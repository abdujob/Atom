<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('products', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('name');
            $blueprint->text('description')->nullable();
            $blueprint->decimal('price', 10, 2);
            $blueprint->string('image_url')->nullable();
            $blueprint->foreignId('category_id')->constrained()->onDelete('cascade');
            $blueprint->boolean('is_available')->default(true);
            $blueprint->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
