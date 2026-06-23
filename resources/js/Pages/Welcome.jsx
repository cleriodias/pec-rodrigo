import React, { useMemo, useState } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';

const featureCards = [
    {
        title: 'Matriz e filiais',
        description: 'Estrutura pronta para trabalhar com unidades ligadas a uma matriz principal.',
        badge: 'Rede',
    },
    {
        title: 'Vendas e produtos',
        description: 'Portal preparado para operações, cadastros e leitura rápida do fluxo comercial.',
        badge: 'PDV',
    },
    {
        title: 'Usuarios e permissões',
        description: 'Acesso por unidade, mantendo o vínculo com a matriz correta em cada registro.',
        badge: 'Acesso',
    },
    {
        title: 'Adiantamentos e vales',
        description: 'Área pensada para rotinas de funcionários, controles e acompanhamento financeiro.',
        badge: 'Financeiro',
    },
];

export default function Welcome({ units = [], flash = {}, selectedUnitId = null }) {
    const currentYear = new Date().getFullYear();
    const appName = import.meta.env.VITE_APP_NAME || 'SYSPDV';
    const loginUrl = selectedUnitId ? route('login', { l: selectedUnitId }) : route('login');
    const {
        data,
        setData,
        post,
        processing,
        errors,
        reset,
        recentlySuccessful,
    } = useForm({
        name: '',
        phone: '',
    });
    const [showContactForm, setShowContactForm] = useState(false);

    const validUnits = useMemo(
        () =>
            units.filter((unit) => {
                const cepDigits = String(unit.tb2_cep || '').replace(/\D/g, '');
                return cepDigits.length === 8;
            }),
        [units],
    );

    const featuredUnits = validUnits.slice(0, 4);
    const primaryUnit = validUnits[0] || null;
    const successText =
        flash?.success ||
        (recentlySuccessful ? 'Cadastro recebido. Vamos entrar em contato em breve.' : '');
    const showNewsletterForm = showContactForm || Boolean(errors.name || errors.phone || successText);

    const getMapEmbedUrl = (value) => {
        if (!value) {
            return null;
        }

        try {
            const url = new URL(value);
            const host = url.hostname.replace(/^www\./, '');
            const isGoogleHost =
                host === 'google.com' || host.endsWith('.google.com') || host === 'maps.google.com';

            if (!isGoogleHost) {
                return null;
            }

            if (url.pathname.includes('/maps/embed') || url.searchParams.get('output') === 'embed') {
                return url.toString();
            }

            const query = url.searchParams.get('q') || url.searchParams.get('query');
            if (query) {
                return `https://www.google.com/maps?q=${encodeURIComponent(query)}&output=embed`;
            }

            const placeMatch = url.pathname.match(/\/maps\/place\/([^/]+)/);
            if (placeMatch) {
                const place = placeMatch[1].replace(/\+/g, ' ');
                return `https://www.google.com/maps?q=${encodeURIComponent(place)}&output=embed`;
            }

            const searchMatch = url.pathname.match(/\/maps\/search\/([^/]+)/);
            if (searchMatch) {
                const search = searchMatch[1].replace(/\+/g, ' ');
                return `https://www.google.com/maps?q=${encodeURIComponent(search)}&output=embed`;
            }

            const coordsMatch = url.pathname.match(/\/maps\/@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)/);
            if (coordsMatch) {
                const coords = `${coordsMatch[1]},${coordsMatch[2]}`;
                return `https://www.google.com/maps?q=${encodeURIComponent(coords)}&output=embed`;
            }
        } catch (error) {
            return null;
        }

        return null;
    };

    const primaryMapUrl = getMapEmbedUrl(primaryUnit?.tb2_localizacao);

    const submitNewsletter = (event) => {
        event.preventDefault();
        post(route('newsletter.store'), {
            preserveScroll: true,
            onSuccess: () => {
                reset();
                setShowContactForm(true);
            },
        });
    };

    return (
        <>
            <Head title="SYSPDV">
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Space+Grotesk:wght@400;500;700&display=swap"
                    rel="stylesheet"
                />
            </Head>

            <div
                className="relative min-h-screen overflow-hidden bg-[var(--surface)] text-[var(--ink)]"
                style={{
                    fontFamily: "'Space Grotesk', sans-serif",
                    '--surface': '#eef4fb',
                    '--ink': '#0f172a',
                    '--panel': 'rgba(255,255,255,0.9)',
                    '--panel-strong': '#ffffff',
                    '--accent': '#0f4c81',
                    '--accent-2': '#1d7fd6',
                    '--line': 'rgba(15, 76, 129, 0.12)',
                }}
            >
                <div className="pointer-events-none absolute -top-28 right-0 h-80 w-80 rounded-full bg-sky-400/25 blur-[130px]" />
                <div className="pointer-events-none absolute left-0 top-32 h-72 w-72 rounded-full bg-indigo-500/15 blur-[120px]" />
                <div className="pointer-events-none absolute bottom-0 right-16 h-96 w-96 rounded-full bg-cyan-400/10 blur-[150px]" />
                <div className="pointer-events-none absolute inset-0 opacity-70 [background-image:linear-gradient(rgba(15,76,129,0.08)_1px,transparent_1px),linear-gradient(90deg,rgba(15,76,129,0.08)_1px,transparent_1px)] [background-size:56px_56px]" />

                <div className="relative mx-auto flex min-h-screen w-full max-w-7xl flex-col px-4 py-4 sm:px-6 lg:px-8">
                    <header className="flex flex-col gap-4 rounded-[28px] border border-white/70 bg-white/80 px-5 py-4 shadow-[0_18px_70px_rgba(15,76,129,0.08)] backdrop-blur sm:flex-row sm:items-center sm:justify-between">
                        <Link href="/" className="flex items-center gap-3">
                            <span className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[var(--accent)] text-sm font-black text-white shadow-lg shadow-sky-900/15">
                                SP
                            </span>
                            <span className="flex flex-col leading-tight">
                                <span className="text-xs font-semibold uppercase tracking-[0.28em] text-sky-700">
                                    SYSPDV
                                </span>
                                <span className="text-sm text-slate-500">Matriz, filiais, vendas e controle</span>
                            </span>
                        </Link>

                        <nav className="flex flex-wrap items-center gap-2">
                            <a
                                href="#unidades"
                                className="rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-slate-600 transition hover:border-sky-200 hover:text-sky-700"
                            >
                                Unidades
                            </a>
                            <a
                                href="#recursos"
                                className="rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-slate-600 transition hover:border-sky-200 hover:text-sky-700"
                            >
                                Recursos
                            </a>
                            <Link
                                href={loginUrl}
                                className="rounded-full bg-slate-900 px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-white transition hover:bg-slate-800"
                            >
                                Login
                            </Link>
                        </nav>
                    </header>

                    <main className="mt-6 grid gap-6 xl:grid-cols-[1.08fr_0.92fr]">
                        <section className="overflow-hidden rounded-[32px] border border-white/70 bg-[linear-gradient(135deg,rgba(255,255,255,0.98),rgba(238,244,251,0.92))] p-6 shadow-[0_20px_80px_rgba(15,76,129,0.08)] sm:p-8">
                            <div className="flex flex-wrap items-center gap-3">
                                <span className="inline-flex items-center rounded-full border border-sky-100 bg-sky-50 px-4 py-2 text-xs font-semibold uppercase tracking-[0.22em] text-sky-700">
                                    Portal operacional
                                </span>
                                <span className="inline-flex items-center rounded-full border border-slate-200 bg-white px-4 py-2 text-xs font-semibold uppercase tracking-[0.22em] text-slate-600">
                                    {appName}
                                </span>
                            </div>

                            <div className="mt-8 grid gap-8 lg:grid-cols-[1.05fr_0.95fr]">
                                <div>
                                    <p className="text-sm font-semibold uppercase tracking-[0.25em] text-sky-700">
                                        Gestão para rede
                                    </p>
                                    <h1
                                        className="mt-4 max-w-2xl text-4xl font-semibold leading-[1.05] text-slate-950 sm:text-5xl lg:text-6xl"
                                        style={{ fontFamily: "'Inter', sans-serif" }}
                                    >
                                        SYSPDV para matrizes e filiais, com controle central e acesso por unidade.
                                    </h1>
                                    <p className="mt-5 max-w-2xl text-base leading-7 text-slate-600 sm:text-lg">
                                        Uma interface de operação enxuta para acompanhar unidades, produtos, vendas,
                                        funcionários e rotinas administrativas sem perder o vínculo com a matriz.
                                    </p>

                                    <div className="mt-7 flex flex-wrap gap-3">
                                        <Link
                                            href={loginUrl}
                                            className="inline-flex items-center justify-center rounded-full bg-[var(--accent)] px-6 py-3 text-sm font-semibold text-white shadow-lg shadow-sky-900/15 transition hover:bg-[var(--accent-2)]"
                                        >
                                            Entrar no sistema
                                        </Link>
                                        <a
                                            href="#unidades"
                                            className="inline-flex items-center justify-center rounded-full border border-slate-200 bg-white px-6 py-3 text-sm font-semibold text-slate-700 transition hover:border-sky-200 hover:text-sky-800"
                                        >
                                            Ver unidades
                                        </a>
                                    </div>

                                    <div className="mt-8 grid gap-3 sm:grid-cols-3">
                                        <div className="rounded-3xl border border-white/80 bg-white/80 p-4 shadow-sm">
                                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500">
                                                Total de unidades
                                            </p>
                                            <p className="mt-2 text-3xl font-semibold text-slate-950">{validUnits.length}</p>
                                        </div>
                                        <div className="rounded-3xl border border-white/80 bg-white/80 p-4 shadow-sm">
                                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500">
                                                Acesso
                                            </p>
                                            <p className="mt-2 text-3xl font-semibold text-slate-950">Matriz</p>
                                        </div>
                                        <div className="rounded-3xl border border-white/80 bg-white/80 p-4 shadow-sm">
                                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500">
                                                Status
                                            </p>
                                            <p className="mt-2 text-3xl font-semibold text-slate-950">Ativo</p>
                                        </div>
                                    </div>
                                </div>

                                <div className="grid gap-4">
                                    <div className="rounded-[28px] border border-slate-200 bg-slate-950 p-5 text-white shadow-[0_18px_60px_rgba(15,23,42,0.2)]">
                                        <div className="flex items-center justify-between gap-4">
                                            <div>
                                                <p className="text-xs font-semibold uppercase tracking-[0.25em] text-sky-300">
                                                    Painel de rede
                                                </p>
                                                <p className="mt-2 text-lg font-semibold">Nossas Unidades</p>
                                            </div>
                                            <span className="rounded-full bg-white/10 px-3 py-1 text-xs font-semibold">
                                                {validUnits.length} unidade{validUnits.length === 1 ? '' : 's'}
                                            </span>
                                        </div>

                                        <div className="mt-5 space-y-3">
                                            {featuredUnits.map((unit) => (
                                                <div
                                                    key={unit.tb2_id}
                                                    className="rounded-2xl border border-white/10 bg-white/5 px-4 py-3"
                                                >
                                                    <div className="flex items-start justify-between gap-3">
                                                        <div>
                                                            <p className="font-semibold text-white">{unit.tb2_nome}</p>
                                                            <p className="mt-1 text-xs leading-5 text-slate-300">
                                                                {unit.tb2_endereco}
                                                            </p>
                                                        </div>
                                                        {unit.matriz?.tb30_nome && (
                                                            <span className="rounded-full bg-sky-400/15 px-3 py-1 text-[11px] font-semibold text-sky-200">
                                                                {unit.matriz.tb30_nome}
                                                            </span>
                                                        )}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="rounded-[24px] border border-white/70 bg-white/90 p-4 shadow-sm">
                                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500">
                                                Produtos
                                            </p>
                                            <p className="mt-2 text-2xl font-semibold text-slate-950">Cadastros</p>
                                            <p className="mt-2 text-sm text-slate-600">Código, unidade e matriz vinculados.</p>
                                        </div>
                                        <div className="rounded-[24px] border border-white/70 bg-white/90 p-4 shadow-sm">
                                            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500">
                                                Vendas
                                            </p>
                                            <p className="mt-2 text-2xl font-semibold text-slate-950">Fluxo</p>
                                            <p className="mt-2 text-sm text-slate-600">Registros por unidade e operação.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <aside className="grid gap-6">
                            <div className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-[0_20px_60px_rgba(15,76,129,0.08)] backdrop-blur">
                                <div className="flex items-center justify-between gap-4">
                                    <div>
                                        <p className="text-sm font-semibold uppercase tracking-[0.25em] text-sky-700">
                                            Acesso rápido
                                        </p>
                                        <h2 className="mt-2 text-2xl font-semibold text-slate-950">Entre no portal</h2>
                                    </div>
                                    <button
                                        type="button"
                                        onClick={() => setShowContactForm((prev) => !prev)}
                                        className="rounded-full bg-sky-50 px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-sky-700 transition hover:bg-sky-100"
                                    >
                                        Contato
                                    </button>
                                </div>

                                <p className="mt-4 text-sm leading-6 text-slate-600">
                                    Use o login para entrar no sistema operacional da rede e selecionar a unidade de trabalho.
                                </p>

                                <div className="mt-6">
                                    <Link
                                        href={loginUrl}
                                        className="inline-flex w-full items-center justify-center rounded-2xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-800"
                                    >
                                        Acessar login
                                    </Link>
                                </div>

                                {showNewsletterForm && (
                                    <form id="contact-form" className="mt-6 space-y-4" onSubmit={submitNewsletter}>
                                        <div>
                                            <label className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-500">
                                                Nome
                                            </label>
                                            <input
                                                type="text"
                                                name="name"
                                                value={data.name}
                                                autoComplete="name"
                                                placeholder="Seu nome"
                                                onChange={(event) => setData('name', event.target.value)}
                                                className="mt-2 w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-sky-300 focus:ring-4 focus:ring-sky-100"
                                            />
                                            {errors.name && <p className="mt-1 text-xs text-rose-600">{errors.name}</p>}
                                        </div>

                                        <div>
                                            <label className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-500">
                                                WhatsApp
                                            </label>
                                            <input
                                                type="tel"
                                                name="phone"
                                                value={data.phone}
                                                autoComplete="tel"
                                                inputMode="tel"
                                                placeholder="(00) 00000-0000"
                                                onChange={(event) => setData('phone', event.target.value)}
                                                className="mt-2 w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-800 outline-none transition focus:border-sky-300 focus:ring-4 focus:ring-sky-100"
                                            />
                                            {errors.phone && <p className="mt-1 text-xs text-rose-600">{errors.phone}</p>}
                                        </div>

                                        <button
                                            type="submit"
                                            disabled={processing}
                                            className="inline-flex w-full items-center justify-center rounded-2xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-white transition hover:bg-[var(--accent-2)] disabled:cursor-not-allowed disabled:opacity-60"
                                        >
                                            Receber contato
                                        </button>

                                        {successText && <p className="text-xs font-semibold text-emerald-600">{successText}</p>}
                                    </form>
                                )}
                            </div>

                            <div className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-[0_20px_60px_rgba(15,76,129,0.08)] backdrop-blur">
                                <div className="flex items-center justify-between gap-4">
                                    <div>
                                        <p className="text-sm font-semibold uppercase tracking-[0.25em] text-sky-700">
                                            Visualização
                                        </p>
                                        <h2 className="mt-2 text-2xl font-semibold text-slate-950">Mapa da matriz</h2>
                                    </div>
                                    <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">
                                        {primaryUnit?.matriz?.tb30_nome || 'Sistema'}
                                    </span>
                                </div>

                                {primaryMapUrl ? (
                                    <div className="mt-5 overflow-hidden rounded-[26px] border border-slate-200 bg-slate-50">
                                        <iframe
                                            title={`Mapa da unidade ${primaryUnit.tb2_nome}`}
                                            src={primaryMapUrl}
                                            loading="lazy"
                                            referrerPolicy="no-referrer-when-downgrade"
                                            className="h-64 w-full"
                                            style={{ border: 0 }}
                                            allowFullScreen
                                        />
                                    </div>
                                ) : (
                                    <div className="mt-5 rounded-[26px] border border-dashed border-slate-200 bg-slate-50 p-6 text-sm text-slate-600">
                                        Nenhuma unidade com mapa válido foi encontrada para exibição.
                                    </div>
                                )}
                            </div>
                        </aside>
                    </main>

                    <section id="recursos" className="mt-6 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                        {featureCards.map((card) => (
                            <article
                                key={card.title}
                                className="rounded-[28px] border border-white/70 bg-white/85 p-5 shadow-[0_12px_40px_rgba(15,76,129,0.06)] backdrop-blur"
                            >
                                <span className="inline-flex rounded-full bg-sky-50 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.2em] text-sky-700">
                                    {card.badge}
                                </span>
                                <h3 className="mt-4 text-lg font-semibold text-slate-950">{card.title}</h3>
                                <p className="mt-2 text-sm leading-6 text-slate-600">{card.description}</p>
                            </article>
                        ))}
                    </section>

                    <section id="unidades" className="mt-6 grid gap-6 lg:grid-cols-[1.05fr_0.95fr]">
                        <div className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-[0_20px_60px_rgba(15,76,129,0.08)] backdrop-blur">
                            <div className="flex items-center justify-between gap-4">
                                <div>
                                    <p className="text-sm font-semibold uppercase tracking-[0.25em] text-sky-700">
                                        Unidades ativas
                                    </p>
                                    <h2 className="mt-2 text-2xl font-semibold text-slate-950">
                                        Matriz e filiais cadastradas
                                    </h2>
                                </div>
                                <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">
                                    {featuredUnits.length} exibidas
                                </span>
                            </div>

                            <div className="mt-5 grid gap-4 sm:grid-cols-2">
                                {featuredUnits.map((unit) => (
                                    <div
                                        key={unit.tb2_id}
                                        className="rounded-[24px] border border-slate-200 bg-slate-50/80 p-4"
                                    >
                                        <div className="flex items-start justify-between gap-3">
                                            <div>
                                                <p className="text-base font-semibold text-slate-950">{unit.tb2_nome}</p>
                                                <p className="mt-1 text-sm leading-6 text-slate-600">{unit.tb2_endereco}</p>
                                            </div>
                                            {unit.matriz?.tb30_nome && (
                                                <span className="rounded-full bg-slate-900 px-3 py-1 text-[11px] font-semibold text-white">
                                                    {unit.matriz.tb30_nome}
                                                </span>
                                            )}
                                        </div>
                                    </div>
                                ))}
                                {featuredUnits.length === 0 && (
                                    <div className="rounded-[24px] border border-dashed border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-600">
                                        Nenhuma unidade cadastrada para exibição.
                                    </div>
                                )}
                            </div>
                        </div>

                        <div className="rounded-[32px] border border-slate-900 bg-slate-950 p-6 text-white shadow-[0_20px_60px_rgba(15,23,42,0.22)]">
                            <p className="text-sm font-semibold uppercase tracking-[0.25em] text-sky-300">Resumo do sistema</p>
                            <div className="mt-5 grid gap-4 sm:grid-cols-3">
                                <div className="rounded-[24px] border border-white/10 bg-white/5 p-4">
                                    <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-300">Matriz</p>
                                    <p className="mt-2 text-3xl font-semibold">{primaryUnit?.matriz?.tb30_nome || '—'}</p>
                                </div>
                                <div className="rounded-[24px] border border-white/10 bg-white/5 p-4">
                                    <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-300">Unidades</p>
                                    <p className="mt-2 text-3xl font-semibold">{validUnits.length}</p>
                                </div>
                                <div className="rounded-[24px] border border-white/10 bg-white/5 p-4">
                                    <p className="text-xs font-semibold uppercase tracking-[0.2em] text-slate-300">Ano</p>
                                    <p className="mt-2 text-3xl font-semibold">{currentYear}</p>
                                </div>
                            </div>

                            <div className="mt-6 rounded-[28px] border border-white/10 bg-white/5 p-5">
                                <p className="text-sm leading-7 text-slate-200">
                                    Plataforma desenhada para trabalhar com estrutura de matriz e filiais, mantendo
                                    registros vinculados à unidade correta e à empresa principal.
                                </p>
                            </div>
                        </div>
                    </section>

                    <footer className="mt-6 flex flex-col gap-3 border-t border-white/60 px-1 py-5 text-sm text-slate-500 sm:flex-row sm:items-center sm:justify-between">
                        <p>{currentYear} {appName}. Rede operacional para matriz e filiais.</p>
                        <p className="text-xs uppercase tracking-[0.2em] text-sky-600">SYSPDV</p>
                    </footer>
                </div>
            </div>
        </>
    );
}
