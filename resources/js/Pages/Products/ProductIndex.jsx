import AlertMessage from "@/Components/Alert/AlertMessage";
import PrimaryButton from "@/Components/Button/PrimaryButton";
import SuccessButton from "@/Components/Button/SuccessButton";
import WarningButton from "@/Components/Button/WarningButton";
import ConfirmDeleteButton from "@/Components/Delete/ConfirmDeleteButton";
import Pagination from "@/Components/Pagination";
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout";
import { Head, Link, usePage } from "@inertiajs/react";

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

export default function ProductIndex({ auth, products, typeLabels, statusLabels }) {
    const { flash } = usePage().props;

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

                    <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                        <thead className="bg-gray-50 dark:bg-gray-700">
                            <tr>
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

