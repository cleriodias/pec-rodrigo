<?php

namespace App\Http\Controllers;

use App\Models\ConfiguracaoFiscal;
use App\Models\NotaFiscal;
use App\Models\Unidade;
use App\Models\Venda;
use App\Models\VendaPagamento;
use App\Support\FiscalCertificateService;
use App\Support\FiscalInvoicePreparationService;
use App\Support\FiscalMunicipalityCodeService;
use App\Support\FiscalNfceTransmissionService;
use App\Support\FiscalWebserviceResolverService;
use DOMDocument;
use DOMXPath;
use Illuminate\Http\UploadedFile;
use App\Support\ManagementScope;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;
use RuntimeException;
use Throwable;

class FiscalConfigurationController extends Controller
{
    public function index(
        Request $request,
        FiscalWebserviceResolverService $fiscalWebserviceResolverService,
    ): Response
    {
        $user = $request->user();
        $this->ensureAdmin($user);

        $units = ManagementScope::managedUnits($user, ['tb2_id', 'tb2_nome', 'tb2_cnpj'])
            ->map(fn (Unidade $unit) => [
                'id' => (int) $unit->tb2_id,
                'name' => $unit->tb2_nome,
                'cnpj' => $unit->tb2_cnpj,
            ])
            ->values();

        $selectedUnitId = (int) $request->query('unit_id', (int) ($units->first()['id'] ?? 0));

        if ($selectedUnitId > 0 && ! ManagementScope::canManageUnit($user, $selectedUnitId)) {
            abort(403, 'Acesso negado.');
        }

        if (! $this->fiscalTablesAreAvailable()) {
            return Inertia::render('Settings/FiscalConfig', [
                'units' => $units,
                'selectedUnitId' => $selectedUnitId > 0 ? $selectedUnitId : null,
                'unit' => null,
                'configuration' => [
                    'tb2_id' => $selectedUnitId > 0 ? $selectedUnitId : null,
                    'tb26_emitir_nfe' => false,
                    'tb26_emitir_nfce' => false,
                    'tb26_ambiente' => 'homologacao',
                    'tb26_serie' => '1',
                    'tb26_proximo_numero' => 1,
                    'tb26_crt' => '',
                    'tb26_csc_id' => '',
                    'tb26_csc' => '',
                    'tb26_certificado_tipo' => 'A1',
                    'tb26_certificado_nome' => '',
                    'tb26_certificado_cnpj' => '',
                    'tb26_certificado_arquivo' => '',
                    'tb26_certificado_valido_ate' => '',
                    'tb26_razao_social' => '',
                    'tb26_nome_fantasia' => '',
                    'tb26_ie' => '',
                    'tb26_im' => '',
                    'tb26_cnae' => '',
                    'tb26_logradouro' => '',
                    'tb26_numero' => '',
                    'tb26_complemento' => '',
                    'tb26_bairro' => '',
                    'tb26_codigo_municipio' => '',
                    'tb26_municipio' => '',
                    'tb26_uf' => '',
                    'tb26_cep' => '',
                    'tb26_telefone' => '',
                    'tb26_email' => '',
                    'has_certificate_password' => false,
                ],
                'resolvedEndpoints' => null,
                'invoices' => [],
                'fiscalUnavailableMessage' => 'As tabelas fiscais ainda nao estao disponiveis neste ambiente. Execute as migrations fiscais do deploy antes de usar esta tela.',
            ]);
        }

        $configuration = $selectedUnitId > 0
            ? ConfiguracaoFiscal::query()->where('tb2_id', $selectedUnitId)->first()
            : null;

        $unit = $selectedUnitId > 0
            ? Unidade::query()->find($selectedUnitId)
            : null;

        $invoices = $selectedUnitId > 0
            ? NotaFiscal::query()
                ->where('tb2_id', $selectedUnitId)
                ->with([
                    'pagamento.vendas.unidade:tb2_id,tb2_nome,tb2_endereco,tb2_cnpj',
                    'pagamento.vendas.caixa:id,name',
                    'pagamento.vendas.valeUser:id,name',
                    'configuracaoFiscal:tb26_id,tb26_razao_social,tb26_nome_fantasia,tb26_ie,tb26_logradouro,tb26_numero,tb26_complemento,tb26_bairro,tb26_municipio,tb26_uf,tb26_cep',
                ])
                ->orderByDesc('tb27_id')
                ->limit(15)
                ->get([
                    'tb27_id',
                    'tb4_id',
                    'tb27_modelo',
                    'tb27_ambiente',
                    'tb27_serie',
                    'tb27_numero',
                    'tb27_status',
                    'tb27_mensagem',
                    'tb27_chave_acesso',
                    'tb27_protocolo',
                    'tb27_recibo',
                    'tb27_xml_envio',
                    'tb27_emitida_em',
                    'created_at',
                ])
                ->map(fn (NotaFiscal $invoice) => [
                    'id' => (int) $invoice->tb27_id,
                    'payment_id' => (int) $invoice->tb4_id,
                    'modelo' => $invoice->tb27_modelo,
                    'ambiente' => $invoice->tb27_ambiente,
                    'serie' => $invoice->tb27_serie,
                    'numero' => $invoice->tb27_numero,
                    'status' => $invoice->tb27_status,
                    'mensagem' => $invoice->tb27_mensagem,
                    'chave_acesso' => $invoice->tb27_chave_acesso,
                    'protocolo' => $invoice->tb27_protocolo,
                    'recibo' => $invoice->tb27_recibo,
                    'emitida_em' => optional($invoice->tb27_emitida_em)->format('d/m/y H:i'),
                    'criada_em' => optional($invoice->created_at)->format('d/m/y H:i'),
                    'total' => round((float) ($invoice->pagamento?->valor_total ?? 0), 2),
                    'xml_disponivel' => filled($invoice->tb27_xml_envio),
                    'pode_regenerar' => in_array($invoice->tb27_status, [
                        'pendente_configuracao',
                        'erro_validacao',
                        'erro_transmissao',
                        'pendente_emissao',
                    ], true),
                    'fiscal_receipt' => $invoice->pagamento
                        ? $this->buildFiscalReceiptPayload($invoice)
                        : null,
                ])
                ->values()
            : collect();

        $resolvedEndpoints = null;

        if ($configuration && filled($configuration->tb26_uf) && filled($configuration->tb26_ambiente)) {
            try {
                $resolvedEndpoints = $fiscalWebserviceResolverService->resolveNfceEndpoints(
                    (string) $configuration->tb26_uf,
                    (string) $configuration->tb26_ambiente,
                );
            } catch (RuntimeException $exception) {
                $resolvedEndpoints = [
                    'error' => $exception->getMessage(),
                ];
            }
        }

        return Inertia::render('Settings/FiscalConfig', [
            'units' => $units,
            'selectedUnitId' => $selectedUnitId > 0 ? $selectedUnitId : null,
            'unit' => $unit ? [
                'id' => (int) $unit->tb2_id,
                'name' => $unit->tb2_nome,
                'cnpj' => $unit->tb2_cnpj,
                'endereco' => $unit->tb2_endereco,
                'cnpj_digits' => $this->onlyDigits($unit->tb2_cnpj),
            ] : null,
            'configuration' => [
                'tb2_id' => $selectedUnitId > 0 ? $selectedUnitId : null,
                'tb26_emitir_nfe' => (bool) ($configuration?->tb26_emitir_nfe ?? false),
                'tb26_emitir_nfce' => (bool) ($configuration?->tb26_emitir_nfce ?? false),
                'tb26_ambiente' => $configuration?->tb26_ambiente ?? 'homologacao',
                'tb26_serie' => $configuration?->tb26_serie ?? '1',
                'tb26_proximo_numero' => (int) ($configuration?->tb26_proximo_numero ?? 1),
                'tb26_crt' => $configuration?->tb26_crt ? (string) $configuration->tb26_crt : '',
                'tb26_csc_id' => $configuration?->tb26_csc_id ?? '',
                'tb26_csc' => $configuration?->tb26_csc ?? '',
                'tb26_certificado_tipo' => $configuration?->tb26_certificado_tipo ?? 'A1',
                'tb26_certificado_nome' => $configuration?->tb26_certificado_nome ?? '',
                'tb26_certificado_cnpj' => $configuration?->tb26_certificado_cnpj ?? '',
                'tb26_certificado_arquivo' => $configuration?->tb26_certificado_arquivo ?? '',
                'tb26_certificado_valido_ate' => $configuration?->tb26_certificado_valido_ate
                    ? $configuration->tb26_certificado_valido_ate->format('d/m/y H:i')
                    : '',
                'tb26_razao_social' => $configuration?->tb26_razao_social ?? '',
                'tb26_nome_fantasia' => $configuration?->tb26_nome_fantasia ?? ($unit?->tb2_nome ?? ''),
                'tb26_ie' => $configuration?->tb26_ie ?? '',
                'tb26_im' => $configuration?->tb26_im ?? '',
                'tb26_cnae' => $configuration?->tb26_cnae ?? '',
                'tb26_logradouro' => $configuration?->tb26_logradouro ?? '',
                'tb26_numero' => $configuration?->tb26_numero ?? '',
                'tb26_complemento' => $configuration?->tb26_complemento ?? '',
                'tb26_bairro' => $configuration?->tb26_bairro ?? '',
                'tb26_codigo_municipio' => $configuration?->tb26_codigo_municipio ?? '',
                'tb26_municipio' => $configuration?->tb26_municipio ?? '',
                'tb26_uf' => $configuration?->tb26_uf ?? '',
                'tb26_cep' => $configuration?->tb26_cep ?? '',
                'tb26_telefone' => $configuration?->tb26_telefone ?? '',
                'tb26_email' => $configuration?->tb26_email ?? '',
                'has_certificate_password' => filled($configuration?->tb26_certificado_senha),
            ],
            'resolvedEndpoints' => $resolvedEndpoints,
            'invoices' => $invoices,
            'fiscalUnavailableMessage' => null,
        ]);
    }

    public function update(
        Request $request,
        FiscalCertificateService $fiscalCertificateService,
        FiscalMunicipalityCodeService $fiscalMunicipalityCodeService,
    ): RedirectResponse
    {
        $user = $request->user();
        $this->ensureAdmin($user);

        $data = $request->validate([
            'tb2_id' => ['required', 'integer', 'exists:tb2_unidades,tb2_id'],
            'tb26_emitir_nfe' => ['nullable', 'boolean'],
            'tb26_emitir_nfce' => ['nullable', 'boolean'],
            'tb26_ambiente' => ['required', Rule::in(['homologacao', 'producao'])],
            'tb26_serie' => ['required', 'string', 'max:10'],
            'tb26_proximo_numero' => ['required', 'integer', 'min:1'],
            'tb26_crt' => ['nullable', Rule::in(['1', '2', '3', 1, 2, 3])],
            'tb26_csc_id' => ['nullable', 'string', 'max:36'],
            'tb26_csc' => ['nullable', 'string', 'max:255'],
            'tb26_certificado_tipo' => ['nullable', Rule::in(['A1', 'A3'])],
            'tb26_certificado_nome' => ['nullable', 'string', 'max:255'],
            'tb26_certificado_cnpj' => ['nullable', 'string', 'max:18'],
            'tb26_certificado_arquivo_upload' => [
                'nullable',
                'file',
                'max:5120',
                function (string $attribute, mixed $value, \Closure $fail): void {
                    if (! $value instanceof UploadedFile) {
                        return;
                    }

                    $extension = strtolower((string) ($value->getClientOriginalExtension() ?: $value->extension()));

                    if (! in_array($extension, ['pfx', 'p12'], true)) {
                        $fail('O campo certificado deve ser um arquivo do tipo: pfx, p12.');
                    }
                },
            ],
            'tb26_certificado_senha' => ['nullable', 'string', 'max:255'],
            'remover_certificado' => ['nullable', 'boolean'],
            'tb26_razao_social' => ['nullable', 'string', 'max:255'],
            'tb26_nome_fantasia' => ['nullable', 'string', 'max:255'],
            'tb26_ie' => ['nullable', 'string', 'max:20'],
            'tb26_im' => ['nullable', 'string', 'max:20'],
            'tb26_cnae' => ['nullable', 'string', 'max:10'],
            'tb26_logradouro' => ['nullable', 'string', 'max:255'],
            'tb26_numero' => ['nullable', 'string', 'max:20'],
            'tb26_complemento' => ['nullable', 'string', 'max:255'],
            'tb26_bairro' => ['nullable', 'string', 'max:120'],
            'tb26_codigo_municipio' => ['nullable', 'string', 'max:7'],
            'tb26_municipio' => ['nullable', 'string', 'max:120'],
            'tb26_uf' => ['nullable', 'string', 'size:2'],
            'tb26_cep' => ['nullable', 'string', 'max:8'],
            'tb26_telefone' => ['nullable', 'string', 'max:20'],
            'tb26_email' => ['nullable', 'email', 'max:255'],
        ]);

        $unitId = (int) $data['tb2_id'];

        if (! ManagementScope::canManageUnit($user, $unitId)) {
            abort(403, 'Acesso negado.');
        }

        $unit = Unidade::query()->findOrFail($unitId);

        $configuration = ConfiguracaoFiscal::query()->firstOrNew([
            'tb2_id' => $unitId,
        ]);

        if ($request->boolean('remover_certificado') && filled($configuration->tb26_certificado_arquivo)) {
            Storage::delete($configuration->tb26_certificado_arquivo);
            $configuration->tb26_certificado_arquivo = null;
            $configuration->tb26_certificado_senha = null;
        }

        if ($request->hasFile('tb26_certificado_arquivo_upload')) {
            if (filled($configuration->tb26_certificado_arquivo)) {
                Storage::delete($configuration->tb26_certificado_arquivo);
            }

            $file = $request->file('tb26_certificado_arquivo_upload');
            $password = trim((string) ($data['tb26_certificado_senha'] ?? ''));

            if ($password === '' && ! filled($configuration->tb26_certificado_senha)) {
                throw ValidationException::withMessages([
                    'tb26_certificado_senha' => 'Informe a senha do certificado para validar o arquivo enviado.',
                ]);
            }

            $path = $file->storeAs(
                'fiscal-certificados/' . $unitId,
                'certificado-' . now()->format('YmdHis') . '.' . $file->getClientOriginalExtension()
            );

            $configuration->tb26_certificado_arquivo = $path;

            try {
                $inspection = $fiscalCertificateService->inspectStoredCertificate(
                    $path,
                    $password !== '' ? $password : (string) $configuration->tb26_certificado_senha
                );
            } catch (RuntimeException $exception) {
                Storage::delete($path);
                $configuration->tb26_certificado_arquivo = null;

                throw ValidationException::withMessages([
                    'tb26_certificado_arquivo_upload' => $exception->getMessage(),
                ]);
            }

            $configuration->tb26_certificado_nome = $inspection['common_name'] ?? $configuration->tb26_certificado_nome;
            $configuration->tb26_certificado_cnpj = $inspection['cnpj'] ?? $configuration->tb26_certificado_cnpj;
            $configuration->tb26_certificado_valido_ate = isset($inspection['valid_to'])
                ? now()->setTimestamp((int) $inspection['valid_to'])
                : null;
        }

        $configuration->fill([
            'tb26_emitir_nfe' => (bool) ($data['tb26_emitir_nfe'] ?? false),
            'tb26_emitir_nfce' => (bool) ($data['tb26_emitir_nfce'] ?? false),
            'tb26_ambiente' => $data['tb26_ambiente'],
            'tb26_serie' => trim((string) $data['tb26_serie']),
            'tb26_proximo_numero' => (int) $data['tb26_proximo_numero'],
            'tb26_crt' => filled($data['tb26_crt'] ?? null) ? (int) $data['tb26_crt'] : null,
            'tb26_csc_id' => $this->nullableTrim($data['tb26_csc_id'] ?? null),
            'tb26_csc' => $this->nullableTrim($data['tb26_csc'] ?? null),
            'tb26_certificado_tipo' => $this->nullableTrim($data['tb26_certificado_tipo'] ?? null) ?? 'A1',
            'tb26_certificado_nome' => $this->nullableTrim($data['tb26_certificado_nome'] ?? null) ?? $configuration->tb26_certificado_nome,
            'tb26_certificado_cnpj' => $this->onlyDigits($data['tb26_certificado_cnpj'] ?? null) ?? $configuration->tb26_certificado_cnpj,
            'tb26_certificado_valido_ate' => $configuration->tb26_certificado_valido_ate,
            'tb26_razao_social' => $this->nullableTrim($data['tb26_razao_social'] ?? null),
            'tb26_nome_fantasia' => $this->nullableTrim($data['tb26_nome_fantasia'] ?? null),
            'tb26_ie' => $this->normalizeStateRegistration($data['tb26_ie'] ?? null),
            'tb26_im' => $this->nullableTrim($data['tb26_im'] ?? null),
            'tb26_cnae' => $this->onlyDigits($data['tb26_cnae'] ?? null),
            'tb26_logradouro' => $this->nullableTrim($data['tb26_logradouro'] ?? null),
            'tb26_numero' => $this->nullableTrim($data['tb26_numero'] ?? null),
            'tb26_complemento' => $this->nullableTrim($data['tb26_complemento'] ?? null),
            'tb26_bairro' => $this->nullableTrim($data['tb26_bairro'] ?? null),
            'tb26_codigo_municipio' => $this->onlyDigits($data['tb26_codigo_municipio'] ?? null),
            'tb26_municipio' => $this->nullableTrim($data['tb26_municipio'] ?? null),
            'tb26_uf' => strtoupper((string) ($data['tb26_uf'] ?? '')),
            'tb26_cep' => $this->onlyDigits($data['tb26_cep'] ?? null),
            'tb26_telefone' => $this->nullableTrim($data['tb26_telefone'] ?? null),
            'tb26_email' => $this->nullableTrim($data['tb26_email'] ?? null),
        ]);

        if ($request->filled('tb26_certificado_senha')) {
            $configuration->tb26_certificado_senha = $data['tb26_certificado_senha'];
        }

        $this->ensureCertificateMatchesUnit($configuration, $unit);
        $this->ensureMunicipalityCodeMatchesUf($configuration, $fiscalMunicipalityCodeService);

        $configuration->save();

        return redirect()
            ->route('settings.fiscal', ['unit_id' => $unitId])
            ->with('success', 'Configuracao fiscal atualizada com sucesso.');
    }

    public function reprocess(
        Request $request,
        FiscalInvoicePreparationService $fiscalInvoicePreparationService,
    ): RedirectResponse {
        $user = $request->user();
        $this->ensureAdmin($user);

        $data = $request->validate([
            'tb2_id' => ['required', 'integer', 'exists:tb2_unidades,tb2_id'],
        ]);

        $unitId = (int) $data['tb2_id'];

        if (! ManagementScope::canManageUnit($user, $unitId)) {
            abort(403, 'Acesso negado.');
        }

        $count = $fiscalInvoicePreparationService->reprocessPendingInvoicesForUnit($unitId);

        return redirect()
            ->route('settings.fiscal', ['unit_id' => $unitId])
            ->with('success', sprintf('%d nota(s) fiscal(is) reprocessada(s) para a loja selecionada.', $count));
    }

    public function regenerateInvoice(
        Request $request,
        NotaFiscal $notaFiscal,
        FiscalInvoicePreparationService $fiscalInvoicePreparationService,
    ): RedirectResponse {
        $user = $request->user();
        $this->ensureAdmin($user);

        if (! ManagementScope::canManageUnit($user, (int) $notaFiscal->tb2_id)) {
            abort(403, 'Acesso negado.');
        }

        $notaFiscal->loadMissing('pagamento.vendas.produto', 'pagamento.vendas.unidade');

        if (! $notaFiscal->pagamento) {
            return redirect()
                ->route('settings.fiscal', ['unit_id' => $notaFiscal->tb2_id])
                ->with('error', 'Nao foi encontrado o pagamento vinculado a esta nota fiscal.');
        }

        $invoice = $fiscalInvoicePreparationService->prepareForPayment($notaFiscal->pagamento);

        return redirect()
            ->route('settings.fiscal', ['unit_id' => $notaFiscal->tb2_id])
            ->with('success', sprintf(
                'Nota fiscal da venda %d regenerada com status %s.',
                (int) $notaFiscal->tb4_id,
                $invoice?->tb27_status ?? 'indefinido'
            ));
    }

    public function downloadXml(Request $request, NotaFiscal $notaFiscal)
    {
        $user = $request->user();
        $this->ensureAdmin($user);

        if (! ManagementScope::canManageUnit($user, (int) $notaFiscal->tb2_id)) {
            abort(403, 'Acesso negado.');
        }

        if (! filled($notaFiscal->tb27_xml_envio)) {
            abort(404, 'Nao existe XML assinado para esta nota.');
        }

        $filename = sprintf('nfce-loja-%d-venda-%d.xml', (int) $notaFiscal->tb2_id, (int) $notaFiscal->tb4_id);

        return response($notaFiscal->tb27_xml_envio, 200, [
            'Content-Type' => 'application/xml; charset=UTF-8',
            'Content-Disposition' => 'attachment; filename="' . $filename . '"',
        ]);
    }

    public function transmit(
        Request $request,
        NotaFiscal $notaFiscal,
        FiscalNfceTransmissionService $fiscalNfceTransmissionService,
    ): RedirectResponse {
        $user = $request->user();
        $this->ensureAdmin($user);

        if (! ManagementScope::canManageUnit($user, (int) $notaFiscal->tb2_id)) {
            abort(403, 'Acesso negado.');
        }

        try {
            $fiscalNfceTransmissionService->transmit($notaFiscal);
        } catch (RuntimeException $exception) {
            return redirect()
                ->route('settings.fiscal', ['unit_id' => $notaFiscal->tb2_id])
                ->with('error', $exception->getMessage());
        }

        return redirect()
            ->route('settings.fiscal', ['unit_id' => $notaFiscal->tb2_id])
            ->with('success', sprintf('Nota fiscal da venda %d enviada para a SEFAZ.', (int) $notaFiscal->tb4_id));
    }

    private function ensureAdmin($user): void
    {
        if (! $user || ! in_array((int) $user->funcao, [0, 1], true)) {
            abort(403, 'Acesso negado.');
        }
    }

    private function nullableTrim(?string $value): ?string
    {
        $value = trim((string) $value);

        return $value === '' ? null : $value;
    }

    private function onlyDigits(?string $value): ?string
    {
        $value = preg_replace('/\D+/', '', (string) $value);

        return $value === '' ? null : $value;
    }

    private function normalizeStateRegistration(?string $value): ?string
    {
        $value = strtoupper(trim((string) $value));

        if ($value === '') {
            return null;
        }

        if ($value === 'ISENTO') {
            return 'ISENTO';
        }

        return $this->onlyDigits($value);
    }

    private function ensureCertificateMatchesUnit(ConfiguracaoFiscal $configuration, Unidade $unit): void
    {
        $certificateCnpj = $this->onlyDigits($configuration->tb26_certificado_cnpj);
        $unitCnpj = $this->onlyDigits($unit->tb2_cnpj);

        if (! $certificateCnpj || ! $unitCnpj) {
            return;
        }

        $unitBase = substr($unitCnpj, 0, 8);
        $certificateBase = substr($certificateCnpj, 0, 8);

        if ($unitBase !== $certificateBase) {
            throw ValidationException::withMessages([
                'tb26_certificado_cnpj' => 'O certificado informado nao pertence ao mesmo CNPJ base da loja selecionada.',
            ]);
        }
    }

    private function ensureMunicipalityCodeMatchesUf(
        ConfiguracaoFiscal $configuration,
        FiscalMunicipalityCodeService $fiscalMunicipalityCodeService,
    ): void {
        if (! filled($configuration->tb26_uf) || ! filled($configuration->tb26_codigo_municipio)) {
            return;
        }

        if ($fiscalMunicipalityCodeService->matchesUf($configuration->tb26_uf, $configuration->tb26_codigo_municipio)) {
            return;
        }

        $expectedPrefix = $fiscalMunicipalityCodeService->expectedPrefixForUf($configuration->tb26_uf);

        throw ValidationException::withMessages([
            'tb26_codigo_municipio' => sprintf(
                'O codigo do municipio IBGE %s nao pertence a UF %s. Use um codigo iniciado por %s.',
                (string) $configuration->tb26_codigo_municipio,
                (string) $configuration->tb26_uf,
                $expectedPrefix ?? '--'
            ),
        ]);
    }

    private function buildReceiptPayload(VendaPagamento $payment): array
    {
        $sales = $payment->vendas->values();
        $firstSale = $sales->first();
        $saleDateTime = $firstSale?->data_hora ?? $payment->created_at;
        $receiptComanda = $this->resolveReceiptComanda($sales);

        return [
            'id' => $payment->tb4_id,
            'comanda' => $receiptComanda,
            'total' => round((float) $payment->valor_total, 2),
            'date_time' => $saleDateTime?->toIso8601String(),
            'tipo_pago' => $payment->tipo_pagamento,
            'cashier_name' => $firstSale?->caixa?->name ?? '---',
            'unit_name' => $firstSale?->unidade?->tb2_nome ?? '---',
            'unit_address' => $firstSale?->unidade?->tb2_endereco,
            'unit_cnpj' => $firstSale?->unidade?->tb2_cnpj,
            'vale_user_name' => $firstSale?->valeUser?->name,
            'vale_type' => in_array($payment->tipo_pagamento, ['vale', 'refeicao'], true)
                ? $payment->tipo_pagamento
                : null,
            'payment' => [
                'id' => $payment->tb4_id,
                'valor_total' => round((float) $payment->valor_total, 2),
                'valor_pago' => $payment->valor_pago !== null ? round((float) $payment->valor_pago, 2) : null,
                'troco' => $payment->troco !== null ? round((float) $payment->troco, 2) : null,
                'dois_pgto' => $payment->dois_pgto !== null ? round((float) $payment->dois_pgto, 2) : null,
            ],
            'items' => $sales
                ->map(fn (Venda $sale) => [
                    'id' => $sale->tb3_id,
                    'product_name' => $sale->produto_nome,
                    'quantity' => (int) $sale->quantidade,
                    'unit_price' => round((float) $sale->valor_unitario, 2),
                    'subtotal' => round((float) $sale->valor_total, 2),
                    'comanda' => $sale->id_comanda,
                ])
                ->values()
                ->all(),
        ];
    }

    private function resolveReceiptComanda($sales): ?string
    {
        $comanda = $sales
            ->pluck('id_comanda')
            ->filter(fn ($value) => $value !== null && $value !== '')
            ->unique()
            ->implode(', ');

        return $comanda !== '' ? $comanda : null;
    }

    private function buildFiscalReceiptPayload(NotaFiscal $invoice): ?array
    {
        $payment = $invoice->pagamento;

        if (! $payment) {
            return null;
        }

        $sales = $payment->vendas->values();
        $firstSale = $sales->first();
        $configuration = $invoice->configuracaoFiscal;
        $xmlData = $this->extractFiscalReceiptXmlData($invoice->tb27_xml_envio);
        $issueDateTime = $invoice->tb27_emitida_em ?? $firstSale?->data_hora ?? $invoice->created_at;
        $emitterName = $configuration?->tb26_nome_fantasia
            ?: $configuration?->tb26_razao_social
            ?: $firstSale?->unidade?->tb2_nome
            ?: 'EMITENTE NAO INFORMADO';

        return [
            'title' => strtolower((string) $invoice->tb27_modelo) === 'nfce' ? 'DANFE NFC-e' : 'Documento fiscal',
            'subtitle' => 'Documento auxiliar da nota fiscal eletronica para impressao em 80mm',
            'payment_id' => (int) $invoice->tb4_id,
            'invoice_id' => (int) $invoice->tb27_id,
            'model_label' => strtoupper((string) $invoice->tb27_modelo) === 'NFCE' ? 'NFC-e' : strtoupper((string) $invoice->tb27_modelo),
            'environment' => $invoice->tb27_ambiente === 'producao' ? 'Producao' : 'Homologacao',
            'serie' => $invoice->tb27_serie,
            'number' => $invoice->tb27_numero,
            'status' => $invoice->tb27_status,
            'status_message' => $invoice->tb27_mensagem,
            'issued_at' => $issueDateTime?->toIso8601String(),
            'emitter_name' => $emitterName,
            'emitter_legal_name' => $configuration?->tb26_razao_social,
            'emitter_document' => $firstSale?->unidade?->tb2_cnpj,
            'emitter_ie' => $configuration?->tb26_ie,
            'emitter_address' => $this->buildEmitterAddress($configuration),
            'consumer_name' => 'CONSUMIDOR NAO IDENTIFICADO',
            'payment_label' => $this->resolvePaymentLabel($payment->tipo_pagamento),
            'total' => round((float) $payment->valor_total, 2),
            'amount_paid' => $payment->valor_pago !== null ? round((float) $payment->valor_pago, 2) : null,
            'change' => $payment->troco !== null ? round((float) $payment->troco, 2) : null,
            'additional_payment' => $payment->dois_pgto !== null ? round((float) $payment->dois_pgto, 2) : null,
            'access_key' => $invoice->tb27_chave_acesso ?: ($xmlData['access_key'] ?? null),
            'protocol' => $invoice->tb27_protocolo,
            'receipt' => $invoice->tb27_recibo,
            'consulta_url' => $xmlData['consulta_url'] ?? null,
            'qr_code_data' => $xmlData['qr_code_data'] ?? null,
            'is_preview' => $invoice->tb27_status !== 'emitida',
            'items' => $sales
                ->map(fn (Venda $sale) => [
                    'id' => $sale->tb3_id,
                    'product_name' => $sale->produto_nome,
                    'quantity' => (float) $sale->quantidade,
                    'unit_price' => round((float) $sale->valor_unitario, 2),
                    'subtotal' => round((float) $sale->valor_total, 2),
                ])
                ->values()
                ->all(),
        ];
    }

    private function buildEmitterAddress(?ConfiguracaoFiscal $configuration): ?string
    {
        if (! $configuration) {
            return null;
        }

        $lineOne = trim(implode(', ', array_filter([
            $configuration->tb26_logradouro,
            $configuration->tb26_numero,
            $configuration->tb26_complemento,
        ])));

        $lineTwo = trim(implode(' - ', array_filter([
            $configuration->tb26_bairro,
            trim(implode('/', array_filter([
                $configuration->tb26_municipio,
                $configuration->tb26_uf,
            ]))),
        ])));

        $parts = array_filter([
            $lineOne,
            $lineTwo,
            $configuration->tb26_cep ? 'CEP ' . $configuration->tb26_cep : null,
        ]);

        if ($parts === []) {
            return null;
        }

        return implode(' | ', $parts);
    }

    private function extractFiscalReceiptXmlData(?string $xml): array
    {
        if (! filled($xml)) {
            return [];
        }

        $document = new DOMDocument();

        if (! @$document->loadXML((string) $xml)) {
            return [];
        }

        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('nfe', 'http://www.portalfiscal.inf.br/nfe');

        return [
            'access_key' => $this->stringOrNull($xpath->evaluate('string(//nfe:infNFe/@Id)'))
                ? preg_replace('/^NFe/', '', (string) $xpath->evaluate('string(//nfe:infNFe/@Id)'))
                : null,
            'qr_code_data' => $this->stringOrNull($xpath->evaluate('string(//nfe:infNFeSupl/nfe:qrCode)')),
            'consulta_url' => $this->stringOrNull($xpath->evaluate('string(//nfe:infNFeSupl/nfe:urlChave)')),
        ];
    }

    private function stringOrNull(mixed $value): ?string
    {
        $value = trim((string) $value);

        return $value !== '' ? $value : null;
    }

    private function resolvePaymentLabel(?string $paymentType): string
    {
        return match ((string) $paymentType) {
            'dinheiro' => 'Dinheiro',
            'maquina' => 'Maquina',
            'vale' => 'Vale',
            'refeicao' => 'Refeicao',
            'faturar' => 'Faturar',
            default => strtoupper(str_replace('_', ' ', trim((string) $paymentType))) ?: 'Nao informado',
        };
    }

    private function fiscalTablesAreAvailable(): bool
    {
        try {
            return Schema::hasTable('tb26_configuracoes_fiscais')
                && Schema::hasTable('tb27_notas_fiscais');
        } catch (Throwable) {
            return false;
        }
    }
}
