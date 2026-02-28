<?php

namespace App\Repositories\Contracts;

interface CanFind
{
    /**
     * Encontra um registro pelo ID.
     *
     * @param int|string $id
     * @return object|null
     */
    public function find(int|string $id): ?object;

    /**
     * Encontra registros baseado em um campo específico.
     *
     * @param string $field
     * @param mixed $value
     * @return object|null
     */
    public function findByField(string $field, mixed $value): ?object;
}
