import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import {
    formatBrazilShortDate,
    formatBrazilTime,
    isoToBrazilShortDateInput,
    normalizeBrazilShortDateInput,
    shortBrazilDateInputToIso,
} from '@/Utils/date';
import { Head, useForm } from '@inertiajs/react';

const STATUS_CLASS = {
    Assinada: 'border-emerald-200 bg-emerald-50 text-emerald-700 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-200',
    Erro: 'border-rose-200 bg-rose-50 text-rose-700 dark:border-rose-500/30 dark:bg-rose-500/10 dark:text-rose-200',
    Emitida: 'border-blue-200 bg-blue-50 text-blue-700 dark:border-blue-500/30 dark:bg-blue-500/10 dark:text-blue-200',
};

const formatCurrency = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });

const formatDateTime = (value) => (value ? `${formatBrazilShortDate(value)} ${formatBrazilTime(value)}` : '--');

const statusClassName = (label) =>
    `inline-flex rounded-full border px-3 py-1 text-xs font-semibold ${
        STATUS_CLASS[label] ?? 'border-slate-200 bg-slate-50 text-slate-700 dark:border-slate-600 dark:bg-slate-700 dark:text-slate-100'
    }`;

export default function FiscalInvoicesReport({
    rows = [],
    startDate,
    endDate,
    unit,
    filterUnits = [],
    selectedUnitId = null,
    selectedStatus = 'all',
    statusOptions = [],
}) {
    const { data, setData, get, processing } = useForm({
        start_date: isoToBrazilShortDateInput(startDate ?? ''),
        end_date: isoToBrazilShortDateInput(endDate ?? ''),
        unit_id:
            selectedUnitId !== null && selectedUnitId !== undefined
                ? String(selectedUnitId)
                : 'all',
        status: selectedStatus ?? 'all',
    });

    const totalAmount = rows.reduce((sum, row) => sum + (Number(row.total) || 0), 0);

    const handleSubmit = (event) => {
        event.preventDefault();

        get(route('reports.notas-fiscais-emitidas'), {
            preserveState: true,
            preserveScroll: true,
            replace: true,
            data: {
                start_date: shortBrazilDateInputToIso(data.start_date) || undefined,
                end_date: shortBrazilDateInputToIso(data.end_date) || undefined,
                unit_id: data.unit_id,
                status: data.status,
            },
        });
    };

    return (
        <AuthenticatedLayout
            header={
                <div>
                    <h2 className="text-xl font-semibold text-gray-800 dark:text-gray-100">
                        Notas Fiscais Emitidas
                    </h2>
                    <p className="text-sm text-gray-500 dark:text-gray-300">
                        Relatorio de notas fiscais por loja, situacao e periodo. Unidade atual: {unit?.name ?? '---'}.
                    </p>
                </div>
            }
        >
            <Head title="Notas Fiscais Emitidas" />

            <div className="py-8">
                <div className="mx-auto max-w-7xl space-y-6 px-4 sm:px-6 lg:px-8">
                    <form
                        onSubmit={handleSubmit}
                        className="rounded-2xl bg-white p-4 shadow dark:bg-gray-800"
                    >
                        <div className="flex flex-wrap items-end gap-3">
                            <div>
                                <label className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                    Inicio
                                </label>
                                <input
                                    type="text"
                                    inputMode="numeric"
                                    value={data.start_date}
                                    onChange={(event) => setData('start_date', normalizeBrazilShortDateInput(event.target.value))}
                                    placeholder="DD/MM/AA"
                                    className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                />
                            </div>
                            <div>
                                <label className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                    Fim
                                </label>
                                <input
                                    type="text"
                                    inputMode="numeric"
                                    value={data.end_date}
                                    onChange={(event) => setData('end_date', normalizeBrazilShortDateInput(event.target.value))}
                                    placeholder="DD/MM/AA"
                                    className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                />
                            </div>
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
                                    Situacao
                                </label>
                                <select
                                    value={data.status}
                                    onChange={(event) => setData('status', event.target.value)}
                                    className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                >
                                    {statusOptions.map((option) => (
                                        <option key={option.value} value={option.value}>
                                            {option.label}
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

                    <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
                        <div className="flex flex-wrap items-center justify-between gap-3">
                            <div>
                                <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                                    Notas fiscais
                                </h3>
                                <p className="text-sm text-gray-500 dark:text-gray-300">
                                    A data do filtro considera a criacao do registro fiscal.
                                </p>
                            </div>
                            <div className="flex flex-wrap items-center gap-3">
                                <span className="text-xs font-semibold text-gray-500 dark:text-gray-300">
                                    {rows.length} registro(s)
                                </span>
                                <div className="rounded-xl border border-indigo-100 bg-indigo-50 px-3 py-2 text-indigo-700 shadow-sm dark:border-indigo-500/30 dark:bg-indigo-500/10 dark:text-indigo-200">
                                    <p className="text-[10px] font-semibold uppercase tracking-wide">
                                        Total filtrado
                                    </p>
                                    <p className="text-sm font-bold">
                                        {formatCurrency(totalAmount)}
                                    </p>
                                </div>
                            </div>
                        </div>

                        {rows.length === 0 ? (
                            <p className="mt-4 rounded-xl border border-dashed border-gray-200 px-4 py-6 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-300">
                                Nenhuma nota fiscal para os filtros selecionados.
                            </p>
                        ) : (
                            <div className="mt-4 overflow-x-auto">
                                <table className="min-w-full divide-y divide-gray-200 text-sm dark:divide-gray-700">
                                    <thead className="bg-gray-100 dark:bg-gray-900/60">
                                        <tr>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Venda</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Loja</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Situacao</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Modelo</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Serie/Numero</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Criada em</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Emitida em</th>
                                            <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">Valor</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Pagamento</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Caixa</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Chave</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Protocolo</th>
                                            <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">Mensagem</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
                                        {rows.map((row) => (
                                            <tr key={row.id}>
                                                <td className="px-3 py-3 font-semibold text-gray-900 dark:text-gray-100">
                                                    #{row.payment_id}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {row.unit_name ?? '--'}
                                                </td>
                                                <td className="px-3 py-3">
                                                    <span className={statusClassName(row.status_label)}>
                                                        {row.status_label ?? '--'}
                                                    </span>
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {String(row.modelo ?? '').toUpperCase() || '--'}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {row.serie || row.numero ? `${row.serie ?? '--'}/${row.numero ?? '--'}` : '--'}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {formatDateTime(row.created_at)}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {formatDateTime(row.issued_at)}
                                                </td>
                                                <td className="px-3 py-3 text-right font-semibold text-gray-900 dark:text-gray-100">
                                                    {formatCurrency(row.total)}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {row.payment_type ?? '--'}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {row.cashier ?? '--'}
                                                </td>
                                                <td className="max-w-[18rem] break-all px-3 py-3 font-mono text-xs text-gray-700 dark:text-gray-200">
                                                    {row.access_key ?? '--'}
                                                </td>
                                                <td className="px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {row.protocol ?? '--'}
                                                </td>
                                                <td className="min-w-[18rem] px-3 py-3 text-gray-700 dark:text-gray-200">
                                                    {row.message ?? row.items_label ?? '--'}
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
