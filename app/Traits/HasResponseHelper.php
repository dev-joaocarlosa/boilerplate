<?php

namespace App\Traits;

use App\Helpers\ResponseHelper;

trait HasResponseHelper
{
    /**
     * Get response helper instance
     *
     * @return ResponseHelper
     */
    protected function getResponse()
    {
        return app(ResponseHelper::class);
    }

    /**
     * Get POST attributes from request
     *
     * @return array
     */
    protected function getPostAttributes()
    {
        return request()->all();
    }
}
