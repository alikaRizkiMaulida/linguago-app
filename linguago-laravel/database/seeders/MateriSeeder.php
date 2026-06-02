<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Course;
use App\Models\Chapter;
use App\Models\VideoLesson;
use App\Models\Map_Node;
use Illuminate\Support\Facades\File;

class MateriSeeder extends Seeder
{
    public function run()
    {
        $json = File::get(database_path('data/materi_chapters.json'));
        $data = json_decode($json, true);

        foreach ($data as $cData) {
            // 1. Simpan Course
            $course = Course::create([
                'course_title'  => $cData['course_title'],
                'language'      => $cData['language'],
                'description'    => $cData['description'], 
                'thumbnail_url' => $cData['thumbnail_url'],
            ]);

            foreach ($cData['chapters'] as $chData) {
                // 2. Simpan Chapter
                $chapter = Chapter::create([
                    'course_id'      => $course->id,
                    'chapter_number' => $chData['chapter_number'],
                    'chapter_title'  => $chData['chapter_title'],
                    'description'    => $chData['description'],
                ]);

                // Kita buat counter untuk node_number agar unik
                $nodeCounter = 1;

                foreach ($chData['lessons'] as $lData) {
                    // 3. Simpan ke map_nodes (Semua field yang kamu kasih ada di sini)
                    $node = Map_Node::create([
                        'chapter_id'       => $chapter->id,
                        'node_number'      => $nodeCounter++, 
                        'title'            => $lData['title'],
                        'description'      => "Materi video untuk " . $lData['title'],
                        'node_type'        => 'video', 
                        'position_x'       => 0, 
                        'position_y'       => 0,
                        'required_node_id' => null, 
                        'reward_xp'        => 50,    
                        'reward_gems'      => 5,     
                        'is_boss_node'     => false,
                    ]);

                    // 4. Simpan ke video_lessons
                    VideoLesson::create([
                        'node_id'          => $node->id, // Hubungkan ke Node di atas
                        'title'            => $lData['title'],
                        'video_url'        => $lData['video_url'],
                        'thumbnail_url'    => $cData['thumbnail_url'],
                        'duration_seconds' => 300, 
                    ]);
                }
            }
        }
    }
}