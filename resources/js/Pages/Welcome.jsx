import React from "react";

import { Head, Link } from "@inertiajs/react";

export default function Welcome({ auth }){

    const currentYear = new Date().getFullYear();

    const appName = import.meta.env.VITE_APP_NAME || "Seu Gerenciador de Condimínio";

    return(
        <>
            <Head title="Home" />

            <div className="bg-gradient-to-r from-red-900 to-yellow-900 min-h-screen flex flex-col justify-center items-center text-white">

                <header className="text-center">

                    <h1 className="text-3xl font-bold mb-6">Pão & Café</h1>

                    <p className="text-lg mb-10">Controle despesas, organize assembleias e mantenha os moradores informados.</p>
                </header>

                <div className="flex justify-center space-x-4">
                     {/* Verifica se o usuário está autenticado */}
                     {auth.user ? (
                            <Link href={route('dashboard')} className="bg-red-900 hover:bg-red-700 text-white font-semibold py-2 px-4 rounded transition duration-300">
                                Painel de Controle
                            </Link>
                        ) : ( // Se o usuário não estiver autenticado
                            <>
                                <Link href={route('login')} className="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded transition duration-300">
                                    Acesso Restrito
                                </Link>
                            </>
                        )}
                </div>

                <section className="mt-12 flex flex-col md:flex-row justify-center items-center space-y-6 md:space-y-0 md:space-x-6">

                    {/* Descrição do primeiro recurso */}
                    <div className="bg-white text-black p-6 rounded-lg shadow-lg w-72 text-center">
                        <h3 className="font-bold text-xl mb-4">Setor 10</h3>
                        <p>
                            Area Av-3 Lt, 3/4, Lote 02 - Parque da Barragem Setor 10
                        </p>
                        <p>
                            CEP: 72925-170
                        </p>
                        <p>
                            (61) 984524923
                        </p>
                    </div>

                    {/* Descrição do segundo recurso */}
                    <div className="bg-white text-black p-6 rounded-lg shadow-lg w-72 text-center">
                        <h3 className="font-bold text-xl mb-4">Setor 1</h3>
                        <p>
                            Area Av-3 Lt, 3/4, Lote 02 - Parque da Barragem Setor 1
                        </p>
                        <p>
                            CEP: 72925-000
                        </p>
                        <p>
                            (61) 984524923
                        </p>
                    </div>

                    {/* Descrição do terceiro recurso */}
                    <div className="bg-white text-black p-6 rounded-lg shadow-lg w-72 text-center">
                        <h3 className="font-bold text-xl mb-4">Barragem 1</h3>
                        <p>
                            Area Av-3 Lt, 3/4, Lote 02 - Parque da Barragem 1
                        </p>
                        <p>
                            CEP: 72925-000
                        </p>
                        <p>
                            (61) 984524923
                        </p>
                    </div>

                </section>

                {/* Seção do rodapé */}
                <footer className="mt-16 text-center">
                    {/* Exibe o ano atual e o nome do aplicativo */}
                    <p>@ {currentYear} PeC . Todos os direitos reservados.</p>
                </footer>

            </div>

        </>
    )
}
