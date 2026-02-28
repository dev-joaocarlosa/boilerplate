<?php

namespace App\Repositories\Concerns;

trait Findable
{
    /**
     * @inheritDoc
     */
    public function find(int|string $id): ?object
    {
        return $this->getResource()->find($id);
    }

    /**
     * @inheritDoc
     */
    public function findByField(string $field, mixed $value): ?object
    {
        return $this->getResource()->where($field, $value)->first();
    }
}
