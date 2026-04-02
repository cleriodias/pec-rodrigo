const BADGE_BASE_CLASSNAME =
    'rounded-full border px-3 py-1 text-xs font-semibold transition dark:border-gray-600';

const UNIT_STYLE_MAP = {
    'SETOR 10': {
        className:
            `${BADGE_BASE_CLASSNAME} border-violet-800 bg-violet-700 text-white hover:border-violet-900 hover:text-white`,
    },
    'SETOR 1': {
        className:
            `${BADGE_BASE_CLASSNAME} border-sky-800 bg-sky-700 text-white hover:border-sky-900 hover:text-white`,
    },
    'BARRAGEM 1': {
        className:
            `${BADGE_BASE_CLASSNAME} border-emerald-800 bg-emerald-700 text-white hover:border-emerald-900 hover:text-white`,
    },
    default: {
        className:
            `${BADGE_BASE_CLASSNAME} border-slate-800 bg-slate-700 text-white hover:border-slate-900 hover:text-white`,
    },
};

const ROLE_STYLE_MAP = {
    MASTER: {
        className:
            `${BADGE_BASE_CLASSNAME} border-amber-400 bg-amber-50 text-amber-800 hover:border-amber-500 hover:text-amber-900`,
    },
    GERENTE: {
        className:
            `${BADGE_BASE_CLASSNAME} border-blue-400 bg-blue-50 text-blue-800 hover:border-blue-500 hover:text-blue-900`,
    },
    'SUB-GERENTE': {
        className:
            `${BADGE_BASE_CLASSNAME} border-cyan-400 bg-cyan-50 text-cyan-800 hover:border-cyan-500 hover:text-cyan-900`,
    },
    CAIXA: {
        className:
            `${BADGE_BASE_CLASSNAME} border-indigo-400 bg-indigo-50 text-indigo-800 hover:border-indigo-500 hover:text-indigo-900`,
    },
    LANCHONETE: {
        className:
            `${BADGE_BASE_CLASSNAME} border-rose-400 bg-rose-50 text-rose-800 hover:border-rose-500 hover:text-rose-900`,
    },
    FUNCIONARIO: {
        className:
            `${BADGE_BASE_CLASSNAME} border-slate-400 bg-slate-50 text-slate-700 hover:border-slate-500 hover:text-slate-800`,
    },
    CLIENTE: {
        className:
            `${BADGE_BASE_CLASSNAME} border-lime-400 bg-lime-50 text-lime-800 hover:border-lime-500 hover:text-lime-900`,
    },
    default: {
        className:
            `${BADGE_BASE_CLASSNAME} border-slate-400 bg-slate-50 text-slate-700 hover:border-slate-500 hover:text-slate-800`,
    },
};

const normalizeKey = (value) =>
    String(value ?? '')
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/[-_/]+/g, ' ')
        .trim()
        .replace(/\s+/g, ' ')
        .toUpperCase();

export const getUserNameBadgeClassName = () =>
    `${BADGE_BASE_CLASSNAME} border-gray-300 bg-white text-black hover:border-indigo-400 hover:text-black`;

export const formatUnitBadgeLabel = (value) =>
    normalizeKey(value).replace(/\s+/g, '-') || 'SEM-LOJA';

export const formatRoleBadgeLabel = (value) => {
    const normalized = normalizeKey(value);

    if (normalized === 'LANCHONETE') {
        return 'LANCH';
    }

    if (normalized === 'SUB GERENTE') {
        return 'SUB-G';
    }

    return normalized || '---';
};

export const getUnitBadgeClassName = (value) =>
    (UNIT_STYLE_MAP[normalizeKey(value)] ?? UNIT_STYLE_MAP.default).className;

export const getRoleBadgeClassName = (value) =>
    (ROLE_STYLE_MAP[normalizeKey(value)] ?? ROLE_STYLE_MAP.default).className;
