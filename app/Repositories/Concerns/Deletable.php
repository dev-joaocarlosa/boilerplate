<?php

namespace App\Repositories\Concerns;

trait Deletable
{
    /**
     * @inheritDoc
     */
    public function delete(int|string $id): bool
    {
        $resource = $this->getResource()->find($id);

        if (!$resource) {
            return false;
        }

        return $resource->delete();
    }
}
