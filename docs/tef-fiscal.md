# Implementacao fiscal TEF

Documento da implementacao realizada em 30/07/2026 para preparar o sistema para pagamentos eletronicos integrados a NFC-e.

## Contexto legal usado

A fonte inicial foi o artigo da Nox sobre TEF obrigatorio em Goias:

- https://nox.com.br/tef-obrigatorio-goias

Durante a implementacao foi conferida a norma atual de Goias:

- IN 1608/2025-GSE: https://appasp.economia.go.gov.br/legislacao/arquivos/Secretario/IN/IN_1608_2025.htm
- Noticia SEFAZ-GO de 27/02/2026 sobre novo prazo: https://agencia.go.gov.br/integracao-entre-meios-de-pagamento-e-documento-fiscal-tem-novo-prazo/
- Noticia SEFAZ-GO de 01/06/2026 sobre inicio para grandes empresas: https://agencia.go.gov.br/integracao-dos-meios-de-pagamento-passa-a-valer-para-grandes-empresas/

Observacao importante: a obrigacao em Goias e a integracao entre o meio de pagamento e o documento fiscal, nao necessariamente uma tecnologia TEF especifica. Por isso a implementacao foi feita para receber retorno de TEF, SmartPOS ou outro integrador equivalente, desde que informe os dados fiscais necessarios do pagamento eletronico.

## Objetivo da implementacao

Permitir que a venda grave os dados do pagamento eletronico integrado e que o XML da NFC-e informe o grupo de cartao/pagamento com `tpIntegra=1` quando houver retorno TEF.

Sem retorno TEF, o comportamento anterior continua preservado:

- cartao, Pix e maquina continuam gerando o grupo de pagamento;
- o XML continua usando `tpIntegra=2`;
- a venda nao quebra em lojas que ainda nao ativaram a exigencia de TEF integrado.

## Arquivos alterados

- `database/migrations/2026_07_30_200000_add_tef_fields_to_fiscal_configuration_and_payments.php`
- `app/Models/VendaPagamento.php`
- `app/Models/ConfiguracaoFiscal.php`
- `app/Http/Controllers/SaleController.php`
- `app/Http/Controllers/FiscalConfigurationController.php`
- `app/Support/FiscalInvoicePreparationService.php`
- `app/Support/FiscalNfceXmlService.php`
- `resources/js/Pages/Settings/FiscalConfig.jsx`
- `tests/Feature/SaleCardPaymentTypesTest.php`
- `tests/Unit/FiscalInvoicePreparationServiceTest.php`
- `tests/Unit/FiscalNfceXmlServiceTest.php`

## Banco de dados

A migration adiciona em `tb26_configuracoes_fiscais`:

- `tb26_exigir_tef_integrado`: flag por unidade para obrigar TEF integrado em cartao, Pix e pagamento misto com complemento eletronico.

A migration adiciona em `tb4_vendas_pg`:

- `tef_integrado`: indica que a venda veio de integracao TEF.
- `tef_autorizacao`: codigo de autorizacao ou identificacao do pedido retornado pelo integrador.
- `tef_cnpj_credenciadora`: CNPJ da credenciadora, subcredenciadora ou intermediador.
- `tef_bandeira`: codigo de bandeira usado no XML fiscal.
- `tef_terminal`: identificacao do terminal ou pinpad.
- `tef_transacao_em`: data/hora da transacao retornada pelo integrador.
- `tef_payload`: payload bruto complementar para auditoria e diagnostico.

## Configuracao fiscal por unidade

Na tela `Configuracao fiscal`, foi criado o toggle `Exigir TEF integrado`.

Quando desligado:

- vendas em cartao/Pix continuam aceitas mesmo sem retorno TEF;
- NFC-e de pagamento eletronico sem retorno TEF continua com `tpIntegra=2`.

Quando ligado:

- cartao, Pix, `maquina`, `dinheiro_cartao_credito`, `dinheiro_cartao_debito` e `dinheiro_pix` exigem retorno TEF;
- se a venda nao tiver retorno TEF, a nota fica com erro de validacao fiscal;
- a mensagem exibida e: `A configuracao fiscal desta loja exige TEF integrado para cartao, Pix e pagamentos mistos com complemento eletronico.`

Essa flag ficou por unidade porque o enquadramento de obrigatoriedade depende do cronograma fiscal da empresa/unidade e nao deve ser inferido automaticamente apenas pelo estado.

## Payload esperado na venda

O endpoint de venda `sales.store` passa a aceitar o objeto opcional `tef`.

Exemplo:

```json
{
  "tipo_pago": "cartao_debito",
  "items": [
    {
      "product_id": 10,
      "quantity": 1
    }
  ],
  "tef": {
    "integrado": true,
    "autorizacao": "ABC123",
    "cnpj_credenciadora": "12.345.678/0001-95",
    "bandeira": "mastercard",
    "terminal": "PINPAD-01",
    "transacao_em": "2026-07-30 20:10:00",
    "payload": {
      "nsu": "999888"
    }
  }
}
```

Campos aceitos:

- `tef.integrado`: booleano. Precisa ser `true` para ativar o tratamento TEF.
- `tef.autorizacao`: obrigatorio quando integrado. Maximo de 20 caracteres.
- `tef.cnpj_credenciadora`: obrigatorio quando integrado. Pode vir com mascara; o sistema salva apenas digitos.
- `tef.bandeira`: obrigatorio para cartao. Pode vir como codigo ou nome.
- `tef.terminal`: opcional.
- `tef.transacao_em`: opcional, em formato de data aceito pelo Laravel.
- `tef.payload`: opcional, objeto JSON com dados adicionais retornados pelo provedor.

## Normalizacao de bandeira

O controller normaliza nomes comuns para os codigos usados no XML:

- `visa` -> `01`
- `mastercard`, `master`, `master card` -> `02`
- `american express`, `amex` -> `03`
- `sorocred` -> `04`
- `diners club`, `diners` -> `05`
- `elo` -> `06`
- `hipercard` -> `07`
- `aura` -> `08`
- `cabal` -> `09`
- outros nomes -> `99`

Se o integrador ja enviar `01`, `02`, etc., o sistema preserva o codigo com dois digitos.

## Geracao do XML NFC-e

Antes da mudanca, pagamentos eletronicos eram declarados como nao integrados:

```xml
<card>
  <tpIntegra>2</tpIntegra>
</card>
```

Com retorno TEF, o XML passa a enviar:

```xml
<card>
  <tpIntegra>1</tpIntegra>
  <CNPJ>12345678000195</CNPJ>
  <tBand>02</tBand>
  <cAut>ABC123</cAut>
</card>
```

Tambem foi adicionada informacao complementar no `infCpl`, incluindo autorizacao e terminal quando disponiveis.

## Validacoes adicionadas

No fechamento da venda:

- `tef.integrado=true` so e aceito para cartao, Pix, maquina e pagamentos mistos com complemento eletronico.
- autorizacao e CNPJ da credenciadora sao obrigatorios quando integrado.
- bandeira e obrigatoria para pagamentos de cartao.
- CNPJ e salvo apenas com digitos.

Na preparacao fiscal:

- se a unidade exige TEF integrado, pagamentos eletronicos sem retorno TEF geram erro de validacao.
- se `tef_integrado=true`, o fiscal valida autorizacao, CNPJ e bandeira antes de tentar assinar XML.

## Testes executados

Comandos executados apos a implementacao:

```bash
php artisan test tests\Unit\FiscalNfceXmlServiceTest.php tests\Unit\FiscalInvoicePreparationServiceTest.php tests\Feature\SaleCardPaymentTypesTest.php
npm.cmd run build
```

Resultado da bateria focada:

- 31 testes passaram.
- 4 testes foram ignorados por limitacao local de OpenSSL para certificado temporario, comportamento ja existente.
- O build Vite passou.

## Ponto de integracao pendente

Esta implementacao nao instala um provedor TEF especifico. O proximo passo e plugar o retorno do provedor escolhido no PDV para chamar `sales.store` com o objeto `tef`.

O sistema esta pronto para receber os dados; ainda falta escolher e implementar o fluxo operacional do adquirente/TEF/SmartPOS:

- iniciar transacao no provedor;
- aguardar autorizacao;
- receber CNPJ da credenciadora/intermediador, autorizacao, bandeira, terminal e NSU;
- enviar esses dados no objeto `tef`;
- confirmar/cancelar a transacao no provedor conforme sucesso ou erro da venda.
