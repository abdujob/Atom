<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_number')->unique(); // Ex: #0042
            $table->json('items');                    // Liste des articles
            $table->decimal('total', 10, 2);
            $table->string('payment_method');         // 'cash' ou 'wave'
            $table->string('status')->default('completed'); // completed, pending, cancelled
            $table->string('wave_session_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
