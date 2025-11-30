import ApplicationLogo from '@/Components/ApplicationLogo';
import Dropdown from '@/Components/Dropdown';
import NavLink from '@/Components/NavLink';
import ResponsiveNavLink from '@/Components/ResponsiveNavLink';
import { Link, usePage, router } from '@inertiajs/react';
import { useState } from 'react';

const MenuLabel = ({ icon, text }) => (
    <span className="inline-flex items-center gap-2">
        <i className={`${icon} text-base`} aria-hidden="true"></i>
        <span>{text}</span>
    </span>
);

export default function AuthenticatedLayout({ header, children }) {
    const pageProps = usePage().props;
    const user = pageProps.auth.user;
    const activeUnitName = pageProps.auth.unit?.name ?? 'Dashboard';
    const effectiveRole = user ? Number(user.funcao) : null;
    const originalRole = user ? Number(user.funcao_original ?? user.funcao) : null;
    const isCashier = user && effectiveRole === 3;
    const canSeeUsers = user && [0, 1].includes(effectiveRole);
    const canSeeUnits = canSeeUsers;
    const canSeeReports = canSeeUnits;
    const canSwitchUnit = user && originalRole === 0;
    const canSwitchRole = user && originalRole === 0;
    const roleLabels = {
        0: 'MASTER',
        1: 'GERENTE',
        2: 'SUB-GERENTE',
        3: 'CAIXA',
        4: 'LANCHONETE',
        5: 'FUNCIONARIO',
        6: 'CLIENTE',
    };

    const [showingNavigationDropdown, setShowingNavigationDropdown] =
        useState(false);

    const handleLogout = () => {
        router.post(route('logout'), { _token: pageProps?.csrf_token ?? '' }, {
            onSuccess: () => {
                window.location.reload();
            },
        });
    };

    return (
        <div className="min-h-screen bg-gray-100 dark:bg-gray-900">
            <nav className="border-b border-gray-100 bg-white dark:border-gray-700 dark:bg-gray-800">
                <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                    <div className="flex h-16 justify-between">
                        <div className="flex">
                            <div className="flex shrink-0 items-center">
                                <Link href="/">
                                    <ApplicationLogo className="block h-9 w-auto fill-current text-gray-800 dark:text-gray-200" />
                                </Link>
                            </div>

                            <div className="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
                                <NavLink
                                    href={route('dashboard')}
                                    active={route().current('dashboard')}
                                >
                                    <MenuLabel icon="bi bi-speedometer2" text={activeUnitName} />
                                </NavLink>

                                {canSeeUsers && (
                                    <NavLink
                                        href={route('users.index')}
                                        active={route().current('users.index')}
                                    >
                                        <MenuLabel icon="bi bi-people-fill" text="Usuários" />
                                    </NavLink>
                                )}

                                {canSeeUnits && (
                                    <NavLink
                                        href={route('units.index')}
                                        active={route().current('units.index')}
                                    >
                                        <MenuLabel icon="bi bi-building" text="Unidades" />
                                    </NavLink>
                                )}
                                <NavLink
                                    href={route('products.index')}
                                    active={route().current('products.*')}
                                >
                                    <MenuLabel icon="bi bi-box-seam" text="Produtos" />
                                </NavLink>
                                {isCashier && (
                                    <NavLink
                                        href={route('cashier.close')}
                                        active={route().current('cashier.close')}
                                    >
                                        <MenuLabel icon="bi bi-cash-stack" text="Fechar CX" />
                                    </NavLink>
                                )}
                                {canSeeReports && (
                                    <>
                                        <NavLink
                                            href={route('reports.control')}
                                            active={route().current('reports.control')}
                                        >
                                            <MenuLabel icon="bi bi-graph-up-arrow" text="Controle" />
                                        </NavLink>
                                        <NavLink
                                            href={route('reports.cash.closure')}
                                            active={route().current('reports.cash.closure')}
                                        >
                                            <MenuLabel icon="bi bi-clipboard-data" text="Fechamento de CAIXA" />
                                        </NavLink>
                                    </>
                                )}
                            </div>
                        </div>

                        <div className="hidden sm:ms-6 sm:flex sm:items-center">
                            <div className="relative ms-3">
                                <Dropdown>
                                    <Dropdown.Trigger>
                                        <span className="inline-flex rounded-md">
                                            <button
                                                type="button"
                                                className="inline-flex items-center rounded-md border border-transparent bg-white px-3 py-2 text-sm font-medium leading-4 text-gray-500 transition duration-150 ease-in-out hover:text-gray-700 focus:outline-none dark:bg-gray-800 dark:text-gray-400 dark:hover:text-gray-300"
                                            >
                                                {user.name}
                                                <span className="ml-2 rounded-full bg-gray-100 px-2 py-0.5 text-xs font-semibold text-gray-600 dark:bg-gray-700 dark:text-gray-200">
                                                    {roleLabels[effectiveRole] ?? '---'}
                                                </span>

                                                <svg
                                                    className="-me-0.5 ms-2 h-4 w-4"
                                                    xmlns="http://www.w3.org/2000/svg"
                                                    viewBox="0 0 20 20"
                                                    fill="currentColor"
                                                >
                                                    <path
                                                        fillRule="evenodd"
                                                        d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                                        clipRule="evenodd"
                                                    />
                                                </svg>
                                            </button>
                                        </span>
                                    </Dropdown.Trigger>

                                    <Dropdown.Content>
                                        <Dropdown.Link href={route('profile.edit')}>
                                            <MenuLabel icon="bi bi-person-circle" text="Perfil" />
                                        </Dropdown.Link>
                                        {canSeeReports && (
                                            <>
                                                <Dropdown.Link href={route('reports.sales.today')}>
                                                    <MenuLabel icon="bi bi-calendar-day" text="Vendas hoje" />
                                                </Dropdown.Link>
                                                <Dropdown.Link href={route('reports.sales.period')}>
                                                    <MenuLabel icon="bi bi-calendar-range" text="Vendas periodo" />
                                                </Dropdown.Link>
                                                <Dropdown.Link href={route('reports.sales.detailed')}>
                                                    <MenuLabel icon="bi bi-card-checklist" text="Detalhado" />
                                                </Dropdown.Link>
                                                <Dropdown.Link href={route('reports.cash.closure')}>
                                                    <MenuLabel icon="bi bi-clipboard-data" text="Fechamento de CAIXA" />
                                                </Dropdown.Link>
                                            </>
                                        )}
                                        {canSwitchUnit && (
                                            <Dropdown.Link href={route('reports.switch-unit')}>
                                                <MenuLabel icon="bi bi-arrow-left-right" text="Trocar unidade" />
                                            </Dropdown.Link>
                                        )}
                                        {canSwitchRole && (
                                            <Dropdown.Link href={route('reports.switch-role')}>
                                                <MenuLabel icon="bi bi-people" text="Trocar funcao" />
                                            </Dropdown.Link>
                                        )}
                                        {canSeeReports && (
                                            <Dropdown.Link href={route('salary-advances.index')}>
                                                <MenuLabel icon="bi bi-wallet2" text="Adiantamento" />
                                            </Dropdown.Link>
                                        )}
                                        <Dropdown.Link href={route('products.discard')}>
                                            <MenuLabel icon="bi bi-recycle" text="Descarte" />
                                        </Dropdown.Link>
                                        <button
                                            type="button"
                                            onClick={handleLogout}
                                            className="w-full px-4 py-2 text-left text-sm font-semibold text-red-600 transition hover:text-red-700 focus:bg-red-50 dark:text-red-300 dark:hover:bg-red-500/20"
                                        >
                                            <MenuLabel icon="bi bi-box-arrow-right" text="Sair" />
                                        </button>
                                    </Dropdown.Content>
                                </Dropdown>
                            </div>
                        </div>

                        <div className="-me-2 flex items-center sm:hidden">
                            <button
                                onClick={() =>
                                    setShowingNavigationDropdown(
                                        (previousState) => !previousState,
                                    )
                                }
                                className="inline-flex items-center justify-center rounded-md p-2 text-gray-400 transition duration-150 ease-in-out hover:bg-gray-100 hover:text-gray-500 focus:bg-gray-100 focus:text-gray-500 focus:outline-none dark:text-gray-500 dark:hover:bg-gray-900 dark:hover:text-gray-400 dark:focus:bg-gray-900 dark:focus:text-gray-400"
                            >
                                <svg
                                    className="h-6 w-6"
                                    stroke="currentColor"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        className={
                                            !showingNavigationDropdown
                                                ? 'inline-flex'
                                                : 'hidden'
                                        }
                                        strokeLinecap="round"
                                        strokeLinejoin="round"
                                        strokeWidth="2"
                                        d="M4 6h16M4 12h16M4 18h16"
                                    />
                                    <path
                                        className={
                                            showingNavigationDropdown
                                                ? 'inline-flex'
                                                : 'hidden'
                                        }
                                        strokeLinecap="round"
                                        strokeLinejoin="round"
                                        strokeWidth="2"
                                        d="M6 18L18 6M6 6l12 12"
                                    />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <div
                    className={
                        (showingNavigationDropdown ? 'block' : 'hidden') +
                        ' sm:hidden'
                    }
                >
                    <div className="space-y-1 pb-3 pt-2">
                        <ResponsiveNavLink
                            href={route('dashboard')}
                            active={route().current('dashboard')}
                        >
                            <MenuLabel icon="bi bi-speedometer2" text={activeUnitName} />
                        </ResponsiveNavLink>

                        {canSeeUsers && (
                            <ResponsiveNavLink
                                href={route('users.index')}
                                active={route().current('users.index')}
                            >
                                <MenuLabel icon="bi bi-people-fill" text={"Usu\u00E1rios"} />
                            </ResponsiveNavLink>
                        )}

                        {canSeeUnits && (
                            <ResponsiveNavLink
                                href={route('units.index')}
                                active={route().current('units.index')}
                            >
                                <MenuLabel icon="bi bi-building" text="Unidades" />
                            </ResponsiveNavLink>
                        )}
                        <ResponsiveNavLink
                            href={route('products.index')}
                            active={route().current('products.*')}
                        >
                            <MenuLabel icon="bi bi-box-seam" text="Produtos" />
                        </ResponsiveNavLink>
                        {isCashier && (
                            <ResponsiveNavLink
                                href={route('cashier.close')}
                                active={route().current('cashier.close')}
                            >
                                <MenuLabel icon="bi bi-cash-stack" text="Fechar CX" />
                            </ResponsiveNavLink>
                        )}
                        {canSeeReports && (
                            <>
                                <ResponsiveNavLink
                                    href={route('reports.control')}
                                    active={route().current('reports.control')}
                                >
                                    <MenuLabel icon="bi bi-graph-up-arrow" text="Controle" />
                                </ResponsiveNavLink>
                                <ResponsiveNavLink
                                    href={route('reports.cash.closure')}
                                    active={route().current('reports.cash.closure')}
                                >
                                    <MenuLabel icon="bi bi-clipboard-data" text="Fechamento de CAIXA" />
                                </ResponsiveNavLink>
                            </>
                        )}
                        <ResponsiveNavLink
                            href={route('products.discard')}
                            active={route().current('products.discard')}
                        >
                            <MenuLabel icon="bi bi-recycle" text="Descarte" />
                        </ResponsiveNavLink>
                    </div>

                    <div className="border-t border-gray-200 pb-1 pt-4 dark:border-gray-600">
                        <div className="px-4">
                            <div className="text-base font-medium text-gray-800 dark:text-gray-200">
                                {user.name}
                                <span className="ml-2 rounded-full bg-gray-100 px-2 py-0.5 text-xs font-semibold text-gray-600 dark:bg-gray-700 dark:text-gray-200">
                                    {roleLabels[effectiveRole] ?? '---'}
                                </span>
                            </div>
                            <div className="text-sm font-medium text-gray-500">
                                {user.email}
                            </div>
                        </div>

                        <div className="mt-3 space-y-1">
                            <ResponsiveNavLink href={route('profile.edit')}>
                                Perfil
                            </ResponsiveNavLink>
                            {canSeeReports && (
                                <>
                                    <ResponsiveNavLink
                                        href={route('reports.sales.today')}
                                        active={route().current('reports.sales.today')}
                                    >
                                        Vendas hoje
                                    </ResponsiveNavLink>
                                    <ResponsiveNavLink
                                        href={route('reports.sales.period')}
                                        active={route().current('reports.sales.period')}
                                    >
                                        Vendas periodo
                                    </ResponsiveNavLink>
                                    <ResponsiveNavLink
                                        href={route('reports.sales.detailed')}
                                        active={route().current('reports.sales.detailed')}
                                    >
                                        Detalhado
                                    </ResponsiveNavLink>
                                    <ResponsiveNavLink
                                        href={route('reports.cash.closure')}
                                        active={route().current('reports.cash.closure')}
                                    >
                                        Fechamento de CAIXA
                                    </ResponsiveNavLink>
                                </>
                            )}
                            {canSwitchUnit && (
                                <ResponsiveNavLink
                                    href={route('reports.switch-unit')}
                                    active={route().current('reports.switch-unit')}
                                >
                                    Trocar unidade
                                </ResponsiveNavLink>
                            )}
                            {canSwitchRole && (
                                <ResponsiveNavLink
                                    href={route('reports.switch-role')}
                                    active={route().current('reports.switch-role')}
                                >
                                    Trocar funcao
                                </ResponsiveNavLink>
                            )}
                            {canSeeReports && (
                                <ResponsiveNavLink
                                    href={route('salary-advances.index')}
                                    active={route().current('salary-advances.*')}
                                >
                                    Adiantamento
                                </ResponsiveNavLink>
                            )}
                            <button
                                type="button"
                                onClick={handleLogout}
                                className="block w-full px-4 py-2 text-left text-sm font-semibold text-red-600 transition hover:bg-red-50 dark:text-red-300 dark:hover:bg-red-500/20"
                            >
                                Sair
                            </button>
                        </div>
                    </div>
                </div>
            </nav>

            {header && (
                <header className="bg-white shadow dark:bg-gray-800">
                    <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
                        {header}
                    </div>
                </header>
            )}

            <main>{children}</main>
        </div>
    );
}
