<?php

namespace App\Repositories\Concerns;

trait Updatable
{
    /**
     * @inheritDoc
     */
    public function update(int|string $id, array $data): bool
    {
        $resource = $this->getResource()->find($id);

        if (!$resource) {
            return false;
        }

        return $resource->update($data);
    }
}
