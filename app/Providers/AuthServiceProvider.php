<?php

namespace App\Providers;

use App\Contracts\Services\Auth\PasswordResetLinkServiceInterface;
use App\Services\Auth\PasswordResetLinkService;
use Illuminate\Contracts\Support\DeferrableProvider;
use Illuminate\Support\ServiceProvider;

class AuthServiceProvider extends ServiceProvider implements DeferrableProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->bind(
            PasswordResetLinkServiceInterface::class,
            PasswordResetLinkService::class
        );
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }

    /**
     * Get the services provided by the provider.
     *
     * @return array<int, string>
     */
    public function provides(): array
    {
        return [
            PasswordResetLinkServiceInterface::class,
        ];
    }
}
