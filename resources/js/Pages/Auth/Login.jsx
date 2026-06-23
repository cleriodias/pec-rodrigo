import Checkbox from '@/Components/Checkbox';
import InputError from '@/Components/InputError';
import InputLabel from '@/Components/InputLabel';
import TextInput from '@/Components/TextInput';
import GuestLayout from '@/Layouts/GuestLayout';
import { Head, Link, useForm } from '@inertiajs/react';
import { useEffect, useRef } from 'react';

export default function Login({ status, canResetPassword, units = [], selectedUnitId = null }) {
    const { data, setData, post, processing, errors, reset } = useForm({
        username: '',
        password: '',
        remember: false,
        unit_id: selectedUnitId ? String(selectedUnitId) : '',
    });
    const formRef = useRef(null);

    useEffect(() => {
        if (selectedUnitId) {
            setData('unit_id', String(selectedUnitId));
        }
    }, [selectedUnitId]);

    const handleSubmit = (event) => {
        event.preventDefault();

        post(route('login'), {
            onFinish: () => reset('password'),
        });
    };

    const handleUnitSelect = (unitId) => {
        setData('unit_id', String(unitId));

        if (data.username && data.password) {
            window.requestAnimationFrame(() => {
                formRef.current?.requestSubmit?.();
            });
        }
    };

    const selectedUnit = units.find((unit) => String(unit.tb2_id) === String(data.unit_id));

    return (
        <GuestLayout>
            <Head title="Login - SYSPDV" />

            <div className="grid gap-6 xl:grid-cols-[0.95fr_1.05fr]">
                <section className="rounded-[32px] border border-slate-200 bg-slate-950 p-6 text-white shadow-[0_20px_60px_rgba(15,23,42,0.22)]">
                    <p className="text-xs font-semibold uppercase tracking-[0.25em] text-sky-300">SYSPDV</p>
                    <h1 className="mt-4 max-w-xl text-4xl font-semibold leading-tight" style={{ fontFamily: "'Inter', sans-serif" }}>
                        Acesso por unidade, matriz e filial
                    </h1>
                    <p className="mt-4 max-w-xl text-sm leading-7 text-slate-300">
                        Entre com usuário, senha e unidade para abrir o painel operacional correto.
                    </p>

                    <div className="mt-8 grid gap-3 sm:grid-cols-2">
                        <div className="rounded-[24px] border border-white/10 bg-white/5 p-4">
                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-300">Portal</p>
                            <p className="mt-2 text-2xl font-semibold">Rede</p>
                            <p className="mt-1 text-sm text-slate-400">Acesso centralizado por matriz.</p>
                        </div>
                        <div className="rounded-[24px] border border-white/10 bg-white/5 p-4">
                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-300">Operação</p>
                            <p className="mt-2 text-2xl font-semibold">Segura</p>
                            <p className="mt-1 text-sm text-slate-400">Dados vinculados à unidade certa.</p>
                        </div>
                    </div>

                    <div className="mt-8 rounded-[28px] border border-white/10 bg-white/5 p-5">
                        <p className="text-sm leading-7 text-slate-200">
                            O login direciona cada usuário para a matriz selecionada, preservando o vínculo com
                            unidades e registros do sistema.
                        </p>
                    </div>
                </section>

                <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-[0_20px_60px_rgba(15,76,129,0.08)] backdrop-blur">
                    {status && (
                        <div className="mb-5 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-medium text-emerald-700">
                            {status}
                        </div>
                    )}

                    <div className="mb-6 flex items-center justify-between gap-4">
                        <div>
                            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-sky-700">
                                Login do sistema
                            </p>
                            <h2 className="mt-2 text-2xl font-semibold text-slate-950">Selecione a unidade e entre</h2>
                        </div>
                        <Link
                            href="/"
                            className="rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-slate-600 transition hover:border-sky-200 hover:text-sky-700"
                        >
                            Voltar
                        </Link>
                    </div>

                    <form ref={formRef} onSubmit={handleSubmit} className="space-y-5">
                        <div>
                            <InputLabel htmlFor="username" value="Usuário" />
                            <div className="mt-2 flex overflow-hidden rounded-2xl border border-slate-200 bg-white focus-within:border-sky-300 focus-within:ring-4 focus-within:ring-sky-100">
                                <TextInput
                                    id="username"
                                    type="text"
                                    name="username"
                                    placeholder="Usuário"
                                    value={data.username}
                                    className="block w-full border-0 bg-transparent px-4 py-3 shadow-none focus:border-0 focus:ring-0"
                                    autoComplete="username"
                                    isFocused={true}
                                    onChange={(e) => setData('username', e.target.value)}
                                />
                                <span className="inline-flex items-center border-s border-slate-200 bg-slate-50 px-3 text-sm font-semibold text-slate-600">
                                    @paoecafe83.com.br
                                </span>
                            </div>
                            <InputError message={errors.username} className="mt-2" />
                        </div>

                        <div>
                            <InputLabel htmlFor="password" value="Senha" />
                            <TextInput
                                id="password"
                                type="password"
                                name="password"
                                placeholder="Senha"
                                value={data.password}
                                className="mt-2 block w-full rounded-2xl border-slate-200 px-4 py-3 focus:border-sky-300 focus:ring-sky-100"
                                autoComplete="current-password"
                                onChange={(e) => setData('password', e.target.value)}
                            />
                            <InputError message={errors.password} className="mt-2" />
                        </div>

                        <div className="flex items-center justify-between gap-4">
                            <label className="flex items-center">
                                <Checkbox
                                    name="remember"
                                    checked={data.remember}
                                    onChange={(e) => setData('remember', e.target.checked)}
                                />
                                <span className="ms-2 text-sm text-slate-600">Lembrar acesso</span>
                            </label>

                            {canResetPassword && (
                                <Link
                                    href={route('password.request')}
                                    className="text-sm font-medium text-slate-600 no-underline hover:text-slate-900"
                                >
                                    Esqueceu a senha?
                                </Link>
                            )}
                        </div>

                        <div>
                            <div className="mb-3 flex items-center justify-between gap-4">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-slate-500">
                                    Selecione a unidade
                                </p>
                                <span className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-400">
                                    {units.length} cadastradas
                                </span>
                            </div>

                            {units.length ? (
                                <div className="grid gap-3 sm:grid-cols-2">
                                    {units.map((unit) => {
                                        const isSelected = String(data.unit_id) === String(unit.tb2_id);

                                        return (
                                            <button
                                                type="button"
                                                key={unit.tb2_id}
                                                disabled={processing}
                                                onClick={() => handleUnitSelect(unit.tb2_id)}
                                                className={`rounded-2xl border px-4 py-3 text-left text-sm font-semibold transition duration-150 ease-in-out focus:outline-none focus:ring-4 focus:ring-sky-100 disabled:opacity-50 ${
                                                    isSelected
                                                        ? 'border-sky-600 bg-sky-600 text-white shadow-lg shadow-sky-900/15'
                                                        : 'border-slate-200 bg-white text-slate-700 hover:border-sky-200 hover:bg-sky-50'
                                                }`}
                                            >
                                                <div className="flex flex-col gap-1">
                                                    <span>{unit.tb2_nome}</span>
                                                    {unit.matriz?.tb30_nome && (
                                                        <span
                                                            className={`inline-flex w-fit items-center rounded-full px-2 py-0.5 text-[10px] font-semibold ${
                                                                isSelected
                                                                    ? 'bg-white/20 text-white'
                                                                    : 'bg-slate-100 text-slate-600'
                                                            }`}
                                                        >
                                                            Matriz: {unit.matriz.tb30_nome}
                                                        </span>
                                                    )}
                                                </div>
                                            </button>
                                        );
                                    })}
                                </div>
                            ) : (
                                <p className="rounded-2xl border border-dashed border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-600">
                                    Nenhuma unidade cadastrada.
                                </p>
                            )}
                            <InputError message={errors.unit_id} className="mt-2" />
                        </div>

                        <div className="flex items-center justify-between gap-4 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-4">
                            <p className="text-xs text-slate-500">
                                {selectedUnit
                                    ? `Unidade selecionada: ${selectedUnit.tb2_nome}`
                                    : 'Selecione uma unidade para entrar.'}
                            </p>
                            <button
                                type="submit"
                                disabled={processing || !data.unit_id}
                                className="rounded-2xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:opacity-60"
                            >
                                Entrar
                            </button>
                        </div>
                    </form>
                </section>
            </div>
        </GuestLayout>
    );
}
