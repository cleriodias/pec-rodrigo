import { Link } from '@inertiajs/react';

export default function GuestLayout({ children }) {
    return (
        <div
            className="relative min-h-screen overflow-hidden bg-[var(--surface)] text-[var(--ink)]"
            style={{
                fontFamily: "'Space Grotesk', sans-serif",
                '--surface': '#f3f7fb',
                '--surface-strong': '#eef4ff',
                '--ink': '#0f172a',
                '--accent': '#0f4c81',
                '--accent-strong': '#0b355d',
            }}
        >
            <div className="pointer-events-none absolute -top-28 right-6 h-80 w-80 rounded-full bg-sky-400/25 blur-[130px]" />
            <div className="pointer-events-none absolute -bottom-24 left-0 h-96 w-96 rounded-full bg-indigo-500/20 blur-[150px]" />
            <div className="pointer-events-none absolute inset-0 opacity-90 [background-image:radial-gradient(circle_at_top_left,rgba(255,255,255,0.95)_0%,rgba(255,255,255,0.2)_42%,rgba(255,255,255,0)_75%)]" />
            <div className="pointer-events-none absolute inset-0 opacity-[0.22] [background-image:linear-gradient(rgba(15,76,129,0.16)_1px,transparent_1px),linear-gradient(90deg,rgba(15,76,129,0.16)_1px,transparent_1px)] [background-size:52px_52px]" />

            <div className="relative mx-auto flex min-h-screen w-full max-w-7xl flex-col px-4 py-4 sm:px-6 lg:px-8">
                <header className="flex items-center justify-between gap-4 rounded-3xl border border-white/70 bg-white/75 px-5 py-4 shadow-sm backdrop-blur">
                    <Link href="/" className="flex items-center gap-3">
                        <span className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[var(--accent)] text-sm font-black text-white shadow-lg shadow-sky-900/15">
                            SP
                        </span>
                        <span className="flex flex-col leading-tight">
                            <span className="text-xs font-semibold uppercase tracking-[0.28em] text-sky-700">SYSPDV</span>
                            <span className="text-sm text-slate-500">Painel de matriz e filiais</span>
                        </span>
                    </Link>

                    <div className="hidden items-center gap-2 sm:flex">
                        <span className="rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold text-white">Portal</span>
                        <span className="rounded-full bg-sky-100 px-3 py-1 text-xs font-semibold text-sky-700">Rede</span>
                    </div>
                </header>

                <main className="flex flex-1 items-center justify-center py-6 sm:py-10">
                    <div className="w-full">
                        {children}
                    </div>
                </main>
            </div>
        </div>
    );
}
