-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 17/01/2026 às 21:55
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pec`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('selmabispo4571@gmail.com|127.0.0.1', 'i:1;', 1766516612),
('selmabispo4571@gmail.com|127.0.0.1:timer', 'i:1766516612;', 1766516612);

-- --------------------------------------------------------

--
-- Estrutura para tabela `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cashier_closures`
--

CREATE TABLE `cashier_closures` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `unit_name` varchar(255) DEFAULT NULL,
  `cash_amount` decimal(12,2) NOT NULL,
  `card_amount` decimal(12,2) NOT NULL,
  `closed_date` date NOT NULL,
  `closed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `cashier_closures`
--

INSERT INTO `cashier_closures` (`id`, `user_id`, `unit_id`, `unit_name`, `cash_amount`, `card_amount`, `closed_date`, `closed_at`, `created_at`, `updated_at`) VALUES
(3, 1, 2, 'SETOR 1', 38.00, 21.00, '2025-12-21', '2025-12-22 00:08:42', '2025-12-22 00:08:42', '2025-12-22 00:08:42'),
(4, 1, 1, 'SETOR 10', 15800.00, 50500.00, '2025-12-21', '2025-12-22 00:24:43', '2025-12-22 00:24:43', '2025-12-22 00:24:43'),
(5, 1, 1, 'SETOR 10', 10.00, 20.00, '2025-12-22', '2025-12-23 10:12:13', '2025-12-23 10:12:13', '2025-12-23 10:12:13'),
(6, 1, 4, 'Unidade Teste Clerio', 0.70, 0.00, '2025-12-22', '2025-12-23 12:45:49', '2025-12-23 12:45:49', '2025-12-23 12:45:49'),
(7, 1, 4, 'TST CLERIO', 10.00, 12.00, '2025-12-23', '2025-12-24 13:46:18', '2025-12-24 13:46:18', '2025-12-24 13:46:18'),
(8, 1, 1, 'SETOR 10', 0.00, 0.00, '2025-12-23', '2025-12-24 19:07:13', '2025-12-24 19:07:13', '2025-12-24 19:07:13'),
(9, 1, 1, 'SETOR 10', 289.90, 53.00, '2025-12-24', '2025-12-24 19:08:05', '2025-12-24 19:08:05', '2025-12-24 19:08:05'),
(10, 1, 3, 'BARRAGEM 1', 1050.00, 2030.00, '2025-12-23', '2025-12-24 19:09:26', '2025-12-24 19:09:26', '2025-12-24 19:09:26'),
(11, 1, 3, 'BARRAGEM 1', 0.70, 0.70, '2025-12-24', '2025-12-24 19:09:39', '2025-12-24 19:09:39', '2025-12-24 19:09:39'),
(12, 1, 2, 'SETOR 1', 11.00, 12.00, '2025-12-23', '2025-12-27 10:14:54', '2025-12-27 10:14:54', '2025-12-27 10:14:54'),
(13, 1, 4, 'TST CLERIO', 0.00, 0.00, '2025-12-24', '2025-12-27 12:03:49', '2025-12-27 12:03:49', '2025-12-27 12:03:49'),
(14, 1, 2, 'SETOR 1', 0.00, 0.00, '2025-12-27', '2025-12-27 12:05:11', '2025-12-27 12:05:11', '2025-12-27 12:05:11');

-- --------------------------------------------------------

--
-- Estrutura para tabela `expenses`
--

CREATE TABLE `expenses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `supplier_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `expense_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `expenses`
--

INSERT INTO `expenses` (`id`, `supplier_id`, `unit_id`, `user_id`, `expense_date`, `amount`, `notes`, `created_at`, `updated_at`) VALUES
(1, 15, 2, 3, '2025-12-22', 300.00, 'compras', '2025-12-22 02:19:39', '2025-12-22 02:19:39'),
(2, 2, 3, 1, '2025-12-22', 200.00, 'teste', '2025-12-22 02:20:05', '2025-12-22 02:20:05'),
(3, 7, 1, 1, '2025-12-22', 500.00, 'teste 2', '2025-12-22 02:20:16', '2025-12-22 02:20:16'),
(4, 17, 3, 2, '2025-12-23', 35.00, 'teste', '2025-12-23 12:38:36', '2025-12-23 12:38:36'),
(5, 15, 2, 2, '2025-12-23', 350.00, 'teste', '2025-12-23 12:39:03', '2025-12-23 12:39:03'),
(6, 10, 2, 1, '2025-12-23', 300.00, 'teste clerio', '2025-12-23 16:03:19', '2025-12-23 16:03:19'),
(7, 11, 2, 1, '2025-12-23', 138.50, 'teste pos alt', '2025-12-23 16:25:37', '2025-12-23 16:25:37');

-- --------------------------------------------------------

--
-- Estrutura para tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_11_28_120000_add_employee_fields_to_users_table', 1),
(5, '2025_11_28_130000_create_tb2_unidades_table', 1),
(6, '2025_11_28_140000_add_tb2_id_to_users_and_create_pivot_table', 1),
(7, '2025_11_28_150000_create_tb1_produto_table', 1),
(8, '2025_11_28_160000_create_tb3_vendas_table', 1),
(9, '2025_11_28_170000_create_tb4_vendas_pg_table', 1),
(10, '2025_11_28_180000_add_funcao_original_to_users_table', 1),
(11, '2025_11_28_190000_create_salary_advances_table', 1),
(12, '2025_11_29_020500_add_vale_tipo_to_tb3_vendas_table', 1),
(13, '2025_11_29_030500_flatten_vale_tipo_into_tipo_pago', 1),
(14, '2025_11_29_060000_add_favorite_to_tb1_produto_table', 1),
(15, '2025_11_29_070500_create_cashier_closures_table', 1),
(16, '2025_11_29_080000_create_product_discards_table', 1),
(17, '2025_11_29_090000_add_vr_credit_to_tb1_produto_table', 1),
(18, '2025_12_01_120000_add_comanda_fields_to_tb3_vendas_table', 1),
(19, '2025_12_02_100000_add_cod_acesso_to_users_table', 1),
(20, '2025_12_03_000000_make_id_user_caixa_nullable_in_tb3_vendas', 1),
(21, '2025_12_03_010000_update_cashier_closures_unique_index', 1),
(22, '2025_12_20_230000_create_suppliers_table', 1),
(23, '2025_12_20_231000_create_expenses_table', 1),
(24, '2025_12_20_232000_add_unit_id_to_expenses_table', 1),
(25, '2025_12_20_233000_create_sales_disputes_table', 1),
(26, '2025_12_20_233500_create_sales_dispute_bids_table', 1),
(27, '2025_12_20_234000_add_approval_and_invoice_to_sales_dispute_bids_table', 1),
(28, '2025_12_21_000000_add_unit_id_to_salary_advances_table', 2),
(29, '2025_12_22_000000_add_unit_id_to_product_discards_table', 3),
(30, '2025_12_22_130000_create_newsletter_subscriptions_table', 4),
(31, '2025_12_22_140500_create_newsletter_notices_table', 5),
(32, '2025_12_23_000000_add_unique_phone_to_newsletter_subscriptions_table', 6),
(33, '2025_12_23_020000_add_user_id_to_expenses_table', 6);

-- --------------------------------------------------------

--
-- Estrutura para tabela `newsletter_notices`
--

CREATE TABLE `newsletter_notices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `newsletter_subscription_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `newsletter_notices`
--

INSERT INTO `newsletter_notices` (`id`, `newsletter_subscription_id`, `name`, `phone`, `message`, `created_at`, `updated_at`) VALUES
(1, 1, 'Clerio', '61996994113', 'Clerio , _*Pão* quentinho em 10min._', '2025-12-22 05:57:55', '2025-12-22 05:57:55');

-- --------------------------------------------------------

--
-- Estrutura para tabela `newsletter_subscriptions`
--

CREATE TABLE `newsletter_subscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `newsletter_subscriptions`
--

INSERT INTO `newsletter_subscriptions` (`id`, `name`, `phone`, `created_at`, `updated_at`) VALUES
(1, 'Clerio', '61996994113', '2025-12-22 05:36:47', '2025-12-22 05:36:47');

-- --------------------------------------------------------

--
-- Estrutura para tabela `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `product_discards`
--

CREATE TABLE `product_discards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `product_discards`
--

INSERT INTO `product_discards` (`id`, `product_id`, `user_id`, `unit_id`, `quantity`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 50.000, '2025-12-21 13:44:32', '2025-12-21 13:44:32'),
(2, 25, 1, 2, 5.000, '2025-12-22 01:56:54', '2025-12-22 01:56:54'),
(3, 22, 1, 3, 2.000, '2025-12-22 01:57:35', '2025-12-22 01:57:35');

-- --------------------------------------------------------

--
-- Estrutura para tabela `salary_advances`
--

CREATE TABLE `salary_advances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `advance_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `salary_advances`
--

INSERT INTO `salary_advances` (`id`, `user_id`, `unit_id`, `advance_date`, `amount`, `reason`, `created_at`, `updated_at`) VALUES
(3, 1, 2, '2025-12-21', 415.00, 'teste', '2025-12-21 17:53:30', '2025-12-21 17:53:30');

-- --------------------------------------------------------

--
-- Estrutura para tabela `sales_disputes`
--

CREATE TABLE `sales_disputes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_name` varchar(160) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `sales_dispute_bids`
--

CREATE TABLE `sales_dispute_bids` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sales_dispute_id` bigint(20) UNSIGNED NOT NULL,
  `supplier_id` bigint(20) UNSIGNED NOT NULL,
  `unit_cost` decimal(12,2) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `invoice_note` text DEFAULT NULL,
  `invoice_file_path` varchar(255) DEFAULT NULL,
  `invoiced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('6jGVEx0dMV9GyEfp68JXosLDSAG5fE0O4Vg3UXM5', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoidlNYcWV4M2ZzdFFBU0Z2TVdReGEyTk9Uam9QY2ZudnRWTk9MQ2o3USI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9yZXBvcnRzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjExOiJhY3RpdmVfdW5pdCI7YTo0OntzOjI6ImlkIjtpOjI7czo0OiJuYW1lIjtzOjc6IlNFVE9SIDEiO3M6NzoiYWRkcmVzcyI7czoyNjoiQXJlYSBBdi0zIEx0LCAzLzQsIExvdGUgMDIiO3M6NDoiY25waiI7czoxODoiNTAuMzU5Ljc5MC8wMDAxLTc0Ijt9fQ==', 1766934839),
('Fds0aB6lueRr25waoNSi33OS7XaDCjL33EVdFJyJ', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoiR0pTajVrZWRaZVZabFZBN256NlZBckxDSE5vYUVNWERuRjdnTHFoVCI7czozOiJ1cmwiO2E6MDp7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxMToiYWN0aXZlX3VuaXQiO2E6NDp7czoyOiJpZCI7aToyO3M6NDoibmFtZSI7czo3OiJTRVRPUiAxIjtzOjc6ImFkZHJlc3MiO3M6MjY6IkFyZWEgQXYtMyBMdCwgMy80LCBMb3RlIDAyIjtzOjQ6ImNucGoiO3M6MTg6IjUwLjM1OS43OTAvMDAwMS03NCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjI3OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvdW5pdHMiO319', 1766973846),
('SLU6P8X6xGlXhVHzqoYruj8KXlzz0RMwuW8O1jzD', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoickNTYlREOVVhelljb0lDNTZSNTRzR2F6YjBxN25ETjM0Z3A5WmFUUiI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjExOiJhY3RpdmVfdW5pdCI7YTo0OntzOjI6ImlkIjtpOjE7czo0OiJuYW1lIjtzOjg6IlNFVE9SIDEwIjtzOjc6ImFkZHJlc3MiO3M6MjY6IkFyZWEgQXYtMyBMdCwgMy80LCBMb3RlIDAyIjtzOjQ6ImNucGoiO3M6MTg6IjUwLjM1OS43OTAvMDAwMS03NCI7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjQwOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvcHJvZHVjdHMvZmF2b3JpdGVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1768053627),
('u1YyRXsZqVE24ueUvbFnt1BvuGp3CkibP6Fh09pI', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoieGZXUFZZaWFhUURRZVFGRjk4UHVUN1kzZnNZdmQyYjJzMzVodnYwZiI7czozOiJ1cmwiO2E6MDp7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxMToiYWN0aXZlX3VuaXQiO2E6NDp7czoyOiJpZCI7aToyO3M6NDoibmFtZSI7czo3OiJTRVRPUiAxIjtzOjc6ImFkZHJlc3MiO3M6MjY6IkFyZWEgQXYtMyBMdCwgMy80LCBMb3RlIDAyIjtzOjQ6ImNucGoiO3M6MTg6IjUwLjM1OS43OTAvMDAwMS03NCI7fX0=', 1766955246);

-- --------------------------------------------------------

--
-- Estrutura para tabela `suppliers`
--

CREATE TABLE `suppliers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `dispute` tinyint(1) NOT NULL DEFAULT 0,
  `access_code` varchar(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `dispute`, `access_code`, `created_at`, `updated_at`) VALUES
(1, 'ESTRELINHA', 0, '6446', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(2, 'BONA MIX ATACADISTA', 1, '1221', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(3, 'PEROLA ATACADISTA', 0, '0110', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(4, 'S.A ATACADISTA ', 0, '6116', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(5, 'MAX GOUD ATACADISTA', 1, '8008', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(6, 'UNIPAN ATACADISTA', 1, '6006', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(7, 'BRF', 1, '7447', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(8, 'REALLI', 1, '2552', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(9, 'GUARA DISTRIBUICAO', 1, '3003', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(10, 'OVO', 1, '1', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(11, 'IORGUTE GOIANINHO', 1, '2', '2025-12-21 11:30:26', '2025-12-25 11:11:34'),
(12, 'ELMA CHIPS', 1, '3', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(13, 'MICOS SALGADINHO', 1, '4', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(14, 'CAPITAL EMBALAGUENS', 1, '5', '2025-12-21 11:30:26', '2025-12-25 11:11:34'),
(15, 'ATACADAO DIA A DIA', 1, '6', '2025-12-21 11:30:26', '2025-12-25 11:11:34'),
(16, 'MERCADO IDEAL', 1, '7', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(17, 'ALMOÇO', 1, '8', '2025-12-21 11:30:26', '2025-12-25 11:11:34'),
(18, 'PASSAGEM FUNCIONARIO', 1, '9', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(19, 'PAMONHA', 1, '10', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(20, 'VILMA CIGARRO', 1, '11', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(21, 'PAGAMENTO DE DIARIAS', 1, '12', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(22, 'RODRIGO RETIRADA', 1, '13', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(23, 'PRESUNTO JAL ALIMENTOS', 1, '14', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(24, 'COCADA E LEITE NINHO', 1, '17', '2025-12-21 11:30:26', '2025-12-25 11:11:34'),
(25, 'JM CAMPOS ETIQUETAS', 1, '16', '2025-12-21 11:30:26', '2025-12-21 11:30:26'),
(27, 'IORGUTE GOIANINHO', 1, '15', '2025-12-25 11:11:34', '2025-12-25 11:11:34');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb1_produto`
--

CREATE TABLE `tb1_produto` (
  `tb1_id` bigint(20) UNSIGNED NOT NULL,
  `tb1_nome` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tb1_vlr_custo` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tb1_vlr_venda` decimal(12,2) NOT NULL DEFAULT 0.00,
  `tb1_codbar` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tb1_tipo` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `tb1_status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `tb1_favorito` tinyint(1) NOT NULL DEFAULT 0,
  `tb1_vr_credit` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Despejando dados para a tabela `tb1_produto`
--

INSERT INTO `tb1_produto` (`tb1_id`, `tb1_nome`, `tb1_vlr_custo`, `tb1_vlr_venda`, `tb1_codbar`, `tb1_tipo`, `tb1_status`, `tb1_favorito`, `tb1_vr_credit`, `created_at`, `updated_at`) VALUES
(0, '?', 0.00, 0.00, 'SEM-0', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1, 'PAO DE SAL', 0.00, 0.70, '1', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2, 'PAO DE QUEIJO PEQUENO', 0.00, 0.50, '2', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(3, 'PAO DE QUEIJO GRANDE', 0.00, 3.00, '3', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(4, 'CAFEZINHO', 0.00, 2.00, '4', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(5, 'CAFE M OU PINGADO P', 0.00, 3.00, '5', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(6, 'CAFE G OU PINGADO G', 0.00, 4.00, 'SEM-6', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(7, 'PINGADO P', 0.00, 3.00, '7', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(8, 'SUCO P', 0.00, 2.00, '8', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(9, 'SUCO G', 0.00, 3.00, '9', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(10, 'NESCAU P', 0.00, 4.00, '10', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(11, 'NESCAU G', 0.00, 5.00, '11', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(12, 'PAO C/ MANTEIGA', 0.00, 3.00, '12', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(13, 'PAO COM OVO', 0.00, 4.50, '13', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(14, 'MISTO SIMPLES', 0.00, 6.50, '14', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(15, 'MISTO COMPLETO', 0.00, 8.50, '15', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(16, 'PAO COM QUEIJO', 0.00, 5.00, '16', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(17, 'TAPIOCA COM MANTEIGA', 0.00, 4.00, '17', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(18, 'TAPIOCA C/ QUEIJO', 0.00, 5.00, 'SEM-18', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(19, 'TAPIOCA C/ PRESUNTO E QUEIJO', 0.00, 6.50, 'SEM-19', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(20, 'TAPIOCA COMPLETA', 0.00, 8.00, 'SEM-20', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(21, 'SALGADO (FRITO)', 0.00, 4.00, 'SEM-21', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(22, 'CACHORRO QUENTE', 0.00, 6.00, 'SEM-22', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(23, 'TORTA DE FRANGO', 0.00, 8.00, 'SEM-23', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(24, 'BOLO PEDAÃ§O', 0.00, 4.00, 'SEM-24', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(25, 'HAMBURGÃ£O', 0.00, 6.00, 'SEM-25', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(26, 'SALGADO ASSADO', 0.00, 5.00, 'SEM-26', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(27, 'BROA', 0.00, 2.50, 'SEM-27', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(28, 'QUEBRADOR', 0.00, 2.50, 'SEM-28', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(29, 'PAMONHA', 0.00, 8.00, 'SEM-29', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(30, 'BISCOITO DE QUEIJO', 3.00, 3.00, 'SEM-30', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(31, 'FATIA TORTA CONFEITADA', 0.00, 8.00, 'SEM-31', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(32, 'PUDIM', 0.00, 6.00, 'SEM-32', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(33, 'PUDIM GRANDE', 0.00, 25.00, 'SEM-33', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(34, 'COPO DA FELICIDADE', 0.00, 12.00, 'SEM-34', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(35, 'SONHO OU ROSCA DE CREME', 0.00, 2.50, 'SEM-35', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(36, 'PAO DE DOCE', 0.00, 1.00, 'SEM-36', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(37, 'PUDIM DE LEITE NINHO', 0.00, 6.00, 'SEM-37', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(38, 'TRUFA GOURMET', 0.00, 5.00, 'SEM-38', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(39, 'BOLO DA INDIA', 0.00, 9.00, 'SEM-39', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(40, 'MINI SALGADO', 0.00, 0.50, 'SEM-40', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(41, 'BANOFE', 0.00, 8.00, 'SEM-41', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(42, 'X BURGUER', 0.00, 10.00, 'SEM-42', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(43, 'X EGG', 0.00, 12.00, 'SEM-43', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(44, 'BOLO NO POTE', 0.00, 6.00, '44', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(45, 'COPO MOUSSE', 0.00, 8.00, '45', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(46, 'CUPCAKE', 0.00, 4.00, '46', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(47, 'ROCAMBOLE', 0.00, 6.00, '47', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(48, 'CHARUTO DE PRESTIGIO', 0.00, 8.00, '48', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(49, 'BOMBOM', 0.00, 3.00, '49', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(50, 'TORTELETE', 0.00, 6.00, '50', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(51, 'BOMBA DE CHOCOLATE', 0.00, 5.00, '51', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(52, 'BOLO DE BANANA', 0.00, 25.00, '52', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(53, 'TORTA PROMOÃ§Ã£O 50', 0.00, 50.00, '53', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(54, 'BOLO DE CENOURA E CHOCOLATE', 0.00, 4.00, '54', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(55, 'GRAVATA PALMIER', 0.00, 30.00, '55', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(56, 'BOLO DE MILHO', 0.00, 4.00, '56', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(57, 'BOLINHO BRIGADEIRINHO', 0.00, 30.00, '57', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(58, 'BOLO BRIGADEIRO', 0.00, 4.00, '58', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(59, 'BRIGADEIRAO', 0.00, 3.00, '59', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(60, 'BOLO FLORESTA NEGRA', 0.00, 5.00, '60', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(61, 'TAPIOCA COZIDA', 0.00, 5.00, '61', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(62, 'BOLO BOMBOCADO', 0.00, 4.00, '62', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(63, 'BOLO DE MANDIOCA', 0.00, 4.00, '63', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(64, 'BOLO PRESTIGIO', 0.00, 5.00, '64', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(65, 'BOLO CAÃ§AROLA', 0.00, 4.00, '65', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(66, 'CAROLINA', 0.00, 2.50, '66', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(67, 'PAO PALITO', 0.00, 2.00, '67', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(68, 'PAO BATATA C/ COCO', 0.00, 1.50, '68', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(69, 'ROSQUINHA DE CANELA', 0.00, 2.00, '69', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(70, 'ROSQUINHA AMANTEIGADA', 0.00, 2.00, '70', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(71, 'PAO PEIXINHO', 0.00, 1.00, '71', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(72, 'PAO CARTEIRA', 0.00, 1.50, '72', 1, 1, 0, 1, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(73, 'BOLO DE TRIGO', 0.00, 22.00, '73', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(74, 'ROSQUINHA DE QUEIJO', 0.00, 2.50, '74', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(75, 'BISCOITO DE QUEIJO', 0.00, 2.50, '75', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(76, 'BOLO DE COCO', 0.00, 22.00, '76', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(77, 'ROSQUINHA DE LEITE NINHO', 0.00, 1.50, '77', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(78, 'ROSCA MARTHA ROCHA', 0.00, 2.50, '78', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(79, 'BOLINHO DE COCO', 0.00, 25.00, '79', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(80, 'BISCOITO DE POLVILHO', 0.00, 2.50, '80', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(81, 'MARAVILHA DE QUEIJO', 0.00, 3.00, '81', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(82, 'PAO AMANTEIGADO', 0.00, 1.50, '82', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(83, 'PAO MANDIR', 0.00, 1.00, '83', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(84, 'COXINHA DE BRIGADEIRO', 0.00, 2.00, '84', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(85, 'BOLO GELADO', 0.00, 6.00, '85', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(86, 'BOLO FORMIGUEIRO', 0.00, 12.00, '86', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(87, 'BOLO DE COCO', 0.00, 18.00, '87', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(88, 'BOLO MESCLADO', 0.00, 12.00, '88', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(89, 'BOLO DE CHOCOLATE', 0.00, 14.00, '89', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(90, 'BOLO DE MILHO', 0.00, 12.00, '90', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(91, 'BOLO DE PAMONHA', 0.00, 10.00, '91', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(92, 'BOLO DE LIMÃƒO', 0.00, 15.00, '92', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(93, 'BOLO DE LARANJA', 0.00, 12.00, '93', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(94, 'BOLO BRIGADEIRO', 0.00, 18.00, '94', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(95, 'BOLO DE LEITE', 0.00, 15.00, '95', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(96, 'BOLO DE TRIGO', 0.00, 12.00, '96', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(97, 'BOLO DE MANDIOCA', 0.00, 15.00, '97', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(98, 'BOLO PUDIM', 0.00, 15.00, '98', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(99, 'BOLO DE FRUTAS', 0.00, 14.00, '99', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(100, 'BOLO DE CENOURA', 0.00, 12.00, '100', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(101, 'BOLO DE ABACAXI', 0.00, 10.00, '101', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(102, 'BOLO GOTAS DE CHOCOLATE', 0.00, 10.00, '102', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(103, 'BOLO PAÃ‡OCÃƒO', 0.00, 15.00, '103', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(104, 'BOLO PAÃ‡OCÃƒO', 0.00, 10.00, '104', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(105, 'BOLO DE REQUEIJÃƒO', 0.00, 10.00, '105', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(106, 'BOLO CAPIXABA', 0.00, 10.00, '106', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(107, 'BOLO COCO FLOCOS', 0.00, 18.00, '107', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(108, 'BOLO DE LEITE NINHO', 0.00, 15.00, '108', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(109, 'BOLO COCADA', 0.00, 15.00, '109', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(110, 'FLORESTA NEGRA', 0.00, 18.00, '110', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(111, 'FLORESTA NEGRA', 0.00, 25.00, '111', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(112, 'BOLO DE FUBÃ', 0.00, 12.00, '112', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(113, 'BOLO PRESTIGIO', 0.00, 15.00, '113', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(114, 'BOLO DE CASTANHA', 0.00, 18.00, '114', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(115, 'BOLO DE AMENDOIM', 0.00, 10.00, '115', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(116, 'BOLO DE CENOURA E CHOCOLATE', 0.00, 15.00, '116', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(117, 'BOLO DE ABACAXI', 0.00, 25.00, '117', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(118, 'BOLO DE BANANA COM GRANOLA', 0.00, 22.00, '118', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(119, 'PAMONHA ASSADA', 0.00, 15.00, '119', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(120, 'BOLO DE QUEIJO', 0.00, 15.00, '120', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(121, 'BOLO DELICIA DE COCO', 0.00, 18.00, '121', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(122, 'BOLO DE MILHO CREMOSO', 0.00, 15.00, '122', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(123, 'BOLO DE LIMAO', 0.00, 10.00, '123', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(124, 'BOLO DE SAL', 0.00, 15.00, '124', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(125, 'BANDEIJA DE BRIGADEIRO', 30.00, 30.00, '125', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(126, 'PRESUNTO', 0.00, 45.00, '126', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(127, 'MUSSARELA', 0.00, 58.00, '127', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(128, 'MORTADELA CONFIANÃ‡A', 0.00, 25.00, '128', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(129, 'MORTADELA BOLONHA', 0.00, 49.00, '129', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(130, 'QUEIJO MINAS', 0.00, 38.00, '130', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(131, 'PEITO DE PERU DEFUMADO', 0.00, 60.00, '131', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(132, 'BOLO DE QUEIJO', 4.00, 4.00, 'SEM-132', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(133, 'CURAL DE MILHO', 0.00, 7.00, 'SEM-133', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(134, 'CUCA DE BANANA', 0.00, 7.00, '134', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(135, 'MILHO VERDE', 0.00, 6.00, '135', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(136, 'BOLO XADREZ', 0.00, 25.00, '136', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(137, 'BOLO DE LIMÃƒO', 0.00, 30.00, '137', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(138, 'BOLO BRIGADEIRO', 0.00, 30.00, '138', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(139, 'BOLO DE MANDIOCA', 0.00, 25.00, '139', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(140, 'CAKE DE MILHO', 0.00, 30.00, '140', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(141, 'BOLO DE PRESTIGIO E CASTANHA', 0.00, 25.00, '141', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(142, 'BOLO DA INDIA', 0.00, 25.00, '142', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(143, 'BOLO DE MANDIOCA C/ COCO', 0.00, 25.00, '143', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(144, 'BOLO MESCLADO', 0.00, 25.00, '144', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(145, 'CAKE DE CHOCOLATE', 0.00, 30.00, '145', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(146, 'BOLO DE MARACUJA', 0.00, 25.00, '146', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(147, 'BOLO DOCE DE LEITE', 0.00, 25.00, '147', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(148, 'BOLO DE LEITE NINHO', 0.00, 25.00, '148', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(149, 'BOLO DE CENOURA E CHOCOLATE', 0.00, 25.00, '149', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(150, 'BOLINHO DA MAMÃƒE', 0.00, 35.00, '150', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(151, 'BOLO DE PRESTIGIO', 0.00, 30.00, '151', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(152, 'TAPIOCA COZIDA B2', 0.00, 7.00, '152', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(153, 'BOLO BOMBOCADO', 0.00, 7.50, '153', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(154, 'BOLO BREVIDADE', 0.00, 25.00, '154', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(155, 'BOLO DE LARANJA', 0.00, 25.00, '155', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(156, 'ROSQUINHA DONUT', 0.00, 5.00, '156', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(157, 'EMPADAO GOIANO', 0.00, 8.00, '157', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(158, 'ROMEU E JULIETA', 0.00, 25.00, '158', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(159, 'BOLO MARMORE', 0.00, 7.00, '159', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(160, 'BOLO DE CHOCOLATE', 0.00, 6.50, '160', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(161, 'CUCA DE BANANA', 0.00, 25.00, '161', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(162, 'TORTA DE ABACAXI', 0.00, 25.00, '162', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(163, 'BOLINHO CUPCAKE', 0.00, 8.00, '163', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(164, 'ROCAMBOLE M6', 0.00, 40.00, '164', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(165, 'SANDUICHE VRAP', 0.00, 25.00, '165', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(166, 'SANDUICHE NATURAL', 0.00, 45.00, '166', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(167, 'BANDEIJA DE BRIGADEIRO 36 UNIDADES', 0.00, 25.00, '167', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(168, 'TORTA SALGADA B2', 0.00, 8.00, '168', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(169, 'TORTA DE PRESUNTO', 0.00, 7.00, '169', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(170, 'TORTA DE BANANA', 0.00, 25.00, '170', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(171, 'TEREZA RECHEADA', 0.00, 26.00, '171', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(172, 'MINI ENROLADINHO', 0.00, 39.00, '172', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(173, 'MINI ENROLADINHO DE FRANGO', 0.00, 36.00, '173', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(174, 'ENROLADINHO DE PRESUNTO E QUEIJO', 0.00, 40.00, '174', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(175, 'MINI ENROLADINHO DE CARNE', 0.00, 36.00, '175', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(176, 'MINI ENROLADINHO DE QUEIJO', 0.00, 38.00, '176', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(177, 'BOLO DE PAMONHA', 0.00, 7.00, '177', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(178, 'BOLO DE MANDIOCA', 0.00, 4.00, '178', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(179, 'PAOZINHO DE MEL', 0.00, 55.00, '179', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(180, 'ADICIONAL RECHEIO', 0.00, 5.00, '180', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(181, 'RED VELVET/LEITE NINHO', 0.00, 30.00, '181', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(182, 'BOLO DE CHURROS', 0.00, 28.00, '182', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(183, 'BOLO DE CAFÃ‰ C/ CHOCOLATE', 0.00, 30.00, '183', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(184, 'CAKE BRIGADEIRO', 0.00, 28.00, '184', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(185, 'CAKE MARACUJA', 0.00, 28.00, '185', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(186, 'CAKE COM GOTAS DE CHOCOLATE', 0.00, 28.00, '186', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(187, 'PAMONHA ASSADA', 0.00, 5.00, '187', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(188, 'MINE PAO PIZZA', 0.00, 40.00, '188', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(189, 'BOLO FLOCOS DE MILHO', 0.00, 4.00, '189', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(190, 'BOLO PERNILONGO', 0.00, 28.00, '190', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(191, 'BOLO DE MANDIOCA', 0.00, 7.00, '191', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(192, 'BOLO PRESTIGIO', 0.00, 30.00, '192', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(193, 'BOLO DE CHOCOLATE C/ AMENDOIM', 0.00, 25.00, '193', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(194, 'BOLO FLOCOS', 0.00, 25.00, '194', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(195, 'PAO DE QUEIJO NO PACOTE', 0.00, 25.00, '195', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(196, 'ROSCA DE CREME', 0.00, 22.00, '196', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(197, 'ROSCA DE COCO', 0.00, 22.00, '197', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(198, 'ROSQUINHA CONFEITEIRA', 0.00, 25.00, '198', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(199, 'TORTA RECHEIO TRADICIONAL', 0.00, 50.00, '199', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(200, 'PAO SOVADO P', 0.00, 3.00, '200', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(201, 'PAO SOVADO M', 0.00, 5.00, '201', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(202, 'PAO SOVADO G', 0.00, 8.00, '202', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(203, 'PAO CARECA', 0.00, 6.00, '203', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(204, 'MINI PAO CARECA 50 UN', 0.00, 25.00, '204', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(205, 'PAO DE LEITE', 0.00, 22.00, '205', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(206, 'PAO DE LEITE C/ QUEIJO', 0.00, 9.50, '206', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(207, 'PETROPOLES', 0.00, 8.00, '207', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(208, 'PAO DE ERVA', 0.00, 22.00, '208', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(209, 'PAO DE MILHO', 0.00, 22.00, '209', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(210, 'PAO BATATA', 0.00, 2.00, '210', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(211, 'PAO BRIOCHE', 0.00, 22.00, '211', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(212, 'PAO DE FORMA', 0.00, 8.00, '212', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(213, 'PAO CASEIRO', 0.00, 7.00, '213', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(214, 'BISNAGUINHA', 0.00, 25.00, '214', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(215, 'PAO DE HAMBURGUER', 0.00, 6.00, '215', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(216, 'BISCOITO PAULISTA', 0.00, 25.00, '216', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(217, 'BISCOITO DE QUEIJO', 0.00, 7.00, '217', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(218, 'CROISSANT', 0.00, 2.50, '218', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(219, 'ROSCA DE CALABRESA', 0.00, 10.00, '219', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(220, 'CALZONE', 0.00, 25.00, '220', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(221, 'TORRADA', 0.00, 30.00, '221', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(222, 'PETA', 0.00, 30.00, '222', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(223, 'PETA', 0.00, 30.00, '223', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(224, 'MINI BROA TEMPERADA', 0.00, 30.00, '224', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(225, 'MINI QUEBRADOR', 0.00, 30.00, '225', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(226, 'SEQUILHOS', 0.00, 30.00, '226', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(227, 'SUSPIRO', 0.00, 30.00, '227', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(228, 'FARINHA DE ROSCA', 0.00, 15.99, '228', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(229, 'AMANTEIGADOS', 0.00, 30.00, '229', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(230, 'COOKIES', 0.00, 30.00, '230', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(231, 'DELICIA DE MAIZENA', 0.00, 30.00, '231', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(232, 'CUECA VIRADA', 0.00, 25.00, '232', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(233, 'MARIA MOLE', 0.00, 30.00, '233', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(234, 'PIZZA COM BORDA', 0.00, 30.00, '234', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(235, 'MINI PIZZA', 7.00, 7.00, '235', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(236, 'BISCOITINHO DE COCO', 0.00, 30.00, '236', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(237, 'INHOQUE', 0.00, 0.70, '237', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(238, 'BOLACHA 7 CAPAS', 0.00, 30.00, '238', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(239, 'BOLACHINHA SECA', 0.00, 30.00, '239', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(240, 'BROWNIE', 0.00, 30.00, '240', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(241, 'CAROLINA', 0.00, 40.00, '241', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(242, 'BOLINHO DE CHOCOLATE', 0.00, 4.00, '242', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(243, 'BOLINHO DE CENOURA', 0.00, 4.00, '243', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(244, 'DELICIA DE COCO', 0.00, 4.00, '244', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(245, 'ROSQUINHA DE LEITE', 0.00, 22.00, '245', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(246, 'BOLINHO COCADA', 0.00, 4.00, '246', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(247, 'BOLINHO DE CHOCOLATE', 0.00, 30.00, '247', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(248, 'HUNGARA DE COCO', 0.00, 35.00, '248', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(249, 'HUNGARA DE CHOCOLATE', 0.00, 29.99, '249', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(250, 'ROSCA RAINHA G', 0.00, 26.00, '250', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(251, 'ROSCA RAINHA P', 0.00, 8.00, '251', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(252, 'PAO DE LEITE C/ CREME', 0.00, 22.00, '252', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(253, 'SONHO AMERICANO', 0.00, 1.50, '253', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(254, 'PAO CASCA DE BANANA', 0.00, 22.00, '254', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(255, 'PAO DE MILHO', 0.00, 1.00, '255', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(256, 'PAO ESPIGA', 0.00, 22.00, '256', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(257, 'PANETONE DE FRUTAS', 0.00, 12.00, '257', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(258, 'PANETONE DE UVA PASSAS', 0.00, 12.00, '258', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(259, 'PANETONE DE GOTAS DE CHOCOLATE', 0.00, 12.00, '259', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(260, 'PAMONHA ASSADA', 0.00, 6.00, '260', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(261, 'PAO SIRIO', 0.00, 22.00, '261', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(262, 'PAO CASEIRINHO', 0.00, 22.00, '262', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(263, 'PAO DE CENOURA', 0.00, 22.00, '263', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(264, 'BOLO PISCINA', 0.00, 20.00, '264', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(265, 'MINI BROA DE MILHO', 0.00, 25.00, '265', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(266, 'BALINHA', 0.00, 0.25, '2284', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(267, 'OVO UNIDADE', 0.00, 1.00, '267', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(268, 'KIT FESTA 15', 0.00, 149.99, 'SEM-268', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(269, 'KIT FESTA 30', 0.00, 289.99, 'SEM-269', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(270, 'KIT FESTA 45', 0.00, 439.99, 'SEM-270', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(271, 'MORTADELA CONFIANCA', 0.00, 25.00, '971', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(272, 'PUDIM FAMÃ­LIA', 0.00, 50.00, '272', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(273, 'BREVIDADE', 0.00, 5.00, '00', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(274, 'PIZZA TRADICIONAL MINI', 0.00, 6.00, '274', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(275, 'ADICIONAL', 0.00, 2.00, '275', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(276, 'TORTA RECHEIO ESPECIAL KG', 0.00, 59.90, '276', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(277, 'OLHO DE SOGRA', 0.00, 30.00, '277', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(278, 'PAO MINEIRO CASEIRO', 0.00, 6.00, '278', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(279, 'ENROLADINHO CALABRESA', 0.00, 38.00, '279', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(280, 'BOLO FORMIGUEIRO', 0.00, 25.00, '280', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(281, 'BOLO DE LARANJA COM COBERTURA', 0.00, 15.00, '281', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(282, 'M. FOLHEADA C. QUEIJO', 0.00, 38.00, '282', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(283, 'FOLHEADO DE GOIABADA', 0.00, 40.00, '283', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(284, 'PET FLOR SALGADO', 0.00, 30.00, '284', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(285, 'BELISCÃ£O', 0.00, 30.00, '285', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(286, 'SURPRESINHA DE FRANGO', 0.00, 39.00, '286', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(287, 'BOLO DE CASTANHA', 0.00, 30.00, '287', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(288, 'BOLO DE MORANGO', 0.00, 30.00, '288', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(289, 'QUEIJADINHA M6', 0.00, 7.00, '289', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(290, 'QUINDIM', 0.00, 6.00, '290', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(291, 'TORTA DE CARNE', 0.00, 7.00, '291', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(292, 'QUADRADIN GOURMET', 0.00, 8.00, '292', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(293, 'PIPOCA LEITE NINHO', 0.00, 20.00, '293', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(294, 'BOLACHA CHAMPANHE', 0.00, 22.00, '294', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(295, 'FOLHEADO DE PRESUNTO', 0.00, 36.00, '295', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(296, 'CENTO DE SALGADO', 0.00, 45.00, '296', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(297, 'MEIO CENTO DE MINI SALGADO', 0.00, 22.50, '297', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(298, 'ROSQUINHA DE CEREJA', 0.00, 30.00, '298', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(299, 'BOLO DE FUBA', 0.00, 22.00, '299', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(300, 'CHUPETITA', 0.00, 1.50, '300', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(301, 'TEREZA DE FRANGO', 0.00, 7.00, '301', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(302, 'TEREZA DE PRESUNTO', 0.00, 7.00, '302', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(303, 'BOLINHO DE PAMONHA', 0.00, 1.00, '303', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(304, 'FOLHEADO DE CATUPIRY', 0.00, 38.00, '304', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(305, 'BISCOITO DE NATA', 0.00, 70.00, '305', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(306, 'BROA TEMPERADA', 0.00, 2.00, '306', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(307, 'PAO DE ALHO', 0.00, 2.00, '307', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(308, 'CENTO MINI PAES PRA DOG', 0.00, 50.00, '345', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(309, 'CUSCUZ', 0.00, 5.00, '345-309', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(310, 'BOLINHO CUPCAKE', 0.00, 1.50, '310', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(311, 'BOLO DE LARANJA INGLES', 0.00, 5.00, '311', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(312, 'LASANHA FOLHEADO', 0.00, 39.00, '312', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(313, 'CAKE DE DOCE DE LEITE', 0.00, 28.00, '313', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(314, 'BOLO TONE', 0.00, 8.00, '314', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(315, 'BOLO TONE UN', 0.00, 1.50, '315', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(316, 'CHOCOTONE', 0.00, 12.00, '316', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(317, 'CUPCAKE RED VELVET', 0.00, 7.00, '317', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(318, 'CUCA DE GOIABADA', 0.00, 30.00, '318', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(319, 'RABANADA', 0.00, 30.00, '319', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(320, 'SOBREMESA', 0.00, 4.00, '2902', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(321, 'CASADINHO DOCE DE LEITE', 0.00, 45.00, '321', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(322, 'BISCOITO DE COCO', 0.00, 40.00, '322', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(323, 'PAO MINEIRINHO', 0.00, 22.00, '323', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(324, 'BOLO DE PISTACHE', 0.00, 25.00, '324', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(325, 'BISCOITO CHAMPANHE', 0.00, 25.00, '325', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(326, 'PETA', 0.00, 4.00, '326', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(327, 'BOLO NO POTE G', 0.00, 8.00, '327', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(328, 'GOIABADA', 0.00, 3.00, '328', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(329, 'FOLEADO DE CHOCOLATE', 0.00, 4.00, '329', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(330, 'MINI PAO DE LEITE C/ QUEIJO', 0.00, 6.00, '330', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(331, 'BOLINHO CUPCAKE', 0.00, 4.00, '331', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(332, 'BISCOITO DE CANELA', 0.00, 70.00, '336', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(333, 'BOLO PISCINA G', 0.00, 30.00, '333', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(334, 'PANETONE P', 0.00, 4.99, '334', 1, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1000, 'SCHWEPPES TONICA 310ML', 0.00, 4.00, '7894900301151', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1001, 'MONSTER PIPELINE 473ML', 0.00, 10.00, '7898938890045', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1002, 'BATATA PALHA AMARELINHA 90G', 0.00, 6.50, '7896221400605', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1003, 'MILHO DE PIPOCA PACHÃ¡ 500G', 0.00, 5.00, '7896602900212', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1004, 'CREME DE LEITE MOCOCA UHT 200G', 0.00, 4.50, '7891030003467', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1005, 'LIMPADOR CASA FLOR 500ML', 0.00, 5.00, '7896440503934', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1006, 'KETCHUP FUGINI 180G', 0.00, 3.00, '7897517207540', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1007, 'MOLHO DE PIMENTA PINGO 150ML', 0.00, 4.00, '7896215300874', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1008, 'LAVA LOUÃ§AS BRISA NEUTRO', 0.00, 3.00, '7908324400380', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1009, 'LAVA LOUÃ§AS BRISA COCO', 0.00, 3.00, '7908324403466', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1010, 'VELA SUPER ESTELAR', 0.00, 10.00, '7891175483483', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1011, 'PASSATEMPO CHOCOMIX', 0.00, 3.50, '7891000259405', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1012, 'NESTON 280ML', 0.00, 8.50, '7891000090732', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1013, 'NESCAU 270ML', 0.00, 8.50, '7891000101926', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1014, 'ALPINO 270ML', 0.00, 8.50, '7891000067048', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1015, 'SUCO LARANJA NUTRI 1,350 LT', 0.00, 15.00, '7898961490533', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1016, 'TRENTO MILK 29G', 0.00, 3.50, '7896306625312', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1017, 'TRENTO MASSIMO AVELÃ£ CASTANHA E AMENDOIM 2', 0.00, 3.50, '7896306625145', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1018, 'DEL VALLE FRT LARANJA 450ML', 0.00, 5.50, '7894900556056', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1019, 'DEL VALLE FRUT FRUTAS CITRICAS 450ML', 0.00, 5.50, '7894900666502', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1020, 'SERENATA DE AMOR', 0.00, 1.50, '7891008414127', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1021, 'SORRISO 50G', 0.00, 3.50, '7891528038025', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1022, 'EMBARE 395G', 0.00, 7.00, '7896259423560', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1023, 'FLOCAO DE MILHO JUNINO 500G', 0.00, 2.00, '7896369617064', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1024, 'BISÂ´S 40G', 0.00, 3.50, '7891330009176', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1025, 'NUTRI NECTAR PESSEGO 1L', 0.00, 7.00, '7898961490489', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1026, 'IOIO MIX', 0.00, 3.99, '7899970402456', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1027, 'FLOCOS DE MILHO 70 G', 0.00, 2.50, '618341475182', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1028, 'FLOCOS DE MILHO 70 G', 0.00, 2.50, '618341475182-1028', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1029, 'MONSTER ULTRA FIESTA MANGO 473ML', 0.00, 10.00, '7898938890113', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1030, 'FANTA UVA 600ML', 0.00, 6.00, '7894900053630', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1031, 'CREME DE LEITE LEITBOM 200G', 0.00, 4.00, '7898215155041', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1032, 'GUNE 3EM1 345ML', 0.00, 8.50, '618341475328', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1033, 'BARBECUE 370G', 0.00, 9.50, '618341475304', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1034, 'HEINZ KETCHUP 260G', 0.00, 8.50, '7896102000382', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1035, 'DIPLOKO CABECA DE ABOBORA', 0.00, 3.00, '7898964630356', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1036, 'DIPLOKO OLHO', 0.00, 3.00, '7898963171928', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1037, 'CAFÃ© DO SITIO 250GK', 0.00, 20.00, '7896759900011', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1038, 'NUTRI LARANJA', 0.00, 7.00, '7898961490526', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1039, 'GUARANA ANTARTICA 2L', 0.00, 9.00, '7891991001342', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1040, 'GUARANÃ¡ MINEIRO 2L', 0.00, 8.00, '7897184000017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1041, 'GOIANINHO 850G', 0.00, 7.49, '7898644341176', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1042, 'PURA AGUA MINERAL', 0.00, 5.00, '7898910905033', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1043, 'FANTA LARANJA 200ML', 0.00, 3.00, '78936478', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1044, 'OLEO DE GIRASSOL 1L', 0.00, 12.00, '7891107111910', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1045, 'OLEO DE MILHO', 0.00, 9.50, '7891107111934', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1046, 'DETERGENTE NEUTRO GUNE 500ML', 0.00, 3.00, '618341474741', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1047, 'PAPEL H. BEST 4 ROLOS', 0.00, 6.00, '7896053470166', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1048, 'SABAO EM PO ASSIM 800G', 0.00, 10.50, '7908324402681', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1049, 'LEITE CONDENSADO TRIANGULO 395G', 0.00, 7.00, '7896434921133', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1050, 'MACARRAO CRISTAL COM OVOS 500G', 0.00, 6.00, '7896212911660', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1051, 'BATATA PALHA KARIS 70G', 0.00, 4.00, '7898966834004', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1052, 'SOPAO APTI GALINHA E VEGETAIS 180G', 0.00, 6.50, '7896327515913', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1053, 'CREAM CRACKER FORTALEZA 350G', 0.00, 6.50, '7891152801446', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1054, 'FREEGELLS EXTRA FORTE', 0.00, 2.00, '7891151039772', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1055, 'FINI TWISTER 15G', 0.00, 2.00, '7898591457845', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1056, 'MONSTER ULTRA 473ML', 0.00, 10.00, '070847022206', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1057, 'MONSTER ABSOLUTELY ZERO 473ML', 0.00, 10.00, '070847022305', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1058, 'MONSTER ULTRA VIOLET 473ML', 0.00, 10.00, '070847033929', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1059, 'NUTRI NECTAR MAÃ§A 1L', 0.00, 7.00, '7898920195424', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1060, 'NUTRI NECTAR LIMONADA 1L', 0.00, 7.00, '7898961490410', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1061, 'CREMOSY', 0.00, 6.00, '7894904271504', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1062, 'BISCOITO RANCHEIRO 90G', 0.00, 3.50, '7896253401397', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1063, 'BISCOITO FOINHO BAUNILHA 110G', 0.00, 2.50, '7898176550336', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1064, 'BISCOITO FOFINHO MORANGO E CHOCOLATE 110G', 0.00, 2.50, '7898176550329', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1065, 'CREAM CRACKER TOST 350G', 0.00, 6.00, '7896532701781', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1066, 'PAPEL HIGIENICO MIMMO 6 ROLO', 0.00, 12.50, '7898962794395', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1067, 'PAPEL HIGIENICO SUBLIME 4 ROLOS', 0.00, 5.00, '7896061915109', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1068, 'BISCOITO DE MAIZENA AMANDA 300G', 0.00, 6.50, '7898921667401', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1069, 'ROSQUINHA BEL COCO 300G', 0.00, 5.50, '7898921667050', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1070, 'KINDER JOY', 0.00, 9.00, '78602731', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1071, 'POLVILHO DOCE CAIPIRA', 0.00, 7.50, '7898042330024', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1072, 'PIMENTA GUNE EXTRA FORTE 150ML', 0.00, 3.50, '618341475380', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1073, 'KETCHUP GUNE', 0.00, 4.50, '618341475236', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1074, 'FUGINI BARBECUE 180G', 0.00, 4.00, '7897517207571', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1075, 'PASTA ALHO E SAL UBOM 400G', 0.00, 8.50, '7896312702182', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1076, 'EXTRATO DE TOMATE PREDILECTA 260G', 0.00, 10.30, '7896292301429', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1077, 'SARDINHA COQUEIRO TOMATE 125G', 0.00, 7.50, '7896009301063', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1078, 'PALITO GINA 100 UNIDADES', 0.00, 2.00, '7896051020127', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1079, 'FAROFA CASEIRA UBOM 400G', 0.00, 4.99, '7896312700645', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1080, 'FUBA UBOM 1K', 0.00, 4.50, '7896312700386', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1081, 'FARINHA M BRANCA UBOM 1K', 0.00, 6.50, '7896312700317', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1082, 'FARINHA MANDIOCA AMARELA UBOM', 0.00, 7.00, '7896312723019', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1083, 'FARINHA UBOM', 0.00, 6.50, '7896312734008', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1084, 'ASSIM TRIPLA AÃ§AO 800G', 0.00, 10.50, '7908324402698', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1085, 'KIT NOVEX KERATINA 300ML', 0.00, 15.00, '7896013507024', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1086, 'KIT NOVEX ARGAN 300 ML', 0.00, 15.00, '7896013553908', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1087, 'CLOSEUP  HORTELA 70G', 0.00, 4.50, '7891150049888', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1088, 'SORRISO 70G', 0.00, 5.50, '7891528029498', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1089, 'SABONETE ABOVE EXTREME BLACK 75G', 0.00, 3.00, '7899674042729', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1090, 'SABONETE ABOVE CREAM 75G', 0.00, 3.50, '7899674042705', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1091, 'POLVILHO DOCE UBOM', 0.00, 6.75, '7896312700430', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1092, 'MILHO DE PIPOCA UBOM 500G', 0.00, 3.50, '7896312700416', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1093, 'CANJICA BRANCA UBOM 500G', 0.00, 3.50, '7896312700263', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1094, 'CANJICA DE MILHO AMARELA UBOM 500G', 0.00, 2.50, '7896312700256', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1095, 'AMENDOIM UBOM 500G', 0.00, 7.00, '7896312700249', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1096, 'MASSA PRONTA TAPIOCA UBOM 500G', 0.00, 4.50, '7896312723194', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1097, 'TALENTO MEIO AMARGO  AMENDOAS 85G', 0.00, 10.50, '7891008121575', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1098, 'GAROTO CROCANTE 80G', 0.00, 10.00, '7891008124071', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1099, 'PASTILHA GAROTO HORTELA', 0.00, 1.50, '78910041', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1100, 'INTIMUS 16 UNIDADES', 0.00, 10.50, '7896007545100', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1101, 'INTIMUS COBERTURA SUAVE 16 U', 0.00, 10.50, '7896007545094', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1102, 'INTIMUS  C/ABAS 8 UN', 0.00, 6.00, '7896007540631', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1103, 'ALBANY LAVANDA', 0.00, 2.50, '7908324403985', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1104, 'ALBANY JASMIM', 0.00, 2.50, '7908324408430', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1105, 'HERSHEYS BARRA 82G', 0.00, 8.00, '7899970402821', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1106, 'LEITE MARAJOARA 1L', 0.00, 6.50, '7896354100113', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1107, 'BRAZILIAN COFFEE HALLS 30G', 0.00, 2.50, '7896321017383', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1108, 'FREEGELLS EUCALIPTO 27G', 0.00, 2.00, '7891151039758', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1109, 'TRENTO MORANGO 29G', 0.00, 3.50, '7896306625336', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1110, 'LINGUIÃ§A PERNIL SUINO 600G', 0.00, 15.00, '7898610190166', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1111, 'LINGUIÃ§A APIMENTADA 600G', 0.00, 15.00, '7898610190173', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1112, 'REQUEIJAO CREMOSO TRAD VIGOR CP 200G', 0.00, 10.50, '7891999144485', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1113, 'LEITE FERMENTADO MINIONS VIGOR 75G', 0.00, 1.50, '78913554', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1114, 'PETIT SUISSE VIGOR BANDEIJA COM 8', 0.00, 11.50, '7896625211043', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1115, 'SUCO VIG MORANGO 200ML', 0.00, 3.00, '7891999340108', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1116, 'SUCO VIG UVA 200ML', 0.00, 3.00, '7891999100047', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1117, 'IOGURTE POLPA VIGOR BANDEIJA C/6 510G', 0.00, 8.50, '7896625211258', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1118, 'IOG GREGO FRUTAS AMARELAS 90G', 0.00, 4.00, '7896625211128', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1119, 'IOG GREGO FLOCOS CHOCOLATE 90G', 0.00, 4.00, '7896625211081', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1120, 'IOG GREGO FRUTAS VERMELHAS 90G', 0.00, 4.00, '7896625211111', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1121, 'IOG GREGO TRADICIONAL VIGOR 90G', 0.00, 4.00, '7896625211142', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1122, 'SAL FAVORITO 1KG', 0.00, 3.00, '602883933569', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1123, 'YPE NEUTRO 500ML', 0.00, 3.00, '7896098900208', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1124, 'YPE CAPIM LIMÃ£O 500ML', 0.00, 3.00, '7896098902042', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1125, 'YPE MAÃ§Ã£ 500ML', 0.00, 3.00, '7896098900215', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1126, 'CREME DE LEITE ITALAC 200G', 0.00, 4.50, '7898080640222', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1127, 'FINI AZEDINHOS 15G', 0.00, 2.00, '7898591459498', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1128, 'FINI UVA 15G', 0.00, 2.00, '7898591455629', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1129, 'FINI MINHOCAS 15G', 0.00, 2.00, '7898591450723', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1130, 'FINI AMORAS 15G', 0.00, 2.00, '7898591450648', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1131, 'CRISTAL COPO 150 ML', 0.00, 6.50, '7898939720044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34');
INSERT INTO `tb1_produto` (`tb1_id`, `tb1_nome`, `tb1_vlr_custo`, `tb1_vlr_venda`, `tb1_codbar`, `tb1_tipo`, `tb1_status`, `tb1_favorito`, `tb1_vr_credit`, `created_at`, `updated_at`) VALUES
(1132, 'RED BULL MELANCIA 250ML', 0.00, 10.00, '9002490247379', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1133, 'RED BUL AMORA 250ML', 0.00, 10.00, '9002490275020', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1134, 'RED BULL MELAO 250ML', 0.00, 10.00, '9002490275013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1135, 'PAÃ§OKÃ£O', 0.00, 3.00, '7896595591947', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1136, 'BANANADA CREMOSA', 0.00, 2.00, '7898922790061', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1137, 'LUCKY STRIKE DOUBLE FROST', 0.00, 15.00, '78946293', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1138, 'PALHEIROS TERRA TOMBADA', 0.00, 8.00, '7898957589616', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1139, 'NEUGEBAUER AO LEITE', 0.00, 6.00, '7891330019120', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1140, 'NEUGEBAUER AMENDOIM', 0.00, 6.00, '7891330019144', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1141, 'NEUGEBAUER BRANCO', 0.00, 6.00, '7891330019298', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1142, 'INTENSE CHOCOLATE AMARGO 9G', 0.00, 2.00, '7891330018550', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1143, 'SUPREME CHOCOLATE LEITE 9G', 0.00, 2.00, '7891330019809', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1144, 'PALHEIROS MENTA', 0.00, 8.00, '7898957589524', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1145, 'PALHEIROS UVA', 0.00, 8.00, '7898957589548', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1146, 'DEL VALE  LARANJA1,5 L', 0.00, 12.50, '7894900556063', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1147, 'MABEL CREAM CRAKER 300G', 0.00, 6.00, '7896071030052', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1148, 'HERSHEYÂ´S 40 CACAU MEIO AMARGO 82G', 0.00, 8.00, '7899970402838', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1149, 'TALENTO AVELÃ£ 85G', 0.00, 10.00, '7891008121728', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1150, 'TALENTO CASTANHA-DO-PARÃ¡ 85G', 0.00, 10.00, '7891008121773', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1151, 'IOIO MIX CHOCO 11,9 G', 0.00, 3.99, '7899970402463', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1152, 'MENTOS SABOR BLUER RASPBERRY', 0.00, 3.50, '7895144892832', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1153, 'KINDER JOY 20G', 0.00, 9.00, '78602731-1153', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1154, 'SABAO EM BARRA BRISA NEUTRO 900G', 0.00, 12.00, '7908324402933', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1155, 'FLOCAO GOTA 400G', 0.00, 2.40, '7898617581820', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1156, 'FUBA MIMOSO 500G', 0.00, 3.00, '7892300026629', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1157, 'MENTOS COOL WHITE TUTTI FRUTTI', 0.00, 3.50, '8935001728306', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1158, 'MENTOS PURE FRESH SPEARMINT', 0.00, 3.50, '7895144892931', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1159, 'MENTOS PURE FRESH STRONG MINT', 0.00, 3.50, '7895144893730', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1160, 'MENTOS PURE FRESH MINT', 0.00, 3.50, '8935001728283', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1161, 'MENTOS PURE FRUIT FRUTAS', 0.00, 3.50, '7895144899930', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1162, 'NUTRI NECTAR SABOR MAÃ§A', 0.00, 2.50, '7898961490625', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1163, 'NISSIN PICANHA', 0.00, 3.00, '7891079011775', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1164, 'LATA LEITE NINHO', 0.00, 27.00, '7891000393284', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1165, 'MAIONESE  HELLMANNS', 0.00, 14.50, '7894000050034', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1166, 'DUNHILL FREE', 0.00, 15.00, '78943131', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1167, 'ROTHMANS BLUE', 0.00, 10.00, '78944541', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1168, 'BELAGURT MORANGO 1,1KG', 0.00, 10.49, '7898644341916', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1169, 'COOKIE INTEGRAL NESFIT 60G', 0.00, 4.00, '7891000255773', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1170, 'GUARANA AMAZONA ZERO 2L', 0.00, 7.50, '7898962842133', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1171, 'IORGUTE VIGOR MORANGO C/6 510G', 0.00, 8.50, '7896625211265', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1172, 'VIGOR MORANGO 170G', 0.00, 4.00, '7896625210466', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1173, 'TESTE', 0.00, 12.01, '6912478457450', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1174, 'MONSTER PACIFIC PUNCH', 0.00, 10.00, '1220000250031', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1175, 'BALY TRAD. 2L', 0.00, 12.00, '7898080662668', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1176, 'AMACIANTE MINUANO', 0.00, 12.00, '7897664150010', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1177, 'DESINFETANTE MARINE 500ML', 0.00, 2.50, '7897664140561', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1178, 'MINUANO MAÃ§A 500ML', 0.00, 4.00, '7897664130012', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1179, 'DESINFETANTE FLORAL MINUANO 500ML', 0.00, 2.50, '7897664140219', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1180, 'SABONETE SIE 85G', 0.00, 2.50, '7898086585923', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1181, 'SABONETE SIE 85G', 0.00, 2.50, '11807898086585930', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1182, 'SABONETE SIE 85G', 0.00, 2.50, '7898086585961', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1183, 'ASSOLAN 45G 8 U', 0.00, 3.50, '7896090100101', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1184, 'ESPONJA GUNE', 0.00, 1.50, '609963909834', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1185, 'ROSQUINHAS MABEL COCO  600G', 0.00, 9.00, '7896071025638', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1186, 'MINUETO MORANGO 73G', 0.00, 2.50, '7896004009957', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1187, 'MINUETO CHOCOLATE COM BAUNILHA', 0.00, 2.50, '7896004009971', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1188, 'MINUETO CHOCOLATE 73G', 0.00, 2.50, '7896004009940', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1189, 'BOM DE BOLA FLOCOS 101G', 0.00, 2.50, '7896004010823', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1190, 'BOM DE BOLA DUO CHOCOLATE', 0.00, 2.50, '7896004010816', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1191, 'BOM DE BOLA MORANGO', 0.00, 2.50, '7896004010809', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1192, 'BOM DE BOLA CHOCOLATE', 0.00, 2.50, '7896004010793', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1193, 'TRIANGULO MISTURA DE LEITE', 0.00, 3.00, '7896434921058', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1194, 'KETCHUP TRADICIONAL BONARE 390G', 0.00, 8.50, '7898905153982', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1195, 'CHEETOS MIX 41G', 0.00, 4.00, '7892840824068', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1196, 'BATATA PALHA GUINE 80G', 0.00, 6.50, '618341474840', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1197, 'TRENTO MAIS LEITE DUO 29G', 0.00, 3.50, '7896306625299', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1198, 'TRETO CARAMELO 29G', 0.00, 3.00, '7896306625466', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1199, 'SIENE', 0.00, 2.50, '7898086585930', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1200, 'FANTA LARANJA 600ML', 0.00, 6.00, '7894900031607', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1201, 'FREEGELLS MELANCIA', 0.00, 2.00, '7891151041591', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1202, 'Ã¡LCOOL 70 DE 1L', 0.00, 10.50, '7897946400833', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1203, 'RUFFLES PIMENTA MEXICANA', 0.00, 4.00, '7892840824211', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1204, 'CORY AO LEITE 68G', 0.00, 4.00, '7896286621854', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1205, 'PAPEL H. NOBLE 12 ROLOS', 0.00, 12.00, '7896061917608', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1206, 'MINI DISQUETE 11G', 0.00, 1.50, '7896058500110', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1207, 'SURPRESA CHOCOLATE 20G', 0.00, 3.00, '7891000408490', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1208, 'ROLL BALDUCCO', 0.00, 2.50, '7891962051574', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1209, 'BATOM AO LEITE', 0.00, 2.00, '7891000440339', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1210, 'REQUEIJÃ£O CREMOSO ITAMBÃ© 200G', 0.00, 12.00, '7896051140016', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1211, 'POWER ADE SOUR MAÃ§A VERDE 500ML', 0.00, 6.00, '7894900509601', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1212, 'CANUDIMHO GREGO DOCILE 15G', 0.00, 1.50, '7896451914569', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1213, 'CANUDINHO TUTTI FRUTTI 15 G', 0.00, 1.50, '7896451912510', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1214, 'CANUDINHO SABOR MORANGO DOCILE 15G', 0.00, 1.50, '7896451912497', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1215, 'DEL VALLE PESSEGO 200ML', 0.00, 4.00, '7894900660425', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1216, 'DEL VALLE UVA 200ML', 0.00, 4.00, '7894900660432', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1217, 'DEL VALLE LARANJA 200ML', 0.00, 4.00, '7894900660418', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1218, 'DEL VALLE PESSEGO 1L', 0.00, 11.00, '7898341430036', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1219, 'DEL VALLE MARACUJA 1L', 0.00, 11.00, '7898341430074', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1220, 'ICE TEA LEÃ£O LIMÃ£O', 0.00, 3.50, '7891098040831', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1221, 'DEL VALE  CAJU 1L', 0.00, 11.00, '7898341430081', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1222, 'DEL VALLE SABOR PÃªSSEGO', 0.00, 11.00, '12217898341430036', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1223, 'DEL VALLE  PÃªSSEGO SEM AÃ§ÃºCAR', 0.00, 11.00, '12227898341430043', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1224, 'DEL VALLE  MARACUJÃ¡', 0.00, 11.00, '12237898341430074', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1225, 'SHOWKINHO 200ML', 0.00, 2.50, '7896256602111', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1226, 'PAPEL HIGIENICO BIANCO 4 ROLOS FOLHAS SIMPLES', 0.00, 6.00, '7896104998434', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1227, 'COCADA', 0.00, 4.00, '7892883100013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1228, 'COPO 300 ML', 0.00, 12.00, '7898939720105', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1229, 'LACTA OURO BRANCO 98G', 0.00, 10.00, '7622210528216', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1230, 'VELA CORAÃ§Ã£O DOURADA', 0.00, 10.00, '7899044200131', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1231, 'VELA ESTRELADA DOURADA', 0.00, 10.00, '17899044200087', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1232, 'ARISCO COMPLETO SEM PIMENTA 300G', 0.00, 8.00, '7891700011204', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1233, 'SYM', 0.00, 5.00, '7896110003863', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1234, 'SORRISO DENTES BRANCOS 180G', 0.00, 8.00, '7891528038001', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1235, 'CLOSEUP 70G DENTES FORTE', 0.00, 5.00, '7891150049895', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1236, 'GAROTO CROCANTE 25G', 0.00, 3.80, '7891008124583', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1237, 'DEL VALE 1L', 0.00, 11.00, '7898341430043', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1238, 'CRONY ORIGINAL 76', 0.00, 7.50, '7896245710230', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1239, 'CRONY CHURRASCO 76G', 0.00, 7.50, '7896245710254', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1240, 'CRONY CEBOLA E SALSA 35G', 0.00, 3.80, '7896245709807', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1241, 'CRONY CHURRASCO 35G', 0.00, 3.80, '7896245709791', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1242, 'MICOS PRESUNTO 105G', 0.00, 8.00, '7896245710315', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1243, 'MICOS GALINHA 100G', 0.00, 8.00, '7896245710292', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1244, 'ANELITOS CEBOLA 91G', 0.00, 8.00, '7896245710322', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1245, 'MICOS REQUEIJAO 105G', 0.00, 8.00, '7896245710308', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1246, 'REFINATA CLASSICA 35G', 0.00, 4.00, '7896245710377', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1247, 'REFINATA BATATA LISA PICANHA AO ALHO 40G', 0.00, 5.00, '7896245710131', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1248, 'REFINATA', 0.00, 6.00, '7896245710117', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1249, 'GOIABADA AMORE 200G', 0.00, 3.00, '7897977910332', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1250, 'FAMILIA MORANGO 2L', 0.00, 29.99, '7898081810013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1251, 'SELETOS CHOCOMENTA 1,5L', 0.00, 23.99, '7898081811164', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1252, 'FAMILIA FLOCOS 2L', 0.00, 29.99, '7898081810143', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1253, 'SUPREMO BLACK 1,5L', 0.00, 34.99, '7898081811324', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1254, 'SUPREMO AVELA 1,5L', 0.00, 34.99, '7898081811331', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1255, 'SEPREMO COOKIE 1,5L', 0.00, 33.99, '7898081811317', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1256, 'SUPREMO CHOKOTINE 1,5L', 0.00, 34.99, '7898081811379', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1257, 'SUPREMO DOCE DE LEITE 1,5L', 0.00, 34.99, '7898081811362', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1258, 'SELETOS PAVE 1,5L', 0.00, 23.99, '7898081811232', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1259, 'SELETOS DUO CHOCOLATE E BAUNILHA 1,5L', 0.00, 23.99, '7898081811188', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1260, 'SELETOS CHOCOLATE BRANCO 1,5L', 0.00, 23.99, '7898081811294', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1261, 'SELETOS COCO BRANCO 1,5L', 0.00, 23.99, '7898081811287', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1262, 'SELETOS ABACAXI 1,5L', 0.00, 23.99, '7898081811263', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1263, 'SELETOS CHICLETE 1,5L', 0.00, 23.99, '7898081811171', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1264, 'SELETOS CROCANTE 1,5L', 0.00, 23.99, '7898081811157', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1265, 'SELETOS TENTAÃ§AO 1,5L', 0.00, 23.99, '7898081811140', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1266, 'FAMILIA CREME 2L', 0.00, 29.99, '7898081810136', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1267, 'FAMILIA NAPOLITANO 2L', 0.00, 29.99, '7898081810051', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1268, 'FAMILIA PASSAS AO RUM 2L', 0.00, 29.99, '7898081810105', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1269, 'FAMILIA CHOCOLATE 2L', 0.00, 29.99, '12687898081810068', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1270, 'TRIO TRES CHOCOLATES 2L', 0.00, 29.00, '7898081810358', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1271, 'TRIO TRES FRUTAS 2L', 0.00, 29.00, '7898081810389', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1272, 'AÃ§AI COM CHOCOLATE 1,5L', 0.00, 34.99, '7898081811072', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1273, 'AÃ§AI RURA ENERGIA 1,5L', 0.00, 34.99, '7898081811058', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1274, 'AÃ§AI COM MORANGO 1,5L', 0.00, 34.99, '7898081811065', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1275, 'AÃ§AI COM BANANA CARAMELIZADA 1,5L', 0.00, 34.99, '7898081811089', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1276, 'AÃ§AI +LEITINHO 1,5L', 0.00, 37.99, '7898081811096', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1277, 'DELICIE IOGUTE COM FRUTAS VERMELHAS 1,8L', 0.00, 29.99, '7898081810693', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1278, 'DELICIE MELANCIA 1,8L', 0.00, 29.99, '7898081811591', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1279, 'DELICIE JABUTICABA 1,8L', 0.00, 29.99, '7898081811621', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1280, 'DELICIE MORANGO 1,8 L', 0.00, 29.99, '7898081810808', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1281, 'DELICIE LEITE TRUFADO', 0.00, 29.99, '7898081810686', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1282, 'DELICIE SORVERTE DE ALGODÃ£O DOCE E CHICLET', 0.00, 29.99, '12817898081810853', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1283, 'DELICIE MOUSSE DE MARACUJÃ¡ 1,8L', 0.00, 29.99, '7898081810662', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1284, 'SORVETE FAMILIA 2L', 0.00, 29.99, '7898081810044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1285, 'BATATA CRONY 115G', 0.00, 11.00, '7896245710261', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1286, 'RAYAOAC 4 PILHAS', 0.00, 10.00, '7896009718113', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1287, 'MONSTER ULTRA PEACHY KEEN', 0.00, 10.00, '7898938890090', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1288, 'TRENTO SPECIALE PISTACHE C/ AVEIA', 0.00, 5.00, '7896306625671', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1289, 'AGUA DE COCO VITCOCO 200ML', 0.00, 3.50, '7898648021821', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1290, 'DEL VALLE GOIABA 1 L', 0.00, 11.00, '7894900660555', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1291, 'CAFÃ© EXPORT PRIMIU', 0.00, 30.00, '7896362900057', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1292, 'DIP LOKO MENTA GELO', 0.00, 3.00, '7898967923875', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1293, 'DEL VALLE ABACAXI 1L', 0.00, 11.00, '7894900660364', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1294, 'BARBEADOR BIC AQQUA 3', 0.00, 10.00, '070330729872', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1295, 'BARBEADOR  BIC COMFORT 3', 0.00, 8.50, '070330727984', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1296, 'AÃ§ÃºCAR CRIATAL SAFIRA 2K', 0.00, 12.00, '7898994576921', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1297, 'NEUGEBAUER MEIO AMARGO 40% CACAU 9G', 0.00, 2.00, '7891330019212', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1298, 'DOCILE CANUDINHO SABOR MORANGO UNI 15G', 0.00, 1.50, '7896451913586', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1299, 'DOCE DE BANANA 25G 0% AÃ§UCAR', 0.00, 2.50, '7898619510095', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1300, 'DOCE DE BANANA 30G TRADICIONAL', 0.00, 2.50, '7898619510088', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1301, 'CHEETOS SUPER CHEDDAR 48G', 0.00, 3.99, '7892840824105', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1302, 'RUFFLES   PIMENTA MEXICANA 65G', 0.00, 9.00, '7892840824204', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1303, 'PILHAS RAYOVAC (FINAS )', 0.00, 9.50, '7896009765421', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1304, 'CANUDINHO AZEDINHO SABOR MORANGO 15G', 0.00, 1.50, '7896451912527', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1305, 'CANUDINHO AZEDINHO MORANGO 15G', 0.00, 1.50, '7896451912503', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1306, 'DEL VALLE ABACAXI 1 L', 0.00, 11.00, '7894900660357', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1307, 'DEL VALLE SABOR LARANJA', 0.00, 11.00, '7898341430111', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1308, 'NISSIN LAMEN CALABRESA PICANTE 80G', 0.00, 3.00, '7891079014288', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1309, 'FANTA SABOR CHUCKY PUNCH', 0.00, 4.00, '7894900095197', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1310, 'VELA ESTRELA', 0.00, 10.00, '7899044200087', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1311, 'SABAO GLICERINADO YPE 160 G', 0.00, 4.00, '7896098905913', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1312, 'AGUA LA PRIOR 5 LITROS', 0.00, 10.00, '7898121460123', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1313, 'MICOS PIZZA', 0.00, 2.50, '7896245709357', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1314, 'MENTOS SABOR FRUTAS VERMELHAS', 0.00, 3.50, '7895144603063', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1315, 'CHOCOLATE LACTA AMARO', 0.00, 12.00, '7622210674432', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1316, 'MINUETO SABOR LIMAO', 0.00, 2.50, '7896004010069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1317, 'TANG LARANJA DOCINHA 18G', 0.00, 2.00, '7622210571571', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1318, 'TANG AZUL ESPACIAL 18G', 0.00, 2.00, '7622202347535', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1319, 'MINI MINTY  LARANJA 14G', 0.00, 3.00, '78917286', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1320, 'MINI MINTY HORTELA 14G', 0.00, 3.00, '78916982', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1321, 'ABS DIANA 16 UNI', 0.00, 7.50, '7896914002116', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1322, 'ABS DIANA NOTURNO', 0.00, 6.50, '7896301801957', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1323, 'SYM', 0.00, 5.00, '7896110002248', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1324, 'FLOCAO DE MILHO RAINHA 500G', 0.00, 2.99, '7898907825085', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1325, 'MONSTER JUICE', 0.00, 12.00, '7898938890120', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1326, 'OLEO DE SOJA COMIGO', 0.00, 9.50, '7898917173381', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1327, 'PICOLE BOMBOM GAROTO 82,5G', 0.00, 15.00, '7798304841650', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1328, 'PICOLE OREO MINI BITES 72G', 0.00, 21.00, '5900130042220', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1329, 'PICOLE KIT KET GOLD 45G', 0.00, 8.90, '7899975801896', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1330, 'PICOLE LA FRUTA COCO 66G', 0.00, 7.50, '7899975802695', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1331, 'PICOLE PRESTIGIO 60G', 0.00, 15.90, '7891000105788', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1332, 'PICOLE KIT KET 61G', 0.00, 18.90, '7899975801964', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1333, 'PICOLE OREO SANDWICH 81G', 0.00, 21.00, '7899975802886', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1334, 'PICOLE COM PEDAÃ§OS DE BISCOITO OREO 65G', 0.00, 17.50, '7899975802893', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1335, 'PICOLE LAKA OREO 68G', 0.00, 18.90, '7899975802145', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1336, 'PICOLE SKIMO GAROTO 48G', 0.00, 7.50, '7899975803197', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1337, 'PICOLE BOMBOM GAROTO 68G', 0.00, 9.90, '7899975802671', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1338, 'PICOLE CROCANTE GAROTO 68G', 0.00, 15.90, '7899975802084', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1339, 'PICOLE FINI DENTADURAS 50G', 0.00, 7.90, '7899975802749', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1340, 'PICOLE BATON GAROTO 45G', 0.00, 5.90, '7899975800042', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1341, 'PICOLE FINE TUBES MORANGO AZEDINHO 45G', 0.00, 5.90, '7899975801704', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1342, 'PICOLE CHAMBINHO NESTLE 45G', 0.00, 7.90, '7891000702505', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1343, 'MARGARINA CLAYBOM CREMOSA COM SAL 500G', 0.00, 8.50, '7891515901059', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1344, 'DUCREM NAPOLITANO 10G', 0.00, 1.00, '78954731', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1345, 'JAZAN COLORETI 18G', 0.00, 1.50, '7896383000422', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1346, 'MINUANO MARINE COM BICARBONATO 500ML', 0.00, 3.99, '7897664130319', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1347, 'VELA REVELACAO', 0.00, 15.00, '7891175442367', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1348, 'VELA +1', 0.00, 12.00, '7891175359344', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1349, 'DETERGENTE MINUANO 500G', 0.00, 4.00, '7897664130029', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1350, 'MINUANO DETERGENTE', 0.00, 4.00, '7908324401783', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1351, 'COOKIES CHARGE COM PEDAÃ§OS DE AMENDOIM 60G', 0.00, 4.00, '7891000420867', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1352, 'FUEL ENERGY DRINK  MELANCIA 2L', 0.00, 12.00, '074468811492', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1353, 'FUEL ENERGY TROPICAL 2L', 0.00, 12.00, '074468811508', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1354, 'FUEL ENERGY DRINK MAÃ§A VERDE 2L', 0.00, 12.00, '074468811515', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1355, 'KIT KAT 41,5 G', 0.00, 4.50, '7891000436837', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1356, 'SELETOS DUO MORANGO E LEITE CONDENSADO', 0.00, 22.00, '7898081811195', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1357, 'CHEETOS CRUNCHY PIMENTA MEXICANA', 0.00, 5.00, '7892840824228', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1358, 'RUFFLES DE SAL TUBO', 0.00, 10.00, '7892840822040', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1359, 'BACONZITOS', 0.00, 4.00, '7892840823450', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1360, 'TEKBOND 20G', 0.00, 11.99, '2000001001264', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1361, 'DELICIE UNICORNIO', 0.00, 29.99, '7898081810853', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1362, 'TALENTO CASTANHA  DE CAJU 85G  .OFERTA DO DIA', 0.00, 5.00, '7891008122213', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1363, 'PARTILHA GAROTA EXTRA FORTE', 0.00, 1.50, '7891008116823', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1364, 'PARTILHA GAROTA MENTA', 0.00, 1.50, '7891008116779', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1365, 'LEITE FERMETADO', 0.00, 2.99, '7898644341565', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1366, 'GOIANINHO MORANGO COM FLOCOS 130G', 0.00, 4.99, '7898644341725', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1367, 'WHEY  DE  MORANGO 250G', 0.00, 7.99, '7898644341855', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1368, 'DEL VALLE UVA 450ML', 0.00, 5.50, '7894900550054', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1369, 'DEL VALLE MELANCIA 200ML', 0.00, 4.00, '7894900650365', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1370, 'NISSIN LAMEN COSTELA 80G', 0.00, 3.00, '7891079012963', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1371, 'FOSFORO 10 UN', 0.00, 10.00, '7898905100023', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1372, 'KUAT 2L', 0.00, 9.00, '7894900911510', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1373, 'MOLHO DE TOMATE QUERO 240G', 0.00, 3.00, '7896102503661', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1374, 'ESPEGUETE LIANE 400G', 0.00, 4.00, '7896080843018', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1375, 'TUBINHO PINTA LINGUA 15G', 0.00, 1.50, '7891151043830', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1376, 'TUBINHO  SABOR MORANGO 15G', 0.00, 1.50, '7891151043779', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1377, 'TUBINHO FRUTAS SILVESTRE 15G', 0.00, 1.50, '7891151043854', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1378, 'TUBINHO SABOR MORANGO 15G', 0.00, 1.50, '7891151043816', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1379, 'AZEITONA VERDE SEM CAROÃ§O  GUNE 200G', 0.00, 5.00, '040141417671', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1380, 'SPRIT 200ML', 0.00, 3.00, '78939745', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1381, 'MIKAO SABOR DE QUEIJO', 0.00, 5.00, '7896245707117', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1382, 'DUNHILL NOVO', 0.00, 15.00, '78947467', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1383, 'OLEO BRASILEIRO', 0.00, 9.50, '7898917173398', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1384, 'TALETO AMENDOA PASSAS', 0.00, 10.00, '7891008121827', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1385, 'PICOLE GAROTO CARIBE', 0.00, 9.90, '7899975803098', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1386, 'SAL ALMIRANTE 1KG', 0.00, 3.00, '7896110194363', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1387, 'ROTHMANS BLUE', 0.00, 10.00, '78944480', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1388, 'PE DE MOLEQUE 14G', 0.00, 2.50, '7898691642578', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1389, 'BEIJO 50G', 0.00, 3.00, '7898537841189', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1390, 'DIPLOKO MELANCIA', 0.00, 3.00, '7898934595487', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1391, 'DIPLOKO PINTA LINGUA', 0.00, 3.00, '7898970162681', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1392, 'MENTOS FANTA LARANJA', 0.00, 3.50, '7895144208442', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1393, 'MENTOS WILD', 0.00, 3.50, '7895144900025', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1394, 'NESCAU 180ML', 0.00, 4.00, '7891000359822', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1395, 'NESCAFE 270ML', 0.00, 8.50, '7891000110829', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1396, 'LA FRUTTA MANGA', 0.00, 5.90, '7899975802909', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1397, 'LA FRUTTA MORANGO AO LEITE', 0.00, 7.50, '7899975802657', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1398, 'SPRITE LEMON FRESH 600ML', 0.00, 6.00, '7894900680553', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1399, 'DEL VALLE FRUTAS CITRICAS  1,5L', 0.00, 12.50, '7894900666526', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1400, 'PICOLE TUBES MORANGO', 0.00, 5.90, '13407899975801704', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1401, 'MANTEIGA COM SAL MINASLAC 200G', 0.00, 12.50, '7898911520402', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1402, 'DIAMANTE NEGRO 28G', 0.00, 4.00, '7622202256691', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1403, 'LACTA 28G', 0.00, 4.00, '7622202258459', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1404, 'OREO 20,1G', 0.00, 1.50, '78948150', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1405, 'DIAMANTE  NEGRO 20G', 0.00, 3.50, '7622300862282', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1406, 'MINI OREO 35G', 0.00, 3.75, '7622210933454', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1407, 'LEITE CONDENSADO ITALAC 395G', 0.00, 7.00, '7898080640413', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1408, 'TABACO SELVA', 0.00, 12.00, '609963288656', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1409, 'IOGURTE AMEIXA 850G', 0.00, 9.99, '7898644341497', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1410, 'GOIANINHO AMEIXA 850G', 0.00, 7.49, '7898644341251', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1411, 'EXTRATO ELEFANTE 300G', 0.00, 9.00, '7896036000717', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1412, 'PAPEL HIGIENICO FLORAL DUPLA FOLHA 12 ROLOS', 0.00, 13.50, '7891172523649', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(1413, 'PANETONE P', 0.00, 4.99, '2033400004994', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2001, 'COCA RET. 2L', 6.00, 7.50, '7894900027082', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2002, 'MARG. DELICIA 500G', 0.00, 10.00, '7894904271528', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2003, 'FARINHA LACTEA 360G', 0.00, 16.00, '7891000358764', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2004, 'LEITE NINHO 380G', 0.00, 26.00, '7891000284933', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2005, 'COCA COLA 2L', 0.00, 12.00, '7894900027013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2006, 'FANTA LARANJA 2L', 0.00, 9.00, '7894900031515', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2007, 'SPRITE 2L', 0.00, 9.00, '7894900681000', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2008, 'FEIJOADA 310G', 0.00, 12.00, '7896037518228', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2009, 'COCA COLA 600ML', 0.00, 6.00, '7894900011609', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2010, 'FEIJAO-CARIOCA BONARE 300G', 0.00, 5.50, '7898905153340', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2011, 'FANTA LARANJA 500ML', 0.00, 5.50, '7894900033564', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2012, 'KETCHUP CIABON 370G', 0.00, 6.00, '7898929666185', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2013, 'H2 OH 500ML', 0.00, 6.00, '7892840812423', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2014, 'MOLHO DE PIMENTA NEVES 150ML', 0.00, 4.00, '7897521203408', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2015, 'FANTA LARANJA 250ML', 0.00, 3.50, '78912922', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2016, 'COCA COLA 250ML', 0.00, 3.50, '78909045', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2017, 'MOLHO DE TOMATE TRAD. 300G', 0.00, 4.00, '7896102501872', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2018, 'FANTA LARANJA 310ML', 0.00, 4.00, '7894900031157', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2019, 'MOLHO DE ALHO C/ ERVAS 170ML', 0.00, 6.00, '7898560854637', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2020, 'LEITE COND. MOCOCA 395G', 0.00, 7.50, '7891030002033', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2021, 'MISTURA LAC. COND. 395G', 0.00, 7.00, '7891030300207', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2022, 'FANTA UVA 310ML', 0.00, 4.00, '7894900051155', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2023, 'FANTA UVA 2L', 0.00, 9.00, '7894900051513', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2024, 'COCA COLA 310ML', 0.00, 4.00, '7894900011159', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2025, 'ESPAGUETE REIMASSAS400G', 0.00, 5.50, '7896533700721', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2026, 'DEL VALLE GOIABA 290ML', 0.00, 4.50, '7894900660265', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2027, 'PERAFUSO REIMASSAS', 0.00, 5.50, '7896533700738', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2028, 'DEL VALLE UVA 290ML', 0.00, 5.50, '7894900660333', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2029, 'CREME DE LITE PIRACANJUBA 200G', 0.00, 4.50, '7898215151784', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2030, 'DEL VALLE MANGA 290ML', 0.00, 5.50, '7894900660401', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2031, 'COCA COLA 220ML', 0.00, 3.50, '7894900010398', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2032, 'EXTRATO ODERICH', 0.00, 5.00, '7896041174076', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2033, 'MAIONESE QUERO 200G', 0.00, 4.50, '7896292360433', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2034, 'LEITE 1L HABITUS', 0.00, 6.50, '7896590806305', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2035, 'OLEO SOYA 900ML', 0.00, 9.50, '7891107101621', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2036, 'SAL SOUTO 1KG', 0.00, 2.50, '7896713600315', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2037, 'SARDINHA C/ OLEO 88', 0.00, 7.50, '7891167023017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2038, 'SARDINHA TOMATE ROB. CRUS.', 0.00, 7.00, '7898943163028', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2039, 'PITCHULA COLA 250ML', 0.00, 3.00, '7896520011717', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2040, 'PITCHULA LIMAO 250ML', 0.00, 3.00, '7896520021693', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2041, 'TANG LIMAO', 0.00, 2.00, '7622210571540', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2042, 'TANG LARANJA/MAMAO', 0.00, 2.00, '7622210571847', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2043, 'TANG GOIABA', 0.00, 2.00, '7622210571496', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2044, 'PITCHULA LARANJA 250ML', 0.00, 3.00, '7896520021198', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2045, 'TANG MANGA', 0.00, 2.00, '7622210571526', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2046, 'PITCHULA UVA 250ML', 0.00, 3.00, '7896520029101', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2047, 'TANG ABACAXI', 0.00, 2.00, '7622210571755', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2048, 'TANG GUARANA', 0.00, 2.00, '7622210571816', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2049, 'TANG TANGERINA', 0.00, 2.00, '7622210571632', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2050, 'TANG MORANGO', 0.00, 2.00, '7622210571724', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2051, 'FLOCAO BONOMILHO 500G', 0.00, 2.40, '7896333200117', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2052, 'FLOCAO SINHA 500G', 0.00, 2.99, '7892300000933', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2053, 'GOIABADA VAL 300G', 0.00, 4.50, '7898045700336', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2054, 'GUARANA MINEIRO 350ML', 0.00, 4.50, '7897184000079', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2055, 'TODDYNHO 200ML', 0.00, 3.99, '7894321722016', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2056, 'CAFE DO SITIO 500G', 0.00, 38.00, '7896759900059', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2057, 'PITCHULA GUARANA 250ML', 0.00, 3.00, '7896520021181', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2058, 'CAFE EXPORT 500G', 0.00, 30.00, '7896362900026', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2059, 'FEIJAO DA MAMAE 1KG', 0.00, 8.50, '7896916200145', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2060, 'PARACATU 200G', 0.00, 15.00, '7896583400077', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2061, 'FUBA MIMOSO SINHA 1KG', 0.00, 6.00, '7892300001480', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2062, 'QUALY 500G', 0.00, 10.50, '7893000394209', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2063, 'ACUCAR PEROLA 2KG', 0.00, 12.00, '7898218770029', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2064, 'NISSIN CARNE', 0.00, 3.00, '7891079000205', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2065, 'MARG. DELICIA 250G', 0.00, 6.00, '7894904271535', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2066, 'NISSI CALABRESA PIM. MALAG.', 0.00, 2.80, '7891079011485', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2067, 'NISSIN GALINHA CAIP.', 0.00, 3.00, '7891079000229', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2068, 'ARROZ CAMIL 5KG', 0.00, 42.00, '7896006762027', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2069, 'CAFE EXPORT 250G', 0.00, 20.00, '7896362900019', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2070, 'ESPONJA ASSOLAN', 0.00, 1.50, '7896090105007', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2071, 'SABAO MINUANO 180G', 0.00, 4.00, '7908324402841', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2072, 'CLOSEUP HORTELA 70G', 0.00, 3.50, '7891150049888-2072', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2073, 'COLGATE HORTELA 90G', 0.00, 6.00, '7891024132128', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2074, 'ALBANY PER. NAT. 85G', 0.00, 2.50, '7908324403992', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2075, 'MARATINHO UVA 200ML', 0.00, 3.00, '7898378180928', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2076, 'FRANCIS SED. 85G', 0.00, 2.40, '7891176117349', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2077, 'SABAO YPE NEUTRO 900G', 0.00, 16.00, '7896098906316', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2078, 'MARATINHO MORANGO 200ML', 0.00, 3.00, '7898378180935', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2079, 'AGUA SANIT. KI-JOIA 1L', 0.00, 2.70, '7896061505225', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2080, 'MARATINHO LARANJA 200ML', 0.00, 3.00, '7898378180942', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2081, 'DEL VALLE  KAPO UVA 200ML', 0.00, 4.00, '7894900593709', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2082, 'LAVA-LOUCA KI-JOIA NEU. 500ML', 0.00, 2.00, '7896061503320', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2083, 'PIRAKIDS 1L', 0.00, 10.00, '7898215151814', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2084, 'LAVA-LOUCA KI-JOIA CLEAR 500ML', 0.00, 2.00, '7896061503368', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2085, 'MINUANO LAVA ROUPAS MAX. PERF. 800G', 0.00, 12.00, '7908324403312', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2086, 'BABYSEC ULTRASEC P 20UN', 0.00, 19.00, '7896061990069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2087, 'NUTRI NECTAR CAJU 200ML', 0.00, 2.50, '7898920195325', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2088, 'OLEO VILA VELHA 900ML', 0.00, 9.50, '7896223709423', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2089, 'NUTRI NECTAR GOIABA 200ML', 0.00, 2.50, '7898920195363', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2090, 'NUTRI NECTAR MARACUJA 200ML', 0.00, 2.50, '7898920195226', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2091, 'MICOS GALINHA 30G', 0.00, 1.50, '7896245700941', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2092, 'CRONY CHURRASCO 40G', 0.00, 3.50, '7896245709913', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2093, 'LA FRUIT MARACUJA 200ML', 0.00, 3.00, '7896520023062', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2094, 'SELECAO COST. LIMAO 50G', 0.00, 2.50, '7896805372724', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2095, 'BACONZITOS 86G', 0.00, 10.00, '7892840822774', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2096, 'ANELITOS CEBOLA 41G', 0.00, 2.70, '7896245709418', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2097, 'LA FRUIT LARANJA 200ML', 0.00, 3.00, '7896520023031', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2098, 'CRONY LIMAO 90G', 0.00, 7.00, '7896245708930', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2099, 'MIKAO PRESUNTO 120G', 0.00, 5.00, '7896245707094', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2100, 'TIAL LARANJA 200ML', 0.00, 2.50, '7896005309988', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2101, 'PELISKAO PRESUNTO 140G', 0.00, 3.50, '7898903727123', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2102, 'LA FRUIT GOIABA 200ML', 0.00, 3.00, '7896520028609', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2103, 'PELITAS BACON 35G', 0.00, 2.50, '7898903727048', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2104, 'DUCOCO AGUA D. COCO 200ML', 0.00, 4.00, '7896016601972', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2105, 'CRONY ORIGINAL 35G', 0.00, 3.80, '7896245709784', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2106, 'LA FRUIT UVA 200ML', 0.00, 3.00, '7896520023079', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2107, 'SELECAO CHURRASCO 26G', 0.00, 1.50, '7896805313130', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2108, 'FANDANGOS 105G', 0.00, 10.00, '7892840822880', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2109, 'SELECAO CEBOLA SALSA 26G', 0.00, 1.50, '7896805312126', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2110, 'CEBOLITOS 110G', 0.00, 10.00, '7892840822804', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2111, 'SELECAO QUEIJO 26G', 0.00, 1.50, '7896805311112', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2112, 'SELECAO PRESUNTO 26G', 0.00, 1.50, '7896805314144', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2113, 'RUFFLES 115G', 0.00, 15.00, '7892840817978', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2114, 'MICOS REQUEIJAO 30G', 0.00, 1.50, '7896245704352', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2115, 'MICOS PRESUNTO 45G', 0.00, 2.50, '7896245709326', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2116, 'DORITOS 140G', 0.00, 15.00, '7892840814540', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2117, 'LACTA DIAM. NEG. 34G', 0.00, 3.50, '7622210573322', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2118, 'CHEETOS PARMESSAO  110G', 0.00, 10.00, '7892840820473', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2119, 'CHEETOS REQUEIJAO 122G', 0.00, 10.00, '7892840820480', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2120, 'BAUDC. BOLINHO CHOC. 40G', 0.00, 2.50, '7891962031170', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2121, 'TALENTO AMEND. 25G', 0.00, 3.00, '78907355', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2122, 'BATON DUOBRANCO 16G', 0.00, 2.00, '78930193', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2123, 'TALENTO CAST. PARA 25G', 0.00, 3.00, '78907478', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2124, 'TALENTO AVELA 25G', 0.00, 3.00, '78907461', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2125, 'PACOCA DE AMEND. 90G', 0.00, 2.50, '7898946780895', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2126, 'AMENDOIN CARAME. 70G', 0.00, 3.50, '736532575234', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2127, 'JUJUBA GOMA GURT 31G', 0.00, 1.50, '7897064811832', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2128, 'BATON AO LEITE', 0.00, 2.00, '78912359', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2129, 'BATON BRANCO', 0.00, 2.00, '78912366', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2130, 'BISC. BOM DE BOLA CHOC.', 0.00, 2.50, '7896011102412', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2131, 'BISC. BOM DE BOLA MORAN.', 0.00, 2.50, '7896011102436', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2132, 'OREO CHOC. 90G', 0.00, 4.59, '7622300873554', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2133, 'BAUD. COOKIES CHOC. 96G', 0.00, 5.49, '7891962054124', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2134, 'SENSACOES PEITO DE PERU 40G', 0.00, 6.00, '7892840820244', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2135, 'SENSACOES FRAN. GRELHADO 40G', 0.00, 6.00, '7892840820183', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2136, 'CHEETOS REQUEIJ. 45G', 0.00, 4.00, '7892840824044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2137, 'CHEETOS PARME. 40G', 0.00, 4.00, '7892840824051', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2138, 'CHEETOS MIX 41G', 0.00, 3.50, '7892840821180', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2139, 'LACTA DIAM. NEGRO 80G', 0.00, 12.00, '7622210674050', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2140, 'NESTLE CLASSIC 80G', 0.00, 8.00, '7891000368572', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34');
INSERT INTO `tb1_produto` (`tb1_id`, `tb1_nome`, `tb1_vlr_custo`, `tb1_vlr_venda`, `tb1_codbar`, `tb1_tipo`, `tb1_status`, `tb1_favorito`, `tb1_vr_credit`, `created_at`, `updated_at`) VALUES
(2141, 'FINI BANANAS 15G', 0.00, 2.00, '7898591450686', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2142, 'FINI DENTADURAS 15G', 0.00, 2.00, '7898591450600', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2143, 'CEBOLITOS 33G', 0.00, 4.00, '7892840822255', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2144, 'RUFFLES 40G', 0.00, 4.00, '7892840819729', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2145, 'FANDANGOS 37G', 0.00, 3.00, '7892840821166', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2146, 'DORITOS 53G', 0.00, 5.00, '7892840819576', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2147, 'AMASSYXUP CHOC.', 0.00, 1.50, '7896969400882', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2148, 'AMASSYXUP MORAN.', 0.00, 1.50, '7896969410201', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2149, 'DUCREM 5', 0.00, 1.50, '78917644', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2150, 'PRESTIGIO 33G', 0.00, 3.80, '7891000460207', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2151, 'FINI TUBES FRAMB. 15G', 0.00, 2.00, '7898591459771', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2152, 'ESCOVA CLEAR FRESH', 0.00, 3.50, '7898504929964', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2153, 'CHICLETE TERROR ZONE', 0.00, 0.50, '7896043352595', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2154, 'HALLS PRETO', 0.00, 2.50, '78938816', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2155, 'HALLS MENTA PRATA', 0.00, 2.50, '78938878', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2156, 'HALLS MORANGO', 0.00, 2.50, '78938847', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2157, 'HALLS MELANCIA', 0.00, 2.50, '78938854', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2158, 'HALLS VERDE', 0.00, 2.50, '78938861', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2159, 'HALLS AZUL', 0.00, 2.50, '78938823', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2160, 'HALLS CEREJA', 0.00, 2.50, '78938793', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2161, 'MENTOS RAINBOW', 0.00, 3.00, '7895144603148', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2162, 'TIC TAC LARANJA', 0.00, 3.00, '78945456', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2163, 'TIC TAC MENTA', 0.00, 3.00, '78945449', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2164, 'TRIDENTE MELANCIA 8G', 0.00, 3.00, '7895800309780', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2165, 'TRIDENTE CANELA 8G', 0.00, 3.00, '7895800304235', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2166, 'ROTHMANS', 0.00, 8.00, '78919501', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2167, 'GIFT', 0.00, 6.00, '78935655', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2168, 'DUNHILL', 0.00, 15.00, '78941076', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2169, 'SUTRA MORAN. 3UN', 0.00, 6.00, '7898079005247', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2170, 'INTUMUS ABSOR. INTERNO', 0.00, 8.00, '7896007541867', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2171, 'INTIMUS ABSORVENTE  COM ABAS', 0.00, 5.50, '7896007540617', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2172, 'SYM ABSORVENTE', 0.00, 8.00, '7896110003740', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2173, 'INTIMUS NOTURNO COM ABAS', 0.00, 9.50, '7896007540662', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2174, 'DIANA ABSORVENTE', 0.00, 5.00, '7896914000266', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2175, 'VELAS PEDRAVIVA 8UNI NUM. 5', 0.00, 10.00, '7898925508014', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2176, 'VELAS PEDRAVIVA 8UNI NUM. 7', 0.00, 15.00, '7898925508151', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2177, 'VELAS PEDRAVIVA 6UNI NUM.8', 0.00, 15.00, '7898925508090', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2178, 'SUPER COLA 3G', 0.00, 3.50, '7894561238520', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2179, 'PRUDENCE HORTELA', 0.00, 8.00, '7898079000310', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2180, 'PRUDENCE MORANGO', 0.00, 8.00, '7898079000303', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2181, 'PRUDENCE CLASSICO', 0.00, 8.00, '7898079003021', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2182, 'PRUDENCE UVA', 0.00, 8.00, '7898079000327', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2183, 'GILLETE', 0.00, 4.00, '7500435154420', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2184, 'VELA DE ANIVER. ESTRELA', 0.00, 10.00, '7899044200056', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2185, 'VELA ANIVER CHAMA ESTELAR', 0.00, 10.00, '7899044200049', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2186, 'NUCITA OU DUCREM', 0.00, 1.00, '7896969400370', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2187, 'FOSFORO GABOARDI', 0.00, 1.00, '7896279200103', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2188, 'DOCE DE LEITE REAL GRANDE', 0.00, 1.50, '7898204520010', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2189, 'QUEIJADINHA', 0.00, 2.00, '7899543890086', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2190, 'PACOCA ROLO 51G', 0.00, 2.00, '7898691641946', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2191, 'VELA 1 BRANCA', 0.00, 5.00, '7899044200889', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2192, 'VELA 2 BRANCA', 0.00, 5.00, '7899044200896', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2193, 'VELA 5 ROSA', 0.00, 5.00, '7899044201121', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2194, 'VELA 3 BRANCA', 0.00, 5.00, '7899044200902', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2195, 'VELA 4 BRANCA', 0.00, 5.00, '7899044200919', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2196, 'VELA 5 BRANCA', 0.00, 5.00, '7899044200926', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2197, 'VELA 6 BRANCA', 0.00, 5.00, '7899044200933', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2198, 'VELA 1 ROSA', 0.00, 5.00, '7899776000818', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2199, 'VELA 7 BRANCA', 0.00, 5.00, '7899044200940', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2200, 'VELA 2 ROSA', 0.00, 5.00, '7899044201091', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2201, 'VELA 8 BRANCA', 0.00, 5.00, '7899044200957', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2202, 'VELA 9 BRANCA', 0.00, 5.00, '7899044200964', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2203, 'VELA 3 ROSA', 0.00, 5.00, '7899044201107', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2204, 'VELA 0 BRANCA', 0.00, 5.00, '7899044200872', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2205, 'VELA 4 ROSA', 0.00, 5.00, '7899044201114', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2206, 'VELA 7 BRANCA', 0.00, 5.00, '7898446284145', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2207, 'VELA 6 ROSA', 0.00, 5.00, '7899044201138', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2208, 'VELA 7 ROSA', 0.00, 5.00, '7899044201145', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2209, 'VELA 8 ROSA', 0.00, 5.00, '7899044201152', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2210, 'VELA 9 ROSA', 0.00, 5.00, '7899044201169', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2211, 'VELA 0 ROSA', 0.00, 5.00, '7899044201077', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2212, 'OURO BRANCO', 0.00, 1.50, '78939318', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2213, 'PAÃ§OCA MORENINHA DO RIO', 0.00, 1.00, '7897047000628', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2214, 'AGUA PURA&LEVE 500ML', 0.00, 2.00, '7898306940228', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2215, 'VELA 0 AZUL', 0.00, 5.00, '7898726140253', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2216, 'VELA 1 AZUL', 0.00, 5.00, '7899044200988', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2217, 'VELA 7 AZUL', 0.00, 5.00, '7899044201046', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2218, 'VELA 2 AZUL', 0.00, 5.00, '7899044200995', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2219, 'VELA 3 AZUL', 0.00, 5.00, '7899044201008', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2220, 'VELA 9 AZUL', 0.00, 5.00, '7899044201060', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2221, 'VELA 5 AZUL', 0.00, 5.00, '7899044201022', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2222, 'VELA 6 AZUL', 0.00, 5.00, '7899044201039', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2223, 'VELA 8 AZUL', 0.00, 5.00, '7899044201053', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2224, 'VELA 9 AZUL', 0.00, 5.00, '7898446284169', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2225, 'GUARANA AMAZONAS', 0.00, 7.50, '7898962842041', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2226, 'GUARAMIX COPO 290ML', 0.00, 3.00, '7898216250059', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2227, 'PITCHULAO 2L', 0.00, 8.00, '7896520028883', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2228, 'TAMPICO 2L', 0.00, 13.00, '095188878572', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2229, 'FLOCOS DE MILHO DOCE', 0.00, 5.50, '192505301956', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2230, 'ISQUEIRO BIC PEQUENO', 0.00, 5.00, '070330631335', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2231, 'TAMPICO 270ML', 0.00, 3.50, '095188878510', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2232, 'ISQUEIRO BIC', 0.00, 7.00, '070330631335-2232', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2233, 'PILHA AAA2 DURACEL', 0.00, 10.00, '041333001074', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2234, 'TAMPICO 450ML', 0.00, 5.50, '095188874505', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2235, 'DORITOS PIZZA 48G', 0.00, 5.00, '7892840820053', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2236, 'GOIANINHO MORANGO 850G', 0.00, 7.49, '7898644341138', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2237, 'GOIANINHO FRUTAS 1250L', 0.00, 12.99, '7898644341466', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2238, 'GOIANINHO FRUTAS 140G', 0.00, 2.99, '7898644341435', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2239, 'GOIANINHO PAST. COR 130G', 0.00, 4.99, '7898644341886', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2240, 'LA FRUIT MARACUJA 1L', 0.00, 9.50, '7896520021334', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2241, 'LA FRUIT PESSEGO 1L', 0.00, 9.50, '7896520021372', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2242, 'DUCOCO 1L', 0.00, 14.00, '7896016608766', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2243, 'LA FRUIT MANGA 1L', 0.00, 9.50, '7896520021327', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2244, 'LA FRUIT CAJU 1L', 0.00, 9.50, '7896520023093', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2245, 'LA FRUIT GOIABA', 0.00, 9.50, '7896520028623', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2246, 'AMAZONAS COLA', 0.00, 7.50, '7898268440170', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2247, 'LA FRUIT UVA 1L', 0.00, 9.50, '7896520021389', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2248, 'MARI COCO 1L', 0.00, 10.00, '7898961490250', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2249, 'AGUA MINERAL 1,5L', 0.00, 5.00, '7898121460154', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2250, 'GOIANINHO PESSEGO 110G', 0.00, 1.50, '7898644341039', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2251, 'GOIANINHO MORANGO 110G', 0.00, 1.75, '7898644341015', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2252, 'GOIANINHO MARACUJA 110G', 0.00, 1.50, '7898644341046', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2253, 'GUARAMIX BICO 500ML', 0.00, 6.00, '7898216250042', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2254, 'GUARAMIX BOCAO 500ML', 0.00, 6.00, '7898216252107', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2255, 'GOIANINHO COCO 110G', 0.00, 1.75, '7898644341022', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2256, 'SONHO DE VALSA', 0.00, 1.50, '78939301', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2257, 'DORITOS 75G', 0.00, 10.00, '7892840822347', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2258, 'RUFFLES 68G', 0.00, 9.00, '7892840823054', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2259, 'LAYS SAL E VINAGRE 70G', 0.00, 10.00, '7892840823382', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2260, 'LAYS SOUR CREAM', 0.00, 10.00, '7892840816780', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2261, 'RUFFLES HOT DOG 35G', 0.00, 4.50, '7892840821074', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2262, 'LAYS RUSTICA 38G', 0.00, 6.00, '7892840820626', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2263, 'ISQUEIRO GRANDE', 0.00, 7.00, '70330909229', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2264, 'JUJUBA', 0.00, 1.50, '7897064811399', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2265, 'SOTRIX ABACAXI', 0.00, 1.50, '7898902259564', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2266, 'SUCO SOTRIX UVA', 0.00, 1.50, '7898902259540', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2267, 'SUCO SOTRIX LIMAO', 0.00, 1.50, '7898902259557', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2268, 'MILHO AO VAPOR', 0.00, 4.00, '7897517208868', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2269, 'TODDY 200G', 0.00, 9.70, '7894321711171', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2270, 'NESCAU 350G', 0.00, 13.50, '7891000426210', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2271, 'MICOS PIZZA 28G', 0.00, 1.50, '7896245700965', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2272, 'PELISKÃ£O QUEIJO 140G', 0.00, 3.50, '7898903727130', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2273, 'MIKÃ£O GALINHA CAIPIRA 120G', 0.00, 5.00, '7896245707100', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2274, 'LAKA BRANCO 34G', 0.00, 3.50, '7622210573353', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2275, 'MOCOQUINHA CHOCOLATE 200ML', 0.00, 2.50, '7891030003016', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2276, 'PIRAKIDS 200ML', 0.00, 2.50, '7898215151807', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2277, 'GOIANINHO MORANGO 140G', 0.00, 2.99, '7898644341350', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2278, 'GOIANINHO ZERO 140G', 0.00, 2.99, '7898644341985', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2279, 'NUTRI NECTAR MANGA 200ML', 0.00, 2.50, '7898920195219', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2280, 'DOCE DE LEITE NINHO', 0.00, 1.50, '7896595581696', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2281, 'ISQUEIRO GRANDE', 0.00, 7.00, '70330909229-2281', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2282, 'OVO FRITO', 0.00, 2.00, '2003000002003', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2283, 'OVO FRITO', 0.00, 2.00, '2003000002003-2283', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2284, 'BALINHA', 0.00, 0.15, '228400', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2285, 'CHICLETE', 0.00, 0.25, '228500', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2286, 'PIRULITO C', 0.00, 1.00, '228600', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2287, 'PIRULITO B', 0.00, 0.50, '228700', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2288, 'CIGARRO C', 0.00, 1.50, '228800', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2289, 'CIGARRO B', 0.00, 0.50, '228900', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2290, 'DOCE', 0.00, 2.00, '229000', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2291, 'PELITAS BACON', 0.00, 3.50, '7898903727017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2292, 'PLINCKITOS', 0.00, 1.50, '7896769802459', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2293, 'PLINCKITOS', 0.00, 1.50, '7896769802435', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2294, 'PLINCKITOS', 0.00, 1.50, '7896769802473', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2295, 'PLINCKITOS', 0.00, 1.50, '7896769802428', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2296, 'PLINCKITOS', 0.00, 1.50, '7896769802466', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2297, 'PLINCKITOS', 0.00, 1.50, '7896769802442', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2298, 'TRIDENT MENTA', 0.00, 3.00, '7895800304228', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2299, 'COCA COLA 600ML SEM AÃ§UCAR', 0.00, 6.00, '7894900701609', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2300, 'LA FRUIT 200ML CAJU', 0.00, 3.00, '7896520023116', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2301, 'GOIANINHO 110G LEITE CONDENSADO', 0.00, 1.75, '7898644341077', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2302, 'GOIANINHO 110G ABACAXI', 0.00, 1.75, '7898644341060', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2303, 'TRIDENT TUTTI-FRUTTI', 0.00, 3.00, '7895800430002', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2304, 'AGUA SANITARIA GEO', 0.00, 6.00, '7896471800774', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2305, 'DESINFETANTE LAVANDA GEO', 0.00, 4.00, '7896471800651', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2306, 'MICOS REQUEIJAO 45G', 0.00, 2.50, '7896245709340', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2307, 'HABITUS MISTURA LACTEA', 0.00, 7.00, '7896590817110', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2308, 'COCADA', 0.00, 4.00, '0602883303140', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2309, 'QUALLY 250G', 0.00, 6.50, '7893000394117', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2310, 'TAMPICO DE UVA 200ML', 0.00, 3.00, '095188872860', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2311, 'SPRITE', 0.00, 4.00, '7894900681024', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2312, 'TAMPICO LARANJA 200 ML', 0.00, 3.00, '095188872006', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2313, 'FREEGELLS CEREJA', 0.00, 2.00, '7891151039734', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2314, 'DOMUS 900ML', 0.00, 17.00, '7896002111911', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2315, 'CANINHA SERTANEJA 500ML', 0.00, 5.00, '7897946400062', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2316, 'MIOJO LIANE CARNE', 0.00, 2.00, '7896080856216', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2317, 'MIOJO LIANE GALINHA', 0.00, 2.00, '7896080856209', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2318, 'APTI FERMENTO', 0.00, 5.50, '7896327512967', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2319, 'RANCHEIRO SABOR MORANGO 78G', 0.00, 3.50, '7896253401557', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2320, 'RANCHEIRO SABOR LIMAO 78G.', 0.00, 2.50, '7896253401540', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2321, 'ESPUMIL NEUTRO 500ML', 0.00, 2.00, '7898906717831', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2322, 'ZUPP MAÃ§A 500ML', 0.00, 2.00, '7896360400818', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2323, 'ZUPP CLEAR 500ML', 0.00, 2.00, '7896360400832', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2324, 'ZUPP COCO 500ML', 0.00, 2.00, '7896360400900', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2325, 'ECOÃ§UCAR', 0.00, 7.50, '7898185000044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2326, 'SHOW GOL CHOCOLATE 110G', 0.00, 2.50, '7896286618151', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2327, 'SHOW GOL MORANGO 110G', 0.00, 2.50, '7896286618144', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2328, 'FUBA BONOMILHO 1KG', 0.00, 6.00, '7896333200230', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2329, 'SACOS PLASTICOS HOT DOG', 0.00, 4.00, '7898220028996', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2330, 'PRATOS PLASTICOS DESCARTAVEIS', 0.00, 4.00, '7898505140450', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2331, 'SAL DUNAS GRILL 1 KG', 0.00, 4.00, '7897167100239', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2332, 'COPO PLAST 100UNI', 0.00, 7.90, '7898930340487', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2333, 'GUARDANAPOS SO PAPEIS  1000UNI', 0.00, 13.00, '736532288240', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2334, 'TIXAN YPE 800G', 0.00, 15.00, '7896098909744', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2335, 'SABAO EM BARRA NOBRE 1KG', 0.00, 14.00, '7898910753016', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2336, 'SOFT 500ML', 0.00, 7.50, '7897938904721', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2337, 'AMACIANTE 2L', 0.00, 12.00, '7896328500208', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2338, 'LEITE PIRACANJUBA 1L', 0.00, 7.00, '7898215151708', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2339, 'FLOCAO DE MILHO PALHEIRO 400G', 0.00, 2.00, '7899090155317', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2340, 'SOFT BEBE PLUS 500ML', 0.00, 7.50, '7897938903632', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2341, 'TALENTO AMENDOAS E PASSAS 25G', 0.00, 3.00, '78907492', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2342, 'DADINHO BLACK', 0.00, 1.00, '7898530842299', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2343, 'TRIDENT CEREJA ICE', 0.00, 3.50, '7622210564337', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2344, 'DOCE DE BANANA', 0.00, 1.00, '7896202820637', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2345, 'KARITOS CHURRASCO', 0.00, 4.00, '7898133400124', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2346, 'KARITOS CEBOLA E SALSA 40G', 0.00, 4.00, '7898133400148', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2347, 'FINI TUTTI-FRUTTI AZEDINHO', 0.00, 2.00, '7898591459474', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2348, 'FINI MORANGO E NATA AZEDINHO', 0.00, 1.50, '7898279799823', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2349, 'FINI MORANGO E NATA', 0.00, 2.00, '7898591459511', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2350, 'TORTUGUITA BAUNILHA', 0.00, 1.50, '7898142865044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2351, 'FREEGELLS MORANGO', 0.00, 2.00, '7891151039819', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2352, 'FREEGELLS CHOCOLATE', 0.00, 2.00, '7891151039598', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2353, 'FREEGELLS MENTA', 0.00, 2.00, '7891151039796', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2354, 'FREEGELLS MARACUJA', 0.00, 2.00, '7891151039574', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2355, 'PAÃ§OQUINHA', 0.00, 1.00, '7897115108799', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2356, 'GOMETS IOGURTE', 0.00, 1.50, '7896058506099', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2357, 'JURUPI PAPEL PARA CIGARROS 50FLHS', 0.00, 1.00, '7898006840149', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2358, 'LACTA SHOT 80G', 0.00, 10.00, '7622210674395', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2359, 'GAROTO NEGRESCO 80G', 0.00, 8.00, '7891008124477', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2360, 'TORTUGUITA BRANCO', 0.00, 1.50, '7898142865068', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2361, 'PLINC CHURRASCO 60G', 0.00, 3.00, '7896769801872', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2362, 'PLINC PRESUNTO 60G', 0.00, 3.00, '7896769801896', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2363, 'PLINC GALINHA 60G', 0.00, 3.00, '7896769801889', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2364, 'PLNC CEBOLA E SALSA 25G', 0.00, 1.50, '7896769801018', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2365, 'PLINC GALINHA 25G', 0.00, 1.50, '7896769801995', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2366, 'CREME D LEITE QUATA 200G', 0.00, 3.00, '7896183201159', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2367, 'COCA COLA ZERO AÃ§UCAR 310ML', 0.00, 4.00, '7894900701159', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2368, 'MICOS GALINHA 45G', 0.00, 2.50, '7896245709319', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2369, 'OLEO', 0.00, 9.50, '7898247780006', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2370, 'ACUCAR CRISTAL', 0.00, 22.00, '7898185000068', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2371, 'MISTURA LACTEA TRIANGULO 395G', 0.00, 6.00, '7896434920778', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2372, 'ESTAX ORIGINAL', 0.00, 15.00, '7892840225810', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2373, 'ESTAX ONION', 0.00, 15.00, '7892840225919', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2374, 'ESTAX QUEIJO CHEDAR', 0.00, 15.00, '7892840226015', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2375, 'LAKA AO LEITE', 0.00, 3.50, '7622210573384', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2376, 'TRIDENT', 0.00, 3.00, '7895800304211', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2377, 'GOIANINHO 0 LAC 850G', 0.00, 10.99, '7898644341534', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2378, 'BIS ORIGINAL 16 UNIDADES', 0.00, 8.00, '7622210575975', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2379, 'BIS ORIGINAL BRANCO', 0.00, 7.00, '7622210575999', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2380, 'LAKA OREO 80 G', 0.00, 10.00, '7622210674357', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2381, 'LAKA AO LEITE', 0.00, 12.00, '7622210674319', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2382, 'CAIXA LACTA BOM,BOM', 0.00, 15.00, '7622210596413', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2383, 'IOGURTE DE COCO 850G', 0.00, 8.49, '7898644341930', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2384, '5 STAR 40G', 0.00, 4.50, '7622210411501', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2385, 'GOIANINHO 1250G', 0.00, 12.99, '7898644341381', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2386, 'FRISCO MARACUJA', 0.00, 1.50, '7896045112135', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2387, 'PRESUNTO COZIDO', 0.00, 9.50, '7894904276677', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2388, 'GOIANINHO 510G', 0.00, 4.99, '7898644341817', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2389, 'STIKSY', 0.00, 3.50, '7892840818500', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2390, 'BAUDUCCO COOKIES', 0.00, 6.50, '7891962054100', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2391, 'AMAZONAS UVA', 0.00, 7.50, '7898962842065', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2392, 'AMAZONAS LIMÃ£O', 0.00, 7.50, '7898962842058', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2393, 'AMAZONAS LARANJA', 0.00, 7.50, '7898962842072', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2394, 'AZEITONA VERDE', 0.00, 5.00, '7898174850278', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2395, 'FANTA GUARANÃ', 0.00, 9.00, '7894900093056', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2396, 'CAFE EXTRA FORTE 500G', 0.00, 34.00, '7896362900040', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2397, 'CHOKITO 32G', 0.00, 3.50, '7891000462300', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2398, 'CHOKITO 32G', 0.00, 4.00, '7891000462300-2398', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2399, 'TANG DE UVA', 0.00, 2.00, '7622210571786', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2400, 'GOIANINHO 850G', 0.00, 9.99, '7898644341374', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2401, 'LA FRUIT LARANJA 1L', 0.00, 8.00, '7896520023017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2402, 'SOTRIX LARANJA 25G', 0.00, 1.50, '7898902259588', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2403, 'CUP NOODLES GALINHA CAIPIRA', 0.00, 6.00, '7891079013038', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2404, 'CUP NOODLES GALINHA CAIPIRA PICANTE', 0.00, 6.00, '7891079013069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2405, 'CUP NOODLES CARNE DEFUMADA', 0.00, 6.00, '7891079013052', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2406, 'CUP NOODLES COSTELA COM MOLHO DE CHURRASCO', 0.00, 6.00, '7891079013083', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2407, 'CUP NOODLES BOLONHESA', 0.00, 6.00, '7891079013120', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2408, 'MICOS PRESUNTO 30G', 0.00, 1.50, '7896245700972', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2409, 'GOIANINHO MORANGO 450G', 0.00, 6.99, '7898644341367', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2410, 'HUGGIES M', 0.00, 20.00, '7896007552412', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2411, 'HUGGIES G', 0.00, 20.00, '7896007552429', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2412, 'PREDILETA GALINHA CAIPIRA', 0.00, 2.00, '7896292339828', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2413, 'MACARRAO PARAFUSO', 0.00, 5.50, '7896080820293', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2414, 'MAIONESE VAL', 0.00, 8.50, '7898045702194', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2415, 'KETCHUP 200G', 0.00, 6.50, '7896102502763', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2416, 'BOLO DE SAL', 0.00, 15.00, '2012400015001', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2417, 'REQUEIJÃ£O CANTO DE MINAS 200G', 0.00, 8.99, '7896629630178', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2418, 'MASSA PARA PASTEL REDONDA 500G', 0.00, 8.50, '7896301300085', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2419, 'MASSA PARA PASTEL QUADRADA 500G', 0.00, 8.50, '7896301300108', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2420, 'MASSA PARA PASTEL REDONDA(GRANDE) 500G', 0.00, 8.50, '7896301300092', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2421, 'PAPEL HIGIENICO PLUS', 0.00, 5.00, '7896339810334', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2422, 'PAPEL HIGIENICO MIMMO FOLHA DUPLA', 0.00, 8.00, '7898962794142', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2423, 'OURO BRANCO 25G', 0.00, 4.00, '7622210570116', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2424, 'NUTRI NÃ©CTAR 1L ABACAXI', 0.00, 6.50, '7898920195813', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2425, 'MINUANO LAVA ROUPAS CONCENTRADO 400G', 0.00, 8.50, '7908324403305', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2426, 'PINGO DE OURO 30G', 0.00, 2.00, '7892840814663', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2427, 'FRESH MARACUJA', 0.00, 2.00, '7622210569851', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2428, 'LEITE ITALAC 1L', 0.00, 6.50, '7898080640611', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2429, 'BISCOITO PASSATEMPO CHOCOLATE', 0.00, 3.50, '7891000241356', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2430, 'MOLHO DE PIMENTA', 0.00, 4.50, '7898929666307', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2431, 'BISCOITO RECHEADO RACINE', 0.00, 2.50, '7898926844173', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2432, 'BISCOITO RECHEADO CHOCOLATE RACINE', 0.00, 2.50, '7898926844180', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2433, 'CHOCOBOM', 0.00, 2.50, '7898215155126', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2434, 'LEITE CONDENSADO PIRACANJUBA', 0.00, 8.50, '7898215152002', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2435, 'SABÃ£O EM PO MINUANO AZUL 400G', 0.00, 8.50, '7908324403251', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2436, 'DIPLOKO MORANGO  11G', 0.00, 3.00, '7898934595463', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2437, 'PAÃ§OCA CASEIRA 90G', 0.00, 3.00, '619205818893', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2438, 'BELAGURT MORANGO 140G', 0.00, 2.49, '7898644341893', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2439, 'GUARANÃ¡ KUAT', 0.00, 6.50, '7894900912357', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2440, 'OLEO DE SOJA LIZA', 0.00, 9.50, '7896036090244', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2441, 'CURAL DE MILHO', 0.00, 7.00, '2013300006007', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2442, 'COCA COCA 250ML', 0.00, 3.50, '78912939', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2443, 'GUARA FIT 500 ML', 0.00, 5.00, '7898956846147', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2444, 'GOIANINHO 850 G', 0.00, 9.99, '7898644341459', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2445, 'AGUA CRYSTAL COM GAS', 0.00, 3.00, '7894900531008', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2446, 'AGUA MINERAL PURA', 0.00, 2.00, '7898910905026', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2447, 'ALCOOL NOBRE 1L', 0.00, 10.00, '7898956358091', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2448, 'GOIANINHO GUARANÃ¡', 0.00, 7.50, '7896520011014', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2449, 'PRESTOBARBA FIAT LUX', 0.00, 3.50, '7896007990528', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2450, 'LEITE CONDENSADO QUATA', 0.00, 7.00, '7896183201135', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2451, 'BATATA PALHA KARI KARI 80G', 0.00, 7.50, '7898133401701', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2452, 'TALENTO CEREAIS E PASSAS 25G', 0.00, 3.00, '78907485', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2453, 'POP CORN NATURAL 100G', 0.00, 4.00, '7896602901011', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2454, 'POPCORN MANTEIGA SUAVE', 0.00, 4.00, '7896602901004', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2455, 'NESTLE AO LEITE 25G', 0.00, 2.50, '7891000312919', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2456, 'LOLLO 28G', 0.00, 3.50, '7891000092606', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2457, 'TORTUGUITA BRIGADEIRO', 0.00, 1.50, '7898142865082', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2458, 'TORTUGUITA AERADO', 0.00, 1.50, '7898142865037', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2459, 'MILHO PARA PIPOCA YOKI 400G', 0.00, 6.00, '7891095911356', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2460, 'COOKIES BAUDUCCO 60G', 0.00, 4.50, '7891962054810', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2461, 'DESINFETANTE PROEZA 2L', 0.00, 6.00, '7898113010664', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2462, 'BELARGURT MORANGO 850G', 0.00, 7.99, '7898644341909', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2463, 'FINI FRUTAS SILVESTRES E NATA AZED. 15G', 0.00, 1.50, '7898591457869', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2464, 'COADOR PARA CAFÃ©', 0.00, 5.00, '7891011121913', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2465, 'TANG LARANJA 18G', 0.00, 2.00, '7622210571601', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2466, 'GUARANÃ¡ JESUS 310ML', 0.00, 4.00, '7894900941159', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2467, 'Ã¡GUA MINERAL MARIZA 1,5L', 0.00, 5.00, '7898920195042', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2468, 'COCA COLA SEM AÃ‡UCAR 2L', 0.00, 12.00, '7894900701517', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2469, 'CRYSTAL GUARANÃ 2L', 0.00, 6.00, '7898941025021', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2470, 'CRYSTAL ABACAXI 2L', 0.00, 6.00, '7898941025045', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2471, 'LEITE CEMIL 1L', 0.00, 6.00, '7896590801232', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2472, 'PAPEL HIGIENICO BEST FOLHA DUPLA 12 ROLOS', 0.00, 12.00, '7896053470173', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2473, 'PAPEL HIGIENICO OLÃ© 12 ROLOS', 0.00, 12.00, '7896339812031', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2474, 'CORTADOR DE UNHA', 0.00, 5.00, '7898684170071', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2475, 'GOIANINHO DE MORANGO ZERO  LACTOSE 850G', 0.00, 9.80, '7898644342081', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2476, 'AGUA CRYSTAL SEM GAS 500ML', 0.00, 2.00, '7894900530001', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2477, 'GOIANINHO COCO 850G', 0.00, 9.99, '7898644341411', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2478, 'ANELITOS CEBOLA 27G', 0.00, 1.70, '7896245708084', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2479, 'AÃ§UCAR ECOÃ§UCAR 2K', 0.00, 12.00, '7898185000051', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2480, 'AGUA SANITARIA YPE 1L', 0.00, 4.50, '7896098904671', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2481, 'SABÃ£O EM PO TIXAN YPE 400G', 0.00, 8.00, '7896098909720', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2482, 'SABÃ£O EM PO TIXAN YPE 800G', 0.00, 12.00, '7896098909751', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2483, 'DOCE DE NINHO COM MORANGO', 0.00, 1.50, '7896595581672', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2484, 'CRYSTAL TUBAINA 2LITROS', 0.00, 6.00, '7898941025069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2485, 'VELA ESTRELAR', 0.00, 5.00, '7899044223789', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2486, 'FEIJAO PRETO 300G', 0.00, 5.50, '7898905153517', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2487, 'CHOCOMIL 200ML', 0.00, 2.50, '7896590802123', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2488, 'NESTLE FRUTAS VERMELHAS', 4.50, 4.50, '7891000390078', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2489, 'CHAMYTO', 2.50, 2.50, '7891000027967', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2490, 'CHAMYTO 75G', 0.00, 1.50, '78928374', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2491, 'NINHO FORT+', 4.50, 4.50, '7891000103876', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2492, 'NESTLE IOGURTE MORANGO 170G', 3.50, 3.50, '7891000244265', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2493, 'IOGURTE VITAMINA FRUTAS', 3.50, 3.50, '7891000241448', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2494, 'LANCHEIRINHA', 3.80, 3.80, '7891000261484', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2495, 'CHAMYTO GO  100G', 3.50, 3.50, '7891000252819', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2496, 'CHAMBINHO RECREIO', 3.50, 3.50, '7891000360668', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2497, 'CHANDELLE', 6.50, 6.50, '78936195', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2498, 'NUTRI  NECTAR DE MORANGO 1L', 0.00, 7.00, '7898961490434', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2499, 'SPRIT 220 ML', 0.00, 3.00, '7894900681178', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2500, 'DEL VALLE  KAPO MORANGO 200ML', 0.00, 4.00, '7894900583700', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2501, 'FANTA UVA 220ML', 0.00, 3.50, '7894900050394', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2502, 'FANTA LARANJA 220ML', 0.00, 3.50, '7894900030396', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2503, 'POWER ADE TANGERINA 500ML', 0.00, 6.00, '7894900502046', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2504, 'POWER ADE MIX DE FRUTAS 500ML', 0.00, 6.00, '7894900504002', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2505, 'MENTOS SABOR MENTA', 0.00, 3.50, '7896262304306', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2506, 'GELATINES AMORA', 0.00, 1.50, '7896451912909', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2507, 'GOMA KUKY', 0.00, 1.50, '7897064811399-2507', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2508, 'AZEDINHO UVA', 0.00, 2.00, '7891151039710', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2509, 'AZEDINHO MORANGO', 0.00, 2.00, '7891151039697', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2510, 'FREEGELLS VITAMINA C', 0.00, 2.50, '7891151039673', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2511, 'GELATINES BEIJO', 0.00, 1.50, '7896451912893', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2512, 'GELATINES BANANA', 0.00, 1.50, '7896451912916', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2513, 'GELATINES VAMPIRO', 0.00, 1.50, '7896451912886', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2514, 'DOCIGOMA CORAÃ§Ã£O', 0.00, 1.50, '7896451903259', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2515, 'DOCIGOMA GURT', 0.00, 1.50, '7896451902580', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2516, 'DOCILE EUCALIPTO', 0.00, 1.50, '7896451903235', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2517, 'AMASSYXUP 15G', 0.00, 1.50, '7896969410478', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2518, 'TORTUGUITA CHOCOCROCANTE', 0.00, 1.50, '7898142865105', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2519, 'TRIDENT HERBAL', 0.00, 3.50, '7622210564313', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2520, 'TRIDENT ACID BLUEBERRY', 0.00, 3.50, '7622210564276', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2521, 'SONHO  DE VALSA  CROCANTE 25G', 0.00, 4.00, '7622210570086', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2522, 'SNICKERS 45G', 0.00, 5.70, '7896423420180', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2523, 'CARIBE', 0.00, 3.80, '7891008121193', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2524, 'GALAK 25G', 0.00, 2.50, '7891000321652', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2525, 'RUFFLES CHEESEBURGUER 35G', 0.00, 4.50, '7892840821098', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2526, 'YORGUTE 100 MORANGO', 0.00, 1.00, '7896058595512', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2527, 'PAÃ§OCA TUBITOS 15G', 0.00, 1.00, '7896383073495', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2528, 'GUARANÃ¡ JESUS 2L', 0.00, 10.00, '7894900941517', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2529, 'AGUA LA PRIORI 500ML', 0.00, 2.00, '7898121460147', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2530, 'BELAGURT 850G', 7.99, 7.49, '7898644341961', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2531, 'IOGURTE SALADA DE FRUTA SACO', 6.50, 7.49, '7898644341213', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2532, 'GOIANINHODE FRUTAS 110G', 1.50, 1.75, '7898644341053', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2533, 'GOIANINHO AÃ§AÃ­ E BANANA 140G', 2.79, 2.79, '7898644341510', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2534, 'GOIANINHO UVA', 7.50, 7.50, '7896520029170', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2535, 'SOUZA PAIOL', 16.00, 16.00, '7898996132385', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2536, 'ACUCAR 5K', 0.00, 20.00, '7898218770036', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2537, 'ACUCAR PEROLA 5K', 0.00, 20.00, '7898218770036-2537', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2538, 'GOIANINHO LARANJA E LIMAO 2L', 0.00, 7.50, '7896520029187', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2539, 'DEL VALLE DE UVA 1L', 0.00, 11.00, '7898341430098', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2540, 'SARDINHA GOMES COSTA COM Ã³LEO', 0.00, 7.99, '7891167021013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2541, 'LEITE CONDENSADO CEMIL 395G', 0.00, 7.00, '7896590817035', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2542, 'LEITE INTEGRAL TIROL 1L', 0.00, 6.50, '7896256601848', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2543, 'TRENTO', 0.00, 3.50, '7896306619458', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2544, 'COCA COLA COM CAFE MINI LATA', 0.00, 3.50, '7894900025019', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2545, 'SCHWEPPES ORIGINAL 220ML', 0.00, 3.50, '7894900180619', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2546, 'POWER SABOR UVA', 0.00, 6.00, '7894900501001', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2547, 'DEL VALLE  KAPO ABACAXI', 0.00, 4.00, '7894900603705', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2548, 'TRENTO DUO 30G', 0.00, 3.50, '7896306623202', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2549, 'TRENTO DARK 30G', 0.00, 3.50, '7896306621147', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2550, 'NUTRI NECTAR 1L CAJU', 0.00, 7.00, '7898920195301', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2551, 'NUTRI NECTAR 1L GOIABA', 0.00, 7.00, '7898920195349', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2552, 'NUTRI NECTAR 200ML UVA', 0.00, 2.50, '7898920195240', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2553, 'NUTRI NECTAR 200ML MORANGO', 0.00, 2.50, '7898961490427', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2554, 'CAFE FORT 3 CORAÃ§ÃµES', 0.00, 28.00, '7896005800546', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2555, 'MOLHO DE TOMATE BONARE', 0.00, 2.50, '7899659901096', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2556, 'EXTRATO DE TOMATE OLÃ©', 0.00, 5.00, '7891032015505', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2557, 'CREME DE LEITE MOCOCA 200G', 0.00, 4.00, '7891030300306', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2558, 'MILHO PREDILECTA', 0.00, 4.50, '7896292340503', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2559, 'COOKIES COM GOTAS 60G', 0.00, 4.00, '7891000339596', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2560, 'GOMUTCHO', 0.00, 1.00, '7891151029438', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2561, 'FRESH ABACAXI', 0.00, 2.00, '7622210570031', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2562, 'FRESH CAJU', 0.00, 2.00, '7622210569912', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2563, 'FRESH LARANJA', 0.00, 2.00, '7622210569790', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2564, 'FRESH GUARANA', 0.00, 2.00, '7622210569882', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2565, 'FRESH LIMÃ£O', 0.00, 2.00, '7622210569974', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2566, 'HALLS MENTA', 0.00, 2.50, '78938830', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2567, 'SAL MARINHO REFINADO 1KG', 0.00, 3.00, '7898964698011', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2568, 'MONSTER ENERGY', 0.00, 10.00, '070847022015', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2569, 'AÃ§UCAR CRISTAL 2KG', 0.00, 12.00, '040232717048', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2570, 'NESTON 3CEREAIS 170G', 0.00, 3.80, '7891000260609', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2571, 'NESTLE MORANGO 150G', 0.00, 4.50, '7891000340004', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2572, 'COMPLEITE INTEGRAL 1L', 0.00, 6.00, '7896773900417', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2573, 'DORITOS SWEET CHILI 37G', 0.00, 5.00, '7892840822439', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2574, 'FANTA UVA 500 ML', 0.00, 5.50, '7894900053562', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2575, 'FANTA GUARANA 500ML', 0.00, 5.50, '7894900093315', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34');
INSERT INTO `tb1_produto` (`tb1_id`, `tb1_nome`, `tb1_vlr_custo`, `tb1_vlr_venda`, `tb1_codbar`, `tb1_tipo`, `tb1_status`, `tb1_favorito`, `tb1_vr_credit`, `created_at`, `updated_at`) VALUES
(2576, 'SPRITE LEMON FRESH 510ML', 0.00, 5.50, '7894900680508', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2577, 'POWER ADE LIMÃ£O 500ML', 0.00, 6.00, '7894900500035', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2578, 'MINUANO EM BARRA 900G', 0.00, 16.00, '7908324402865', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2579, 'MENTOS FRUIT', 0.00, 3.50, '7896262304351', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2580, 'MAIONESE SOYA 500G', 0.00, 9.00, '7894904271368', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2581, 'TRENTO CHOCOLATE 32G', 0.00, 3.50, '7896306612817', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2582, 'TRENTO MOUSSE DE MARACUJA 32G', 0.00, 3.50, '7896306619434', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2583, 'SUFLAIR 50 G', 0.00, 6.50, '7891000107836', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2584, 'QBOA 1L', 0.00, 4.50, '7896083800018', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2585, 'TANG MARACUJA', 0.00, 2.00, '7622210571694', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2586, 'RUFFLES CEBOLA E SALSA 68G', 0.00, 9.00, '7892840823030', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2587, 'RUFFLES CHURRASCO 68G', 0.00, 9.00, '7892840823047', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2588, 'RUFLLES 40G ORIGINAL', 0.00, 4.00, '7892840819750', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2589, 'RUFLLES CHURRASCO 40G', 0.00, 4.00, '7892840819736', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2590, 'LAFRUIT MANGA 200ML', 0.00, 3.00, '7896520023505', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2591, 'LAFRUIT PESSEGO E MANGA', 0.00, 3.00, '7896520023055', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2592, 'CHOCOBOM 1L', 0.00, 9.00, '7898215155133', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2593, 'CHEETOS PARMESÃ£O 95G', 0.00, 10.00, '7892840822514', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2594, 'CHEETOS REQUEIJÃ£O 105G', 0.00, 10.00, '7892840823467', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2595, 'DORITOS 32G', 0.00, 5.00, '7892840822385', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2596, 'FOSFORO LONGO FIAT LUX', 0.00, 1.00, '7896007942213', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2597, 'SUCO FRESH MANGA', 0.00, 2.00, '7622210570000', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2598, 'SUCO FRESH MORANGO', 0.00, 2.00, '7622210569820', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2599, 'SUCO FRESH UVA', 0.00, 2.00, '7622210569943', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2600, 'JUJUBA YOGURT', 0.00, 1.50, '7891151029452', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2601, 'JUJUBA YOGURT', 0.00, 1.50, '7891151029452-2601', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2602, 'JUJUBA DE FRUTAS', 0.00, 1.50, '7891151029438-2602', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2603, 'DEL VALLE KAPO CAJU 200ML', 0.00, 4.00, '7894900650044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2604, 'DEL VALLE KAPO MARACUJA 200ML', 0.00, 4.00, '7894900573701', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2605, 'DEL VALLE KAPO LARANJA 200ML', 0.00, 4.00, '7894900563702', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2606, 'DEL VALLE KAPO MAÃ‡Ãƒ 200ML', 0.00, 4.00, '7894900650013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2607, 'COCADA AMOR COCO', 0.00, 4.00, '6099637363316', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2608, 'COCADA AMOR COCO PRETA', 0.00, 4.00, '606529936457', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2609, 'NISSIN GALINHA CAIPIRA PICANTE', 0.00, 3.00, '7891079014028', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2610, 'NISSIN MEXICANO COM PIMENTA', 0.00, 3.00, '7891079011478', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2611, 'TRENTO ALEGRO', 0.00, 3.00, '7896306624520', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2612, 'ALPINO NESTLE', 0.00, 2.50, '7891000313015', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2613, 'DETERGENTE MINUANO NEUTRO', 0.00, 4.00, '7897664130036', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2614, 'NESCAU 200G', 0.00, 10.50, '7891000379585', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2615, 'KETCHUP QUERO 400G', 0.00, 9.50, '7896102502756', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2616, 'AÃ§UCAR PEROLA 1K', 0.00, 6.50, '7898218770012', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2617, 'NUTRI NNEECTARR  MARACUJA', 0.00, 2.50, '7898920195226-2617', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2618, 'TRENTO DUO 32G', 0.00, 3.00, '7896306623202-2618', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2619, 'FINI BEIJOS 15G', 0.00, 2.00, '7898591450662', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2620, 'MEGA BATATAS PALHA', 0.00, 7.00, '7898551270927', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2621, 'TRIDENT MORANGO', 0.00, 3.00, '7895800201503', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2622, 'PAÃ§OCA PEQUENA', 0.00, 1.00, '751320849267', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2623, 'DORITOS 120G', 0.00, 15.00, '7892840822446', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2624, 'DORITOS SWEET CHILI 140G', 0.00, 15.00, '7892840817930', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2625, 'DORITOS SWEET CHILI 75G', 0.00, 10.00, '7892840822361', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2626, 'DORITOS SWEET CHILI 120G', 0.00, 15.00, '7892840822729', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2627, 'NUTRI NECTAR PÃŠSSEGO 220ML', 0.00, 2.50, '7898920195233', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2628, 'AGUA MARIZA 500ML', 0.00, 2.50, '7898920195028', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2629, 'COCACOLA K-WAVE SEM AÃ§UCAR', 0.00, 4.00, '7894900029406', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2630, 'NUTRI NECTAR MARACUJA 200ML', 0.00, 2.50, '7898920195097', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2631, 'LACTA BRANCO E DIAMANTE NEGRO  80G', 0.00, 10.00, '7622210575630', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2632, 'TRENTO TORTA DE LIMÃ£O 32G', 0.00, 2.50, '7896306618291', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2633, 'GELEIA DE GOMA 70G', 0.00, 2.00, '7898364280373', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2634, 'PE DE MOÃ§A 55G', 0.00, 2.50, '7898364280359', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2635, 'PAÃ§OCA CASEIRA', 0.00, 2.50, '751320093561', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2636, 'TRENTO MASSIMO CHOCOLATE', 0.00, 2.50, '7896306618420', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2637, 'TRENTO MASSIMO MORANGO', 0.00, 2.50, '7896306623141', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2638, 'IOGURTE MAMÃ£O, MAÃ§Ã£ E BANANA 450G', 0.00, 6.99, '7898644341442', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2639, 'GOIANINHO DE UVA 110G', 0.00, 1.75, '7898644341084', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2640, 'MOLHO DE PIMENTA FRICÃ³ 145ML', 0.00, 3.00, '7898916326764', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2641, 'COLGATE 50G', 0.00, 5.80, '7891024132906', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2642, 'SARDINHA MOLHO DE TOMATE 88', 0.00, 6.50, '7891167023024', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2643, 'SUCO NUTRI DE MARACUJÃ¡ 1L', 0.00, 7.00, '7898961490465', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2644, 'DORITOS 37G', 0.00, 5.00, '7892840822408', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2645, 'NUTRI NECTAR DE MANGA 1L', 0.00, 7.00, '7898920195110', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2646, 'NUTRI NECTAR DE UVA 1L', 0.00, 7.00, '7898920195141', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2647, 'TODDY ORIGINAL 370G', 0.00, 12.50, '7892840819507', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2648, 'CHEETOS CRUNCHY CHEDDAR 48G', 0.00, 4.00, '7892840821951', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2649, 'CHEETOS CRUNCHY SUPER CHEDDAR 48G', 0.00, 3.99, '7892840821975', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2650, 'FREEGELLS CREAM', 0.00, 1.50, '7891151039659', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2651, 'SPRITE 250ML', 0.00, 3.00, '78939738', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2652, 'TRENTO CHEESECAKE DE MORANGO 29G', 0.00, 2.50, '7896306625213', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2653, 'PITHULA LARANJA 2 LT', 7.00, 8.00, '7896520029071', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2654, 'SABAO MINUANO 800G', 13.00, 13.00, '7908324403268', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2655, 'MINUANO COCO 500 ML', 3.00, 3.00, '7897664130302', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2656, 'MACARRAO CRISTAL', 4.50, 4.50, '7896212911738', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2657, 'LEITE C. SEMIDESNATADO TIROL 395G', 0.00, 7.00, '7896256604962', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2658, 'GUARANÃ¡ JESUS 250ML', 0.00, 3.00, '7894900941838', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2659, 'COCA COLA SEM AÃ§UCAR 220ML', 0.00, 3.50, '7894900700398', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2660, 'MENTOS TUTTI FRUTTI', 0.00, 3.50, '7895144603223', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2661, 'MOLHO PIMENTA VERDE C/ ERVAS FINAS 150G', 0.00, 8.00, '7961080325397', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2662, 'MOLHO PIMENTA EXTRA FORTE 150G', 0.00, 8.00, '7961080325441', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2663, 'MOLHO PIMENTA AGRIDOCE C/ CHIMICHURRI 150G', 0.00, 8.00, '7961080325403', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2664, 'LEITE CAPILAT 1L', 5.50, 5.50, '7898931794340', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2665, 'CHEETOS QUEIJO SUIÃ§O  37 G', 3.50, 3.50, '7892840821203', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2666, 'RUFFLES ORIGINAL', 0.00, 4.00, '7892840822996', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2667, 'RUFFLES CEBOLA E SALSA', 0.00, 4.00, '7892840822989', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2668, 'RUFFLES CHURRASCO', 0.00, 4.00, '7892840823009', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2669, 'STIKSY ASSADO', 0.00, 2.00, '7892840822538', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2670, 'AGUA NATURAL ORGÃ£NICA 500ML', 0.00, 2.00, '751320989208', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2671, 'LEITE TRIANGULO 1L', 0.00, 6.50, '7896434920549', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2672, 'DOCE DE ABOBORA', 0.00, 2.50, '7898922790306', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2673, 'PIPOCA DOCE IEIE 40G', 0.00, 1.50, '7898930626017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2674, 'MILHO VERDE FUGINI 170G', 0.00, 4.50, '7897517209544', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2675, 'PAPEL H. FLORAL NEUTRO', 0.00, 6.00, '7896006412656', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2676, 'ESCOVA PARA LAVAR CONDOR', 0.00, 4.50, '7891055111604', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2677, 'MINUANO EM BARRA ROSA 180G', 0.00, 4.00, '7908324402926', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2678, 'TRENTO MOMENTOS DE CHOCOLATE 192G', 0.00, 16.00, '7896306624650', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2679, 'TRENTO DE MORANGO 32G', 0.00, 2.50, '7896306623158', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2680, 'TRENTO DE AVELÃ£ 32G', 0.00, 2.50, '7896306612831', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2681, 'TRENTO DARK 32G', 0.00, 2.50, '7896306617492', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2682, 'TRENTO DUO 32G', 0.00, 2.50, '7896306623448', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2683, 'TRIDENT XSENSES', 0.00, 3.50, '7622210564290', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2684, 'FANTA GUARANA 220ML', 0.00, 3.50, '7894900093025', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2685, 'VELA ESTRELAR PONTO', 0.00, 5.00, '7899044202104', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2686, 'MOLHO DE TOMATE FUGINI', 0.00, 2.50, '7897517206086', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2687, 'MAIONESE ORIGINAL FUGNI 180G/179ML', 0.00, 3.50, '7897517205638', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2688, 'NUTRI 250 ML PESSEGO', 0.00, 2.50, '7898961490472', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2689, 'PIMENTA GOTA PICANTE', 0.00, 3.50, '7898286190316', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2690, 'PICOLE LEITE COND. CREAM 60G', 0.00, 4.00, '7898935182471', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2691, 'PICOLE COCO 60G BONABOCA', 0.00, 4.00, '7898935182464', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2692, 'PICOLE GROSELHA 60G BONABOCA', 0.00, 3.50, '7898935182433', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2693, 'PICOLE UVA 60G BONABOCA', 0.00, 4.00, '7898935182426', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2694, 'PICOLE CHOCOLATE 60G BONABOCA', 0.00, 4.00, '7898935182488', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2695, 'PICOLE MORANGO 60G BONABOCA', 0.00, 4.00, '7898935182518', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2696, 'PICOLE CAJA 60G BONABOCA', 0.00, 4.00, '7898935182440', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2697, 'PICOLE TAMARINDO 60G BONABOCA', 0.00, 3.50, '7898935182457', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2698, 'PICOLE TABLETS BAUNILHA 65G BONABOCA', 0.00, 8.00, '7898901196396', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2699, 'PICOLE WHITE 70G BONABOCA', 0.00, 9.00, '7898901196044', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2700, 'PICOLE TRUFA 70G BONABOCA', 0.00, 9.00, '7898901196204', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2701, 'PICOLE NAPOLITANO 70G BONABOCA', 0.00, 7.00, '7898901196020', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2702, 'PICOLE FLOCOS 65G', 0.00, 7.00, '7898901199137', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2703, 'GUARANA KUAT 310ML', 0.00, 4.00, '7894900911152', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2704, 'COPITO FLOCOS 85G BONABOCA', 0.00, 5.00, '7898935182730', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2705, 'COPAO NAPILITANO 180G BONABOCA', 0.00, 9.00, '7898935182747', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2706, 'BONAMIX NINHO TRUFADO 180G BONABOCA', 0.00, 10.00, '7898714280305', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2707, 'AÃ§AI C/ LEITINHO 160G BONABOCA', 0.00, 8.99, '7898714280312', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2708, 'AÃ§AI C/ BANANA 160G BONABOCA', 0.00, 8.99, '7898714280329', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2709, 'AÃ§AI LEITINHO 1L  BONABOCA', 0.00, 28.90, '7898714280374', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2710, 'AÃ§AI C/ BANANA 1L BONABOCA', 0.00, 28.90, '7898714280381', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2711, 'SORVETE DE CHOCOLATE 1L BONABOCA', 0.00, 17.90, '7898714280350', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2712, 'LEITE NAPOLITANO 1L', 0.00, 5.50, '7898931794289', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2713, 'APRESUNTADO PERDIGÃ£O 200G', 0.00, 5.00, '7891515435134', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2714, 'SCHWEPPES SEM AÃ§UCAR 310ML', 0.00, 4.00, '7894900361155', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2715, 'FANTA MARACUJA 310ML', 0.00, 4.00, '7894900091069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2716, 'TRENTO BRANCO', 0.00, 2.50, '7896306616389', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2717, 'TRENTO TORTA DE MAÃ§A', 0.00, 2.50, '7896306623226', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2718, 'AGUA PORTO REAL 500ML', 0.00, 2.00, '7898963757122', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2719, 'FRESQUETO ACEROLA 270ML', 0.00, 2.50, '7898697570028', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2720, 'FRESQUETO MORANGO 270ML', 0.00, 2.50, '7898697570035', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2721, 'FRESQUETO UVA 270ML', 0.00, 2.50, '7898956846802', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2722, 'REQUEIJÃ£O CREMOSO GOIANINHO 180G', 0.00, 8.99, '7898644342401', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2723, 'POWER ADE FRUTAS TROPICAIS 500ML', 0.00, 6.00, '7894900508017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2724, 'MONSTER MANGO LOCO 473ML', 0.00, 10.00, '070847033301', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2725, 'MONSTER WATERMELON 473ML', 0.00, 10.00, '1220000250222', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2726, 'CUP NOODLES YAKISSOBA TRADICIONAL 70G', 0.00, 6.00, '7891079013106', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2727, 'CUP NOODLES LEGUMES COM AZEITE 67G', 0.00, 6.00, '7891079013090', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2728, 'RUFFLES OUTBACK 30G', 0.00, 4.00, '7892840823542', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2729, 'CAFE EXPORT EXTRA FORTE 250G', 0.00, 12.50, '7896362900033', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2730, 'AGUA DE COCO KERO COCO 1L', 0.00, 12.00, '7896828000239', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2731, 'CHEETOS MIX DE QUEIJO 82G', 0.00, 10.00, '7892840822316', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2732, 'SOTRIX MARACUJA', 0.00, 1.50, '7898902259571', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2733, 'SOTRIX MORANGO', 0.00, 1.50, '7898902259533', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2734, 'AGUA PORTO REAL 1,5L', 0.00, 5.00, '7898963757191', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2735, 'ALBANY SABONETE OLEO DE MACADÃ£MIA', 0.00, 2.50, '7897664171725', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2736, 'ALBANY SABONETE ANTIBC 85G', 0.00, 2.50, '7908324404029', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2737, 'ALBANY SABONETE FRUTAS VERMELHA 85G', 0.00, 2.50, '7908324404005', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2738, 'FRANCIS GARDENIA 85G', 0.00, 3.50, '7891176117486', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2739, 'MOLHO DE TOMATE TRADIONAL 300G', 0.00, 2.50, '7898929590657', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2740, 'OREO 18G', 0.00, 1.50, '7622210530073', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2741, 'ROYAL FERMENTO EM PO 100G', 0.00, 5.50, '7622300119621', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2742, 'TRENTO MINI BRANCO', 0.00, 1.50, '7896306621185', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2743, 'TRENTO MINI AVELA', 0.00, 1.50, '7896306624001', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2744, 'TRENTO MINI CHOCOLATE', 0.00, 1.50, '7896306621154', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2745, 'TRENTO MINE CASTANHA', 0.00, 1.50, '7896306624605', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2746, 'TRENTO MINI MILK', 0.00, 1.50, '7896306624599', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2747, 'FLOCÃ£O GUARA 500G', 0.00, 2.40, '7896711600614', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2748, 'NUTRI NECTAR LARANJA 1L', 0.00, 6.50, '7898920195103', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2749, 'CAFE 3 CORAÃ§OES TRADICIONAL 500G', 0.00, 28.00, '7896005800010', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2750, 'CAFE 3 CORAÃ§OES EXTRAFORTE 500G', 0.00, 25.00, '7896005801529', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2751, 'CAFE SANTA CLARA 500G', 0.00, 34.00, '7896005809259', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2752, 'PAPEL H. STYLUS 12 ROLOS', 0.00, 15.00, '7896026801225', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2753, 'PAPEL H. DELUXE 12 ROLOS', 0.00, 16.00, '7896914011217', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2754, 'PAPEL H. PERSONAL 4 ROLOS', 0.00, 6.00, '7896110091440', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2755, 'NINHO RECHEADO COM NUTELA 65G', 0.00, 6.90, '7898935182587', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2756, 'BRIGADEIRO ESPECIAL 60G', 0.00, 6.90, '7898935182556', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2757, 'PICOLE SKIMO 70G', 0.00, 6.50, '7898935182549', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2758, 'PICOLE AÃ§AI COM LEITE CONDENSADO', 0.00, 6.90, '7898935182532', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2759, 'PICOLE LIMAO SUIÃ§O 60G', 0.00, 4.00, '7898935182501', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2760, 'PICOLE DE AÃ§AI GELADO NO PALITO 65G', 0.00, 4.50, '7898935182525', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2761, 'SCHWEPPES 310ML', 0.00, 4.00, '7894900180527', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2762, 'COCA COLA ORIGINAL 1,5L', 0.00, 9.00, '7894900027129', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2763, 'JUJUBA DOCIGOMA', 0.00, 1.50, '7896451911582', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2764, 'COCA COLA RETORNÃ¡VEL', 0.00, 8.00, '7894900027082-2764', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2765, 'NANTEIGA DELICATA 250G', 0.00, 5.00, '7894904284825', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2766, 'LEITE', 0.00, 5.50, '7898931794272', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2767, 'BISCOITO RANCHEIRO MORANGO 78G', 0.00, 2.50, '7896253401557-2767', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2768, 'BISCOITO RANCHEIRO BAUNILHA 75G', 0.00, 2.50, '7896253401571', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2769, 'TODDY ORIGINAL 750G', 0.00, 18.00, '7892840819170', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2770, 'DORITOS DINAMITA 60G', 0.00, 5.00, '7892840822378', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2771, 'GUARA FIT GUARANA E ACAI 290ML', 0.00, 2.80, '7898956846031', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2772, 'IOGURTE GOIANINHO COCO 450G', 0.00, 6.29, '7898644341404', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2773, 'ICE CANA NATURAL 300ML', 0.00, 6.00, '7896772600141', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2774, 'TAMPICO 1L', 0.00, 8.00, '095188870347', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2775, 'SUCO ALEGRIA SABOR LARANJA 2L', 0.00, 9.00, '7899465200512', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2776, 'FANTA BEETLEJUICE 310ML', 0.00, 4.00, '7894900095142', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2777, 'FANTA GUARANA 310ML', 0.00, 4.00, '7894900093032', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2778, 'OLEO CONCORDIA 900ML', 0.00, 10.00, '7898247780075', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2779, 'DISQUETI CHOCOLATE', 0.00, 2.00, '7896058500189', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2780, 'COCA COLA OREO SEM AÃ§UCAR 310ML', 0.00, 4.00, '7894900029505', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2781, 'LACTA AO LEITE 80G', 0.00, 12.00, '7622210673831', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2782, 'RED BULL ENERGETICO 250ML', 0.00, 10.00, '9002490100070', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2783, 'AGUA COM GAS PORTO REAL 500ML', 0.00, 2.50, '7898963757139', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2784, 'EXTRATO DE TOMATE OLE 260G', 0.00, 5.50, '7891032015604', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2785, 'COLGATE MENTA ORIGINAL 90G', 0.00, 6.00, '7891024132005', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2786, 'ALBANY CAPIM LIMÃ£O 85G', 0.00, 2.50, '7908324408447', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2787, 'PAPEL HIGIENICO MAX PURE', 0.00, 8.50, '7898962794050', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2788, 'ESPONJA TININDO LIMPEZA', 0.00, 1.50, '7891040128082', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2789, 'URSO MACIO', 0.00, 19.99, '7898405068731', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2790, 'PISTOLA DÂ´AGUA', 0.00, 19.99, '7898405068137', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2791, 'SAPINHO SOCO SOCO', 0.00, 17.90, '7898405063149', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2792, 'PATO PULA PULA', 0.00, 24.90, '7908274800285', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2793, 'PIRULITO GIRA GIRA', 0.00, 10.00, '7898656685060', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2794, 'BALA DE GELATINA 25G', 0.00, 9.99, '7898656686760', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2795, 'TCHUCO TCHUCO COM SOM', 0.00, 19.90, '7898405066126', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2796, 'PIROLE ICE FRUTAS', 0.00, 5.99, '7898656685244', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2797, 'GIRA GIRA HAPPY BEE', 0.00, 19.90, '7898405069530', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2798, 'PEGA PEGA JACARE', 0.00, 19.99, '7898405069516', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2799, 'POPLITO UNICORNIO', 0.00, 3.00, '7898656685695', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2800, 'CARRINHOS BATE PULA', 0.00, 12.90, '7908274801480', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2801, 'BRINCLETÂ´S TIRA', 0.00, 5.99, '7898656685855', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2802, 'MONSTER ENERGY ZERO SUGAR', 0.00, 10.00, '7898938890076', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2803, 'DORITOS KETCHUP 37G', 0.00, 5.00, '7892840823610', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2804, 'LAYS SOUR CREAM 70G', 0.00, 10.00, '7892840823399', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2805, 'LAYS CLASSICA 70G', 0.00, 10.00, '7892840823375', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2806, 'SUCO ALEGRIA SABOR LARANJA 320ML', 0.00, 3.00, '7899465200505', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2807, 'GUARAMIX 250ML', 0.00, 3.00, '7898216252114', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2808, 'JUJUBA GOMETS FRUTAS', 0.00, 1.50, '7896058506105', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2809, 'JUICE BOX LARANJA 200ML', 0.00, 3.00, '7898961490069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2810, 'LEITE INTEGRAL FILOMENA 1L', 0.00, 5.50, '7898054780015', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2811, 'NEGRESCO WAFER 110G', 0.00, 3.00, '7891000077962', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2812, 'MOSTARDA 180G', 0.00, 4.00, '7896140666069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2813, 'DEZ EXTRATO DE TOMATE 140G', 0.00, 2.50, '7898929590626', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2814, 'DEZ HOT DOG 300G', 0.00, 2.50, '7898929590572', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2815, 'TOMARELLI MOLHO DE TOMATE 300G', 0.00, 2.50, '7896140666205', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2816, 'TOMARELLI MOLHO DE TOMATE 300G', 0.00, 2.50, '7896140666205-2816', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2817, 'TOMARELLI MOLHO DE TOMATE 300G', 0.00, 2.50, '7896140666205-2817', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2818, 'TOMARELLI MOLHO DE TOMATE 300G', 0.00, 2.50, '7896140666205-2818', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2819, 'BISCOITO RECHEADO FOFINHO', 0.00, 2.50, '7898176550312', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2820, 'FUTURINHOS WAFER CHOCOLATE', 0.00, 2.50, '7898657830322', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2821, 'FUTURINHOS WAFER BLACK', 0.00, 2.50, '7898657830353', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2822, 'BISCOITO FOFINHO MORANGO', 0.00, 2.50, '7898176550367', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2823, 'POPLITO DINO', 0.00, 3.00, '7898656685121', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2824, 'POPLITO CARROS', 0.00, 3.00, '7898656685183', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2825, 'POPLITO BEIJINHO', 0.00, 3.00, '7898656685152', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2826, 'POPLITO PRINCESAS', 0.00, 3.00, '7898656685091', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2827, 'MÃ£MA UNICORNIO', 0.00, 5.00, '7898656683523', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2828, 'GOIABADA PREDILECTA 300G', 0.00, 4.50, '7896292330061', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2829, 'LA FRUIT LATA 350ML UVA', 0.00, 6.00, '7896520021174', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2830, 'LA FRUIT LATA 350ML MARACUJA', 0.00, 6.00, '7896520021129', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2831, 'PRESTIGIO DARK 33G', 0.00, 3.50, '7891000118580', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2832, 'GOIANINHO ZERO MORANGO 850G', 0.00, 10.49, '7898644341992', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2833, 'MICOS PRESUNTO 41G', 0.00, 2.50, '7896245710193', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2834, 'MIKÃ£O PRESUNTO 90G', 0.00, 3.50, '7896245709432', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2835, 'MIKÃ£O GALINHA 90G', 0.00, 3.50, '7896245709425', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2836, 'MIKÃ£O REQUEIJÃ£O 90G', 0.00, 3.50, '7896245709456', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2837, 'MICOS REQUEIJÃ£O 41G', 0.00, 2.50, '7896245710216', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2838, 'MICOS REQUEIJÃ£O 28G', 0.00, 1.50, '7896245710179', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2839, 'MICOS GALINHA 28G', 0.00, 1.50, '7896245710148', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2840, 'MAIONESE PRAMESA 200G', 0.00, 4.50, '7898556015035', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2841, 'DETERGENTE ESTRELA COCO', 0.00, 4.00, '7897323600467', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2842, 'DETERGENTE ESTRELA NEUTRO', 0.00, 3.00, '7897323600092', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2843, 'MICOS QUEIJO 28G', 0.00, 1.50, '7896245710162', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2844, 'TORCIDA QUEIJO 35G', 0.00, 1.50, '7892840822521', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2845, 'DORITOS DINAMITA PIMENTA MEXICANA', 0.00, 5.00, '7892840823481', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2846, 'BIS XTRA 45G', 0.00, 4.00, '7622300988470', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2847, 'MILHO EM CONSERVA BONARE 260G', 0.00, 4.50, '7899659901126', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2848, 'MONSTER TROPICAL ORANGE', 0.00, 10.00, '1220000250147', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2849, 'LETE NINHO', 0.00, 1.50, '7890000000017', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2850, 'COOKIES CROCANTE', 0.00, 3.50, '7891000402856', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2851, 'COOKIES NEGRESCO', 0.00, 4.00, '7891000247624', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2852, 'COOKIES NESCAU', 0.00, 3.50, '7891000339558', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2853, 'BISCOITO PASSATEMPO LEITE', 0.00, 3.30, '7891000051436', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2854, 'BISCOITO PASSATEMPO MORANGO', 0.00, 3.50, '7891000241295', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2855, 'BISCOITO NEGRESCO', 0.00, 3.30, '7891000376768', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2856, 'COOKIES ALPINO', 0.00, 4.00, '7891000350119', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2857, 'COOKIES GALAK', 0.00, 4.00, '7891000350072', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2858, 'COOKIES PASSATEMPO', 0.00, 4.00, '7891000109298', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2859, 'COOKIE PRESTIGIO', 0.00, 4.00, '7891000339237', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2860, 'TEMPERO ALHO E SAL ACHEI 500G', 0.00, 5.50, '630941716717', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2861, 'VELA 0 AZUL', 0.00, 5.00, '7899044200971', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2862, 'VELA ? ROSA', 0.00, 5.00, '7899044202111', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2863, 'WHEY MORANGO 250ML', 0.00, 7.50, '7898215157847', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2864, 'TRENTO TORTA DE LIMÃƒO 29G', 0.00, 3.00, '7896306625374', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2865, 'TRENTO CHOCOLATE 29G', 0.00, 3.00, '7896306625237', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2866, 'TRENTO TORTA DE MAÃ‡A 29G', 0.00, 3.00, '7896306625398', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2867, 'TRENTO DARK 29G', 0.00, 3.50, '7896306625275', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2868, 'TRENTO AVELÃƒ 29G', 0.00, 2.50, '7896306625190', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2869, 'TRENTO MOUSSE DE MARACUJA 29G', 0.00, 3.50, '7896306625350', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2870, 'OVOS 12 UNIDADES', 0.00, 10.00, '7898967993014', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2871, 'MICOS GALINHA 41G', 0.00, 2.50, '7896245710186', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2872, 'AÃ§UCAR REFINADO CARAVELAS 1KG', 0.00, 9.50, '7896894900013', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2873, 'SAL MARINHO BOM DE MESA 1K', 0.00, 3.00, '7898280090032', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2874, 'COOKIES CARIBE', 0.00, 3.50, '7891000402894', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2875, 'ROTHMANS', 0.00, 8.50, '78944237', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2876, 'RESTANTE DA ENCOMENDA 500 MINI PAES', 0.00, 150.00, '78935495', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2877, 'BALDE GRANDE VAZIO', 0.00, 10.00, '7896279600200', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2878, 'ALBANY SPORT', 0.00, 2.50, '7897664171732', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2879, 'MIKÃ£O QUEIJO 90G', 0.00, 3.50, '7896245709449', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2880, 'MIKÃ£O CEBOLA 90G', 0.00, 3.50, '7896245709463', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2881, 'SNICKERS PE DE MOLEKE 42G', 0.00, 4.00, '7896423497984', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2882, 'KITKET', 0.00, 4.00, '7891000248768', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2883, 'SNICKERS MARACUJA', 0.00, 4.00, '7896423456561', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2884, 'AGUA DE COCO MARI COCO 200ML', 0.00, 3.50, '7898961490267', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2885, 'UFO CARNE C MOLHO JAPONES 81G', 0.00, 8.50, '7891079013847', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2886, 'UFO GALINHA CAIPIRA 81G', 0.00, 8.50, '7891079014172', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2887, 'NISSIN SABOR TOMATE', 0.00, 3.00, '7891079001028', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2888, 'ALBANY ANTIBAC MENTOL 85G', 0.00, 2.50, '7897664171756', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2889, 'FRUTSY UVA', 0.00, 1.00, '7896058595550', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2890, 'FRUTSY CHOCOLATE', 0.00, 0.50, '7896072595574', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2891, 'FRUTSY CHOCOLATE', 0.00, 1.00, '7896058595574', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2892, 'SKAT BALINHA', 0.00, 5.99, '7898405068649', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2893, 'BICICLETA BALINHA', 0.00, 5.99, '7898405061718', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2894, 'SPRITE 600ML', 0.00, 6.00, '7894900681246', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2895, 'BATATA PALHA KARIS 140G', 0.00, 7.00, '7898078611869', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2896, 'SABAO YPE GREEN 180G', 0.00, 5.00, '7896098905920', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2897, 'BATATA PALHA SLIGHI 60G', 0.00, 5.50, '7896245707124', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2898, 'BATATA PALHA SLIGHT 100G', 0.00, 8.50, '7896245707131', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2899, 'LAMINA PARA BARBEAR', 0.00, 2.00, '7891051015210', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2900, 'LUCKY STRIKE', 0.00, 15.00, '78946187', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2901, 'PE DE MOLEQUE CROCANTE', 0.00, 2.00, '7898943946126', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2902, 'DOCE DE LEITE REAL', 0.00, 1.00, '7897257400225', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2903, 'POWER ADE LARANJA 500ML', 0.00, 6.00, '7894900503029', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2904, 'EQUILIBRI PANETINI PRESUNTO 40G', 0.00, 3.99, '7892840267841', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2905, 'VELA 4 AZUL', 0.00, 5.00, '7899044201015', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2906, 'PIRULITO $0.25', 0.25, 0.25, '41414141', 0, 1, 1, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:35'),
(2907, 'MICOS PRESUNTO 28G', 0.00, 1.50, '7896245710155', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2908, 'VELA 2 AZUL', 0.00, 5.00, '7898726140284', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2909, 'VELA 9 ROSA', 0.00, 5.00, '7898446284367', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2910, 'BOLETE TUTTI FRUTTI', 0.00, 1.00, '7896058500288', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2911, 'VELA 1 ROSA', 0.00, 5.00, '7899044201084', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2912, 'CAFÃ© PILÃ£O 500G', 0.00, 28.00, '7896089013634', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2913, 'BICOITO BONO 90G', 0.00, 3.30, '7891000376843', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2914, 'TRENTO BRANCO DARK 29G', 0.00, 3.50, '7896306625251', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2915, 'BRINCLETS', 0.00, 5.99, '7898656685886', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2916, 'MOEDA CHOCOLATE REAL', 0.00, 1.00, '7898094763184', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2917, 'BALDE MEDIO VAZIO', 0.00, 8.00, '7896434920501', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2918, 'BALDE PEQUENO VAZIO', 0.00, 5.00, '7898049431540', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2919, 'LEITE QUATÃ¡ 1L', 0.00, 6.50, '7896183202187', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2920, 'COCA COLA PET 200ML', 0.00, 3.00, '78908901', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2921, 'LEITE PIRACANJUBA ZERO LACTOSE 1L', 0.00, 8.00, '7898215157830', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2922, 'LEITE NESTLE NINHO 1L', 0.00, 9.00, '7898215157403', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2923, 'CAFE CABOCLO 500G', 0.00, 20.00, '7896089011227', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2924, 'COCA COLA PET  SEM AÃ§UCAR 200ML', 0.00, 3.00, '78933873', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2925, 'MARLBORO RED', 0.00, 10.00, '78940871', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2926, 'LEITE CONDESADA MEU BOM 395G', 0.00, 6.50, '7898215157670', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2927, 'BARRA DE CHOCOLATE HERSHEYÂ´S 77G', 0.00, 8.00, '7899970402876', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2928, 'DIPLOKO BOOOM LIKE UVA 11G', 0.00, 3.00, '7898934595500', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2929, 'ISQUEIRO MINI BIC', 0.00, 5.00, '070330638341', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2930, 'PAÃ§OCA CASEIRA 60G', 0.00, 2.00, '7898364280281', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2931, 'KITUBAINA 2L', 0.00, 8.00, '7897417402694', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2932, 'NUTRI NECTA LARANJA 200ML', 0.00, 2.50, '7898961490519', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2933, 'ESPAGUET LIANE 500 G', 0.00, 5.00, '7896080820255', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2934, 'KETCHUP PREDILECTA 400G', 0.00, 6.50, '7896292300460', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2935, 'BISCOITO DE SAL MABEL 300G', 0.00, 6.00, '7896071030069', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2936, 'PASTA DE DENTE COLGATE 90G', 0.00, 5.50, '7891024134702', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2937, 'PASTA DE DENTE SORRISO 90G', 0.00, 4.50, '7891528030142', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2938, 'BISCOITO OREO 90G', 0.00, 4.50, '7622300830151', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2939, 'ACHOCOLATADO NESCAU 350G', 0.00, 12.50, '7891000412855', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2940, 'SAL DUNAS 1KG', 0.00, 3.00, '7897167100062', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2941, 'BIS XTRA OREO 45G', 0.00, 4.00, '7622300988517', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2942, 'PRESTIGIO BRANCO 33G', 0.00, 3.50, '7891000251133', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2943, 'KITKAT BRANCO', 0.00, 4.00, '7891000249239', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2944, 'COPO DESCARTAVEL 300ML', 0.00, 9.90, '7896322701502', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2945, 'IOGURTE COCO GOIANINHO 1250G', 0.00, 12.99, '7898644341428', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2946, 'BISCOITO RANCHEIRO CHOCOLATE 78G', 0.00, 2.50, '7896253401564', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2947, 'MARLBORO GOLD', 0.00, 9.00, '78941618', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2948, 'GOIANINHO  DE COCO 140G', 0.00, 2.80, '7898644341398', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2949, 'COOKIES NESTLE DE CHOCOLATE 60G', 0.00, 3.00, '7891000247648', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2950, 'FANTA LARAN. SEM AÃ§UCAR 310ML', 0.00, 4.00, '7894900151152', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2951, 'CASADINHO 50G', 0.00, 3.00, '7898537841240', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2952, 'VELA DE INTERROGAÃ§Ã£O AZUL', 0.00, 5.00, '7899044202098', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2953, 'LUCKY STRIKE', 0.00, 15.00, '78944343', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2954, 'BELAGURT AÃ‡AI E BANANA 140G', 0.00, 2.49, '7898644342494', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2955, 'BELAGURT MAMAO,MAÃ‡A E BANANA 140G', 0.00, 2.49, '7898644341954', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2956, 'DUNHILL ON BLUE', 0.00, 12.00, '78942929', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2957, 'RED BULL TRADICIONAL 250ML', 0.00, 10.00, '611269991000', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2958, 'RED BULL SEM AÃ§UCAR 250ML', 0.00, 10.00, '611269101713', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2959, 'SAB. PALMOLIVE FRAMBOESA', 0.00, 3.50, '7891024034828', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2960, 'SAB. PALMOLIVE LEITE E PETALAS', 0.00, 3.50, '7891024034804', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2961, 'SAB. PALMOLIVE KARITE', 0.00, 3.50, '7891024034781', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2962, 'SODA LIMONADA 350ML', 0.00, 4.00, '7891991000833', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2963, 'PAPEL TOALHA SOCIAL', 0.00, 6.00, '7896914000716', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2964, 'PINGO BEL 50G', 0.00, 3.00, '7898947980768', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2965, 'GOIANINHO BANDEIJA 320G', 0.00, 8.00, '7898644341800', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2966, 'MENTOS IORGUT MORANGO', 0.00, 3.50, '7895144603087', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2967, 'FANTA CAJU 310ML', 0.00, 4.00, '7894900096521', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2968, 'DIPLOKO FRAMBOESA 11G', 0.00, 3.00, '7898934595548', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2969, 'DIPLOKO AMORA 11G', 0.00, 3.00, '7898934595524', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2970, 'CAFE SANTA CLARA 250G', 0.00, 22.00, '7896045110131', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2971, 'CAFE BICO DE OURO 500G', 0.00, 32.00, '7896550400062', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2972, 'SARDINHA GOMES DA C. AO MOLHO', 0.00, 7.99, '7891167021020', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2973, 'DOCE DE AMENDOIM 30G', 0.00, 1.50, '7897115107501', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2974, 'MOLHO DE TOMATE ACHEI', 0.00, 2.50, '630941717455', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2975, 'DOCE ENCANTO 25G', 0.00, 3.50, '379840876718', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2976, 'COCA COLA 1L', 0.00, 8.50, '7894900011715', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2977, 'DEL VALLE FRUT 1,5', 0.00, 10.00, '7894900550061', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2978, 'PIPOCA DOCE GULOZINHA 100G', 0.00, 2.50, '7896565000769', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2979, 'PIPOCA DOCE GULOZINHA 40G', 0.00, 1.50, '7896565000103', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2980, 'GOIABADA AMORE 300G', 0.00, 3.50, '7897977903716', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2981, 'AGUA LA PRIORI 500ML', 0.00, 2.50, '7898121460284', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2982, 'FREEGELLS VIT. MEL E LIMÃ£O', 0.00, 2.50, '7891151039895', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2983, 'ZOLLÃ© STICK FRAMBOESA', 0.00, 1.50, '7896321017963', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2984, 'GELÃ©IA MOCOTÃ³', 0.00, 2.00, '7898364281752', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2985, 'ZOLLÃ© STICK MAÃ§Ã£ VERDE', 0.00, 1.50, '7896321017970', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2986, 'MINIT STICK HORTELÃ£', 0.00, 1.50, '7896321026842', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2987, 'DOCE DE LEITE 60G', 0.00, 2.00, '7898364280922', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2988, 'TAMPICO UVA 1 LITRO', 0.00, 7.50, '095188878695', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2989, 'CHOCO TRIO', 0.00, 8.00, '7891000377598', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2990, 'LACTA  BRANCO 20G', 0.00, 3.00, '7622300862442', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2991, 'LACTA 20G', 0.00, 3.50, '7622300862367', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2992, 'NUTRY CEREAL AVELÃ£ 22G', 0.00, 3.50, '7891331010485', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2993, 'NESTLE CLASSIC DIPLOMATA', 0.00, 8.00, '7891000368893', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2994, 'DIPLOKO SALADA DE FRUTAS', 0.00, 3.00, '7898934595562', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2995, 'DIPLOKO LIMÃ£O', 0.00, 3.00, '7898970162018', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34');
INSERT INTO `tb1_produto` (`tb1_id`, `tb1_nome`, `tb1_vlr_custo`, `tb1_vlr_venda`, `tb1_codbar`, `tb1_tipo`, `tb1_status`, `tb1_favorito`, `tb1_vr_credit`, `created_at`, `updated_at`) VALUES
(2996, 'DIPLOKO LICHIA', 0.00, 3.00, '7898970162032', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2997, 'DIPLOKO FRUTAS VERMELHAS', 0.00, 3.00, '7898934596248', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2998, 'INTIMUS NOTURNO C/ ABAS 8 UN', 0.00, 9.50, '7896007542437', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34'),
(2999, 'JUJUBA CREME E FRUTAS', 0.00, 1.50, '7896058507423', 0, 1, 0, 0, '2025-12-21 13:39:21', '2025-12-25 11:11:34');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb2_unidades`
--

CREATE TABLE `tb2_unidades` (
  `tb2_id` bigint(20) UNSIGNED NOT NULL,
  `tb2_nome` varchar(255) NOT NULL,
  `tb2_endereco` varchar(255) NOT NULL,
  `tb2_cep` varchar(20) NOT NULL,
  `tb2_fone` varchar(20) NOT NULL,
  `tb2_cnpj` varchar(20) NOT NULL,
  `tb2_localizacao` varchar(512) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `tb2_unidades`
--

INSERT INTO `tb2_unidades` (`tb2_id`, `tb2_nome`, `tb2_endereco`, `tb2_cep`, `tb2_fone`, `tb2_cnpj`, `tb2_localizacao`, `created_at`, `updated_at`) VALUES
(1, 'SETOR 10', 'Area Av-3 Lt, 3/4, Lote 02', '72925-170', '(61) 9 8452-4923', '50.359.790/0001-74', 'https://maps.app.goo.gl/RamuBRPegsbk7NZZA', '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(2, 'SETOR 1', 'Area Av-3 Lt, 3/4, Lote 02', '72925-000', '(61) 9 8452-4923', '50.359.790/0001-74', 'https://maps.app.goo.gl/98f3uSdHqm7d5Xcm9', '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(3, 'BARRAGEM 1', 'Area Av-3 Lt, 3/4, Lote 02', '72925-000', '(61) 9 8452-4923', '50.359.790/0001-74', 'https://maps.app.goo.gl/ZeCTtye7KcYZ56E88', '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(4, 'TESTE', 'Teste', '8840072', '+351 913 007 661', '87083980172', 'https://clerio.com.br', '2025-12-22 05:08:29', '2025-12-28 23:03:45');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb2_unidade_user`
--

CREATE TABLE `tb2_unidade_user` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `tb2_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `tb2_unidade_user`
--

INSERT INTO `tb2_unidade_user` (`id`, `user_id`, `tb2_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(2, 2, 1, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(3, 3, 1, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(4, 1, 2, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(5, 1, 3, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(6, 2, 2, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(7, 2, 3, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(8, 3, 2, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(9, 3, 3, '2025-12-25 11:11:34', '2025-12-25 11:11:34'),
(10, 1, 4, '2025-12-22 05:12:28', '2025-12-22 05:12:28');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb3_vendas`
--

CREATE TABLE `tb3_vendas` (
  `tb3_id` bigint(20) UNSIGNED NOT NULL,
  `tb4_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tb1_id` bigint(20) UNSIGNED NOT NULL,
  `id_comanda` int(10) UNSIGNED DEFAULT NULL,
  `produto_nome` varchar(120) NOT NULL,
  `valor_unitario` decimal(10,2) NOT NULL,
  `quantidade` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `valor_total` decimal(12,2) NOT NULL,
  `data_hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_user_caixa` bigint(20) UNSIGNED DEFAULT NULL,
  `id_user_vale` bigint(20) UNSIGNED DEFAULT NULL,
  `id_lanc` bigint(20) UNSIGNED DEFAULT NULL,
  `id_unidade` bigint(20) UNSIGNED NOT NULL,
  `tipo_pago` enum('maquina','dinheiro','vale','refeicao','faturar') NOT NULL,
  `status_pago` tinyint(1) NOT NULL DEFAULT 1,
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `tb3_vendas`
--

INSERT INTO `tb3_vendas` (`tb3_id`, `tb4_id`, `tb1_id`, `id_comanda`, `produto_nome`, `valor_unitario`, `quantidade`, `valor_total`, `data_hora`, `id_user_caixa`, `id_user_vale`, `id_lanc`, `id_unidade`, `tipo_pago`, `status_pago`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 2284, NULL, 'BALINHA', 0.15, 1, 0.15, '2025-12-21 13:43:40', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-21 13:43:40', '2025-12-21 13:43:40'),
(2, 2, 2284, NULL, 'BALINHA', 0.15, 1, 0.15, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(3, 2, 2285, NULL, 'CHICLETE', 0.25, 1, 0.25, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(4, 2, 2289, NULL, 'CIGARRO B', 0.50, 1, 0.50, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(5, 2, 2288, NULL, 'CIGARRO C', 1.50, 1, 1.50, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(6, 2, 2290, NULL, 'DOCE', 2.00, 1, 2.00, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(7, 2, 2232, NULL, 'ISQUEIRO BIC', 7.00, 1, 7.00, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(8, 2, 2230, NULL, 'ISQUEIRO BIC PEQUENO', 5.00, 1, 5.00, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(9, 2, 2906, NULL, 'PIRULITO $0.25', 0.25, 1, 0.25, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(10, 2, 2287, NULL, 'PIRULITO B', 0.50, 1, 0.50, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(11, 2, 2286, NULL, 'PIRULITO C', 1.00, 1, 1.00, '2025-12-21 13:43:59', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(12, 3, 25, NULL, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-21 13:44:53', 1, 1, NULL, 1, 'vale', 0, 1, '2025-12-21 13:44:53', '2025-12-21 13:44:53'),
(13, 3, 250, NULL, 'ROSCA RAINHA G', 26.00, 3, 78.00, '2025-12-21 13:44:53', 1, 1, NULL, 1, 'vale', 0, 1, '2025-12-21 13:44:53', '2025-12-21 13:44:53'),
(14, 4, 25, NULL, 'HAMBURGÃ£O', 6.00, 15, 90.00, '2025-12-21 13:48:23', 1, 2, NULL, 1, 'refeicao', 0, 1, '2025-12-21 13:48:23', '2025-12-21 13:48:23'),
(15, 5, 270, NULL, 'KIT FESTA 45', 439.99, 115, 50598.85, '2025-12-21 14:01:19', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-21 14:01:19', '2025-12-21 14:01:19'),
(16, 6, 270, NULL, 'KIT FESTA 45', 439.99, 36, 15839.64, '2025-12-21 14:01:42', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 14:01:42', '2025-12-21 14:01:42'),
(17, 7, 12, 3000, 'PAO C/ MANTEIGA', 3.00, 1, 3.00, '2025-12-21 16:39:38', 1, NULL, 1, 2, 'dinheiro', 1, 1, '2025-12-21 16:39:14', '2025-12-21 16:39:38'),
(18, 7, 15, 3000, 'MISTO COMPLETO', 8.50, 1, 8.50, '2025-12-21 16:39:38', 1, NULL, 1, 2, 'dinheiro', 1, 1, '2025-12-21 16:39:16', '2025-12-21 16:39:38'),
(19, 7, 4, 3000, 'CAFEZINHO', 2.00, 1, 2.00, '2025-12-21 16:39:38', 1, NULL, 1, 2, 'dinheiro', 1, 1, '2025-12-21 16:39:17', '2025-12-21 16:39:38'),
(20, 7, 33, 3000, 'PUDIM GRANDE', 25.00, 1, 25.00, '2025-12-21 16:39:38', 1, NULL, 1, 2, 'dinheiro', 1, 1, '2025-12-21 16:39:21', '2025-12-21 16:39:38'),
(21, 8, 25, 3001, 'HAMBURGÃ£O', 6.00, 2, 12.00, '2025-12-21 16:47:28', 1, NULL, 1, 2, 'maquina', 1, 1, '2025-12-21 16:46:03', '2025-12-21 16:47:28'),
(22, 8, 2775, 3001, 'SUCO ALEGRIA SABOR LARANJA 2L', 9.00, 1, 9.00, '2025-12-21 16:47:28', 1, NULL, 1, 2, 'maquina', 1, 1, '2025-12-21 16:46:11', '2025-12-21 16:47:28'),
(23, 9, 13, 3002, 'PAO COM OVO', 4.50, 1, 4.50, '2025-12-21 16:50:00', 1, 2, 1, 2, 'refeicao', 0, 1, '2025-12-21 16:46:47', '2025-12-21 16:50:00'),
(24, 9, 4, 3002, 'CAFEZINHO', 2.00, 1, 2.00, '2025-12-21 16:50:00', 1, 2, 1, 2, 'refeicao', 0, 1, '2025-12-21 16:46:49', '2025-12-21 16:50:00'),
(25, 9, 35, 3002, 'SONHO OU ROSCA DE CREME', 2.50, 1, 2.50, '2025-12-21 16:50:00', 1, 2, 1, 2, 'refeicao', 0, 1, '2025-12-21 16:46:59', '2025-12-21 16:50:00'),
(26, 12, 25, 3009, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-22 00:21:34', 1, NULL, 1, 1, 'maquina', 1, 1, '2025-12-21 22:40:08', '2025-12-22 00:21:34'),
(27, 12, 26, 3009, 'SALGADO ASSADO', 5.00, 1, 5.00, '2025-12-22 00:21:34', 1, NULL, 1, 1, 'maquina', 1, 1, '2025-12-21 22:40:10', '2025-12-22 00:21:34'),
(28, 12, 2775, 3009, 'SUCO ALEGRIA SABOR LARANJA 2L', 9.00, 1, 9.00, '2025-12-22 00:21:34', 1, NULL, 1, 1, 'maquina', 1, 1, '2025-12-21 22:40:13', '2025-12-22 00:21:34'),
(29, 10, 1, NULL, 'PAO DE SAL', 0.70, 11, 7.70, '2025-12-21 22:40:28', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-21 22:40:28', '2025-12-21 22:40:28'),
(30, 11, 69, NULL, 'ROSQUINHA DE CANELA', 2.00, 3, 6.00, '2025-12-21 22:40:52', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-21 22:40:52', '2025-12-21 22:40:52'),
(31, 11, 2659, NULL, 'COCA COLA SEM AÃ§UCAR 220ML', 3.50, 1, 3.50, '2025-12-21 22:40:52', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-21 22:40:52', '2025-12-21 22:40:52'),
(32, 13, 1, NULL, 'PAO DE SAL', 0.70, 1, 0.70, '2025-12-22 05:12:51', 1, NULL, NULL, 4, 'maquina', 1, 1, '2025-12-22 05:12:51', '2025-12-22 05:12:51'),
(33, 14, 15, NULL, 'MISTO COMPLETO', 8.50, 2, 17.00, '2025-12-23 07:37:43', 1, NULL, NULL, 2, 'faturar', 0, 1, '2025-12-23 07:37:43', '2025-12-23 07:37:43'),
(34, 15, 15, NULL, 'MISTO COMPLETO', 8.50, 1, 8.50, '2025-12-23 07:41:20', 1, NULL, NULL, 2, 'maquina', 1, 1, '2025-12-23 07:41:20', '2025-12-23 07:41:20'),
(35, 15, 16, NULL, 'PAO COM QUEIJO', 5.00, 1, 5.00, '2025-12-23 07:41:20', 1, NULL, NULL, 2, 'maquina', 1, 1, '2025-12-23 07:41:20', '2025-12-23 07:41:20'),
(36, 16, 10, NULL, 'NESCAU P', 4.00, 1, 4.00, '2025-12-23 07:42:11', 1, 1, NULL, 2, 'refeicao', 0, 1, '2025-12-23 07:42:11', '2025-12-23 07:42:11'),
(37, 17, 25, NULL, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-23 07:42:29', 1, 2, NULL, 2, 'vale', 0, 1, '2025-12-23 07:42:29', '2025-12-23 07:42:29'),
(38, 17, 2775, NULL, 'SUCO ALEGRIA SABOR LARANJA 2L', 9.00, 1, 9.00, '2025-12-23 07:42:29', 1, 2, NULL, 2, 'vale', 0, 1, '2025-12-23 07:42:29', '2025-12-23 07:42:29'),
(39, 18, 18, NULL, 'TAPIOCA C/ QUEIJO', 5.00, 1, 5.00, '2025-12-23 07:42:43', 1, 3, NULL, 2, 'refeicao', 0, 1, '2025-12-23 07:42:43', '2025-12-23 07:42:43'),
(40, 19, 1, NULL, 'PAO DE SAL', 0.70, 11, 7.70, '2025-12-23 07:43:37', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 07:43:37', '2025-12-23 07:43:37'),
(41, 19, 174, NULL, 'ENROLADINHO DE PRESUNTO E QUEIJO', 40.00, 1, 40.00, '2025-12-23 07:43:37', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 07:43:37', '2025-12-23 07:43:37'),
(42, 20, 1, NULL, 'PAO DE SAL', 0.70, 35, 24.50, '2025-12-23 07:45:03', 1, 3, NULL, 2, 'vale', 0, 1, '2025-12-23 07:45:03', '2025-12-23 07:45:03'),
(43, 21, 15, 3100, 'MISTO COMPLETO', 8.50, 1, 8.50, '2025-12-23 07:47:31', 1, 1, 1, 2, 'refeicao', 0, 1, '2025-12-23 07:47:10', '2025-12-23 07:47:31'),
(44, 21, 22, 3100, 'CACHORRO QUENTE', 6.00, 1, 6.00, '2025-12-23 07:47:31', 1, 1, 1, 2, 'refeicao', 0, 1, '2025-12-23 07:47:14', '2025-12-23 07:47:31'),
(45, 21, 27, 3100, 'BROA', 2.50, 1, 2.50, '2025-12-23 07:47:31', 1, 1, 1, 2, 'refeicao', 0, 1, '2025-12-23 07:47:16', '2025-12-23 07:47:31'),
(46, 22, 18, 3009, 'TAPIOCA C/ QUEIJO', 5.00, 1, 5.00, '2025-12-23 07:48:29', 1, NULL, 1, 2, 'dinheiro', 1, 1, '2025-12-23 07:48:12', '2025-12-23 07:48:29'),
(47, 22, 27, 3009, 'BROA', 2.50, 1, 2.50, '2025-12-23 07:48:29', 1, NULL, 1, 2, 'dinheiro', 1, 1, '2025-12-23 07:48:13', '2025-12-23 07:48:29'),
(48, 23, 15, NULL, 'MISTO COMPLETO', 8.50, 2, 17.00, '2025-12-23 08:28:56', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 08:28:56', '2025-12-23 08:28:56'),
(49, 24, 59, NULL, 'BRIGADEIRAO', 3.00, 5, 15.00, '2025-12-23 08:51:37', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 08:51:37', '2025-12-23 08:51:37'),
(50, 25, 28, NULL, 'QUEBRADOR', 2.50, 1, 2.50, '2025-12-23 08:55:51', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 08:55:51', '2025-12-23 08:55:51'),
(51, 25, 36, NULL, 'PAO DE DOCE', 1.00, 1, 1.00, '2025-12-23 08:55:51', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 08:55:51', '2025-12-23 08:55:51'),
(52, 26, 26, NULL, 'SALGADO ASSADO', 5.00, 1, 5.00, '2025-12-23 09:02:03', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 09:02:03', '2025-12-23 09:02:03'),
(53, 26, 300, NULL, 'CHUPETITA', 1.50, 1, 1.50, '2025-12-23 09:02:03', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 09:02:03', '2025-12-23 09:02:03'),
(54, 26, 2031, NULL, 'COCA COLA 220ML', 3.50, 1, 3.50, '2025-12-23 09:02:03', 1, NULL, NULL, 2, 'dinheiro', 1, 1, '2025-12-23 09:02:03', '2025-12-23 09:02:03'),
(55, 27, 25, 3020, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-23 09:46:30', 1, NULL, 1, 3, 'maquina', 1, 1, '2025-12-23 09:46:11', '2025-12-23 09:46:30'),
(56, 27, 36, 3020, 'PAO DE DOCE', 1.00, 1, 1.00, '2025-12-23 09:46:30', 1, NULL, 1, 3, 'maquina', 1, 1, '2025-12-23 09:46:12', '2025-12-23 09:46:30'),
(57, 27, 64, 3020, 'BOLO PRESTIGIO', 5.00, 2, 10.00, '2025-12-23 09:46:30', 1, NULL, 1, 3, 'maquina', 1, 1, '2025-12-23 09:46:14', '2025-12-23 09:46:30'),
(58, 27, 99, 3020, 'BOLO DE FRUTAS', 14.00, 1, 14.00, '2025-12-23 09:46:30', 1, NULL, 1, 3, 'maquina', 1, 1, '2025-12-23 09:46:16', '2025-12-23 09:46:30'),
(59, 28, 10, NULL, 'NESCAU P', 4.00, 2, 8.00, '2025-12-23 09:56:50', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-23 09:56:50', '2025-12-23 09:56:50'),
(60, 28, 25, NULL, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-23 09:56:50', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-23 09:56:50', '2025-12-23 09:56:50'),
(61, 28, 252, NULL, 'PAO DE LEITE C/ CREME', 22.00, 1, 22.00, '2025-12-23 09:56:50', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-23 09:56:50', '2025-12-23 09:56:50'),
(62, 29, 25, NULL, 'HAMBURGÃ£O', 6.00, 2, 12.00, '2025-12-23 10:02:58', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-23 10:02:58', '2025-12-23 10:02:58'),
(63, 29, 99, NULL, 'BOLO DE FRUTAS', 14.00, 2, 28.00, '2025-12-23 10:02:58', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-23 10:02:58', '2025-12-23 10:02:58'),
(64, 30, 25, 3008, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-23 10:12:03', 1, NULL, 1, 1, 'maquina', 1, 1, '2025-12-23 10:10:56', '2025-12-23 10:12:03'),
(65, 30, 35, 3008, 'SONHO OU ROSCA DE CREME', 2.50, 1, 2.50, '2025-12-23 10:12:03', 1, NULL, 1, 1, 'maquina', 1, 1, '2025-12-23 10:10:59', '2025-12-23 10:12:03'),
(66, 31, 2287, NULL, 'PIRULITO B', 0.50, 1, 0.50, '2025-12-23 10:42:11', 1, NULL, NULL, 3, 'maquina', 1, 1, '2025-12-23 10:42:11', '2025-12-23 10:42:11'),
(67, 32, 1, NULL, 'PAO DE SAL', 0.70, 10, 7.00, '2025-12-23 10:45:59', 3, NULL, NULL, 2, 'maquina', 1, 1, '2025-12-23 10:45:59', '2025-12-23 10:45:59'),
(68, 33, 269, NULL, 'KIT FESTA 30', 289.99, 7, 2029.93, '2025-12-23 12:34:52', 1, NULL, NULL, 3, 'dinheiro', 1, 1, '2025-12-23 12:34:52', '2025-12-23 12:34:52'),
(69, 34, 270, NULL, 'KIT FESTA 45', 439.99, 3, 1319.97, '2025-12-23 12:35:10', 1, NULL, NULL, 3, 'maquina', 1, 1, '2025-12-23 12:35:10', '2025-12-23 12:35:10'),
(70, 35, 1, NULL, 'PAO DE SAL', 0.70, 1, 0.70, '2025-12-23 16:30:47', 1, NULL, NULL, 4, 'dinheiro', 1, 1, '2025-12-23 16:30:47', '2025-12-23 16:30:47'),
(71, 36, 25, 3006, 'HAMBURGÃ£O', 6.00, 1, 6.00, '2025-12-23 16:32:34', 1, 1, 1, 4, 'vale', 0, 1, '2025-12-23 16:31:38', '2025-12-23 16:32:34'),
(72, 36, 2806, 3006, 'SUCO ALEGRIA SABOR LARANJA 320ML', 3.00, 1, 3.00, '2025-12-23 16:32:34', 1, 1, 1, 4, 'vale', 0, 1, '2025-12-23 16:31:47', '2025-12-23 16:32:34'),
(73, 37, 29, 3088, 'PAMONHA', 8.00, 1, 8.00, '2025-12-23 19:18:55', 1, NULL, 1, 4, 'faturar', 0, 1, '2025-12-23 16:31:59', '2025-12-23 19:18:55'),
(74, 37, 98, 3088, 'BOLO PUDIM', 15.00, 1, 15.00, '2025-12-23 19:18:55', 1, NULL, 1, 4, 'faturar', 0, 1, '2025-12-23 16:32:01', '2025-12-23 19:18:55'),
(75, 38, 29, 3099, 'PAMONHA', 8.00, 1, 8.00, '2025-12-24 13:46:08', 1, NULL, 1, 4, 'faturar', 0, 1, '2025-12-23 16:33:41', '2025-12-24 13:46:08'),
(76, 38, 32, 3099, 'PUDIM', 6.00, 1, 6.00, '2025-12-24 13:46:08', 1, NULL, 1, 4, 'faturar', 0, 1, '2025-12-23 16:33:42', '2025-12-24 13:46:08'),
(77, 38, 18, 3099, 'TAPIOCA C/ QUEIJO', 5.00, 1, 5.00, '2025-12-24 13:46:08', 1, NULL, 1, 4, 'faturar', 0, 1, '2025-12-23 16:33:44', '2025-12-24 13:46:08'),
(78, 38, 1385, 3099, 'PICOLE GAROTO CARIBE', 9.90, 1, 9.90, '2025-12-24 13:46:08', 1, NULL, 1, 4, 'faturar', 0, 1, '2025-12-23 16:33:47', '2025-12-24 13:46:08'),
(79, 43, 15, 3030, 'MISTO COMPLETO', 8.50, 1, 8.50, '2025-12-27 10:14:44', 1, NULL, 3, 2, 'faturar', 0, 1, '2025-12-23 16:51:02', '2025-12-27 10:14:44'),
(80, 43, 2976, 3030, 'COCA COLA 1L', 8.50, 1, 8.50, '2025-12-27 10:14:44', 1, NULL, 3, 2, 'faturar', 0, 1, '2025-12-23 16:51:10', '2025-12-27 10:14:44'),
(81, 39, 12, NULL, 'PAO C/ MANTEIGA', 3.00, 5, 15.00, '2025-12-24 19:07:38', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-24 19:07:38', '2025-12-24 19:07:38'),
(82, 39, 23, NULL, 'TORTA DE FRANGO', 8.00, 1, 8.00, '2025-12-24 19:07:38', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-24 19:07:38', '2025-12-24 19:07:38'),
(83, 39, 125, NULL, 'BANDEIJA DE BRIGADEIRO', 30.00, 1, 30.00, '2025-12-24 19:07:38', 1, NULL, NULL, 1, 'maquina', 1, 1, '2025-12-24 19:07:38', '2025-12-24 19:07:38'),
(84, 40, 269, NULL, 'KIT FESTA 30', 289.99, 1, 289.99, '2025-12-24 19:07:50', 1, NULL, NULL, 1, 'dinheiro', 1, 1, '2025-12-24 19:07:50', '2025-12-24 19:07:50'),
(85, 41, 1, NULL, 'PAO DE SAL', 0.70, 1, 0.70, '2025-12-24 19:09:04', 1, NULL, NULL, 3, 'maquina', 1, 1, '2025-12-24 19:09:04', '2025-12-24 19:09:04'),
(86, 42, 1, NULL, 'PAO DE SAL', 0.70, 1, 0.70, '2025-12-24 19:09:10', 1, NULL, NULL, 3, 'dinheiro', 1, 1, '2025-12-24 19:09:10', '2025-12-24 19:09:10');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb4_vendas_pg`
--

CREATE TABLE `tb4_vendas_pg` (
  `tb4_id` bigint(20) UNSIGNED NOT NULL,
  `valor_total` decimal(12,2) NOT NULL,
  `tipo_pagamento` varchar(20) NOT NULL,
  `valor_pago` decimal(12,2) DEFAULT NULL,
  `troco` decimal(12,2) NOT NULL DEFAULT 0.00,
  `dois_pgto` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `tb4_vendas_pg`
--

INSERT INTO `tb4_vendas_pg` (`tb4_id`, `valor_total`, `tipo_pagamento`, `valor_pago`, `troco`, `dois_pgto`, `created_at`, `updated_at`) VALUES
(1, 0.15, 'maquina', NULL, 0.00, 0.00, '2025-12-21 13:43:40', '2025-12-21 13:43:40'),
(2, 18.15, 'dinheiro', 20.00, 1.85, 0.00, '2025-12-21 13:43:59', '2025-12-21 13:43:59'),
(3, 84.00, 'vale', NULL, 0.00, 0.00, '2025-12-21 13:44:53', '2025-12-21 13:44:53'),
(4, 90.00, 'refeicao', NULL, 0.00, 0.00, '2025-12-21 13:48:23', '2025-12-21 13:48:23'),
(5, 50598.85, 'maquina', NULL, 0.00, 0.00, '2025-12-21 14:01:19', '2025-12-21 14:01:19'),
(6, 15839.64, 'dinheiro', 15900.00, 60.36, 0.00, '2025-12-21 14:01:42', '2025-12-21 14:01:42'),
(7, 38.50, 'dinheiro', 40.00, 1.50, 0.00, '2025-12-21 16:39:38', '2025-12-21 16:39:38'),
(8, 21.00, 'maquina', NULL, 0.00, 0.00, '2025-12-21 16:47:28', '2025-12-21 16:47:28'),
(9, 9.00, 'refeicao', NULL, 0.00, 0.00, '2025-12-21 16:50:00', '2025-12-21 16:50:00'),
(10, 7.70, 'dinheiro', 10.00, 2.30, 0.00, '2025-12-21 22:40:28', '2025-12-21 22:40:28'),
(11, 9.50, 'maquina', NULL, 0.00, 0.00, '2025-12-21 22:40:52', '2025-12-21 22:40:52'),
(12, 20.00, 'maquina', NULL, 0.00, 0.00, '2025-12-22 00:21:34', '2025-12-22 00:21:34'),
(13, 0.70, 'maquina', NULL, 0.00, 0.00, '2025-12-22 05:12:51', '2025-12-22 05:12:51'),
(14, 17.00, 'faturar', NULL, 0.00, 0.00, '2025-12-23 07:37:43', '2025-12-23 07:37:43'),
(15, 13.50, 'maquina', NULL, 0.00, 0.00, '2025-12-23 07:41:20', '2025-12-23 07:41:20'),
(16, 4.00, 'refeicao', NULL, 0.00, 0.00, '2025-12-23 07:42:11', '2025-12-23 07:42:11'),
(17, 15.00, 'vale', NULL, 0.00, 0.00, '2025-12-23 07:42:29', '2025-12-23 07:42:29'),
(18, 5.00, 'refeicao', NULL, 0.00, 0.00, '2025-12-23 07:42:43', '2025-12-23 07:42:43'),
(19, 47.70, 'dinheiro', 50.00, 2.30, 0.00, '2025-12-23 07:43:37', '2025-12-23 07:43:37'),
(20, 24.50, 'vale', NULL, 0.00, 0.00, '2025-12-23 07:45:03', '2025-12-23 07:45:03'),
(21, 17.00, 'refeicao', NULL, 0.00, 0.00, '2025-12-23 07:47:31', '2025-12-23 07:47:31'),
(22, 7.50, 'dinheiro', 10.00, 2.50, 0.00, '2025-12-23 07:48:29', '2025-12-23 07:48:29'),
(23, 17.00, 'dinheiro', 50.00, 33.00, 0.00, '2025-12-23 08:28:56', '2025-12-23 08:28:56'),
(24, 15.00, 'dinheiro', 20.00, 5.00, 0.00, '2025-12-23 08:51:37', '2025-12-23 08:51:37'),
(25, 3.50, 'dinheiro', 5.00, 1.50, 0.00, '2025-12-23 08:55:51', '2025-12-23 08:55:51'),
(26, 10.00, 'dinheiro', 10.00, 0.00, 0.00, '2025-12-23 09:02:03', '2025-12-23 09:02:03'),
(27, 31.00, 'maquina', NULL, 0.00, 0.00, '2025-12-23 09:46:30', '2025-12-23 09:46:30'),
(28, 36.00, 'maquina', NULL, 0.00, 0.00, '2025-12-23 09:56:50', '2025-12-23 09:56:50'),
(29, 40.00, 'dinheiro', 50.00, 10.00, 0.00, '2025-12-23 10:02:58', '2025-12-23 10:02:58'),
(30, 8.50, 'maquina', NULL, 0.00, 0.00, '2025-12-23 10:12:03', '2025-12-23 10:12:03'),
(31, 0.50, 'maquina', NULL, 0.00, 0.00, '2025-12-23 10:42:11', '2025-12-23 10:42:11'),
(32, 7.00, 'maquina', NULL, 0.00, 0.00, '2025-12-23 10:45:59', '2025-12-23 10:45:59'),
(33, 2029.93, 'dinheiro', 2100.00, 70.07, 0.00, '2025-12-23 12:34:52', '2025-12-23 12:34:52'),
(34, 1319.97, 'maquina', NULL, 0.00, 0.00, '2025-12-23 12:35:10', '2025-12-23 12:35:10'),
(35, 0.70, 'dinheiro', 0.50, 0.00, 0.20, '2025-12-23 16:30:47', '2025-12-23 16:30:47'),
(36, 9.00, 'vale', NULL, 0.00, 0.00, '2025-12-23 16:32:34', '2025-12-23 16:32:34'),
(37, 23.00, 'faturar', NULL, 0.00, 0.00, '2025-12-23 19:18:55', '2025-12-23 19:18:55'),
(38, 28.90, 'faturar', NULL, 0.00, 0.00, '2025-12-24 13:46:08', '2025-12-24 13:46:08'),
(39, 53.00, 'maquina', NULL, 0.00, 0.00, '2025-12-24 19:07:38', '2025-12-24 19:07:38'),
(40, 289.99, 'dinheiro', 290.00, 0.01, 0.00, '2025-12-24 19:07:50', '2025-12-24 19:07:50'),
(41, 0.70, 'maquina', NULL, 0.00, 0.00, '2025-12-24 19:09:04', '2025-12-24 19:09:04'),
(42, 0.70, 'dinheiro', 1.00, 0.30, 0.00, '2025-12-24 19:09:10', '2025-12-24 19:09:10'),
(43, 17.00, 'faturar', NULL, 0.00, 0.00, '2025-12-27 10:14:44', '2025-12-27 10:14:44');

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `funcao` tinyint(3) UNSIGNED NOT NULL DEFAULT 5,
  `funcao_original` tinyint(4) DEFAULT NULL,
  `hr_ini` time DEFAULT NULL,
  `hr_fim` time DEFAULT NULL,
  `salario` decimal(10,2) NOT NULL DEFAULT 1518.00,
  `vr_cred` decimal(10,2) NOT NULL DEFAULT 350.00,
  `tb2_id` bigint(20) UNSIGNED NOT NULL DEFAULT 1,
  `cod_acesso` varchar(10) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `funcao`, `funcao_original`, `hr_ini`, `hr_fim`, `salario`, `vr_cred`, `tb2_id`, `cod_acesso`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Clerio', 'cleriodias@gmail.com', NULL, '$2y$12$w0PlFqG0LEA.GJAaKwW5s.aonMUSCZn2.IjPUo0hcOU1qqMbU0tR.', 0, 0, '00:00:00', '23:00:00', 1518.00, 350.00, 1, '0800', 'o0pVjB5CvRdyNumcqxs36Z9jYl4EhdPV5FQjbUzI9HjQdgL6i4qgKjwxkA02', '2025-12-21 10:51:09', '2025-12-28 23:02:53'),
(2, 'Rodrigo', 'trucadoturbinado@gmail.com', NULL, '$2y$12$jcL3CXZ7DyIQ2sjEApG4G.vaYRFpzv2EgoWwmsG0K.8On76DUmGgq', 0, 0, '00:00:00', '23:00:00', 1518.00, 350.00, 1, '0258', 'WneO5QTbIu4Xz3XhzRZyvqacwjsFRZ4NbP0f9aMXFf3GJIiZVjPKbzPwSI4K', '2025-12-21 10:51:09', '2025-12-25 11:11:34'),
(3, 'Selma', 'paoecaf83@gmail.com', '0000-00-00 00:00:00', '$2y$12$B7J97InT5hEaCIQZy5rZre/rZ0OPKVK.QekCLDtVcsFBocx5Sxy.a', 1, 1, '00:00:00', '23:00:00', 1518.00, 350.00, 1, '8520', 'I3bjl99yN7Bm2bGhjLntMIoZ75bdCAB6kXj3h9uT0ZvQHKyJvU5oIrbmzTEp', '2025-12-21 10:51:09', '2025-12-25 11:11:34');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Índices de tabela `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Índices de tabela `cashier_closures`
--
ALTER TABLE `cashier_closures`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cashier_closures_user_unit_date_unique` (`user_id`,`unit_id`,`closed_date`),
  ADD KEY `cashier_closures_unit_id_foreign` (`unit_id`),
  ADD KEY `cashier_closures_user_id_idx` (`user_id`);

--
-- Índices de tabela `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expenses_supplier_id_foreign` (`supplier_id`),
  ADD KEY `expenses_unit_id_foreign` (`unit_id`),
  ADD KEY `expenses_user_id_foreign` (`user_id`);

--
-- Índices de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Índices de tabela `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Índices de tabela `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `newsletter_notices`
--
ALTER TABLE `newsletter_notices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `newsletter_notices_newsletter_subscription_id_foreign` (`newsletter_subscription_id`);

--
-- Índices de tabela `newsletter_subscriptions`
--
ALTER TABLE `newsletter_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `newsletter_subscriptions_phone_unique` (`phone`);

--
-- Índices de tabela `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Índices de tabela `product_discards`
--
ALTER TABLE `product_discards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_discards_user_id_foreign` (`user_id`),
  ADD KEY `product_discards_product_id_foreign` (`product_id`),
  ADD KEY `product_discards_unit_id_foreign` (`unit_id`);

--
-- Índices de tabela `salary_advances`
--
ALTER TABLE `salary_advances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `salary_advances_user_id_foreign` (`user_id`),
  ADD KEY `salary_advances_unit_id_foreign` (`unit_id`);

--
-- Índices de tabela `sales_disputes`
--
ALTER TABLE `sales_disputes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_disputes_created_by_foreign` (`created_by`);

--
-- Índices de tabela `sales_dispute_bids`
--
ALTER TABLE `sales_dispute_bids`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sales_dispute_bids_sales_dispute_id_supplier_id_unique` (`sales_dispute_id`,`supplier_id`),
  ADD KEY `sales_dispute_bids_supplier_id_foreign` (`supplier_id`),
  ADD KEY `sales_dispute_bids_approved_by_foreign` (`approved_by`);

--
-- Índices de tabela `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Índices de tabela `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `suppliers_access_code_unique` (`access_code`);

--
-- Índices de tabela `tb1_produto`
--
ALTER TABLE `tb1_produto`
  ADD PRIMARY KEY (`tb1_id`),
  ADD UNIQUE KEY `tb1_produto_tb1_codbar_unique` (`tb1_codbar`);

--
-- Índices de tabela `tb2_unidades`
--
ALTER TABLE `tb2_unidades`
  ADD PRIMARY KEY (`tb2_id`);

--
-- Índices de tabela `tb2_unidade_user`
--
ALTER TABLE `tb2_unidade_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tb2_unidade_user_user_id_tb2_id_unique` (`user_id`,`tb2_id`),
  ADD KEY `tb2_unidade_user_tb2_id_foreign` (`tb2_id`);

--
-- Índices de tabela `tb3_vendas`
--
ALTER TABLE `tb3_vendas`
  ADD PRIMARY KEY (`tb3_id`),
  ADD KEY `tb3_vendas_tb1_id_foreign` (`tb1_id`),
  ADD KEY `tb3_vendas_id_user_vale_foreign` (`id_user_vale`),
  ADD KEY `tb3_vendas_id_unidade_foreign` (`id_unidade`),
  ADD KEY `tb3_vendas_tb4_id_foreign` (`tb4_id`),
  ADD KEY `tb3_vendas_id_comanda_index` (`id_comanda`),
  ADD KEY `tb3_vendas_id_lanc_index` (`id_lanc`),
  ADD KEY `tb3_vendas_status_index` (`status`),
  ADD KEY `tb3_vendas_id_user_caixa_foreign` (`id_user_caixa`);

--
-- Índices de tabela `tb4_vendas_pg`
--
ALTER TABLE `tb4_vendas_pg`
  ADD PRIMARY KEY (`tb4_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_cod_acesso_unique` (`cod_acesso`),
  ADD KEY `users_tb2_id_foreign` (`tb2_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cashier_closures`
--
ALTER TABLE `cashier_closures`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de tabela `newsletter_notices`
--
ALTER TABLE `newsletter_notices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `newsletter_subscriptions`
--
ALTER TABLE `newsletter_subscriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `product_discards`
--
ALTER TABLE `product_discards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `salary_advances`
--
ALTER TABLE `salary_advances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `sales_disputes`
--
ALTER TABLE `sales_disputes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `sales_dispute_bids`
--
ALTER TABLE `sales_dispute_bids`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de tabela `tb1_produto`
--
ALTER TABLE `tb1_produto`
  MODIFY `tb1_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3000;

--
-- AUTO_INCREMENT de tabela `tb2_unidades`
--
ALTER TABLE `tb2_unidades`
  MODIFY `tb2_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb2_unidade_user`
--
ALTER TABLE `tb2_unidade_user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `tb3_vendas`
--
ALTER TABLE `tb3_vendas`
  MODIFY `tb3_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT de tabela `tb4_vendas_pg`
--
ALTER TABLE `tb4_vendas_pg`
  MODIFY `tb4_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `cashier_closures`
--
ALTER TABLE `cashier_closures`
  ADD CONSTRAINT `cashier_closures_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `tb2_unidades` (`tb2_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `cashier_closures_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `expenses_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `tb2_unidades` (`tb2_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `expenses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `newsletter_notices`
--
ALTER TABLE `newsletter_notices`
  ADD CONSTRAINT `newsletter_notices_newsletter_subscription_id_foreign` FOREIGN KEY (`newsletter_subscription_id`) REFERENCES `newsletter_subscriptions` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `product_discards`
--
ALTER TABLE `product_discards`
  ADD CONSTRAINT `product_discards_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `tb1_produto` (`tb1_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_discards_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `tb2_unidades` (`tb2_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `product_discards_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `salary_advances`
--
ALTER TABLE `salary_advances`
  ADD CONSTRAINT `salary_advances_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `tb2_unidades` (`tb2_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `salary_advances_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `sales_disputes`
--
ALTER TABLE `sales_disputes`
  ADD CONSTRAINT `sales_disputes_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `sales_dispute_bids`
--
ALTER TABLE `sales_dispute_bids`
  ADD CONSTRAINT `sales_dispute_bids_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `sales_dispute_bids_sales_dispute_id_foreign` FOREIGN KEY (`sales_dispute_id`) REFERENCES `sales_disputes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_dispute_bids_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tb2_unidade_user`
--
ALTER TABLE `tb2_unidade_user`
  ADD CONSTRAINT `tb2_unidade_user_tb2_id_foreign` FOREIGN KEY (`tb2_id`) REFERENCES `tb2_unidades` (`tb2_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb2_unidade_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tb3_vendas`
--
ALTER TABLE `tb3_vendas`
  ADD CONSTRAINT `tb3_vendas_id_unidade_foreign` FOREIGN KEY (`id_unidade`) REFERENCES `tb2_unidades` (`tb2_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tb3_vendas_id_user_caixa_foreign` FOREIGN KEY (`id_user_caixa`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tb3_vendas_id_user_vale_foreign` FOREIGN KEY (`id_user_vale`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tb3_vendas_tb1_id_foreign` FOREIGN KEY (`tb1_id`) REFERENCES `tb1_produto` (`tb1_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `tb3_vendas_tb4_id_foreign` FOREIGN KEY (`tb4_id`) REFERENCES `tb4_vendas_pg` (`tb4_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Restrições para tabelas `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_tb2_id_foreign` FOREIGN KEY (`tb2_id`) REFERENCES `tb2_unidades` (`tb2_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
