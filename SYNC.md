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
