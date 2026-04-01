import AlertMessage from '@/Components/Alert/AlertMessage';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { formatBrazilDateTime } from '@/Utils/date';
import { Head, useForm, usePage } from '@inertiajs/react';
import { useEffect, useMemo, useRef, useState } from 'react';

const formatFileSize = (value) => {
    const size = Number(value ?? 0);

    if (!Number.isFinite(size) || size <= 0) {
        return '0 B';
    }

    if (size < 1024) {
        return `${size} B`;
    }

    if (size < 1024 * 1024) {
        return `${(size / 1024).toFixed(1)} KB`;
    }

    return `${(size / (1024 * 1024)).toFixed(1)} MB`;
};

const preferredMimeTypes = [
    'video/webm;codecs=vp9,opus',
    'video/webm;codecs=vp8,opus',
    'video/webm',
    'video/mp4',
];

const resolveMimeType = () => {
    if (typeof MediaRecorder === 'undefined') {
        return '';
    }

    return (
        preferredMimeTypes.find((type) =>
            typeof MediaRecorder.isTypeSupported === 'function'
                ? MediaRecorder.isTypeSupported(type)
                : false,
        ) ?? ''
    );
};

const resolveExtension = (mimeType) => {
    if ((mimeType ?? '').includes('mp4')) {
        return 'mp4';
    }

    if ((mimeType ?? '').includes('quicktime')) {
        return 'mov';
    }

    if ((mimeType ?? '').includes('x-matroska')) {
        return 'mkv';
    }

    return 'webm';
};

export default function TicketIndex({ isMaster = false, tickets = [], activeUnit = null, maxUploadMb = 40 }) {
    const { flash } = usePage().props;
    const { data, setData, post, processing, errors, reset } = useForm({
        title: '',
        description: '',
        recording_file: null,
    });

    const [previewUrl, setPreviewUrl] = useState(null);
    const [recordingError, setRecordingError] = useState('');
    const [isRecording, setIsRecording] = useState(false);
    const [selectedTicketId, setSelectedTicketId] = useState(tickets[0]?.id ?? null);

    const recorderRef = useRef(null);
    const streamRef = useRef(null);
    const chunksRef = useRef([]);
    const previewUrlRef = useRef(null);

    const canRecord = useMemo(
        () =>
            typeof window !== 'undefined'
            && typeof MediaRecorder !== 'undefined'
            && !!navigator?.mediaDevices?.getDisplayMedia,
        [],
    );

    const selectedTicket = useMemo(
        () => tickets.find((ticket) => ticket.id === selectedTicketId) ?? tickets[0] ?? null,
        [selectedTicketId, tickets],
    );

    const stopTracks = () => {
        if (streamRef.current) {
            streamRef.current.getTracks().forEach((track) => track.stop());
            streamRef.current = null;
        }
    };

    const clearPreview = () => {
        setPreviewUrl((currentUrl) => {
            if (currentUrl) {
                URL.revokeObjectURL(currentUrl);
            }

            return null;
        });
    };

    useEffect(() => {
        if (tickets.length > 0 && !tickets.some((ticket) => ticket.id === selectedTicketId)) {
            setSelectedTicketId(tickets[0].id);
        }
    }, [selectedTicketId, tickets]);

    useEffect(() => {
        previewUrlRef.current = previewUrl;
    }, [previewUrl]);

    useEffect(() => () => {
        stopTracks();
        if (previewUrlRef.current) {
            URL.revokeObjectURL(previewUrlRef.current);
        }
    }, []);

    const finalizeRecording = () => {
        const blobType = recorderRef.current?.mimeType || chunksRef.current[0]?.type || 'video/webm';
        const blob = new Blob(chunksRef.current, { type: blobType });

        chunksRef.current = [];
        recorderRef.current = null;
        stopTracks();
        setIsRecording(false);

        if (blob.size <= 0) {
            setRecordingError('A gravacao foi encerrada sem gerar video valido.');
            setData('recording_file', null);
            clearPreview();
            return;
        }

        const extension = resolveExtension(blob.type);
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const file = new File([blob], `chamado-${timestamp}.${extension}`, {
            type: blob.type || 'video/webm',
        });

        clearPreview();
        setPreviewUrl(URL.createObjectURL(blob));
        setData('recording_file', file);
    };

    const handleStartRecording = async () => {
        setRecordingError('');

        if (!canRecord) {
            setRecordingError('Seu navegador nao suporta gravacao de tela por esta tela.');
            return;
        }

        try {
            clearPreview();
            setData('recording_file', null);
            chunksRef.current = [];

            const stream = await navigator.mediaDevices.getDisplayMedia({
                video: {
                    frameRate: 15,
                },
                audio: true,
            });

            streamRef.current = stream;

            const mimeType = resolveMimeType();
            const recorder = mimeType
                ? new MediaRecorder(stream, { mimeType })
                : new MediaRecorder(stream);

            recorderRef.current = recorder;
            recorder.ondataavailable = (event) => {
                if (event.data && event.data.size > 0) {
                    chunksRef.current.push(event.data);
                }
            };
            recorder.onstop = finalizeRecording;
            recorder.onerror = () => {
                setRecordingError('Nao foi possivel concluir a gravacao da tela.');
                setIsRecording(false);
                stopTracks();
            };

            stream.getVideoTracks().forEach((track) => {
                track.addEventListener('ended', () => {
                    if (recorder.state !== 'inactive') {
                        recorder.stop();
                    }
                });
            });

            recorder.start(1000);
            setIsRecording(true);
        } catch (error) {
            stopTracks();
            setIsRecording(false);
            setRecordingError('A gravacao de tela foi cancelada ou bloqueada pelo navegador.');
        }
    };

    const handleStopRecording = () => {
        if (recorderRef.current && recorderRef.current.state !== 'inactive') {
            recorderRef.current.stop();
        }
    };

    const handleDiscardRecording = () => {
        if (isRecording) {
            handleStopRecording();
        }

        setRecordingError('');
        setData('recording_file', null);
        clearPreview();
    };

    const handleSubmit = (event) => {
        event.preventDefault();

        post(route('support.tickets.store'), {
            preserveScroll: true,
            forceFormData: true,
            onSuccess: () => {
                reset('title', 'description', 'recording_file');
                setRecordingError('');
                clearPreview();
            },
        });
    };

    const header = (
        <div className="flex flex-col gap-1">
            <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                Chamados com gravacao
            </h2>
            <p className="text-sm text-gray-500 dark:text-gray-300">
                Grave a tela, finalize o video e envie o chamado. Somente perfis master podem visualizar as gravacoes enviadas.
            </p>
            <p className="text-sm text-gray-500 dark:text-gray-300">
                Unidade ativa: <span className="font-semibold text-gray-700 dark:text-gray-200">{activeUnit?.name ?? '--'}</span>
            </p>
        </div>
    );

    return (
        <AuthenticatedLayout header={header}>
            <Head title="Chamados" />

            <div className="py-8">
                <div className="mx-auto max-w-7xl space-y-6 px-4 sm:px-6 lg:px-8">
                    <AlertMessage message={flash} />

                    <div className="grid gap-6 xl:grid-cols-[minmax(0,1.2fr)_minmax(0,1fr)]">
                        <div className="space-y-6">
                            <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
                                <form onSubmit={handleSubmit} className="space-y-5">
                                    <div className="grid gap-4 md:grid-cols-2">
                                        <div>
                                            <label className="text-sm font-semibold text-gray-700 dark:text-gray-200">
                                                Titulo do chamado
                                            </label>
                                            <input
                                                type="text"
                                                value={data.title}
                                                onChange={(event) => setData('title', event.target.value)}
                                                className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                                placeholder="Ex.: erro ao fechar caixa"
                                            />
                                            {errors.title && (
                                                <p className="mt-1 text-sm text-red-600">{errors.title}</p>
                                            )}
                                        </div>
                                        <div className="rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
                                            <p className="font-semibold">Limite atual de envio</p>
                                            <p className="mt-1">
                                                Ate {maxUploadMb} MB por gravacao. Finalize assim que demonstrar o problema.
                                            </p>
                                        </div>
                                    </div>

                                    <div>
                                        <label className="text-sm font-semibold text-gray-700 dark:text-gray-200">
                                            Descricao
                                        </label>
                                        <textarea
                                            rows={4}
                                            value={data.description}
                                            onChange={(event) => setData('description', event.target.value)}
                                            className="mt-2 w-full rounded-xl border border-gray-300 px-3 py-2 text-sm text-gray-800 focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-400 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-100"
                                            placeholder="Explique rapidamente o que aconteceu antes ou depois da gravacao."
                                        />
                                        {errors.description && (
                                            <p className="mt-1 text-sm text-red-600">{errors.description}</p>
                                        )}
                                    </div>

                                    <div className="rounded-2xl border border-dashed border-gray-300 bg-gray-50 p-5 dark:border-gray-600 dark:bg-gray-900/40">
                                        <div className="flex flex-wrap items-center gap-3">
                                            <button
                                                type="button"
                                                onClick={handleStartRecording}
                                                disabled={isRecording}
                                                className="rounded-xl bg-red-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-red-700 disabled:opacity-50"
                                            >
                                                Iniciar gravacao
                                            </button>
                                            <button
                                                type="button"
                                                onClick={handleStopRecording}
                                                disabled={!isRecording}
                                                className="rounded-xl bg-slate-800 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-slate-900 disabled:opacity-50 dark:bg-slate-600 dark:hover:bg-slate-500"
                                            >
                                                Finalizar gravacao
                                            </button>
                                            <button
                                                type="button"
                                                onClick={handleDiscardRecording}
                                                disabled={isRecording && !data.recording_file}
                                                className="rounded-xl border border-gray-300 px-4 py-2 text-sm font-semibold text-gray-700 hover:border-gray-400 hover:bg-gray-100 disabled:opacity-50 dark:border-gray-600 dark:text-gray-200 dark:hover:bg-gray-700"
                                            >
                                                Limpar
                                            </button>
                                        </div>

                                        <div className="mt-4 space-y-2 text-sm text-gray-600 dark:text-gray-300">
                                            <p>1. Clique em <span className="font-semibold">Iniciar gravacao</span>.</p>
                                            <p>2. Escolha a tela ou janela que demonstra o problema.</p>
                                            <p>3. Quando terminar, clique em <span className="font-semibold">Finalizar gravacao</span> e envie o chamado.</p>
                                        </div>

                                        {!canRecord && (
                                            <p className="mt-4 text-sm font-semibold text-red-600">
                                                Seu navegador atual nao oferece suporte a esta captura de tela.
                                            </p>
                                        )}
                                        {recordingError && (
                                            <p className="mt-4 text-sm font-semibold text-red-600">{recordingError}</p>
                                        )}
                                        {errors.recording_file && (
                                            <p className="mt-4 text-sm font-semibold text-red-600">{errors.recording_file}</p>
                                        )}
                                        {isRecording && (
                                            <p className="mt-4 text-sm font-semibold text-emerald-600">
                                                Gravacao em andamento. Execute o fluxo e finalize quando terminar.
                                            </p>
                                        )}
                                        {data.recording_file && (
                                            <p className="mt-4 text-sm font-semibold text-gray-700 dark:text-gray-200">
                                                Arquivo pronto: {data.recording_file.name} ({formatFileSize(data.recording_file.size)})
                                            </p>
                                        )}
                                    </div>

                                    {previewUrl && (
                                        <div className="space-y-2">
                                            <p className="text-sm font-semibold text-gray-700 dark:text-gray-200">
                                                Pre-visualizacao da gravacao
                                            </p>
                                            <video
                                                src={previewUrl}
                                                controls
                                                className="w-full rounded-2xl border border-gray-200 bg-black shadow dark:border-gray-700"
                                            />
                                        </div>
                                    )}

                                    <div className="flex justify-end">
                                        <button
                                            type="submit"
                                            disabled={processing || isRecording || !data.recording_file}
                                            className="rounded-xl bg-indigo-600 px-5 py-2 text-sm font-semibold text-white shadow hover:bg-indigo-700 disabled:opacity-50"
                                        >
                                            {processing ? 'Enviando...' : 'Enviar chamado'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        {isMaster && (
                            <div className="space-y-6">
                                <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
                                    <div className="flex items-center justify-between gap-3">
                                        <div>
                                            <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">
                                                Chamados recebidos
                                            </h3>
                                            <p className="text-sm text-gray-500 dark:text-gray-300">
                                                Visualizacao exclusiva para master.
                                            </p>
                                        </div>
                                        <span className="rounded-full bg-indigo-50 px-3 py-1 text-xs font-semibold text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-100">
                                            {tickets.length} chamado(s)
                                        </span>
                                    </div>

                                    {selectedTicket ? (
                                        <div className="mt-5 space-y-3">
                                            <div className="rounded-2xl border border-gray-200 bg-gray-50 p-4 dark:border-gray-700 dark:bg-gray-900/40">
                                                <div className="flex flex-wrap items-start justify-between gap-3">
                                                    <div>
                                                        <h4 className="text-base font-semibold text-gray-800 dark:text-gray-100">
                                                            {selectedTicket.title}
                                                        </h4>
                                                        <p className="mt-1 text-sm text-gray-500 dark:text-gray-300">
                                                            Enviado por {selectedTicket.user?.name ?? '--'} | Unidade {selectedTicket.unit?.name ?? '--'}
                                                        </p>
                                                        <p className="mt-1 text-sm text-gray-500 dark:text-gray-300">
                                                            {formatBrazilDateTime(selectedTicket.created_at)} | {formatFileSize(selectedTicket.video_size)}
                                                        </p>
                                                    </div>
                                                    <span className="rounded-full bg-emerald-50 px-3 py-1 text-xs font-semibold uppercase text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-100">
                                                        {selectedTicket.status}
                                                    </span>
                                                </div>
                                                {selectedTicket.description && (
                                                    <p className="mt-3 text-sm text-gray-700 dark:text-gray-200">
                                                        {selectedTicket.description}
                                                    </p>
                                                )}
                                            </div>

                                            <video
                                                key={selectedTicket.id}
                                                src={selectedTicket.video_url}
                                                controls
                                                className="w-full rounded-2xl border border-gray-200 bg-black shadow dark:border-gray-700"
                                            />
                                        </div>
                                    ) : (
                                        <p className="mt-5 text-sm text-gray-500 dark:text-gray-300">
                                            Nenhum chamado foi enviado ainda.
                                        </p>
                                    )}
                                </div>

                                {tickets.length > 0 && (
                                    <div className="rounded-2xl bg-white p-6 shadow dark:bg-gray-800">
                                        <h3 className="text-sm font-semibold uppercase tracking-wide text-gray-600 dark:text-gray-300">
                                            Lista rapida
                                        </h3>
                                        <div className="mt-4 space-y-3">
                                            {tickets.map((ticket) => {
                                                const isActive = selectedTicket?.id === ticket.id;

                                                return (
                                                    <button
                                                        key={ticket.id}
                                                        type="button"
                                                        onClick={() => setSelectedTicketId(ticket.id)}
                                                        className={`w-full rounded-2xl border px-4 py-3 text-left transition ${
                                                            isActive
                                                                ? 'border-indigo-500 bg-indigo-50 shadow-sm dark:border-indigo-400 dark:bg-indigo-900/30'
                                                                : 'border-gray-200 bg-white hover:border-indigo-300 dark:border-gray-700 dark:bg-gray-900'
                                                        }`}
                                                    >
                                                        <div className="flex items-start justify-between gap-3">
                                                            <div>
                                                                <p className="text-sm font-semibold text-gray-800 dark:text-gray-100">
                                                                    {ticket.title}
                                                                </p>
                                                                <p className="mt-1 text-xs text-gray-500 dark:text-gray-300">
                                                                    {ticket.user?.name ?? '--'} | {ticket.unit?.name ?? '--'}
                                                                </p>
                                                            </div>
                                                            <span className="text-xs font-semibold text-gray-500 dark:text-gray-300">
                                                                #{ticket.id}
                                                            </span>
                                                        </div>
                                                    </button>
                                                );
                                            })}
                                        </div>
                                    </div>
                                )}
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
