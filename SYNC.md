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
