import { Head, Link, usePage } from '@inertiajs/react';
import { useEffect, useRef, useState } from 'react';

const StepCard = ({ title, description, children }) => (
    <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
        <div className="mb-4">
            <h2 className="text-lg font-semibold text-gray-800">{title}</h2>
            {description && <p className="text-sm text-gray-600">{description}</p>}
        </div>
        {children}
    </div>
);

export default function Terminal() {
    const { auth } = usePage().props;
    const [step, setStep] = useState(1);
    const [accessCode, setAccessCode] = useState('');
    const [comanda, setComanda] = useState('');
    const [search, setSearch] = useState('');

    const accessRef = useRef(null);
    const comandaRef = useRef(null);
    const searchRef = useRef(null);

    useEffect(() => {
        if (step === 1 && accessRef.current) {
            accessRef.current.focus();
        } else if (step === 2 && comandaRef.current) {
            comandaRef.current.focus();
        } else if (step === 3 && searchRef.current) {
            searchRef.current.focus();
        }
    }, [step]);

    const goToStep = (targetStep) => {
        setStep(targetStep);
    };

    const handleAccessSubmit = (e) => {
        e.preventDefault();
        if (!accessCode.trim()) return;
        goToStep(2);
    };

    const handleComandaSubmit = (e) => {
        e.preventDefault();
        if (!comanda.trim()) return;
        goToStep(3);
    };

    const handleFinalize = () => {
        setAccessCode('');
        setComanda('');
        setSearch('');
        goToStep(1);
        if (accessRef.current) {
            accessRef.current.focus();
        }
    };

    return (
        <div className="min-h-screen bg-gray-50">
            <Head title="Terminal Lanchonete" />

            <header className="border-b border-gray-200 bg-white">
                <div className="mx-auto flex max-w-5xl items-center justify-between px-4 py-4">
                    <div className="flex items-center gap-3">
                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-amber-100 text-xl">
                            🍔
                        </div>
                        <div>
                            <p className="text-sm font-semibold text-amber-700">Lanchonete</p>
                            <p className="text-xs text-gray-500">Terminal dedicado</p>
                        </div>
                    </div>
                    <div className="flex items-center gap-3">
                        <Link
                            href={route('reports.switch-role')}
                            className="inline-flex items-center gap-2 rounded-full border border-gray-200 px-3 py-1 text-sm font-semibold text-gray-700 shadow-sm hover:bg-gray-100"
                        >
                            <i className="bi bi-arrow-left-right" aria-hidden="true"></i>
                            Trocar funcao
                        </Link>
                        <div className="hidden sm:flex flex-col items-end">
                            <span className="text-sm font-semibold text-gray-800">{auth?.user?.name}</span>
                            <span className="text-xs text-gray-500">Perfil: Lanchonete</span>
                        </div>
                    </div>
                </div>
            </header>

            <main className="mx-auto max-w-5xl space-y-4 px-4 py-6">
                {step === 1 && (
                    <StepCard
                        title="1. Codigo de acesso"
                        description="Informe seu codigo de acesso antes de lancar itens."
                    >
                        <form onSubmit={handleAccessSubmit} className="space-y-3">
                            <input
                                ref={accessRef}
                                type="number"
                                inputMode="numeric"
                                placeholder="Digite o codigo de acesso"
                                value={accessCode}
                                onChange={(e) => setAccessCode(e.target.value)}
                                className="w-full rounded-lg border border-amber-300 bg-amber-50 px-4 py-3 text-lg font-semibold text-amber-800 focus:border-amber-500 focus:outline-none focus:ring-2 focus:ring-amber-200"
                            />
                            <div className="flex justify-end">
                                <button
                                    type="submit"
                                    className="rounded-lg bg-amber-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-amber-700 focus:outline-none focus:ring-2 focus:ring-amber-400"
                                >
                                    Avancar
                                </button>
                            </div>
                        </form>
                    </StepCard>
                )}

                {step === 2 && (
                    <StepCard
                        title="2. Codigo da comanda"
                        description="Informe o numero da comanda (3000-3100)."
                    >
                        <form onSubmit={handleComandaSubmit} className="space-y-3">
                            <input
                                ref={comandaRef}
                                type="number"
                                inputMode="numeric"
                                placeholder="Digite o codigo da comanda"
                                value={comanda}
                                onChange={(e) => setComanda(e.target.value)}
                                className="w-full rounded-lg border border-blue-300 bg-blue-50 px-4 py-3 text-lg font-semibold text-blue-800 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
                            />
                            <div className="flex justify-between">
                                <button
                                    type="button"
                                    onClick={() => goToStep(1)}
                                    className="rounded-lg border border-gray-300 px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-100"
                                >
                                    Voltar
                                </button>
                                <button
                                    type="submit"
                                    className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400"
                                >
                                    Avancar
                                </button>
                            </div>
                        </form>
                    </StepCard>
                )}

                {step === 3 && (
                    <div className="space-y-4">
                        <StepCard
                            title="3. Buscar produto"
                            description="Busque pelo produto para adicionar aos itens da comanda."
                        >
                            <div className="space-y-3">
                                <input
                                    ref={searchRef}
                                    type="text"
                                    placeholder="Digite nome, codigo ou ID do produto"
                                    value={search}
                                    onChange={(e) => setSearch(e.target.value)}
                                    className="w-full rounded-lg border border-green-300 bg-green-50 px-4 py-3 text-lg font-semibold text-green-800 focus:border-green-500 focus:outline-none focus:ring-2 focus:ring-green-200"
                                />
                                <p className="text-sm text-gray-500">
                                    Cada confirmacao adiciona o item na lista. (Implementar logica de busca e inclusao.)
                                </p>
                            </div>
                        </StepCard>

                        <div className="rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
                            <div className="flex items-center justify-between">
                                <h3 className="text-base font-semibold text-gray-800">Itens adicionados</h3>
                                <button
                                    type="button"
                                    onClick={handleFinalize}
                                    className="rounded-lg bg-gray-800 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-400"
                                >
                                    Finalizar / Nova comanda
                                </button>
                            </div>
                            <p className="mt-2 text-sm text-gray-500">Nenhum item ainda. (Exibir itens da comanda aqui.)</p>
                        </div>
                    </div>
                )}
            </main>
        </div>
    );
}
