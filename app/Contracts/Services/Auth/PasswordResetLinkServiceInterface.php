<?php

namespace App\Contracts\Services\Auth;

interface PasswordResetLinkServiceInterface
{
    /**
     * Envia o link de recuperação de senha para o usuário informado.
     *
     * @param array $data
     * @return string
     * @throws \Illuminate\Validation\ValidationException
     */
    public function sendResetLink(array $data): string;
}
