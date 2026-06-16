<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\WaveController;

Route::post('/api/create-wave-session', [WaveController::class, 'createWaveSession'])
    ->withoutMiddleware([\App\Http\Middleware\VerifyCsrfToken::class]);
