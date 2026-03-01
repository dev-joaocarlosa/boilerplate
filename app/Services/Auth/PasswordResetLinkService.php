<?php

namespace App\Services\Auth;

use App\Contracts\Services\Auth\PasswordResetLinkServiceInterface;
use Illuminate\Support\Facades\Password;
use Illuminate\Validation\ValidationException;

class PasswordResetLinkService implements PasswordResetLinkServiceInterface
{
    /**
     * {@inheritDoc}
     */
    public function sendResetLink(array $data): string
    {
        $status = Password::sendResetLink($data);

        if ($status === Password::RESET_LINK_SENT) {
            return $status;
        }

        throw ValidationException::withMessages([
            'email' => [trans($status)],
        ]);
    }
}
