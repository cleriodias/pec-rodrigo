<?php

declare(strict_types=1);

$start = '2026-04-27 00:00:00';
$end = '2026-04-28 00:00:00';
$sslCa = 'C:/xampp/htdocs/pec-rodrigo/storage/app/private/cacert.pem';

$remote = new PDO(
    'mysql:host=pdv.mysql.database.azure.com;port=3306;dbname=paoecafe83;charset=utf8mb4',
    'pdv',
    '6yh&UJ8ik',
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::MYSQL_ATTR_SSL_CA => $sslCa,
    ]
);

$local = new PDO(
    'mysql:host=127.0.0.1;port=3306;dbname=paoecafe83_d27_prod;charset=utf8mb4',
    'root',
    '',
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]
);

function fetchAllRows(PDO $pdo, string $sql, array $params = []): array
{
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    return $stmt->fetchAll();
}

function fetchWhereIds(PDO $pdo, string $table, string $column, array $ids): array
{
    $ids = array_values(array_unique(array_filter($ids, static fn ($value) => $value !== null && $value !== '')));

    if ($ids === []) {
        return [];
    }

    $rows = [];

    foreach (array_chunk($ids, 500) as $chunk) {
        $placeholders = implode(',', array_fill(0, count($chunk), '?'));
        $sql = sprintf('SELECT * FROM paoecafe83.%s WHERE %s IN (%s)', $table, $column, $placeholders);
        $stmt = $pdo->prepare($sql);
        $stmt->execute(array_values($chunk));
        $rows = array_merge($rows, $stmt->fetchAll());
    }

    return $rows;
}

function mergeByPk(string $pk, array ...$sets): array
{
    $map = [];

    foreach ($sets as $rows) {
        foreach ($rows as $row) {
            if (! array_key_exists($pk, $row)) {
                continue;
            }

            $map[(string) $row[$pk]] = $row;
        }
    }

    return array_values($map);
}

function extractIds(array $rows, array $columns): array
{
    $ids = [];

    foreach ($rows as $row) {
        foreach ($columns as $column) {
            if (array_key_exists($column, $row) && $row[$column] !== null && $row[$column] !== '') {
                $ids[] = $row[$column];
            }
        }
    }

    return array_values(array_unique($ids));
}

function combineIds(array ...$sets): array
{
    $ids = [];

    foreach ($sets as $set) {
        foreach ($set as $value) {
            if ($value !== null && $value !== '') {
                $ids[] = $value;
            }
        }
    }

    return array_values(array_unique($ids));
}

function insertIgnore(PDO $pdo, string $table, array $rows): int
{
    if ($rows === []) {
        return 0;
    }

    $columns = array_keys($rows[0]);
    $columnList = '`'.implode('`,`', $columns).'`';
    $placeholderList = '('.implode(',', array_fill(0, count($columns), '?')).')';
    $sql = sprintf('INSERT IGNORE INTO %s (%s) VALUES %s', $table, $columnList, $placeholderList);
    $stmt = $pdo->prepare($sql);

    $inserted = 0;

    foreach ($rows as $row) {
        $values = [];

        foreach ($columns as $column) {
            $values[] = $row[$column];
        }

        $stmt->execute($values);
        $inserted += $stmt->rowCount();
    }

    return $inserted;
}

$range2 = [$start, $end, $start, $end];
$range3 = [$start, $end, $start, $end, $start, $end];
$range4 = [$start, $end, $start, $end, $start, $end, $start, $end];
$range5 = [$start, $end, $start, $end, $start, $end, $start, $end, $start, $end];

$sales = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb3_vendas WHERE (data_hora >= ? AND data_hora < ?) OR (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY tb3_id", $range3);
$paymentsTime = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb4_vendas_pg WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY tb4_id", $range2);
$notesTime = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb27_notas_fiscais WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) OR (tb27_emitida_em >= ? AND tb27_emitida_em < ?) OR (tb27_cancelada_em >= ? AND tb27_cancelada_em < ?) OR (tb27_ultima_tentativa_em >= ? AND tb27_ultima_tentativa_em < ?) ORDER BY tb27_id", $range5);
$advances = fetchAllRows($remote, "SELECT * FROM paoecafe83.salary_advances WHERE advance_date = '2026-04-27' OR (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY id", $range2);
$expenses = fetchAllRows($remote, "SELECT * FROM paoecafe83.expenses WHERE expense_date = '2026-04-27' OR (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY id", $range2);
$boletos = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb_16_boletos WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) OR (paid_at >= ? AND paid_at < ?) ORDER BY id", $range3);
$closures = fetchAllRows($remote, "SELECT * FROM paoecafe83.cashier_closures WHERE closed_date = '2026-04-27' OR (closed_at >= ? AND closed_at < ?) OR (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) OR (master_checked_at >= ? AND master_checked_at < ?) ORDER BY id", $range4);
$chat = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb22_chat_mensagens WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) OR (read_at >= ? AND read_at < ?) ORDER BY id", $range3);

$paymentIds = combineIds(
    extractIds($paymentsTime, ['tb4_id']),
    extractIds($sales, ['tb4_id']),
    extractIds($notesTime, ['tb4_id'])
);
$payments = mergeByPk('tb4_id', $paymentsTime, fetchWhereIds($remote, 'tb4_vendas_pg', 'tb4_id', $paymentIds));

$notes = mergeByPk('tb27_id', $notesTime, fetchWhereIds($remote, 'tb27_notas_fiscais', 'tb4_id', extractIds($payments, ['tb4_id'])));

$usersTime = fetchAllRows($remote, "SELECT * FROM paoecafe83.users WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY id", $range2);
$userIds = combineIds(
    extractIds($sales, ['id_user_caixa', 'id_user_vale']),
    extractIds($advances, ['user_id']),
    extractIds($expenses, ['user_id']),
    extractIds($boletos, ['user_id', 'paid_by']),
    extractIds($closures, ['user_id', 'master_checked_by']),
    extractIds($chat, ['sender_id', 'recipient_id'])
);
$users = mergeByPk('id', $usersTime, fetchWhereIds($remote, 'users', 'id', $userIds));

$unitsTime = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb2_unidades WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY tb2_id", $range2);
$unitIds = combineIds(
    extractIds($sales, ['id_unidade']),
    extractIds($notes, ['tb2_id']),
    extractIds($advances, ['unit_id']),
    extractIds($expenses, ['unit_id']),
    extractIds($boletos, ['unit_id']),
    extractIds($closures, ['unit_id']),
    extractIds($chat, ['sender_unit_id']),
    extractIds($users, ['tb2_id'])
);
$units = mergeByPk('tb2_id', $unitsTime, fetchWhereIds($remote, 'tb2_unidades', 'tb2_id', $unitIds));

$productsTime = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb1_produto WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY tb1_id", $range2);
$products = mergeByPk('tb1_id', $productsTime, fetchWhereIds($remote, 'tb1_produto', 'tb1_id', extractIds($sales, ['tb1_id'])));

$configsTime = fetchAllRows($remote, "SELECT * FROM paoecafe83.tb26_configuracoes_fiscais WHERE (created_at >= ? AND created_at < ?) OR (updated_at >= ? AND updated_at < ?) ORDER BY tb26_id", $range2);
$configs = mergeByPk(
    'tb26_id',
    $configsTime,
    fetchWhereIds($remote, 'tb26_configuracoes_fiscais', 'tb2_id', $unitIds),
    fetchWhereIds($remote, 'tb26_configuracoes_fiscais', 'tb26_id', extractIds($notes, ['tb26_id']))
);

$report = [];
$report['tb2_unidades'] = ['selecionados' => count($units), 'inseridos' => insertIgnore($local, 'tb2_unidades', $units)];
$report['users'] = ['selecionados' => count($users), 'inseridos' => insertIgnore($local, 'users', $users)];
$report['tb1_produto'] = ['selecionados' => count($products), 'inseridos' => insertIgnore($local, 'tb1_produto', $products)];
$report['tb26_configuracoes_fiscais'] = ['selecionados' => count($configs), 'inseridos' => insertIgnore($local, 'tb26_configuracoes_fiscais', $configs)];
$report['tb4_vendas_pg'] = ['selecionados' => count($payments), 'inseridos' => insertIgnore($local, 'tb4_vendas_pg', $payments)];
$report['tb3_vendas'] = ['selecionados' => count($sales), 'inseridos' => insertIgnore($local, 'tb3_vendas', $sales)];
$report['tb27_notas_fiscais'] = ['selecionados' => count($notes), 'inseridos' => insertIgnore($local, 'tb27_notas_fiscais', $notes)];
$report['salary_advances'] = ['selecionados' => count($advances), 'inseridos' => insertIgnore($local, 'salary_advances', $advances)];
$report['expenses'] = ['selecionados' => count($expenses), 'inseridos' => insertIgnore($local, 'expenses', $expenses)];
$report['tb_16_boletos'] = ['selecionados' => count($boletos), 'inseridos' => insertIgnore($local, 'tb_16_boletos', $boletos)];
$report['cashier_closures'] = ['selecionados' => count($closures), 'inseridos' => insertIgnore($local, 'cashier_closures', $closures)];
$report['tb22_chat_mensagens'] = ['selecionados' => count($chat), 'inseridos' => insertIgnore($local, 'tb22_chat_mensagens', $chat)];

foreach (array_keys($report) as $table) {
    $report[$table]['total_local'] = (int) $local->query("SELECT COUNT(*) FROM {$table}")->fetchColumn();
}

echo json_encode($report, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES).PHP_EOL;
