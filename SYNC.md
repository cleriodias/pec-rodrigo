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
