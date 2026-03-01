<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/v1/status', function () {
    return response()->json([
        'status' => 'online',
        'project' => config('app.name'),
        'environment' => config('app.env'),
        'timestamp' => now()->toISOString(),
    ]);
});

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
