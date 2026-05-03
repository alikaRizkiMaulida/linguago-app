<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $req)
    {
        $req->validate([
            'username' => 'required|string',
            'name'     => 'required|string',
            'email'    => 'required|string|unique:users,email',
            'password' => 'required|string|min:3',
        ]);
        $user = User::create([
            'username' => $req->username,
            'name'     => $req->name,
            'email'    => $req->email,
            'password' => Hash::make($req->password),
        ]);
        return response([
            'user'  => $user,
            'token' => $user->createToken('auth_token')->plainTextToken,
        ], 200);
    }

    public function login(Request $request)
    {
        $user = User::where('email', $request->email)->first();
        if (! $user) {
            return Response([
                'message' => ['User not found'],
            ], 404);
        }
        if (! Hash::check($request->password, $user->password)) {
            return Response([
                'message' => ['Wrong password'],
            ], 404);
        }
        $token = $user->createToken('auth_token')->plainTextToken;
        return response(['user' => $user, 'token' => $token], 200);
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        if ($user) {
            $user->currentAccessToken()->delete();
            return response()->json([
                'status'  => 'success',
                'message' => 'logged out successfuly'], 200);
        }
        return response()->json([
            'status'  => 'error',
            'message' => 'user not found or already logged out',
        ], 401);
    }
}