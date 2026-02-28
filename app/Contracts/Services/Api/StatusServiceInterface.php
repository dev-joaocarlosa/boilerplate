<?php

namespace App\Contracts\Services\Api;

interface StatusServiceInterface
{
    /**
     * Obtém o status do sistema em tempo real
     *
     * @return array
     */
    public function getSystemStatus(): array;
}
