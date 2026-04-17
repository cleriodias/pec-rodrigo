<?php

namespace App\Support;

use App\Models\ConfiguracaoFiscal;
use RuntimeException;
use Illuminate\Support\Facades\Storage;

class FiscalCertificateService
{
    public function inspectStoredCertificate(string $storagePath, string $password): array
    {
        $absolutePath = $this->resolveStorageAbsolutePath($storagePath);

        if ($absolutePath === null) {
            throw new RuntimeException(sprintf(
                'Arquivo do certificado nao encontrado no armazenamento local. Caminho fiscal salvo: %s.',
                trim((string) $storagePath) !== '' ? trim((string) $storagePath) : 'nao informado'
            ));
        }

        return $this->inspectCertificateFile($absolutePath, $password);
    }

    public function loadCertificateForConfiguration(ConfiguracaoFiscal $configuration): array
    {
        $storagePath = trim((string) $configuration->tb26_certificado_arquivo);
        $password = (string) ($configuration->tb26_certificado_senha ?? '');

        if ($storagePath === '') {
            throw new RuntimeException('Nenhum arquivo de certificado foi configurado para esta loja.');
        }

        if ($password === '') {
            throw new RuntimeException('A senha do certificado da loja nao foi configurada.');
        }

        return $this->inspectStoredCertificate($storagePath, $password);
    }

    public function inspectCertificateFile(string $absolutePath, string $password): array
    {
        $content = @file_get_contents($absolutePath);

        if ($content === false) {
            throw new RuntimeException('Nao foi possivel ler o arquivo do certificado.');
        }

        $certificates = [];

        if (! openssl_pkcs12_read($content, $certificates, $password)) {
            throw new RuntimeException('Nao foi possivel abrir o certificado A1. Verifique o arquivo e a senha informada.');
        }

        $certificatePem = (string) ($certificates['cert'] ?? '');
        $privateKeyPem = (string) ($certificates['pkey'] ?? '');

        if ($certificatePem === '' || $privateKeyPem === '') {
            throw new RuntimeException('O certificado informado nao contem os dados necessarios para assinatura.');
        }

        $parsed = openssl_x509_parse($certificatePem);

        if (! is_array($parsed)) {
            throw new RuntimeException('Nao foi possivel interpretar os dados do certificado.');
        }

        $commonName = $this->extractCertificateName($parsed);
        $document = $this->extractCertificateCnpj($parsed);

        return [
            'certificate_pem' => $certificatePem,
            'private_key_pem' => $privateKeyPem,
            'public_certificate_base64' => $this->normalizeCertificateForXml($certificatePem),
            'common_name' => $commonName,
            'cnpj' => $document,
            'serial' => trim((string) ($parsed['serialNumber'] ?? '')),
            'valid_from' => $parsed['validFrom_time_t'] ?? null,
            'valid_to' => $parsed['validTo_time_t'] ?? null,
            'subject' => $parsed['subject'] ?? [],
            'issuer' => $parsed['issuer'] ?? [],
        ];
    }

    public function extractCertificateName(array $parsedCertificate): ?string
    {
        $subject = $parsedCertificate['subject'] ?? [];

        $candidates = [
            $subject['CN'] ?? null,
            $subject['commonName'] ?? null,
            $parsedCertificate['name'] ?? null,
        ];

        foreach ($candidates as $candidate) {
            $value = trim((string) $candidate);

            if ($value !== '') {
                return $value;
            }
        }

        return null;
    }

    public function extractCertificateCnpj(array $parsedCertificate): ?string
    {
        $subject = $parsedCertificate['subject'] ?? [];
        $extensions = $parsedCertificate['extensions'] ?? [];

        $candidates = [
            $subject['serialNumber'] ?? null,
            $subject['serialnumber'] ?? null,
            $parsedCertificate['name'] ?? null,
            $extensions['subjectAltName'] ?? null,
        ];

        foreach ($candidates as $candidate) {
            $digits = $this->extractFourteenDigits($candidate);

            if ($digits !== null) {
                return $digits;
            }
        }

        return null;
    }

    private function normalizeCertificateForXml(string $certificatePem): string
    {
        $normalized = str_replace([
            '-----BEGIN CERTIFICATE-----',
            '-----END CERTIFICATE-----',
            "\r",
            "\n",
        ], '', $certificatePem);

        return trim($normalized);
    }

    private function resolveStorageAbsolutePath(string $storagePath): ?string
    {
        foreach ($this->resolveStorageCandidates($storagePath) as $candidate) {
            $absolutePath = Storage::path($candidate);

            if (is_file($absolutePath)) {
                return $absolutePath;
            }
        }

        return null;
    }

    private function resolveStorageCandidates(string $storagePath): array
    {
        $normalized = ltrim(trim($storagePath), '/\\');

        if ($normalized === '') {
            return [];
        }

        $candidates = [$normalized];

        if (str_starts_with($normalized, 'private/')) {
            $candidates[] = substr($normalized, strlen('private/'));
        } else {
            $candidates[] = 'private/' . $normalized;
        }

        return array_values(array_unique(array_filter($candidates)));
    }

    private function extractFourteenDigits(mixed $value): ?string
    {
        $rawValue = (string) $value;
        $tailMatch = [];

        if (preg_match('/(\d{14})(?!.*\d)/', $rawValue, $tailMatch)) {
            return $tailMatch[1];
        }

        $digits = preg_replace('/\D+/', '', $rawValue);

        if ($digits === '') {
            return null;
        }

        if (strlen($digits) === 14) {
            return $digits;
        }

        if (strlen($digits) > 14) {
            preg_match_all('/\d{14}/', $digits, $matches);

            foreach ($matches[0] ?? [] as $candidate) {
                return $candidate;
            }
        }

        return null;
    }
}
