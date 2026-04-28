<?php

declare(strict_types=1);

$sourceSchema = 'paoecafe83_d27_prod';
$replayPath = 'C:/xampp/htdocs/pec-rodrigo/bkp/replay_day27_after_restore_27-04-26.sql';
$validatePath = 'C:/xampp/htdocs/pec-rodrigo/bkp/validate_day27_after_restore_27-04-26.sql';

$pdo = new PDO(
    'mysql:host=127.0.0.1;port=3306;charset=utf8mb4',
    'root',
    '',
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]
);

$tables = [
    'tb2_unidades',
    'users',
    'tb1_produto',
    'tb26_configuracoes_fiscais',
    'salary_advances',
    'expenses',
    'tb_16_boletos',
    'cashier_closures',
    'tb22_chat_mensagens',
    'tb4_vendas_pg',
    'tb3_vendas',
    'tb27_notas_fiscais',
];

$expectedTotals = [
    'tb2_unidades' => 5,
    'users' => 43,
    'tb1_produto' => 1922,
    'tb26_configuracoes_fiscais' => 5,
    'tb4_vendas_pg' => 31045,
    'tb3_vendas' => 66238,
    'tb27_notas_fiscais' => 88,
    'salary_advances' => 18,
    'expenses' => 478,
    'tb_16_boletos' => 65,
    'cashier_closures' => 226,
    'tb22_chat_mensagens' => 166,
];

$expectedDay27 = [
    'tb4_vendas_pg' => "SELECT 'tb4_day27' AS item, COUNT(*) AS total FROM tb4_vendas_pg WHERE created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00';",
    'tb3_vendas' => "SELECT 'tb3_day27' AS item, COUNT(*) AS total FROM tb3_vendas WHERE (data_hora >= '2026-04-27 00:00:00' AND data_hora < '2026-04-28 00:00:00') OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00');",
    'salary_advances' => "SELECT 'salary_day27' AS item, COUNT(*) AS total FROM salary_advances WHERE advance_date = '2026-04-27' OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00');",
    'expenses' => "SELECT 'expenses_day27' AS item, COUNT(*) AS total FROM expenses WHERE expense_date = '2026-04-27' OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00');",
    'tb_16_boletos' => "SELECT 'boleto_day27' AS item, COUNT(*) AS total FROM tb_16_boletos WHERE (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (paid_at >= '2026-04-27 00:00:00' AND paid_at < '2026-04-28 00:00:00');",
    'cashier_closures' => "SELECT 'cashier_day27' AS item, COUNT(*) AS total FROM cashier_closures WHERE closed_date = '2026-04-27' OR (closed_at >= '2026-04-27 00:00:00' AND closed_at < '2026-04-28 00:00:00') OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (master_checked_at >= '2026-04-27 00:00:00' AND master_checked_at < '2026-04-28 00:00:00');",
    'tb22_chat_mensagens' => "SELECT 'chat_day27' AS item, COUNT(*) AS total FROM tb22_chat_mensagens WHERE (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (read_at >= '2026-04-27 00:00:00' AND read_at < '2026-04-28 00:00:00');",
];

$tableSources = [
    'cashier_closures' => [
        'schema' => 'paoecafe83_merge_27',
        'query' => "SELECT * FROM paoecafe83_merge_27.cashier_closures WHERE closed_date = '2026-04-27' OR (closed_at >= '2026-04-27 00:00:00' AND closed_at < '2026-04-28 00:00:00') OR (created_at >= '2026-04-27 00:00:00' AND created_at < '2026-04-28 00:00:00') OR (updated_at >= '2026-04-27 00:00:00' AND updated_at < '2026-04-28 00:00:00') OR (master_checked_at >= '2026-04-27 00:00:00' AND master_checked_at < '2026-04-28 00:00:00') ORDER BY id",
        'label' => 'base consolidada local (fechamentos recuperados do restore)',
    ],
];

function getColumns(PDO $pdo, string $schema, string $table): array
{
    $stmt = $pdo->prepare(
        'SELECT COLUMN_NAME
         FROM information_schema.columns
         WHERE table_schema = ? AND table_name = ?
         ORDER BY ordinal_position'
    );
    $stmt->execute([$schema, $table]);

    return array_column($stmt->fetchAll(), 'COLUMN_NAME');
}

function getPrimaryKeys(PDO $pdo, string $schema, string $table): array
{
    $stmt = $pdo->prepare(
        'SELECT COLUMN_NAME
         FROM information_schema.key_column_usage
         WHERE table_schema = ? AND table_name = ? AND constraint_name = ?
         ORDER BY ordinal_position'
    );
    $stmt->execute([$schema, $table, 'PRIMARY']);

    return array_column($stmt->fetchAll(), 'COLUMN_NAME');
}

function getRows(PDO $pdo, string $schema, string $table): array
{
    return $pdo->query(sprintf('SELECT * FROM %s.%s', $schema, $table))->fetchAll();
}

function getSourceConfig(string $defaultSchema, string $table, array $tableSources): array
{
    $source = $tableSources[$table] ?? [];

    return [
        'schema' => $source['schema'] ?? $defaultSchema,
        'query' => $source['query'] ?? null,
        'label' => $source['label'] ?? sprintf('staging local de 27/04/26 (%s)', $defaultSchema),
    ];
}

function getRowsFromSource(PDO $pdo, array $sourceConfig, string $table): array
{
    if (is_string($sourceConfig['query'] ?? null) && $sourceConfig['query'] !== '') {
        return $pdo->query($sourceConfig['query'])->fetchAll();
    }

    return getRows($pdo, $sourceConfig['schema'], $table);
}

function quoteValue(PDO $pdo, mixed $value): string
{
    if ($value === null) {
        return 'NULL';
    }

    if (is_string($value) && preg_match('/^0000-00-00(?:[ T]00:00:00(?:\\.0+)?)?$/', $value) === 1) {
        return 'NULL';
    }

    return $pdo->quote((string) $value);
}

$replay = [];
$replay[] = '-- Reaplicacao do dia 27/04/26 sobre a base restaurada do Backup automatizado #5 (27/04/26 09:21:16.601 UTC)';
$replay[] = '-- Executar apontando explicitamente para a base paoecafe83 apos o restore.';
$replay[] = 'START TRANSACTION;';
$replay[] = '';

foreach ($tables as $table) {
    $sourceConfig = getSourceConfig($sourceSchema, $table, $tableSources);
    $rows = getRowsFromSource($pdo, $sourceConfig, $table);
    $columns = getColumns($pdo, $sourceConfig['schema'], $table);
    $primaryKeys = getPrimaryKeys($pdo, $sourceConfig['schema'], $table);
    $updateColumns = array_values(array_diff($columns, $primaryKeys));

    $replay[] = sprintf('-- %s: %d registro(s) na %s', $table, count($rows), $sourceConfig['label']);

    if ($rows === []) {
        $replay[] = sprintf('-- %s sem registros para reaplicar.', $table);
        $replay[] = '';
        continue;
    }

    $columnList = '`'.implode('`,`', $columns).'`';
    $updateAssignments = implode(
        ', ',
        array_map(static fn (string $column) => sprintf('`%1$s` = VALUES(`%1$s`)', $column), $updateColumns)
    );

    foreach (array_chunk($rows, 200) as $chunk) {
        $valueLines = [];

        foreach ($chunk as $row) {
            $values = [];

            foreach ($columns as $column) {
                $values[] = quoteValue($pdo, $row[$column] ?? null);
            }

            $valueLines[] = '('.implode(', ', $values).')';
        }

        $replay[] = sprintf(
            'INSERT INTO `%s` (%s) VALUES',
            $table,
            $columnList
        );
        $replay[] = implode(",\n", $valueLines);
        $replay[] = sprintf('ON DUPLICATE KEY UPDATE %s;', $updateAssignments);
        $replay[] = '';
    }
}

$replay[] = 'COMMIT;';
$replay[] = '';

file_put_contents($replayPath, implode(PHP_EOL, $replay));

$validate = [];
$validate[] = '-- Validacao apos executar replay_day27_after_restore_27-04-26.sql na base restaurada.';
$validate[] = '';

foreach ($expectedTotals as $table => $expected) {
    $validate[] = sprintf(
        "SELECT '%s_total' AS item, COUNT(*) AS total, %d AS esperado FROM `%s`;",
        $table,
        $expected,
        $table
    );
}

$validate[] = '';

foreach ($expectedDay27 as $sql) {
    $validate[] = $sql;
}

$validate[] = '';
$validate[] = "-- Esperados no recorte de 27/04/26: tb4_day27=672, tb3_day27=1447, salary_day27=1, expenses_day27=2, boleto_day27=5, cashier_day27=5, chat_day27=23.";

file_put_contents($validatePath, implode(PHP_EOL, $validate));

echo json_encode(
    [
        'replay' => $replayPath,
        'validate' => $validatePath,
    ],
    JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
).PHP_EOL;
