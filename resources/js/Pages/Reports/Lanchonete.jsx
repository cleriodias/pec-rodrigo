import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, useForm } from '@inertiajs/react';

const formatCurrency = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });

const formatDateTime = (value) => {
    if (!value) {
        return '--';
    }

    return new Date(value).toLocaleString('pt-BR', {
        dateStyle: 'short',
        timeStyle: 'short',
    });
};

const ComandaCard = ({ data, statusLabel }) => (
    <div className="rounded-2xl border border-gray-200 bg-white p-4 shadow-sm dark:border-gray-700 dark:bg-gray-800">
        <div className="flex flex-wrap items-center justify-between gap-3">
            <div className="flex items-center gap-3">
                <span className="text-base font-semibold text-gray-900 dark:text-gray-100">
                    Comanda {data.comanda}
                </span>
                <span className="rounded-full bg-gray-100 px-2 py-0.5 text-xs font-semibold text-gray-600 dark:bg-gray-700 dark:text-gray-200">
                    {statusLabel}
                </span>
            </div>
            <div className="text-right text-sm text-gray-500 dark:text-gray-300">
                <div>Total: {formatCurrency(data.total)}</div>
                <div>Atualizado: {formatDateTime(data.updated_at)}</div>
            </div>
        </div>
        <div className="mt-4 overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200 text-sm dark:divide-gray-700">
                <thead className="bg-gray-100 dark:bg-gray-900/60">
                    <tr>
                        <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                            Produto
                        </th>
                        <th className="px-3 py-2 text-center font-medium text-gray-600 dark:text-gray-300">
                            Qtde
                        </th>
                        <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                            UnitA?rio
                        </th>
                        <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                            Total
                        </th>
                        <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                            LanA?ado por
                        </th>
                        <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                            Caixa
                        </th>
                    </tr>
                </thead>
                <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
                    {data.items.map((item) => (
                        <tr key={item.id}>
                            <td className="px-3 py-2 text-gray-800 dark:text-gray-100">
                                {item.name}
                            </td>
                            <td className="px-3 py-2 text-center text-gray-700 dark:text-gray-200">
                                {item.quantity}
                            </td>
                            <td className="px-3 py-2 text-right text-gray-700 dark:text-gray-200">
                                {formatCurrency(item.unit_price)}
                            </td>
                            <td className="px-3 py-2 text-right font-semibold text-gray-900 dark:text-gray-100">
                                {formatCurrency(item.total)}
                            </td>
                            <td className="px-3 py-2 text-gray-700 dark:text-gray-200">
                                {item.launched_by ?? '--'}
                            </td>
                            <td className="px-3 py-2 text-gray-700 dark:text-gray-200">
                                {item.cashier ?? '--'}
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    </div>
);

const ComandaSection = ({ title, items, emptyMessage, statusLabel }) => (
    <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
        <div className="flex flex-wrap items-center justify-between gap-3">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">{title}</h3>
            <span className="text-xs font-semibold text-gray-500 dark:text-gray-300">
                {items.length} comandas
            </span>
        </div>
        {items.length === 0 ? (
            <p className="mt-4 rounded-xl border border-dashed border-gray-200 px-4 py-6 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-300">
                {emptyMessage}
            </p>
        ) : (
            <div className="mt-4 space-y-4">
                {items.map((item) => (
                    <ComandaCard key={`${item.comanda}-${item.status}`} data={item} statusLabel={statusLabel} />
                ))}
            </div>
        )}
    </div>
);

export default function LanchoneteReport({
    unit,
    dateValue,
    openComandas = [],
    closedComandas = [],
    filterUnits = [],
    selectedUnitId = null,
}) {
    const { data, setData, get, processing } = useForm({
        date: dateValue ?? '',
        unit_id:
            selectedUnitId !== null && selectedUnitId !== undefined
                ? String(selectedUnitId)
                : 'all',
    });

    const handleSubmit = (event) => {
        event.preventDefault();
        get(route('reports.lanchonete'), {
            preserveState: true,
            preserveScroll: true,
            replace: true,
            data,
        });
    };

    return (
        <AuthenticatedLayout
            header={
                <div>
                    <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                        RelatA?rio Lanchonete
                    </h2>
                    <p className="text-sm text-gray-500 dark:text-gray-300">
                        Unidade atual: {unit?.name ?? '---'}.
                    </p>
                </div>
            }
        >
            <Head title="RelatA?rio Lanchonete" />

            <div className="py-10">
                <div className="mx-auto max-w-6xl space-y-6 px-4 sm:px-6 lg:px-8">
                    <form
                        onSubmit={handleSubmit}
                        className="rounded-2xl bg-white p-4 shadow dark:bg-gray-800"
                    >
                        <div className="flex flex-wrap items-end gap-3">
                            <div>
                                <label className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                    Dia
                                </label>
                                <input
                                    type="date"
                                    value={data.date}
                                    onChange={(event) => setData('date', event.target.value)}
                                    className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                />
                            </div>
                            <div>
                                <label className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                    Unidade
                                </label>
                                <select
                                    value={data.unit_id}
                                    onChange={(event) => setData('unit_id', event.target.value)}
                                    className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                >
                                    <option value="all">Todas</option>
                                    {filterUnits.map((filterUnit) => (
                                        <option key={filterUnit.id} value={filterUnit.id}>
                                            {filterUnit.name}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <button
                                type="submit"
                                disabled={processing}
                                className="rounded-xl bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-indigo-700 disabled:opacity-60"
                            >
                                Filtrar
                            </button>
                        </div>
                    </form>
                    <ComandaSection
                        title="Comandas em aberto"
                        items={openComandas}
                        statusLabel="Aberta"
                        emptyMessage="Nenhuma comanda em aberto para esta unidade."
                    />
                    <ComandaSection
                        title="Comandas finalizadas"
                        items={closedComandas}
                        statusLabel="Fechada"
                        emptyMessage="Nenhuma comanda finalizada para esta unidade."
                    />
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
