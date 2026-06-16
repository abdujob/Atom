<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $fillable = [
        'order_number',
        'items',
        'total',
        'payment_method',
        'status',
        'wave_session_id',
    ];

    protected $casts = [
        'items' => 'array',
        'total' => 'decimal:2',
    ];

    /**
     * Génère le prochain numéro de commande séquentiel.
     * Ex: #0001, #0042, #1234
     */
    public static function generateOrderNumber(): string
    {
        $last = self::latest('id')->first();
        $next = $last ? (intval(ltrim($last->order_number, '#')) + 1) : 1;
        return '#' . str_pad($next, 4, '0', STR_PAD_LEFT);
    }
}
