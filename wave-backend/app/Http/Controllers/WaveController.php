<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class WaveController extends Controller
{
    public function createWaveSession(Request $request)
    {
        $amount = $request->input('amount');

        if (!$amount) {
            return response()->json(['error' => 'Amount is required'], 400);
        }

        $response = Http::withToken(env('WAVE_API_KEY'))
            ->post('https://api.wave.com/v1/checkout/sessions', [
                'amount'      => intval($amount),
                'currency'    => 'XOF',
                'success_url' => env('WAVE_SUCCESS_URL', 'http://127.0.0.1:8000/payment/success'),
                'error_url'   => env('WAVE_ERROR_URL',   'http://127.0.0.1:8000/payment/error'),
            ]);

        if (!$response->ok()) {
            return response()->json([
                'error' => 'Erreur avec Wave',
                'wave_status' => $response->status(),
                'wave_response' => $response->json() ?? $response->body()
            ], 500);
        }

        $checkoutUrl = $response->json()['wave_launch_url'] ?? null;

        if (!$checkoutUrl) {
            return response()->json(['error' => 'No URL received'], 500);
        }

        // Si le client demande du JSON, on renvoie l'URL de paiement Wave
        if ($request->wantsJson() || $request->input('format') === 'json') {
            return response()->json(['checkout_url' => $checkoutUrl]);
        }

        $qrCode = \QrCode::format('png')
            ->size(300)
            ->generate($checkoutUrl);

        return response($qrCode, 200)
            ->header('Content-Type', 'image/png');
    }

    /**
     * Vérifie le statut d'une session de paiement Wave
     */
    public function checkStatus($sessionId)
    {
        $response = Http::withToken(env('WAVE_API_KEY'))
            ->get("https://api.wave.com/v1/checkout/sessions/{$sessionId}");

        if (!$response->ok()) {
            return response()->json(['status' => 'unknown'], 200);
        }

        $data = $response->json();
        return response()->json([
            'status'      => $data['payment_status'] ?? 'pending',
            'amount'      => $data['amount'] ?? null,
            'checkout_id' => $sessionId,
        ]);
    }
}
