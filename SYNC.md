## 10/04/26 - Folha de Pagamento em Ferramentas

- causa do problema:
  - o sistema ja possuia salario em `users.salario`, adiantamentos em `salary_advances` e vales em `tb3_vendas`, mas esses dados ficavam espalhados em telas diferentes;
  - nao existia em `Ferramentas` nenhuma visao consolidada por colaborador;
  - tambem nao havia botao de `Contra-Cheque` com impressao em `80mm`, nem modal unica com detalhamento de adiantamentos e vales.

- o que foi implementado:
  - criada a nova rota `settings.payroll` em `/settings/folha-pagamento`;
  - criada a tela `resources/js/Pages/Settings/FolhaPagamento.jsx`;
  - adicionada a opcao `Folha de Pagamento` em `Ferramentas`, tanto em `Settings/Menu.jsx` quanto em `Settings/Config.jsx`;
  - a listagem mostra todos os usuarios exceto perfil `Cliente`;
  - a tela exibe `Salario`, `Adiantamentos`, `Vales` e `Saldo`;
  - o `Saldo` foi calculado como `salario - adiantamentos - vales`;
  - os vales considerados na folha sao somente os registros de `tb3_vendas` com `tipo_pago = vale`;
  - os vales do detalhe foram agrupados por `tb4_id` para cada colaborador, evitando repetir o mesmo cupom quando houver mais de um item;
  - adicionado botao `Detalhes` com modal contendo duas secoes: `Adiantamentos` e `Vales`;
  - adicionado botao `Contra-Cheque` com abertura de layout de impressao para papel `80mm`.

- backend criado:
  - `app/Http/Controllers/PayrollController.php`
  - o controlador concentra os filtros por periodo e unidade;
  - usa `ManagementScope` para respeitar o escopo de lojas do usuario logado;
  - exclui `Cliente` ainda na consulta base dos usuarios;
  - prepara no payload tanto os totais por colaborador quanto os arrays detalhados para a modal/impressao.

- regras e detalhes importantes para sincronizar:
  - a tela aceita filtro de `Inicio`, `Fim` e `Unidade`;
  - a tela agora tambem aceita filtro de `Funcao`, com as opcoes `Master`, `Gerente`, `Sub-Gerente`, `Caixa`, `Lanchonete` e `Funcionario`;
  - as datas exibidas e digitadas no frontend seguem `DD/MM/AA`;
  - o periodo padrao e o mes atual;
  - a impressao do contra-cheque e feita no frontend via `window.open()` com HTML em largura `80mm`;
  - os badges de loja e funcao reutilizam os helpers centrais de `resources/js/Utils/brandBadges.js`;
  - os botoes principais usam os componentes centrais `PrimaryButton` e `InfoButton`.

- arquivos criados:
  - `app/Http/Controllers/PayrollController.php`
  - `resources/js/Pages/Settings/FolhaPagamento.jsx`
  - `tests/Feature/PayrollReportTest.php`

- arquivos alterados:
  - `routes/web.php`
  - `resources/js/Pages/Settings/Menu.jsx`
  - `resources/js/Pages/Settings/Config.jsx`
  - `app/Http/Controllers/PayrollController.php`
  - `resources/js/Pages/Settings/FolhaPagamento.jsx`
  - `tests/Feature/PayrollReportTest.php`

- observacoes de validacao nesta copia:
  - `npm run build` concluiu com sucesso e gerou o bundle da nova pagina `FolhaPagamento`;
  - `php -l app/Http/Controllers/PayrollController.php` retornou sem erro de sintaxe;
  - os testes automatizados da nova tela foram criados, mas nao puderam ser executados fim a fim neste ambiente porque:
    - com o `.env` atual, a suite tenta usar o MySQL remoto;
    - com SQLite em memoria, migrations antigas do projeto quebram por `ALTER TABLE ... MODIFY` incompativel com SQLite;
  - `php artisan route:list` tambem falha nesta copia por um problema pre-existente e fora desta entrega: referencia a `App\Http\Controllers\MobileRevenueController` ausente.

## 10/04/26 - Controle de Pagamentos por usuario + aviso do Sistema no chat

- causa do problema:
  - o `Controle de Pagamentos` era global, entao qualquer usuario com acesso a tela via todos os registros cadastrados e tambem podia excluir registros de outros usuarios;
  - nao existia dono do registro em `tb24_controle_pagamentos`, entao o sistema nao conseguia definir quem deveria ver, excluir e receber lembretes;
  - no login nao havia nenhuma rotina que verificasse vencimentos do proprio usuario e publicasse um resumo no modulo `On-Line`.

- decisao aplicada nesta copia:
  - o proprio usuario confirmou que nao existem registros antigos em `tb24_controle_pagamentos`, entao a migration nova adiciona `user_id` sem rotina de backfill;
  - o controle continua acessivel aos perfis administrativos que ja tinham acesso, mas agora cada usuario ve e exclui somente os registros criados por ele.

- o que foi implementado:
  - criada a migration `2026_04_10_160000_add_user_id_to_tb24_controle_pagamentos_table.php` para adicionar `user_id` em `tb24_controle_pagamentos`;
  - o model `ControlePagamento` passou a aceitar `user_id` em massa e ganhou relacao `user()`;
  - `ControlePagamentoController` passou a:
    - listar apenas os controles com `user_id = auth()->id()`;
    - gravar automaticamente `user_id` no cadastro;
    - bloquear exclusao de registro pertencente a outro usuario com `403`;
  - a regra de cronologia foi extraida para `app/Support/PaymentControlTimeline.php`, evitando duplicacao entre tela e notificacao;
  - no login, `AuthenticatedSessionController` agora chama `PaymentControlNotificationService` logo apos definir `active_unit` e `active_role` na sessao;
  - `PaymentControlNotificationService`:
    - busca somente os controles do usuario logado;
    - monta um resumo com pendencias de `hoje` e dos `proximos 3 dias`;
    - cria uma mensagem em `tb22_chat_mensagens`;
    - usa um usuario interno fake chamado `Sistema`;
    - inclui no corpo da mensagem um link para `/settings/controle-pagamentos`;
  - o chat `On-Line` passou a interpretar a marcacao `[link=...]texto[/link]` no frontend;
  - o preview das conversas no backend tambem remove as tags `[link]` para exibir texto limpo;
  - a tela `ControlePagamentos.jsx` agora deixa explicito no texto que cada usuario ve e gerencia apenas os proprios controles.

- detalhes importantes para sincronizar:
  - o usuario fake usa email fixo `sistema.chat@pec.local`;
  - o nome exibido do remetente fake e `Sistema`;
  - a mensagem de resumo usa datas em `DD/MM/AA`;
  - a mensagem so e criada no login quando existir ao menos uma pendencia do dia ou dos proximos 3 dias;
  - o resumo separa:
    - `Hoje: X pendencia(s)`
    - `Proximos 3 dias: X pendencia(s)`
  - o link do chat foi implementado com whitelist:
    - caminhos internos iniciando com `/`
    - links externos `http://` ou `https://`

- arquivos criados:
  - `app/Support/PaymentControlTimeline.php`
  - `app/Support/PaymentControlNotificationService.php`
  - `database/migrations/2026_04_10_160000_add_user_id_to_tb24_controle_pagamentos_table.php`

- arquivos alterados:
  - `app/Models/ControlePagamento.php`
  - `app/Http/Controllers/ControlePagamentoController.php`
  - `app/Http/Controllers/Auth/AuthenticatedSessionController.php`
  - `app/Http/Controllers/OnlineController.php`
  - `resources/js/Pages/Online/Index.jsx`
  - `resources/js/Pages/Settings/ControlePagamentos.jsx`
  - `tests/Feature/ControlePagamentoTest.php`

- observacoes de validacao nesta copia:
  - `php -l app/Support/PaymentControlTimeline.php`: ok;
  - `php -l app/Support/PaymentControlNotificationService.php`: ok;
  - `php -l app/Http/Controllers/ControlePagamentoController.php`: ok;
  - `php -l app/Http/Controllers/Auth/AuthenticatedSessionController.php`: ok;
  - `php -l app/Http/Controllers/OnlineController.php`: ok;
  - `php -l tests/Feature/ControlePagamentoTest.php`: ok;
  - `npm run build`: ok;
  - `php artisan test --filter=ControlePagamentoTest` falhou neste ambiente antes de executar as assercoes porque a suite tentou conectar no MySQL remoto definido no `.env` atual e retornou `SQLSTATE[HY000] [2002]`.
