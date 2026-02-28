<?php

namespace App\Repositories\Contracts;

interface CanStore
{
    /**
     * Cria um novo registro com base no array fornecido.
     *
     * @param array $data
     * @return object
     */
    public function create(array $data): object;
}
