<?php

namespace App\Facades\Api;

use App\Contracts\Services\Api\StatusServiceInterface;
use Illuminate\Support\Facades\Facade;

/**
 * Facade para StatusService.
 *
 * @method static array getSystemStatus()
 *
 * @see StatusServiceInterface
 */
class StatusService extends Facade
{
    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return StatusServiceInterface::class;
    }
}
