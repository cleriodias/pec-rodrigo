import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { formatBrazilDateTime } from '@/Utils/date';
import { Head, useForm } from '@inertiajs/react';

const formatCurrency = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });

const formatQuantity = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 3,
    });

const formatDateTime = (value) => {
    if (!value) {
        return '--';
    }

    return formatBrazilDateTime(value);
};

const SummaryCard = ({ title, value, description, accentClass }) => (
    <div className="rounded-2xl border border-gray-100 bg-white p-5 shadow-sm dark:border-gray-700 dark:bg-gray-800">
        <p className="text-xs font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-300">
            {title}
        </p>
        <p className={`mt-2 text-2xl font-bold ${accentClass}`}>
            {value}
        </p>
        <p className="mt-2 text-sm text-gray-500 dark:text-gray-300">
            {description}
        </p>
    </div>
);

export default function DiscardConsolidated({
    rows = [],
    summary = {},
    monthValue,
    monthLabel,
    unit,
    filterUnits = [],
    selectedUnitId = null,
}) {
    const { data, setData, get, processing } = useForm({
        month: monthValue ?? '',
        unit_id:
            selectedUnitId !== null && selectedUnitId !== undefined
                ? String(selectedUnitId)
                : 'all',
    });

    const handleSubmit = (event) => {
        event.preventDefault();
        get(route('reports.descarte.consolidado'), {
            preserveState: true,
            preserveScroll: true,
            replace: true,
            data,
        });
    };

    const topProduct = summary?.top_product ?? null;

    return (
        <AuthenticatedLayout
            header={
                <div>
                    <h2 className="text-xl font-semibold text-gray-800 dark:text-gray-100">
                        Discarte Consolidado
                    </h2>
                    <p className="text-sm text-gray-500 dark:text-gray-300">
                        Ranking de itens mais descartados no mes. Loja atual: {unit?.name ?? 'Todas'}.
                    </p>
                </div>
            }
        >
            <Head title="Discarte Consolidado" />

            <div className="py-8">
                <div className="mx-auto max-w-7xl space-y-6 px-4 sm:px-6 lg:px-8">
                    <form
                        onSubmit={handleSubmit}
                        className="rounded-2xl bg-white p-4 shadow dark:bg-gray-800"
                    >
                        <div className="flex flex-wrap items-end gap-3">
                            <div>
                                <label className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                    Loja
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

                            <div>
                                <label className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                    Mes
                                </label>
                                <input
                                    type="month"
                                    value={data.month}
                                    onChange={(event) => setData('month', event.target.value)}
                                    className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                />
                            </div>

                            <button
                                type="submit"
                                disabled={processing}
                                className="rounded-xl bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-indigo-700 disabled:opacity-60"
                            >
                                Filtrar
                            </button>
                        </div>

                        <p className="mt-4 text-xs text-gray-500 dark:text-gray-300">
                            Referencia: {monthLabel ?? '--'}.
                        </p>
                    </form>

                    <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                        <SummaryCard
                            title="Itens distintos"
                            value={String(summary?.products_count ?? 0)}
                            description="Produtos agrupados no filtro atual."
                            accentClass="text-indigo-700 dark:text-indigo-300"
                        />
                        <SummaryCard
                            title="Quantidade descartada"
                            value={formatQuantity(summary?.total_quantity ?? 0)}
                            description="Soma de todas as quantidades descartadas."
                            accentClass="text-rose-700 dark:text-rose-300"
                        />
                        <SummaryCard
                            title="Valor total"
                            value={formatCurrency(summary?.total_value ?? 0)}
                            description="Total financeiro estimado dos descartes."
                            accentClass="text-emerald-700 dark:text-emerald-300"
                        />
                        <SummaryCard
                            title="Item lider"
                            value={topProduct?.product ?? 'Nenhum'}
                            description={
                                topProduct
                                    ? `${formatQuantity(topProduct.total_quantity)} descartados em ${topProduct.occurrences} registros`
                                    : 'Nenhum descarte encontrado no filtro.'
                            }
                            accentClass="text-amber-700 dark:text-amber-300"
                        />
                    </section>

                    <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
                        <div className="flex flex-wrap items-center justify-between gap-3">
                            <div>
                                <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                                    Ranking de descarte
                                </h3>
                                <p className="text-sm text-gray-500 dark:text-gray-300">
                                    Ordenado pelos itens com maior quantidade descartada.
                                </p>
                            </div>
                            <div className="rounded-xl border border-indigo-100 bg-indigo-50 px-3 py-2 text-indigo-700 shadow-sm dark:border-indigo-500/30 dark:bg-indigo-500/10 dark:text-indigo-200">
                                <p className="text-[10px] font-semibold uppercase tracking-wide">
                                    Registros agrupados
                                </p>
                                <p className="text-sm font-bold">
                                    {summary?.total_occurrences ?? 0}
                                </p>
                            </div>
                        </div>

                        {rows.length === 0 ? (
                            <p className="mt-4 rounded-xl border border-dashed border-gray-200 px-4 py-6 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-300">
                                Nenhum descarte encontrado para o filtro selecionado.
                            </p>
                        ) : (
                            <div className="mt-4 overflow-x-auto">
                                <table className="min-w-full divide-y divide-gray-200 text-sm dark:divide-gray-700">
                                    <thead className="bg-gray-100 dark:bg-gray-900/60">
                                        <tr>
                                            <th className="px-3 py-2 text-center font-medium text-gray-600 dark:text-gray-300">
                                                Rank
                                            </th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                                                Produto
                                            </th>
                                            <th className="px-3 py-2 text-center font-medium text-gray-600 dark:text-gray-300">
                                                Registros
                                            </th>
                                            <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                                                Quantidade
                                            </th>
                                            <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                                                Valor medio
                                            </th>
                                            <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                                                Valor total
                                            </th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                                                Ultimo descarte
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
                                        {rows.map((row) => (
                                            <tr
                                                key={`${row.product_id ?? row.product}-${row.rank}`}
                                                className={row.rank === 1 ? 'bg-amber-50/60 dark:bg-amber-500/10' : ''}
                                            >
                                                <td className="px-3 py-2 text-center font-bold text-gray-700 dark:text-gray-200">
                                                    {row.rank}
                                                </td>
                                                <td className="px-3 py-2 text-gray-800 dark:text-gray-100">
                                                    <div className="font-semibold">{row.product}</div>
                                                    {row.rank === 1 ? (
                                                        <div className="text-xs text-amber-700 dark:text-amber-300">
                                                            Item mais descartado do filtro
                                                        </div>
                                                    ) : null}
                                                </td>
                                                <td className="px-3 py-2 text-center text-gray-700 dark:text-gray-200">
                                                    {row.occurrences}
                                                </td>
                                                <td className="px-3 py-2 text-right font-semibold text-gray-900 dark:text-gray-100">
                                                    {formatQuantity(row.total_quantity)}
                                                </td>
                                                <td className="px-3 py-2 text-right text-gray-700 dark:text-gray-200">
                                                    {formatCurrency(row.average_unit_price)}
                                                </td>
                                                <td className="px-3 py-2 text-right font-semibold text-emerald-700 dark:text-emerald-300">
                                                    {formatCurrency(row.total_value)}
                                                </td>
                                                <td className="px-3 py-2 text-gray-700 dark:text-gray-200">
                                                    {formatDateTime(row.last_discard_at)}
                                                </td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
