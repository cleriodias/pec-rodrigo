import AlertMessage from '@/Components/Alert/AlertMessage';
import PrimaryButton from '@/Components/Button/PrimaryButton';
import InputError from '@/Components/InputError';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { formatReceiptCurrency } from '@/Utils/receipt';
import { Head, Link, router, useForm, usePage } from '@inertiajs/react';

const inputClassName =
    'mt-2 block h-12 w-full rounded-[18px] border border-slate-200 bg-white px-4 text-sm text-slate-900 shadow-sm transition focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200 dark:border-slate-600 dark:bg-gray-700 dark:text-gray-100';

const panelClassName =
    'rounded-[24px] border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-700 dark:bg-gray-800';

const toInputValue = (value) => {
    if (value === null || value === undefined || value === '') {
        return '';
    }

    return Number(value).toFixed(2);
};

const PeriodLimitCard = ({ title, summary }) => {
    const percentage = Number(summary?.percentage ?? 0);
    const hasLimit = summary?.limit !== null && summary?.limit !== undefined;
    const exceeded = Boolean(summary?.exceeded);

    return (
        <section className={panelClassName}>
            <div className="flex items-start justify-between gap-4">
                <div>
                    <p className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-500 dark:text-slate-300">
                        {title}
                    </p>
                    <p className="mt-3 text-2xl font-semibold text-slate-900 dark:text-slate-100">
                        {formatReceiptCurrency(summary?.total ?? 0)}
                    </p>
                </div>
                <span
                    className={`rounded-full px-3 py-1 text-xs font-semibold ${
                        exceeded
                            ? 'bg-rose-100 text-rose-700 dark:bg-rose-500/10 dark:text-rose-200'
                            : 'bg-emerald-100 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-200'
                    }`}
                >
                    {exceeded ? 'Limite atingido' : 'Dentro do limite'}
                </span>
            </div>
            <div className="mt-5">
                <div className="h-3 overflow-hidden rounded-full bg-slate-100 dark:bg-slate-700">
                    <div
                        className={`h-full rounded-full ${exceeded ? 'bg-rose-500' : 'bg-blue-600'}`}
                        style={{ width: `${hasLimit ? Math.min(100, percentage) : 0}%` }}
                    />
                </div>
                <div className="mt-3 flex flex-wrap justify-between gap-2 text-sm text-slate-600 dark:text-slate-300">
                    <span>Limite: {hasLimit ? formatReceiptCurrency(summary.limit) : 'Sem limite'}</span>
                    <span>Restante: {hasLimit ? formatReceiptCurrency(summary.remaining ?? 0) : '--'}</span>
                </div>
            </div>
        </section>
    );
};

export default function FiscalTaxLimit({
    auth,
    units = [],
    selectedUnitId = null,
    unit = null,
    configuration = {},
    summary = {},
    fiscalUnavailableMessage = null,
}) {
    const { flash = {} } = usePage().props;
    const { data, setData, post, processing, errors } = useForm({
        tb2_id: configuration?.tb2_id ?? selectedUnitId ?? '',
        tb26_limite_imposto_ativo: Boolean(configuration?.tb26_limite_imposto_ativo),
        tb26_limite_imposto_diario: toInputValue(configuration?.tb26_limite_imposto_diario),
        tb26_limite_imposto_mensal: toInputValue(configuration?.tb26_limite_imposto_mensal),
    });

    const handleSelectUnit = (unitId) => {
        router.get(route('settings.fiscal.tax-limit'), {
            unit_id: unitId,
        }, {
            preserveState: false,
            preserveScroll: true,
            replace: true,
        });
    };

    const handleSubmit = (event) => {
        event.preventDefault();

        post(route('settings.fiscal.tax-limit.update'), {
            preserveScroll: true,
        });
    };

    const blockedBy = configuration?.tb26_limite_imposto_bloqueado_por;
    const automaticGenerationEnabled = Boolean(configuration?.tb26_geracao_automatica_ativa);

    return (
        <AuthenticatedLayout
            user={auth.user}
            header={
                <div className="flex flex-col gap-1">
                    <h2 className="text-xl font-semibold text-gray-800 dark:text-gray-100">
                        Configuracao Limite Imposto
                    </h2>
                    <p className="text-sm text-gray-500 dark:text-gray-300">
                        Controle o volume diario e mensal de notas assinadas por unidade.
                    </p>
                </div>
            }
        >
            <Head title="Configuracao Limite Imposto" />
            <div className="py-8">
                <div className="mx-auto max-w-7xl space-y-6 px-4 sm:px-6 lg:px-8">
                    <AlertMessage message={flash} />

                    <section className={panelClassName}>
                        <div className="flex flex-col gap-4">
                            <div className="flex flex-wrap items-start justify-between gap-3">
                                <div>
                                    <h3 className="text-lg font-semibold text-gray-900 dark:text-gray-100">Unidade</h3>
                                    <p className="text-sm text-gray-500 dark:text-gray-300">
                                        Selecione a loja para ajustar os limites fiscais.
                                    </p>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    <Link
                                        href={route('settings.fiscal', selectedUnitId ? { unit_id: selectedUnitId } : {})}
                                        className="inline-flex items-center rounded-full border border-slate-200 bg-slate-50 px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-slate-300 hover:bg-slate-100 dark:border-slate-600 dark:bg-slate-700 dark:text-slate-100"
                                    >
                                        Voltar fiscal
                                    </Link>
                                    <Link
                                        href={route('settings.nfe', selectedUnitId ? { unit_id: selectedUnitId } : {})}
                                        className="inline-flex items-center rounded-full border border-blue-200 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 transition hover:border-blue-300 hover:bg-blue-100 dark:border-blue-500/30 dark:bg-blue-500/10 dark:text-blue-200"
                                    >
                                        Abrir NFe
                                    </Link>
                                </div>
                            </div>
                            <div className="flex flex-wrap gap-3">
                                {units.map((store) => {
                                    const isActive = Number(selectedUnitId) === Number(store.id);

                                    return (
                                        <button
                                            key={store.id}
                                            type="button"
                                            onClick={() => handleSelectUnit(store.id)}
                                            className={`rounded-full border px-5 py-3 text-sm font-semibold transition ${
                                                isActive
                                                    ? 'border-blue-500 bg-blue-50 text-blue-700 shadow-sm dark:border-blue-400 dark:bg-blue-500/10 dark:text-blue-200'
                                                    : 'border-gray-200 bg-white text-gray-700 hover:border-blue-300 hover:text-blue-700 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-200'
                                            }`}
                                        >
                                            {store.name}
                                        </button>
                                    );
                                })}
                            </div>
                        </div>
                    </section>

                    {fiscalUnavailableMessage && (
                        <div className="rounded-2xl border border-amber-200 bg-amber-50 px-4 py-4 text-sm text-amber-800 shadow dark:border-amber-500/30 dark:bg-amber-500/10 dark:text-amber-100">
                            {fiscalUnavailableMessage}
                        </div>
                    )}

                    {!selectedUnitId ? (
                        <div className="rounded-2xl border border-dashed border-gray-300 bg-white px-6 py-10 text-center text-sm text-gray-500 shadow dark:border-gray-700 dark:bg-gray-800 dark:text-gray-300">
                            Selecione uma unidade para configurar o limite de imposto.
                        </div>
                    ) : (
                        <>
                            <div className="grid gap-6 xl:grid-cols-[minmax(0,0.9fr)_minmax(0,1.1fr)]">
                                <section className={panelClassName}>
                                    <p className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-500 dark:text-slate-300">
                                        Loja selecionada
                                    </p>
                                    <h3 className="mt-3 text-xl font-semibold text-slate-900 dark:text-slate-100">
                                        {unit?.name ?? 'Unidade'}
                                    </h3>
                                    <p className="mt-2 text-sm text-slate-500 dark:text-slate-300">
                                        CNPJ: {unit?.cnpj ?? '--'}
                                    </p>
                                    <p className="mt-1 text-sm text-slate-500 dark:text-slate-300">
                                        {unit?.endereco ?? '--'}
                                    </p>
                                </section>

                                <section className={panelClassName}>
                                    <p className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-500 dark:text-slate-300">
                                        Status
                                    </p>
                                    <div className="mt-3 flex flex-wrap items-center gap-3">
                                        <span
                                            className={`rounded-full px-3 py-1 text-xs font-semibold ${
                                                automaticGenerationEnabled
                                                    ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-200'
                                                    : 'bg-rose-100 text-rose-700 dark:bg-rose-500/10 dark:text-rose-200'
                                            }`}
                                        >
                                            Geracao {automaticGenerationEnabled ? 'ativa' : 'desligada'}
                                        </span>
                                        {blockedBy && (
                                            <span className="rounded-full bg-amber-100 px-3 py-1 text-xs font-semibold text-amber-800 dark:bg-amber-500/10 dark:text-amber-100">
                                                Bloqueado por limite {blockedBy}
                                            </span>
                                        )}
                                    </div>
                                    {configuration?.tb26_limite_imposto_bloqueado_em && (
                                        <p className="mt-3 text-sm text-slate-600 dark:text-slate-300">
                                            Bloqueado em {configuration.tb26_limite_imposto_bloqueado_em}.
                                        </p>
                                    )}
                                </section>
                            </div>

                            <div className="grid gap-6 lg:grid-cols-2">
                                <PeriodLimitCard title="Hoje" summary={summary?.daily ?? {}} />
                                <PeriodLimitCard title="Mes atual" summary={summary?.monthly ?? {}} />
                            </div>

                            <form onSubmit={handleSubmit} className={panelClassName}>
                                <div className="flex flex-col gap-6">
                                    <label className="flex items-start justify-between gap-4 rounded-[22px] border border-slate-200 bg-slate-50 p-4 dark:border-slate-700 dark:bg-slate-900/40">
                                        <div>
                                            <p className="text-sm font-semibold text-slate-900 dark:text-slate-100">
                                                Controle de limite ativo
                                            </p>
                                            <p className="mt-1 text-sm text-slate-500 dark:text-slate-300">
                                                Quando o total de notas assinadas atingir o limite, a geracao automatica da unidade e desligada.
                                            </p>
                                        </div>
                                        <button
                                            type="button"
                                            onClick={() => setData('tb26_limite_imposto_ativo', !Boolean(data.tb26_limite_imposto_ativo))}
                                            className={`relative inline-flex h-8 w-14 shrink-0 items-center rounded-full transition ${
                                                data.tb26_limite_imposto_ativo ? 'bg-blue-600' : 'bg-slate-300 dark:bg-slate-600'
                                            }`}
                                            aria-pressed={Boolean(data.tb26_limite_imposto_ativo)}
                                        >
                                            <span className="sr-only">Alternar controle de limite de imposto</span>
                                            <span
                                                className={`inline-block h-6 w-6 transform rounded-full bg-white transition ${
                                                    data.tb26_limite_imposto_ativo ? 'translate-x-7' : 'translate-x-1'
                                                }`}
                                            />
                                        </button>
                                    </label>
                                    <InputError message={errors.tb26_limite_imposto_ativo} />

                                    <div className="grid gap-5 md:grid-cols-2">
                                        <div>
                                            <label className="text-sm font-medium text-slate-700 dark:text-slate-200">
                                                Limite diario
                                            </label>
                                            <input
                                                type="number"
                                                min="0"
                                                step="0.01"
                                                value={data.tb26_limite_imposto_diario}
                                                onChange={(event) => setData('tb26_limite_imposto_diario', event.target.value)}
                                                className={inputClassName}
                                                placeholder="Sem limite"
                                            />
                                            <InputError message={errors.tb26_limite_imposto_diario} className="mt-2" />
                                        </div>
                                        <div>
                                            <label className="text-sm font-medium text-slate-700 dark:text-slate-200">
                                                Limite mensal
                                            </label>
                                            <input
                                                type="number"
                                                min="0"
                                                step="0.01"
                                                value={data.tb26_limite_imposto_mensal}
                                                onChange={(event) => setData('tb26_limite_imposto_mensal', event.target.value)}
                                                className={inputClassName}
                                                placeholder="Sem limite"
                                            />
                                            <InputError message={errors.tb26_limite_imposto_mensal} className="mt-2" />
                                        </div>
                                    </div>

                                    <input type="hidden" value={data.tb2_id} />
                                    <div className="flex justify-end">
                                        <PrimaryButton
                                            type="submit"
                                            disabled={processing || Boolean(fiscalUnavailableMessage)}
                                            className="px-6 py-3 text-sm font-semibold normal-case tracking-normal"
                                        >
                                            Salvar limite
                                        </PrimaryButton>
                                    </div>
                                </div>
                            </form>
                        </>
                    )}
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
