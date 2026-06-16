<?php

use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\AdminAuthController;
use App\Http\Controllers\WaveController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/create-wave-session', [WaveController::class, 'createWaveSession']);
Route::get('/wave/status/{sessionId}', [WaveController::class, 'checkStatus']);

// Admin Auth Routes
Route::post('/admin/login', [AdminAuthController::class, 'login']);
Route::post('/admin/verify', [AdminAuthController::class, 'verify']);

// Menu Management Routes
Route::apiResource('categories', CategoryController::class);
Route::apiResource('products', ProductController::class);

// Orders Routes
Route::post('/orders', [OrderController::class, 'store']);
Route::get('/orders', [OrderController::class, 'index']);
Route::get('/orders/stats', [OrderController::class, 'stats']);


