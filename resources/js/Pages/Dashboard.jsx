import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import axios from 'axios';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

const MIN_CHARACTERS = 3;
const numericRegex = /^\d+$/;
const paymentLabels = {
    maquina: 'Maquina',
    dinheiro: 'Dinheiro',
    vale: 'Vale',
    faturar: 'Faturar',
    refeicao: 'Refeição',
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

const normalizeCartItem = (item) => ({
    ...item,
    vrEligible: Boolean(
        item.vrEligible ?? item.vr_credit ?? item.tb1_vr_credit ?? false,
    ),
});

const ITEMS_STORAGE_KEY = 'dashboard.selectedItems';
const SAVED_CARTS_STORAGE_KEY = 'dashboard.savedCarts';

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
    const [selectedValeType, setSelectedValeType] = useState('vale');
    const [valeLoading, setValeLoading] = useState(false);
    const [receiptData, setReceiptData] = useState(null);
    const [showReceipt, setShowReceipt] = useState(false);
    const [cashInputVisible, setCashInputVisible] = useState(false);
    const [cashValue, setCashValue] = useState('');
    const cashInputRef = useRef(null);
    const [savedCarts, setSavedCarts] = useState([]);
    const [favoriteProducts, setFavoriteProducts] = useState([]);
    const [showChangeCard, setShowChangeCard] = useState(false);
    const [openComandasAmount, setOpenComandasAmount] = useState(0);
    const [openComandasCount, setOpenComandasCount] = useState(0);
    const [openComandasList, setOpenComandasList] = useState([]);
    const [showComandasButtons, setShowComandasButtons] = useState(false);
    const [comandaLoading, setComandaLoading] = useState(false);
    const [selectedComandaCode, setSelectedComandaCode] = useState(null);

    useEffect(() => {
        if (typeof window === 'undefined') {
            return;
        }

        const storedItems = window.localStorage.getItem(ITEMS_STORAGE_KEY);

        if (!storedItems) {
            return;
        }

        try {
            const parsed = JSON.parse(storedItems);

            if (Array.isArray(parsed) && parsed.length > 0) {
                setItems(parsed.map((item) => normalizeCartItem(item)));
            }
        } catch (storageError) {
            console.error('Failed to parse stored sale items', storageError);
            window.localStorage.removeItem(ITEMS_STORAGE_KEY);
        }
    }, []);

    useEffect(() => {
        if (typeof window === 'undefined') {
            return;
        }

        if (items.length === 0) {
            window.localStorage.removeItem(ITEMS_STORAGE_KEY);
            return;
        }

        window.localStorage.setItem(ITEMS_STORAGE_KEY, JSON.stringify(items));
    }, [items]);

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
    const totalItems = useMemo(
        () => items.reduce((sum, item) => sum + (item.quantity ?? 0), 0),
        [items],
    );
    const openCommandasCount = 0;
    const isComandaMode = false;

    const hasVrRestrictions = useMemo(
        () => items.some((item) => !item.vrEligible),
        [items],
    );
    const canUseRefeicao = useMemo(
        () => items.length > 0 && !hasVrRestrictions,
        [items.length, hasVrRestrictions],
    );

    useEffect(() => {
        inputRef.current?.focus();
    }, []);
    useEffect(() => {
        if (typeof window === 'undefined') {
            return;
        }

        const storedCarts = window.localStorage.getItem(SAVED_CARTS_STORAGE_KEY);

        if (!storedCarts) {
            return;
        }

        try {
            const parsed = JSON.parse(storedCarts);

            if (Array.isArray(parsed) && parsed.length > 0) {
                setSavedCarts(parsed);
            }
        } catch (storageError) {
            console.error('Failed to parse saved carts', storageError);
            window.localStorage.removeItem(SAVED_CARTS_STORAGE_KEY);
        }
    }, []);

    useEffect(() => {
        if (typeof window === 'undefined') {
            return;
        }

        if (savedCarts.length === 0) {
            window.localStorage.removeItem(SAVED_CARTS_STORAGE_KEY);
            return;
        }

        window.localStorage.setItem(
            SAVED_CARTS_STORAGE_KEY,
            JSON.stringify(savedCarts),
        );
    }, [savedCarts]);

    useEffect(() => {
        let isMounted = true;

        fetch(route('products.favorites'), {
            headers: {
                Accept: 'application/json',
            },
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Falha ao carregar favoritos');
                }

                return response.json();
            })
            .then((data) => {
                if (!isMounted) {
                    return;
                }

                setFavoriteProducts(
                    Array.isArray(data)
                        ? data.map((product) => ({
                              ...product,
                              tb1_vr_credit: Boolean(product.tb1_vr_credit),
                          }))
                        : [],
                );
            })
            .catch(() => {
                if (!isMounted) {
                    return;
                }

                setFavoriteProducts([]);
            });

        return () => {
            isMounted = false;
        };
    }, []);

    const fetchOpenComandas = useCallback(() => {
        let isMounted = true;

        axios
            .get(route('sales.open-comandas'))
            .then((response) => {
                if (!isMounted) {
                    return;
                }
                const data = response.data ?? {};
                setOpenComandasAmount(Number(data.total_amount ?? 0));
                setOpenComandasCount(Number(data.total_comandas ?? 0));
                setOpenComandasList(Array.isArray(data.comandas) ? data.comandas : []);
            })
            .catch(() => {
                if (isMounted) {
                    setOpenComandasAmount(0);
                    setOpenComandasCount(0);
                    setOpenComandasList([]);
                }
            });

        return () => {
            isMounted = false;
        };
    }, []);

    useEffect(() => {
        const cleanup = fetchOpenComandas();
        return cleanup;
    }, [fetchOpenComandas]);

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
            setShowChangeCard(false);
        }
    }, [items.length]);

    useEffect(() => {
        if (!canUseRefeicao && selectedValeType === 'refeicao') {
            setSelectedValeType('vale');
        }
    }, [canUseRefeicao, selectedValeType]);

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
                    vrEligible: Boolean(product.tb1_vr_credit),
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

    const incrementItemQuantity = (itemId) => {
        setItems((prevItems) =>
            prevItems.map((item) =>
                item.id === itemId
                    ? { ...item, quantity: item.quantity + 1 }
                    : item,
            ),
        );
    };

    const decrementItemQuantity = (itemId) => {
        setItems((prevItems) =>
            prevItems
                .map((item) => {
                    if (item.id !== itemId) {
                        return item;
                    }

                    const nextQuantity = Math.max(item.quantity - 1, 0);
                    return { ...item, quantity: nextQuantity };
                })
                .filter((item) => item.quantity > 0),
        );
    };

    const removeItem = (itemId) => {
        setItems((prevItems) => prevItems.filter((item) => item.id !== itemId));
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
        setSelectedValeType('vale');
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

    const finalizeSale = (type, { valeUserId = null, valeType = null, cashAmount = null } = {}) => {
        if (items.length === 0) {
            setSaleError('Adicione pelo menos um item antes de finalizar.');
            return;
        }

        setSaleLoading(true);
        setSaleError('');
        const payload = {
            _token: csrfTokenProp,
            tipo_pago: type,
            vale_user_id: valeUserId,
            vale_type: type === 'vale' ? valeType : null,
            valor_pago: cashAmount,
        };

        if (selectedComandaCode !== null) {
            payload.comanda_codigo = selectedComandaCode;
        } else {
            payload.items = items.map((item) => ({
                product_id: item.id,
                quantity: item.quantity,
            }));
        }

        axios
            .post(route('sales.store'), payload)
            .then((response) => {
                const data = response.data;
                setReceiptData({
                    ...data.sale,
                    payment_label: paymentLabels[data.sale.tipo_pago] ?? data.sale.tipo_pago,
                });
                setShowReceipt(true);
                resetValePicker();
                setCashInputVisible(false);
                setCashValue('');
                if (selectedComandaCode !== null) {
                    setSelectedComandaCode(null);
                    setItems([]);
                    fetchOpenComandas();
                }
            })
            .catch((error) => {
                let message = 'Falha ao registrar a venda.';

                if (error.response?.data) {
                    const data = error.response.data;
                    if (data.message) {
                        message = data.message;
                    } else if (data.errors) {
                        const firstError = Object.values(data.errors).flat()[0];
                        if (firstError) {
                            message = firstError;
                        }
                    }
                } else if (error.message) {
                    message = error.message;
                }

                setSaleError(message);
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
            setSelectedValeType('vale');
            setSaleError('');
            return;
        }

        if (type === 'dinheiro') {
            resetValePicker();
            setSaleError('');
            if (!cashInputVisible) {
                setCashInputVisible(true);
                setShowChangeCard(true);
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
        setShowChangeCard(false);
        setCashValue('');
        finalizeSale(type);
    };

    const handleLoadComandaItems = (codigo) => {
        setComandaLoading(true);
        axios
            .get(route('sales.comandas.items', { codigo }))
            .then((response) => {
                const data = response.data ?? {};
                const mapped = Array.isArray(data.items)
                    ? data.items.map((item) => ({
                          id: item.id,
                          name: item.name,
                          price: Number(item.price ?? 0),
                          quantity: Number(item.quantity ?? 0),
                          vrEligible: true,
                      }))
                    : [];
                setItems(mapped);
                setSelectedComandaCode(codigo);
                setSaleError('');
                setShowComandasButtons(false);
                fetchOpenComandas();
            })
            .catch(() => {
                setSaleError('Nao foi possivel carregar os itens da comanda.');
            })
            .finally(() => {
                setComandaLoading(false);
            });
    };

    const handleSelectValeUser = (user) => {
        if (selectedValeType === 'refeicao' && !canUseRefeicao) {
            setSaleError('Há itens que não podem ser pagos com VR Crédito.');
            return;
        }

        if (selectedValeType === 'refeicao') {
            const balance = Number(user.refeicao_balance ?? user.vr_cred ?? 0);
            if (totalAmount > balance) {
                setSaleError(
                    `Saldo de refeicao insuficiente para ${user.name}. Disponivel: ${formatCurrency(balance)}`,
                );
                return;
            }
        }

        finalizeSale('vale', { valeUserId: user.id, valeType: selectedValeType });
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
                            ? `<p>Cartao (compl.): ${formatCurrency(receiptData.payment.dois_pgto)}</p>`
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
                    ${
                        receiptData.vale_user_name
                            ? `<p>Vale: ${receiptData.vale_user_name}${
                                  receiptData.vale_type === 'refeicao' ? ' (RefeiÃ§Ã£o)' : ''
                              }</p>`
                            : ''
                    }
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

    const resetSaleState = () => {
        setTexto('');
        setSuggestions([]);
        setLastManualSearch(false);
        setItems([]);
        if (typeof window !== 'undefined') {
            window.localStorage.removeItem(ITEMS_STORAGE_KEY);
        }
        setSaleError('');
        resetValePicker();
        setCashInputVisible(false);
        setCashValue('');
        setHideSuggestions(false);
        requestAnimationFrame(() => {
            inputRef.current?.focus();
        });
    };

    const resetAfterReceipt = () => {
        resetSaleState();
        setReceiptData(null);
        setShowReceipt(false);
    };

    const handleCloseReceipt = () => {
        resetAfterReceipt();
    };

    const handleSaveCart = () => {
        if (items.length === 0) {
            setSaleError('Nenhum item para guardar.');
            return;
        }

        const snapshot = items.map((item) => ({ ...item }));
        const cartId = `${Date.now()}-${Math.random().toString(36).slice(2)}`;

        setSavedCarts((prev) => [
            ...prev,
            {
                id: cartId,
                items: snapshot,
                total: totalAmount,
            },
        ]);

        resetSaleState();
    };

    const handleRestoreCart = (cartId) => {
        const targetCart = savedCarts.find((cart) => cart.id === cartId);

        if (!targetCart) {
            return;
        }

        setSavedCarts((prev) => prev.filter((cart) => cart.id !== cartId));
        const sanitizedItems = targetCart.items.map((item) => normalizeCartItem(item));
        setItems(sanitizedItems);
        setSaleError('');
        setTexto('');
        setHideSuggestions(true);
        setCashInputVisible(false);
        setCashValue('');
        if (typeof window !== 'undefined') {
            window.localStorage.setItem(
                ITEMS_STORAGE_KEY,
                JSON.stringify(sanitizedItems),
            );
        }
        requestAnimationFrame(() => {
            inputRef.current?.focus();
        });
    };

    const handleFavoriteQuickAdd = (product) => {
        addItemFromProduct(product, { preserveInput: true });
    };

    const headerContent = (
        <div className="space-y-3">
            <div className="flex flex-wrap items-center gap-3">
                <label
                    htmlFor="campo-dashboard"
                    className="text-sm font-medium text-gray-700 dark:text-gray-200"
                >
                    Busca por produto
                </label>
                {favoriteProducts.length > 0 && (
                    <div className="flex flex-wrap gap-2">
                        {favoriteProducts.map((product) => (
                            <button
                                type="button"
                                key={`favorite-${product.tb1_id}`}
                                onClick={() => handleFavoriteQuickAdd(product)}
                                className="rounded-full border border-gray-200 px-3 py-1 text-xs font-semibold text-gray-600 transition hover:border-indigo-400 hover:text-indigo-600 dark:border-gray-600 dark:text-gray-200"
                            >
                                {product.tb1_nome}
                            </button>
                        ))}
                    </div>
                )}
            </div>
            <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:gap-6">
                <div className="flex-1">
                    <div className="flex flex-col gap-1">
                        <input
                            id="campo-dashboard"
                            type="text"
                            ref={inputRef}
                            value={texto}
                            onChange={handleInputChange}
                            onKeyDown={handleKeyDown}
                            placeholder="Digite nome, codigo ou ID"
                            className="block w-full rounded-2xl border-2 border-indigo-300 bg-white px-4 py-3 text-lg text-gray-900 shadow focus:border-indigo-500 focus:outline-none focus:ring-4 focus:ring-indigo-200 disabled:opacity-60 dark:bg-gray-700 dark:text-gray-100"
                            disabled={addingItem || saleLoading}
                        />
                        <div className="flex items-center justify-between text-xs text-gray-500 dark:text-gray-300">
                            <span>Digite pelo menos {MIN_CHARACTERS} caracteres ou pressione Enter com o ID do produto.</span>
                            <span className="inline-flex items-center gap-1 font-semibold text-emerald-600 dark:text-emerald-400">
                                <i className="bi bi-list-check" aria-hidden="true"></i>
                                {totalItems} item(s)
                            </span>
                        </div>
                    </div>
                </div>
                <div className="flex w-full flex-col gap-2 sm:flex-row sm:justify-end lg:w-auto lg:gap-3">
                    <div className="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-left shadow-sm dark:border-emerald-500/30 dark:bg-emerald-900/20">
                        <p className="text-xs font-semibold uppercase text-emerald-700 dark:text-emerald-200">Total</p>
                        <p className="text-2xl font-bold text-emerald-700 dark:text-emerald-100">
                            {formatCurrency(totalAmount)}
                        </p>
                        <p className="text-xs font-semibold text-emerald-700 dark:text-emerald-200">{totalItems} item(s)</p>
                    </div>
                    {showChangeCard && (
                        <div className="flex items-center justify-between rounded-2xl border border-blue-200 bg-blue-50 px-4 py-3 shadow-sm dark:border-blue-500/30 dark:bg-blue-900/20">
                            <div>
                                <p className="text-xs font-semibold uppercase text-blue-700 dark:text-blue-200">Troco</p>
                                <p className="text-2xl font-bold text-blue-700 dark:text-blue-100">
                                    {formatCurrency(cashChange)}
                                </p>
                            </div>
                            <i className="bi bi-wallet2 text-xl text-blue-500 dark:text-blue-200" aria-hidden="true"></i>
                        </div>
                    )}
                    <div className="flex items-center justify-between rounded-2xl border border-red-200 bg-red-50 px-4 py-3 shadow-sm dark:border-red-500/30 dark:bg-red-900/20">
                        <div>
                            <p className="text-xs font-semibold uppercase text-red-700 dark:text-red-200">Comandas</p>
                            <p className="text-xl font-bold text-red-600 dark:text-red-100">
                                {formatCurrency(openComandasAmount)}
                            </p>
                            <p className="text-[11px] font-semibold text-red-500 dark:text-red-200">{openComandasCount} em aberto</p>
                        </div>
                        <button
                            type="button"
                            onClick={() => setShowComandasButtons((prev) => !prev)}
                            className="rounded-full border border-red-200 bg-white px-2 py-1 text-xs font-semibold text-red-600 transition hover:border-red-400 dark:border-red-500/40 dark:bg-red-800/40 dark:text-red-100"
                            title="Ver comandas"
                        >
                            <i className="bi bi-egg-fried text-base" aria-hidden="true"></i>
                        </button>
                    </div>
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
                                    <div className="flex flex-wrap items-center justify-between gap-3">
                                        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">
                                            Itens adicionados
                                        </h3>
                                        <div className="flex items-center gap-3">
                                            <button
                                                type="button"
                                                onClick={handleSaveCart}
                                                disabled={items.length === 0}
                                                className="inline-flex items-center gap-2 rounded-xl border border-gray-200 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:border-indigo-400 hover:text-indigo-600 disabled:cursor-not-allowed disabled:opacity-50 dark:border-gray-600 dark:text-gray-200"
                                            >
                                                <i className="bi bi-download" aria-hidden="true"></i>
                                                Guardar lista
                                            </button>
                                            <span className="text-sm text-gray-500 dark:text-gray-300">
                                                {items.length} produto(s)
                                            </span>
                                        </div>
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
                                                        <th className="px-3 py-2 text-center font-medium text-gray-600 dark:text-gray-300">
                                                            Remover
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
                                                                <div className="flex items-center justify-center gap-2">
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => incrementItemQuantity(item.id)}
                                                                        className="text-indigo-600 transition hover:text-indigo-400 focus:outline-none disabled:opacity-50"
                                                                        disabled={saleLoading}
                                                                        aria-label={`Adicionar uma unidade de ${item.name}`}
                                                                    >
                                                                        <i className="bi bi-plus-circle-fill text-lg" aria-hidden="true"></i>
                                                                    </button>
                                                                    <span className="text-base font-semibold">{item.quantity}</span>
                                                                    <button
                                                                        type="button"
                                                                        onClick={() => decrementItemQuantity(item.id)}
                                                                        className="text-red-500 transition hover:text-red-400 focus:outline-none disabled:opacity-50"
                                                                        disabled={saleLoading}
                                                                        aria-label={`Remover uma unidade de ${item.name}`}
                                                                    >
                                                                        <i className="bi bi-dash-circle-fill text-lg" aria-hidden="true"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                            <td className="px-3 py-2 text-right text-gray-800 dark:text-gray-100">
                                                                {formatCurrency(item.price)}
                                                            </td>
                                                            <td className="px-3 py-2 text-right font-semibold text-gray-900 dark:text-gray-50">
                                                                {formatCurrency(item.quantity * item.price)}
                                                            </td>
                                                            <td className="px-3 py-2 text-center">
                                                                <button
                                                                    type="button"
                                                                    onClick={() => removeItem(item.id)}
                                                                    className="text-red-600 transition hover:text-red-400 focus:outline-none disabled:opacity-50"
                                                                    disabled={saleLoading}
                                                                >
                                                                    <i className="bi bi-trash-fill text-lg" aria-hidden="true"></i>
                                                                    <span className="sr-only">Remover {item.name}</span>
                                                                </button>
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
                                                className={`rounded-lg px-4 py-3 text-center text-base font-semibold shadow focus:outline-none focus:ring-4 disabled:cursor-not-allowed disabled:opacity-60 ${option.classes}`}
                                            >
                                                {option.label}
                                            </button>
                                        ))}
                                    </div>

                                    {showComandasButtons && (
                                        <div className="mt-3 flex flex-wrap gap-2">
                                            {openComandasList.length === 0 ? (
                                                <span className="text-xs text-gray-500 dark:text-gray-300">
                                                    Nenhuma comanda em aberto.
                                                </span>
                                            ) : (
                                                openComandasList.map((comanda) => (
                                                    <button
                                                        type="button"
                                                        key={`comanda-${comanda.codigo}`}
                                                        onClick={() => handleLoadComandaItems(comanda.codigo)}
                                                        className="inline-flex items-center rounded-full border border-gray-300 px-3 py-1 text-xs font-semibold text-gray-700 shadow-sm transition hover:border-indigo-400 hover:text-indigo-600 dark:border-gray-600 dark:text-gray-100"
                                                    >
                                                        {comanda.codigo}
                                                    </button>
                                                ))
                                            )}
                                            {comandaLoading && (
                                                <span className="text-xs text-gray-500 dark:text-gray-300">
                                                    Carregando itens da comanda...
                                                </span>
                                            )}
                                        </div>
                                    )}

                                    {savedCarts.length > 0 && (
                                        <div className="mt-6 border-t border-gray-100 pt-4 dark:border-gray-700">
                                            <p className="text-sm font-medium text-gray-700 dark:text-gray-200">
                                                Pedidos guardados
                                            </p>
                                            <div className="mt-3 flex flex-wrap gap-2">
                                                {savedCarts.map((cart) => (
                                                    <button
                                                        type="button"
                                                        key={cart.id}
                                                        onClick={() => handleRestoreCart(cart.id)}
                                                        className="rounded-full border border-indigo-200 px-4 py-2 text-sm font-semibold text-indigo-700 shadow-sm transition hover:border-indigo-400 hover:bg-indigo-50 dark:border-indigo-500 dark:text-indigo-200"
                                                    >
                                                        {formatCurrency(cart.total)}
                                                    </button>
                                                ))}
                                            </div>
                                        </div>
                                    )}

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
                                        <div className="mt-4 flex flex-wrap gap-3">
                                            <label
                                                className={`flex cursor-pointer items-center gap-2 rounded-xl border px-4 py-2 text-sm font-semibold transition ${
                                                    selectedValeType === 'vale'
                                                        ? 'border-amber-500 bg-white text-amber-800 dark:bg-gray-900'
                                                        : 'border-gray-200 bg-white/70 text-gray-700 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-200'
                                                }`}
                                            >
                                                <input
                                                    type="radio"
                                                    name="vale-type"
                                                    value="vale"
                                                    checked={selectedValeType === 'vale'}
                                                    onChange={() => setSelectedValeType('vale')}
                                                className="h-4 w-4 text-amber-600 focus:ring-amber-500"
                                            />
                                            Vale
                                        </label>
                                        <label
                                                className={`flex items-center gap-2 rounded-xl border px-4 py-2 text-sm font-semibold transition ${
                                                    selectedValeType === 'refeicao'
                                                        ? 'border-amber-500 bg-white text-amber-800 dark:bg-gray-900'
                                                        : 'border-gray-200 bg-white/70 text-gray-700 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-200'
                                                } ${!canUseRefeicao ? 'cursor-not-allowed opacity-60' : 'cursor-pointer'}`}
                                            >
                                                <input
                                                    type="radio"
                                                    name="vale-type"
                                                    value="refeicao"
                                                    checked={selectedValeType === 'refeicao'}
                                                    onChange={() => setSelectedValeType('refeicao')}
                                                    disabled={!canUseRefeicao}
                                                    className="h-4 w-4 text-amber-600 focus:ring-amber-500"
                                                />
                                                Refeição
                                            </label>
                                        </div>
                                        <p className="mt-2 text-xs text-amber-800 dark:text-amber-100">
                                            {selectedValeType === 'refeicao'
                                                ? 'O saldo de Refeição do colaborador será utilizado; saldo insuficiente impede a venda.'
                                                : 'Utilize esta opção para lançar o valor no vale tradicional do colaborador.'}
                                        </p>
                                        {!canUseRefeicao && (
                                            <p className="mt-1 text-xs text-amber-700 dark:text-amber-200">
                                                Remova itens não liberados para VR Crédito para habilitar a opção Refeição.
                                            </p>
                                        )}
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
                                            {!valeLoading && valeResults.length === 0 && valeSearchTerm.trim().length >= 2 && (
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
                                                                <div>
                                                                    <p className="font-semibold">{user.name}</p>
                                                                    {selectedValeType === 'refeicao' && (
                                                                        <p className="text-xs text-amber-700 dark:text-amber-200">
                                                                            Saldo: {formatCurrency(user.refeicao_balance ?? user.vr_cred ?? 0)}
                                                                        </p>
                                                                    )}
                                                                </div>
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
                                    <span className="font-medium">Cartao (compl.):</span>{' '}
                                    {formatCurrency(receiptData.payment.dois_pgto)}
                                </p>
                            )}
                            <p>
                                <span className="font-medium">Caixa:</span> {receiptData.cashier_name}
                            </p>
                            {receiptData.vale_user_name && (
                                <p>
                                    <span className="font-medium">Cliente Vale:</span> {receiptData.vale_user_name}
                                    {receiptData.vale_type === 'refeicao' && (
                                        <span className="ml-1 text-xs text-amber-600 dark:text-amber-200">(Refeição)</span>
                                    )}
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
