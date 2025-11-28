import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { useMemo, useState } from 'react';

const formatCurrency = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });

const formatDate = (value) => {
    if (!value) {
        return '--';
    }

    const date = new Date(value);
    return date.toLocaleString('pt-BR', {
        dateStyle: 'short',
        timeStyle: 'short',
    });
};

export default function SalesToday({ meta, chartData, details, totals, dateLabel }) {
    const initialType = useMemo(() => {
        const withValue = chartData.find((item) => item.total > 0);
        return withValue?.type ?? 'dinheiro';
    }, [chartData]);

    const [selectedType, setSelectedType] = useState(initialType);

    const totalSum = chartData.reduce((sum, item) => sum + item.total, 0);

    const pieStyle = useMemo(() => {
        if (totalSum <= 0) {
            return { background: '#e5e7eb' };
        }

        let accumulated = 0;
        const stops = chartData.map((item) => {
            if (item.total <= 0) {
                return null;
            }

            const angle = (item.total / totalSum) * 360;
            const start = accumulated;
            const end = accumulated + angle;
            accumulated = end;

            return `${item.color} ${start}deg ${end}deg`;
        });

        return {
            background: `conic-gradient(${stops.filter(Boolean).join(',')})`,
        };
    }, [chartData, totalSum]);

    const selectedDetails = details[selectedType] ?? [];
    const selectedMeta = meta[selectedType] ?? { label: selectedType, color: '#111827' };
    const selectedTotal = totals[selectedType] ?? 0;

    const observations = (record) => {
        if (record.origin === 'dinheiro' && selectedType === 'maquina') {
            return 'Complemento no cartão';
        }

        if (record.origin === 'dinheiro') {
            return 'Venda em dinheiro (pode conter complemento)';
        }

        return 'Pagamento direto';
    };

    const headerContent = (
        <div>
            <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                Vendas de hoje ({dateLabel})
            </h2>
            <p className="text-sm text-gray-500 dark:text-gray-300">
                Visão geral dos pagamentos registrados no dia, com destaque para cada forma de
                pagamento.
            </p>
        </div>
    );

    return (
        <AuthenticatedLayout header={headerContent}>
            <Head title="Vendas de hoje" />

            <div className="py-12">
                <div className="mx-auto max-w-7xl space-y-8 px-4 sm:px-6 lg:px-8">
                    <div className="grid gap-6 rounded-2xl bg-white p-6 shadow dark:bg-gray-800 lg:grid-cols-2">
                        <div>
                            <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                                Totais por tipo
                            </h3>
                            <div className="mt-4 grid gap-4 sm:grid-cols-2">
                                {chartData.map((item) => (
                                    <div
                                        key={item.type}
                                        className="rounded-2xl border border-gray-100 bg-gray-50 p-4 shadow-sm dark:border-gray-700 dark:bg-gray-900/40"
                                    >
                                        <p className="text-sm text-gray-600 dark:text-gray-300">
                                            {item.label}
                                        </p>
                                        <p className="text-2xl font-bold text-gray-900 dark:text-white">
                                            {formatCurrency(item.total)}
                                        </p>
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="flex flex-col items-center justify-center gap-4">
                            <div
                                className="flex h-48 w-48 items-center justify-center rounded-full border-8 border-white text-xl font-bold text-gray-800 shadow-inner dark:border-gray-700"
                                style={pieStyle}
                            >
                                {formatCurrency(totalSum)}
                            </div>
                            <div className="flex flex-wrap justify-center gap-3 text-sm">
                                {chartData.map((item) => (
                                    <div key={item.type} className="flex items-center gap-2">
                                        <span
                                            className="inline-block h-3 w-3 rounded-full"
                                            style={{ backgroundColor: item.color }}
                                        />
                                        <span className="text-gray-600 dark:text-gray-200">
                                            {item.label}
                                        </span>
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>

                    <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
                        <div className="flex flex-wrap items-center justify-between gap-3">
                            <div>
                                <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                                    Detalhes por pagamento
                                </h3>
                                <p className="text-sm text-gray-500 dark:text-gray-300">
                                    Selecione uma forma de pagamento para listar as vendas.
                                </p>
                            </div>
                            <div className="flex flex-wrap gap-2">
                                {chartData.map((item) => (
                                    <button
                                        type="button"
                                        key={item.type}
                                        onClick={() => setSelectedType(item.type)}
                                        className={`rounded-full px-4 py-2 text-sm font-semibold text-white shadow ${
                                            selectedType === item.type
                                                ? 'ring-2 ring-offset-2 ring-offset-gray-50 dark:ring-offset-gray-800'
                                                : 'opacity-70'
                                        }`}
                                        style={{ backgroundColor: item.color }}
                                    >
                                        {item.label}
                                    </button>
                                ))}
                            </div>
                        </div>

                        <div className="mt-6 rounded-2xl border border-gray-100 bg-gray-50 p-4 dark:border-gray-700 dark:bg-gray-900/40">
                            <p className="text-sm font-medium text-gray-600 dark:text-gray-200">
                                Total em {selectedMeta.label}
                            </p>
                            <p className="text-3xl font-bold text-gray-900 dark:text-white">
                                {formatCurrency(selectedTotal)}
                            </p>
                        </div>

                        <div className="mt-6 overflow-x-auto">
                            {selectedDetails.length === 0 ? (
                                <p className="rounded-xl border border-dashed border-gray-200 px-4 py-6 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-300">
                                    Nenhuma venda registrada nesta forma de pagamento hoje.
                                </p>
                            ) : (
                                <table className="min-w-full divide-y divide-gray-200 text-sm dark:divide-gray-700">
                                    <thead className="bg-gray-100 dark:bg-gray-900/60">
                                        <tr>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                                                ID
                                            </th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                                                Data/Hora
                                            </th>
                                            <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                                                Valor considerado
                                            </th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                                                Observação
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
                                        {selectedDetails.map((record) => (
                                            <tr key={`${record.tb4_id}-${record.origin}-${record.applied_total}`}>
                                                <td className="px-3 py-2 text-gray-800 dark:text-gray-100">
                                                    #{record.tb4_id}
                                                </td>
                                                <td className="px-3 py-2 text-gray-700 dark:text-gray-200">
                                                    {formatDate(record.created_at)}
                                                </td>
                                                <td className="px-3 py-2 text-right font-semibold text-gray-900 dark:text-white">
                                                    {formatCurrency(record.applied_total)}
                                                </td>
                                                <td className="px-3 py-2 text-gray-600 dark:text-gray-300">
                                                    {observations(record)}
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
