import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';

export default function Config({ auth }) {
    const options = [
        { label: 'Acesso', icon: 'bi-shield-lock' },
        { label: 'Perfil', icon: 'bi-person-circle' },
        { label: 'Menu', icon: 'bi-ui-checks' },
        { label: 'Relatórios', icon: 'bi-clipboard-data' },
        {
            label: 'Permissões de Menu',
            icon: 'bi-gear',
            href: route('settings.profile-access'),
        },
        {
            label: 'Organizar Menu',
            icon: 'bi-list-ol',
            href: route('settings.menu-order'),
        },
        {
            label: 'Fornecedores',
            icon: 'bi-truck',
            href: route('settings.suppliers'),
        },
        {
            label: 'Cadastro de Gastos',
            icon: 'bi-receipt',
            href: route('expenses.index'),
        },
    ];

    return (
        <AuthenticatedLayout
            user={auth.user}
            header={
                <div className="flex flex-col gap-1">
                    <h2 className="text-xl font-semibold text-gray-800 dark:text-gray-100">
                        Configurações
                    </h2>
                    <p className="text-sm text-gray-500 dark:text-gray-300">
                        Gerencie acesso, perfil, menus e relatórios.
                    </p>
                </div>
            }
        >
            <Head title="Configurações" />
            <div className="py-8">
                <div className="mx-auto max-w-4xl space-y-6 px-4 sm:px-6 lg:px-8">
                    <div className="grid gap-4 sm:grid-cols-2">
                        {options.map((opt) => (
                            <a
                                key={opt.label}
                                href={opt.href ?? '#'}
                                className="flex items-center justify-between rounded-2xl border border-gray-200 bg-white px-4 py-3 shadow-sm transition hover:border-indigo-300 hover:shadow-md dark:border-gray-700 dark:bg-gray-900"
                            >
                                <div className="flex items-center gap-3">
                                    <i className={`bi ${opt.icon} text-xl text-indigo-500`} aria-hidden="true"></i>
                                    <span className="text-sm font-semibold text-gray-800 dark:text-gray-100">
                                        {opt.label}
                                    </span>
                                </div>
                                <span className="text-xs font-medium text-indigo-600 dark:text-indigo-300">
                                    {opt.href ? 'Abrir' : 'Em breve'}
                                </span>
                            </a>
                        ))}
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
