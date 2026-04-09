# 09/04/26

## Status de unidades com bloqueio em reports e filtros

- Arquivos alterados:
  - `database/migrations/2026_04_09_080000_add_tb2_status_to_tb2_unidades_table.php`
  - `app/Models/Unidade.php`
  - `database/seeders/UnitSeeder.php`
  - `app/Support/ManagementScope.php`
  - `app/Http/Controllers/UnitController.php`
  - `app/Http/Controllers/UnitSwitchController.php`
  - `app/Http/Controllers/Auth/AuthenticatedSessionController.php`
  - `app/Http/Controllers/SalesReportController.php`
  - `app/Http/Controllers/AnyDesckController.php`
  - `app/Http/Middleware/EnsureActiveUnit.php`
  - `routes/web.php`
  - `resources/js/Pages/Units/UnitCreate.jsx`
  - `resources/js/Pages/Units/UnitEdit.jsx`
  - `resources/js/Pages/Units/UnitIndex.jsx`
  - `resources/js/Pages/Units/UnitShow.jsx`
- Problema corrigido:
  - nao existia status persistido para unidades;
  - por isso unidades inativas continuavam aparecendo em `reports`, seletores e filtros de unidade.
- Causa real:
  - a tabela `tb2_unidades` nao tinha coluna de status;
  - as consultas que montavam as opcoes de unidade em `reports`, login, troca de unidade e filtros administrativos buscavam todas as unidades sem distinguir ativa/inativa;
  - alguns relatorios consolidados ainda somavam dados de qualquer `id_unidade` quando o filtro estava em `Todas as unidades`.
- Comportamento novo:
  - foi criada a coluna `tb2_status` em `tb2_unidades`, com padrao `1`;
  - o model `Unidade` agora possui `scopeActive()`;
  - o CRUD de unidades passou a permitir marcar a unidade como `Ativa` ou `Inativa`;
  - a listagem e a visualizacao de unidades agora exibem o status;
  - `reports`, `switch-unit`, login e demais filtros centrais agora carregam apenas unidades ativas;
  - os relatorios consolidados passaram a limitar os dados ao conjunto de unidades ativas disponiveis ao usuario, evitando que loja inativa reapareca mesmo sem filtro explicito.
- Regras importantes para sincronizar:
  - replicar a migration `2026_04_09_080000_add_tb2_status_to_tb2_unidades_table.php`;
  - em `Unidade.php`, copiar `fillable`, `casts` e `scopeActive()`;
  - em `ManagementScope.php`, `managedUnits()` deve retornar apenas unidades ativas;
  - em `SalesReportController.php`, nao basta esconder o filtro: tambem e necessario limitar as queries dos relatorios quando estiver em `Todas as unidades`;
  - em `AuthenticatedSessionController.php` e `EnsureActiveUnit.php`, a unidade da sessao/login precisa ser validada como ativa;
  - em `UnitSwitchController.php`, somente unidades ativas devem ser oferecidas para troca de sessao;
  - o CRUD de unidades precisa enviar e salvar `tb2_status`.
- Impacto na sincronizacao com `pec1`:
  - replicar integralmente a migration nova e as mudancas de backend em `Unidade.php`, `ManagementScope.php`, `UnitController.php`, `UnitSwitchController.php`, `AuthenticatedSessionController.php`, `SalesReportController.php`, `AnyDesckController.php` e `EnsureActiveUnit.php`;
  - replicar tambem as telas `resources/js/Pages/Units/UnitCreate.jsx`, `UnitEdit.jsx`, `UnitIndex.jsx` e `UnitShow.jsx`;
  - em `routes/web.php`, copiar o filtro de unidades ativas para a home apenas se a home do espelho continuar exibindo unidades publicamente;
  - como `pec1` tem `Welcome.jsx` e `Login.jsx` diferentes, a regra importante e manter o backend entregando e aceitando apenas unidades ativas, adaptando a interface local sem perder essa restricao.

# 2026-04-08

## Modal de detalhe dos gastos no reports/cash-closure

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `resources/js/Pages/Reports/CashClosure.jsx`
  - `tests/Feature/CashClosureMasterReviewTest.php`
- Problema corrigido:
  - o `reports/cash-closure` mostrava o valor total dos gastos deduzidos no `Dinheiro`, mas nao permitia abrir o detalhe dos lancamentos que compunham esse total.
- Causa real:
  - o backend enviava apenas `expense_total` por `caixa + unidade + dia`;
  - o frontend renderizava o valor negativo dos gastos apenas como texto, sem modal nem acao de detalhe.
- Comportamento novo:
  - o backend agora envia tambem `expense_details` por fechamento, com fornecedor, data, valor, observacao, usuario e loja;
  - o valor negativo dos gastos na coluna `Dinheiro` virou um botao clicavel;
  - ao clicar, abre uma modal `Detalhe dos gastos` com o total e a lista dos gastos que foram deduzidos daquele fechamento.
- Testes adicionados:
  - a cobertura de gastos no `cash-closure` agora tambem valida o payload `expense_details`.
- Impacto na sincronizacao com `pec1`:
  - replicar no `SalesReportController` o payload `expense_details` agrupado por `user_id + unit_id + data`;
  - replicar em `CashClosure.jsx` a abertura da modal ao clicar no valor negativo dos gastos;
  - copiar tambem o ajuste do teste para evitar regressao no detalhe dos gastos.

## Exclusao de gastos restrita ao usuario que gravou

- Arquivos alterados:
  - `app/Http/Controllers/ExpenseController.php`
  - `resources/js/Pages/Finance/ExpenseIndex.jsx`
- Problema corrigido:
  - qualquer usuario com acesso ao endpoint `expenses` na mesma loja podia excluir gastos gravados por outra pessoa.
- Causa real:
  - o backend validava apenas a `unit_id` do gasto na exclusao;
  - a listagem mostrava o botao `Excluir` para todos os registros.
- Comportamento novo:
  - somente o proprio usuario que gravou o gasto pode exclui-lo;
  - a listagem agora recebe o campo `can_delete`;
  - o botao `Excluir` aparece apenas nas linhas do proprio autor do gasto.
- Impacto na sincronizacao com `pec1`:
  - replicar no `ExpenseController` a validacao de exclusao por `user_id`;
  - replicar em `ExpenseIndex.jsx` o uso do campo `can_delete` para esconder o botao dos demais usuarios.

## Correcao do carregamento de gastos no cash-closure

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
- Problema corrigido:
  - havia gasto listado em `expenses`, mas ele nao aparecia no calculo do `reports/cash-closure`.
- Causa real:
  - o total agrupado de gastos era calculado antes do `map()` do fechamento, mas a variavel `$expenseTotals` nao tinha sido incluida no `use (...)` da closure;
  - por isso, dentro do fechamento o valor efetivo do gasto acabava ficando zerado.
- Comportamento novo:
  - o `cash-closure` agora passa a enxergar corretamente os gastos agrupados e a deduzi-los do dinheiro esperado no caixa.
- Impacto na sincronizacao com `pec1`:
  - conferir no `SalesReportController` do projeto espelho se a closure do `cashClosure()` tambem recebeu `$expenseTotals` no `use (...)`.

## Loja e usuario na lista de expenses com observacao no title

- Arquivos alterados:
  - `app/Http/Controllers/ExpenseController.php`
  - `resources/js/Pages/Finance/ExpenseIndex.jsx`
- Problema corrigido:
  - a lista de `expenses` nao mostrava quem lancou o gasto nem a loja vinculada;
  - a coluna `Observacao` ocupava largura fixa da tabela e apertava o restante da listagem.
- Causa real:
  - o backend carregava apenas o relacionamento com `supplier`;
  - a tabela do frontend renderizava somente `Fornecedor`, `Data`, `Valor` e `Observacao`.
- Comportamento novo:
  - a listagem de gastos agora mostra `Loja` e `Usuario` em colunas dedicadas;
  - a `Observacao` deixa de ocupar uma coluna propria;
  - o texto da observacao passa a ficar no atributo `title` da linha, aparecendo ao passar o mouse sobre o registro.
- Impacto na sincronizacao com `pec1`:
  - replicar em `ExpenseController` o carregamento das relacoes `unit` e `user`;
  - replicar em `ExpenseIndex.jsx` as colunas `Loja` e `Usuario`;
  - remover a coluna `Observacao` e mover o texto para o `title` da linha.

## Gastos deduzidos do caixa no endpoint reports/cash-closure

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `resources/js/Pages/Reports/CashClosure.jsx`
  - `resources/js/Pages/Reports/CashDiscrepancies.jsx`
  - `tests/Feature/CashClosureMasterReviewTest.php`
- Problema corrigido:
  - o `reports/cash-closure` tratava todo o dinheiro vendido no dia como valor que deveria permanecer no caixa;
  - quando havia gasto lancado em `expenses`, o fechamento passava a aparecer como falta mesmo que o dinheiro ja tivesse saído corretamente do caixa;
  - o `reports/cash-discrepancies` repetia a mesma distorcao e continuava listando discrepancia indevida.
- Causa real:
  - o backend do fechamento agrupava apenas pagamentos por `caixa + unidade + dia`;
  - os registros de `expenses` nao eram somados nem deduzidos da base esperada em dinheiro;
  - a tela nao recebia o total de gastos por fechamento para exibir esse abatimento.
- Comportamento novo:
  - o backend agora soma os `expenses` do mesmo `user_id + unit_id + dia` de cada fechamento;
  - esse total passa a ser deduzido apenas da base de `dinheiro`, sem alterar os totais de venda por forma de pagamento;
  - no `CashClosure.jsx`, a coluna `Dinheiro` mostra a base liquida esperada no caixa e, quando houver gasto, exibe abaixo da diferenca apenas o valor negativo deduzido, sem legenda extra;
  - o card `Base da conferencia` e a coluna `Conferencia caixa` passam a usar `dinheiro liquido + cartao`;
  - o `reports/cash-discrepancies` agora usa a mesma base com gastos deduzidos do dinheiro, evitando faltas falsas;
  - o modal de detalhe das discrepancias passa a mostrar tambem o total de `Gastos` usado na conta.
- Testes adicionados:
  - cobertura para garantir que o `cash-closure` deduz os gastos do caixa correto;
  - cobertura para garantir que a tela de discrepancias deixa de listar o fechamento quando o gasto explica exatamente a diferenca.
- Impacto na sincronizacao com `pec1`:
  - replicar em `SalesReportController` o agrupamento de `expenses` por `user_id + unit_id + data`;
  - deduzir esse total apenas da base de `dinheiro` usada na conferencia e nas discrepancias;
  - em `CashClosure.jsx`, trocar a base exibida de `Dinheiro` para a base liquida e mostrar o valor negativo do gasto sem legenda;
  - alinhar `CashDiscrepancies.jsx` para usar a mesma base liquida e exibir o card `Gastos` no detalhe;
  - copiar tambem os testes novos para evitar regressao na sincronizacao.

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

## Busca de colaborador no Dashboard para Vale/Refeicao

- Arquivos alterados:
  - `app/Http/Controllers/UserController.php`
  - `tests/Feature/SaleRefeicaoRulesTest.php`
- Problema corrigido:
  - o `Caixa` recebia "Nenhum usuario encontrado." ao buscar colaborador no modal de `Vale` ou `Refeicao`, mesmo quando o nome existia.
- Causa real:
  - a rota `users.search` foi liberada para `Caixa`, mas a busca passou a aplicar `ManagementScope::applyManagedUserScope`;
  - esse escopo retorna consulta vazia para perfis fora da gestao (`funcao 3`), entao o endpoint sempre devolvia lista vazia para o `Caixa`;
  - a regressao apareceu junto das alteracoes da regra de `Refeicao`, porque a busca foi mexida para devolver os campos de saldo/uso diario.
- Comportamento novo:
  - quando o usuario logado for `Caixa`, a busca de colaborador no dashboard passa a filtrar pela unidade ativa da sessao;
  - `Master` e `Gerente` continuam usando o escopo de gestao existente;
  - a busca do `Caixa` nao traz colaboradores de outra unidade.
- Testes ajustados:
  - o teste da busca de usuario em `Refeicao` agora inclui sessao com unidade ativa;
  - o teste tambem garante que um colaborador de outra unidade nao apareca para o `Caixa`.
- Impacto na sincronizacao com `pec1`:
  - replicar a mesma bifurcacao no `UserController::search`;
  - para `Caixa`, usar a unidade ativa da sessao (`active_unit.id`) com fallback para `tb2_id`;
  - manter `ManagementScope::applyManagedUserScope` apenas para perfis de gestao.

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

## Compras com complemento em cartao menor que R$ 1,00 no endpoint reports/cash-closure

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `resources/js/Pages/Reports/CashClosure.jsx`
  - `tests/Feature/CashClosureMasterReviewTest.php`
- Problema corrigido:
  - a coluna `Maquina` mostrava apenas os totais e a diferenca do fechamento, sem destacar as compras em `dinheiro` que usaram complemento automatico em cartao menor que `R$ 1,00`.
- Causa real:
  - o backend do `cash-closure` agrupava apenas os totais por forma de pagamento e nao separava os pagamentos `dinheiro` com `dois_pgto`;
  - a tela nao recebia uma lista por caixa/unidade com essas compras pequenas para montar o link e a modal de detalhe.
- Comportamento novo:
  - o backend agora entrega em cada linha do relatorio um bloco `small_card_complements` com total e itens das compras em `dinheiro` cujo `dois_pgto` esteja entre `R$ 0,01` e `R$ 0,99`;
  - abaixo de `Diferenca` na coluna `Maquina`, cada fechamento/loja passa a exibir seu proprio link com o total desses complementos, mostrando apenas o valor sem legenda extra;
  - ao clicar no link, abre uma modal com os registros que compoem aquele total, mostrando cupom, comanda, data/hora, total da compra, valor em dinheiro e complemento em cartao;
  - cada linha do detalhe agora possui a acao `Detalhar cupom`, que abre o cupom completo com itens e opcao de impressao;
  - o carregamento das `vendas` no `cash-closure` agora inclui tambem `tb1_id`, `produto_nome`, `quantidade`, `valor_unitario`, `valor_total` e `data_hora`, evitando itens zerados no detalhe do cupom;
  - foi adicionada cobertura para garantir que o agrupamento seja feito por caixa/unidade e ignore complementos iguais ou maiores que `R$ 1,00`.
- Impacto na sincronizacao com `pec1`:
  - replicar no metodo `cashClosure()` do `SalesReportController` o agrupamento `small_card_complements` por caixa/unidade;
  - replicar em `resources/js/Pages/Reports/CashClosure.jsx` o link individual em cada linha da coluna `Maquina`;
  - replicar a modal com o detalhe das compras e o total por fechamento;
  - incluir no payload de cada item o `receipt` completo e reaproveitar o mesmo fluxo de impressao de cupom usado nos outros relatorios;
  - copiar tambem a cobertura do teste `tests/Feature/CashClosureMasterReviewTest.php` se o `pec1` estiver com a mesma estrutura de testes.

## Formato de data DD/MM/AA no filtro do endpoint reports/cash-closure

- Arquivos alterados:
  - `resources/js/Pages/Reports/CashClosure.jsx`
  - `AGENTS.md`
- Problema corrigido:
  - o filtro de data do `reports/cash-closure` dependia do `input type="date"` nativo e podia aparecer no formato `MM/DD/AAAA` conforme o navegador/sistema.
- Causa real:
  - o campo nativo de data nao garantia o padrao visual exigido pelo projeto;
  - a tela ainda misturava formatos de data ISO, ano com 4 digitos e exibicao dependente do navegador.
- Comportamento novo:
  - o filtro de data agora aceita e exibe somente `DD/MM/AA`;
  - a tela converte esse valor para ISO apenas no envio do filtro ao backend;
  - as datas exibidas localmente no `CashClosure.jsx` passam a seguir o mesmo padrao curto `DD/MM/AA` e `DD/MM/AA HH:MM`;
  - o `AGENTS.md` passa a registrar a regra global de datas no formato `DD/MM/AA`, tanto para preenchimento quanto para visualizacao.
- Impacto na sincronizacao com `pec1`:
  - replicar em `resources/js/Pages/Reports/CashClosure.jsx` a troca do `input type="date"` por campo controlado em `DD/MM/AA`;
  - replicar a conversao do valor digitado para ISO antes de enviar os filtros;
  - adicionar no `AGENTS.md` do projeto espelho a mesma regra global de formato de data.

## Adiantamento salarial integrado ao endpoint users

- Arquivos alterados:
  - `app/Http/Controllers/UserController.php`
  - `app/Http/Controllers/SalaryAdvanceController.php`
  - `app/Support/ManagementScope.php`
  - `resources/js/Pages/Users/UserIndex.jsx`
  - `resources/js/Pages/Finance/SalaryAdvanceCreate.jsx`
  - `resources/js/Pages/Finance/SalaryAdvanceIndex.jsx`
  - `resources/js/Utils/date.js`
- Problema corrigido:
  - o cadastro de adiantamento existia em um fluxo separado, sem integração com `users`, sem resumo de confirmação antes da gravação e com regra de cálculo incompatível com a necessidade de acompanhar apenas o mês corrente do colaborador.
- Causa real:
  - o `UserController` bloqueava o endpoint `users` para `Sub-Gerente`;
  - a listagem `users` ainda exibia a coluna `Unidades` e não possuía ação de adiantamento por usuário;
  - o `SalaryAdvanceController` validava o adiantamento somando histórico inteiro e ainda misturava esse cálculo com vendas em `tb3_vendas` com `tipo_pago = vale`;
  - a tela `SalaryAdvanceCreate.jsx` usava um formulário genérico, sem usuário pré-selecionado, sem modal de resumo e sem lista dos lançamentos do mês corrente;
  - a exclusão de adiantamento ainda ficava disponível fora da regra "somente Master".
- Comportamento novo:
  - a listagem `users` agora pode ser acessada também por `Sub-Gerente`, sempre respeitando o escopo das unidades gerenciadas;
  - a coluna `Unidades` foi removida do `users` e cada linha ganhou um botão com ícone de dinheiro (`bi-cash-coin`) para abrir o cadastro de adiantamento do colaborador;
  - para `Sub-Gerente`, a tela `users` exibe apenas a ação de adiantamento; ações de criar/visualizar/editar/excluir usuário continuam restritas a `Master` e `Gerente`;
  - a tela de adiantamento agora trabalha orientada ao usuário selecionado, mostra salário, total do mês e unidade ativa, e permite trocar o colaborador pela própria busca;
  - a data do adiantamento passou a aceitar e exibir `DD/MM/AA`, inclusive no preenchimento inicial e na validação antes de gravar;
  - ao clicar em `Gravar`, o sistema abre uma modal de resumo com salário, valor informado, total do mês corrente, percentual do vale com base no salário e saldo projetado, com ações para confirmar ou cancelar;
  - o backend passou a validar o limite com base apenas nos adiantamentos cadastrados no mês corrente em `salary_advances`, sem misturar vendas no vale;
  - após gravar, o usuário permanece na mesma tela para continuar acompanhando os lançamentos do colaborador;
  - a mesma tela exibe a lista de adiantamentos do mês corrente do colaborador, com exclusão disponível apenas para `Master`;
  - a listagem geral de adiantamentos (`SalaryAdvanceIndex.jsx`) também passou a esconder a ação de exclusão para perfis que não sejam `Master`.
- Regras importantes para sincronizar:
  - nao foi criada migration nova; a tabela existente de adiantamentos continua a mesma;
  - o calculo do resumo/limite agora considera somente `SalaryAdvance` do mes corrente (`startOfMonth()` ate `endOfMonth()`), somando o novo valor ao total ja registrado;
  - o campo de data no frontend usa `DD/MM/AA`, mas o backend aceita converter isso para ISO antes de persistir;
  - o `Sub-Gerente` deve ter escopo de gerenciamento aplicado via `ManagementScope`, mas sem ganhar permissao para editar/cadastrar/excluir usuarios.
- Impacto na sincronizacao com `pec1`:
  - replicar em `app/Support/ManagementScope.php` a inclusao do `Sub-Gerente` no escopo de gerenciamento de usuarios/unidades;
  - replicar no `UserController` a liberacao do endpoint `users.index` para `funcao = 2` e o envio do bloco `permissions` para a tela;
  - replicar em `resources/js/Pages/Users/UserIndex.jsx` a remocao da coluna `Unidades`, o novo botao de dinheiro e o ocultamento das demais acoes para `Sub-Gerente`;
  - replicar em `app/Http/Controllers/SalaryAdvanceController.php` o carregamento do usuario via query `?user=`, a lista de adiantamentos do mes corrente, o resumo baseado apenas no mes corrente e a exclusao somente por `Master`;
  - replicar em `resources/js/Pages/Finance/SalaryAdvanceCreate.jsx` o novo fluxo com busca/troca de usuario, data `DD/MM/AA`, modal de confirmacao e grade dos adiantamentos do mes corrente;
  - replicar em `resources/js/Pages/Finance/SalaryAdvanceIndex.jsx` a ocultacao da acao de exclusao para perfis nao `Master`;
  - replicar em `resources/js/Utils/date.js` os utilitarios `formatBrazilShortDate`, `getBrazilTodayShortInputValue`, `normalizeBrazilShortDateInput` e `shortBrazilDateInputToIso`, porque a nova tela depende deles.

## Relatorio de adiantamentos agrupado por usuario com modal de detalhe

- Arquivos alterados:
  - `app/Http/Controllers/SalesReportController.php`
  - `resources/js/Pages/Reports/Advances.jsx`
- Problema corrigido:
  - o endpoint `reports/adiantamentos` listava cada adiantamento como uma linha isolada, sem consolidar valores por colaborador e sem oferecer detalhamento/modal/impressao do periodo.
- Causa real:
  - o metodo `adiantamentos()` retornava diretamente cada `SalaryAdvance`, sem `groupBy` por usuario;
  - a tela `Advances.jsx` apenas renderizava tabela simples por lancamento, usando o total bruto das linhas;
  - nao existia payload dedicado para detalhe por colaborador, nem HTML de impressao no padrao compacto usado pelos cupons;
  - o filtro de loja era aplicado de forma unica ao relatorio, sem uma segunda visao que pudesse ignorar loja no detalhamento do colaborador.
- Comportamento novo:
  - o relatorio agora mostra uma linha por usuario, com quantidade de lancamentos filtrados e total filtrado por colaborador;
  - cada linha ganhou o botao `Ver detalhe`;
  - ao clicar, abre uma modal com cabeçalho do colaborador, periodo, quantidade de lancamentos e valor total;
  - o detalhe da modal ignora o filtro de loja e carrega todos os adiantamentos do usuario dentro do periodo informado;
  - dentro da modal existe o botao `Imprimir`, que gera um detalhamento em formato compacto tipo cupom, com usuario, periodo, quantidade, total e lista de todos os lancamentos do periodo;
  - o filtro de data da tela passou a aceitar e exibir `DD/MM/AA`.
- Regras importantes para sincronizar:
  - o agrupamento principal continua respeitando o filtro de loja do relatorio;
  - somente o bloco `detail` de cada usuario ignora a loja e usa todos os `SalaryAdvance` do periodo para aquele colaborador;
  - cada item do detalhe inclui `data`, `valor`, `observacao` e `loja`, justamente porque o detalhe passa a mesclar lancamentos de lojas diferentes;
  - a impressao foi implementada localmente em `Advances.jsx` com HTML proprio, no mesmo estilo estreito de cupom usado nos outros relatorios.
- Impacto na sincronizacao com `pec1`:
  - replicar no metodo `adiantamentos()` do `SalesReportController` a troca de linhas individuais por agrupamento `groupBy('user_id')`;
  - replicar a montagem do bloco `detail` por usuario, carregando todos os adiantamentos do periodo sem aplicar o filtro de loja nesse segundo conjunto;
  - replicar em `resources/js/Pages/Reports/Advances.jsx` a nova tabela por usuario, a modal de detalhe e o botao `Imprimir` dentro da modal;
  - replicar na mesma tela a troca dos filtros de data para `DD/MM/AA`, usando os utilitarios ja adicionados em `resources/js/Utils/date.js`.

## Cor verde no botao de adiantamento em users

- Arquivos alterados:
  - `resources/js/Pages/Users/UserIndex.jsx`
- Problema corrigido:
  - o botao de adiantamento salarial na listagem de `users` estava azul, destoando da necessidade de destacar essa acao com a cor verde.
- Causa real:
  - o botao estava usando o componente `PrimaryButton`, que no projeto aplica a cor azul padrao.
- Comportamento novo:
  - o botao de adiantamento em `users` agora usa `SuccessButton`, mantendo o mesmo icone e comportamento, mas com cor verde.
- Impacto na sincronizacao com `pec1`:
  - replicar em `resources/js/Pages/Users/UserIndex.jsx` a troca de `PrimaryButton` para `SuccessButton` apenas no botao de adiantamento salarial.
