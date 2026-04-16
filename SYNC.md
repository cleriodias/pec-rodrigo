## 16/04/26 - Codigo de barras movido para baixo do nome em `products`

- causa do problema:
  - na listagem `products`, o codigo de barras aparecia em uma coluna propria;
  - isso deixava a tabela mais larga e dava destaque excessivo ao codigo, quando o desejado era um visual mais compacto.

- o que foi ajustado:
  - removida a coluna exclusiva `Codigo de barras` da tabela;
  - o codigo de barras passou a ser exibido logo abaixo do nome do produto;
  - o codigo agora usa fonte menor e aparencia mais discreta.

- frontend envolvido:
  - `resources/js/Pages/Products/ProductIndex.jsx`
    - removido o header da coluna de codigo de barras;
    - removida a celula separada do codigo de barras;
    - o nome do produto passou a renderizar o codigo abaixo dele em `text-xs`.

- arquivos alterados:
  - `resources/js/Pages/Products/ProductIndex.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `resources/js/Pages/Products/ProductIndex.jsx`
  - nao depende de migration;
  - nao altera banco;
  - nao altera backend.

## 16/04/26 - Correcao de IDs de produtos fora do padrao e bloqueio preventivo no cadastro

- causa do problema:
  - a tabela `tb1_produto` estava com `AUTO_INCREMENT` contaminado por inclusoes com IDs muito altos;
  - tambem existiam produtos cadastrados na faixa `3000` a `3100`, que e reservada para comandas;
  - no backend de produtos, o cadastro do tipo `Balanca` aceitava `tb1_id` manual apenas com `min:1`, sem bloquear a faixa reservada nem limitar o tamanho do ID;
  - para produtos nao-balanca, o sistema dependia do `AUTO_INCREMENT` do banco, entao depois que um ID gigante entrou, os proximos produtos continuaram sendo criados fora do padrao.

- diagnostico confirmado no banco antes da correcao:
  - `23` produtos estavam com IDs entre `3000` e `3100`;
  - `64` produtos estavam com IDs acima de `9999`;
  - total de `87` produtos afetados;
  - havia `182` registros relacionados em `tb3_vendas`;
  - havia `2` registros relacionados em `product_discards`;
  - o `AUTO_INCREMENT` da `tb1_produto` estava em `2191800009062`.

- regra aplicada na correcao:
  - os produtos validos continuam ate `2999`;
  - a faixa `3000` a `3100` continua reservada exclusivamente para comandas;
  - todos os produtos afetados foram remapeados em ordem de criacao (`created_at ASC`, `tb1_id ASC`);
  - o novo de/para passou a ocupar a faixa `3101` ate `3187`;
  - o proximo ID seguro ficou `3188`.

- o que foi corrigido no banco:
  - remapeados `87` produtos de `tb1_produto`;
  - atualizados os IDs vinculados em `tb3_vendas`;
  - atualizados os IDs vinculados em `product_discards`;
  - verificada a tabela `tb25_produto_movimentacoes` sem registros afetados no momento;
  - ajustado o `AUTO_INCREMENT` de `tb1_produto` para `3188`;
  - apos a correcao:
    - `0` produtos ficaram na faixa reservada;
    - `0` produtos ficaram com IDs acima de `9999`;
    - `0` referencias invalidas permaneceram em `tb3_vendas`, `product_discards` e `tb25_produto_movimentacoes`.

- o que foi ajustado no codigo para nao voltar a acontecer:
  - `app/Http/Controllers/ProductController.php`
    - criadas constantes para:
      - inicio da faixa reservada (`3000`);
      - fim da faixa reservada (`3100`);
      - limite maximo seguro (`9999`);
    - cadastro de `Balanca` agora bloqueia IDs na faixa reservada;
    - cadastro de `Balanca` agora bloqueia IDs acima de `9999`;
    - novos produtos nao-balanca deixaram de depender do `AUTO_INCREMENT` contaminado;
    - novos produtos nao-balanca passam a receber o proximo ID seguro gerado pelo metodo `nextSafeProductId()`;
    - o metodo pula automaticamente a faixa `3000` a `3100`.
  - `resources/js/Pages/Products/ProductCreate.jsx`
    - adicionada orientacao visual informando que IDs `3000` a `3100` sao reservados para comandas.

- arquivos alterados:
  - `app/Http/Controllers/ProductController.php`
  - `resources/js/Pages/Products/ProductCreate.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/ProductController.php`
    - `resources/js/Pages/Products/ProductCreate.jsx`
  - esta correcao teve duas partes:
    - parte de codigo, que deve ser sincronizada;
    - parte de banco/dados, que foi executada diretamente neste ambiente;
  - se o banco do `pec1` apresentar o mesmo problema, repetir a auditoria antes de aplicar qualquer remapeamento;
  - criterio usado no de/para:
    - selecionar produtos com `tb1_id` entre `3000` e `3100` ou acima de `9999`;
    - ordenar por `created_at ASC`, depois `tb1_id ASC`;
    - reatribuir sequencialmente de `3101` em diante;
    - atualizar referencias em `tb3_vendas`, `product_discards` e `tb25_produto_movimentacoes`;
    - ajustar o `AUTO_INCREMENT` para o proximo ID seguro;
  - este ajuste nao criou migration porque a correcao foi de dados existentes no banco, nao de estrutura.

## 15/04/26 - Novo tipo `Producao` com estoque e tela de movimentacao

- causa do problema:
  - o cadastro de produtos reconhecia apenas os tipos `Industria`, `Balanca` e `Servico`;
  - o campo `tb1_qtd` nao participava do model, validacao, create, edit, listagem nem visualizacao;
  - tambem nao existia tela propria para registrar entrada e saida dos produtos de `Producao`;
  - como a regra definida foi nao controlar estoque pela venda, faltava um fluxo administrativo dedicado para essas movimentacoes.

- regra adotada neste ajuste:
  - o novo tipo de produto ficou como valor `3` com label `Producao`;
  - produtos `Producao` usam `codigo de barras` como os tipos nao-balanca;
  - o estoque nao e debitado na venda;
  - entradas e saidas sao registradas manualmente em tela propria;
  - a nova tabela seguiu o proximo sequencial livre identificado no projeto: `tb25`.

- o que foi ajustado:
  - adicionado o tipo `Producao` nas opcoes e labels de produtos;
  - integrado o campo `tb1_qtd` ao CRUD de produtos;
  - criado um fluxo de estoque com tela de movimentacao e historico;
  - criada a tabela `tb25_produto_movimentacoes` para auditar entrada e saida;
  - adicionados atalhos para a tela de estoque na listagem, criacao, edicao e visualizacao de produtos;
  - a migration de `tb1_qtd` foi feita com protecao por `Schema::hasColumn`, porque neste projeto o campo ja havia sido criado manualmente.

- backend envolvido:
  - `app/Http/Controllers/ProductController.php`
    - passou a reconhecer `tb1_tipo = 3` como `Producao`;
    - passou a validar e preparar `tb1_qtd`;
    - passou a permitir ordenacao por `tb1_qtd`;
  - `app/Http/Controllers/ProductStockController.php`
    - criado para listar produtos de `Producao`, mostrar historico e registrar `Entrada` e `Saida`;
    - faz travamento da linha do produto com `lockForUpdate`;
    - impede saida acima do estoque atual;
    - atualiza `tb1_qtd` e grava o historico em `tb25_produto_movimentacoes`;
  - `app/Models/Produto.php`
    - recebeu `tb1_qtd` em `fillable` e `casts`;
    - recebeu relacionamento `stockMovements`;
  - `app/Models/ProductStockMovement.php`
    - criado para a nova tabela de movimentacoes;
  - `routes/web.php`
    - adicionadas as rotas:
      - `products.production-stock`
      - `products.production-stock.store`

- migrations envolvidas:
  - `database/migrations/2026_04_15_170000_add_tb1_qtd_to_tb1_produto_table.php`
    - adiciona `tb1_qtd` em `tb1_produto` somente se a coluna ainda nao existir;
  - `database/migrations/2026_04_15_171000_create_tb25_produto_movimentacoes_table.php`
    - cria `tb25_produto_movimentacoes`;
    - grava produto, usuario, tipo da movimentacao, quantidade, saldo anterior, saldo posterior e observacao.

- frontend envolvido:
  - `resources/js/Pages/Products/ProductCreate.jsx`
    - passou a exibir `Quantidade inicial` quando o tipo selecionado for `Producao`;
    - recebeu atalho para a tela de estoque;
  - `resources/js/Pages/Products/ProductEdit.jsx`
    - passou a exibir `Quantidade atual` quando o tipo for `Producao`;
    - orienta o uso da tela de estoque para novas entradas e saidas;
    - recebeu atalho para a tela de estoque;
  - `resources/js/Pages/Products/ProductIndex.jsx`
    - ganhou a coluna `Estoque`;
    - mostra o valor apenas para produtos de `Producao`;
    - ganhou botao superior de estoque e atalho por linha;
  - `resources/js/Pages/Products/ProductShow.jsx`
    - passou a mostrar `Estoque atual` para produtos de `Producao`;
    - recebeu atalho para a tela de estoque;
  - `resources/js/Pages/Products/ProductionStock.jsx`
    - criada a nova tela de estoque;
    - possui formulario de `Entrada` e `Saida`;
    - mostra saldo atual do produto selecionado;
    - lista produtos de `Producao`;
    - lista historico recente das movimentacoes.

- arquivos alterados:
  - `app/Http/Controllers/ProductController.php`
  - `app/Models/Produto.php`
  - `resources/js/Pages/Products/ProductCreate.jsx`
  - `resources/js/Pages/Products/ProductEdit.jsx`
  - `resources/js/Pages/Products/ProductIndex.jsx`
  - `resources/js/Pages/Products/ProductShow.jsx`
  - `routes/web.php`
  - `SYNC.md`

- arquivos criados:
  - `app/Http/Controllers/ProductStockController.php`
  - `app/Models/ProductStockMovement.php`
  - `database/migrations/2026_04_15_170000_add_tb1_qtd_to_tb1_produto_table.php`
  - `database/migrations/2026_04_15_171000_create_tb25_produto_movimentacoes_table.php`
  - `resources/js/Pages/Products/ProductionStock.jsx`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/ProductController.php`
    - `app/Http/Controllers/ProductStockController.php`
    - `app/Models/Produto.php`
    - `app/Models/ProductStockMovement.php`
    - `resources/js/Pages/Products/ProductCreate.jsx`
    - `resources/js/Pages/Products/ProductEdit.jsx`
    - `resources/js/Pages/Products/ProductIndex.jsx`
    - `resources/js/Pages/Products/ProductShow.jsx`
    - `resources/js/Pages/Products/ProductionStock.jsx`
    - `routes/web.php`
    - `database/migrations/2026_04_15_170000_add_tb1_qtd_to_tb1_produto_table.php`
    - `database/migrations/2026_04_15_171000_create_tb25_produto_movimentacoes_table.php`
  - depois de sincronizar o codigo no `pec1`, executar as migrations;
  - a migration de `tb1_qtd` foi preparada para nao quebrar se a coluna ja existir manualmente;
  - a nova tabela criada neste ajuste usa o sequencial `tb25`, entao nao reutilizar esse numero para outra tabela;
  - este ajuste nao altera o fluxo de venda nem baixa estoque automaticamente por venda.

## 15/04/26 - Nome do fornecedor abre a tela de resposta das disputas em `settings/suppliers`

- causa do problema:
  - na listagem `Fornecedores cadastrados` o nome do fornecedor era apenas texto;
  - a tela onde o fornecedor responde as disputas existe em `/supplier/disputes`, mas depende da sessao `supplier_access` criada pelo login com codigo;
  - por isso nao era possivel, a partir do painel administrativo, abrir diretamente a tela de respostas de um fornecedor especifico.

- o que foi ajustado:
  - criado um acesso administrativo para visualizar a tela de disputas de um fornecedor especifico;
  - o nome do fornecedor passou a ser clicavel na tabela de `settings/suppliers`;
  - o clique abre a mesma pagina `Supplier/Disputes`, agora em modo administrativo;
  - nesse modo a tela mostra os dados que o fornecedor enxerga, mas sem depender da sessao dele e sem permitir envio de resposta ou faturamento.

- backend envolvido:
  - `routes/web.php`
    - adicionada a rota nomeada `settings.suppliers.disputes`;
  - `app/Http/Controllers/SupplierController.php`
    - criado o metodo `showDisputes(Request $request, Supplier $supplier)`;
    - criado o helper privado `buildSupplierBids(Supplier $supplier)` para montar os lances exibidos na tela administrativa.

- frontend envolvido:
  - `resources/js/Pages/Settings/Suppliers.jsx`
    - o nome do fornecedor passou a usar `Link` para a nova rota administrativa;
  - `resources/js/Pages/Supplier/Disputes.jsx`
    - passou a aceitar `portalMode` e `backUrl`;
    - no modo `admin`, exibe mensagem de visualizacao administrativa;
    - no modo `admin`, substitui `Sair` por `Voltar`;
    - no modo `admin`, desabilita edicao de custo, upload e acoes de envio/faturamento.

- arquivos alterados:
  - `routes/web.php`
  - `app/Http/Controllers/SupplierController.php`
  - `resources/js/Pages/Settings/Suppliers.jsx`
  - `resources/js/Pages/Supplier/Disputes.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `routes/web.php`
    - `app/Http/Controllers/SupplierController.php`
    - `resources/js/Pages/Settings/Suppliers.jsx`
    - `resources/js/Pages/Supplier/Disputes.jsx`
  - manter a rota publica `/supplier/disputes` como esta;
  - a nova rota administrativa nao substitui o acesso por codigo do fornecedor, ela apenas permite consulta pelo master;
  - nao depende de migration;
  - nao altera estrutura do banco.

## 15/04/26 - Botao de alternancia na coluna `Disputa` em `settings/suppliers`

- causa do problema:
  - a tela `settings/suppliers` ja listava o campo `dispute` de cada fornecedor;
  - porem a coluna `Disputa` era apenas informativa, mostrando somente `Sim` ou `Nao`;
  - com isso, qualquer alteracao exigia ajuste indireto no cadastro ou intervencao manual, porque nao existia rota nem acao especifica para alternar esse booleano diretamente na listagem.

- o que foi ajustado:
  - adicionada uma rota `PUT` dedicada para alternar o campo `dispute` do fornecedor;
  - criado no controller o metodo que faz o switch do valor atual no banco;
  - a coluna `Disputa` da tabela `Fornecedores cadastrados` passou a exibir um botao clicavel;
  - o botao agora alterna entre `Sim` e `Nao` sem sair da pagina, mantendo o scroll.

- backend envolvido:
  - `routes/web.php`
    - adicionada a rota nomeada `settings.suppliers.toggle-dispute`;
  - `app/Http/Controllers/SupplierController.php`
    - criado o metodo `toggleDispute(Request $request, Supplier $supplier)`;
    - o metodo valida permissao de `MASTER`, inverte o booleano `dispute` e redireciona com mensagem de sucesso.

- frontend envolvido:
  - `resources/js/Pages/Settings/Suppliers.jsx`
    - importado `PrimaryButton`, `router` e `useState`;
    - criada a funcao `handleDisputeToggle`;
    - a celula `Disputa` deixou de renderizar texto fixo e passou a renderizar um botao;
    - o botao mostra `...` enquanto a requisicao daquele fornecedor estiver em andamento;
    - o update usa `preserveScroll: true`.

- arquivos alterados:
  - `routes/web.php`
  - `app/Http/Controllers/SupplierController.php`
  - `resources/js/Pages/Settings/Suppliers.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `routes/web.php`
    - `app/Http/Controllers/SupplierController.php`
    - `resources/js/Pages/Settings/Suppliers.jsx`
  - atualizar tambem o `SYNC.md` do outro projeto se voces mantiverem historico la;
  - nao depende de migration;
  - nao cria tabela;
  - nao altera estrutura do banco;
  - depende de o model `App\\Models\\Supplier` continuar com `dispute` em `fillable` e `casts`, como ja esta neste projeto.

## 14/04/26 - Totais de `Vale` e `Adiantamento` no card `Periodo considerado` em `settings/contra-cheque`

- causa do problema:
  - o backend da tela `settings/contra-cheque` ja enviava `summary.advances_total` e `summary.vales_total`;
  - porem o frontend do card `Periodo considerado` montava apenas `Colaboradores`, `Salarios` e `Saldo a receber`;
  - com isso, os totais de `Vale` e `Adiantamento` nao apareciam no resumo superior, mesmo estando disponiveis nos dados.

- o que foi ajustado:
  - adicionado o card `Adiantamento` no resumo superior;
  - adicionado o card `Vale` no resumo superior;
  - ajustada a grade do bloco para acomodar os 5 cards sem quebrar o layout.

- frontend envolvido:
  - `resources/js/Pages/Settings/ContraCheque.jsx`
    - `summaryCards` agora inclui `summary.advances_total`;
    - `summaryCards` agora inclui `summary.vales_total`;
    - a grade do bloco `Periodo considerado` passou de 3 cards para 5 cards.

- arquivos alterados:
  - `resources/js/Pages/Settings/ContraCheque.jsx`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `resources/js/Pages/Settings/ContraCheque.jsx`
  - nao depende de migration;
  - nao depende de rota nova;
  - nao altera banco;
  - o backend nao precisou ser alterado porque os totais ja eram enviados por `app/Http/Controllers/PayrollController.php`.

## 13/04/26 - Filtros adicionados em `settings/contra-cheque`

- causa do problema:
  - a tela `settings/contra-cheque` foi criada com os cards e a impressao, mas sem o mesmo formulario de filtros da tela `settings/folha-pagamento`;
  - com isso, o usuario nao conseguia refinar a visualizacao por periodo, unidade ou funcao diretamente nessa tela.

- o que foi ajustado:
  - adicionados em `settings/contra-cheque` os mesmos filtros da folha:
    - `Inicio`;
    - `Fim`;
    - `Unidade`;
    - `Funcao`;
  - o formulario agora envia os filtros para a propria rota `settings.contra-cheque`;
  - as datas continuam usando o padrao `DD/MM/AA`;
  - os cards e a impressao em 80mm continuam funcionando sobre o resultado filtrado.

- frontend envolvido:
  - `resources/js/Pages/Settings/ContraCheque.jsx`
    - passou a usar `useForm`;
    - recebeu os campos de filtro com o mesmo comportamento da folha;
    - converte as datas com `shortBrazilDateInputToIso`;
    - reaproveita `filterUnits`, `roleOptions`, `selectedUnitId` e `selectedRole` enviados pelo backend.

- arquivos alterados:
  - `resources/js/Pages/Settings/ContraCheque.jsx`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `resources/js/Pages/Settings/ContraCheque.jsx`
  - nao depende de migration;
  - nao depende de rota nova;
  - nao altera banco;
  - o backend ja estava preparado para receber esses filtros, por isso neste ajuste foi necessario alterar apenas o frontend.

## 13/04/26 - Nova opcao `Contra-Cheque` em Ferramentas com cards e impressao 80mm

- causa do problema:
  - no menu `Ferramentas` nao existia uma entrada dedicada chamada `Contra-Cheque`;
  - o sistema possuia a tela `Folha de Pagamento`, mas ela era uma visao mais ampla, em tabela, e nao uma tela direta em cards por colaborador;
  - tambem nao existia uma tela simplificada focada apenas em colaboradores com salario informado e com impressao resumida em 80mm.

- regra adotada para este ajuste:
  - como o sistema nao possui um campo explicito de `usuario ativo` no model `User`, foi considerada como base de exibicao:
    - usuarios dentro do escopo de gerenciamento permitido;
    - usuarios diferentes de `Cliente`;
    - usuarios com `salario > 0`.

- o que foi ajustado:
  - criada a opcao `Contra-Cheque` dentro de `Ferramentas`;
  - criada uma tela nova em cards, exibindo um resumo por colaborador;
  - cada card exibe:
    - `Salario`;
    - `Vale em compras`;
    - `Adiantamento`;
    - `Saldo`;
  - cada card possui botao `Imprimir 80mm`;
  - a impressao foi configurada para mostrar um resumo dos valores e o `Saldo a receber`;
  - a logica de impressao foi extraida para uma utilidade compartilhada;
  - a tela `Folha de Pagamento` passou a reutilizar a mesma utilidade de impressao.

- backend envolvido:
  - `app/Http/Controllers/PayrollController.php`
    - criada a action `contraCheque`;
    - a montagem dos dados da folha foi centralizada em `buildPayrollPayload`;
    - a nova tela reutiliza a mesma base de calculo de salario, vale, adiantamento e saldo;
    - quando a tela e `Contra-Cheque`, a consulta filtra apenas usuarios com `salario > 0`.
  - `routes/web.php`
    - adicionada a rota `settings.contra-cheque` em `/settings/contra-cheque`.

- frontend envolvido:
  - `resources/js/Pages/Settings/ContraCheque.jsx`
    - nova tela em cards para resumo individual por colaborador;
    - imprime contra-cheque resumido em 80mm.
  - `resources/js/Utils/contraChequePrint.js`
    - nova utilidade compartilhada para gerar e imprimir o HTML do contra-cheque;
    - suporta impressao resumida e detalhada.
  - `resources/js/Pages/Settings/FolhaPagamento.jsx`
    - passou a usar a utilidade compartilhada de impressao.
  - `resources/js/Pages/Settings/Menu.jsx`
    - adicionada a entrada `Contra-Cheque` no bloco `Ferramentas`.
  - `resources/js/Pages/Settings/Config.jsx`
    - adicionada a opcao `Contra-Cheque` na grade principal de `Ferramentas`.

- arquivos alterados:
  - `app/Http/Controllers/PayrollController.php`
  - `routes/web.php`
  - `resources/js/Pages/Settings/FolhaPagamento.jsx`
  - `resources/js/Pages/Settings/Menu.jsx`
  - `resources/js/Pages/Settings/Config.jsx`
  - `resources/js/Pages/Settings/ContraCheque.jsx`
  - `resources/js/Utils/contraChequePrint.js`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/PayrollController.php`
    - `routes/web.php`
    - `resources/js/Pages/Settings/FolhaPagamento.jsx`
    - `resources/js/Pages/Settings/Menu.jsx`
    - `resources/js/Pages/Settings/Config.jsx`
    - `resources/js/Pages/Settings/ContraCheque.jsx`
    - `resources/js/Utils/contraChequePrint.js`
  - nao depende de migration;
  - nao depende de alteracao no banco;
  - a regra de `ativo` nesta implementacao esta baseada em `salario > 0` e exclusao do perfil `Cliente`, porque nao existe um campo especifico de ativo em `users`;
  - a tela nova usa o mes corrente por padrao, seguindo a mesma regra de datas ja usada em `Folha de Pagamento`.

## 13/04/26 - Impressao individual e em lote em `salary-advances/create`

- causa do problema:
  - a tela `salary-advances/create` listava os adiantamentos do mes corrente apenas com a acao de exclusao;
  - nao existia botao para imprimir um adiantamento individual;
  - nao existia botao para imprimir todos os adiantamentos exibidos do usuario selecionado;
  - a tela tambem nao recebia o nome da loja de cada lancamento nem o periodo completo do mes corrente para montar a impressao corretamente.

- o que foi ajustado:
  - adicionados botoes `Imprimir` em cada linha da lista de adiantamentos;
  - adicionado botao `Imprimir todos` no topo do bloco `Vales do mes corrente`;
  - a impressao individual gera um comprovante contendo apenas o adiantamento da linha clicada;
  - a impressao em lote gera um comprovante com todos os adiantamentos exibidos do usuario no mes corrente;
  - o botao `Gravar` da tela passou a usar o componente central `PrimaryButton`;
  - o botao `Excluir` da grade passou a usar o componente central `DangerButton`;
  - o layout de impressao foi extraido para uma utilidade compartilhada, evitando duplicacao com o relatorio de adiantamentos.

- backend envolvido:
  - `app/Http/Controllers/SalaryAdvanceController.php`
    - a tela `create` agora envia `currentMonthStart` e `currentMonthEnd`;
    - a consulta do mes corrente agora carrega a relacao da loja;
    - cada item de `currentMonthAdvances` agora inclui `unit_name`;
    - o metodo `currentMonthAdvancesQuery` passou a aceitar intervalo opcional para reutilizar o mesmo periodo resolvido na action.

- frontend envolvido:
  - `resources/js/Pages/Finance/SalaryAdvanceCreate.jsx`
    - adicionados os botoes `Imprimir` e `Imprimir todos`;
    - adicionada mensagem visual quando o navegador bloqueia pop-up de impressao;
    - montado o detalhe individual e o detalhe consolidado do mes para envio ao helper de impressao.
  - `resources/js/Utils/salaryAdvancePrint.js`
    - nova utilidade compartilhada para gerar o HTML de impressao de adiantamentos;
    - centraliza a abertura da janela e o `window.print`.
  - `resources/js/Pages/Reports/Advances.jsx`
    - passou a reutilizar a nova utilidade compartilhada de impressao.

- arquivos alterados:
  - `app/Http/Controllers/SalaryAdvanceController.php`
  - `resources/js/Pages/Finance/SalaryAdvanceCreate.jsx`
  - `resources/js/Pages/Reports/Advances.jsx`
  - `resources/js/Utils/salaryAdvancePrint.js`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/SalaryAdvanceController.php`
    - `resources/js/Pages/Finance/SalaryAdvanceCreate.jsx`
    - `resources/js/Pages/Reports/Advances.jsx`
    - `resources/js/Utils/salaryAdvancePrint.js`
  - nao depende de migration;
  - nao depende de rota nova;
  - nao altera banco;
  - a impressao continua 100% no frontend;
  - se a IA de `pec1` encontrar o codigo antigo de impressao dentro de `resources/js/Pages/Reports/Advances.jsx`, deve remover aquela duplicacao e usar a utilidade `resources/js/Utils/salaryAdvancePrint.js`.

## 11/04/26 - Configuracao do Discarte com filtro mensal e consolidado por loja

- causa do problema:
  - a tela `settings/discard-config` mostrava apenas o escopo ativo da sessao;
  - nao existia filtro de mes;
  - nao havia consolidado real de todas as lojas permitidas;
  - tambem nao existia detalhamento individual por loja com `Hoje` e `Acumulado`.

- o que foi ajustado:
  - removido o card `Escopo atual` da tela;
  - adicionado filtro de mes para controlar o bloco de `Acumulado`;
  - mantido o bloco `Hoje` usando a data atual;
  - o `Acumulado` agora considera o mes selecionado e exibe o periodo visual em `DD/MM/AA a DD/MM/AA`;
  - a tela passou a exibir:
    - consolidado de hoje de todas as lojas permitidas;
    - consolidado acumulado de todas as lojas permitidas;
    - tabela com cada loja individual exibindo `Hoje` e `Acumulado`.

- backend envolvido:
  - `app/Http/Controllers/DiscardSettingsController.php`
    - passou a ler `month` via query string;
    - resolve o mes com fallback para o mes atual;
    - monta a lista de lojas permitidas via `ManagementScope::managedUnits`;
    - envia para a Inertia um `monitoring` novo com consolidado geral e detalhamento por loja.
  - `app/Support/DiscardAlertService.php`
    - ganhou o metodo `dashboardForAdmin`;
    - calcula consolidado geral `today`;
    - calcula consolidado geral `month`;
    - monta a lista `stores` com `today` e `month` por loja;
    - reutiliza a mesma regra de calculo de descarte, faturamento e percentual que ja existia.

- arquivos alterados:
  - `app/Http/Controllers/DiscardSettingsController.php`
  - `app/Support/DiscardAlertService.php`
  - `resources/js/Pages/Settings/DiscardConfig.jsx`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/DiscardSettingsController.php`
    - `app/Support/DiscardAlertService.php`
    - `resources/js/Pages/Settings/DiscardConfig.jsx`
  - nao depende de migration;
  - nao depende de rota nova;
  - nao altera banco;
  - a tela continua administrativa;
  - o filtro mensal desta tela nao troca a loja ativa da sessao;
  - o monitoramento global usado em outras partes do sistema nao foi alterado.

## 11/04/26 - Ajuste visual do topo em `settings/discard-config`

- causa do problema:
  - o topo da tela estava montado em blocos verticais simples;
  - o input e o botao do percentual ficavam separados;
  - o filtro mensal tambem estava mais alto e espaçado que o layout desejado;
  - visualmente a composicao nao seguia a referencia enviada.

- o que foi ajustado:
  - `resources/js/Pages/Settings/DiscardConfig.jsx`
    - o card `Percentual aceitavel` agora usa input e botao na mesma linha;
    - o botao `Salvar configuracao` passou a ficar dentro de uma faixa horizontal ao lado do campo;
    - o card `Filtro do acumulado` agora usa campo `month` e botao `Aplicar mes` lado a lado;
    - ajustadas proporcoes da grid superior, paddings, larguras e arredondamentos para aproximar o visual da imagem;
    - a logica da tela nao foi alterada, somente a organizacao visual.

- arquivos alterados:
  - `resources/js/Pages/Settings/DiscardConfig.jsx`

- validacao:
  - `npm run build`: ok.
