<?php

namespace App\Http\Controllers\Api\V1;

use App\Facades\Api\{StatusService};
use App\Http\Controllers\Controller;
use Illuminate\Http\{JsonResponse};

class StatusController extends Controller
{
    /**
     * Obtém o status operacional do sistema
     *
     * @return JsonResponse
     */
    public function getSystemStatus(): JsonResponse
    {
        return $this->getResponse()->dispatch(function () {
            return [
                'data' => StatusService::getSystemStatus()
            ];
        });
    }
}
