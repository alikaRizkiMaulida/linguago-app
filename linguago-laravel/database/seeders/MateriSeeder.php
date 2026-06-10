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

        // Keep track of the last created node globally (or per course) to create sequential required_node_id
        $lastNodeId = null;

        foreach ($data as $cData) {
            // 1. Simpan Course
            $course = Course::create([
                'course_title'  => $cData['course_title'],
                'language'      => $cData['language'],
                'description'   => $cData['description'], 
                'thumbnail_url' => $cData['thumbnail_url'],
            ]);

            // Reset last node ID for each course so courses are independent
            $lastNodeId = null;

            foreach ($cData['chapters'] as $chData) {
                // 2. Simpan Chapter
                $chapter = Chapter::create([
                    'course_id'      => $course->id,
                    'chapter_number' => $chData['chapter_number'],
                    'chapter_title'  => $chData['chapter_title'],
                    'description'    => $chData['description'],
                ]);

                $nodeCounter = 1;

                // SPECIAL CASE: Course 1 (English for Beginners) - Chapter 1
                // We seed the exact 5-node sequence requested for Level 1
                if ($course->course_title === 'English for Beginners' && in_array($chapter->chapter_number, [1, 2, 3, 4, 5])) {
                    $chapterConfigs = [
                        1 => [
                            'video_title' => 'ABC Song',
                            'video_desc'  => 'Learn the Alphabet with the ABC Song video lesson.',
                            'video_url'   => 'https://youtu.be/CU6x9olTzuo?si=6ACYhW3Nbi-Wgisk',
                            'q1_title'    => 'Quiz Level 1',
                            'q1_desc'     => 'Uji pemahamanmu tentang huruf vokal dan konsonan dasar.',
                            'q2_title'    => 'Quiz Level 2',
                            'q2_desc'     => 'Uji pemahamanmu tentang bunyi khusus seperti SH dan PH.',
                            'ff_title'    => 'Fun Fact Alphabet',
                            'ff_desc'     => 'Fakta-fakta menarik tentang huruf dan kata dalam Bahasa Inggris.',
                            'qf_title'    => 'Quiz Final',
                            'qf_desc'     => 'Kuis akhir untuk menguji semua pemahaman huruf di Chapter 1.',
                        ],
                        2 => [
                            'video_title' => 'Numbers Song 1-100',
                            'video_desc'  => 'Learn basic numbers, teens, and multiples of ten up to 100.',
                            'video_url'   => 'https://youtu.be/D0Ajq682yrA?si=m5l9Wn7VfJEq_k2W',
                            'q1_title'    => 'Quiz Level 2.1',
                            'q1_desc'     => 'Uji pemahaman dasar angka 1-10 dalam Bahasa Inggris.',
                            'q2_title'    => 'Quiz Level 2.2',
                            'q2_desc'     => 'Uji pemahaman angka belasan, puluhan, hingga 100.',
                            'ff_title'    => 'Fun Fact Numbers',
                            'ff_desc'     => 'Fakta menarik tentang sejarah angka, spelling \'forty\', dan kegunaannya.',
                            'qf_title'    => 'Quiz Final Level 2',
                            'qf_desc'     => 'Kuis akhir untuk menguji semua pemahaman angka 1-100.',
                        ],
                        3 => [
                            'video_title' => 'Reading Dates in English',
                            'video_desc'  => 'Learn how to read and write calendar dates and use ordinal numbers.',
                            'video_url'   => 'https://youtu.be/Fe9B7y42898?si=Z6y_19_N2829y',
                            'q1_title'    => 'Quiz Level 3.1',
                            'q1_desc'     => 'Uji pemahaman dasar penulisan tanggal dan bentuk ordinal.',
                            'q2_title'    => 'Quiz Level 3.2',
                            'q2_desc'     => 'Uji pemahaman membaca tanggal spesifik dan format penanggalan.',
                            'ff_title'    => 'Fun Fact Dates',
                            'ff_desc'     => 'Fakta menarik tentang pembacaan tanggal, huruf kapital pada bulan, dan format penulisan.',
                            'qf_title'    => 'Quiz Final Level 3',
                            'qf_desc'     => 'Kuis akhir untuk menguji pemahaman tanggal dan angka ordinal.',
                        ],
                        4 => [
                            'video_title' => 'Days of the Week Song',
                            'video_desc'  => 'Learn the seven days of the week, weekdays vs weekends, and prepositions.',
                            'video_url'   => 'https://youtu.be/mXMofxtDPUQ?si=1fQYp3P9pI123',
                            'q1_title'    => 'Quiz Level 4.1',
                            'q1_desc'     => 'Uji pemahaman nama-nama hari dan urutannya.',
                            'q2_title'    => 'Quiz Level 4.2',
                            'q2_desc'     => 'Uji pemahaman penggunaan preposisi untuk nama hari.',
                            'ff_title'    => 'Fun Fact Days',
                            'ff_desc'     => 'Fakta menarik tentang asal-usul nama hari, jam dalam seminggu, dan penulisan kapital.',
                            'qf_title'    => 'Quiz Final Level 4',
                            'qf_desc'     => 'Kuis akhir untuk menguji pemahaman nama hari dan preposisi.',
                        ],
                        5 => [
                            'video_title' => 'Months of the Year Song',
                            'video_desc'  => 'Learn the twelve months of the year, seasons, and prepositions.',
                            'video_url'   => 'https://youtu.be/Fe9B7y42898?si=Z6y_19_N2829y',
                            'q1_title'    => 'Quiz Level 5.1',
                            'q1_desc'     => 'Uji pemahaman dasar nama-nama bulan dan urutannya.',
                            'q2_title'    => 'Quiz Level 5.2',
                            'q2_desc'     => 'Uji pemahaman penggunaan preposisi dan asosiasi bulan.',
                            'ff_title'    => 'Fun Fact Months',
                            'ff_desc'     => 'Fakta menarik tentang asal-usul nama bulan Juli-Agustus, bulan terpendek, dan musim.',
                            'qf_title'    => 'Quiz Final Level 5',
                            'qf_desc'     => 'Kuis akhir untuk menguji semua pemahaman bulan dan preposisi.',
                        ],
                    ];

                    $cfg = $chapterConfigs[$chapter->chapter_number];

                    // Node 1: Video Lesson
                    $node1 = Map_Node::create([
                        'chapter_id'       => $chapter->id,
                        'node_number'      => $nodeCounter++,
                        'title'            => $cfg['video_title'],
                        'description'      => $cfg['video_desc'],
                        'node_type'        => 'video',
                        'position_x'       => 0,
                        'position_y'       => 0,
                        'required_node_id' => $lastNodeId,
                        'reward_xp'        => 50,
                        'reward_gems'      => 5,
                        'is_boss_node'     => false,
                    ]);

                    VideoLesson::create([
                        'node_id'          => $node1->id,
                        'title'            => $cfg['video_title'],
                        'video_url'        => $cfg['video_url'],
                        'thumbnail_url'    => $course->thumbnail_url,
                        'duration_seconds' => 300,
                    ]);

                    // Node 2: Quiz Level X.1
                    $node2 = Map_Node::create([
                        'chapter_id'       => $chapter->id,
                        'node_number'      => $nodeCounter++,
                        'title'            => $cfg['q1_title'],
                        'description'      => $cfg['q1_desc'],
                        'node_type'        => 'quiz',
                        'position_x'       => 0,
                        'position_y'       => 0,
                        'required_node_id' => $node1->id,
                        'reward_xp'        => 50,
                        'reward_gems'      => 5,
                        'is_boss_node'     => false,
                    ]);

                    // Node 3: Quiz Level X.2
                    $node3 = Map_Node::create([
                        'chapter_id'       => $chapter->id,
                        'node_number'      => $nodeCounter++,
                        'title'            => $cfg['q2_title'],
                        'description'      => $cfg['q2_desc'],
                        'node_type'        => 'quiz',
                        'position_x'       => 0,
                        'position_y'       => 0,
                        'required_node_id' => $node2->id,
                        'reward_xp'        => 50,
                        'reward_gems'      => 5,
                        'is_boss_node'     => false,
                    ]);

                    // Node 4: Fun Fact
                    $node4 = Map_Node::create([
                        'chapter_id'       => $chapter->id,
                        'node_number'      => $nodeCounter++,
                        'title'            => $cfg['ff_title'],
                        'description'      => $cfg['ff_desc'],
                        'node_type'        => 'fun_fact',
                        'position_x'       => 0,
                        'position_y'       => 0,
                        'required_node_id' => $node3->id,
                        'reward_xp'        => 20,
                        'reward_gems'      => 2,
                        'is_boss_node'     => false,
                    ]);

                    // Node 5: Quiz Final
                    $node5 = Map_Node::create([
                        'chapter_id'       => $chapter->id,
                        'node_number'      => $nodeCounter++,
                        'title'            => $cfg['qf_title'],
                        'description'      => $cfg['qf_desc'],
                        'node_type'        => 'quiz',
                        'position_x'       => 0,
                        'position_y'       => 0,
                        'required_node_id' => $node4->id,
                        'reward_xp'        => 100,
                        'reward_gems'      => 10,
                        'is_boss_node'     => true,
                    ]);

                    // Set last node ID for next chapter prerequisite
                    $lastNodeId = $node5->id;

                } else {
                    // Default logic for other chapters/courses
                    foreach ($chData['lessons'] as $lData) {
                        $node = Map_Node::create([
                            'chapter_id'       => $chapter->id,
                            'node_number'      => $nodeCounter++, 
                            'title'            => $lData['title'],
                            'description'      => "Materi video untuk " . $lData['title'],
                            'node_type'        => 'video', 
                            'position_x'       => 0, 
                            'position_y'       => 0,
                            'required_node_id' => $lastNodeId, 
                            'reward_xp'        => 50,    
                            'reward_gems'      => 5,     
                            'is_boss_node'     => false,
                        ]);

                        VideoLesson::create([
                            'node_id'          => $node->id,
                            'title'            => $lData['title'],
                            'video_url'        => $lData['video_url'],
                            'thumbnail_url'    => $course->thumbnail_url,
                            'duration_seconds' => 300, 
                        ]);

                        $lastNodeId = $node->id;
                    }
                }
            }
        }
    }
}