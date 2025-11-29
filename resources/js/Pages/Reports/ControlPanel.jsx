import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';

const formatCurrency = (value) =>
    Number(value ?? 0).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });

const MetricCard = ({ title, value, description, accent }) => (
    <div className="rounded-2xl border border-gray-100 bg-white/90 p-5 shadow-sm backdrop-blur dark:border-gray-700 dark:bg-gray-900/70">
        <p className="text-sm font-medium text-gray-500 dark:text-gray-300">{title}</p>
        <p className="mt-2 text-3xl font-bold" style={{ color: accent ?? '#111827' }}>
            {formatCurrency(value)}
        </p>
        {description && (
            <p className="mt-2 text-sm text-gray-500 dark:text-gray-300">{description}</p>
        )}
    </div>
);

export default function ControlPanel({ unit, period, metrics, filterUnits = [], selectedUnitId = null }) {
    const safeMetrics = {
        total_sales: metrics?.total_sales ?? 0,
        total_vale: metrics?.total_vale ?? 0,
        total_refeicao: metrics?.total_refeicao ?? 0,
        net_sales: metrics?.net_sales ?? 0,
        total_advances: metrics?.total_advances ?? 0,
        total_payroll: metrics?.total_payroll ?? 0,
        net_payroll: metrics?.net_payroll ?? 0,
    };

    const headerContent = (
        <div>
            <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                Controle financeiro
            </h2>
            <p className="text-sm text-gray-500 dark:text-gray-300">
                Consolidado mensal da unidade{' '}
                <span className="font-semibold text-gray-700 dark:text-gray-100">
                    {unit?.name ?? '---'}
                </span>{' '}
                ({period?.label ?? ''})
            </p>
        </div>
    );

    const unitsOptions = [
        { id: null, name: 'Todas as unidades' },
        ...filterUnits,
    ].filter(
        (option, index, self) => index === self.findIndex((item) => item.id === option.id),
    );

    const handleFilter = (unitId) => {
        router.get(
            route('reports.control'),
            { unit_id: unitId ?? '' },
            {
                preserveState: true,
                preserveScroll: true,
                replace: true,
            },
        );
    };

    return (
        <AuthenticatedLayout header={headerContent}>
            <Head title="Controle financeiro" />

            <div className="py-12">
                <div className="mx-auto max-w-7xl space-y-8 px-4 sm:px-6 lg:px-8">
                    <section className="rounded-3xl bg-white p-6 shadow ring-1 ring-gray-100 dark:bg-gray-800 dark:ring-gray-700">
                        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                            <div>
                                <p className="text-sm font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-300">
                                    Filtro
                                </p>
                                <p className="text-sm text-gray-500 dark:text-gray-300">
                                    Escolha a unidade para visualizar os dados mensais.
                                </p>
                            </div>
                            <div className="flex flex-wrap gap-2">
                                {unitsOptions.map((option) => {
                                    const isActive =
                                        (option.id === null && selectedUnitId === null) ||
                                        option.id === selectedUnitId;

                                    return (
                                        <button
                                            key={option.id ?? 'all'}
                                            type="button"
                                            onClick={() => handleFilter(option.id)}
                                            className={`rounded-full px-4 py-2 text-sm font-semibold shadow transition focus:outline-none focus:ring-2 focus:ring-indigo-400 ${
                                                isActive
                                                    ? 'bg-indigo-600 text-white'
                                                    : 'bg-gray-100 text-gray-700 dark:bg-gray-900 dark:text-gray-200'
                                            }`}
                                        >
                                            {option.name}
                                        </button>
                                    );
                                })}
                            </div>
                        </div>
                    </section>

                    <section className="space-y-6 rounded-3xl bg-gradient-to-br from-indigo-50 via-white to-white p-8 shadow-xl ring-1 ring-indigo-100 dark:from-slate-900 dark:via-gray-900 dark:to-gray-900 dark:ring-gray-800">
                        <div>
                            <p className="text-sm font-semibold uppercase tracking-wide text-indigo-600 dark:text-indigo-300">
                                Vendas
                            </p>
                            <h3 className="mt-1 text-2xl font-bold text-gray-900 dark:text-white">
                                Resultado operacional
                            </h3>
                            <p className="text-sm text-gray-600 dark:text-gray-300">
                                Considera todas as vendas do mês corrente, destacando o impacto dos vales e
                                refeições.
                            </p>
                        </div>

                        <div className="grid gap-5 md:grid-cols-2 lg:grid-cols-4">
                            <MetricCard
                                title="Faturamento bruto"
                                value={safeMetrics.total_sales}
                                description="Todas as vendas registradas no período"
                                accent="#4338ca"
                            />
                            <MetricCard
                                title="Total em vales"
                                value={safeMetrics.total_vale}
                                description="Vendas lançadas como vale tradicional"
                                accent="#f97316"
                            />
                            <MetricCard
                                title="Total em refeição"
                                value={safeMetrics.total_refeicao}
                                description="Consumos abatidos do saldo de refeição"
                                accent="#d97706"
                            />
                            <MetricCard
                                title="Faturamento líquido"
                                value={safeMetrics.net_sales}
                                description="Bruto menos vales e refeição"
                                accent="#16a34a"
                            />
                        </div>
                    </section>

                    <section className="space-y-6 rounded-3xl bg-white p-8 shadow-xl ring-1 ring-gray-100 dark:bg-gray-800 dark:ring-gray-700">
                        <div>
                            <p className="text-sm font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-300">
                                Pessoas
                            </p>
                            <h3 className="mt-1 text-2xl font-bold text-gray-900 dark:text-white">
                                Folha e benefícios
                            </h3>
                            <p className="text-sm text-gray-600 dark:text-gray-300">
                                Considera colaboradores atribuídos à unidade selecionada.
                            </p>
                        </div>

                        <div className="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
                            <MetricCard
                                title="Adiantamentos concedidos"
                                value={safeMetrics.total_advances}
                                description="Somatório de adiantamentos no mês"
                                accent="#0ea5e9"
                            />
                            <MetricCard
                                title="Folha bruta"
                                value={safeMetrics.total_payroll}
                                description="Soma dos salários dos colaboradores da unidade"
                                accent="#334155"
                            />
                            <MetricCard
                                title="Folha líquida"
                                value={safeMetrics.net_payroll}
                                description="Folha bruta - vales - refeição - adiantamentos"
                                accent="#22c55e"
                            />
                        </div>
                    </section>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
