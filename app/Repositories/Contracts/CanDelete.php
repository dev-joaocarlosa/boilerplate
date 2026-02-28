<?php

namespace App\Repositories\Contracts;

interface CanDelete
{
    /**
     * Remove um registro.
     *
     * @param int|string $id
     * @return bool
     */
    public function delete(int|string $id): bool;
}
