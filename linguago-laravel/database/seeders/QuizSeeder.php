<?php

namespace Database\Seeders;

use App\Models\Chapter;
use App\Models\Course;
use App\Models\Map_Node;
use App\Models\QuestionOptions;
use App\Models\Questions;
use App\Models\Quizzes;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class QuizSeeder extends Seeder
{
    public function run()
    {
        $this->ensureKoreanChapter1Nodes();

        $jsonFiles = ['quiz.json', 'quiz_korea.json'];

        foreach ($jsonFiles as $file) {
            $path = database_path("data/{$file}");
            if (!File::exists($path)) {
                continue;
            }

            $json = File::get($path);
            $data = json_decode($json, true);

            foreach ($data as $qData) {
                $node = Map_Node::where('title', $qData['node_title'])->first();

                if (!$node) {
                    $this->command->warn("Node '{$qData['node_title']}' not found in '{$file}'. Skipping.");
                    continue;
                }

                if (Quizzes::where('node_id', $node->id)->exists()) {
                    continue;
                }

                $quiz = Quizzes::create([
                    'node_id'       => $node->id,
                    'title'         => $qData['quiz_title'],
                    'passing_score' => 80,
                ]);

                foreach ($qData['questions'] as $index => $ques) {
                    $question = Questions::create([
                        'quiz_id'       => $quiz->id,
                        'question_text' => $ques['text'],
                        'explanation'   => $ques['explanation'] ?? '',
                        'soft_order'    => $index + 1,
                    ]);

                    foreach ($ques['options'] as $oIdx => $opt) {
                        QuestionOptions::create([
                            'question_id' => $question->id,
                            'option_text' => $opt['text'],
                            'is_correct'  => $opt['is_correct'],
                            'soft_order'  => $oIdx + 1,
                        ]);
                    }
                }
            }
        }
    }

    private function ensureKoreanChapter1Nodes()
    {
        $course = Course::where('course_title', 'Bahasa Korea Dasar')->first();
        if (!$course) {
            return;
        }

        $chapter = Chapter::where('course_id', $course->id)
            ->where('chapter_number', 1)
            ->first();

        if (!$chapter) {
            return;
        }

        $lastNode = Map_Node::where('chapter_id', $chapter->id)
            ->orderBy('node_number', 'desc')
            ->first();

        $nextNumber = $lastNode ? $lastNode->node_number + 1 : 1;
        $lastId = $lastNode ? $lastNode->id : null;

        $defs = [
            ['title' => 'Quiz Level 1 Bagian 1', 'desc' => 'Uji pemahaman dasar huruf Hangul dan pelafalannya.',           'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Quiz Level 1 Bagian 2', 'desc' => 'Uji pemahaman merangkai huruf dan kosakata dasar Hangul.',     'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Fun Fact Hangul',        'desc' => 'Fakta-fakta menarik tentang Hangul dan bahasa Korea.',        'type' => 'fun_fact', 'xp' => 20,  'gems' => 2,  'boss' => false],
            ['title' => 'Quiz Final Level 1',     'desc' => 'Kuis akhir untuk menguji semua pemahaman Hangul Level 1.',    'type' => 'quiz',     'xp' => 100, 'gems' => 10, 'boss' => true],
            ['title' => 'Quiz Level 2 Bagian 1', 'desc' => 'Uji pemahaman vokal dasar Hangul (ㅏ, ㅗ, ㅜ, ㅣ, ㅓ).',          'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Quiz Level 2 Bagian 2', 'desc' => 'Uji pemahaman pengenalan vokal Hangul (ㅡ, ㅣ, ㅓ, ㅏ, ㅗ).',      'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Fun Fact Vowels',        'desc' => 'Fakta-fakta menarik tentang vokal Hangul dan pola pembentukannya.', 'type' => 'fun_fact', 'xp' => 20,  'gems' => 2,  'boss' => false],
            ['title' => 'Quiz Final Level 2',     'desc' => 'Kuis akhir untuk menguji semua pemahaman vokal Hangul Level 2.',    'type' => 'quiz',     'xp' => 100, 'gems' => 10, 'boss' => true],
            ['title' => 'Quiz Level 3 Bagian 1', 'desc' => 'Uji pemahaman konsonan dasar Hangul (ㄱ, ㄴ, ㅁ, ㅎ, ㅂ).',         'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Quiz Level 3 Bagian 2', 'desc' => 'Uji pemahaman pengenalan konsonan (ㅈ, ㅁ, ㄹ, ㅅ, ㅇ).',            'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Fun Fact Consonants',    'desc' => 'Fakta-fakta menarik tentang konsonan Hangul.',                    'type' => 'fun_fact', 'xp' => 20,  'gems' => 2,  'boss' => false],
            ['title' => 'Quiz Final Level 3',     'desc' => 'Kuis akhir untuk menguji semua pemahaman konsonan Hangul Level 3.','type' => 'quiz',     'xp' => 100, 'gems' => 10, 'boss' => true],
            ['title' => 'Quiz Level 4 Bagian 1', 'desc' => 'Uji pemahaman vokal rangkap dasar Hangul (ㅘ, ㅝ, ㅟ, ㅢ, ㅙ).',    'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Quiz Level 4 Bagian 2', 'desc' => 'Uji pemahaman pengenalan vokal rangkap (ㅘ, ㅚ, ㅞ, ㅝ, ㅚ).',      'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Fun Fact Compound Vowels', 'desc' => 'Fakta-fakta menarik tentang vokal rangkap Hangul.',             'type' => 'fun_fact', 'xp' => 20,  'gems' => 2,  'boss' => false],
            ['title' => 'Quiz Final Level 4',     'desc' => 'Kuis akhir untuk menguji semua pemahaman vokal rangkap Level 4.','type' => 'quiz',     'xp' => 100, 'gems' => 10, 'boss' => true],
            ['title' => 'Quiz Level 5 Bagian 1', 'desc' => 'Uji pemahaman konsonan ganda Hangul (ㄲ, ㄸ, ㅆ, ㅃ, ㅉ).',         'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Quiz Level 5 Bagian 2', 'desc' => 'Uji pemahaman pengenalan konsonan ganda (ㅆ, ㄲ, ㅃ, dll).',         'type' => 'quiz',     'xp' => 50,  'gems' => 5,  'boss' => false],
            ['title' => 'Fun Fact Double Consonants', 'desc' => 'Fakta-fakta menarik tentang konsonan ganda Hangul.',          'type' => 'fun_fact', 'xp' => 20,  'gems' => 2,  'boss' => false],
            ['title' => 'Quiz Final Level 5',     'desc' => 'Kuis akhir untuk menguji semua pemahaman konsonan ganda Level 5.','type' => 'quiz',     'xp' => 100, 'gems' => 10, 'boss' => true],
        ];

        foreach ($defs as $def) {
            $existing = Map_Node::where('chapter_id', $chapter->id)
                ->where('title', $def['title'])
                ->exists();

            if ($existing) {
                $node = Map_Node::where('chapter_id', $chapter->id)
                    ->where('title', $def['title'])
                    ->first();
                $lastId = $node->id;
                continue;
            }

            $node = Map_Node::create([
                'chapter_id'       => $chapter->id,
                'node_number'      => $nextNumber++,
                'title'            => $def['title'],
                'description'      => $def['desc'],
                'node_type'        => $def['type'],
                'position_x'       => 0,
                'position_y'       => 0,
                'required_node_id' => $lastId,
                'reward_xp'        => $def['xp'],
                'reward_gems'      => $def['gems'],
                'is_boss_node'     => $def['boss'],
            ]);

            $lastId = $node->id;
        }
    }
}