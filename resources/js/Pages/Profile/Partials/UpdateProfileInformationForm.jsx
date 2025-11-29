import InputError from '@/Components/InputError';
import InputLabel from '@/Components/InputLabel';
import PrimaryButton from '@/Components/Button/PrimaryButton';
import TextInput from '@/Components/TextInput';
import { Transition } from '@headlessui/react';
import { Link, useForm, usePage } from '@inertiajs/react';

export default function UpdateProfileInformation({
    mustVerifyEmail,
    status,
    className = '',
}) {
    const user = usePage().props.auth.user;

    const { data, setData, patch, errors, processing, recentlySuccessful } =
        useForm({
            name: user.name,
            email: user.email,
        });

    const submit = (e) => {
        e.preventDefault();

        patch(route('profile.update'));
    };

    return (
        <section className={`space-y-6 ${className}`}>
            <header className="border-b border-gray-800 pb-4">
                <h2 className="text-xl font-semibold text-white">
                    Profile Information
                </h2>
                <p className="mt-1 text-sm text-gray-400">
                    Update your account's profile information and email address.
                </p>
            </header>

            <form onSubmit={submit} className="mt-8 space-y-6">
                <div className="grid gap-6 sm:grid-cols-2">
                    <div>
                        <InputLabel
                            htmlFor="name"
                            value="Name"
                            className="text-gray-300"
                        />

                        <TextInput
                            id="name"
                            className="mt-2 block w-full rounded-lg border border-gray-800 bg-gray-950 text-gray-400 focus:border-blue-500 focus:ring-blue-500"
                            value={data.name}
                            readOnly
                            autoComplete="name"
                        />

                        <InputError className="mt-2" message={errors.name} />
                    </div>

                    <div>
                        <InputLabel
                            htmlFor="email"
                            value="Email"
                            className="text-gray-300"
                        />

                        <TextInput
                            id="email"
                            type="email"
                            className="mt-2 block w-full rounded-lg border border-gray-800 bg-gray-950 text-gray-100 placeholder-gray-500 focus:border-blue-500 focus:ring-blue-500"
                            value={data.email}
                            onChange={(e) => setData('email', e.target.value)}
                            required
                            autoComplete="username"
                        />

                        <InputError className="mt-2" message={errors.email} />
                    </div>
                </div>

                {mustVerifyEmail && user.email_verified_at === null && (
                    <div className="rounded-xl border border-amber-500/40 bg-amber-500/10 p-4 text-sm text-amber-100">
                        <p>
                            Your email address is unverified.
                            <Link
                                href={route('verification.send')}
                                method="post"
                                as="button"
                                className="ml-1 font-semibold underline"
                            >
                                Resend verification email
                            </Link>
                        </p>

                        {status === 'verification-link-sent' && (
                            <div className="mt-2 font-medium text-green-400">
                                A new verification link has been sent to your email
                                address.
                            </div>
                        )}
                    </div>
                )}

                <div className="flex items-center gap-4">
                    <PrimaryButton disabled={processing}>Save</PrimaryButton>

                    <Transition
                        show={recentlySuccessful}
                        enter="transition ease-in-out"
                        enterFrom="opacity-0"
                        leave="transition ease-in-out"
                        leaveTo="opacity-0"
                    >
                        <p className="text-sm text-gray-400">Saved.</p>
                    </Transition>
                </div>
            </form>
        </section>
    );
}
