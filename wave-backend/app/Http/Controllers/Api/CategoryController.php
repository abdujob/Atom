<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;

class CategoryController extends Controller
{
    public function index()
    {
        return response()->json(Category::with('products')->get());
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'color' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($request->hasFile('image')) {
            $uploadedFile = Cloudinary::uploadApi()->upload($request->file('image')->getRealPath(), [
                'folder' => 'categories'
            ]);
            $validated['icon'] = $uploadedFile['secure_url'];
        }

        $category = Category::create($validated);
        return response()->json($category, 201);
    }

    public function show(Category $category)
    {
        return response()->json($category->load('products'));
    }

    public function update(Request $request, Category $category)
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'color' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($request->hasFile('image')) {
            if ($category->icon && str_starts_with($category->icon, '/storage/')) {
                $oldPath = str_replace('/storage/', '', $category->icon);
                Storage::disk('public')->delete($oldPath);
            }
            $uploadedFile = Cloudinary::uploadApi()->upload($request->file('image')->getRealPath(), [
                'folder' => 'categories'
            ]);
            $validated['icon'] = $uploadedFile['secure_url'];
        }

        $category->update($validated);
        return response()->json($category);
    }

    public function destroy(Category $category)
    {
        if ($category->icon && str_starts_with($category->icon, '/storage/')) {
            $oldPath = str_replace('/storage/', '', $category->icon);
            Storage::disk('public')->delete($oldPath);
        }
        $category->delete();
        return response()->json(null, 204);
    }
}
