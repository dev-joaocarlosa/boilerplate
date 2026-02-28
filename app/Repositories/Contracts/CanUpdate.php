<?php

namespace App\Repositories\Contracts;

interface CanUpdate
{
    /**
     * Atualiza um registro existente.
     *
     * @param int|string $id
     * @param array $data
     * @return bool
     */
    public function update(int|string $id, array $data): bool;
}
