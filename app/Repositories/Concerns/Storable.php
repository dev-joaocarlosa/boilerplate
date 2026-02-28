<?php

namespace App\Repositories\Concerns;

trait Storable
{
    /**
     * @inheritDoc
     */
    public function create(array $data): object
    {
        return $this->getResource()->create($data);
    }
}
