<?php

namespace App\Services\Api;

use App\Contracts\Services\Api\StatusServiceInterface;

class StatusService implements StatusServiceInterface
{
    /**
     * {@inheritDoc}
     */
    public function getSystemStatus(): array
    {
        return [
            'status'      => 'online',
            'project'     => config('app.name'),
            'environment' => config('app.env'),
            'timestamp'   => now()->toISOString(),
        ];
    }
}
