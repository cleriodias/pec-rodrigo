import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { useEffect, useRef, useState } from 'react';

const MIN_CHARACTERS = 3;
const numericRegex = /^\d+$/;
const typeLabels = {
    0: 'Indústria',
    1: 'Balança',
    2: 'Serviço',
};
const statusLabels = {
    0: 'Inativo',
    1: 'Ativo',
};

const formatCurrency = (value) => {
    const parsed = Number(value ?? 0);

    return parsed.toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });
};

export default function Dashboard() {
    const [texto, setTexto] = useState('');
    const [suggestions, setSuggestions] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [searchTrigger, setSearchTrigger] = useState(0);
    const [lastManualSearch, setLastManualSearch] = useState(false);
    const lastTriggerConsumed = useRef(0);

    useEffect(() => {
        const term = texto.trim();
        const isNumericTerm = numericRegex.test(term);
        const hasMinChars = term.length >= MIN_CHARACTERS;
        const forcedSearch = lastTriggerConsumed.current !== searchTrigger;

        setSelectedProduct((previous) => {
            if (previous && previous.tb1_nome === term) {
                return previous;
            }

            return null;
        });

        if (term.length === 0) {
            setSuggestions([]);
            setError('');
            setLoading(false);
            setLastManualSearch(false);
            if (forcedSearch) {
                lastTriggerConsumed.current = searchTrigger;
            }
            return;
        }

        if (!isNumericTerm && !hasMinChars && !forcedSearch) {
            setSuggestions([]);
            setError('');
            setLoading(false);
            return;
        }

        if (forcedSearch) {
            lastTriggerConsumed.current = searchTrigger;
            setLastManualSearch(true);
        } else {
            setLastManualSearch(false);
        }

        let isCurrent = true;
        setLoading(true);
        setError('');

        fetch(route('products.search', { q: term }), {
            headers: {
                Accept: 'application/json',
            },
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Falha ao carregar produtos');
                }

                return response.json();
            })
            .then((data) => {
                if (!isCurrent) {
                    return;
                }

                setSuggestions(data);
            })
            .catch(() => {
                if (!isCurrent) {
                    return;
                }

                setError('Não foi possível buscar produtos.');
                setSuggestions([]);
            })
            .finally(() => {
                if (!isCurrent) {
                    return;
                }

                setLoading(false);
            });

        return () => {
            isCurrent = false;
        };
    }, [texto, searchTrigger]);

    const handleSelect = (product) => {
        setTexto(product.tb1_nome);
        setSelectedProduct(product);
        setSuggestions([]);
    };

    const trimmedText = texto.trim();
    const isNumericInput = numericRegex.test(trimmedText);
    const hasMinChars = trimmedText.length >= MIN_CHARACTERS;
    const showSuggestions =
        trimmedText.length > 0 && (isNumericInput || hasMinChars || lastManualSearch);

    const handleInputChange = (event) => {
        setTexto(event.target.value);
        setLastManualSearch(false);
    };

    const handleKeyDown = (event) => {
        if (event.key !== 'Enter') {
            return;
        }

        const term = texto.trim();
        const isNumericTerm = numericRegex.test(term);
        const hasMin = term.length >= MIN_CHARACTERS;

        if (!term || isNumericTerm || hasMin) {
            return;
        }

        event.preventDefault();
        setSearchTrigger((prev) => prev + 1);
    };

    return (
        <AuthenticatedLayout
            header={
                <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                    Dashboard
                </h2>
            }
        >
            <Head title="Dashboard" />

            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="overflow-hidden bg-white shadow-sm sm:rounded-lg dark:bg-gray-800">
                        <div className="p-6 text-gray-900 dark:text-gray-100">
                            <div className="mt-6">
                                <label
                                    htmlFor="campo-dashboard"
                                    className="block text-xl font-semibold text-gray-700 dark:text-gray-200"
                                >
                                    Busca por produto
                                </label>
                                <input
                                    id="campo-dashboard"
                                    type="text"
                                    value={texto}
                                    onChange={handleInputChange}
                                    onKeyDown={handleKeyDown}
                                    placeholder="Digite nome, código ou ID"
                                    className="mt-3 block rounded-2xl border-2 border-indigo-400 bg-white px-6 py-5 text-2xl text-gray-900 shadow-lg focus:border-indigo-600 focus:outline-none focus:ring-4 focus:ring-indigo-500/50 dark:border-indigo-300 dark:bg-gray-700 dark:text-gray-100"
                                    style={{ width: '50vw' }}
                                />
                                <p className="mt-3 text-sm text-gray-500 dark:text-gray-300">
                                    Digite pelo menos {MIN_CHARACTERS} caracteres ou pressione Enter para forçar a
                                    busca quando houver menos caracteres.
                                </p>

                                {showSuggestions && (
                                    <div className="mt-4 w-full max-w-3xl rounded-2xl border border-gray-200 bg-white shadow-lg dark:border-gray-700 dark:bg-gray-900">
                                        {loading && (
                                            <p className="px-4 py-3 text-sm text-gray-500 dark:text-gray-400">
                                                Buscando produtos...
                                            </p>
                                        )}
                                        {!loading && error && (
                                            <p className="px-4 py-3 text-sm text-red-600 dark:text-red-400">{error}</p>
                                        )}
                                        {!loading && !error && suggestions.length === 0 && (
                                            <p className="px-4 py-3 text-sm text-gray-500 dark:text-gray-400">
                                                Nenhum produto encontrado.
                                            </p>
                                        )}
                                        {!loading && !error && suggestions.length > 0 && (
                                            <ul className="divide-y divide-gray-100 dark:divide-gray-800">
                                                {suggestions.map((product) => (
                                                    <li key={product.tb1_id}>
                                                        <button
                                                            type="button"
                                                            onClick={() => handleSelect(product)}
                                                            className="flex w-full items-center justify-between px-4 py-3 text-left hover:bg-indigo-50 dark:hover:bg-indigo-900/30"
                                                        >
                                                            <div>
                                                                <p className="text-base font-semibold text-gray-800 dark:text-gray-100">
                                                                    {product.tb1_nome}
                                                                </p>
                                                                <p className="text-sm text-gray-500 dark:text-gray-400">
                                                                    ID: {product.tb1_id} · Código: {product.tb1_codbar}
                                                                </p>
                                                            </div>
                                                            <span className="text-sm font-medium text-indigo-600 dark:text-indigo-300">
                                                                {formatCurrency(product.tb1_vlr_venda)}
                                                            </span>
                                                        </button>
                                                    </li>
                                                ))}
                                            </ul>
                                        )}
                                    </div>
                                )}

                                {selectedProduct && (
                                    <div className="mt-6 rounded-2xl border border-indigo-200 bg-indigo-50 p-4 shadow dark:border-indigo-500/40 dark:bg-indigo-900/30">
                                        <h3 className="text-lg font-semibold text-indigo-800 dark:text-indigo-200">
                                            Produto selecionado
                                        </h3>
                                        <div className="mt-2 grid gap-4 sm:grid-cols-2">
                                            <div>
                                                <p className="text-sm text-gray-500 dark:text-gray-300">Nome</p>
                                                <p className="text-base font-medium text-gray-900 dark:text-gray-100">
                                                    {selectedProduct.tb1_nome}
                                                </p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-gray-500 dark:text-gray-300">ID</p>
                                                <p className="text-base font-medium text-gray-900 dark:text-gray-100">
                                                    {selectedProduct.tb1_id}
                                                </p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-gray-500 dark:text-gray-300">Custo</p>
                                                <p className="text-base font-medium text-gray-900 dark:text-gray-100">
                                                    {formatCurrency(selectedProduct.tb1_vlr_custo)}
                                                </p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-gray-500 dark:text-gray-300">Venda</p>
                                                <p className="text-base font-medium text-gray-900 dark:text-gray-100">
                                                    {formatCurrency(selectedProduct.tb1_vlr_venda)}
                                                </p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-gray-500 dark:text-gray-300">Tipo</p>
                                                <p className="text-base font-medium text-gray-900 dark:text-gray-100">
                                                    {typeLabels[selectedProduct.tb1_tipo] ?? '---'}
                                                </p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-gray-500 dark:text-gray-300">Status</p>
                                                <p className="text-base font-medium text-gray-900 dark:text-gray-100">
                                                    {statusLabels[selectedProduct.tb1_status] ?? '---'}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
