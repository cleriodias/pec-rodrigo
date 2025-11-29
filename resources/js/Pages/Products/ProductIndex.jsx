import AlertMessage from "@/Components/Alert/AlertMessage";
import PrimaryButton from "@/Components/Button/PrimaryButton";
import SuccessButton from "@/Components/Button/SuccessButton";
import WarningButton from "@/Components/Button/WarningButton";
import ConfirmDeleteButton from "@/Components/Delete/ConfirmDeleteButton";
import Pagination from "@/Components/Pagination";
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout";
import { Head, Link, usePage, router } from "@inertiajs/react";
import { useEffect, useRef, useState } from "react";

const MIN_SEARCH_CHARACTERS = 3;
const numericRegex = /^\d+$/;

const formatCurrency = (value) => {
    const parsed = Number(value ?? 0);

    return parsed.toLocaleString("pt-BR", {
        style: "currency",
        currency: "BRL",
    });
};

const resolveLabel = (labels, key) => {
    if (!labels) {
        return "---";
    }

    return labels[key] ?? "---";
};

export default function ProductIndex({ auth, products, typeLabels, statusLabels, search = '' }) {
    const { flash } = usePage().props;

    const [searchTerm, setSearchTerm] = useState(search ?? '');
    const [searchError, setSearchError] = useState('');
    const [favoriteLoading, setFavoriteLoading] = useState(null);
    const initialSearchHandled = useRef(false);

    useEffect(() => {
        setSearchTerm(search ?? '');
    }, [search]);

    useEffect(() => {
        const handler = setTimeout(() => {
            const term = searchTerm.trim();
            const isNumeric = numericRegex.test(term);

            if (initialSearchHandled.current === false) {
                initialSearchHandled.current = true;
                if ((search ?? '') === term) {
                    return;
                }
            }

            if (term === '') {
                setSearchError('');
                router.get(route('products.index'), {}, { preserveState: true, replace: true });
                return;
            }

            if (!isNumeric && term.length < MIN_SEARCH_CHARACTERS) {
                setSearchError(`Digite pelo menos ${MIN_SEARCH_CHARACTERS} caracteres ou utilize ID/c?digo.`);
                return;
            }

            setSearchError('');
            router.get(route('products.index'), { search: term }, { preserveState: true, replace: true });
        }, 400);

        return () => clearTimeout(handler);
    }, [searchTerm, search]);

    const handleToggleFavorite = (productId, currentValue) => {
        setFavoriteLoading(productId);
        router.post(route('products.favorite', { product: productId }), { favorite: !currentValue }, {
            preserveScroll: true,
            preserveState: true,
            onFinish: () => setFavoriteLoading(null),
        });
    };

    return (
        <AuthenticatedLayout
            user={auth.user}
            header={
                <h2 className="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                    Produtos
                </h2>
            }
        >
            <Head title="Produtos" />

            <div className="py-4 max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div className="overflow-hidden bg-white shadow-lg sm:rounded-lg dark:bg-gray-800">
                    <div className="flex justify-between items-center m-4">
                        <h3 className="text-lg">Listar</h3>
                        <div className="flex space-x-4">
                            <Link href={route("products.create")}>
                                <SuccessButton aria-label="Cadastrar" title="Cadastrar">
                                    <i className="bi bi-plus-lg text-lg" aria-hidden="true"></i>
                                </SuccessButton>
                            </Link>
                        </div>
                    </div>

                    <AlertMessage message={flash} />

                    <div className="px-4 pb-4">
                        <div className="flex flex-col gap-3">
                            <label htmlFor="product-search" className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                Buscar produto
                            </label>
                            <input
                                id="product-search"
                                type="text"
                                value={searchTerm}
                                onChange={(event) => setSearchTerm(event.target.value)}
                                placeholder="Digite ID, c?digo de barras ou nome"
                                className="w-full rounded-xl border border-gray-300 px-3 py-2 text-gray-800 focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                            />
                            <p className="text-xs text-gray-500 dark:text-gray-400">
                                IDs ou c?digos num?ricos podem ser pesquisados imediatamente; nomes exigem pelo menos {MIN_SEARCH_CHARACTERS} letras.
                            </p>
                            {searchError && (
                                <p className="text-sm text-red-600 dark:text-red-400">{searchError}</p>
                            )}
                        </div>
                    </div>

                    <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                        <thead className="bg-gray-50 dark:bg-gray-700">
                            <tr>
                                <td className="px-4 py-3 text-center text-sm font-medium text-gray-500 tracking-wider">
                                    Favorito
                                </td>
                                <td className="px-4 py-3 text-left text-sm font-medium text-gray-500 tracking-wider">
                                    ID
                                </td>
                                <td className="px-4 py-3 text-left text-sm font-medium text-gray-500 tracking-wider">
                                    Nome
                                </td>
                                <td className="px-4 py-3 text-right text-sm font-medium text-gray-500 tracking-wider">
                                    Custo
                                </td>
                                <td className="px-4 py-3 text-right text-sm font-medium text-gray-500 tracking-wider">
                                    Venda
                                </td>
                                <td className="px-4 py-3 text-left text-sm font-medium text-gray-500 tracking-wider">
                                    Código de barras
                                </td>
                                <td className="px-4 py-3 text-left text-sm font-medium text-gray-500 tracking-wider">
                                    Tipo
                                </td>
                                <td className="px-4 py-3 text-left text-sm font-medium text-gray-500 tracking-wider">
                                    Status
                                </td>
                                <td className="px-4 py-3 text-center text-sm font-medium text-gray-500 tracking-wider">
                                    Ações
                                </td>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                            {products.data.map((product) => (
                                <tr key={product.tb1_id}>
                                    <td className="px-4 py-2 text-center">
                                        <button
                                            type="button"
                                            onClick={() => handleToggleFavorite(product.tb1_id, product.tb1_favorito)}
                                            disabled={favoriteLoading === product.tb1_id}
                                            className="text-xl text-yellow-400 transition hover:scale-110 disabled:opacity-50"
                                            aria-label={product.tb1_favorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos'}
                                        >
                                            <i
                                                className={product.tb1_favorito ? 'bi bi-star-fill' : 'bi bi-star'}
                                                aria-hidden="true"
                                            ></i>
                                        </button>
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider">
                                        {product.tb1_id}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider">
                                        {product.tb1_nome}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider text-right">
                                        {formatCurrency(product.tb1_vlr_custo)}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider text-right">
                                        {formatCurrency(product.tb1_vlr_venda)}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider">
                                        {product.tb1_codbar}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider">
                                        {resolveLabel(typeLabels, product.tb1_tipo)}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider">
                                        {resolveLabel(statusLabels, product.tb1_status)}
                                    </td>
                                    <td className="px-4 py-2 text-sm text-gray-500 tracking-wider">
                                        <Link href={route("products.show", { product: product.tb1_id })}>
                                            <PrimaryButton className="ms-1" aria-label="Visualizar" title="Visualizar">
                                                <i className="bi bi-eye text-lg" aria-hidden="true"></i>
                                            </PrimaryButton>
                                        </Link>
                                        <Link href={route("products.edit", { product: product.tb1_id })}>
                                            <WarningButton className="ms-1" aria-label="Editar" title="Editar">
                                                <i className="bi bi-pencil-square text-lg" aria-hidden="true"></i>
                                            </WarningButton>
                                        </Link>
                                        <ConfirmDeleteButton id={product.tb1_id} routeName="products.destroy" />
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>

                    <Pagination links={products.links} currentPage={products.current_page} />
                </div>
            </div>
        </AuthenticatedLayout>
    );
}

