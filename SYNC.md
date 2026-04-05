# 2026-04-05

## Atalho de Vales no endpoint reports/cash-discrepancies

- Arquivos alterados:
  - `resources/js/Pages/Reports/CashDiscrepancies.jsx`
- Problema corrigido:
  - a tela `reports/cash-discrepancies` exibia o botao `Vales` no cabecalho sem funcionar como atalho direto para `Ferramentas > Relatorios > Vales`.
- Causa real:
  - o cabecalho da pagina nao tinha link configurado para a rota `reports.vale`;
  - a tela de discrepancias estava sem integracao direta com o relatorio de vales.
- Comportamento novo:
  - o botao `Vales` do cabecalho agora abre o relatorio `reports/vale`;
  - o atalho ja envia a mesma `data` selecionada na tela como `start_date` e `end_date`;
  - o atalho tambem envia a `unit_id` atual, preservando o contexto da loja quando houver filtro aplicado.
- Impacto na sincronizacao com `pec1`:
  - replicar o link do cabecalho em `resources/js/Pages/Reports/CashDiscrepancies.jsx`;
  - importar `Link` de `@inertiajs/react` nessa pagina, se ainda nao estiver importado;
  - enviar no atalho os parametros `start_date`, `end_date` e `unit_id` para a rota `reports.vale`.

## Botao Imprimir Vales no endpoint reports/vale

- Arquivos alterados:
  - `resources/js/Pages/Reports/Vale.jsx`
- Problema corrigido:
  - a tela `reports/vale` permitia abrir e imprimir apenas o cupom detalhado de cada compra individual;
  - faltava uma impressao resumida da listagem de compras no vale.
- Causa real:
  - o frontend so tinha acao por linha usando o cupom detalhado;
  - nao existia gerador de impressao consolidada para a secao `Compras no vale`.
- Comportamento novo:
  - a tela agora mostra o botao `Imprimir Vales`;
  - o botao gera uma impressao resumida em formato de cupom com o titulo `Compras no vale`;
  - a impressao lista `ID`, `Data/Hora`, nome do funcionario do vale e `Valor` de cada compra;
  - o cupom tambem mostra a data/hora corrente da impressao;
  - ao final, o cupom mostra o `Total` geral do periodo filtrado.
- Impacto na sincronizacao com `pec1`:
  - replicar o botao `Imprimir Vales` em `resources/js/Pages/Reports/Vale.jsx`;
  - replicar o gerador HTML resumido da listagem com os campos `ID`, `Data/Hora`, nome do funcionario, `Valor` e `Total`;
  - replicar a exibicao da data/hora corrente da impressao.

## Regras de editar e excluir mensagens nao lidas no endpoint on-line

- Arquivos alterados:
  - `app/Http/Controllers/OnlineController.php`
  - `resources/js/Pages/Online/Index.jsx`
  - `routes/web.php`
  - `tests/Feature/OnlineFeatureTest.php`
- Problema corrigido:
  - no endpoint `on-line`, a modal de editar podia abrir para mensagens ja lidas;
  - tambem nao existia uma forma de excluir mensagens ainda nao lidas.
- Causa real:
  - o clique na propria mensagem dependia apenas de `is_mine`;
  - o backend aceitava edicao mesmo quando `read_at` ja estava preenchido;
  - nao havia rota nem acao para exclusao da mensagem antes da leitura.
- Comportamento novo:
  - editar agora so e possivel para mensagens proprias ainda nao lidas;
  - mensagens ja lidas deixam de abrir a modal;
  - a modal ganhou o botao `Excluir`, exibido apenas quando a mensagem ainda nao foi lida;
  - a exclusao remove apenas mensagens proprias com `read_at = null`;
  - o backend tambem bloqueia edicao e exclusao manual de mensagens lidas.
- Testes adicionados:
  - cobertura para permitir editar somente mensagem nao lida;
  - cobertura para permitir excluir somente mensagem nao lida.
- Impacto na sincronizacao com `pec1`:
  - replicar a nova rota `DELETE /on-line/messages/{message}`;
  - replicar os bloqueios de `read_at` no `OnlineController`;
  - replicar na tela `resources/js/Pages/Online/Index.jsx` a abertura da modal e o botao `Excluir` apenas para mensagens nao lidas.

## Ajustes no endpoint reports/cash-discrepancies

- Arquivos alterados:
  - `resources/js/Pages/Reports/CashDiscrepancies.jsx`
- Problema corrigido:
  - a tela ainda mostrava ano com 4 digitos;
  - o modal `Detalhar` ficava estreito;
  - o card `Total discrepancia` somava tambem os caixas com sobra;
  - faltava um card separado para as sobras;
  - faltava uma linha final com os totais de todas as colunas.
- Causa real:
  - a formatacao local da pagina usava ano completo;
  - o modal estava configurado com largura `md`;
  - o acumulado de discrepancia somava positivos e negativos juntos;
  - a grade principal nao tinha agregacao final.
- Comportamento novo:
  - todas as datas exibidas na pagina agora usam ano com 2 digitos;
  - o modal `Detalhar` foi ampliado para `2xl`;
  - o card `Total discrepancia` agora soma apenas os caixas com falta de dinheiro;
  - foi criado um card verde `Total sobra` com a soma das discrepancias negativas em valor absoluto;
  - a tabela principal agora tem uma linha `Total geral` com a soma de discrepancia e de todas as colunas de pagamento.
- Impacto na sincronizacao com `pec1`:
  - replicar os ajustes em `resources/js/Pages/Reports/CashDiscrepancies.jsx`;
  - manter o card `Total discrepancia` somente com faltas;
  - incluir o card `Total sobra`;
  - incluir a linha `Total geral` na tabela;
  - replicar a formatacao de datas com ano de 2 digitos e o modal mais largo.

# 2026-04-04

## Master Confere no endpoint reports/cash-closure

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `app/Models/CashierClosure.php`
  - `database/migrations/2026_04_04_120000_add_master_review_fields_to_cashier_closures_table.php`
  - `resources/js/Pages/Reports/CashClosure.jsx`
  - `routes/web.php`
  - `tests/Feature/CashClosureMasterReviewTest.php`
- Problema corrigido:
  - o relatorio `reports/cash-closure` mostrava apenas os valores originais fechados pelo caixa e nao permitia uma segunda conferencia do `Master`;
  - o card `Base da conferencia` ficava misturado no bloco de resumo, em vez de acompanhar os filtros no topo.
- Causa real:
  - a tabela `cashier_closures` nao tinha campos separados para a revisao do `Master`;
  - o backend so carregava `cash_amount` e `card_amount` originais;
  - o frontend nao tinha acao de edicao nem modal para a segunda conferencia.
- Comportamento novo:
  - quando o fechamento existir, o `Master (0)` passa a ver o botao `Master Confere` ao lado do status;
  - esse botao abre um modal para editar dinheiro e cartao na segunda conferencia;
  - o relatorio passa a usar os valores revisados pelo `Master` como base efetiva de conferencia, preservando os valores originais do caixa;
  - a tela mostra quem fez a conferencia do `Master` e quando ela ocorreu;
  - o card `Base da conferencia` foi movido para o topo, ao lado dos filtros, como no layout solicitado.
- Testes adicionados:
  - cobertura para atualizar a conferencia do `Master`;
  - cobertura para garantir que o relatorio usa os valores revisados quando existirem.
- Impacto na sincronizacao com `pec1`:
  - criar os campos de segunda conferencia na tabela `cashier_closures`;
  - replicar a nova rota de atualizacao da conferencia;
  - replicar a logica do `Master Confere` no `SalesReportController` e na tela `CashClosure.jsx`.

## Regra diaria para Refeicao no Dashboard

- Arquivos alterados:
  - `app/Http/Controllers/SaleController.php`
  - `app/Http/Controllers/UserController.php`
  - `resources/js/Pages/Dashboard.jsx`
  - `tests/Feature/SaleRefeicaoRulesTest.php`
- Problema corrigido:
  - o fluxo de lancamentos no `Dashboard` aceitava pagamento em `Refeicao` apenas com base no saldo mensal, sem limite diario e exibindo o saldo do colaborador o tempo todo.
- Causa real:
  - o `SaleController` validava somente o saldo disponivel no periodo mensal;
  - o `users.search` devolvia apenas saldo/uso mensal;
  - a tela do `Dashboard` sempre mostrava o saldo no modo `Refeicao`, mesmo quando a compra era permitida.
- Comportamento novo:
  - compras em `Refeicao` agora respeitam limite diario de `R$ 12,00` de segunda a sabado e `R$ 24,00` no domingo;
  - se a compra ultrapassar o limite diario, a conclusao e bloqueada com mensagem personalizada;
  - se o saldo de refeicao for insuficiente, a mensagem passa a mostrar o saldo disponivel do colaborador;
  - na lista de usuarios do modal, o saldo so aparece quando ele for insuficiente para a compra atual;
  - quando o bloqueio for pelo limite diario, a lista mostra apenas o valor ainda disponivel no dia.
- Testes adicionados:
  - bloqueio de venda em `Refeicao` acima do limite diario em dia util;
  - validacao de venda permitida no domingo com limite maior;
  - cobertura da busca de usuarios com campos de uso diario de refeicao.
- Impacto na sincronizacao com `pec1`:
  - replicar a validacao do limite diario no `SaleController`;
  - replicar os novos campos de uso diario em `UserController::search`;
  - replicar o ajuste visual e a validacao previa no `resources/js/Pages/Dashboard.jsx`.

## Busca por comanda no endpoint reports/hoje

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `resources/js/Pages/Reports/Hoje.jsx`
  - `tests/Feature/SalesReportHojeTest.php`
- Problema corrigido:
  - a tela `reports/hoje` ja filtrava por cupom, valor e horario, mas ainda nao permitia buscar diretamente pelo numero da comanda.
- Causa real:
  - o backend nao aceitava nenhum parametro `comanda` na consulta;
  - o frontend nao tinha campo para enviar esse filtro.
- Comportamento novo:
  - a busca de `reports/hoje` agora tambem aceita o numero da comanda;
  - o filtro funciona em conjunto com os demais criterios, mantendo sempre a base fixa no dia atual da loja e o limite de 10 registros.
- Teste adicionado:
  - cobertura para garantir o filtro por numero da comanda.
- Impacto na sincronizacao com `pec1`:
  - replicar o filtro `comanda` no metodo `hoje()` do `SalesReportController`;
  - replicar o novo campo no formulario de `resources/js/Pages/Reports/Hoje.jsx`;
  - copiar a cobertura de teste correspondente, se o `pec1` estiver com a mesma base de testes.

## Busca limitada no endpoint reports/hoje

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `resources/js/Pages/Reports/Hoje.jsx`
  - `tests/Feature/SalesReportHojeTest.php`
- Problema corrigido:
  - o endpoint `reports/hoje` listava todos os cupons do dia da loja atual de uma vez, sem busca dedicada e sem limite por consulta.
- Causa real:
  - o metodo `hoje()` carregava todos os pagamentos do dia com `get()` e sem filtros especificos;
  - a tela `Hoje.jsx` apenas renderizava a lista recebida, sem formulario para pesquisar por cupom, valor ou horario.
- Comportamento novo:
  - a tela `reports/hoje` agora exibe uma busca com filtros por numero do cupom, valor e hora;
  - a base da consulta continua sempre fixa nos cupons do dia atual da loja ativa;
  - ao informar `hora:minuto`, o backend retorna os cupons entre 10 minutos antes e 10 minutos depois do horario informado;
  - cada busca retorna no maximo 10 registros, ordenados do mais recente para o mais antigo;
  - a tela ganhou botao para limpar os filtros e mensagem explicando o limite da pesquisa.
- Teste adicionado:
  - cobertura para garantir o limite de 10 resultados no dia/unidade atual;
  - cobertura para filtro por valor + janela de horario;
  - cobertura para filtro por numero do cupom.
- Impacto na sincronizacao com `pec1`:
  - replicar no metodo `hoje()` do `SalesReportController` os filtros `cupom`, `valor` e `hora`, mantendo o dia atual como filtro fixo;
  - limitar o retorno da consulta a 10 registros;
  - replicar o formulario de busca em `resources/js/Pages/Reports/Hoje.jsx`;
  - copiar tambem o teste `tests/Feature/SalesReportHojeTest.php` se o projeto `pec1` ja estiver com a estrutura de testes alinhada.
