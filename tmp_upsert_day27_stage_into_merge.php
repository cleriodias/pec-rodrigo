<?php

declare(strict_types=1);

$sourceSchema = 'paoecafe83_d27_prod';
$targetSchema = 'paoecafe83_merge_27';

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
    'tb_16_boletos',
    'tb22_chat_mensagens',
    'tb4_vendas_pg',
    'tb3_vendas',
    'tb27_notas_fiscais',
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

$report = [];

foreach ($tables as $table) {
    $columns = getColumns($pdo, $sourceSchema, $table);
    $primaryKeys = getPrimaryKeys($pdo, $targetSchema, $table);

    $columnList = '`'.implode('`,`', $columns).'`';
    $selectList = implode(', ', array_map(static fn (string $column) => sprintf('s.`%s`', $column), $columns));

    $updateColumns = array_values(array_diff($columns, $primaryKeys));
    $updateAssignments = implode(
        ', ',
        array_map(static fn (string $column) => sprintf('`%1$s` = VALUES(`%1$s`)', $column), $updateColumns)
    );

    $before = (int) $pdo->query(sprintf('SELECT COUNT(*) FROM %s.%s', $targetSchema, $table))->fetchColumn();
    $source = (int) $pdo->query(sprintf('SELECT COUNT(*) FROM %s.%s', $sourceSchema, $table))->fetchColumn();

    if ($source === 0) {
        $report[$table] = [
            'fonte' => 0,
            'antes' => $before,
            'afetados' => 0,
            'depois' => $before,
        ];
        continue;
    }

    $sql = sprintf(
        'INSERT INTO %1$s.%2$s (%3$s)
         SELECT %4$s
         FROM %5$s.%2$s s
         ON DUPLICATE KEY UPDATE %6$s',
        $targetSchema,
        $table,
        $columnList,
        $selectList,
        $sourceSchema,
        $updateAssignments
    );

    $affected = $pdo->exec($sql);
    $after = (int) $pdo->query(sprintf('SELECT COUNT(*) FROM %s.%s', $targetSchema, $table))->fetchColumn();

    $report[$table] = [
        'fonte' => $source,
        'antes' => $before,
        'afetados' => $affected,
        'depois' => $after,
    ];
}

echo json_encode($report, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES).PHP_EOL;
