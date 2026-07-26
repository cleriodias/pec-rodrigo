import InfoButton from "@/Components/Button/InfoButton";
import WarningButton from "@/Components/Button/WarningButton";
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout";
import { Head, Link, useForm } from "@inertiajs/react";

const empty = (unitId = "") => ({
    tb2_id: unitId,
    tb28_csosn: "",
    tb28_cst_icms: "00",
    tb28_aliquota_icms: "0",
    tb28_cst_pis: "01",
    tb28_aliquota_pis: "0",
    tb28_cst_cofins: "01",
    tb28_aliquota_cofins: "0",
    tb28_cst_ibs_cbs: "000",
    tb28_cclass_trib: "200003",
    tb28_aliquota_ibs_uf: "0.1",
    tb28_aliquota_ibs_mun: "0",
    tb28_aliquota_cbs: "0.9",
    tb28_reducao_ibs_uf: "0",
    tb28_reducao_ibs_mun: "0",
    tb28_reducao_cbs: "0",
    tb28_ativo: true,
    tb28_rtc_manual: false,
    copy_to_unit_ids: [],
});

export default function ProductFiscalRules({ auth, product, units = [], rules = {} }) {
    const firstUnitId = units[0]?.tb2_id ?? "";
    const form = useForm({
        ...empty(firstUnitId),
        ...(rules[firstUnitId] ?? {}),
        tb2_id: firstUnitId,
        copy_to_unit_ids: [],
    });

    const loadUnit = (unitId) => form.setData({
        ...empty(unitId),
        ...(rules[unitId] ?? {}),
        tb2_id: unitId,
        copy_to_unit_ids: [],
    });

    const submit = (event) => {
        event.preventDefault();
        form.post(route("products.fiscal-rule.store", { product: product.tb1_id }));
    };

    const field = (name, label, props = {}) => (
        <div className="min-w-0">
            <label className="block truncate text-[11px] font-semibold leading-4 text-gray-700">{label}</label>
            <input
                {...props}
                value={form.data[name] ?? ""}
                onChange={(event) => form.setData(name, event.target.value)}
                className="mt-0.5 block h-9 w-full rounded-md border-gray-300 px-2 text-sm shadow-sm"
            />
            {form.errors[name] && <p className="text-xs text-red-600">{form.errors[name]}</p>}
        </div>
    );

    return (
        <AuthenticatedLayout user={auth.user} header={<h2 className="text-xl font-semibold text-gray-800">Tributacao fiscal por loja</h2>}>
            <Head title="Tributacao fiscal por loja" />

            <div className="mx-auto max-w-7xl px-4 py-3">
                <div className="mb-3 flex items-center justify-between gap-3">
                    <p className="text-sm text-gray-600">Produto #{product.tb1_id} - {product.tb1_nome}</p>
                    <Link href={route("products.edit", { product: product.tb1_id })}>
                        <InfoButton title="Voltar"><i className="bi bi-arrow-left" /></InfoButton>
                    </Link>
                </div>

                <form onSubmit={submit} className="space-y-4 rounded-lg bg-white p-4 shadow">
                    <section>
                        <p className="mb-1.5 text-sm font-semibold text-gray-800">Loja</p>
                        <div className="flex gap-2 overflow-x-auto pb-1">
                            {units.map((unit) => {
                                const selected = String(unit.tb2_id) === String(form.data.tb2_id);

                                return (
                                    <button
                                        key={unit.tb2_id}
                                        type="button"
                                        onClick={() => {
                                            if (!selected) {
                                                loadUnit(unit.tb2_id);
                                            }
                                        }}
                                        className={[
                                            "h-9 shrink-0 rounded-md border px-3 text-sm font-semibold transition",
                                            selected
                                                ? "border-sky-600 bg-sky-600 text-white shadow-sm"
                                                : "border-gray-300 bg-white text-gray-700 hover:border-sky-400 hover:text-sky-700",
                                        ].join(" ")}
                                    >
                                        {unit.tb2_nome}
                                    </button>
                                );
                            })}
                        </div>
                    </section>

                    <section>
                        <h3 className="mb-1.5 text-sm font-semibold text-gray-900">Tributacao atual</h3>
                        <div className="grid grid-cols-2 gap-2 md:grid-cols-7">
                            {field("tb28_csosn", "CSOSN", { maxLength: 3 })}
                            {field("tb28_cst_icms", "CST ICMS", { maxLength: 2 })}
                            {field("tb28_aliquota_icms", "ICMS %", { type: "number", step: "0.0001" })}
                            {field("tb28_cst_pis", "CST PIS", { maxLength: 2 })}
                            {field("tb28_aliquota_pis", "PIS %", { type: "number", step: "0.0001" })}
                            {field("tb28_cst_cofins", "CST COFINS", { maxLength: 2 })}
                            {field("tb28_aliquota_cofins", "COFINS %", { type: "number", step: "0.0001" })}
                        </div>
                    </section>

                    <section>
                        <h3 className="mb-1.5 text-sm font-semibold text-gray-900">RTC 2026 - IBS/CBS</h3>
                        <div className="grid grid-cols-2 gap-2 md:grid-cols-8">
                            {field("tb28_cst_ibs_cbs", "CST *", { required: true, maxLength: 3 })}
                            {field("tb28_cclass_trib", "cClass *", { required: true, maxLength: 6 })}
                            {field("tb28_aliquota_ibs_uf", "IBS UF *", { required: true, type: "number", step: "0.0001" })}
                            {field("tb28_aliquota_ibs_mun", "IBS Mun *", { required: true, type: "number", step: "0.0001" })}
                            {field("tb28_aliquota_cbs", "CBS *", { required: true, type: "number", step: "0.0001" })}
                            {field("tb28_reducao_ibs_uf", "Red. UF", { type: "number", step: "0.0001" })}
                            {field("tb28_reducao_ibs_mun", "Red. Mun", { type: "number", step: "0.0001" })}
                            {field("tb28_reducao_cbs", "Red. CBS", { type: "number", step: "0.0001" })}
                        </div>
                    </section>

                    <section className="flex flex-wrap items-center gap-x-6 gap-y-2">
                        <label className="flex items-center gap-2 text-sm font-medium">
                            <input
                                type="checkbox"
                                checked={Boolean(form.data.tb28_ativo)}
                                onChange={(event) => form.setData("tb28_ativo", event.target.checked)}
                                className="h-4 w-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                            />
                            RTC ativa nesta loja
                        </label>
                        <label className="flex items-center gap-2 text-sm font-medium">
                            <input
                                type="checkbox"
                                checked={Boolean(form.data.tb28_rtc_manual)}
                                onChange={(event) => form.setData("tb28_rtc_manual", event.target.checked)}
                                className="h-4 w-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                            />
                            RTC manual <span className="text-xs font-normal text-slate-500">(SETOR-9: protege contra recalculo por NCM)</span>
                        </label>
                    </section>

                    <section>
                        <p className="text-sm font-semibold text-gray-800">Copiar para outras lojas</p>
                        <select
                            multiple
                            value={form.data.copy_to_unit_ids}
                            onChange={(event) => form.setData("copy_to_unit_ids", Array.from(event.target.selectedOptions, (option) => option.value))}
                            className="mt-1 h-20 w-full rounded-md border-gray-300 text-sm"
                        >
                            {units
                                .filter((unit) => String(unit.tb2_id) !== String(form.data.tb2_id))
                                .map((unit) => <option key={unit.tb2_id} value={unit.tb2_id}>{unit.tb2_nome}</option>)}
                        </select>
                    </section>

                    <div className="flex justify-end">
                        <WarningButton type="submit" disabled={form.processing}>Salvar tributacao</WarningButton>
                    </div>
                </form>
            </div>
        </AuthenticatedLayout>
    );
}
