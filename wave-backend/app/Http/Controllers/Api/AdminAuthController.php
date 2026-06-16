<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;

class AdminAuthController extends Controller
{
    /**
     * Vérification du mot de passe admin via bcrypt côté serveur.
     * Le hash est stocké dans .env (jamais dans le code source).
     */
    public function login(Request $request)
    {
        $ip  = $request->ip();
        $key = 'admin-login:' . $ip;

        // Blocage si trop de tentatives (5 max par minute)
        if (RateLimiter::tooManyAttempts($key, 5)) {
            $seconds = RateLimiter::availableIn($key);
            return response()->json([
                'error' => "Trop de tentatives. Réessayez dans {$seconds}s."
            ], 429);
        }

        $password = $request->input('password');
        $hash     = env('ADMIN_PASSWORD_HASH');

        if (!$password || !$hash) {
            return response()->json(['error' => 'Configuration invalide'], 500);
        }

        if (!password_verify($password, $hash)) {
            RateLimiter::hit($key, 60); // Incrémenter le compteur
            return response()->json(['error' => 'Mot de passe incorrect'], 401);
        }

        // Succès — on reset le compteur et on retourne un token simple
        RateLimiter::clear($key);

        // Token signé valable 8h (stocké en session localStorage côté client)
        $token = base64_encode(json_encode([
            'ts'  => time(),
            'exp' => time() + (8 * 3600),
            'sig' => hash_hmac('sha256', 'admin', env('APP_KEY')),
        ]));

        return response()->json(['token' => $token]);
    }

    /**
     * Vérification de la validité du token admin.
     */
    public function verify(Request $request)
    {
        $token = $request->input('token');

        if (!$token) {
            return response()->json(['valid' => false], 401);
        }

        try {
            $data = json_decode(base64_decode($token), true);

            if (
                !$data ||
                $data['exp'] < time() ||
                $data['sig'] !== hash_hmac('sha256', 'admin', env('APP_KEY'))
            ) {
                return response()->json(['valid' => false], 401);
            }

            return response()->json(['valid' => true]);
        } catch (\Throwable $e) {
            return response()->json(['valid' => false], 401);
        }
    }
}
