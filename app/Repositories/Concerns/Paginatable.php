<?php

namespace App\Repositories\Concerns;

use Illuminate\Contracts\Pagination\LengthAwarePaginator;

trait Paginatable
{
    /**
     * @inheritDoc
     */
    public function paginate(int $perPage = 15): LengthAwarePaginator
    {
        return $this->getResource()->paginate($perPage);
    }
}
