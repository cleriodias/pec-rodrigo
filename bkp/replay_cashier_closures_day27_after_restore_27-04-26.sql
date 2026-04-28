-- Complemento de reaplicacao dos fechamentos de caixa com movimentacao em 27/04/26.
-- Origem: base consolidada local, preservando os 5 registros recuperados do restore.
START TRANSACTION;

INSERT INTO `cashier_closures` (`id`,`user_id`,`unit_id`,`unit_name`,`cash_amount`,`card_amount`,`open_comandas_observation`,`master_cash_amount`,`master_card_amount`,`closed_date`,`closed_at`,`master_checked_by`,`master_checked_at`,`created_at`,`updated_at`) VALUES
('232', '25', '5', 'SETOR-9', '645.10', '2513.88', NULL, NULL, NULL, '2026-04-26', '2026-04-27 01:05:46', NULL, NULL, '2026-04-27 01:05:46', '2026-04-27 01:05:46'),
('233', '20', '2', 'SETOR-1', '779.50', '2922.64', NULL, NULL, NULL, '2026-04-26', '2026-04-27 02:04:42', NULL, NULL, '2026-04-27 02:04:42', '2026-04-27 02:04:42'),
('234', '16', '3', 'BARRAGEM-1', '748.50', '1782.16', NULL, NULL, NULL, '2026-04-26', '2026-04-27 02:06:52', NULL, NULL, '2026-04-27 02:06:52', '2026-04-27 02:06:52'),
('235', '22', '1', 'SETOR-10', '1028.60', '4845.36', NULL, NULL, NULL, '2026-04-26', '2026-04-27 02:16:52', NULL, NULL, '2026-04-27 02:16:52', '2026-04-27 02:16:52'),
('236', '1', '3', 'BARRAGEM-1', '0.50', '0.10', 'Teste Clerio', NULL, NULL, '2026-04-26', '2026-04-27 02:24:51', NULL, NULL, '2026-04-27 02:24:51', '2026-04-27 02:24:51')
ON DUPLICATE KEY UPDATE
`user_id` = VALUES(`user_id`),
`unit_id` = VALUES(`unit_id`),
`unit_name` = VALUES(`unit_name`),
`cash_amount` = VALUES(`cash_amount`),
`card_amount` = VALUES(`card_amount`),
`open_comandas_observation` = VALUES(`open_comandas_observation`),
`master_cash_amount` = VALUES(`master_cash_amount`),
`master_card_amount` = VALUES(`master_card_amount`),
`closed_date` = VALUES(`closed_date`),
`closed_at` = VALUES(`closed_at`),
`master_checked_by` = VALUES(`master_checked_by`),
`master_checked_at` = VALUES(`master_checked_at`),
`created_at` = VALUES(`created_at`),
`updated_at` = VALUES(`updated_at`);

COMMIT;
