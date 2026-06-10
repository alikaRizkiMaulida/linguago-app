<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        return response()->json([
            'user' => $request->user(),
        ], 200);
    }

    public function update(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'name'       => 'sometimes|string|max:255',
            'username'   => 'sometimes|string|max:255|unique:users,username,' . $user->id,
            'email'      => 'sometimes|email|max:255|unique:users,email,' . $user->id,
            'avatar_url' => 'sometimes|nullable|string|max:255',
            'bio'        => 'sometimes|nullable|string|max:500',
            'birthday'   => 'sometimes|nullable|date',
        ]);

        $user->fill($data)->save();

        return response()->json([
            'message' => 'Profile updated successfully',
            'user'    => $user->fresh(),
        ], 200);
    }

    public function uploadAvatar(Request $request)
    {
        $request->validate([
            'avatar' => 'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        $user = $request->user();

        if ($user->avatar_url) {
            $oldPath = str_replace(url('/storage') . '/', '', $user->avatar_url);
            if (Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->delete($oldPath);
            }
        }

        $path = $request->file('avatar')->store('avatars', 'public');

        $url = url('/storage/' . $path);

        $user->avatar_url = $url;
        $user->save();

        return response()->json([
            'message' => 'Avatar updated successfully',
            'user'    => $user->fresh(),
        ], 200);
    }

    public function deleteAvatar(Request $request)
    {
        $user = $request->user();

        if ($user->avatar_url) {
            $oldPath = str_replace(url('/storage') . '/', '', $user->avatar_url);
            if (Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->delete($oldPath);
            }
        }

        $user->avatar_url = null;
        $user->save();

        return response()->json([
            'message' => 'Avatar removed successfully',
            'user'    => $user->fresh(),
        ], 200);
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password'      => 'required|string',
            'new_password'          => 'required|string|min:3|confirmed',
        ]);

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'Current password is incorrect',
            ], 400);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json([
            'message' => 'Password updated successfully',
        ], 200);
    }
}
