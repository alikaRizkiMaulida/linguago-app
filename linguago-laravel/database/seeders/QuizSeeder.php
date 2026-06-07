<?php

namespace Database\Seeders;

use App\Models\Map_Node;
use App\Models\QuestionOptions;
use App\Models\Questions;
use App\Models\Quizzes;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class QuizSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        if (File::exists(database_path('data/quiz.json'))) {
            $json = File::get(database_path('data/quiz.json'));
            $data = json_decode($json, true);

            foreach ($data as $qData) {
                // Find MapNode by title (linked to corresponding node in the map)
                $node = Map_Node::where('title', $qData['node_title'])->first();

                if ($node) {
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
    }
}