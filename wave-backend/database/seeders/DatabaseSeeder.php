<?php
 
namespace Database\Seeders;
 
use App\Models\User;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Seeder;
 
class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Créer un utilisateur test pour l'administration
        User::factory()->create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
        ]);
 
        // 1. Créer les Catégories par défaut
        $tacosCat = Category::create([
            'name' => 'Tacos',
            'icon' => 'assets/images/tacos.png',
            'color' => '#FFA500',
        ]);
 
        $burgerCat = Category::create([
            'name' => 'Burger',
            'icon' => 'assets/images/burger.png',
            'color' => '#FF4500',
        ]);
 
        $pizzaCat = Category::create([
            'name' => 'Pizza',
            'icon' => 'assets/images/pizza1.png',
            'color' => '#D32F2F',
        ]);
 
        // 2. Créer les Produits par défaut associés
        // Tacos
        Product::create([
            'name' => 'Tacos M',
            'description' => 'Tacos de taille moyenne',
            'price' => 2500,
            'image_url' => '/assets/images/img.png',
            'category_id' => $tacosCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Tacos L',
            'description' => 'Tacos de taille grande',
            'price' => 4000,
            'image_url' => '/assets/images/tacos.webp',
            'category_id' => $tacosCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Tacos XL',
            'description' => 'Tacos format familial',
            'price' => 5500,
            'image_url' => '/assets/images/img_1.png',
            'category_id' => $tacosCat->id,
            'is_available' => true,
        ]);
 
        // Burger
        Product::create([
            'name' => 'Burger Classic',
            'description' => 'Burger classique',
            'price' => 1000,
            'image_url' => '/assets/images/burger.png',
            'category_id' => $burgerCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Burger Deluxe',
            'description' => 'Burger de luxe',
            'price' => 1500,
            'image_url' => '/assets/images/burger.JPG',
            'category_id' => $burgerCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Burger Special',
            'description' => 'Burger spécial',
            'price' => 1200,
            'image_url' => '/assets/images/img12.webp',
            'category_id' => $burgerCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Burger Chicken',
            'description' => 'Burger au poulet croustillant',
            'price' => 1800,
            'image_url' => '/assets/images/img10.webp',
            'category_id' => $burgerCat->id,
            'is_available' => true,
        ]);
 
        // Pizza
        Product::create([
            'name' => 'Pizza Margherita',
            'description' => 'Pizza Margherita classique',
            'price' => 1000,
            'image_url' => '/assets/images/pizza1.png',
            'category_id' => $pizzaCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Pizza Pepperoni',
            'description' => 'Pizza au pepperoni',
            'price' => 1200,
            'image_url' => '/assets/images/pizza.png',
            'category_id' => $pizzaCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Pizza Végétarienne',
            'description' => 'Pizza aux légumes',
            'price' => 1100,
            'image_url' => '/assets/images/pizza1.png',
            'category_id' => $pizzaCat->id,
            'is_available' => true,
        ]);
 
        Product::create([
            'name' => 'Pizza Famille',
            'description' => 'Grande pizza à partager',
            'price' => 2200,
            'image_url' => '/assets/images/pizza.png',
            'category_id' => $pizzaCat->id,
            'is_available' => true,
        ]);
    }
}
