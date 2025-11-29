import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import DeleteUserForm from './Partials/DeleteUserForm';
import UpdatePasswordForm from './Partials/UpdatePasswordForm';
import UpdateProfileInformationForm from './Partials/UpdateProfileInformationForm';

export default function Edit({ mustVerifyEmail, status }) {
    return (
        <AuthenticatedLayout
            header={
                <h2 className="text-xl font-semibold leading-tight text-gray-800 dark:text-gray-200">
                    Profile
                </h2>
            }
        >
            <Head title="Profile" />

            <div className="min-h-screen bg-gray-950 py-12 text-gray-100">
                <div className="mx-auto w-full max-w-4xl space-y-8 px-4 sm:px-0">
                    <div className="rounded-2xl border border-gray-800 bg-gray-900 p-8 shadow-lg">
                        <UpdateProfileInformationForm
                            mustVerifyEmail={mustVerifyEmail}
                            status={status}
                            className="w-full"
                        />
                    </div>

                    <div className="rounded-2xl border border-gray-800 bg-gray-900 p-8 shadow-lg">
                        <UpdatePasswordForm className="w-full" />
                    </div>

                    <div className="rounded-2xl border border-gray-800 bg-gray-900 p-8 shadow-lg">
                        <DeleteUserForm className="w-full" />
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    );
}
