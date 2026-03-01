<?php

namespace App\Facades\Auth;

use App\Contracts\Services\Auth\PasswordResetLinkServiceInterface;
use Illuminate\Support\Facades\Facade;

/**
 * Facade para PasswordResetLinkService.
 *
 * @method static string sendResetLink(array $data)
 *
 * @see PasswordResetLinkServiceInterface
 */
class PasswordResetLinkService extends Facade
{
    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return PasswordResetLinkServiceInterface::class;
    }
}
