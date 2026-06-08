import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
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
      'type': 'audio_choice',
      'text': 'Which word did you think you heard?',
      'audioWord': 'Hada',
      'options': ['하다', '한국어', '한', '나라'],
      'correct': 0, // "하다"
      'pose': MascotPose.listening,
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
    {
      'type': 'true_false',
      'text': 'Hangul is the Korean alphabet system.',
      'options': ['True', 'False'],
      'correct': 0, // 'True'
      'pose': MascotPose.confused,
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
      'type': 'pronunciation',
      'text': 'Which letter has the sound "E"?',
      'options': ['l', 'ㅔ', 'ㅏ', 'ㅜ'],
      'correct': 1,
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'What is the sound of ㄱ?',
      'boardText': 'ㄱ',
      'options': ['N', 'D', 'G', 'S'],
      'correct': 2,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'audio_choice',
      'text': 'Which word did you think you heard?',
      'audioWord': 'Hieut',
      'options': ['ㅖ', 'ㄱ', 'ㅅ', 'ㅎ'],
      'correct': 3,
      'pose': MascotPose.listening,
    },
    {
      'type': 'translation_large_cards',
      'text': 'What is the Korean word for\n',
      'targetWord': '"to go"?',
      'options': [
        {'hangul': '구다', 'roman': 'Guda'},
        {'hangul': '게다', 'roman': 'Geda'},
        {'hangul': '기다', 'roman': 'Gida'},
        {'hangul': '가다', 'roman': 'Gada'},
      ],
      'correct': 3,
      'pose': MascotPose.reading, // Not shown
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': '한',
      'options': ['Han', 'Hin', 'Hun', 'Hon'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'translation_large_cards',
      'text': 'What does\n',
      'targetWord': '나는 한국어를 배워요',
      'postTargetWord': ' mean?',
      'options': [
        {'imageAsset': 'assets/quiz_img_1.png', 'text': 'I like Korean\nlanguage'},
        {'imageAsset': 'assets/quiz_img_2.png', 'text': 'Korean\nLanguage'},
        {'imageAsset': 'assets/quiz_img_3.png', 'text': 'I come from\nKorea'},
        {'imageAsset': 'assets/quiz_img_4.png', 'text': 'I am learning\nKorean'},
      ],
      'correct': 3,
      'pose': MascotPose.reading, // Not shown
    },
    {
      'type': 'blackboard',
      'text': 'What is the name of the :',
      'boardText': 'Korean alphabet\nsystem?',
      'boardTextSize': 16.0,
      'options': ['Hiragana', 'Hangul', 'Hangul-eo', 'Hanguk'],
      'correct': 1,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the Hangul letter with its sound.',
      'audioWord': 'Nieun-Digot-Shiot',
      'options': ['ㄴ-ㄱ-ㅅ', 'ㄱ-ㅅ-ㄴ', 'ㄴ-ㄷ-ㅅ', 'ㅅ-ㄴ-ㄷ'],
      'correct': 2,
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which letter has the sound "I"?',
      'options': ['ㅔ', 'ㅏ', 'ㅜ', 'ㅣ'],
      'correct': 3,
      'pose': MascotPose.confused,
    },
  ];

  static const List<Map<String, dynamic>> _basicQuestionsEnglish = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'CAT',
      'letters': ['C', 'T', 'A', 'P'],
      'correctAnswer': 'CAT',
      'pose': MascotPose.reading,
    },
    {
      'type': 'audio_choice',
      'text': 'Which word did you think you heard?',
      'audioWord': 'Apple',
      'options': ['Apple', 'Banana', 'Cat', 'Dog'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': 'HELLO',
      'options': ['Selamat Pagi', 'Halo / Hai', 'Terima Kasih', 'Selamat Tinggal'],
      'correct': 1,
      'pose': MascotPose.reading,
    },
    {
      'type': 'true_false',
      'text': 'The English alphabet has 26 letters.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
    {
      'type': 'pronunciation',
      'text': 'Which letter makes the sound /f/?',
      'options': ['P', 'F', 'T', 'H'],
      'correct': 1,
      'pose': MascotPose.confused,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word "B_G" (large):',
      'options': ['I', 'O', 'U', 'E'],
      'correct': 0,
      'pose': MascotPose.teaching,
    },
  ];

  static const List<Map<String, dynamic>> _listeningQuestionsEnglish = [
    {
      'type': 'blackboard',
      'text': 'What is the short sound of letter A?',
      'boardText': 'A',
      'options': ['/ey/', '/ah/', '/ih/', '/oh/'],
      'correct': 1,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the word with sound "Sun":',
      'audioWord': 'Sun',
      'options': ['Son', 'Sun', 'Sin', 'Run'],
      'correct': 1,
      'pose': MascotPose.listening,
    },
    {
      'type': 'pronunciation',
      'text': 'Which English vowel makes the sound /i/ in "pin"?',
      'options': ['A', 'E', 'I', 'O'],
      'correct': 2,
      'pose': MascotPose.confused,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': 'DOG',
      'options': ['Anjing', 'Kucing', 'Kelinci', 'Burung'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'reading',
      'text': 'What does "English language" mean?',
      'options': ['Bahasa Inggris', 'Bahasa Korea', 'Bahasa Indonesia', 'Bahasa Jerman'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'true_false',
      'text': 'The word "cat" is a noun.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
  ];

  static const List<Map<String, dynamic>> _mixedQuestionsEnglish = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'DOG',
      'letters': ['D', 'O', 'G', 'T'],
      'correctAnswer': 'DOG',
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word to spell "HOME" (rumah):',
      'options': ['A', 'E', 'I', 'O'],
      'correct': 3,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': 'BOOK',
      'options': ['Buku', 'Pena', 'Meja', 'Kursi'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'pronunciation',
      'text': 'Which letter blend makes the /sh/ sound?',
      'options': ['CH', 'SH', 'TH', 'PH'],
      'correct': 1,
      'pose': MascotPose.confused,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Welcome":',
      'audioWord': 'Welcome',
      'options': ['Selamat Datang', 'Selamat Jalan', 'Selamat Pagi', 'Halo'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
  ];

  static const List<Map<String, dynamic>> _finalQuestionsEnglish = [
    {
      'type': 'arrange',
      'text': 'Arrange these letters into:',
      'target': 'BOOK',
      'letters': ['B', 'O', 'O', 'K'],
      'correctAnswer': 'BOOK',
      'pose': MascotPose.reading,
    },
    {
      'type': 'audio_choice',
      'text': 'Match the sound "Welcome":',
      'audioWord': 'Welcome',
      'options': ['Selamat Datang', 'Selamat Jalan', 'Selamat Pagi', 'Halo'],
      'correct': 0,
      'pose': MascotPose.listening,
    },
    {
      'type': 'reading',
      'text': 'How do you read this word?',
      'word': 'SCHOOL',
      'options': ['Sekolah', 'Rumah', 'Taman', 'Pasar'],
      'correct': 0,
      'pose': MascotPose.reading,
    },
    {
      'type': 'blackboard',
      'text': 'Complete the word to spell "GOOD" (baik):',
      'options': ['A', 'O', 'E', 'U'],
      'correct': 1,
      'pose': MascotPose.teaching,
    },
    {
      'type': 'true_false',
      'text': 'The word "play" is a verb.',
      'options': ['True', 'False'],
      'correct': 0,
      'pose': MascotPose.confused,
    },
  ];

  @override
  void initState() {
    super.initState();

    final bool isKorea = QuizProgress.learningLanguage == 'Korea';

    if (widget.part == 2) {
      _questions = isKorea ? _listeningQuestions : _listeningQuestionsEnglish;
    } else if (widget.part == 3) {
      _questions = isKorea ? _mixedQuestions : _mixedQuestionsEnglish;
    } else if (widget.part == 5) {
      _questions = isKorea ? _finalQuestions : _finalQuestionsEnglish;
    } else {
      _questions = isKorea ? _basicQuestions : _basicQuestionsEnglish;
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
    
    if (QuizProgress.learningLanguage == 'English') {
      return letters.join('').toUpperCase();
    }
    
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
      } else if (widget.part == 5 && QuizProgress.unlockedPart == 5) {
        QuizProgress.setUnlockedPart(6);
      }

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => QuizCompletedScreen(
            part: widget.part,
            correctCount: _correctCount,
            totalQuestions: _questions.length,
            xpEarned: _correctCount * 4,
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
    final bool isTranslationLargeCards = qType == 'translation_large_cards';
    final bool isQ5 = qType == 'true_false' || (_currentQuestionIndex == _questions.length - 1 && !isTranslationLargeCards);

    final List<dynamic> currentOptionsRaw = !isArrange ? (qData['options'] ?? []) : [];
    final List<String> currentOptions = !isArrange && !isTranslationLargeCards 
        ? List<String>.from(currentOptionsRaw) 
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
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
                    child: RichText(
                      text: TextSpan(
                        text: currentQuestionText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                          fontFamily: 'Nunito',
                        ),
                        children: [
                          if (qData['targetWord'] != null)
                            TextSpan(
                              text: qData['targetWord'] as String,
                              style: const TextStyle(
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          if (qData['postTargetWord'] != null)
                            TextSpan(
                              text: qData['postTargetWord'] as String,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                              ),
                            ),
                        ],
                      ),
                    ),
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
                      ],
                    ),
                  )
                else if (isTranslationLargeCards)
                  const SizedBox(height: 8) // No mascot for this type
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
                                        color: Colors.black.withValues(alpha: 0.08),
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
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: qData['boardTextSize'] != null ? (qData['boardTextSize'] as double) : 54, // larger for single characters like ㄴ
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
                                    color: const Color(0xFFE4D9F6).withValues(alpha: 0.24),
                                  ),
                                ),
                              ),

                            // Q5 Faint Floating Korean Letters Background
                            if (isQ5) ...[
                              _buildFaintLetter('ㄱ', top: 10, left: 40, size: 40),
                              _buildFaintLetter('ㄴ', top: 50, right: 30, size: 32),
                              _buildFaintLetter('ㄷ', bottom: 30, left: 40, size: 44),
                              _buildFaintLetter('ㄹ', bottom: 80, right: 30, size: 38),
                              _buildFaintLetter('ㅏ', top: 110, left: 50, size: 36),
                              _buildFaintLetter('ㅣ', top: 20, right: 100, size: 40),
                              _buildFaintLetter('ㅎ', bottom: 120, left: 20, size: 34),
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
                if (isTranslationLargeCards)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Builder(
                        builder: (context) {
                          Widget buildLargeOptionCard(int index, Map<String, String> optionData) {
                            final bool isSelected = _selectedOptionIndex == index;
                            final bool isCorrect = _hasChecked && (qData['correct'] == index);
                            final bool isWrongSelected = _hasChecked && isSelected && !isCorrect;

                            Color borderColor = AppColors.disableBorder;
                            Color bgColor = Colors.white;

                            if (isSelected) {
                              borderColor = AppColors.primaryPurple;
                              bgColor = Colors.white;
                            }
                            if (_hasChecked) {
                              if (isCorrect) {
                                borderColor = const Color(0xFF58CC02);
                                bgColor = const Color(0xFF58CC02).withValues(alpha: 0.1);
                              } else if (isWrongSelected) {
                                borderColor = const Color(0xFFEA2B2B);
                                bgColor = const Color(0xFFEA2B2B).withValues(alpha: 0.1);
                              } else {
                                borderColor = AppColors.disableBorder;
                                bgColor = Colors.white;
                              }
                            }

                            return GestureDetector(
                              onTap: () => _onOptionTap(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: borderColor, width: 2.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryPurple.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (optionData.containsKey('imageAsset')) ...[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 12.0),
                                          child: Image.asset(
                                            optionData['imageAsset']!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          optionData['text']!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ),
                                    ] else if (optionData.containsKey('svgAsset')) ...[
                                      Expanded(
                                        child: Center(
                                          child: SvgPicture.asset(
                                            optionData['svgAsset']!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Text(
                                        optionData['hangul']!,
                                        style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        optionData['roman']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            );
                          }

                          final options = List<Map<String, String>>.from(
                            (qData['options'] as List).map((e) => Map<String, String>.from(e as Map))
                          );

                          return Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(child: buildLargeOptionCard(0, options[0])),
                                    const SizedBox(width: 16),
                                    Expanded(child: buildLargeOptionCard(1, options[1])),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(child: buildLargeOptionCard(2, options[2])),
                                    const SizedBox(width: 16),
                                    Expanded(child: buildLargeOptionCard(3, options[3])),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: isArrange
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
                  color: Colors.black.withValues(alpha: 0.35),
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
          color: const Color(0xFFE4D9F6).withValues(alpha: 0.3),
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
                  ? AppColors.primaryPurple.withValues(alpha: 0.12)
                  : AppColors.primaryPurple.withValues(alpha: 0.04),
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
                    color: AppColors.primaryPurple.withValues(alpha: 0.04),
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
                  ? AppColors.primaryPurple.withValues(alpha: 0.12)
                  : AppColors.primaryPurple.withValues(alpha: 0.04),
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
    final Color iconColor = _isAnswerCorrect ? const Color(0xFF58CC02) : const Color(0xFFEA2B2B);
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
                color: Colors.black.withValues(alpha: 0.06),
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
      bottom: 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOutQuad,
        )),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: 160,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -15,
                        child: MascotWidget(
                          pose: _isAnswerCorrect ? MascotPose.success : MascotPose.fail,
                          size: 110,
                        ),
                      ),
                      // Speech Bubble next to the mascot
                      Positioned(
                        left: 95,
                        top: -10,
                        child: _buildSpeechBubble(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
      ),
    );
  }
}
