import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/core/constants/language_preference.dart';
import 'package:linguago_flutter/ui/widgets/mascot_widget.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_completed_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_failed_screen.dart';

class QuizScreen extends StatefulWidget {
  final int part;
  const QuizScreen({super.key, this.part = 1});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0; // 0 to 4 (5 questions)
  int? _selectedOptionIndex;
  bool _hasChecked = false;
  bool _isAnswerCorrect = false;
  int _hearts = 5;
  int _correctCount = 0;
  final List<int> _selectedArrangeIndices = [];

  late AnimationController _progressController;
  late final List<Map<String, dynamic>> _questions;

  static const List<Map<String, dynamic>> _basicQuestions = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'HAN',
      'letters': ['ㄴ', 'ㅏ', 'ㅎ', 'ㄱ'],
      'correctAnswer': '한',
      'pose': MascotPose.reading,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': '가다',
      'options': ['Nara', 'Gada', 'Hane', 'Guri'],
      'correct': 1, // "Gada"
      'pose': MascotPose.reading,
    },
    {
      'type': 'true_false',
      'text': 'Hangul is the Korean alphabet system.',
      'options': ['True', 'False'],
      'correct': 0, // "True"
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which Pronunciation letter has the sound "ㄷ"?',
      'options': ['Hieut', 'Gieok', 'Nieun', 'Digot'],
      'correct': 3, // "Digot"
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word:',
      'options': ['ㅓ', 'ㅏ', 'ㅜ', 'ㅣ'],
      'correct': 1, // "ㅏ" -> "가다"
      'pose': MascotPose.teaching,
    },
  ];

  static const List<Map<String, dynamic>> _listeningQuestions = [
    {
      'type': 'blackboard',
      'text': 'What is the sound of ㄴ?',
      'boardText': 'ㄴ',
      'options': ['G', 'N', 'D', 'S'],
      'correct': 1, // 'N'
      'pose': MascotPose.teaching,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the Hangul letter with the correct sound.',
      'audioWord': 'Shiot',
      'options': ['ㄱ', 'ㄷ', 'ㅅ', 'ㅏ'],
      'correct': 2, // 'ㅅ'
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which Hangul letter has the sound "A"?',
      'options': ['ㅏ', 'ㅐ', 'ㅓ', 'ㅣ'],
      'correct': 0, // 'ㅏ'
      'pose': MascotPose.confused,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': '가다',
      'options': ['Nara', 'Gada', 'Hana', 'Guri'],
      'correct': 1, // 'Gada'
      'pose': MascotPose.reading,
    },
    {
      'type': 'reading',
      'text': 'What does 한국어 mean?',
      'options': ['English language', 'Korean student', 'Korean teacher', 'Korean language'],
      'correct': 3, // 'Korean language'
      'pose': MascotPose.reading,
      'watermark': '?',
    },
  ];

  static const List<Map<String, dynamic>> _mixedQuestions = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'HADA',
      'letters': ['ㄷ', 'ㅏ', 'ㅎ', 'ㅏ'],
      'correctAnswer': '하다',
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word to spell "NARA" (country):',
      'options': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': '우리',
      'options': ['Nara', 'Uri', 'Guri', 'Hane'],
      'correct': 1,
      'pose': MascotPose.reading,
    },
    {
      'type': 'pronunciation',
      'text': 'Which Korean letter makes the sound "ㄴ"?',
      'options': ['Nieun', 'Gieok', 'Digeut', 'Hieut'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Annyeong":',
      'audioWord': 'Annyeong',
      'options': ['안녕', '안녕하세요', '가다', '나라'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
  ];

  static const List<Map<String, dynamic>> _finalQuestions = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'HADA',
      'letters': ['ㄷ', 'ㅏ', 'ㅎ', 'ㅏ'],
      'correctAnswer': '하다',
      'pose': MascotPose.reading,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Annyeong":',
      'audioWord': 'Annyeong',
      'options': ['안녕', '안녕하세요', '가다', '나라'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': '우리',
      'options': ['Nara', 'Uri', 'Guri', 'Hane'],
      'correct': 1,
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word to spell "NARA" (country):',
      'options': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The Korean alphabet system is called Hangul.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
  ];

  static const List<Map<String, dynamic>> _basicEnglishQuestions = [
    {
      'type': 'pronunciation',
      'text': 'What is the common sound of the letter A in "Name"?',
      'options': ['Ah', 'Ey', 'Ee', 'Oh'],
      'correct': 1,
      'pose': MascotPose.confused,
      'watermark': 'Aa',
    },
    {
      'type': 'blackboard',
      'text': 'Which word has the A sound like in "Can"?',
      'boardText': 'CAN',
      'options': ['Care', 'Car', 'Bad', 'Name'],
      'correct': 2,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound can the letter "C" make?',
      'options': ['K/S', 'B/D', 'F/V', 'T/H'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'true_false',
      'text': 'The letter C can sound like "S".',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has a silent "K"?',
      'options': ['King', 'Kite', 'Kid', 'Know'],
      'correct': 3,
      'pose': MascotPose.reading,
    },
  ];

  static const List<Map<String, dynamic>> _listeningEnglishQuestions = [
    {
      'type': 'blackboard',
      'text': 'What is the sound of the letter I in "Like"?',
      'boardText': 'Like',
      'options': ['AY', 'IH', 'EE', 'EH'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the word you hear with the correct spelling:',
      'audioWord': 'See',
      'options': ['See', 'Sea', 'She', 'Say'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which letter is silent in the word "Knee"?',
      'options': ['K', 'N', 'E', 'None'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'reading',
      'text': 'How do you read the word "Thought"?',
      'options': ['Th-ot', 'T-out', 'Th-oh-gt', 'T-ot'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'reading',
      'text': 'What does the word "School" mean?',
      'options': ['Sekolah', 'Rumah', 'Kantor', 'Taman'],
      'correct': 0,
      'pose': MascotPose.reading,
      'watermark': '?',
    },
  ];

  static const List<Map<String, dynamic>> _mixedEnglishQuestions = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'NAME',
      'letters': ['M', 'A', 'N', 'E'],
      'correctAnswer': 'NAME',
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the spelling of "C_ty":',
      'options': ['i', 'y', 'e', 'a'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'reading',
      'text': 'How do you read the word "Time"?',
      'options': ['Tym', 'Ta-im', 'Tee-me', 'Tim'],
      'correct': 1,
      'pose': MascotPose.reading,
    },
    {
      'type': 'pronunciation',
      'text': 'Which letter is silent in the word "Hour"?',
      'options': ['H', 'O', 'U', 'R'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Hello":',
      'audioWord': 'Hello',
      'options': ['Hello', 'Help', 'Hollow', 'Hero'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
  ];

  static const List<Map<String, dynamic>> _finalEnglishQuestions = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'CARE',
      'letters': ['R', 'A', 'E', 'C'],
      'correctAnswer': 'CARE',
      'pose': MascotPose.reading,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Awesome":',
      'audioWord': 'Awesome',
      'options': ['Awesome', 'Awful', 'Somehow', 'Always'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'reading',
      'text': 'How do you read the word "See"?',
      'options': ['Se-e', 'Si', 'Say', 'She'],
      'correct': 1,
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word to spell "B_d" (tempat tidur):',
      'options': ['e', 'a', 'o', 'u'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'In English, the letter C always sounds like "K".',
      'options': ['True', 'False'],
      'correct': 1,
      'pose': MascotPose.confused,
    },
  ];

  // ── Box 3 English quiz parts (placeholder — will be filled with user content) ──
  static const List<Map<String, dynamic>> _level3Part1EnglishQuestions = [
    {
      'type': 'pronunciation',
      'text': 'What sound does "ph" make in "phone"?',
      'options': ['P', 'F', 'H', 'B'],
      'correct': 1,
      'pose': MascotPose.confused,
      'watermark': 'ph',
    },
    {
      'type': 'blackboard',
      'text': 'Which word uses a silent "B"?',
      'boardText': 'Silent B',
      'options': ['Bat', 'Bomb', 'Best', 'Bear'],
      'correct': 1,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'In English, "gh" is always silent.',
      'options': ['True', 'False'],
      'correct': 1,
      'pose': MascotPose.confused,
    },
    {
      'type': 'reading',
      'text': 'What does "enough" mean?',
      'options': ['Cukup', 'Banyak', 'Sedikit', 'Kurang'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has the same vowel sound as "feet"?',
      'options': ['Fit', 'Fat', 'Feat', 'Foul'],
      'correct': 2,
      'pose': MascotPose.reading,
    },
  ];

  static const List<Map<String, dynamic>> _level3Part2EnglishQuestions = [
    {
      'type': 'audio_choice',
      'text': 'What sound does the letter "G" make?',
      'audioWord': 'Page',
      'options': ['G', 'J', 'K', 'S'],
      'correct': 1, // J — in "Page" the G sounds like J
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'How is "PH" usually pronounced?',
      'options': ['P', 'H', 'F', 'V'],
      'correct': 2, // F
      'pose': MascotPose.confused,
      'watermark': 'PH',
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word with the correct letter sound.',
      'boardText': '_ag',
      'options': ['S', 'B', 'V', 'G'],
      'correct': 1, // B → Bag
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'English letter "R" is pronounced strongly like Indonesian R.',
      'options': ['True', 'False'],
      'correct': 1, // False
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Which word contains the "CH" sound?',
      'audioWord': 'Chair',
      'options': ['Chair', 'Car', 'Share', 'Care'],
      'correct': 0, // Chair
      'pose': MascotPose.listening,
    },
  ];

  // ── Box 3 Korean quiz parts (placeholder) ──
  static const List<Map<String, dynamic>> _level3Part1KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which Hangul character sounds like "R/L"?',
      'options': ['ㄹ', 'ㄴ', 'ㅁ', 'ㄷ'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'reading',
      'text': 'How do you read "학교"?',
      'options': ['Hakgyo', 'Hangyo', 'Hakgo', 'Hanggo'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'true_false',
      'text': '학교 means school in Korean.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'What sound does ㅎ make?',
      'boardText': 'ㅎ',
      'options': ['H', 'P', 'F', 'S'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'reading',
      'text': 'What does 선생님 mean?',
      'options': ['Friend', 'Teacher', 'Student', 'School'],
      'correct': 1,
      'pose': MascotPose.reading,
    },
  ];

  static const List<Map<String, dynamic>> _level3Part2KoreanQuestions = [
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Annyeong":',
      'audioWord': 'Annyeong',
      'options': ['안녕', '감사', '미안', '고마워'],
      'correct': 0, // 안녕
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'How is ㅈ usually pronounced?',
      'options': ['Z', 'J', 'S', 'D'],
      'correct': 1, // J
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'What sound does ㅂ make?',
      'boardText': 'ㅂ',
      'options': ['B/P', 'M', 'V', 'F'],
      'correct': 0, // B/P
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'ㅏ and ㅑ have the exact same vowel sound.',
      'options': ['True', 'False'],
      'correct': 1, // False — ㅏ is "a", ㅑ is "ya"
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Saranghae":',
      'audioWord': 'Saranghae',
      'options': ['사랑해', '안녕하세요', '고마워요', '미안해요'],
      'correct': 0, // 사랑해
      'pose': MascotPose.listening,
    },
  ];

  // ── Box 3 English quiz Part 3 ──
  static const List<Map<String, dynamic>> _level3Part3EnglishQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which word has the "SH" sound?',
      'options': ['Show', 'Sun', 'Rose', 'Bag'],
      'correct': 0, // Show
      'pose': MascotPose.confused,
      'watermark': 'SH',
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word with the correct letter sound.',
      'boardText': 'Kn_fe',
      'options': ['i', 'e', 'a', 'u'],
      'correct': 0, // i → Knife
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The letter Y can act as a vowel in English.',
      'options': ['True', 'False'],
      'correct': 0, // True
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Which word matches this sound?',
      'audioWord': 'Night',
      'options': ['Night', 'Neat', 'Note', 'Nail'],
      'correct': 0, // Night
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has a silent "K"?',
      'options': ['Know', 'Kick', 'King', 'Keep'],
      'correct': 0, // Know
      'pose': MascotPose.confused,
      'watermark': 'K',
    },
  ];

  // ── Box 3 Korean quiz Part 3 ──
  static const List<Map<String, dynamic>> _level3Part3KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which Hangul character sounds like "NG"?',
      'options': ['ㅇ', 'ㄴ', 'ㄷ', 'ㄹ'],
      'correct': 0, // ㅇ
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'What sound does ㅊ make?',
      'boardText': 'ㅊ',
      'options': ['Ch', 'S', 'T', 'P'],
      'correct': 0, // Ch
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': '친구 means "friend" in Korean.',
      'options': ['True', 'False'],
      'correct': 0, // True
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Saranghaeyo":',
      'audioWord': 'Saranghaeyo',
      'options': ['사랑해요', '감사합니다', '안녕하세요', '미안해요'],
      'correct': 0, // 사랑해요
      'pose': MascotPose.listening,
    },
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'NARA',
      'letters': ['ㄴ', 'ㅏ', 'ㄹ', 'ㅏ'],
      'correctAnswer': '나라',
      'pose': MascotPose.reading,
    },
  ];

  // ── Box 5 English quiz parts ──
  static const List<Map<String, dynamic>> _level5Part1EnglishQuestions = [
    {
      'type': 'blackboard',
      'text': 'Which word has the "AI" sound?',
      'boardText': 'AI',
      'options': ['Bed', 'Sin', 'Run', 'Fine'],
      'correct': 3, // Fine
      'pose': MascotPose.teaching,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "PH" make?',
      'options': ['F', 'P', 'H', 'SH'],
      'correct': 0, // F
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word contains a silent H?',
      'options': ['Home', 'Happy', 'Hour', 'Hat'],
      'correct': 2, // Hour
      'pose': MascotPose.confused,
      'watermark': 'Aa',
    },
    {
      'type': 'image_choice',
      'text': 'Which word has the "z" sound?',
      'options': ['Show', 'Rose', 'Sun', 'think'],
      'optionImages': [
        'assets/stage_spotlight.png',
        'assets/red_rose.png',
        'assets/cartoon_sun.png',
        'assets/stickman_thinking.png'
      ],
      'correct': 1, // Rose
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What is the pronunciation of the letter "V"?',
      'options': ['Like F', 'Silent', 'Like B', 'using 👄 and 🦷'],
      'correct': 3, // using 👄 and 🦷
      'pose': MascotPose.reading,
    },
  ];

  static const List<Map<String, dynamic>> _level5Part2EnglishQuestions = [
    {
      'type': 'blackboard',
      'text': 'Which word has the "EE" sound?',
      'boardText': 'EE',
      'options': ['Red', 'Meet', 'Cat', 'Dog'],
      'correct': 1, // Meet
      'pose': MascotPose.teaching,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "CH" make?',
      'options': ['Sh', 'K', 'Ch', 'S'],
      'correct': 2, // Ch
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word contains a silent W?',
      'options': ['Write', 'Walk', 'Wet', 'Wind'],
      'correct': 0, // Write
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has the "SH" sound?',
      'options': ['Fish', 'Sun', 'Star', 'Tree'],
      'correct': 0, // Fish
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What is the pronunciation of the letter "G" in "Gently"?',
      'options': ['Like G in "Go"', 'Like J', 'Silent', 'Like K'],
      'correct': 1, // Like J
      'pose': MascotPose.reading,
    },
  ];

  static const List<Map<String, dynamic>> _level5Part3EnglishQuestions = [
    {
      'type': 'blackboard',
      'text': 'Which word has the "OW" sound?',
      'boardText': 'OW',
      'options': ['Cow', 'Snow', 'Low', 'Row'],
      'correct': 0, // Cow
      'pose': MascotPose.teaching,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "TH" make in "Think"?',
      'options': ['F', 'S', 'T', 'Th'],
      'correct': 3, // Th
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word contains a silent L?',
      'options': ['Talk', 'Tall', 'Tell', 'Toll'],
      'correct': 0, // Talk
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has the "F" sound?',
      'options': ['Photo', 'Pen', 'Paper', 'Pencil'],
      'correct': 0, // Photo
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What is the pronunciation of the letter "C" in "Circle"?',
      'options': ['Like K', 'Like S', 'Like Sh', 'Silent'],
      'correct': 1, // Like S
      'pose': MascotPose.reading,
    },
  ];

  // ── Box 5 Korean quiz parts ──
  static const List<Map<String, dynamic>> _level5Part1KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which character is the double consonant "ㄲ"?',
      'options': ['ㄱ', 'ㅋ', 'ㄲ', 'ㄷ'],
      'correct': 2,
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "ㅗ" make?',
      'options': ['O', 'U', 'A', 'E'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'blackboard',
      'text': 'How do you write the syllable "Han"?',
      'boardText': '한',
      'options': ['한', '학', '하', '함'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'reading',
      'text': 'How do you read "물"?',
      'options': ['Mul', 'Bul', 'Sul', 'Kul'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'true_false',
      'text': 'Is "Hangul" the name of the Korean alphabet?',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.success,
    },
  ];

  static const List<Map<String, dynamic>> _level5Part2KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'What sound does "ㅐ" make?',
      'options': ['Ae', 'E', 'Ya', 'Yo'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'reading',
      'text': 'How do you read "밥"?',
      'options': ['Bap', 'Bab', 'Pap', 'Mab'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'reading',
      'text': 'Which word makes the sound "Sarang"?',
      'options': ['사랑', '사람', '사탕', '사자'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word to spell "K-Pop":',
      'boardText': '케이팝',
      'options': ['팝', '요', '래', '막'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The consonant "ㅇ" has no sound when placed at the beginning of a syllable.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
  ];

  static const List<Map<String, dynamic>> _level5Part3KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which character is "ㅌ"?',
      'options': ['ㄷ', 'ㅌ', 'ㄸ', 'ㅋ'],
      'correct': 1,
      'pose': MascotPose.confused,
    },
    {
      'type': 'reading',
      'text': 'How do you read "한국"?',
      'options': ['Hanguk', 'Hangul', 'Hangyo', 'Hangang'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "ㅝ" make?',
      'options': ['Wo', 'We', 'Wa', 'Wi'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the spelling of "감사합니다" (Thank you):',
      'boardText': '감사합니다',
      'options': ['합', '함', '하', '밥'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The double consonant "ㅃ" is pronounced strongly.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.success,
    },
  ];

  // ── Box 6 English quiz parts ──
  static const List<Map<String, dynamic>> _level6Part1EnglishQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which word has a long E sound?',
      'options': ['Bed', 'Bee', 'Run', 'Full'],
      'correct': 1, // Bee
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "TH" make in "Think"?',
      'options': ['T', 'D', 'TH', 'F'],
      'correct': 2, // TH
      'pose': MascotPose.confused,
      'watermark': 'Aa',
    },
    {
      'type': 'blackboard',
      'text': 'Which word has the "OU" sound?',
      'boardText': 'OU',
      'options': ['Full', 'Sin', 'Cool', 'Rose'],
      'correct': 2, // Cool (long /u:/ sound)
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The letter "C" can sound like "CH".',
      'options': ['True', 'False'],
      'correct': 1, // False
      'pose': MascotPose.confused,
    },
    {
      'type': 'image_choice',
      'text': 'Which word is pronounced with a silent K?',
      'options': ['Kid', 'King', 'Knee', 'Kite'],
      'optionImages': [
        'assets/cartoon_kid.png',
        'assets/cartoon_king.png',
        'assets/cartoon_knee.png',
        'assets/cartoon_kite.png'
      ],
      'correct': 2, // Knee
      'pose': MascotPose.confused,
    },
  ];

  static const List<Map<String, dynamic>> _level6Part2EnglishQuestions = [
    {
      'type': 'blackboard',
      'text': 'Which word has the "OI" sound?',
      'boardText': 'OI',
      'options': ['Coin', 'Cone', 'Can', 'Corn'],
      'correct': 0, // Coin
      'pose': MascotPose.teaching,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "SH" make?',
      'options': ['S', 'Sh', 'Ch', 'Z'],
      'correct': 1, // Sh
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word contains a silent W?',
      'options': ['Write', 'Who', 'Wake', 'Wind'],
      'correct': 0, // Write
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has a soft G sound?',
      'options': ['Giant', 'Game', 'Gate', 'Gold'],
      'correct': 0, // Giant
      'pose': MascotPose.confused,
    },
    {
      'type': 'true_false',
      'text': 'Is the letter "L" silent in "Walk"?',
      'options': ['True', 'False'],
      'correct': 0, // True
      'pose': MascotPose.success,
    },
  ];

  static const List<Map<String, dynamic>> _level6Part3EnglishQuestions = [
    {
      'type': 'blackboard',
      'text': 'Which word has the "AY" sound?',
      'boardText': 'AY',
      'options': ['Day', 'Dog', 'Dig', 'Den'],
      'correct': 0, // Day
      'pose': MascotPose.teaching,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "PH" make?',
      'options': ['P', 'F', 'H', 'B'],
      'correct': 1, // F
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word contains a silent T?',
      'options': ['Castle', 'Cat', 'Cold', 'Cart'],
      'correct': 0, // Castle
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word has a hard C sound?',
      'options': ['Cat', 'City', 'Cell', 'Center'],
      'correct': 0, // Cat
      'pose': MascotPose.confused,
    },
    {
      'type': 'true_false',
      'text': 'The word "Knight" has two silent letters.',
      'options': ['True', 'False'],
      'correct': 0, // True (K and GH)
      'pose': MascotPose.success,
    },
  ];

  // ── Box 6 Korean quiz parts ──
  static const List<Map<String, dynamic>> _level6Part1KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which double vowel represents the sound "We"?',
      'options': ['ㅞ', 'ㅘ', 'ㅝ', 'ㅢ'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What is the pronunciation of "ㅂ" when it is at the bottom (batchim)?',
      'options': ['P', 'B', 'M', 'N'],
      'correct': 0, // P
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word contains the consonant "ㅋ"?',
      'options': ['코', '고', '도', '로'],
      'correct': 0, // 코
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'How do you write the syllable "Guk"?',
      'boardText': '국',
      'options': ['국', '군', '물', '밥'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The character "ㅇ" has no sound when at the bottom of a syllable.',
      'options': ['True', 'False'],
      'correct': 1, // False (sounds like NG)
      'pose': MascotPose.confused,
    },
  ];

  static const List<Map<String, dynamic>> _level6Part2KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which character represents the double consonant "ㅃ"?',
      'options': ['ㅃ', 'ㅂ', 'ㅍ', 'ㅁ'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What sound does "ㅢ" make when it\'s at the beginning of a word?',
      'options': ['Ui', 'E', 'I', 'A'],
      'correct': 0, // Ui
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word means "Water" in Korean?',
      'options': ['물', '불', '풀', '줄'],
      'correct': 0, // 물
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'How do you write the syllable "Hyo"?',
      'boardText': '효',
      'options': ['효', '하', '허', '호'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'Is "Hangul" written from top to bottom and left to right?',
      'options': ['True', 'False'],
      'correct': 0, // True
      'pose': MascotPose.success,
    },
  ];

  static const List<Map<String, dynamic>> _level6Part3KoreanQuestions = [
    {
      'type': 'pronunciation',
      'text': 'Which double vowel makes the sound "Wa"?',
      'options': ['ㅘ', 'ㅝ', 'ㅚ', 'ㅟ'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'What is the pronunciation of "ㄷ" when used as batchim?',
      'options': ['T', 'D', 'N', 'L'],
      'correct': 0, // T
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which word means "Teacher" in Korean?',
      'options': ['선생님', '학생', '친구', '학교'],
      'correct': 0, // 선생님
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'How do you write the syllable "Hap"?',
      'boardText': '합',
      'options': ['합', '한', '할', '함'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The character "ㅎ" can sound silent in some words like "좋아".',
      'options': ['True', 'False'],
      'correct': 0, // True
      'pose': MascotPose.success,
    },
  ];

  @override
  void initState() {
    super.initState();

    final bool isEnglish = LanguagePreference.current == 'English';
    if (isEnglish) {
      if (widget.part == 2) {
        _questions = _listeningEnglishQuestions;
      } else if (widget.part == 3) {
        _questions = _mixedEnglishQuestions;
      } else if (widget.part == 5) {
        _questions = _finalEnglishQuestions;
      } else if (widget.part == 7) {
        _questions = _level3Part1EnglishQuestions;
      } else if (widget.part == 8) {
        _questions = _level3Part2EnglishQuestions;
      } else if (widget.part == 9) {
        _questions = _level3Part3EnglishQuestions;
      } else if (widget.part == 10) {
        _questions = _level5Part1EnglishQuestions;
      } else if (widget.part == 11) {
        _questions = _level5Part2EnglishQuestions;
      } else if (widget.part == 12) {
        _questions = _level5Part3EnglishQuestions;
      } else if (widget.part == 13) {
        _questions = _level6Part1EnglishQuestions;
      } else if (widget.part == 14) {
        _questions = _level6Part2EnglishQuestions;
      } else if (widget.part == 15) {
        _questions = _level6Part3EnglishQuestions;
      } else {
        _questions = _basicEnglishQuestions;
      }
    } else {
      if (widget.part == 2) {
        _questions = _listeningQuestions;
      } else if (widget.part == 3) {
        _questions = _mixedQuestions;
      } else if (widget.part == 5) {
        _questions = _finalQuestions;
      } else if (widget.part == 7) {
        _questions = _level3Part1KoreanQuestions;
      } else if (widget.part == 8) {
        _questions = _level3Part2KoreanQuestions;
      } else if (widget.part == 9) {
        _questions = _level3Part3KoreanQuestions;
      } else if (widget.part == 10) {
        _questions = _level5Part1KoreanQuestions;
      } else if (widget.part == 11) {
        _questions = _level5Part2KoreanQuestions;
      } else if (widget.part == 12) {
        _questions = _level5Part3KoreanQuestions;
      } else if (widget.part == 13) {
        _questions = _level6Part1KoreanQuestions;
      } else if (widget.part == 14) {
        _questions = _level6Part2KoreanQuestions;
      } else if (widget.part == 15) {
        _questions = _level6Part3KoreanQuestions;
      } else {
        _questions = _basicQuestions;
      }
    }

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Set initial progress for Q1
    _progressController.value = 1.0 / _questions.length;
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _onOptionTap(int index) {
    if (_hasChecked) return;
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _onLetterTap(int index) {
    if (_hasChecked) return;
    setState(() {
      if (_selectedArrangeIndices.contains(index)) {
        _selectedArrangeIndices.remove(index);
      } else {
        _selectedArrangeIndices.add(index);
      }
    });
  }

  String _combineLetters(List<String> letters) {
    if (letters.isEmpty) return '';
    final temp = letters.join('');

    // Multisyllable and custom arrange patterns
    if (temp == 'ㅎㅏㄷㅏ') return '하다';
    if (temp == 'ㄴㅏㄹㅏ') return '나라';
    if (temp == 'ㅇㅜㄹㅣ') return '우리';

    if (temp == 'ㅎㅏㄴ') return '한';
    if (temp == 'ㅎㅏㄱ') return '학';
    if (temp == 'ㅎㅏ') return '하';
    if (temp == 'ㅎ') return 'ㅎ';
    
    if (temp == 'ㄴㅏㄴ') return '난';
    if (temp == 'ㄴㅏㄱ') return '낙';
    if (temp == 'ㄴㅏ') return '나';
    if (temp == 'ㄴ') return 'ㄴ';
    
    if (temp == 'ㄱㅏㄴ') return '간';
    if (temp == 'ㄱㅏㄱ') return '각';
    if (temp == 'ㄱㅏ') return '가';
    if (temp == 'ㄱ') return 'ㄱ';

    if (letters.length == 1) {
      return letters[0];
    } else if (letters.length == 2) {
      final c = letters[0];
      final v = letters[1];
      if (c == 'ㅎ' && v == 'ㅏ') return '하';
      if (c == 'ㄴ' && v == 'ㅏ') return '나';
      if (c == 'ㄱ' && v == 'ㅏ') return '가';
      return letters.join('');
    } else if (letters.length >= 3) {
      final c = letters[0];
      final v = letters[1];
      final f = letters[2];
      if (c == 'ㅎ' && v == 'ㅏ') {
        if (f == 'ㄴ') return '한';
        if (f == 'ㄱ') return '학';
        return '하$f';
      }
      if (c == 'ㄴ' && v == 'ㅏ') {
        if (f == 'ㄴ') return '난';
        if (f == 'ㄱ') return '낙';
        return '나$f';
      }
      if (c == 'ㄱ' && v == 'ㅏ') {
        if (f == 'ㄴ') return '간';
        if (f == 'ㄱ') return '각';
        return '가$f';
      }
      return letters.join('');
    }
    return temp;
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedOptionIndex = null;
      _selectedArrangeIndices.clear();
      _hasChecked = false;
      _isAnswerCorrect = false;
      _hearts = 5;
      _correctCount = 0;
      _progressController.value = 1.0 / _questions.length;
    });
  }

  void _checkAnswer() {
    if (_hasChecked) return;

    final Map<String, dynamic> qData = _questions[_currentQuestionIndex];
    final bool isArrange = qData['type'] == 'arrange';

    bool isCorrect = false;
    if (isArrange) {
      if (_selectedArrangeIndices.isEmpty) return;
      final List<String> letters = _selectedArrangeIndices.map((idx) => qData['letters'][idx] as String).toList();
      final String constructed = _combineLetters(letters);
      isCorrect = constructed == qData['correctAnswer'];
    } else {
      if (_selectedOptionIndex == null) return;
      final int correctIndex = qData['correct'] as int;
      isCorrect = _selectedOptionIndex == correctIndex;
    }

    setState(() {
      _hasChecked = true;
      _isAnswerCorrect = isCorrect;
      if (isCorrect) {
        _correctCount++;
      } else {
        _hearts = math.max(0, _hearts - 1);
      }
    });
  }

  void _handleNextOrReset() {
    if (_hearts == 0) {
      // Navigate to failed screen
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => QuizFailedScreen(
            correctCount: _correctCount,
            totalQuestions: _questions.length,
            onRetry: _resetQuiz,
          ),
        ),
      );
      return;
    }

    // Go to next question or complete
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _selectedArrangeIndices.clear();
        _hasChecked = false;
      });
      // Animate progress to the new question
      final double targetProgress = (_currentQuestionIndex + 1) / _questions.length;
      _progressController.animateTo(targetProgress, curve: Curves.easeOut);
    } else {
      // Unlock next parts on the map
      if (widget.part == 1 && QuizProgress.unlockedPart == 2) {
        QuizProgress.setUnlockedPart(3);
      } else if (widget.part == 2 && QuizProgress.unlockedPart == 3) {
        QuizProgress.setUnlockedPart(4);
      } else if (widget.part == 5 && QuizProgress.unlockedPart == 4) {
        QuizProgress.setUnlockedPart(5); // Box 2 done — unlocks Box 3 Part 1
      } else if (widget.part == 7 && QuizProgress.unlockedPart == 5) {
        QuizProgress.setUnlockedPart(6);
      } else if (widget.part == 8 && QuizProgress.unlockedPart == 6) {
        QuizProgress.setUnlockedPart(7);
      } else if (widget.part == 9 && QuizProgress.unlockedPart == 7) {
        QuizProgress.setUnlockedPart(8); // Box 3 done — unlocks Box 4 Fun Fact
      } else if (widget.part == 10 && QuizProgress.unlockedPart == 9) {
        QuizProgress.setUnlockedPart(10);
      } else if (widget.part == 11 && QuizProgress.unlockedPart == 10) {
        QuizProgress.setUnlockedPart(11);
      } else if (widget.part == 12 && QuizProgress.unlockedPart == 11) {
        QuizProgress.setUnlockedPart(12); // Box 5 done — unlocks Box 6 Part 1
      } else if (widget.part == 13 && QuizProgress.unlockedPart == 12) {
        QuizProgress.setUnlockedPart(13);
      } else if (widget.part == 14 && QuizProgress.unlockedPart == 13) {
        QuizProgress.setUnlockedPart(14);
      } else if (widget.part == 15 && QuizProgress.unlockedPart == 14) {
        QuizProgress.setUnlockedPart(15); // Box 6 done — all completed!
      }

      // isLastPart = true hanya untuk part terakhir tiap box:
      // - Part 5 = Part 3 Box 2 (terakhir)
      // - Part 9 = Part 3 Box 3 (terakhir)
      // - Part 12 = Part 3 Box 5 (terakhir)
      // - Part 15 = Part 3 Box 6 (terakhir)
      final bool isLastPart = widget.part == 5 || widget.part == 9 || widget.part == 12 || widget.part == 15;

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => QuizCompletedScreen(
            part: widget.part,
            correctCount: _correctCount,
            totalQuestions: _questions.length,
            xpEarned: _correctCount * 4,
            isLastPart: isLastPart,
          ),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> qData = _questions[_currentQuestionIndex];
    final String currentQuestionText = qData['text'] as String;
    final MascotPose currentPose = qData['pose'] as MascotPose;

    final String? qType = qData['type'] as String?;
    final bool isArrange = qType == 'arrange';
    final bool isBlackboard = qType == 'blackboard';
    final bool isAudioChoice = qType == 'audio_choice';
    final bool isPronunciation = qType == 'pronunciation';
    final bool isReading = qType == 'reading';
    final bool isImageChoice = qType == 'image_choice';
    final bool isQ5 = qType == 'true_false' || (_currentQuestionIndex == _questions.length - 1);

    final List<String> currentOptions = !isArrange ? List<String>.from(qData['options'] ?? []) : [];

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Top Header Progress Bar ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.chevron_left_rounded, size: 30, color: AppColors.primaryText),
                      ),
                      const SizedBox(width: 8),
                      // Progress bar with floating star
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double trackWidth = constraints.maxWidth;
                            
                            return SizedBox(
                              height: 28, // Height to fit the floating star comfortably
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                clipBehavior: Clip.none,
                                children: [
                                  // Background bar track
                                  Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE7F8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // Active progress bar
                                  AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (context, child) {
                                      return FractionallySizedBox(
                                        widthFactor: _progressController.value,
                                        child: Container(
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPurple,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Yellow star at the end of the active bar
                                  AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (context, child) {
                                      final double progress = _progressController.value;
                                      const double starSize = 24.0;
                                      // Center the star horizontally at the right edge of the active progress
                                      final double leftPos = (trackWidth * progress) - (starSize / 2);
                                      
                                      return Positioned(
                                        left: leftPos,
                                        top: (28 - starSize) / 2, // Centered vertically
                                        child: SvgPicture.asset(
                                          'assets/ic_round-star.svg',
                                          width: starSize,
                                          height: starSize,
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFFFFCA28), // Bright gold yellow star
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Hearts indicator
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: Color(0xFFEF5350), // Solid red heart
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_hearts',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Question Title ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildQuestionTextWidget(currentQuestionText),
                  ),
                ),

                // ── Audio Choice Player Pill ──────────────────────────────
                if (isAudioChoice) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryPurple, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.volume_up_rounded, color: AppColors.primaryPurple, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            qData['audioWord'] as String? ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryPurple,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // ── Arrange Target ───────────────────────────────────────────
                if (isArrange) ...[
                  const SizedBox(height: 16),
                  Text(
                    '"${qData['target']}"',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],

                // ── Reading Word Target ──────────────────────────────────────
                if (isReading && qData['word'] != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    qData['word'] as String,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],

                // ── Mascot & Background Watermarks Graphic ────────────────────
                if (isArrange)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (!_hasChecked) {
                              setState(() {
                                _selectedArrangeIndices.clear();
                              });
                            }
                          },
                          child: Container(
                            height: 60,
                            alignment: Alignment.bottomCenter,
                            child: Builder(
                              builder: (context) {
                                final List<String> letters = _selectedArrangeIndices.map((idx) => qData['letters'][idx] as String).toList();
                                final String constructed = _combineLetters(letters);
                                return Text(
                                  constructed.isEmpty ? ' ' : constructed,
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryText,
                                    letterSpacing: 2,
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: screenWidth * 0.75,
                          height: 2.0,
                          color: const Color(0xFFE5E5EA),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                else if (isImageChoice)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildImageOptionCard(0, currentOptions[0], qData['optionImages'][0])),
                              const SizedBox(width: 14),
                              Expanded(child: _buildImageOptionCard(1, currentOptions[1], qData['optionImages'][1])),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(child: _buildImageOptionCard(2, currentOptions[2], qData['optionImages'][2])),
                              const SizedBox(width: 14),
                              Expanded(child: _buildImageOptionCard(3, currentOptions[3], qData['optionImages'][3])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Blackboard Background (Q1 / Complete the word)
                            if (isBlackboard)
                              Positioned(
                                top: 0,
                                right: 20,
                                child: Container(
                                  width: 170,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1135),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFF8B5E3C), width: 6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Builder(
                                      builder: (context) {
                                        if (qData.containsKey('boardText') && qData['boardText'] != null) {
                                          return Text(
                                            qData['boardText'] as String,
                                            style: const TextStyle(
                                              fontSize: 54, // larger for single characters like ㄴ
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                        String boardText = 'ㄱ----다';
                                        if (_selectedOptionIndex != null && qData['options'] != null && _selectedOptionIndex! < (qData['options'] as List).length) {
                                          final String vowel = qData['options'][_selectedOptionIndex!].toString();
                                          if (vowel == 'ㅏ') {
                                            boardText = '가다';
                                          } else if (vowel == 'ㅓ') {
                                            boardText = '거다';
                                          } else if (vowel == 'ㅜ') {
                                            boardText = '구다';
                                          } else if (vowel == 'ㅣ') {
                                            boardText = '기다';
                                          }
                                        }
                                        return Text(
                                          boardText,
                                          style: const TextStyle(
                                            fontSize: 38,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2,
                                          ),
                                        );
                                      }
                                    ),
                                  ),
                                ),
                              ),

                            // Q3 "Aa" or "?" Faint Watermark Background
                            if (isPronunciation || qData.containsKey('watermark'))
                              Positioned(
                                top: -20,
                                child: Text(
                                  qData['watermark'] as String? ?? 'Aa',
                                  style: TextStyle(
                                    fontSize: 160,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFFE4D9F6).withOpacity(0.24),
                                  ),
                                ),
                              ),

                            // Q5 Faint Floating Letters Background
                            if (isQ5) ...[
                              if (LanguagePreference.current == 'English') ...[
                                _buildFaintLetter('D', top: 10, left: 40, size: 40),
                                _buildFaintLetter('H', top: 50, right: 30, size: 32),
                                _buildFaintLetter('K', top: 20, right: 100, size: 40),
                                _buildFaintLetter('P', top: 110, left: 50, size: 36),
                                _buildFaintLetter('A', bottom: 30, left: 40, size: 44),
                                _buildFaintLetter('R', bottom: 80, right: 30, size: 38),
                                _buildFaintLetter('C', bottom: 120, left: 20, size: 34),
                                _buildFaintLetter('E', bottom: 10, right: 80, size: 32),
                              ] else ...[
                                _buildFaintLetter('ㄱ', top: 10, left: 40, size: 40),
                                _buildFaintLetter('ㄴ', top: 50, right: 30, size: 32),
                                _buildFaintLetter('ㄷ', bottom: 30, left: 40, size: 44),
                                _buildFaintLetter('ㄹ', bottom: 80, right: 30, size: 38),
                                _buildFaintLetter('ㅏ', top: 110, left: 50, size: 36),
                                _buildFaintLetter('ㅣ', top: 20, right: 100, size: 40),
                                _buildFaintLetter('ㅎ', bottom: 120, left: 20, size: 34),
                              ],
                            ],

                            // Cute Bat Mascot (floating and animated)
                            MascotWidget(
                              pose: currentPose,
                              size: 190,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Options Grid or Row Layout ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: isImageChoice
                      ? const SizedBox.shrink()
                      : isArrange
                      ? Builder(
                          builder: (context) {
                            final List<String> letters = List<String>.from(qData['letters'] ?? []);
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildArrangeOptionCard(0, letters.isNotEmpty ? letters[0] : '')),
                                    const SizedBox(width: 14),
                                    Expanded(child: _buildArrangeOptionCard(1, letters.length > 1 ? letters[1] : '')),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(child: _buildArrangeOptionCard(2, letters.length > 2 ? letters[2] : '')),
                                    const SizedBox(width: 14),
                                    Expanded(child: _buildArrangeOptionCard(3, letters.length > 3 ? letters[3] : '')),
                                  ],
                                ),
                              ],
                            );
                          }
                        )
                      : currentOptions.length == 2
                           ? Row(
                               children: [
                                 Expanded(child: _buildTrueFalseOptionCard(0, currentOptions[0])),
                                 const SizedBox(width: 16),
                                 Expanded(child: _buildTrueFalseOptionCard(1, currentOptions[1])),
                               ],
                             )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildOptionCard(0, currentOptions[0])),
                                    const SizedBox(width: 14),
                                    Expanded(child: _buildOptionCard(1, currentOptions[1])),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(child: _buildOptionCard(2, currentOptions[2])),
                                    const SizedBox(width: 14),
                                    Expanded(child: _buildOptionCard(3, currentOptions[3])),
                                  ],
                                ),
                              ],
                            ),
                ),

                // ── Check Answer Button ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Builder(
                      builder: (context) {
                        final bool isBtnEnabled = isArrange
                            ? _selectedArrangeIndices.isNotEmpty
                            : _selectedOptionIndex != null;

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFF3EEFB),
                            disabledForegroundColor: const Color(0xFFC8B6F9),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: isBtnEnabled && !_hasChecked ? _checkAnswer : null,
                          child: const Text(
                            'Check Answer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // ── BOTTOM SHEET DIALOG OVERLAY (Correct / Wrong) ────────────────
            if (_hasChecked) ...[
              GestureDetector(
                onTap: () {}, // absorb tap events
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                ),
              ),
              _buildBottomDialogOverlay(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFaintLetter(String char, {double? top, double? bottom, double? left, double? right, double size = 30}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Text(
        char,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFE4D9F6).withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildImageOptionCard(int index, String text, String imagePath) {
    final bool isSelected = _selectedOptionIndex == index;
    return GestureDetector(
      onTap: () => _onOptionTap(index),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : const Color(0xFFEDE7F8),
            width: isSelected ? 2.2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryPurple.withOpacity(0.12)
                  : AppColors.primaryPurple.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String text) {
    final bool isSelected = _selectedOptionIndex == index;
    return GestureDetector(
      onTap: () => _onOptionTap(index),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : const Color(0xFFEDE7F8),
            width: isSelected ? 2.2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryPurple.withOpacity(0.12)
                  : AppColors.primaryPurple.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArrangeOptionCard(int index, String letter) {
    if (letter.isEmpty) {
      return const SizedBox(height: 72);
    }
    final bool isSelected = _selectedArrangeIndices.contains(index);
    return GestureDetector(
      onTap: () => _onLetterTap(index),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F3FA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE4D9F6) : const Color(0xFFEDE7F8),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppColors.disableText : AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrueFalseOptionCard(int index, String text) {
    final bool isSelected = _selectedOptionIndex == index;
    return GestureDetector(
      onTap: () => _onOptionTap(index),
      child: Container(
        height: 64, // taller for true/false buttons
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : const Color(0xFFEDE7F8),
            width: isSelected ? 2.2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryPurple.withOpacity(0.12)
                  : AppColors.primaryPurple.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechBubble() {
    final Color iconColor = const Color(0xFF1C1135);
    final IconData iconData = _isAnswerCorrect ? Icons.check_rounded : Icons.close_rounded;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Speech Bubble Tail (drawn first so it is behind the circle)
        Positioned(
          left: -2,
          bottom: 2,
          child: Transform.rotate(
            angle: -0.7, // rotated to point down-left towards mascot
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Color(0xFF1C1135), width: 2.2),
                  bottom: BorderSide(color: Color(0xFF1C1135), width: 2.2),
                ),
              ),
            ),
          ),
        ),
        // Main Speech Bubble Circle (drawn second to overlay the tail)
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1C1135),
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              iconData,
              color: iconColor,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomDialogOverlay() {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOutQuad,
        )),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // White Dialog Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isAnswerCorrect ? 'Nice Answer !' : 'Wrong answer !',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _isAnswerCorrect ? const Color(0xFF58CC02) : const Color(0xFFEA2B2B),
                    ),
                  ),
                  if (!_isAnswerCorrect) ...[
                    const SizedBox(height: 6),
                    Builder(
                      builder: (context) {
                        final Map<String, dynamic> qData = _questions[_currentQuestionIndex];
                        final bool isArrange = qData['type'] == 'arrange';
                        final String correctAnswerText = isArrange
                            ? (qData['correctAnswer'] as String? ?? '')
                            : (qData['options'] != null && qData['correct'] != null
                                ? qData['options'][qData['correct'] as int].toString()
                                : '');
                        return Text(
                          'Correct answer: $correctAnswerText',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _handleNextOrReset,
                      child: Text(
                        _isAnswerCorrect
                            ? 'Next'
                            : (_hearts == 0 ? 'LIHAT HASIL' : 'Okay'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Mascot and speech bubble container overlapping the top border
            Positioned(
              top: -55,
              child: SizedBox(
                width: 150,
                height: 110,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    MascotWidget(
                      pose: _isAnswerCorrect ? MascotPose.success : MascotPose.fail,
                      size: 110,
                    ),
                    Positioned(
                      right: 12,
                      top: 5,
                      child: _buildSpeechBubble(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTextWidget(String text) {
    final List<InlineSpan> spans = [];
    
    // Match double quoted strings (straight/curly) or phonetic standalone target letters/digraphs
    final RegExp regex = RegExp(
      r'([“"][^”"]+[”"])|(\b(?:A|E|I|C|G|K|TH|PH|GH)\b)',
      caseSensitive: true,
    );

    int lastMatchEnd = 0;
    
    for (final RegExpMatch match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ));
      }
      
      final String matchedText = match.group(0)!;
      spans.add(TextSpan(
        text: matchedText,
        style: const TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.w900,
        ),
      ));
      
      lastMatchEnd = match.end;
    }
    
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.primaryText,
        height: 1.3,
      ),
    );
  }
}
