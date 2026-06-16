<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Enregistrer une nouvelle commande depuis la borne
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'items'           => 'required|array',
            'total'           => 'required|numeric|min:0',
            'payment_method'  => 'required|string|in:cash,wave',
            'wave_session_id' => 'nullable|string',
        ]);

        $order = Order::create([
            'order_number'    => Order::generateOrderNumber(),
            'items'           => $validated['items'],
            'total'           => $validated['total'],
            'payment_method'  => $validated['payment_method'],
            'status'          => 'completed',
            'wave_session_id' => $validated['wave_session_id'] ?? null,
        ]);

        return response()->json([
            'success'      => true,
            'order_number' => $order->order_number,
            'id'           => $order->id,
        ], 201);
    }

    /**
     * Lister toutes les commandes (pour l'admin web)
     */
    public function index(Request $request)
    {
        $date = $request->query('date'); // Ex: 2026-06-15

        $query = Order::orderByDesc('created_at');

        if ($date) {
            $query->whereDate('created_at', $date);
        }

        $orders = $query->get();

        return response()->json($orders);
    }

    /**
     * Stats du jour pour le dashboard admin
     */
    public function stats()
    {
        $today = now()->toDateString();

        $todayOrders = Order::whereDate('created_at', $today)->get();

        $totalRevenue = $todayOrders->sum('total');
        $orderCount   = $todayOrders->count();

        // Commandes des 7 derniers jours
        $weekly = [];
        for ($i = 6; $i >= 0; $i--) {
            $day = now()->subDays($i)->toDateString();
            $dayOrders = Order::whereDate('created_at', $day)->get();
            $weekly[] = [
                'date'    => $day,
                'count'   => $dayOrders->count(),
                'revenue' => $dayOrders->sum('total'),
            ];
        }

        return response()->json([
            'today' => [
                'orders'  => $orderCount,
                'revenue' => $totalRevenue,
            ],
            'weekly' => $weekly,
        ]);
    }
}
