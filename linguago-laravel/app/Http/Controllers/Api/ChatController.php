<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Conversation;
use App\Models\Message;
use App\Events\MessageSent;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $conversations = $user->conversations()
            ->with(['participants' => function ($q) use ($user) {
                $q->where('users.id', '!=', $user->id)->select('users.id', 'users.username', 'users.name', 'users.avatar_url');
            }, 'lastMessage.sender'])
            ->latest('updated_at')
            ->get();

        return response()->json([
            'status' => 'success',
            'data'   => $conversations,
        ]);
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $request->validate([
            'user_ids'   => 'required|array|min:1',
            'user_ids.*' => 'integer|exists:users,id',
        ]);

        $userIds = $request->user_ids;

        if (in_array($user->id, $userIds)) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Tidak bisa membuat chat dengan diri sendiri',
            ], 400);
        }

        if (count($userIds) === 1) {
            $participantIds = collect([$user->id, $userIds[0]])->sort()->values();

            $existing = Conversation::where('type', 'private')
                ->whereHas('participants', function ($q) use ($participantIds) {
                    $q->whereIn('users.id', $participantIds);
                }, '=', 2)
                ->get()
                ->first(function ($conv) use ($participantIds) {
                    $ids = $conv->participants->pluck('id')->sort()->values();
                    return $ids->toArray() === $participantIds->toArray();
                });

            if ($existing) {
                return response()->json([
                    'status' => 'success',
                    'data'   => $existing->load(['participants', 'lastMessage.sender']),
                ]);
            }
        }

        $conversation = Conversation::create([
            'type' => count($userIds) === 1 ? 'private' : 'group',
        ]);

        $conversation->participants()->attach($user->id, ['joined_at' => now()]);
        foreach ($userIds as $uid) {
            $conversation->participants()->attach($uid, ['joined_at' => now()]);
        }

        $conversation->load(['participants', 'lastMessage.sender']);

        return response()->json([
            'status' => 'success',
            'data'   => $conversation,
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();

        $conversation = Conversation::whereHas('participants', function ($q) use ($user) {
            $q->where('users.id', $user->id);
        })->with(['participants' => function ($q) use ($user) {
            $q->where('users.id', '!=', $user->id);
        }])->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data'   => $conversation,
        ]);
    }

    public function messages(Request $request, $id)
    {
        $user = $request->user();

        $conversation = Conversation::whereHas('participants', function ($q) use ($user) {
            $q->where('users.id', $user->id);
        })->findOrFail($id);

        $messages = Message::where('conversation_id', $conversation->id)
            ->with('sender:id,username,name,avatar_url')
            ->latest()
            ->paginate(50);

        return response()->json([
            'status' => 'success',
            'data'   => $messages,
        ]);
    }

    public function sendMessage(Request $request, $id)
    {
        $user = $request->user();
        $request->validate([
            'content' => 'required|string|max:5000',
        ]);

        $conversation = Conversation::whereHas('participants', function ($q) use ($user) {
            $q->where('users.id', $user->id);
        })->findOrFail($id);

        $message = Message::create([
            'conversation_id' => $conversation->id,
            'sender_id'       => $user->id,
            'content'         => $request->content,
        ]);

        $message->load('sender:id,username,name,avatar_url');

        $conversation->touch();

        broadcast(new MessageSent($message))->toOthers();

        return response()->json([
            'status' => 'success',
            'data'   => $message,
        ], 201);
    }
}
