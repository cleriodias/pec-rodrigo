import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { useEffect, useMemo, useState } from 'react';

const paymentColumns = [
    { key: 'dinheiro', label: 'Dinheiro' },
    { key: 'maquina', label: 'Maquina' },
    { key: 'vale', label: 'Vale' },
    { key: 'refeicao', label: 'Refei\u00e7\u00e3o' },
    { key: 'faturar', label: 'Faturar' },
];

const formatCurrency = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });

export default function CashClosure({
    records = [],
    dateValue = '',
    dateInputValue = '',
    filterUnits = [],
    selectedUnitId = null,
    selectedUnit = { name: 'Todas as unidades' },
}) {
    const normalizedSelectedUnit = selectedUnitId ?? null;
    const [dateInput, setDateInput] = useState(dateInputValue ?? '');
    const [unitFilter, setUnitFilter] = useState(normalizedSelectedUnit);

    useEffect(() => {
        setDateInput(dateInputValue ?? '');
    }, [dateInputValue]);

    useEffect(() => {
        setUnitFilter(normalizedSelectedUnit);
    }, [normalizedSelectedUnit]);

    const totals = useMemo(() => {
        return paymentColumns.reduce(
            (acc, column) => ({
                ...acc,
                [column.key]: records.reduce(
                    (sum, record) => sum + (record.totals?.[column.key] ?? 0),
                    0,
                ),
            }),
            {},
        );
    }, [records]);

    const grandTotal = useMemo(
        () => records.reduce((sum, record) => sum + (record.grand_total ?? 0), 0),
        [records],
    );

    const unitOptions = useMemo(() => {
        const base = [{ id: null, name: 'Todas as unidades' }];
        if (!Array.isArray(filterUnits) || filterUnits.length === 0) {
            return base;
        }

        const mapped = filterUnits.map((unit) => ({
            id: unit.id ?? unit.tb2_id ?? null,
            name: unit.name ?? unit.tb2_nome ?? '---',
        }));

        return base.concat(mapped);
    }, [filterUnits]);

    const applyFilters = (dateValueParam, unitValueParam) => {
        const params = {};

        if (dateValueParam) {
            params.date = dateValueParam;
        }

        if (unitValueParam !== null && unitValueParam !== undefined) {
            params.unit_id = unitValueParam;
        }

        router.get(route('reports.cash.closure'), params, { preserveScroll: true });
    };

    const handleDateChange = (value) => {
        setDateInput(value);
        applyFilters(value, unitFilter);
    };

    const handleUnitFilter = (optionId) => {
        const normalized = optionId ?? null;
        setUnitFilter(normalized);
        applyFilters(dateInput, normalized);
    };

    const filterCard = (
        <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
            <div className="flex flex-col gap-2">
                <p className="text-xs font-semibold uppercase tracking-[0.3em] text-gray-400">
                    Filtro
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-300">
                    Escolha a data e a unidade para visualizar o fechamento.
                </p>
            </div>
            <div className="mt-4 flex flex-col gap-4">
                <div className="flex flex-col gap-2 sm:flex-row sm:items-end">
                    <div className="flex-1">
                        <label
                            htmlFor="closure-date"
                            className="text-sm font-medium text-gray-700 dark:text-gray-200"
                        >
                            Data de refer\u00eancia
                        </label>
                        <input
                            id="closure-date"
                            type="date"
                            value={dateInput}
                            onChange={(event) => handleDateChange(event.target.value)}
                            className="mt-1 w-full rounded-xl border border-gray-300 px-3 py-2 text-gray-800 focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                        />
                    </div>
                </div>

                <div>
                    <p className="text-xs font-semibold uppercase tracking-[0.3em] text-gray-400">
                        Unidade
                    </p>
                    <div className="mt-3 flex flex-wrap gap-2">
                        {unitOptions.map((unit) => {
                            const optionId = unit.id ?? null;
                            const isActive = optionId === (unitFilter ?? null);

                            return (
                                <button
                                    type="button"
                                    key={`unit-filter-${optionId ?? 'all'}`}
                                    onClick={() => handleUnitFilter(optionId)}
                                    className={`rounded-full px-4 py-2 text-sm font-semibold transition ${
                                        isActive
                                            ? 'bg-indigo-600 text-white shadow'
                                            : 'bg-gray-100 text-gray-600 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-200'
                                    }`}
                                >
                                    {unit.name}
                                </button>
                            );
                        })}
                    </div>
                </div>
            </div>
        </div>
    );

    const summaryCard = (
        <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                Resumo geral
            </h3>
            <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-6">
                {paymentColumns.map((column) => (
                    <div
                        key={column.key}
                        className="rounded-xl border border-gray-100 bg-gray-50 p-4 text-center dark:border-gray-700 dark:bg-gray-900/40"
                    >
                        <p className="text-sm text-gray-600 dark:text-gray-300">{column.label}</p>
                        <p className="text-xl font-bold text-gray-900 dark:text-white">
                            {formatCurrency(totals[column.key] ?? 0)}
                        </p>
                    </div>
                ))}
                <div className="rounded-xl border border-indigo-100 bg-indigo-50 p-4 text-center dark:border-indigo-500/40 dark:bg-indigo-900/30">
                    <p className="text-sm text-indigo-800 dark:text-indigo-200">Total geral</p>
                    <p className="text-2xl font-bold text-indigo-900 dark:text-white">
                        {formatCurrency(grandTotal)}
                    </p>
                </div>
            </div>
        </div>
    );

    const tableSection = (
        <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                Totais por caixa ({selectedUnit?.name ?? 'Todas as unidades'}) — {dateValue || '---'}
            </h3>
            <div className="mt-4 overflow-x-auto">
                {records.length === 0 ? (
                    <p className="rounded-xl border border-dashed border-gray-200 px-4 py-6 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-300">
                        Nenhum lan\u00e7amento encontrado para a data selecionada.
                    </p>
                ) : (
                    <table className="min-w-full divide-y divide-gray-200 text-sm dark:divide-gray-700">
                        <thead className="bg-gray-50 text-gray-600 dark:bg-gray-900/60 dark:text-gray-300">
                            <tr>
                                <th className="px-3 py-2 text-left font-medium">Caixa</th>
                                <th className="px-3 py-2 text-left font-medium">Unidade</th>
                                {paymentColumns.map((column) => (
                                    <th
                                        key={`header-${column.key}`}
                                        className="px-3 py-2 text-right font-medium"
                                    >
                                        {column.label}
                                    </th>
                                ))}
                                <th className="px-3 py-2 text-right font-medium">Total</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
                            {records.map((record) => (
                                <tr key={record.cashier_id}>
                                    <td className="px-3 py-2 text-gray-800 dark:text-gray-100">
                                        {record.cashier_name}
                                    </td>
                                    <td className="px-3 py-2 text-gray-600 dark:text-gray-300">
                                        {record.unit_name ?? '---'}
                                    </td>
                                    {paymentColumns.map((column) => (
                                        <td
                                            key={`${record.cashier_id}-${column.key}`}
                                            className="px-3 py-2 text-right text-gray-700 dark:text-gray-200"
                                        >
                                            {formatCurrency(record.totals?.[column.key] ?? 0)}
                                        </td>
                                    ))}
                                    <td className="px-3 py-2 text-right font-semibold text-gray-900 dark:text-white">
                                        {formatCurrency(record.grand_total ?? 0)}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>
        </div>
    );

    return (
        <AuthenticatedLayout
            header={
                <div>
                    <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                        Fechamento de CAIXA
                    </h2>
                    <p className="text-sm text-gray-500 dark:text-gray-300">
                        Totais de venda por atendente organizados por forma de pagamento.
                    </p>
                </div>
            }
        >
            <Head title="Fechamento de CAIXA" />

            <div className="py-12">
                <div className="mx-auto max-w-7xl space-y-8 px-4 sm:px-6 lg:px-8">
                    {filterCard}
                    {summaryCard}
                    {tableSection}
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
