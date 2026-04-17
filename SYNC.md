## 16/04/26 - Nomes de produtos convertidos e protegidos em maiusculo

- causa do problema:
  - o campo `tb1_nome` era salvo exatamente como digitado;
  - isso permitia cadastro e alteracao com letras minusculas, deixando a base inconsistente.

- o que foi ajustado:
  - o backend passou a normalizar `tb1_nome` para maiusculo antes de salvar;
  - as telas de cadastro e edicao passaram a converter o nome para maiusculo enquanto o usuario digita;
  - os registros ja existentes em `tb1_produto` tambem foram convertidos para maiusculo.

- backend envolvido:
  - `app/Http/Controllers/ProductController.php`
    - adicionada normalizacao central do nome com `mb_strtoupper`;
    - `store` e `update` passam a salvar o nome sempre em maiusculo via `prepareProductData`.

- frontend envolvido:
  - `resources/js/Pages/Products/ProductCreate.jsx`
    - o campo `tb1_nome` agora converte para maiusculo no `onChange`.
  - `resources/js/Pages/Products/ProductEdit.jsx`
    - o campo `tb1_nome` agora converte para maiusculo no `onChange`.

- arquivos alterados:
  - `app/Http/Controllers/ProductController.php`
  - `resources/js/Pages/Products/ProductCreate.jsx`
  - `resources/js/Pages/Products/ProductEdit.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/ProductController.php`
    - `resources/js/Pages/Products/ProductCreate.jsx`
    - `resources/js/Pages/Products/ProductEdit.jsx`
  - nao depende de migration;
  - nao altera estrutura de banco;
  - e importante replicar tambem a conversao dos registros ja existentes no banco de `pec1`.

## 16/04/26 - Nome do produto limitado a 25 caracteres em `products`

- causa do problema:
  - na listagem `products`, nomes longos de produtos estavam sendo exibidos por completo;
  - isso aumentava visualmente a largura da coluna e prejudicava a leitura rapida da tabela.

- o que foi ajustado:
  - o nome do produto passou a exibir no maximo `25` caracteres;
  - quando o nome ultrapassa esse limite, a listagem mostra reticencias;
  - adicionado `title` com o nome completo para consulta no hover.

- frontend envolvido:
  - `resources/js/Pages/Products/ProductIndex.jsx`
    - adicionada regra de truncamento visual do nome;
    - mantido o valor completo no `title`.

- arquivos alterados:
  - `resources/js/Pages/Products/ProductIndex.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `resources/js/Pages/Products/ProductIndex.jsx`
  - nao depende de migration;
  - nao altera banco;
  - nao altera backend.

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

## 16/04/26 - Produto sem codigo de barras usando o proprio `tb1_id`

- causa do problema:
  - o cadastro de produto nao permitia indicar explicitamente que um item nao possui codigo de barras;
  - quando isso acontecia, o sistema acabava usando codigos improvisados ou o usuario precisava informar um valor ficticio;
  - na base atual existiam varios `tb1_codbar` curtos, inclusive casos no padrao `SEM-*`, o que deixava o comportamento inconsistente entre cadastro novo e produtos antigos.

- regra aplicada:
  - quando o usuario marcar que o produto nao possui codigo de barras, o sistema grava o proprio `tb1_id` no campo `tb1_codbar`;
  - produtos de balanca continuam sem codigo de barras proprio, mas agora tambem usam o proprio `tb1_id` em `tb1_codbar`;
  - na correcao do banco, todo produto com `tb1_codbar` menor que `7` caracteres passa a receber `CAST(tb1_id AS CHAR)`.

- backend envolvido:
  - `app/Http/Controllers/ProductController.php`
    - adicionada a flag de request `sem_codigo_barras`;
    - `tb1_codbar` deixa de ser obrigatorio quando essa flag estiver marcada;
    - a geracao final do codigo passou a ser centralizada em `resolveProductBarcode`;
    - quando o produto estiver sem codigo proprio, o controller grava `tb1_codbar` com o proprio `tb1_id`;
    - a validacao de colisao de codigo passou a considerar tambem esse codigo gerado com base no ID;
    - `nextSafeProductId` passou a ignorar IDs cujo valor textual ja esteja ocupado em `tb1_codbar`.
  - `database/migrations/2026_04_16_190000_sync_short_product_barcodes_with_id.php`
    - nova migration de saneamento;
    - atualiza `tb1_produto.tb1_codbar` para `CAST(tb1_id AS CHAR)` quando `CHAR_LENGTH(TRIM(tb1_codbar)) < 7`;
    - o `down` ficou sem reversao automatica porque os valores antigos nao sao recuperaveis.

- frontend envolvido:
  - `resources/js/Pages/Products/ProductCreate.jsx`
    - adicionado checkbox `Produto sem codigo de barras`;
    - quando marcado, o campo manual de codigo deixa de ser exibido;
    - a tela informa que o sistema copiara o `tb1_id` para `tb1_codbar`;
    - para produtos de balanca o checkbox fica sempre ativo e bloqueado.
  - `resources/js/Pages/Products/ProductEdit.jsx`
    - recebeu a mesma regra visual do cadastro;
    - quando o produto estiver sem codigo proprio, a tela exibe apenas a orientacao e nao mostra input manual para `tb1_codbar`;
    - para produtos de balanca, a mensagem agora deixa claro que `tb1_codbar` acompanha o proprio `tb1_id`.

- testes:
  - `tests/Feature/ProductManagementTest.php`
    - atualizado para refletir o fim do padrao `SEM-*`;
    - adicionado cenario cobrindo produto comum marcado como sem codigo de barras, validando `tb1_codbar = tb1_id`.

- arquivos alterados:
  - `app/Http/Controllers/ProductController.php`
  - `resources/js/Pages/Products/ProductCreate.jsx`
  - `resources/js/Pages/Products/ProductEdit.jsx`
  - `tests/Feature/ProductManagementTest.php`
  - `SYNC.md`
  - `database/migrations/2026_04_16_190000_sync_short_product_barcodes_with_id.php`

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente:
    - `app/Http/Controllers/ProductController.php`
    - `resources/js/Pages/Products/ProductCreate.jsx`
    - `resources/js/Pages/Products/ProductEdit.jsx`
    - `tests/Feature/ProductManagementTest.php`
    - `database/migrations/2026_04_16_190000_sync_short_product_barcodes_with_id.php`
  - aplicar a migration tambem em `pec1`;
  - a copia em `pec1` pode ter pequenas diferencas visuais nas telas `Welcome.jsx` e `Login.jsx`, mas isso nao interfere nesta sincronizacao;
  - o ponto critico da sincronizacao e manter a mesma regra no controller e no formulario: `sem_codigo_barras` precisa resultar em `tb1_codbar = tb1_id`.

## 16/04/26 - Base estrutural para emissao fiscal NF-e/NFC-e

- causa do problema:
  - o sistema fechava a venda normalmente, mas nao possuia nenhuma camada fiscal para transformar esse fechamento em nota eletronica;
  - faltavam tres blocos essenciais:
    - configuracao fiscal por unidade;
    - cadastro fiscal minimo de produto;
    - vinculo entre a venda concluida e um registro fiscal preparado para futura transmissao a SEFAZ;
  - sem isso, mesmo com certificado e API depois, a emissao ficaria travada por falta de estrutura e validacao interna.

- o que foi criado nesta etapa:
  - estrutura de banco para configuracao fiscal por unidade;
  - estrutura de banco para registrar a nota fiscal ligada ao fechamento da venda;
  - ampliacao do cadastro de produto com campos fiscais minimos;
  - tela administrativa de configuracao fiscal;
  - preparacao automatica de registro fiscal quando a venda e finalizada;
  - validacao interna para marcar se a nota esta:
    - `pendente_configuracao`;
    - `erro_validacao`;
    - `pendente_emissao`.

- banco de dados:
  - `database/migrations/2026_04_16_200000_add_fiscal_fields_to_tb1_produto_table.php`
    - adiciona em `tb1_produto`:
      - `tb1_ncm`
      - `tb1_cest`
      - `tb1_cfop`
      - `tb1_unidade_comercial`
      - `tb1_unidade_tributavel`
      - `tb1_origem`
      - `tb1_csosn`
      - `tb1_cst`
      - `tb1_aliquota_icms`
  - `database/migrations/2026_04_16_201000_create_tb26_configuracoes_fiscais_table.php`
    - cria `tb26_configuracoes_fiscais`;
    - tabela por unidade (`tb2_id` unico);
    - guarda ambiente, serie, proximo numero, CRT, CSC, tipo de certificado, caminho do certificado, senha criptografada e dados completos do emitente.
  - `database/migrations/2026_04_16_202000_create_tb27_notas_fiscais_table.php`
    - cria `tb27_notas_fiscais`;
    - liga uma nota ao fechamento (`tb4_id`);
    - guarda status, payload montado, erros de validacao, chave, protocolo, XML e datas operacionais.

- backend:
  - `app/Models/ConfiguracaoFiscal.php`
    - novo model da tabela `tb26_configuracoes_fiscais`;
    - senha do certificado com cast `encrypted`.
  - `app/Models/NotaFiscal.php`
    - novo model da tabela `tb27_notas_fiscais`.
  - `app/Support/FiscalInvoicePreparationService.php`
    - novo servico para preparar a nota a partir do fechamento;
    - monta payload interno da emissao;
    - valida configuracao da unidade;
    - valida se os produtos tem cadastro fiscal minimo;
    - define o status inicial da nota;
    - reserva numeracao somente quando a unidade ja tiver algum tipo de emissao habilitado.
  - `app/Http/Controllers/SaleController.php`
    - ao finalizar a venda, agora chama `FiscalInvoicePreparationService`;
    - o JSON de retorno da venda passou a trazer bloco `fiscal` com status, mensagem, modelo, ambiente, serie e numero.
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - novo controller para tela de configuracao fiscal;
    - permite selecionar unidade;
    - salvar ambiente, serie, CRT, CSC, dados do emitente;
    - fazer upload do certificado `A1` (`.pfx`/`.p12`);
    - remover certificado atual;
    - listar as ultimas notas preparadas da unidade.
  - `app/Http/Controllers/ProductController.php`
    - validacao e persistencia dos novos campos fiscais do produto;
    - inclusao das opcoes de origem fiscal no formulario.
  - `app/Models/Produto.php`
    - fillable/casts atualizados com os novos campos fiscais.
  - `app/Models/VendaPagamento.php`
    - adicionada relacao `notaFiscal()`.
  - `app/Models/Unidade.php`
    - adicionada relacao `configuracaoFiscal()`.
  - `routes/web.php`
    - novas rotas:
      - `settings.fiscal`
      - `settings.fiscal.update`

- frontend:
  - `resources/js/Pages/Settings/Config.jsx`
    - adicionada entrada `Configuracao Fiscal` no menu de ferramentas.
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - nova tela de configuracao fiscal;
    - selecao de unidade;
    - bloco de emissao e numeracao;
    - bloco de credenciais fiscais;
    - upload de certificado;
    - bloco de dados do emitente;
    - tabela com as ultimas notas preparadas.
  - `resources/js/Pages/Products/ProductCreate.jsx`
    - nova secao `Cadastro fiscal`.
  - `resources/js/Pages/Products/ProductEdit.jsx`
    - nova secao `Cadastro fiscal`.

- testes e validacao:
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
    - novo teste unitario cobrindo:
      - falta de configuracao fiscal;
      - configuracao completa e produto valido;
      - produto sem cadastro fiscal minimo.
  - `php artisan test tests/Unit/FiscalInvoicePreparationServiceTest.php`: ok.
  - `npm run build`: ok.
  - `php artisan test`: nao validado integralmente por bloqueio de conexao com o MySQL externo do ambiente de teste.

- comportamento importante desta etapa:
  - isto ainda nao transmite nota para a SEFAZ;
  - esta entrega prepara a base para a futura integracao oficial;
  - a venda agora ja nasce com um registro fiscal interno;
  - se a unidade ou o produto estiverem incompletos, a nota fica sinalizada com pendencia em vez de falhar silenciosamente.

- observacoes para sincronizar em `pec1`:
  - sincronizar exatamente estes arquivos:
    - `app/Http/Controllers/FiscalConfigurationController.php`
    - `app/Http/Controllers/ProductController.php`
    - `app/Http/Controllers/SaleController.php`
    - `app/Models/ConfiguracaoFiscal.php`
    - `app/Models/NotaFiscal.php`
    - `app/Models/Produto.php`
    - `app/Models/Unidade.php`
    - `app/Models/VendaPagamento.php`
    - `app/Support/FiscalInvoicePreparationService.php`
    - `database/migrations/2026_04_16_200000_add_fiscal_fields_to_tb1_produto_table.php`
    - `database/migrations/2026_04_16_201000_create_tb26_configuracoes_fiscais_table.php`
    - `database/migrations/2026_04_16_202000_create_tb27_notas_fiscais_table.php`
    - `resources/js/Pages/Products/ProductCreate.jsx`
    - `resources/js/Pages/Products/ProductEdit.jsx`
    - `resources/js/Pages/Settings/Config.jsx`
    - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - `routes/web.php`
    - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
  - a sincronizacao desta etapa nao depende de `Welcome.jsx` nem `Login.jsx`;
  - ponto critico:
    - copiar o service, o controller fiscal e as tres migrations juntos;
    - se copiar so a tela ou so o controller, a venda vai referenciar estruturas que ainda nao existem;
    - a migration `tb27_notas_fiscais` depende de `tb26_configuracoes_fiscais`;
    - a regra nova da venda depende da relacao `notaFiscal()` em `VendaPagamento`.

## 16/04/26 - Associacao explicita entre loja e certificado fiscal

- causa do ajuste:
  - foi confirmado que cada loja possui CNPJ proprio;
  - consequentemente cada loja tambem possui certificado digital proprio;
  - embora a configuracao fiscal ja estivesse vinculada por `tb2_id`, ainda faltava deixar isso explicito no cadastro e na validacao:
    - qual certificado pertence a qual loja;
    - qual CNPJ esta vinculado ao certificado;
    - impedir que uma loja salve ou use o certificado de outra.

- o que foi ajustado:
  - `database/migrations/2026_04_16_203000_add_certificate_identity_to_tb26_configuracoes_fiscais_table.php`
    - adiciona em `tb26_configuracoes_fiscais`:
      - `tb26_certificado_nome`
      - `tb26_certificado_cnpj`
  - `app/Models/ConfiguracaoFiscal.php`
    - fillable atualizado com os novos campos.
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - a tela agora recebe tambem o CNPJ normalizado da loja;
    - passou a salvar `nome do certificado` e `CNPJ do certificado`;
    - antes de gravar, valida se o CNPJ base do certificado e o mesmo CNPJ base da loja selecionada;
    - se nao for, retorna erro no campo `tb26_certificado_cnpj`.
  - `app/Support/FiscalInvoicePreparationService.php`
    - o payload interno da nota agora inclui os dados identificadores do certificado;
    - a validacao fiscal passou a exigir `nome do certificado` e `CNPJ do certificado`;
    - na preparacao da nota, tambem confere se o certificado pertence ao mesmo CNPJ base da loja da venda.
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - adicionados os campos:
      - `Nome do certificado`
      - `CNPJ do certificado`
    - adicionada uma caixa de resumo visual com:
      - loja;
      - CNPJ da loja;
      - nome do certificado;
      - CNPJ do certificado;
      - arquivo vinculado.
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
    - novo cenario cobrindo tentativa de usar certificado de outra loja.

- regra importante:
  - a associacao operacional correta agora e:
    - `loja/unidade -> configuracao fiscal -> certificado proprio`
  - a validacao considera o CNPJ base:
    - se o certificado nao pertencer ao mesmo CNPJ base da loja, a configuracao e bloqueada;
    - se por algum motivo isso escapar, a preparacao da nota tambem marca erro.

- validacao:
  - `php artisan test tests/Unit/FiscalInvoicePreparationServiceTest.php`: ok.
  - `npm run build`: ok.

- arquivos alterados:
  - `database/migrations/2026_04_16_203000_add_certificate_identity_to_tb26_configuracoes_fiscais_table.php`
  - `app/Models/ConfiguracaoFiscal.php`
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalInvoicePreparationService.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - copiar esses arquivos junto com a base fiscal criada anteriormente;
  - aplicar tambem a migration nova `2026_04_16_203000_add_certificate_identity_to_tb26_configuracoes_fiscais_table.php`;
  - ponto critico da sincronizacao:
    - nao copiar so a tela;
    - o controller e o service precisam ir juntos para manter a validacao consistente entre cadastro e preparo da nota.

## 16/04/26 - Inspecao automatica do A1 e XML assinado localmente para NFC-e

- causa do ajuste:
  - a base fiscal ja sabia qual loja e qual certificado deveriam ser usados;
  - faltava transformar isso em algo operacional:
    - abrir o certificado A1;
    - validar senha e identidade do certificado;
    - identificar nome, CNPJ e validade do certificado;
    - gerar XML fiscal assinado localmente;
    - permitir reprocessar notas que ficaram pendentes antes da configuracao completa.
  - tambem ficou claro que `NF-e` modelo `55` ainda nao pode ser emitida automaticamente com a estrutura atual, porque a venda nao armazena destinatario fiscal; por isso a assinatura local desta etapa foi focada em `NFC-e`.

- o que foi criado:
  - `app/Support/FiscalCertificateService.php`
    - novo servico para abrir certificado `A1` (`.pfx`/`.p12`);
    - le o PKCS12 com `openssl`;
    - extrai:
      - certificado publico;
      - chave privada;
      - nome do certificado;
      - CNPJ do certificado;
      - validade;
    - normaliza o certificado para uso em `XMLDSig`.
  - `app/Support/FiscalNfceXmlService.php`
    - novo servico para montar XML `NFC-e` modelo `65`;
    - gera:
      - chave de acesso;
      - bloco `ide`;
      - emitente;
      - itens;
      - impostos basicos;
      - totais;
      - pagamento;
      - informacao adicional;
    - assina o XML localmente com o certificado da loja.
  - `app/Support/FiscalInvoicePreparationService.php`
    - passou a carregar o certificado real da unidade;
    - passou a tentar gerar XML assinado quando a nota for `NFC-e` e estiver validada;
    - status novo:
      - `xml_assinado`
    - adicionada rotina de `reprocessamento` das notas pendentes da unidade;
    - validacao nova:
      - certificado vencido bloqueia;
      - `NF-e` modelo `55` fica com erro explicando que ainda falta destinatario fiscal;
      - nesta etapa a geracao automatica foi preparada para `CRT 1` com `CSOSN 102/103/300/400`.
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - upload do certificado agora exige senha quando necessario;
    - ao enviar o arquivo, o sistema tenta abrir o `A1`;
    - se conseguir:
      - preenche automaticamente nome do certificado;
      - preenche automaticamente CNPJ do certificado;
      - grava a validade;
    - se falhar:
      - remove o arquivo salvo;
      - retorna erro no formulario;
    - nova acao para reprocessar notas pendentes da unidade;
    - nova acao para baixar o XML assinado da nota.
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - mostra validade do certificado no resumo da associacao loja/certificado;
    - adiciona acao `Reprocessar notas pendentes`;
    - exibe botao `Baixar XML` quando a nota ja tem `tb27_xml_envio`.

- banco de dados:
  - `database/migrations/2026_04_16_204000_add_certificate_validity_to_tb26_configuracoes_fiscais_table.php`
    - adiciona `tb26_certificado_valido_ate` em `tb26_configuracoes_fiscais`.

- regras importantes desta etapa:
  - a assinatura local esta preparada para `NFC-e`;
  - `NF-e` modelo `55` continua bloqueada automaticamente ate existir destinatario fiscal na venda;
  - o certificado da loja agora nao e apenas um arquivo salvo:
    - ele e aberto;
    - identificado;
    - validado;
    - e usado para assinar o XML localmente.

- testes e validacao:
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
    - ajustado para o novo fluxo de validacao;
    - continua cobrindo configuracao, produto fiscal e certificado de outra loja.
  - `tests/Unit/FiscalCertificateServiceTest.php`
    - novo teste unitario cobrindo extracao de nome e CNPJ do certificado.
  - `php artisan test tests/Unit/FiscalInvoicePreparationServiceTest.php tests/Unit/FiscalCertificateServiceTest.php`: ok.
  - `npm run build`: ok.
  - `php -l` nos novos servicos/controladores/migrations: ok.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Models/ConfiguracaoFiscal.php`
  - `app/Support/FiscalCertificateService.php`
  - `app/Support/FiscalInvoicePreparationService.php`
  - `app/Support/FiscalNfceXmlService.php`
  - `database/migrations/2026_04_16_204000_add_certificate_validity_to_tb26_configuracoes_fiscais_table.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `routes/web.php`
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
  - `tests/Unit/FiscalCertificateServiceTest.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar esta etapa junto com toda a base fiscal anterior;
  - aplicar tambem:
    - `2026_04_16_204000_add_certificate_validity_to_tb26_configuracoes_fiscais_table.php`
  - ponto critico:
    - `FiscalCertificateService`, `FiscalNfceXmlService` e `FiscalInvoicePreparationService` precisam ir juntos;
    - o controller fiscal tambem precisa ser sincronizado no mesmo pacote, porque agora ele depende da inspecao real do certificado;
    - sem isso, a tela vai salvar o arquivo, mas nao vai preencher identidade/validade nem conseguir assinar o XML.

## 16/04/26 - Transmissao inicial da NFC-e para a SEFAZ com endpoint por UF

- causa do ajuste:
  - a etapa anterior ja deixava a nota em `xml_assinado`, mas ainda faltava o envio real para a SEFAZ;
  - havia tambem dois riscos tecnicos que impediriam a transmissao funcionar corretamente:
    - usar o endpoint `?wsdl` como se fosse URL de envio;
    - montar o lote XML escapado como texto dentro do SOAP, em vez de enviar o XML como nodo valido.

- o que foi criado:
  - `app/Support/FiscalWebserviceResolverService.php`
    - novo servico para resolver os endpoints da NFC-e por `UF` e `ambiente`;
    - nesta etapa o mapeamento inicial foi preparado para `GO`;
    - agora diferencia:
      - URL real de envio;
      - URL do `WSDL`;
      - operacao SOAP de autorizacao.
  - `app/Support/FiscalNfceTransmissionService.php`
    - novo servico para transmissao da `NFC-e`;
    - carrega o certificado da loja;
    - monta o lote `enviNFe`;
    - monta o envelope SOAP com o XML anexado corretamente;
    - envia para o webservice da SEFAZ com `cURL` e certificado `PEM` temporario;
    - interpreta a resposta da autorizacao e atualiza:
      - status;
      - mensagem;
      - recibo;
      - protocolo;
      - chave;
      - XML de retorno;
      - data da emissao.

- ajustes no controller fiscal:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - a listagem da tela passa a receber os endpoints resolvidos da unidade;
    - a tela mostra o endpoint real de envio e tambem o `WSDL`;
    - nova acao para transmitir manualmente uma nota em `xml_assinado`;
    - se a transmissao falhar, o erro volta para a tela como feedback ao usuario em vez de estourar excecao bruta.

- ajustes no frontend:
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - a tabela de notas agora mostra:
      - botao `Baixar XML`;
      - botao `Transmitir` para notas em `xml_assinado`;
    - o resumo da loja/certificado mostra:
      - endpoint de envio;
      - `WSDL` de autorizacao.

- ajustes de rota:
  - `routes/web.php`
    - adicionadas as rotas:
      - `settings.fiscal.reprocess`
      - `settings.fiscal.invoices.xml`
      - `settings.fiscal.invoices.transmit`

- testes e validacao:
  - `tests/Unit/FiscalWebserviceResolverServiceTest.php`
    - novo teste unitario validando:
      - URL de envio sem `?wsdl`;
      - URL do `WSDL` separada;
      - excecao para `UF` ainda nao mapeada.
  - os testes anteriores de certificado e preparacao fiscal continuam sendo executados em conjunto nesta etapa.

- regra importante desta etapa:
  - a transmissao automatica continua focada em `NFC-e`;
  - `NF-e` modelo `55` ainda permanece bloqueada no preparo automatico porque a venda atual nao guarda destinatario fiscal;
  - o mapeamento oficial de endpoint ainda nao cobre todas as `UFs`, entao lojas fora do mapeamento atual vao exibir erro explicito na tela ate que a `UF` seja adicionada no resolver.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalNfceTransmissionService.php`
  - `app/Support/FiscalWebserviceResolverService.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `routes/web.php`
  - `tests/Unit/FiscalWebserviceResolverServiceTest.php`
  - `SYNC.md`

  - observacoes para sincronizar em `pec1`:
  - copiar este pacote junto com toda a base fiscal anterior;
  - ponto critico:
    - o servico de transmissao depende do servico de certificado e do XML assinado localmente;
    - nao adianta sincronizar apenas o botao `Transmitir` da tela;
    - o resolver de endpoint precisa ir junto, porque a transmissao agora nao usa mais a URL `?wsdl` para o `POST`;
    - se a loja do `pec1` estiver em outra `UF`, incluir o novo mapeamento oficial no `FiscalWebserviceResolverService.php` antes de tentar emitir em producao.

## 16/04/26 - Correcao do upload de certificado A1 com MIME generico no Windows

- causa do problema:
  - alguns certificados `A1` validos em `.pfx` estavam sendo enviados corretamente pelo navegador;
  - porem o PHP no Windows identificava esses arquivos com MIME generico `application/octet-stream`;
  - a validacao anterior usava `mimes:pfx,p12`, entao o Laravel rejeitava o upload antes mesmo da inspecao real com `openssl`.

- o que foi ajustado:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - a validacao do campo `tb26_certificado_arquivo_upload` deixou de depender do MIME detectado;
    - agora o backend aceita o upload pela extensao real do arquivo:
      - `.pfx`
      - `.p12`
    - a verificacao pesada do certificado continua sendo feita depois pela inspecao real do arquivo com `FiscalCertificateService`.

- efeito pratico:
  - certificados `A1` validos enviados em Windows nao ficam mais bloqueados por `application/octet-stream`;
  - se o arquivo tiver extensao invalida, continua sendo rejeitado;
  - se a extensao for valida, mas o certificado/senha estiver errado, a falha continua aparecendo na etapa de inspecao real.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar junto com a base fiscal anterior;
  - este ajuste nao substitui a migration fiscal pendente `2026_04_16_204000_add_certificate_validity_to_tb26_configuracoes_fiscais_table.php`, que tambem precisa estar aplicada para o salvamento completo do certificado.

## 16/04/26 - Acoes por linha em `Ultimas notas preparadas`

- causa do ajuste:
  - a tabela `Ultimas notas preparadas` mostrava apenas o estado fiscal e duas acoes tecnicas:
    - `Baixar XML`
    - `Transmitir`
  - no uso diario faltavam duas operacoes importantes:
    - reimprimir o cupom da venda vinculada;
    - regenerar apenas uma nota que ficou com erro, sem precisar reprocessar todas da loja.

- o que foi ajustado:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - a listagem das notas agora monta tambem o payload do cupom por linha;
    - cada nota passa a enviar `receipt` para o frontend;
    - cada nota passa a informar `pode_regenerar` para os status que aceitam nova preparacao;
    - criada a acao `regenerateInvoice()` para reexecutar `prepareForPayment()` somente da nota selecionada.
  - `routes/web.php`
    - adicionada a rota:
      - `settings.fiscal.invoices.regenerate`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - adicionada a coluna `Cupom` com o botao `Imprimir cupom`;
    - adicionada a coluna `Regenerar` com o botao `Regenerar nota`;
    - a impressao reutiliza o HTML padrao de cupom de `resources/js/Utils/receipt.js`;
    - quando o navegador bloquear pop-up, a tela mostra erro visivel.

- regra pratica:
  - `Imprimir cupom` apenas reabre a representacao da venda ja concluida;
  - `Regenerar nota` refaz o preparo fiscal apenas daquela venda;
  - a regeneracao individual fica disponivel para notas com status:
    - `pendente_configuracao`
    - `erro_validacao`
    - `erro_transmissao`
    - `pendente_emissao`

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `routes/web.php`
  - `SYNC.md`

  - observacoes para sincronizar em `pec1`:
  - sincronizar os tres arquivos acima em conjunto;
  - o botao de impressao depende do utilitario ja existente `resources/js/Utils/receipt.js`;
  - se copiar apenas a tela sem o controller, a tabela nao recebera o payload `receipt` e os botoes vao ficar incompletos.

## 16/04/26 - Cadastro de produto bloqueando falta de NCM, CFOP e CSOSN/CST

- causa do problema:
  - o cadastro de produto aceitava salvar campos fiscais essenciais como opcionais;
  - a cobranca desses dados so acontecia depois, na preparacao da nota fiscal;
  - com isso, produtos como `PAO DE SAL` podiam ser cadastrados normalmente e so falhavam no momento da emissao.

- o que foi ajustado:
  - `app/Http/Controllers/ProductController.php`
    - adicionada validacao complementar no backend para bloquear salvamento sem:
      - `NCM`;
      - `CFOP`;
      - pelo menos um entre `CSOSN` ou `CST`.
    - agora o produto nao segue para gravacao se esses dados fiscais minimos estiverem faltando.
  - `resources/js/Pages/Products/ProductCreate.jsx`
    - a secao `Cadastro fiscal` agora destaca visualmente que:
      - `NCM` e `CFOP` sao obrigatorios;
      - `CSOSN` ou `CST` precisam ser informados.
    - adicionados marcadores visuais `*` nos campos fiscais essenciais.
  - `resources/js/Pages/Products/ProductEdit.jsx`
    - recebeu o mesmo reforco visual e obrigatoriedade do cadastro.

- efeito pratico:
  - novos produtos nao poderao mais entrar no sistema sem os dados fiscais minimos exigidos pela emissao;
  - a falha deixa de aparecer so na nota e passa a ser tratada na origem, no cadastro do produto.

- arquivos alterados:
  - `app/Http/Controllers/ProductController.php`
  - `resources/js/Pages/Products/ProductCreate.jsx`
  - `resources/js/Pages/Products/ProductEdit.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar os tres arquivos juntos;
  - este ajuste nao depende de migration;
  - ele apenas endurece a validacao e o formulario para impedir novos produtos fiscalmente incompletos.

## 16/04/26 - NFC-e com `infNFeSupl`, `qrCode` e `urlChave` para corrigir rejeicao de schema

- causa do problema:
  - o gerador de XML da `NFC-e` montava `ide`, `emit`, `det`, `total`, `pag` e assinatura;
  - porem o XML estava saindo sem o bloco suplementar `infNFeSupl`;
  - para `NFC-e`, esse bloco carrega `qrCode` e `urlChave`, e sua ausencia deixava o documento incompleto para o leiaute esperado pela SEFAZ;
  - como efeito pratico, notas como a `#20145` podiam chegar ao envio e retornar `Falha no Schema XML do lote de NFe`.

- o que foi ajustado:
  - `app/Support/FiscalNfceXmlService.php`
    - passou a depender de `FiscalWebserviceResolverService`;
    - agora resolve os enderecos oficiais da `UF` antes de finalizar o XML;
    - adiciona o bloco `infNFeSupl` dentro da `NFe`;
    - preenche:
      - `qrCode`
      - `urlChave`
    - o `qrCode` foi montado no formato simplificado da versao `3` para emissao `on-line`:
      - `...?p=<chave_acesso>|3|<tpAmb>`
  - `app/Support/FiscalWebserviceResolverService.php`
    - manteve a URL de consulta por `QR Code` da `NFC-e`;
    - passou a diferenciar a URL de consulta por chave (`urlChave`) da URL do `qrCode`;
    - para `GO`, `urlChave` agora aponta para `.../sites/nfe/consulta-completa`.
  - `tests/Unit/FiscalWebserviceResolverServiceTest.php`
    - passou a validar tambem `qr_code_url` e `consultation_url`.
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
    - novo teste cobrindo a criacao de `infNFeSupl` com `qrCode` e `urlChave`.
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
    - ajustado para a nova dependencia do gerador de XML.

- efeito pratico:
  - a `NFC-e` agora sai com a parte suplementar esperada pelo leiaute;
  - o XML assinado fica estruturalmente mais proximo do padrao exigido para transmissao;
  - isso ataca diretamente a causa mais provavel da rejeicao de schema observada no envio.

- validacao:
  - `php -l app/Support/FiscalNfceXmlService.php`: ok.
  - `php -l app/Support/FiscalWebserviceResolverService.php`: ok.
  - `php artisan test tests/Unit/FiscalWebserviceResolverServiceTest.php tests/Unit/FiscalNfceXmlServiceTest.php tests/Unit/FiscalInvoicePreparationServiceTest.php`: ok.

- arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `app/Support/FiscalWebserviceResolverService.php`
  - `tests/Unit/FiscalWebserviceResolverServiceTest.php`
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
  - `SYNC.md`

- arquivos criados:
  - `tests/Unit/FiscalNfceXmlServiceTest.php`

- observacoes para sincronizar em `pec1`:
  - sincronizar estes arquivos em conjunto;
  - ponto critico:
    - se copiar apenas o `FiscalNfceXmlService.php` sem o `FiscalWebserviceResolverService.php`, o XML vai tentar buscar chaves de endpoint que ainda nao existem;
    - se copiar apenas o resolver sem o XML service, o sistema continua transmitindo a `NFC-e` sem `infNFeSupl`;
  - depois da sincronizacao, reprocessar a nota que falhou para que um novo XML seja gerado com `qrCode` e `urlChave`.

## 16/04/26 - Endurecimento do XML da NFC-e contra rejeicao de schema

- causa do ajuste:
  - mesmo apos incluir `infNFeSupl`, a SEFAZ continuou retornando `Falha no Schema XML do lote de NFe`;
  - isso indicou que o XML ainda podia conter algum campo estruturalmente valido na interface, mas invalido no schema:
    - campos numericos com mascara em cadastros antigos;
    - `CEP`, `cMun`, `NCM`, `CEST` e `CFOP` enviados sem saneamento final no momento da geracao do XML;
    - retorno da SEFAZ ainda muito generico, sem destacar o `cStat`.

- o que foi ajustado:
  - `app/Support/FiscalNfceXmlService.php`
    - passou a normalizar novamente, na hora de gerar o XML, os campos sensiveis ao schema;
    - agora `cMunFG`, `cMun`, `CEP`, `NCM`, `CEST`, `CFOP` e `orig` sao tratados para sair sem mascara;
    - quando algum desses campos obrigatorios nao fecha exatamente no tamanho fiscal esperado, o service interrompe a geracao com erro explicito antes do envio;
    - isso protege tambem notas geradas a partir de cadastros antigos que ja estavam salvos com mascara.
  - `app/Support/FiscalNfceTransmissionService.php`
    - melhorado o parse da resposta para incluir o `cStat` na mensagem final;
    - quando existir `SOAP Fault`, a razao do fault passa a ser considerada no texto de erro.
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
    - novo cenario cobrindo normalizacao de `cMun`, `CEP`, `NCM`, `CEST` e `CFOP`.
  - `tests/Unit/FiscalNfceTransmissionServiceTest.php`
    - novo teste cobrindo a mensagem de erro com prefixo `cStat`.

- efeito pratico:
  - o XML da `NFC-e` fica mais resistente a rejeicoes de schema causadas por mascara ou formato salvo em registros antigos;
  - quando a SEFAZ rejeitar novamente, a mensagem salva no sistema fica mais diagnostica.

- validacao:
  - `php -l app/Support/FiscalNfceXmlService.php`: ok.
  - `php -l app/Support/FiscalNfceTransmissionService.php`: ok.
  - `php -l tests/Unit/FiscalNfceXmlServiceTest.php`: ok.
  - `php -l tests/Unit/FiscalNfceTransmissionServiceTest.php`: ok.
  - `php artisan test tests/Unit/FiscalWebserviceResolverServiceTest.php tests/Unit/FiscalNfceXmlServiceTest.php tests/Unit/FiscalNfceTransmissionServiceTest.php tests/Unit/FiscalInvoicePreparationServiceTest.php`: ok.

- arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `app/Support/FiscalNfceTransmissionService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
  - `SYNC.md`

- arquivos criados:
  - `tests/Unit/FiscalNfceTransmissionServiceTest.php`

- observacoes para sincronizar em `pec1`:
  - sincronizar estes arquivos junto com as etapas fiscais anteriores;
  - depois da sincronizacao, regenerar a nota com erro para que o XML seja montado novamente com os campos saneados;
  - se ainda houver rejeicao `225`, o sistema agora deve devolver uma mensagem mais informativa para a proxima investigacao.

## 17/04/26 - Travamento de UF x codigo IBGE e correcao pontual da configuracao fiscal da loja

- causa do problema:
  - ao inspecionar o XML real da nota `#20145`, foi confirmado que a emissao estava em `homologacao`, mas com dados geograficos inconsistentes;
  - a configuracao fiscal da loja estava assim:
    - `UF = GO`
    - `municipio = AGUAS LINDAS`
    - `codigo_municipio = 5300108`
  - o codigo `5300108` pertence a `Brasilia/DF`, nao a `Aguas Lindas de Goias/GO`;
  - isso fazia a nota sair com:
    - `cUF = 53`
    - `cMun = 5300108`
    - endpoint de `GO/homologacao`
  - essa mistura de `UF/IBGE` foi a primeira inconsistencia concreta confirmada no XML salvo da nota rejeitada.

- o que foi ajustado no codigo:
  - `app/Support/FiscalMunicipalityCodeService.php`
    - novo servico com o mapa de prefixos IBGE por `UF`;
    - usado para conferir se os 2 primeiros digitos do codigo do municipio pertencem a `UF` informada.
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - antes de salvar a configuracao fiscal, agora valida a combinacao:
      - `tb26_uf`
      - `tb26_codigo_municipio`
    - se o codigo nao pertencer a `UF`, o salvamento e bloqueado com mensagem explicita.
  - `app/Support/FiscalInvoicePreparationService.php`
    - a preparacao da nota tambem passou a validar essa compatibilidade;
    - isso protege notas geradas a partir de configuracoes antigas que ja estavam erradas no banco.
  - `tests/Unit/FiscalMunicipalityCodeServiceTest.php`
    - novo teste cobrindo a regra do prefixo IBGE por `UF`.
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
    - novo cenario cobrindo configuracao com `GO` + codigo de municipio de `DF`.

- correcao aplicada diretamente no banco deste projeto:
  - configuracao fiscal `tb26_id = 1` / loja `tb2_id = 3`
    - `tb26_codigo_municipio`: de `5300108` para `5200258`
    - `tb26_municipio`: de `AGUAS LINDAS` para `AGUAS LINDAS DE GOIAS`
  - esta foi uma correcao de dado, nao de estrutura;
  - por isso nao foi criada migration nova.

- efeito pratico:
  - a nota `#20145` foi reprocessada apos a correcao de dados;
  - ela voltou para status `xml_assinado`;
  - o novo XML ficou com:
    - `cUF = 52`
    - `cMunFG = 5200258`
    - `cMun = 5200258`
    - `xMun = AGUAS LINDAS DE GOIAS`

- validacao:
  - `php -l app/Support/FiscalMunicipalityCodeService.php`: ok.
  - `php -l app/Http/Controllers/FiscalConfigurationController.php`: ok.
  - `php -l app/Support/FiscalInvoicePreparationService.php`: ok.
  - `php -l tests/Unit/FiscalMunicipalityCodeServiceTest.php`: ok.
  - `php -l tests/Unit/FiscalInvoicePreparationServiceTest.php`: ok.
  - `php artisan test tests/Unit/FiscalMunicipalityCodeServiceTest.php tests/Unit/FiscalInvoicePreparationServiceTest.php tests/Unit/FiscalWebserviceResolverServiceTest.php tests/Unit/FiscalNfceXmlServiceTest.php tests/Unit/FiscalNfceTransmissionServiceTest.php`: ok.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalInvoicePreparationService.php`
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
  - `SYNC.md`

- arquivos criados:
  - `app/Support/FiscalMunicipalityCodeService.php`
  - `tests/Unit/FiscalMunicipalityCodeServiceTest.php`

- observacoes para sincronizar em `pec1`:
  - sincronizar os arquivos de codigo acima;
  - no banco do `pec1`, verificar se existe configuracao fiscal com `UF` diferente do prefixo do codigo IBGE;
  - se houver loja equivalente a esta:
    - corrigir `tb26_codigo_municipio` para `5200258`
    - corrigir `tb26_municipio` para `AGUAS LINDAS DE GOIAS`
  - depois da sincronizacao, reprocessar as notas fiscais pendentes/erro da loja para gerar XML novo com o municipio correto.

## 17/04/26 - Normalizacao da inscricao estadual do emitente para evitar schema 225

- causa do problema:
  - mesmo apos corrigir `UF` e `codigo_municipio`, a nota `#20145` continuou retornando `cStat 225`;
  - ao inspecionar o XML real salvo da nota, foi confirmado que o campo `IE` do emitente ainda estava saindo com mascara:
    - `20.303.012-5`
  - a documentacao oficial da NF-e indica que a `IE` do emitente deve ser enviada apenas com algarismos, sem pontuacao, ou com a literal `ISENTO` quando aplicavel;
  - isso mantinha o XML sujeito a rejeicao por schema.

- o que foi ajustado no codigo:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - o campo `tb26_ie` agora e normalizado no salvamento;
    - se vier como `ISENTO`, preserva `ISENTO`;
    - se vier com mascara, salva apenas os digitos.
  - `app/Support/FiscalNfceXmlService.php`
    - o XML da `NFC-e` agora nunca envia `IE` com pontuacao;
    - se a inscricao estadual estiver invalida, a geracao para antes do envio com erro explicito.
  - `app/Support/FiscalInvoicePreparationService.php`
    - a preparacao da nota passou a validar a `IE` da unidade;
    - aceita:
      - apenas digitos com 2 a 14 posicoes;
      - ou `ISENTO`.
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
    - passou a validar que `IE` com mascara e serializada no XML sem pontuacao.
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
    - novo cenario cobrindo `IE` invalida na configuracao fiscal.

- correcao aplicada diretamente no banco deste projeto:
  - configuracao fiscal `tb26_id = 1` / loja `tb2_id = 3`
    - `tb26_ie`: de `20.303.012-5` para `203030125`
  - apos isso, a nota `#20145` foi reprocessada para gerar novo XML com `IE` sem mascara.

- efeito pratico:
  - a configuracao fiscal passa a armazenar `IE` em formato compativel com o schema;
  - notas novas e reprocessadas nao herdam mais pontuacao antiga no campo do emitente;
  - a investigacao da `#20145` ficou mais objetiva, porque o XML regenerado agora elimina mais uma causa concreta de schema.

- validacao:
  - `php -l app/Http/Controllers/FiscalConfigurationController.php`: ok.
  - `php -l app/Support/FiscalNfceXmlService.php`: ok.
  - `php -l app/Support/FiscalInvoicePreparationService.php`: ok.
  - `php -l tests/Unit/FiscalNfceXmlServiceTest.php`: ok.
  - `php -l tests/Unit/FiscalInvoicePreparationServiceTest.php`: ok.
  - `php artisan test tests/Unit/FiscalMunicipalityCodeServiceTest.php tests/Unit/FiscalInvoicePreparationServiceTest.php tests/Unit/FiscalWebserviceResolverServiceTest.php tests/Unit/FiscalNfceXmlServiceTest.php tests/Unit/FiscalNfceTransmissionServiceTest.php`: ok.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalNfceXmlService.php`
  - `app/Support/FiscalInvoicePreparationService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
  - `tests/Unit/FiscalInvoicePreparationServiceTest.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar os arquivos acima junto com a blindagem de `UF x codigo IBGE`;
  - no banco do `pec1`, verificar se a `IE` da configuracao fiscal da loja equivalente tambem esta com mascara;
  - se estiver, remover a pontuacao antes de reprocessar as notas fiscais pendentes/erro.

## 17/04/26 - Ajuste do bloco de pagamento fiscal para `maquina`, `vale` e `refeicao`

- causa do problema:
  - depois de corrigir `UF`, `codigo IBGE` e `IE`, o `cStat 225` da nota `#20145` continuou;
  - ao inspecionar o XML real da nota, foi confirmado que:
    - a venda estava com `tipo_pagamento = maquina`;
    - o XML estava saindo com `<tPag>99</tPag>` e sem `<xPag>`;
  - alem disso, pagamentos `vale` tambem caiam no fallback generico `99`, em vez de usar o codigo fiscal proprio.

- o que foi ajustado:
  - `app/Support/FiscalNfceXmlService.php`
    - o bloco `pag/detPag` deixou de usar apenas um resolvedor de codigo simples;
    - agora existe um resolvedor completo de pagamento fiscal com:
      - codigo (`tPag`);
      - descricao (`xPag`) quando necessaria.
    - mapeamento aplicado:
      - `dinheiro` -> `01`
      - `vale` -> `10`
      - `refeicao` -> `11`
      - `faturar` -> `90`
      - `maquina` -> `99` com `xPag = MAQUINA`
      - tipos desconhecidos -> `99` com `xPag` gerado a partir do nome informado.
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
    - novo cenario cobrindo:
      - `maquina` gerando `tPag 99` com `xPag`;
      - `vale` gerando `tPag 10` sem `xPag`.

- efeito pratico:
  - o XML fiscal deixa de usar fallback generico silencioso para meios de pagamento conhecidos;
  - o grupo de pagamento fica mais aderente ao leiaute fiscal atual, especialmente nos casos em que o sistema interno usa o label `maquina`.

- validacao:
  - `php -l app/Support/FiscalNfceXmlService.php`: ok.
  - `php -l tests/Unit/FiscalNfceXmlServiceTest.php`: ok.
  - `php artisan test tests/Unit/FiscalMunicipalityCodeServiceTest.php tests/Unit/FiscalInvoicePreparationServiceTest.php tests/Unit/FiscalWebserviceResolverServiceTest.php tests/Unit/FiscalNfceXmlServiceTest.php tests/Unit/FiscalNfceTransmissionServiceTest.php`: ok.

- arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar este ajuste junto com as correcoes anteriores do XML fiscal;
  - depois da sincronizacao, reprocessar notas emitidas com `tipo_pagamento = maquina` para que o novo `detPag` seja reconstruido no XML.

## 17/04/26 - Correcao da ordem `Signature` x `infNFeSupl` na raiz da NFC-e

- causa do problema:
  - mesmo depois de corrigir `UF`, `codigo IBGE`, `IE` e o bloco de pagamento, a nota `#20145` continuou retornando `cStat 225`;
  - ao revisar o gerador do XML da `NFC-e`, foi identificado um detalhe estrutural na raiz do documento `NFe`;
  - o fluxo estava montando a raiz nesta ordem:
    - `infNFe`
    - `infNFeSupl`
    - `Signature`
  - para a `NFC-e`, esse tipo de inversao entre a assinatura digital e o bloco suplementar e um candidato forte a rejeicao de schema, porque a ordem dos nos faz parte do leiaute validado pela SEFAZ.

- o que foi ajustado:
  - `app/Support/FiscalNfceXmlService.php`
    - a assinatura digital agora e anexada antes do bloco suplementar;
    - a raiz do `NFe` passa a ser montada nesta ordem:
      - `infNFe`
      - `Signature`
      - `infNFeSupl`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
    - novo teste cobrindo explicitamente a ordem dos nos da raiz do `NFe`;
    - o teste garante que `infNFeSupl` nunca mais fique antes de `Signature`.

- efeito pratico:
  - o XML assinado da `NFC-e` fica mais aderente ao leiaute estrutural esperado;
  - isso ataca um ponto tipico de rejeicao `225` que nao aparece na interface e nem nos dados cadastrais.

- validacao:
  - pendente reprocessar e retransmitir a nota `#20145` assim que a conexao com o banco externo responder novamente;
  - o teste unitario passou a proteger a ordem correta do XML em nivel de codigo.

- arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar estes arquivos junto com as etapas fiscais anteriores;
  - depois da sincronizacao, reprocessar qualquer nota `NFC-e` que tenha sido gerada antes desta correcao, porque o XML antigo continua com a ordem estrutural errada.

## 17/04/26 - Botao `Cupom R$0,00` com DANFE NFC-e 80mm em `settings/fiscal`

- causa do ajuste:
  - na lista `Ultimas notas preparadas`, o botao ainda usava o utilitario de recibo interno da venda;
  - isso fazia o clique abrir apenas um comprovante simples, sem estrutura fiscal, sem chave de acesso e sem `QR Code`;
  - alem disso, o rotulo do botao nao mostrava o valor da nota.

- o que foi ajustado:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - a listagem das notas passou a enviar:
      - `total` da nota;
      - `protocolo`;
      - `recibo`;
      - payload `fiscal_receipt` proprio da nota fiscal;
    - criado um montador especifico para cupom fiscal 80mm;
    - o payload fiscal agora inclui:
      - emitente;
      - endereco;
      - CNPJ;
      - IE;
      - serie e numero;
      - ambiente;
      - status;
      - itens;
      - total;
      - chave de acesso;
      - protocolo;
      - recibo;
      - `qrCode` e `urlChave` extraidos do XML assinado.
  - `resources/js/Utils/receipt.js`
    - mantido o recibo interno antigo para as outras telas;
    - criado `buildFiscalReceiptHtml()` para imprimir um cupom fiscal estilo `DANFE NFC-e` em largura `80mm`;
    - o HTML fiscal mostra:
      - cabecalho fiscal;
      - emitente;
      - itens;
      - pagamento;
      - total;
      - chave de acesso;
      - `QR Code`;
      - observacao de previa quando a nota ainda nao estiver autorizada.
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - o botao deixou de se chamar `Imprimir cupom`;
    - agora o rotulo segue o formato:
      - `Cupom R$ 0,00`
    - o clique passou a abrir o cupom fiscal da nota, nao o recibo interno da venda;
    - a rotina de impressao foi ajustada para deixar o proprio HTML fiscal controlar o momento da impressao.

- efeito pratico:
  - a area fiscal passa a imprimir um cupom muito mais proximo do que se espera de uma `NFC-e` em impressora `80mm`;
  - o botao ja mostra o valor da nota na propria lista;
  - notas ainda nao autorizadas continuam imprimiveis como previa fiscal para conferencia.

- validacao:
  - validar com:
    - `php -l app/Http/Controllers/FiscalConfigurationController.php`
    - `cmd /c npm run build`
  - recomendacao pratica:
    - abrir `settings/fiscal`;
    - clicar em um `Cupom R$...`;
    - conferir impressao em navegador e impressora `80mm`.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `resources/js/Utils/receipt.js`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar os tres arquivos juntos;
  - se copiar apenas a tela sem o controller, o frontend nao recebera o payload `fiscal_receipt`;
  - se copiar apenas o controller sem o novo utilitario, o botao vai existir mas a impressao fiscal nao sera montada.

## 17/04/26 - Item `Transmitir` no dropdown do dashboard com modal de notas pendentes

- causa do ajuste:
  - o dropdown do dashboard mostrava apenas atalhos estaticos;
  - nao existia nenhum resumo imediato das notas prontas para transmissao;
  - para transmitir uma nota fiscal, o usuario precisava navegar manualmente ate `settings/fiscal` e localizar a nota na lista.

- o que foi ajustado:
  - `app/Http/Middleware/HandleInertiaRequests.php`
    - passou a compartilhar globalmente um resumo das notas com status `xml_assinado`;
    - o resumo e limitado ao escopo das lojas que o usuario administrador pode gerenciar;
    - cada item compartilhado inclui:
      - loja;
      - venda;
      - modelo;
      - serie/numero;
      - valor;
      - data;
      - status;
      - mensagem;
      - rota para `Transmitir`;
      - rota para abrir `settings/fiscal`.
  - `resources/js/Layouts/AuthenticatedLayout.jsx`
    - adicionado no dropdown desktop o item:
      - `Transmitir (N)`
    - adicionado o mesmo atalho no menu mobile;
    - ao clicar, abre uma modal global com a lista das notas pendentes para transmissao;
    - cada registro da modal possui:
      - dados resumidos da nota;
      - botao `Abrir fiscal`;
      - botao `Transmitir`.

- regra aplicada:
  - o resumo so aparece para perfis administrativos (`MASTER` e `GERENTE`);
  - entram na fila apenas notas com status `xml_assinado`, ou seja, ja prontas para envio;
  - `MASTER` enxerga todas as lojas;
  - `GERENTE` enxerga apenas as lojas dentro do proprio escopo de gestao.

- efeito pratico:
  - o dashboard passa a funcionar tambem como painel rapido de transmissao fiscal;
  - o usuario nao precisa mais sair do fluxo principal para descobrir quantas notas estao pendentes de envio;
  - a transmissao continua reaproveitando a mesma rota fiscal ja existente, sem duplicar logica.

- validacao:
  - validar com:
    - `php -l app/Http/Middleware/HandleInertiaRequests.php`
    - `cmd /c npm run build`
  - conferir visualmente:
    - dropdown desktop;
    - menu mobile;
    - abertura da modal;
    - clique em `Transmitir`.

- arquivos alterados:
  - `app/Http/Middleware/HandleInertiaRequests.php`
  - `resources/js/Layouts/AuthenticatedLayout.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar os dois arquivos de codigo juntos;
  - se copiar apenas o layout sem o middleware, o item `Transmitir` aparecera sem dados;
  - se copiar apenas o middleware sem o layout, o resumo global sera enviado mas nao sera exibido no menu.

## 17/04/26 - Correcao do caminho de armazenamento do certificado fiscal

- causa do problema:
  - ao regenerar a nota, o sistema retornava:
    - `Arquivo do certificado nao encontrado no armazenamento local.`
  - a investigacao mostrou que o disco `local` ja aponta para `storage/app/private`;
  - porem o upload do certificado estava sendo salvo com o prefixo:
    - `private/fiscal-certificados/...`
  - isso criava um caminho redundante dentro do proprio disco:
    - `storage/app/private/private/fiscal-certificados/...`
  - alem disso, lojas com configuracao antiga poderiam ficar com o path legado salvo no banco.

- o que foi ajustado:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - o upload do certificado passou a salvar no caminho correto do disco `local`:
      - `fiscal-certificados/<tb2_id>/...`
    - com isso, o arquivo deixa de cair no subdiretorio redundante `private/private`.
  - `app/Support/FiscalCertificateService.php`
    - a leitura do certificado passou a aceitar:
      - caminho novo: `fiscal-certificados/...`
      - caminho legado: `private/fiscal-certificados/...`
    - isso preserva compatibilidade com configuracoes antigas ja gravadas no banco;
    - a mensagem de erro de arquivo ausente agora inclui o caminho fiscal salvo para facilitar o diagnostico.
  - `tests/Unit/FiscalCertificateServiceTest.php`
    - novo teste cobrindo a resolucao do path atual e do legado para o mesmo arquivo no storage.

- efeito pratico:
  - novos uploads ficam salvos no lugar correto;
  - leituras antigas nao quebram por causa da mudanca de prefixo;
  - quando o arquivo realmente nao existir no storage, o erro fica mais objetivo.

- validacao:
  - validar com:
    - `php -l app/Http/Controllers/FiscalConfigurationController.php`
    - `php -l app/Support/FiscalCertificateService.php`
    - `php artisan test tests/Unit/FiscalCertificateServiceTest.php`
  - observacao operacional:
    - se a configuracao fiscal apontar para um arquivo inexistente de fato, sera necessario reenviar o certificado da loja para repor o arquivo fisico.

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalCertificateService.php`
  - `tests/Unit/FiscalCertificateServiceTest.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar estes arquivos em conjunto;
  - se o `pec1` ja tiver configuracoes gravadas com prefixo `private/`, o novo service continua aceitando;
  - para novos uploads no `pec1`, o caminho salvo passara a ser o formato corrigido sem o prefixo duplicado.

## 17/04/26 - Reposicao do arquivo fisico do certificado da loja 3 e regeneracao da venda `20145`

- causa do problema:
  - mesmo apos a correcao de codigo do caminho fiscal, a venda `20145` continuava falhando ao regenerar;
  - a configuracao fiscal da loja `tb2_id = 3` apontava para:
    - `private/fiscal-certificados/3/certificado-20260416164839.pfx`
  - porem o arquivo fisico nao existia no storage local da aplicacao;
  - o unico `.pfx` disponivel no ambiente estava na raiz do projeto.

- o que foi corrigido diretamente neste ambiente:
  - copiado o arquivo:
    - `PAOECAFEBARRAGEM01LTDA_12345678.pfx`
  - para os caminhos:
    - `storage/app/private/fiscal-certificados/3/certificado-20260416164839.pfx`
    - `storage/app/private/private/fiscal-certificados/3/certificado-20260416164839.pfx`
  - o segundo caminho foi mantido apenas como compatibilidade imediata com o path legado salvo no banco.

- ajuste de dado aplicado no banco deste projeto:
  - configuracao fiscal da loja `tb2_id = 3`
    - `tb26_certificado_arquivo`:
      - de `private/fiscal-certificados/3/certificado-20260416164839.pfx`
      - para `fiscal-certificados/3/certificado-20260416164839.pfx`

- validacao executada:
  - a configuracao da loja voltou a abrir o certificado com sucesso;
  - leitura confirmada do certificado:
    - CNPJ: `62074417000156`
    - nome: `PAO E CAFE BARRAGEM 01 LTDA:62074417000156`
  - a venda `20145` foi reprocessada no fluxo real;
  - a nota fiscal vinculada voltou para:
    - `xml_assinado`
    - mensagem: `XML fiscal assinado localmente e aguardando transmissao para a SEFAZ.`

- efeito pratico:
  - o erro `Arquivo do certificado nao encontrado no armazenamento local` deixou de bloquear a regeneracao da nota desta loja;
  - a proxima etapa operacional volta a ser a transmissao da nota.

- arquivos alterados nesta correcao operacional:
  - `SYNC.md`

- arquivos criados/copied no ambiente:
  - `storage/app/private/fiscal-certificados/3/certificado-20260416164839.pfx`
  - `storage/app/private/private/fiscal-certificados/3/certificado-20260416164839.pfx`

- observacoes para sincronizar em `pec1`:
  - alem do codigo, verificar se o arquivo fisico do certificado tambem existe no storage do `pec1`;
  - se o banco do `pec1` apontar para um `.pfx` inexistente, repor o arquivo antes de tentar regenerar as notas;
  - se houver o mesmo certificado em local externo ao storage, copiar para `storage/app/private/fiscal-certificados/<tb2_id>/...` e alinhar `tb26_certificado_arquivo` para o caminho sem o prefixo legado `private/`.

## 17/04/26 - Blindagem de producao para `settings/fiscal` e rotas moveis ausentes

- causa do problema:
  - apos o deploy em producao, a tela `settings/fiscal` retornava `500 Server Error`;
  - havia dois pontos de risco:
    - o layout global passou a consultar `tb27_notas_fiscais` em toda requisicao autenticada para alimentar o item `Transmitir` do dropdown;
    - o proprio controller fiscal assume que as tabelas `tb26_configuracoes_fiscais` e `tb27_notas_fiscais` ja existem no banco;
  - se o deploy subir o codigo antes de aplicar as migrations fiscais, qualquer uma dessas consultas pode derrubar a aplicacao;
  - alem disso, `routes/web.php` referenciava `MobileRevenueController`, mas esse controller nao existe no projeto atual, o que pode quebrar `route:list`, cache de rotas e alguns processos de deploy.

- o que foi ajustado:
  - `app/Http/Middleware/HandleInertiaRequests.php`
    - a montagem de `pendingFiscalTransmissions` agora verifica antes se as tabelas fiscais existem;
    - se a base fiscal ainda nao estiver pronta, retorna `count = 0` e `items = []` sem derrubar a aplicacao;
    - tambem foi adicionada protecao com `try/catch` para evitar `500` em falhas de banco nessa etapa global.
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - a acao `index()` agora verifica se as tabelas fiscais ja existem;
    - se nao existirem, a tela continua abrindo sem `500`;
    - nesse caso, ela renderiza a pagina com listas vazias e uma mensagem explicando que as migrations fiscais ainda nao foram aplicadas no ambiente.
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - passou a exibir a mensagem amigavel de indisponibilidade da base fiscal quando o backend detectar ambiente sem as tabelas novas.
  - `routes/web.php`
    - as rotas de `MobileRevenueController` passaram a ser registradas apenas se a classe realmente existir no projeto;
    - isso impede que um controller ausente quebre `route:list` e etapas de deploy/caching.

- efeito pratico:
  - `settings/fiscal` deixa de cair com `500` quando o deploy sobe antes das migrations fiscais;
  - o dropdown global continua funcionando mesmo sem a base fiscal pronta;
  - o projeto deixa de depender da existencia do `MobileRevenueController` para montar as rotas.

- validacao:
  - validar com:
    - `php -l app/Http/Middleware/HandleInertiaRequests.php`
    - `php -l app/Http/Controllers/FiscalConfigurationController.php`
    - `php -l routes/web.php`
    - `cmd /c npm run build`

- arquivos alterados:
  - `app/Http/Middleware/HandleInertiaRequests.php`
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `routes/web.php`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar estes arquivos em conjunto;
  - esta blindagem nao substitui a necessidade de aplicar as migrations fiscais em producao;
  - ela apenas evita que a interface inteira caia enquanto o banco ainda nao foi atualizado.

## 17/04/26 - Blindagem adicional de `settings/fiscal` contra XML invalido e ausencia de `dom/xml`

- causa do problema:
  - mesmo com a protecao para tabelas ausentes, `settings/fiscal` ainda podia retornar `500` em producao;
  - o controller passou a montar o cupom fiscal de cada nota ao abrir a tela;
  - isso depende de:
    - `DOMDocument`;
    - `DOMXPath`;
    - XML fiscal valido em `tb27_xml_envio`;
  - se o servidor estiver sem a extensao `dom/xml` ou se uma unica nota tiver XML corrompido, a tela inteira podia cair.

- o que foi ajustado:
  - `app/Http/Controllers/FiscalConfigurationController.php`
    - o carregamento da lista de notas passou a ficar dentro de `try/catch`;
    - se houver falha ao carregar a listagem fiscal, a tela continua abrindo e recebe um aviso amigavel;
    - cada nota agora e montada por um metodo isolado;
    - a construcao do `fiscal_receipt` de cada linha tambem fica protegida por `try/catch`, impedindo que uma nota quebrada derrube toda a tela;
    - `extractFiscalReceiptXmlData()` agora retorna vazio imediatamente quando `DOMDocument` ou `DOMXPath` nao existirem no ambiente.
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
    - passou a exibir `invoiceLoadWarning` quando o backend conseguir abrir a tela, mas nao conseguir montar com seguranca a listagem fiscal completa.

- efeito pratico:
  - a tela `settings/fiscal` continua abrindo em producao mesmo se:
    - o PHP estiver sem `dom/xml`;
    - alguma nota tiver XML invalido;
    - a montagem do cupom fiscal falhar em uma ou mais linhas.
  - nesses casos, o impacto fica restrito ao cupom/listagem, sem derrubar a pagina toda.

- validacao:
  - validar com:
    - `php -l app/Http/Controllers/FiscalConfigurationController.php`
    - `cmd /c npm run build`

- arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `SYNC.md`

- observacoes para sincronizar em `pec1`:
  - sincronizar estes arquivos junto com as blindagens anteriores de producao;
  - essa camada nao corrige o XML ruim em si, apenas impede que ele derrube a interface.
## 17/04/26 - Blindagem do salvamento fiscal em producao contra 500 no upload do certificado

- Arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalCertificateService.php`

- Causa identificada:
  - em producao, o `settings/fiscal` ainda podia retornar `500` ao salvar a configuracao do certificado quando o ambiente falhasse em pontos como `OpenSSL`, escrita no storage local ou persistencia da configuracao fiscal;
  - a tela ja estava blindada no `GET`, mas o `POST` de salvamento ainda podia deixar a excecao escapar como erro interno;
  - se a extensao `OpenSSL` nao estiver disponivel no servidor, a leitura do `.pfx/.p12` via `openssl_pkcs12_read()` poderia falhar de forma estrutural no ambiente.

- O que foi feito:
  - `FiscalCertificateService` agora verifica explicitamente se as funcoes `openssl_pkcs12_read` e `openssl_x509_parse` existem antes de tentar ler o certificado;
  - quando `OpenSSL` nao estiver disponivel, o sistema passa a retornar uma mensagem controlada: `A extensao OpenSSL nao esta disponivel neste ambiente para ler o certificado digital.`;
  - `FiscalConfigurationController@update` foi blindado com `try/catch` amplo no fluxo de salvamento;
  - `ValidationException` continua subindo normalmente para manter mensagens de formulario;
  - falhas inesperadas de ambiente agora sao registradas com `report($exception)` e redirecionam de volta para `settings/fiscal` com mensagem amigavel, evitando `500` bruto na gravacao.

- Efeito esperado em producao:
  - salvar o certificado nao deve mais derrubar a rota com erro interno visivel ao usuario;
  - se o problema for `OpenSSL`, storage local ou divergencia de banco, a tela deve permanecer aberta e exibir erro amigavel;
  - a excecao continua registrada no log do Laravel/Azure para diagnostico fino do ambiente.

- Observacao para sincronizacao com `pec1`:
  - copiar exatamente essa blindagem do `update()` e da verificacao de `OpenSSL`, porque ela depende do mesmo fluxo de upload do certificado e reduz muito a dificuldade de diagnosticar falhas de producao.
## 17/04/26 - Diagnostico visual de banco, storage e leitura da senha do certificado em settings/fiscal

- Arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`

- Causa identificada:
  - local e producao usam o mesmo banco, mas o comportamento fiscal pode divergir porque o certificado fisico fica no storage local de cada ambiente e a senha do certificado depende da `APP_KEY` para descriptografia;
  - a tela fiscal ainda lia `tb26_certificado_senha` pelo cast `encrypted`, o que pode falhar em producao se a `APP_KEY` nao coincidir com a do ambiente que gravou a senha;
  - isso podia fazer a pagina cair para o modo minimo, dando a impressao de que os dados nao foram gravados mesmo quando o registro existia no banco.

- O que foi feito:
  - `FiscalConfigurationController` agora envia um bloco `configurationDiagnostics` para a tela fiscal;
  - o diagnostico informa:
    - unidade selecionada;
    - se a configuracao foi encontrada no banco;
    - `tb26_id`;
    - caminho salvo do certificado;
    - se o arquivo existe no storage deste ambiente;
    - se existe no caminho legado `private/...`;
    - se ha senha criptografada salva no banco;
    - se a senha conseguiu ou nao ser lida neste ambiente;
  - `buildFiscalConfigurationPayload()` deixou de depender diretamente da leitura descriptografada para montar `has_certificate_password`;
  - foi criada uma leitura segura da senha criptografada usando `getRawOriginal('tb26_certificado_senha')` para evitar derrubar a tela so por divergencia de `APP_KEY`;
  - `FiscalConfig.jsx` agora mostra um card `Diagnostico do ambiente` logo abaixo do resumo do certificado.

- Efeito esperado:
  - em producao, a propria tela deve mostrar se o problema esta no banco, no storage do certificado ou na leitura da senha criptografada;
  - isso ajuda a diferenciar claramente:
    - registro salvo no banco mas arquivo ausente no Azure;
    - senha gravada no banco mas ilegivel por `APP_KEY` diferente;
    - configuracao sequer criada na tabela `tb26_configuracoes_fiscais`.

- Observacao para sincronizacao com `pec1`:
  - essa alteracao e importante para depuracao de ambientes compartilhando o mesmo banco;
  - sincronizar exatamente o card visual e a leitura segura da senha criptografada, porque isso reduz bastante o tempo de diagnostico quando local e servidor divergem.
## 17/04/26 - Resolucao definitiva da senha do certificado entre local e producao com mesmo banco

- Arquivos alterados:
  - `app/Models/ConfiguracaoFiscal.php`
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalCertificateService.php`
  - `app/Support/FiscalInvoicePreparationService.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `tests/Unit/FiscalCertificateServiceTest.php`

- Arquivos criados:
  - `database/migrations/2026_04_17_020000_add_shared_certificate_password_to_tb26_configuracoes_fiscais_table.php`

- Causa confirmada:
  - local e producao compartilham o mesmo banco, mas a senha do certificado estava presa ao cast `encrypted` de `tb26_certificado_senha`;
  - isso faz a leitura depender da `APP_KEY` do ambiente que gravou o dado;
  - com `APP_KEY` diferente entre local e Azure, a producao via o mesmo registro, mas nao conseguia descriptografar a senha;
  - resultado: a configuracao parecia inconsistente entre ambientes, mesmo com o mesmo banco.

- O que foi feito:
  - criada a coluna `tb26_certificado_senha_compartilhada` em `tb26_configuracoes_fiscais`;
  - a migration tenta migrar automaticamente para a nova coluna os valores antigos de `tb26_certificado_senha` quando estiver rodando em um ambiente capaz de descriptografar a senha antiga;
  - `FiscalCertificateService` agora:
    - prefere a senha compartilhada;
    - cai para a senha antiga criptografada somente quando necessario;
    - expõe detalhes da origem e legibilidade da senha;
  - `FiscalConfigurationController` passou a:
    - salvar a nova senha nos dois campos quando o usuario informar novamente;
    - preencher a senha compartilhada automaticamente quando a senha antiga ainda for legivel no ambiente atual;
    - usar o novo resolvedor de senha no upload e no diagnostico;
  - `FiscalInvoicePreparationService` agora valida a senha do certificado usando a senha efetivamente legivel no ambiente, e nao mais apenas o campo criptografado antigo;
  - `FiscalConfig.jsx` passou a mostrar no diagnostico:
    - se a senha compartilhada existe;
    - qual a fonte da senha lida (`shared` ou `legacy_encrypted`);
    - o status real da leitura no ambiente atual.

- Efeito esperado:
  - depois da migration rodar no banco compartilhado a partir do ambiente local, a senha legivel passa a ficar disponivel para a producao sem depender da `APP_KEY`;
  - o Azure deve conseguir abrir o certificado usando a senha compartilhada, mesmo que a senha antiga criptografada tenha sido gravada com outra `APP_KEY`.

- Observacao para sincronizacao com `pec1`:
  - sincronizar exatamente a migration e os ajustes do resolvedor de senha;
  - essa parte e critica porque resolve a divergencia mais traiçoeira entre ambientes com o mesmo banco, mas com `APP_KEY` diferentes.
## 17/04/26 - Exibicao do erro real de salvamento na tela fiscal

- Arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`

- Causa identificada:
  - a gravacao da configuracao fiscal podia falhar antes de criar a linha em `tb26_configuracoes_fiscais`, mas a tela `settings/fiscal` nao exibia o `flash.error` retornado pelo backend;
  - isso fazia parecer que nada acontecia, mesmo quando o controller ja estava redirecionando com erro;
  - como o diagnostico depende da existencia da linha no banco, a ausencia desse feedback dificultava entender que o `save()` nem chegou a persistir.

- O que foi feito:
  - `FiscalConfig.jsx` agora mostra `flash.success` e `flash.error` usando o componente `AlertMessage`;
  - `FiscalConfigurationController@update` passou a devolver um `flash.error` com detalhe tecnico controlado, reaproveitando a mensagem da excecao quando existir;
  - com isso, a proxima tentativa de salvar em producao deve mostrar a causa real diretamente na interface.

- Efeito esperado:
  - quando a configuracao fiscal nao conseguir ser salva, o usuario deve ver o motivo na propria tela;
  - isso elimina o comportamento de “nao gravou e nao deu erro”.
## 17/04/26 - Neutralizacao definitiva do campo legado tb26_certificado_senha para parar o erro "The MAC is invalid."

- Arquivos alterados:
  - `app/Models/ConfiguracaoFiscal.php`
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `app/Support/FiscalCertificateService.php`

- Causa confirmada:
  - mesmo apos a criacao da senha compartilhada, o campo legado `tb26_certificado_senha` ainda permanecia no model com cast `encrypted`;
  - isso fazia o Laravel tentar interpretar um valor criptografado antigo com `APP_KEY` diferente, disparando `The MAC is invalid.` durante o fluxo de salvar a configuracao fiscal;
  - na pratica, o campo legado continuava contaminando o salvamento, apesar a senha compartilhada ja existir para resolver a divergencia entre ambientes.

- O que foi feito:
  - removido o cast `encrypted` de `tb26_certificado_senha` em `ConfiguracaoFiscal`;
  - `FiscalCertificateService` passou a descriptografar o campo legado manualmente via `Crypt::decryptString()` somente quando precisar tentar aproveita-lo;
  - `FiscalConfigurationController@update` passou a limpar `tb26_certificado_senha` sempre que a senha compartilhada estiver presente, deixando `tb26_certificado_senha_compartilhada` como fonte operacional principal;
  - quando uma nova senha e informada, ela agora fica apenas na senha compartilhada e o campo legado e neutralizado.

- Efeito esperado:
  - salvar a configuracao fiscal em producao nao deve mais falhar por causa de `The MAC is invalid.`;
  - a leitura operacional do certificado continua funcionando pela senha compartilhada;
  - o campo legado deixa de interferir no comportamento entre local e Azure.
## 17/04/26 - Instrumentacao do GET settings/fiscal para comparar leitura do model com leitura crua do banco

- Arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`

- Causa investigada:
  - havia divergencia entre o comportamento do local e da producao ao recarregar `settings/fiscal`;
  - o `POST` ja retornava sucesso, mas o `GET` seguinte ainda caia no bloco de protecao, dando a impressao de que nada tinha sido salvo;
  - era necessario descobrir se a linha existia no banco e em qual etapa do carregamento a producao quebrava.

- O que foi feito:
  - `FiscalConfigurationController@index` agora registra a etapa atual do carregamento da tela (`carregar configuracao`, `carregar unidade`, `resolver endpoints`, `montar payload`, etc.);
  - quando o `GET` falhar, a mensagem exibida na propria tela agora informa:
    - a etapa em que a excecao ocorreu;
    - o detalhe tecnico da excecao;
  - foi criado um fallback de diagnostico por consulta crua via `DB::table('tb26_configuracoes_fiscais')`, sem passar pelo model;
  - o card `Diagnostico do ambiente` agora mostra tambem:
    - se a configuracao crua foi encontrada no banco;
    - o `tb26_id` cru;
    - a falha especifica de carregamento, quando existir.

- Efeito esperado:
  - em producao, depois do deploy, a tela deve revelar se:
    - o registro realmente existe no banco;
    - o model esta falhando ao hidratar/carregar;
    - ou se a excecao acontece em outra etapa do `GET /settings/fiscal`.
## 17/04/26 - Correcao do diagnostico da tela fiscal por chave de array divergente

- Arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`

- Causa identificada:
  - o `FiscalCertificateService` passou a devolver o status de leitura da senha na chave `readable`;
  - o controller da tela fiscal ainda tentava ler `decryptable`;
  - isso derrubava o `GET /settings/fiscal` na etapa `montar payload da configuracao fiscal para a tela` com o erro `Undefined array key "decryptable"`.

- O que foi feito:
  - `FiscalConfigurationController` passou a usar a chave correta `readable`;
  - a prop exibida na interface continua sendo `password_decryptable` apenas como nome visual legado, mas agora preenchida com o valor certo retornado pelo servico.

- Efeito esperado:
  - `settings/fiscal` deve voltar a abrir em producao sem cair por esse erro de diagnostico;
  - a partir disso, a tela passa a mostrar o estado real da configuracao fiscal da unidade.
## 17/04/26 - Remocao de CNAE solto no emitente da NFC-e para reduzir rejeicao de schema 225

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`

- Causa identificada:
  - o XML da NFC-e ainda podia sair com `CNAE` no bloco `emit` mesmo quando a configuracao fiscal da loja nao tinha `IM`;
  - no layout fiscal, esse grupo do emitente nao deve ir incompleto;
  - isso deixava o XML da nota estruturalmente suspeito para o schema e mantinha o `cStat 225 - Rejeicao: Falha no Schema XML do lote de NFe`.

- O que foi feito:
  - `FiscalNfceXmlService` passou a enviar `IM` e `CNAE` somente quando a `IM` estiver preenchida;
  - se a loja nao tiver `IM`, o XML deixa de mandar `CNAE` isolado no emitente;
  - os testes unitarios passaram a cobrir os dois cenarios:
    - sem `IM`, `CNAE` nao aparece;
    - com `IM`, `CNAE` continua sendo enviado junto.

- Validacao:
  - `php artisan test tests/Unit/FiscalNfceXmlServiceTest.php`

- Efeito esperado:
  - as notas NFC-e geradas para lojas sem `IM` deixam de levar um grupo parcial no emitente;
  - isso reduz mais uma causa concreta de schema invalido antes da transmissao para a SEFAZ.

- Observacoes para sincronizar em `pec1`:
  - sincronizar exatamente `app/Support/FiscalNfceXmlService.php` e `tests/Unit/FiscalNfceXmlServiceTest.php`;
  - nao depende de migration;
  - depois da sincronizacao, regenerar as notas pendentes que estavam com XML assinado antigo para que o novo XML seja reconstruido sem `CNAE` solto.

## 17/04/26 - Ajuste operacional do storage do certificado para reprocessar a nota 20145

- Arquivos alterados:
  - `SYNC.md`

- Causa identificada:
  - depois que a configuracao fiscal da loja `tb2_id = 3` foi salva novamente em outro ambiente, o banco compartilhado passou a apontar para o caminho `fiscal-certificados/3/certificado-20260417020907.pfx`;
  - neste ambiente local, o storage ainda tinha apenas o arquivo anterior `certificado-20260416164839.pfx`;
  - com isso, a nota `20145` nao conseguia nem regenerar o XML, porque parava em `Arquivo do certificado nao encontrado no armazenamento local`.

- O que foi feito neste ambiente:
  - copiado o certificado fisico existente para o novo nome esperado pelo banco compartilhado:
    - `storage/app/private/fiscal-certificados/3/certificado-20260417020907.pfx`
  - mantida tambem a compatibilidade no caminho legado:
    - `storage/app/private/private/fiscal-certificados/3/certificado-20260417020907.pfx`
  - apos esse alinhamento, a `20145` voltou a regenerar normalmente e o XML novo foi assinado sem `CNAE`.

- Observacoes para sincronizar em `pec1`:
  - se o banco compartilhado apontar para um nome de certificado que nao exista fisicamente no storage do ambiente, a regeneracao da nota vai falhar antes da transmissao;
  - nesses casos, conferir o valor atual de `tb26_certificado_arquivo` no banco e alinhar o arquivo fisico correspondente em:
    - `storage/app/private/fiscal-certificados/<tb2_id>/...`
  - esse ajuste foi operacional, nao estrutural; nao depende de migration nem de alteracao adicional de codigo.

## 17/04/26 - Exclusao segura de notas preparadas nao transmitidas em settings/fiscal

- Arquivos alterados:
  - `app/Http/Controllers/FiscalConfigurationController.php`
  - `resources/js/Pages/Settings/FiscalConfig.jsx`
  - `routes/web.php`

- Causa identificada:
  - a lista `Ultimas notas preparadas` nao tinha acao para descartar registros fiscais internos que ainda nao foram transmitidos;
  - isso deixava notas preparadas antigas acumuladas na unidade e confundia a operacao;
  - ao mesmo tempo, apagar nota ja transmitida seria risco fiscal e precisava continuar proibido.

- O que foi feito:
  - adicionada a rota `settings.fiscal.invoices.destroy` com metodo `DELETE`;
  - criado no `FiscalConfigurationController` o metodo `destroyInvoice()`;
  - a exclusao agora so e permitida para notas que:
    - nao estao com status `emitida` ou `cancelada`;
    - nao possuem `tb27_protocolo`;
    - nao possuem `tb27_recibo`;
  - a listagem fiscal passou a receber a flag `pode_excluir`;
  - a tela `FiscalConfig.jsx` ganhou uma nova coluna `Excluir` com botao de lixeira;
  - ao clicar, a interface pede confirmacao e remove apenas notas ainda nao transmitidas.

- Validacao:
  - `php -l app/Http/Controllers/FiscalConfigurationController.php`
  - `php -l routes/web.php`
  - `cmd /c npm run build`

- Efeito esperado:
  - notas preparadas internas que ainda nao foram transmitidas podem ser descartadas pela tela fiscal;
  - notas ja transmitidas ou com indicio de protocolo/recibo continuam protegidas contra exclusao.

- Observacoes para sincronizar em `pec1`:
  - sincronizar exatamente os tres arquivos listados acima;
  - nao depende de migration;
  - a regra de bloqueio no backend e obrigatoria e nao deve ser removida no outro projeto.

## 17/04/26 - Correcao da ordem da raiz da NFC-e conforme o leiaute oficial

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`

- Causa confirmada:
  - a NFC-e estava sendo gerada com a raiz em ordem:
    - `infNFe`
    - `Signature`
    - `infNFeSupl`
  - pelo leiaute oficial consultado no MOC 7.0, o grupo `infNFeSupl` deve vir antes da `Signature`;
  - isso era a causa real do `cStat 225 - Rejeicao: Falha no Schema XML do lote de NFe`.

- O que foi feito:
  - `FiscalNfceXmlService` passou a montar a NFC-e nesta ordem:
    - `infNFe`
    - `infNFeSupl`
    - `Signature`
  - o teste unitario do XML fiscal foi ajustado para validar a ordem oficial;
  - como o ambiente de teste local nao conseguiu gerar uma chave RSA temporaria com OpenSSL, o teste de assinatura completa ficou preparado para `skip` quando a capacidade de assinatura nao estiver disponivel.

- Validacao:
  - `php artisan test tests/Unit/FiscalNfceXmlServiceTest.php`

- Resultado operacional confirmado:
  - depois de reprocessar a venda `20145` com a nova ordem, o erro mudou de:
    - `cStat 225 - Rejeicao: Falha no Schema XML do lote de NFe`
  - para:
    - `cStat 202 - Rejeicao: Falha no reconhecimento da autoria ou integridade do arquivo digital`
  - isso confirma que o problema de schema foi resolvido e o proximo bloqueio passou a ser a assinatura/autenticidade do XML.

- Observacoes para sincronizar em `pec1`:
  - sincronizar exatamente os arquivos listados acima;
  - depois da sincronizacao, regenerar as notas antigas para que o XML seja refeito com a ordem correta;
  - se o banco compartilhado estiver apontando para um nome de certificado inexistente no storage local, alinhar tambem o arquivo fisico antes de testar transmissao.

## 17/04/26 - Tentativa de migracao da assinatura da NFC-e para SHA-256

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`

- Causa investigada:
  - depois da correcao do schema, a transmissao passou de `cStat 225` para `cStat 202 - Rejeicao: Falha no reconhecimento da autoria ou integridade do arquivo digital`;
  - o candidato mais forte no codigo era que a assinatura ainda usava `SHA-1`.

- O que foi feito:
  - `FiscalNfceXmlService` foi ajustado para:
    - `DigestValue` com `sha256`;
    - `SignatureMethod` com `rsa-sha256`;
    - `DigestMethod` com `sha256`;
    - `openssl_sign(..., OPENSSL_ALGO_SHA256)`;
  - o teste unitario do XML foi mantido consistente com a nova montagem.

- Validacao:
  - `php -l app/Support/FiscalNfceXmlService.php`
  - `php artisan test tests/Unit/FiscalNfceXmlServiceTest.php`

- Resultado operacional observado:
  - o XML novo passou a sair com referencias claras de `sha256` na assinatura e no digest;
  - porem, ao retransmitir a venda `20145`, o retorno voltou de `cStat 202` para:
    - `cStat 225 - Rejeicao: Falha no Schema XML do lote de NFe`
  - isso indica que a mudanca para SHA-256, do jeito atual, nao e a correcao final e introduziu nova incompatibilidade com o schema/assinatura aceitos neste fluxo.

- Observacoes para sincronizar em `pec1`:
  - sincronizar esta etapa somente se o outro projeto tambem estiver seguindo a mesma investigacao;
  - esta mudanca ainda nao resolveu a transmissao final;
  - o ponto util desta etapa foi diagnostico: confirmou que o problema nao era apenas "usar SHA-1", porque a troca direta para SHA-256 reintroduziu erro de schema.

## 17/04/26 - Reversao da assinatura em SHA-256 para retornar ao ponto correto de diagnostico

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `SYNC.md`

- Causa identificada:
  - a troca direta da assinatura para `SHA-256` nao resolveu o problema final e ainda trouxe de volta o `cStat 225`;
  - isso atrapalhava o diagnostico porque reabria o erro de schema, que ja tinha sido superado quando a raiz da NFC-e foi corrigida.

- O que foi feito:
  - revertida a parte da assinatura que havia sido trocada para `SHA-256`;
  - mantida a ordem correta da raiz da NFC-e:
    - `infNFe`
    - `infNFeSupl`
    - `Signature`
  - a assinatura voltou a sair em `SHA-1`, apenas para restaurar o ponto de comparacao que ja havia eliminado o erro de schema.

- Validacao:
  - `php -l app/Support/FiscalNfceXmlService.php`
  - `php artisan test tests/Unit/FiscalNfceXmlServiceTest.php`
  - retransmissao real da venda `20145`

- Resultado operacional confirmado:
  - com a reversao, a venda `20145` voltou a transmitir com:
    - `cStat 202 - Rejeicao: Falha no reconhecimento da autoria ou integridade do arquivo digital`
  - isso confirma novamente que:
    - o problema de schema foi resolvido pela correcao da ordem da raiz;
    - o proximo bloqueio real continua sendo a assinatura/autenticidade do XML.

- Observacoes para sincronizar em `pec1`:
  - sincronizar esta reversao junto com a correcao anterior da ordem da raiz;
  - nao manter a versao `SHA-256` isolada no outro projeto, porque ela trouxe de volta o `225` neste fluxo atual.

## 17/04/26 - Assinatura XMLDSig da NFC-e corrigida para usar namespace em todos os nos internos

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `tests/Unit/FiscalNfceXmlServiceTest.php`

- Causa identificada:
  - o bloco `Signature` da NFC-e nascia com namespace XMLDSig, mas os filhos internos (`SignedInfo`, `Reference`, `DigestValue`, `SignatureValue`, `KeyInfo`, `X509Certificate`, etc.) ainda eram criados com `createElement()` sem namespace;
  - isso pode passar na verificacao matematica local da assinatura, mas faz o autorizador nao reconhecer corretamente a autoria/integridade do arquivo;
  - como o erro atual ja estava em `cStat 202`, o ponto mais forte restante era justamente a montagem XMLDSig manual.

- O que foi feito:
  - `FiscalNfceXmlService` passou a criar todos os nos do bloco de assinatura com `createElementNS('http://www.w3.org/2000/09/xmldsig#', ...)`;
  - `DigestValue`, `SignatureValue` e `X509Certificate` deixaram de reutilizar o helper generico sem namespace e agora usam helper especifico da assinatura;
  - o teste unitario passou a verificar explicitamente se:
    - `Signature` permanece na ordem oficial apos `infNFeSupl`;
    - `SignedInfo`, `Reference`, `SignatureValue` e `X509Certificate` existem com namespace XMLDSig.

- Efeito esperado:
  - a assinatura gerada fica mais aderente ao padrao XMLDSig esperado pela SEFAZ;
  - isso ataca diretamente a causa mais forte restante do `cStat 202 - Rejeicao: Falha no reconhecimento da autoria ou integridade do arquivo digital`.

- Observacoes para sincronizar em `pec1`:
  - sincronizar exatamente os dois arquivos listados acima;
  - nao misturar esta correcao com a tentativa anterior de `SHA-256` que foi revertida;
  - depois da sincronizacao, regenerar a nota para que o XML assinado seja recriado com o novo bloco `Signature` totalmente namespace-aware.

## 17/04/26 - Substituicao da assinatura manual da NFC-e por xmlseclibs

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `composer.json`
  - `composer.lock`

- Causa identificada:
  - mesmo com o schema corrigido e o namespace XMLDSig ajustado, a SEFAZ continuava retornando `cStat 202`;
  - a assinatura manual ja estava matematicamente consistente localmente, mas esse tipo de implementacao ainda e sensivel a detalhes finos de XMLDSig que o autorizador valida com mais rigor;
  - por isso o ponto mais forte restante passou a ser a propria rotina artesanal de assinatura.

- O que foi feito:
  - adicionada a dependencia `robrichards/xmlseclibs:^3.1`;
  - `FiscalNfceXmlService` deixou de montar `SignedInfo`, `Reference`, `DigestValue`, `SignatureValue` e `KeyInfo` manualmente;
  - a assinatura agora usa `XMLSecurityDSig` com:
    - canonicalizacao `C14N`;
    - referencia ao `infNFe` existente sem sobrescrever o `Id`;
    - transforms de `enveloped-signature` e `C14N`;
    - chave privada `RSA_SHA1`, preservando o algoritmo que ja mantinha o schema aceito;
    - inclusao do certificado via `add509Cert()`.

- Efeito esperado:
  - reduzir o risco de incompatibilidades sutis de XMLDSig que passavam localmente, mas ainda eram rejeitadas pela SEFAZ como falha de autoria/integridade;
  - manter intacta a correcao anterior da ordem da raiz da NFC-e.

- Observacoes para sincronizar em `pec1`:
  - sincronizar obrigatoriamente:
    - `app/Support/FiscalNfceXmlService.php`
    - `composer.json`
    - `composer.lock`
  - depois de sincronizar o codigo, executar `composer install` no `pec1` para instalar `xmlseclibs`;
  - nao remover a correcao anterior da ordem `infNFe -> infNFeSupl -> Signature`, porque ela continua sendo necessaria para evitar o `225`.

## 17/04/26 - Nova tentativa de autorizacao com xmlseclibs em RSA-SHA256

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`

- Causa investigada:
  - mesmo apos migrar a assinatura para `xmlseclibs`, a SEFAZ continuou retornando `cStat 202`;
  - isso reduziu o foco para algoritmo de assinatura/digest ou formato do `KeyInfo`;
  - a tentativa anterior de `SHA-256` tinha sido feita ainda na assinatura manual, entao ela nao era conclusiva depois da troca para `xmlseclibs`.

- O que foi feito:
  - `FiscalNfceXmlService` passou a assinar com:
    - `XMLSecurityKey::RSA_SHA256`
    - `XMLSecurityDSig::SHA256`
  - foram mantidos:
    - a ordem correta da raiz `infNFe -> infNFeSupl -> Signature`;
    - a canonicalizacao `C14N`;
    - o uso de `xmlseclibs` para montagem do bloco XMLDSig.

- Efeito esperado:
  - verificar se o autorizador reconhece melhor a autoria/integridade quando a mesma assinatura padrao da biblioteca usa `RSA-SHA256` e `Digest SHA256`;
  - esse teste e mais fiel do que a tentativa antiga em `SHA-256`, porque agora o XMLDSig nao esta mais sendo montado manualmente.

- Observacoes para sincronizar em `pec1`:
  - sincronizar este ajuste apenas junto com a etapa anterior da migracao para `xmlseclibs`;
  - nao aplicar este trecho isoladamente em cima da assinatura manual antiga.

## 17/04/26 - Reversao do xmlseclibs em RSA-SHA256 para voltar ao ponto correto do cStat 202

- Arquivos alterados:
  - `app/Support/FiscalNfceXmlService.php`
  - `SYNC.md`

- Causa identificada:
  - a tentativa de usar `RSA-SHA256` com `Digest SHA256` dentro do `xmlseclibs` fez a transmissao real da NFC-e voltar de `cStat 202` para `cStat 225`;
  - isso mostrou que, neste fluxo atual, o `SHA-256` reabre incompatibilidade de schema e atrapalha o diagnostico do problema real de autoria/integridade.

- O que foi feito:
  - `FiscalNfceXmlService` voltou a usar:
    - `XMLSecurityKey::RSA_SHA1`
    - `XMLSecurityDSig::SHA1`
  - foi mantida a assinatura via `xmlseclibs`;
  - foi mantida a ordem correta da raiz da NFC-e:
    - `infNFe`
    - `infNFeSupl`
    - `Signature`

- Efeito esperado:
  - restaurar o estado estavel em que a NFC-e volta a passar do schema e a resposta da SEFAZ fica em `cStat 202`;
  - a partir desse ponto, a investigacao segue no bloco `KeyInfo/X509Data` e nao mais no algoritmo de assinatura.

- Observacoes para sincronizar em `pec1`:
  - nao manter a variante `RSA-SHA256` ativa no outro projeto neste momento;
  - sincronizar esta reversao junto com a etapa da migracao para `xmlseclibs`.

## 17/04/26 - Botao Transmitir NF no cupom pos-venda do Dashboard

- Arquivos alterados:
  - `app/Http/Controllers/SaleController.php`
  - `resources/js/Pages/Dashboard.jsx`
  - `routes/web.php`

- Causa identificada:
  - o fechamento da venda no `Dashboard` ja retornava o resumo fiscal em `sale.fiscal`, mas o modal do cupom so permitia imprimir o comprovante interno;
  - para transmitir a nota, o operador precisava sair do fluxo do caixa e ir ate `settings/fiscal`;
  - alem disso, a rota de transmissao existente retornava `redirect`, adequada para a tela fiscal administrativa, mas nao para o fluxo em AJAX do cupom pos-venda.

- O que foi feito:
  - adicionada a rota autenticada `sales.fiscal.transmit` em `POST /sales/fiscal/{notaFiscal}/transmit`;
  - criado no `SaleController` o metodo `transmitFiscalInvoice()`:
    - responde em JSON;
    - exige usuario autenticado;
    - restringe a transmissao para a loja ativa do caixa;
    - permite perfis `0`, `1` e `3`, alinhando com o fluxo operacional do Dashboard;
    - reutiliza `FiscalNfceTransmissionService`;
    - devolve no JSON o resumo fiscal atualizado da nota.
  - `SaleController@store` passou a reutilizar o helper `buildFiscalSummary()` para manter o payload fiscal consistente entre venda e transmissao;
  - o modal `Cupom pronto para impressao` em `Dashboard.jsx` ganhou:
    - bloco visual com status da nota, serie/numero, protocolo e recibo;
    - botao `Transmitir NF`;
    - o botao aparece apenas quando a nota estiver em `xml_assinado` ou `erro_transmissao`;
    - ao transmitir, o modal atualiza `receiptData.fiscal` sem fechar o cupom.

- Efeito esperado:
  - logo apos fechar a venda, o operador consegue transmitir a nota fiscal da propria venda sem sair do `Dashboard`;
  - quando a transmissao falhar, o modal continua aberto e o status fiscal e atualizado ali mesmo;
  - quando a nota mudar para `emitida`, o botao deixa de aparecer automaticamente.

- Observacoes para sincronizar em `pec1`:
  - sincronizar exatamente os tres arquivos listados acima;
  - esta mudanca nao depende de migration;
  - o `Dashboard.jsx` depende de o payload `sale.fiscal` continuar vindo do backend no fechamento da venda;
  - importante manter a regra de unidade ativa no endpoint JSON, para o caixa nao transmitir nota de outra loja.
