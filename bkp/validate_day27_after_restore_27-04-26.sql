-- Validacao apos executar replay_day27_after_restore_27-04-26.sql na base restaurada.

SELECT 'tb2_unidades_total' AS item, COUNT(*) AS total, 5 AS esperado FROM `tb2_unidades`;
SELECT 'users_total' AS item, COUNT(*) AS total, 43 AS esperado FROM `users`;
SELECT 'tb1_produto_total' AS item, COUNT(*) AS total, 1922 AS esperado FROM `tb1_produto`;
SELECT 'tb26_configuracoes_fiscais_total' AS item, COUNT(*) AS total, 5 AS esperado FROM `tb26_configuracoes_fiscais`;
SELECT 'tb4_vendas_pg_total' AS item, COUNT(*) AS total, 31045 AS esperado FROM `tb4_vendas_pg`;
SELECT 'tb3_vendas_total' AS item, COUNT(*) AS total, 66238 AS esperado FROM `tb3_vendas`;
SELECT 'tb27_notas_fiscais_total' AS item, COUNT(*) AS total, 88 AS esperado FROM `tb27_notas_fiscais`;
SELECT 'salary_advances_total' AS item, COUNT(*) AS total, 18 AS esperado FROM `salary_advances`;
SELECT 'expenses_total' AS item, COUNT(*) AS total, 478 AS esperado FROM `expenses`;
SELECT 'tb_16_boletos_total' AS item, COUNT(*) AS total, 65 AS esperado FROM `tb_16_boletos`;
SELECT 'cashier_closures_total' AS item, COUNT(*) AS total, 226 AS esperado FROM `cashier_closures`;
SELECT 'tb22_chat_mensagens_total' AS item, COUNT(*) AS total, 166 AS esperado FROM `tb22_chat_mensagens`;

SELECT 'tb4_day27' AS item, COUNT(*) AS total FROM tb4_vendas_pg WHERE created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00';
SELECT 'tb3_day27' AS item, COUNT(*) AS total FROM tb3_vendas WHERE (data_hora >= '2026-04-27 00:00:00' AND data_hora < '2026-04-28 00:00:00') OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00');
SELECT 'salary_day27' AS item, COUNT(*) AS total FROM salary_advances WHERE advance_date = '2026-04-27' OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00');
SELECT 'expenses_day27' AS item, COUNT(*) AS total FROM expenses WHERE expense_date = '2026-04-27' OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00');
SELECT 'boleto_day27' AS item, COUNT(*) AS total FROM tb_16_boletos WHERE (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (paid_at >= '2026-04-27 00:00:00' AND paid_at < '2026-04-28 00:00:00');
SELECT 'cashier_day27' AS item, COUNT(*) AS total FROM cashier_closures WHERE closed_date = '2026-04-27' OR (closed_at >= '2026-04-27 00:00:00' AND closed_at < '2026-04-28 00:00:00') OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (master_checked_at >= '2026-04-27 00:00:00' AND master_checked_at < '2026-04-28 00:00:00');
SELECT 'chat_day27' AS item, COUNT(*) AS total FROM tb22_chat_mensagens WHERE (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (read_at >= '2026-04-27 00:00:00' AND read_at < '2026-04-28 00:00:00');

-- Esperados no recorte de 27/04/26: tb4_day27=672, tb3_day27=1447, salary_day27=1, expenses_day27=2, boleto_day27=5, cashier_day27=5, chat_day27=23.