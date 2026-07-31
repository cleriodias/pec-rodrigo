const DEFAULT_AGENT_URL = 'http://127.0.0.1:8787';
const DEFAULT_TIMEOUT_MS = 120000;

const normalizeBaseUrl = (value) => {
    const url = String(value ?? DEFAULT_AGENT_URL).trim();

    return url.replace(/\/+$/, '');
};

const onlyDigits = (value) => String(value ?? '').replace(/\D/g, '');

const resolvePaymentMethod = (paymentType, cardType = null) => {
    const type = paymentType === 'dinheiro' && cardType ? cardType : paymentType;

    if (type === 'cartao_credito') {
        return 'credit';
    }

    if (type === 'cartao_debito' || type === 'maquina') {
        return 'debit';
    }

    if (type === 'pix') {
        return 'pix';
    }

    return null;
};

const normalizeTefResponse = (data) => {
    const authorization =
        data?.autorizacao ??
        data?.authorization ??
        data?.authorization_code ??
        data?.codigo_autorizacao ??
        data?.codigoAutorizacao ??
        null;
    const acquirerDocument =
        data?.cnpj_credenciadora ??
        data?.acquirer_cnpj ??
        data?.acquirerDocument ??
        data?.cnpjCredenciadora ??
        data?.merchant_acquirer_document ??
        null;
    const brand =
        data?.bandeira ??
        data?.brand ??
        data?.card_brand ??
        data?.cardBrand ??
        null;
    const terminal =
        data?.terminal ??
        data?.terminal_id ??
        data?.terminalId ??
        data?.pos_id ??
        null;
    const paidAt =
        data?.transacao_em ??
        data?.paid_at ??
        data?.authorized_at ??
        data?.transactionDate ??
        data?.created_at ??
        new Date().toISOString();

    return {
        integrado: true,
        autorizacao: authorization,
        cnpj_credenciadora: onlyDigits(acquirerDocument),
        bandeira: brand,
        terminal,
        transacao_em: paidAt,
        payload: data,
    };
};

const assertApprovedResponse = (data) => {
    const status = String(data?.status ?? data?.payment_status ?? data?.situacao ?? '').toLowerCase();

    if (status && !['approved', 'authorized', 'autorizado', 'aprovado', 'paid', 'success'].includes(status)) {
        throw new Error(data?.message ?? data?.mensagem ?? `Pagamento C6/PayGo nao aprovado (${status}).`);
    }

    if (data?.approved === false || data?.authorized === false) {
        throw new Error(data?.message ?? data?.mensagem ?? 'Pagamento C6/PayGo nao aprovado.');
    }
};

const postToAgent = async (config, path, body) => {
    const controller = new AbortController();
    const timeout = window.setTimeout(
        () => controller.abort(),
        Number(config?.timeout_ms ?? DEFAULT_TIMEOUT_MS),
    );

    try {
        const response = await fetch(`${normalizeBaseUrl(config?.agent_url)}${path}`, {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
            signal: controller.signal,
        });

        const data = await response.json().catch(() => ({}));

        if (!response.ok) {
            throw new Error(data?.message ?? data?.mensagem ?? `Falha no agente C6/PayGo (${response.status}).`);
        }

        return data;
    } catch (error) {
        if (error?.name === 'AbortError') {
            throw new Error('Tempo esgotado aguardando resposta da maquininha C6/PayGo.');
        }

        throw error;
    } finally {
        window.clearTimeout(timeout);
    }
};

export const isC6TefConfigured = (config) => Boolean(config?.enabled);

export const requiresC6TefAuthorization = ({ config, paymentType, cardType = null, electronicAmount = 0 }) => {
    if (!isC6TefConfigured(config)) {
        return false;
    }

    return Boolean(resolvePaymentMethod(paymentType, cardType)) && Number(electronicAmount ?? 0) > 0;
};

export const authorizeC6TefPayment = async ({
    config,
    paymentType,
    cardType = null,
    electronicAmount,
    totalAmount,
    items = [],
    comanda = null,
    unit = null,
    cashier = null,
}) => {
    const paymentMethod = resolvePaymentMethod(paymentType, cardType);

    if (!paymentMethod) {
        return null;
    }

    const requestPayload = {
        provider: config?.provider ?? 'c6_paygo',
        order_reference: `pec-${Date.now()}`,
        amount: Number(electronicAmount ?? 0),
        total_amount: Number(totalAmount ?? electronicAmount ?? 0),
        currency: 'BRL',
        payment_method: paymentMethod,
        installments: 1,
        comanda,
        unit,
        cashier,
        items: items.map((item) => ({
            product_id: item.productId,
            name: item.name,
            quantity: Number(item.quantity ?? 0),
            unit_price: Number(item.price ?? 0),
        })),
    };

    const data = await postToAgent(config, config?.authorize_path ?? '/v1/payments/authorize', requestPayload);
    assertApprovedResponse(data);

    const tef = normalizeTefResponse(data);

    if (!tef.autorizacao || !tef.cnpj_credenciadora) {
        throw new Error('Retorno C6/PayGo incompleto: autorizacao e CNPJ da credenciadora sao obrigatorios.');
    }

    if (paymentMethod !== 'pix' && !tef.bandeira) {
        throw new Error('Retorno C6/PayGo incompleto: bandeira do cartao nao informada.');
    }

    return tef;
};

export const cancelC6TefPayment = async ({ config, tef, reason }) => {
    if (!isC6TefConfigured(config) || !tef?.payload) {
        return;
    }

    await postToAgent(config, config?.cancel_path ?? '/v1/payments/cancel', {
        reason,
        tef,
        transaction: tef.payload,
    });
};
