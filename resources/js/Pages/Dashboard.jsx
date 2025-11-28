import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import { useEffect, useMemo, useRef, useState } from 'react';

const MIN_CHARACTERS = 3;
const numericRegex = /^\d+$/;
const paymentLabels = {
    maquina: 'Maquina',
    dinheiro: 'Dinheiro',
    vale: 'Vale',
    faturar: 'Faturar',
};
const paymentOptions = [
    {
        value: 'dinheiro',
        label: paymentLabels.dinheiro,
        classes: 'bg-green-600 hover:bg-green-700 focus:ring-green-200 text-white',
    },
    {
        value: 'maquina',
        label: paymentLabels.maquina,
        classes: 'bg-blue-600 hover:bg-blue-700 focus:ring-blue-200 text-white',
    },
    {
        value: 'vale',
        label: paymentLabels.vale,
        classes: 'bg-amber-500 hover:bg-amber-600 focus:ring-amber-200 text-gray-900',
    },
    {
        value: 'faturar',
        label: paymentLabels.faturar,
        classes: 'bg-gray-900 hover:bg-gray-800 focus:ring-gray-200 text-white',
    },
];

const formatCurrency = (value) => {
    const parsed = Number(value ?? 0);

    return parsed.toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL',
    });
};

const formatDateTime = (value) => {
    const date = value ? new Date(value) : new Date();

    return date.toLocaleString('pt-BR', {
        dateStyle: 'short',
        timeStyle: 'short',
    });
};

export default function Dashboard() {
    const pageProps = usePage().props;
    const { auth } = pageProps;
    const csrfTokenProp = pageProps?.csrf_token ?? '';
    const activeUnitName = auth?.unit?.name ?? '';

    const [texto, setTexto] = useState('');
    const inputRef = useRef(null);
    const [suggestions, setSuggestions] = useState([]);
    const [hideSuggestions, setHideSuggestions] = useState(false);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [searchTrigger, setSearchTrigger] = useState(0);
    const [lastManualSearch, setLastManualSearch] = useState(false);
    const lastTriggerConsumed = useRef(0);

    const [items, setItems] = useState([]);
    const [addingItem, setAddingItem] = useState(false);
    const [saleLoading, setSaleLoading] = useState(false);
    const [saleError, setSaleError] = useState('');
    const [valePickerVisible, setValePickerVisible] = useState(false);
    const [valeSearchTerm, setValeSearchTerm] = useState('');
    const [valeResults, setValeResults] = useState([]);
    const [valeLoading, setValeLoading] = useState(false);
    const [receiptData, setReceiptData] = useState(null);
    const [showReceipt, setShowReceipt] = useState(false);
    const [cashInputVisible, setCashInputVisible] = useState(false);
    const [cashValue, setCashValue] = useState('');
    const cashInputRef = useRef(null);

    const totalAmount = useMemo(
        () => items.reduce((sum, item) => sum + item.quantity * item.price, 0),
        [items],
    );

    const numericCashValue = useMemo(() => {
        if (!cashValue) {
            return 0;
        }

        const normalized = String(cashValue).replace(',', '.');
        const parsed = Number(normalized);
        return Number.isNaN(parsed) ? 0 : parsed;
    }, [cashValue]);

    const cashChange = useMemo(() => {
        if (items.length === 0) {
            return 0;
        }

        return Math.max(0, numericCashValue - totalAmount);
    }, [items.length, numericCashValue, totalAmount]);

    const cashCardComplement = useMemo(() => {
        if (items.length === 0) {
            return 0;
        }

        return Math.max(0, totalAmount - numericCashValue);
    }, [items.length, numericCashValue, totalAmount]);

    useEffect(() => {
        inputRef.current?.focus();
    }, []);
    useEffect(() => {
        const term = texto.trim();
        const isNumericTerm = numericRegex.test(term);
        const hasMinChars = term.length >= MIN_CHARACTERS;
        const forcedSearch = lastTriggerConsumed.current !== searchTrigger;

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

                setError('Nao foi possivel buscar produtos.');
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

    useEffect(() => {
        if (!valePickerVisible) {
            setValeLoading(false);
            return;
        }

        const term = valeSearchTerm.trim();

        if (term.length < 2) {
            setValeResults([]);
            setValeLoading(false);
            return;
        }

        let isCurrent = true;
        setValeLoading(true);

        fetch(route('users.search', { q: term }), {
            headers: {
                Accept: 'application/json',
            },
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Falha ao buscar usuarios');
                }

                return response.json();
            })
            .then((data) => {
                if (!isCurrent) {
                    return;
                }

                setValeResults(data);
            })
            .catch(() => {
                if (!isCurrent) {
                    return;
                }

                setValeResults([]);
            })
            .finally(() => {
                if (!isCurrent) {
                    return;
                }

                setValeLoading(false);
            });

        return () => {
            isCurrent = false;
        };
    }, [valePickerVisible, valeSearchTerm]);

    useEffect(() => {
        if (items.length === 0) {
            setCashInputVisible(false);
            setCashValue('');
        }
    }, [items.length]);

    const addItemFromProduct = (product, { preserveInput = false } = {}) => {
        if (!product) {
            return;
        }

        setItems((previous) => {
            const existingIndex = previous.findIndex((item) => item.id === product.tb1_id);

            if (existingIndex !== -1) {
                const updated = [...previous];
                const existing = updated[existingIndex];

                updated[existingIndex] = {
                    ...existing,
                    quantity: existing.quantity + 1,
                };

                return updated;
            }

            return [
                ...previous,
                {
                    id: product.tb1_id,
                    name: product.tb1_nome,
                    price: Number(product.tb1_vlr_venda ?? 0),
                    quantity: 1,
                },
            ];
        });

        setSuggestions([]);
        setSaleError('');
        if (preserveInput) {
            setHideSuggestions(true);
        } else {
            setTexto('');
            setHideSuggestions(false);
        }
        requestAnimationFrame(() => {
            inputRef.current?.focus();
        });
    };
    const handleSelect = (product) => {
        addItemFromProduct(product);
    };

    const fetchProductAndAdd = (productId) => {
        setAddingItem(true);
        setSaleError('');

        fetch(route('products.search', { q: productId }), {
            headers: {
                Accept: 'application/json',
            },
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Produto nao encontrado.');
                }

                return response.json();
            })
            .then((data) => {
                const product = data.find((item) => Number(item.tb1_id) === productId);

                if (!product) {
                    throw new Error('Produto nao encontrado.');
                }

                addItemFromProduct(product, { preserveInput: true });
            })
            .catch((err) => {
                setSaleError(err.message || 'Nao foi possivel adicionar o produto.');
            })
            .finally(() => {
                setAddingItem(false);
            });
    };

    const trimmedText = texto.trim();
    const isNumericInput = numericRegex.test(trimmedText);
    const hasMinChars = trimmedText.length >= MIN_CHARACTERS;
    const showSuggestions =
        !hideSuggestions &&
        trimmedText.length > 0 &&
        (isNumericInput || hasMinChars || lastManualSearch) &&
        (!isNumericInput || suggestions.length > 0 || loading || error);

    const handleInputChange = (event) => {
        setTexto(event.target.value);
        setLastManualSearch(false);
        setHideSuggestions(false);
    };

    const handleKeyDown = (event) => {
        if (event.key !== 'Enter' || saleLoading || addingItem) {
            return;
        }

        const term = texto.trim();
        const isNumericTerm = numericRegex.test(term);
        const hasMin = term.length >= MIN_CHARACTERS;

        if (!term) {
            return;
        }

        if (isNumericTerm) {
            event.preventDefault();
            fetchProductAndAdd(Number(term));
            return;
        }

        if (!hasMin) {
            event.preventDefault();
            setSearchTrigger((prev) => prev + 1);
        }
    };

    const resetValePicker = () => {
        setValePickerVisible(false);
        setValeSearchTerm('');
        setValeResults([]);
        setValeLoading(false);
    };

    const handleCashValueChange = (event) => {
        setCashValue(event.target.value);
        setSaleError('');
    };

    const handleCashInputKeyDown = (event) => {
        if (event.key !== 'Enter') {
            return;
        }

        if (saleLoading) {
            return;
        }

        if (numericCashValue <= 0) {
            setSaleError('Informe o valor recebido em dinheiro para finalizar.');
            return;
        }

        finalizeSale('dinheiro', { cashAmount: numericCashValue });
    };

    const finalizeSale = (type, { valeUserId = null, cashAmount = null } = {}) => {
        if (items.length === 0) {
            setSaleError('Adicione pelo menos um item antes de finalizar.');
            return;
        }

        const metaToken =
            document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ?? '';
        const csrfToken = metaToken || csrfTokenProp;

        setSaleLoading(true);
        setSaleError('');

        fetch(route('sales.store'), {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                'X-CSRF-TOKEN': csrfToken,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
            body: JSON.stringify({
                _token: csrfToken,
                items: items.map((item) => ({
                    product_id: item.id,
                    quantity: item.quantity,
                })),
                tipo_pago: type,
                vale_user_id: valeUserId,
                valor_pago: cashAmount,
            }),
        })
            .then(async (response) => {
                if (response.ok) {
                    return response.json();
                }

                let message = 'Falha ao registrar a venda.';

                try {
                    const data = await response.json();
                    if (data?.message) {
                        message = data.message;
                    } else if (data?.errors) {
                        const firstError = Object.values(data.errors).flat()[0];
                        if (firstError) {
                            message = firstError;
                        }
                    }
                } catch {
                    // Ignora erros de parse para manter a mensagem padrao.
                }

                throw new Error(message);
            })
            .then((data) => {
                setReceiptData({
                    ...data.sale,
                    payment_label: paymentLabels[data.sale.tipo_pago] ?? data.sale.tipo_pago,
                });
                setShowReceipt(true);
                resetValePicker();
                setCashInputVisible(false);
                setCashValue('');
            })
            .catch((err) => {
                setSaleError(err.message || 'Erro inesperado ao registrar a venda.');
            })
            .finally(() => {
                setSaleLoading(false);
            });
    };

    const handlePaymentClick = (type) => {
        if (saleLoading) {
            return;
        }

        if (items.length === 0) {
            setSaleError('Adicione pelo menos um item antes de escolher o pagamento.');
            return;
        }

        if (type === 'vale') {
            setCashInputVisible(false);
            setCashValue('');
            setValePickerVisible(true);
            setValeSearchTerm('');
            setValeResults([]);
            setSaleError('');
            return;
        }

        if (type === 'dinheiro') {
            resetValePicker();
            setSaleError('');
            if (!cashInputVisible) {
                setCashInputVisible(true);
                requestAnimationFrame(() => {
                    cashInputRef.current?.focus();
                });
                return;
            }

            if (numericCashValue <= 0) {
                setSaleError('Informe o valor recebido em dinheiro e pressione Enter.');
                cashInputRef.current?.focus();
                return;
            }

            finalizeSale('dinheiro', { cashAmount: numericCashValue });
            return;
        }

        resetValePicker();
        setCashInputVisible(false);
        setCashValue('');
        finalizeSale(type);
    };

    const handleSelectValeUser = (user) => {
        finalizeSale('vale', { valeUserId: user.id });
    };

    const handlePrintReceipt = () => {
        if (!receiptData) {
            return;
        }

        const printWindow = window.open('', '_blank', 'width=400,height=600');

        if (!printWindow) {
            setSaleError('Permita pop-ups para imprimir o cupom.');
            return;
        }

        const itemsHtml = (receiptData.items || [])
            .map(
                (item) => `
                    <div class="items-row">
                        <span>${item.quantity}x ${item.product_name}</span>
                        <span>${formatCurrency(item.unit_price)}</span>
                    </div>
                    <div class="items-row items-row-subtotal">
                        <span>Subtotal</span>
                        <span>${formatCurrency(item.subtotal)}</span>
                    </div>
                `,
            )
            .join('');

        const paymentHtml = receiptData.payment
            ? `
                    ${
                        receiptData.payment.valor_pago !== null
                            ? `<p>Pago em dinheiro: ${formatCurrency(receiptData.payment.valor_pago)}</p>`
                            : ''
                    }
                    <p>Troco: ${formatCurrency(receiptData.payment.troco ?? 0)}</p>
                    ${
                        receiptData.payment.dois_pgto > 0
                            ? `<p>Cartão (compl.): ${formatCurrency(receiptData.payment.dois_pgto)}</p>`
                            : ''
                    }
                `
            : '';

        const receiptHtml = `
            <!DOCTYPE html>
            <html>
                <head>
                    <meta charset="utf-8" />
                    <title>Cupom Fiscal</title>
                    <style>
                        * { font-family: 'Courier New', monospace; box-sizing: border-box; }
                        body { width: 80mm; margin: 0 auto; padding: 12px; }
                        h1 { text-align: center; font-size: 16px; margin: 0 0 10px 0; }
                        p { font-size: 12px; margin: 4px 0; }
                        .divider { border-top: 1px dashed #000; margin: 10px 0; }
                        .items-row { display: flex; justify-content: space-between; margin-bottom: 4px; font-size: 12px; }
                        .items-row-subtotal { font-style: italic; }
                        .total { font-size: 14px; font-weight: bold; text-align: right; margin-top: 10px; }
                    </style>
                </head>
                <body>
                    <h1>${activeUnitName || 'Registro de venda'}</h1>
                    <p>Caixa: ${receiptData.cashier_name}</p>
                    ${receiptData.vale_user_name ? `<p>Vale: ${receiptData.vale_user_name}</p>` : ''}
                    <p>Data: ${formatDateTime(receiptData.date_time)}</p>
                    <div class="divider"></div>
                    ${itemsHtml}
                    <div class="divider"></div>
                    <p>Pagamento: ${
                        paymentLabels[receiptData.tipo_pago] ?? receiptData.tipo_pago
                    }</p>
                    ${paymentHtml}
                    <div class="total">Total: ${formatCurrency(receiptData.total)}</div>
                    <p style="text-align:center;margin-top:12px;">Obrigado pela preferencia</p>
                </body>
            </html>
        `;

        printWindow.document.write(receiptHtml);
        printWindow.document.close();
        printWindow.focus();
        printWindow.print();
        printWindow.close();
        resetAfterReceipt();
    };

    const resetAfterReceipt = () => {
        setTexto('');
        setSuggestions([]);
        setLastManualSearch(false);
        setItems([]);
        setSaleError('');
        setReceiptData(null);
        setShowReceipt(false);
        resetValePicker();
        setCashInputVisible(false);
        setCashValue('');
        setHideSuggestions(false);
        requestAnimationFrame(() => {
            inputRef.current?.focus();
        });
    };

    const handleCloseReceipt = () => {
        setShowReceipt(false);
        setReceiptData(null);
    };

    const headerContent = (
        <div className="space-y-3">
            <label
                htmlFor="campo-dashboard"
                className="block text-sm font-medium text-gray-700 dark:text-gray-200"
            >
                Busca por produto
            </label>
            <div className="flex flex-col gap-4 lg:flex-row lg:items-center">
                <div className="flex-1">
                    <input
                        id="campo-dashboard"
                        type="text"
                        ref={inputRef}
                        value={texto}
                        onChange={handleInputChange}
                        onKeyDown={handleKeyDown}
                        placeholder="Digite nome, codigo ou ID"
                        className="block w-full rounded-2xl border-2 border-indigo-300 bg-white px-5 py-4 text-lg text-gray-900 shadow focus:border-indigo-500 focus:outline-none focus:ring-4 focus:ring-indigo-200 dark:bg-gray-700 dark:text-gray-100"
                        disabled={addingItem || saleLoading}
                    />
                    <p className="mt-2 text-xs text-gray-500 dark:text-gray-300">
                        Digite pelo menos {MIN_CHARACTERS} caracteres ou pressione Enter com o ID do produto. Cada Enter incrementa a quantidade do item atual.
                    </p>
                </div>
                <div className="w-full max-w-xs rounded-2xl border border-indigo-100 bg-indigo-50 px-5 py-4 text-center shadow-inner dark:border-indigo-400/50 dark:bg-indigo-900/30">
                    <p className="text-sm font-medium text-indigo-800 dark:text-indigo-200">
                        Total em itens
                    </p>
                    <p className="text-3xl font-bold text-indigo-600 dark:text-indigo-200">
                        {formatCurrency(totalAmount)}
                    </p>
                </div>
            </div>
        </div>
    );
    return (
        <AuthenticatedLayout header={headerContent}>
            <Head title="Dashboard" />

            <div className="py-12">
                <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                    <div className="overflow-hidden bg-white shadow-sm sm:rounded-lg dark:bg-gray-800">
                        <div className="p-6 text-gray-900 dark:text-gray-100">
                            <div className="space-y-6">
                                {saleError && (
                                    <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700 dark:border-red-400/50 dark:bg-red-950/30 dark:text-red-200">
                                        {saleError}
                                    </div>
                                )}

                                {(saleLoading || addingItem) && (
                                    <p className="text-sm text-indigo-600 dark:text-indigo-300">
                                        {saleLoading ? 'Registrando pagamento...' : 'Adicionando produto...'}
                                    </p>
                                )}

                                {showSuggestions && (
                                    <div className="w-full max-w-3xl rounded-2xl border border-gray-200 bg-white shadow-lg dark:border-gray-700 dark:bg-gray-900">
                                        {loading && (
                                            <p className="px-4 py-3 text-sm text-gray-500 dark:text-gray-400">
                                                Buscando produtos...
                                            </p>
                                        )}
                                        {!loading && error && (
                                            <p className="px-4 py-3 text-sm text-red-600 dark:text-red-400">
                                                {error}
                                            </p>
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
                                                                    ID: {product.tb1_id} | Codigo: {product.tb1_codbar}
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

                                <div className="rounded-2xl border border-gray-200 p-4 shadow-sm dark:border-gray-700">
                                    <div className="flex items-center justify-between">
                                        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">
                                            Itens adicionados
                                        </h3>
                                        <span className="text-sm text-gray-500 dark:text-gray-300">
                                            {items.length} produto(s)
                                        </span>
                                    </div>
                                    {items.length === 0 ? (
                                        <p className="mt-4 text-sm text-gray-600 dark:text-gray-300">
                                            Nenhum item adicionado. Informe o ID e pressione Enter ou selecione na lista.
                                        </p>
                                    ) : (
                                        <div className="mt-4 overflow-x-auto">
                                            <table className="min-w-full divide-y divide-gray-200 text-sm dark:divide-gray-700">
                                                <thead className="bg-gray-50 dark:bg-gray-900/40">
                                                    <tr>
                                                        <th className="px-3 py-2 text-left font-medium text-gray-600 dark:text-gray-300">
                                                            Produto
                                                        </th>
                                                        <th className="px-3 py-2 text-center font-medium text-gray-600 dark:text-gray-300">
                                                            Qtd
                                                        </th>
                                                        <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                                                            Valor unit.
                                                        </th>
                                                        <th className="px-3 py-2 text-right font-medium text-gray-600 dark:text-gray-300">
                                                            Subtotal
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-gray-100 dark:divide-gray-800">
                                                    {items.map((item) => (
                                                        <tr key={item.id}>
                                                            <td className="px-3 py-2">
                                                                <p className="font-medium text-gray-800 dark:text-gray-100">
                                                                    {item.name}
                                                                </p>
                                                                <p className="text-xs text-gray-500 dark:text-gray-400">
                                                                    ID {item.id}
                                                                </p>
                                                            </td>
                                                            <td className="px-3 py-2 text-center text-gray-800 dark:text-gray-100">
                                                                {item.quantity}
                                                            </td>
                                                            <td className="px-3 py-2 text-right text-gray-800 dark:text-gray-100">
                                                                {formatCurrency(item.price)}
                                                            </td>
                                                            <td className="px-3 py-2 text-right font-semibold text-gray-900 dark:text-gray-50">
                                                                {formatCurrency(item.quantity * item.price)}
                                                            </td>
                                                        </tr>
                                                    ))}
                                                </tbody>
                                            </table>
                                        </div>
                                    )}
                                    <div className="mt-4 flex items-center justify-between border-t border-gray-100 pt-4 dark:border-gray-700">
                                        <p className="text-base font-semibold text-gray-700 dark:text-gray-200">
                                            Total
                                        </p>
                                        <p className="text-2xl font-bold text-indigo-600 dark:text-indigo-300">
                                            {formatCurrency(totalAmount)}
                                        </p>
                                    </div>

                                    <div className="mt-6 border-t border-gray-100 pt-4 dark:border-gray-700">
                                        <p className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                            Selecione o tipo de pagamento
                                        </p>
                                    </div>
                                    <div className="mt-3 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
                                        {paymentOptions.map((option) => (
                                            <button
                                                type="button"
                                                key={option.value}
                                                onClick={() => handlePaymentClick(option.value)}
                                                disabled={saleLoading || items.length === 0}
                                                className={`rounded-2xl px-4 py-3 text-center text-base font-semibold shadow focus:outline-none focus:ring-4 disabled:cursor-not-allowed disabled:opacity-60 ${option.classes}`}
                                            >
                                                {option.label}
                                            </button>
                                        ))}
                                    </div>

                                    {cashInputVisible && (
                                        <div className="mt-4 rounded-2xl border border-green-200 bg-green-50 p-4 shadow dark:border-green-500/40 dark:bg-green-900/20">
                                            <label className="text-sm font-medium text-gray-700 dark:text-gray-100">
                                                Valor recebido em dinheiro
                                            </label>
                                            <input
                                                type="number"
                                                ref={cashInputRef}
                                                min="0"
                                                step="0.01"
                                                value={cashValue}
                                                onChange={handleCashValueChange}
                                                onKeyDown={handleCashInputKeyDown}
                                                disabled={saleLoading}
                                                className="mt-2 w-full rounded-xl border border-gray-300 px-4 py-2 text-lg text-gray-900 focus:border-green-600 focus:outline-none focus:ring-2 focus:ring-green-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                                placeholder="Ex.: 50.00"
                                            />
                                            <div className="mt-3 flex flex-wrap items-center justify-between text-sm text-gray-700 dark:text-gray-100">
                                                <span>Troco:</span>
                                                <span className="font-semibold">{formatCurrency(cashChange)}</span>
                                            </div>
                                            {cashCardComplement > 0 && (
                                                <p className="mt-2 text-xs text-amber-700 dark:text-amber-200">
                                                    Restante no cartão: {formatCurrency(cashCardComplement)}
                                                </p>
                                            )}
                                            <p className="mt-2 text-xs text-gray-600 dark:text-gray-300">
                                                Informe o valor recebido e pressione Enter para finalizar.
                                            </p>
                                        </div>
                                    )}
                                </div>

                                {valePickerVisible && (
                                    <div className="rounded-2xl border border-amber-200 bg-amber-50 p-4 shadow dark:border-amber-400/40 dark:bg-amber-900/20">
                                        <div className="flex items-center justify-between">
                                            <div>
                                                <h3 className="text-lg font-semibold text-amber-800 dark:text-amber-100">
                                                    Selecionar colaborador para vale
                                                </h3>
                                                <p className="text-sm text-amber-700 dark:text-amber-100">
                                                    Total atual: {formatCurrency(totalAmount)}
                                                </p>
                                            </div>
                                            <button
                                                type="button"
                                                onClick={resetValePicker}
                                                className="text-sm font-medium text-amber-700 underline hover:text-amber-900 dark:text-amber-200"
                                            >
                                                Cancelar
                                            </button>
                                        </div>
                                        <div className="mt-4">
                                            <label className="text-sm text-gray-700 dark:text-gray-200">
                                                Buscar usuarios
                                            </label>
                                            <input
                                                type="text"
                                                value={valeSearchTerm}
                                                onChange={(event) => setValeSearchTerm(event.target.value)}
                                                placeholder="Digite pelo menos 2 letras"
                                                className="mt-2 block w-full rounded-xl border border-gray-300 px-3 py-2 text-gray-800 focus:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                            />
                                        </div>
                                        <div className="mt-4">
                                            {valeLoading && (
                                                <p className="text-sm text-gray-600 dark:text-gray-200">Buscando usuarios...</p>
                                            )}
                                            {!valeLoading && valeResults.length === 0 && (
                                                <p className="text-sm text-gray-600 dark:text-gray-200">
                                                    Nenhum usuario encontrado.
                                                </p>
                                            )}
                                            {!valeLoading && valeResults.length > 0 && (
                                                <ul className="divide-y divide-gray-200 rounded-xl border border-gray-200 bg-white dark:divide-gray-700 dark:border-gray-700 dark:bg-gray-800">
                                                    {valeResults.map((user) => (
                                                        <li key={user.id}>
                                                            <button
                                                                type="button"
                                                                onClick={() => handleSelectValeUser(user)}
                                                                className="flex w-full items-center justify-between px-4 py-3 text-left text-sm font-medium text-gray-800 hover:bg-indigo-50 dark:text-gray-100 dark:hover:bg-indigo-900/30"
                                                            >
                                                                <span>{user.name}</span>
                                                                <span className="text-xs text-gray-500 dark:text-gray-300">
                                                                    Selecionar
                                                                </span>
                                                            </button>
                                                        </li>
                                                    ))}
                                                </ul>
                                            )}
                                        </div>
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {showReceipt && receiptData && (
                <div className="fixed inset-0 z-40 flex items-center justify-center bg-black/60 px-4 py-6">
                    <div className="w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl dark:bg-gray-900">
                        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">
                            Cupom pronto para impressao
                        </h3>
                        <div className="mt-4 space-y-2 text-sm text-gray-700 dark:text-gray-200">
                            {(receiptData.items || []).map((item) => (
                                <div key={item.product_id} className="flex items-center justify-between">
                                    <div>
                                        <p className="font-medium">
                                            {item.quantity}x {item.product_name}
                                        </p>
                                        <p className="text-xs text-gray-500">
                                            {formatCurrency(item.unit_price)} cada
                                        </p>
                                    </div>
                                    <p className="font-semibold">{formatCurrency(item.subtotal)}</p>
                                </div>
                            ))}
                            <p>
                                <span className="font-medium">Pagamento:</span> {receiptData.payment_label}
                            </p>
                            {receiptData.payment?.valor_pago !== null && (
                                <p>
                                    <span className="font-medium">Valor pago:</span>{' '}
                                    {formatCurrency(receiptData.payment.valor_pago)}
                                </p>
                            )}
                            <p>
                                <span className="font-medium">Troco:</span>{' '}
                                {formatCurrency(receiptData.payment?.troco ?? 0)}
                            </p>
                            {receiptData.payment?.dois_pgto > 0 && (
                                <p>
                                    <span className="font-medium">Cartão (compl.):</span>{' '}
                                    {formatCurrency(receiptData.payment.dois_pgto)}
                                </p>
                            )}
                            <p>
                                <span className="font-medium">Caixa:</span> {receiptData.cashier_name}
                            </p>
                            {receiptData.vale_user_name && (
                                <p>
                                    <span className="font-medium">Cliente Vale:</span> {receiptData.vale_user_name}
                                </p>
                            )}
                            <p>
                                <span className="font-medium">Data:</span> {formatDateTime(receiptData.date_time)}
                            </p>
                            <p className="text-lg font-bold text-indigo-600">
                                Total: {formatCurrency(receiptData.total)}
                            </p>
                        </div>
                        <div className="mt-6 flex justify-end gap-3">
                            <button
                                type="button"
                                className="rounded-xl border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:text-gray-200 dark:hover:bg-gray-800"
                                onClick={handleCloseReceipt}
                            >
                                Fechar
                            </button>
                            <button
                                type="button"
                                className="rounded-xl bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-indigo-700"
                                onClick={handlePrintReceipt}
                            >
                                Imprimir
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </AuthenticatedLayout>
    );
}
