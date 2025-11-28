import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { useState } from 'react';

export default function Dashboard() {
    const [texto, setTexto] = useState('');
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
                                    onChange={(event) => setTexto(event.target.value)}
                                    placeholder="Digite o nome do produto"
                                    className="mt-3 block rounded-2xl border-2 border-indigo-400 bg-white px-6 py-5 text-2xl text-gray-900 shadow-lg focus:border-indigo-600 focus:outline-none focus:ring-4 focus:ring-indigo-500/50 dark:border-indigo-300 dark:bg-gray-700 dark:text-gray-100"
                                    style={{ width: '50vw' }}
                                />
                                <p className="mt-3 text-xl text-gray-600 dark:text-gray-300">Resultado: {texto}</p>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
        </AuthenticatedLayout>
    );
}
