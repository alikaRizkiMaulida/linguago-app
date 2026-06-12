import 'package:linguago_flutter/core/constants/language_preference.dart';
import 'package:linguago_flutter/ui/widgets/mascot_widget.dart';

List<Map<String, dynamic>> getQuizQuestions(int part) {
  final bool isEnglish = LanguagePreference.current == 'English';
  if (isEnglish) {
    if (part == 2) return _listeningEnglishQuestions;
    if (part == 3) return _mixedEnglishQuestions;
    if (part == 5) return _finalEnglishQuestions;
    if (part >= 7 && part <= 9) return _getLevel3EnglishQuestions(part);
    if (part >= 10 && part <= 12) return _getLevel5EnglishQuestions(part);
    if (part >= 13 && part <= 15) return _getLevel6EnglishQuestions(part);
    return _basicEnglishQuestions;
  } else {
    if (part == 2) return _listeningQuestions;
    if (part == 3) return _mixedQuestions;
    if (part == 5) return _finalQuestions;
    if (part >= 7 && part <= 9) return _getLevel3KoreanQuestions(part);
    if (part >= 10 && part <= 12) return _getLevel5KoreanQuestions(part);
    if (part >= 13 && part <= 15) return _getLevel6KoreanQuestions(part);
    return _basicQuestions;
  }
}

// ── Basic Korean ──
const List<Map<String, dynamic>> _basicQuestions = [
  {
    'type': 'arrange', 'text': 'Arrange these letters into:', 'target': 'HAN',
    'letters': ['ㄴ', 'ㅏ', 'ㅎ', 'ㄱ'], 'correctAnswer': '한',
    'pose': MascotPose.reading,
  },
  {
    'type': 'reading', 'text': 'How do you read this word?', 'word': '가다',
    'options': ['Nara', 'Gada', 'Hane', 'Guri'], 'correct': 1,
    'pose': MascotPose.reading,
  },
  {
    'type': 'true_false', 'text': 'Hangul is the Korean alphabet system.',
    'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused,
  },
  {
    'type': 'pronunciation', 'text': 'Which Pronunciation letter has the sound "ㄷ"?',
    'options': ['Hieut', 'Gieok', 'Nieun', 'Digot'], 'correct': 3,
    'pose': MascotPose.confused,
  },
  {
    'type': 'blackboard', 'text': 'Complete the word:',
    'options': ['ㅓ', 'ㅏ', 'ㅜ', 'ㅣ'], 'correct': 1,
    'pose': MascotPose.teaching,
  },
];

const List<Map<String, dynamic>> _listeningQuestions = [
  {
    'type': 'blackboard', 'text': 'What is the sound of ㄴ?', 'boardText': 'ㄴ',
    'options': ['G', 'N', 'D', 'S'], 'correct': 1, 'pose': MascotPose.teaching,
  },
  {
    'type': 'audio_choice', 'text': 'Match the Hangul letter with the correct sound.',
    'audioWord': 'Shiot', 'options': ['ㄱ', 'ㄷ', 'ㅅ', 'ㅏ'], 'correct': 2,
    'pose': MascotPose.listening,
  },
  {
    'type': 'pronunciation', 'text': 'Which Hangul letter has the sound "A"?',
    'options': ['ㅏ', 'ㅐ', 'ㅓ', 'ㅣ'], 'correct': 0, 'pose': MascotPose.confused,
  },
  {
    'type': 'reading', 'text': 'How do you read this word?', 'word': '가다',
    'options': ['Nara', 'Gada', 'Hana', 'Guri'], 'correct': 1,
    'pose': MascotPose.reading,
  },
  {
    'type': 'reading', 'text': 'What does 한국어 mean?',
    'options': ['English language', 'Korean student', 'Korean teacher', 'Korean language'],
    'correct': 3, 'pose': MascotPose.reading, 'watermark': '?',
  },
];

// ── Basic English ──
const List<Map<String, dynamic>> _basicEnglishQuestions = [
  {
    'type': 'pronunciation', 'text': 'What is the common sound of the letter A in "Name"?',
    'options': ['Ah', 'Ey', 'Ee', 'Oh'], 'correct': 1, 'pose': MascotPose.confused,
    'watermark': 'Aa',
  },
  {
    'type': 'blackboard', 'text': 'Which word has the A sound like in "Can"?', 'boardText': 'CAN',
    'options': ['Care', 'Car', 'Bad', 'Name'], 'correct': 2, 'pose': MascotPose.teaching,
  },
  {
    'type': 'pronunciation', 'text': 'What sound can the letter "C" make?',
    'options': ['K/S', 'B/D', 'F/V', 'T/H'], 'correct': 0, 'pose': MascotPose.listening,
  },
  {
    'type': 'true_false', 'text': 'The letter C can sound like "S".',
    'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused,
  },
  {
    'type': 'pronunciation', 'text': 'Which word has a silent "K"?',
    'options': ['King', 'Kite', 'Kid', 'Know'], 'correct': 3, 'pose': MascotPose.reading,
  },
];

// ── Helper getters ──
List<Map<String, dynamic>> _getLevel3EnglishQuestions(int part) {
  const all = [_level3Part1EnglishQuestions, _level3Part2EnglishQuestions, _level3Part3EnglishQuestions];
  return all[part - 7];
}

List<Map<String, dynamic>> _getLevel3KoreanQuestions(int part) {
  const all = [_level3Part1KoreanQuestions, _level3Part2KoreanQuestions, _level3Part3KoreanQuestions];
  return all[part - 7];
}

List<Map<String, dynamic>> _getLevel5EnglishQuestions(int part) {
  const all = [_level5Part1EnglishQuestions, _level5Part2EnglishQuestions, _level5Part3EnglishQuestions];
  return all[part - 10];
}

List<Map<String, dynamic>> _getLevel5KoreanQuestions(int part) {
  const all = [_level5Part1KoreanQuestions, _level5Part2KoreanQuestions, _level5Part3KoreanQuestions];
  return all[part - 10];
}

List<Map<String, dynamic>> _getLevel6EnglishQuestions(int part) {
  const all = [_level6Part1EnglishQuestions, _level6Part2EnglishQuestions, _level6Part3EnglishQuestions];
  return all[part - 13];
}

List<Map<String, dynamic>> _getLevel6KoreanQuestions(int part) {
  const all = [_level6Part1KoreanQuestions, _level6Part2KoreanQuestions, _level6Part3KoreanQuestions];
  return all[part - 13];
}

// ── All question data (copied from original quiz_screen) ──

const List<Map<String, dynamic>> _mixedQuestions = [
  {'type': 'arrange', 'text': 'Arrange these letters into:', 'target': 'HADA', 'letters': ['ㄷ', 'ㅏ', 'ㅎ', 'ㅏ'], 'correctAnswer': '하다', 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'Complete the word to spell "NARA" (country):', 'options': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'reading', 'text': 'How do you read this word?', 'word': '우리', 'options': ['Nara', 'Uri', 'Guri', 'Hane'], 'correct': 1, 'pose': MascotPose.reading},
  {'type': 'pronunciation', 'text': 'Which Korean letter makes the sound "ㄴ"?', 'options': ['Nieun', 'Gieok', 'Digeut', 'Hieut'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'audio_choice', 'text': 'Match the sound "Annyeong":', 'audioWord': 'Annyeong', 'options': ['안녕', '안녕하세요', '가다', '나라'], 'correct': 0, 'pose': MascotPose.listening},
];

const List<Map<String, dynamic>> _finalQuestions = [
  {'type': 'arrange', 'text': 'Arrange these letters into:', 'target': 'HADA', 'letters': ['ㄷ', 'ㅏ', 'ㅎ', 'ㅏ'], 'correctAnswer': '하다', 'pose': MascotPose.reading},
  {'type': 'audio_choice', 'text': 'Match the sound "Annyeong":', 'audioWord': 'Annyeong', 'options': ['안녕', '안녕하세요', '가다', '나라'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'reading', 'text': 'How do you read this word?', 'word': '우리', 'options': ['Nara', 'Uri', 'Guri', 'Hane'], 'correct': 1, 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'Complete the word to spell "NARA" (country):', 'options': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The Korean alphabet system is called Hangul.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused},
];

const List<Map<String, dynamic>> _mixedEnglishQuestions = [
  {'type': 'arrange', 'text': 'Arrange these letters into:', 'target': 'NAME', 'letters': ['M', 'A', 'N', 'E'], 'correctAnswer': 'NAME', 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'Complete the spelling of "C_ty":', 'options': ['i', 'y', 'e', 'a'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'reading', 'text': 'How do you read the word "Time"?', 'options': ['Tym', 'Ta-im', 'Tee-me', 'Tim'], 'correct': 1, 'pose': MascotPose.reading},
  {'type': 'pronunciation', 'text': 'Which letter is silent in the word "Hour"?', 'options': ['H', 'O', 'U', 'R'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'audio_choice', 'text': 'Match the sound "Hello":', 'audioWord': 'Hello', 'options': ['Hello', 'Help', 'Hollow', 'Hero'], 'correct': 0, 'pose': MascotPose.listening},
];

const List<Map<String, dynamic>> _listeningEnglishQuestions = [
  {'type': 'blackboard', 'text': 'What is the sound of the letter I in "Like"?', 'boardText': 'Like', 'options': ['AY', 'IH', 'EE', 'EH'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'audio_choice', 'text': 'Match the word you hear with the correct spelling:', 'audioWord': 'See', 'options': ['See', 'Sea', 'She', 'Say'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which letter is silent in the word "Knee"?', 'options': ['K', 'N', 'E', 'None'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'reading', 'text': 'How do you read the word "Thought"?', 'options': ['Th-ot', 'T-out', 'Th-oh-gt', 'T-ot'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'reading', 'text': 'What does the word "School" mean?', 'options': ['Sekolah', 'Rumah', 'Kantor', 'Taman'], 'correct': 0, 'pose': MascotPose.reading, 'watermark': '?'},
];

const List<Map<String, dynamic>> _finalEnglishQuestions = [
  {'type': 'arrange', 'text': 'Arrange these letters into:', 'target': 'CARE', 'letters': ['R', 'A', 'E', 'C'], 'correctAnswer': 'CARE', 'pose': MascotPose.reading},
  {'type': 'audio_choice', 'text': 'Match the sound "Awesome":', 'audioWord': 'Awesome', 'options': ['Awesome', 'Awful', 'Somehow', 'Always'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'reading', 'text': 'How do you read the word "See"?', 'options': ['Se-e', 'Si', 'Say', 'She'], 'correct': 1, 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'Complete the word to spell "B_d" (tempat tidur):', 'options': ['e', 'a', 'o', 'u'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'In English, the letter C always sounds like "K".', 'options': ['True', 'False'], 'correct': 1, 'pose': MascotPose.confused},
];

// ── Level 3 English ──
const List<Map<String, dynamic>> _level3Part1EnglishQuestions = [
  {'type': 'pronunciation', 'text': 'What sound does "ph" make in "phone"?', 'options': ['P', 'F', 'H', 'B'], 'correct': 1, 'pose': MascotPose.confused, 'watermark': 'ph'},
  {'type': 'blackboard', 'text': 'Which word uses a silent "B"?', 'boardText': 'Silent B', 'options': ['Bat', 'Bomb', 'Best', 'Bear'], 'correct': 1, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'In English, "gh" is always silent.', 'options': ['True', 'False'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'reading', 'text': 'What does "enough" mean?', 'options': ['Cukup', 'Banyak', 'Sedikit', 'Kurang'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'pronunciation', 'text': 'Which word has the same vowel sound as "feet"?', 'options': ['Fit', 'Fat', 'Feat', 'Foul'], 'correct': 2, 'pose': MascotPose.reading},
];
const List<Map<String, dynamic>> _level3Part2EnglishQuestions = [
  {'type': 'audio_choice', 'text': 'What sound does the letter "G" make?', 'audioWord': 'Page', 'options': ['G', 'J', 'K', 'S'], 'correct': 1, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'How is "PH" usually pronounced?', 'options': ['P', 'H', 'F', 'V'], 'correct': 2, 'pose': MascotPose.confused, 'watermark': 'PH'},
  {'type': 'blackboard', 'text': 'Complete the word with the correct letter sound.', 'boardText': '_ag', 'options': ['S', 'B', 'V', 'G'], 'correct': 1, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'English letter "R" is pronounced strongly like Indonesian R.', 'options': ['True', 'False'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'audio_choice', 'text': 'Which word contains the "CH" sound?', 'audioWord': 'Chair', 'options': ['Chair', 'Car', 'Share', 'Care'], 'correct': 0, 'pose': MascotPose.listening},
];
const List<Map<String, dynamic>> _level3Part3EnglishQuestions = [
  {'type': 'pronunciation', 'text': 'Which word has the "SH" sound?', 'options': ['Show', 'Sun', 'Rose', 'Bag'], 'correct': 0, 'pose': MascotPose.confused, 'watermark': 'SH'},
  {'type': 'blackboard', 'text': 'Complete the word with the correct letter sound.', 'boardText': 'Kn_fe', 'options': ['i', 'e', 'a', 'u'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The letter Y can act as a vowel in English.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'audio_choice', 'text': 'Which word matches this sound?', 'audioWord': 'Night', 'options': ['Night', 'Neat', 'Note', 'Nail'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word has a silent "K"?', 'options': ['Know', 'Kick', 'King', 'Keep'], 'correct': 0, 'pose': MascotPose.confused, 'watermark': 'K'},
];

// ── Level 3 Korean ──
const List<Map<String, dynamic>> _level3Part1KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which Hangul character sounds like "R/L"?', 'options': ['ㄹ', 'ㄴ', 'ㅁ', 'ㄷ'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'reading', 'text': 'How do you read "학교"?', 'options': ['Hakgyo', 'Hangyo', 'Hakgo', 'Hanggo'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'true_false', 'text': '학교 means school in Korean.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'blackboard', 'text': 'What sound does ㅎ make?', 'boardText': 'ㅎ', 'options': ['H', 'P', 'F', 'S'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'reading', 'text': 'What does 선생님 mean?', 'options': ['Friend', 'Teacher', 'Student', 'School'], 'correct': 1, 'pose': MascotPose.reading},
];
const List<Map<String, dynamic>> _level3Part2KoreanQuestions = [
  {'type': 'audio_choice', 'text': 'Match the sound "Annyeong":', 'audioWord': 'Annyeong', 'options': ['안녕', '감사', '미안', '고마워'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'How is ㅈ usually pronounced?', 'options': ['Z', 'J', 'S', 'D'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'blackboard', 'text': 'What sound does ㅂ make?', 'boardText': 'ㅂ', 'options': ['B/P', 'M', 'V', 'F'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'ㅏ and ㅑ have the exact same vowel sound.', 'options': ['True', 'False'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'audio_choice', 'text': 'Match the sound "Saranghae":', 'audioWord': 'Saranghae', 'options': ['사랑해', '안녕하세요', '고마워요', '미안해요'], 'correct': 0, 'pose': MascotPose.listening},
];
const List<Map<String, dynamic>> _level3Part3KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which Hangul character sounds like "NG"?', 'options': ['ㅇ', 'ㄴ', 'ㄷ', 'ㄹ'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'blackboard', 'text': 'What sound does ㅊ make?', 'boardText': 'ㅊ', 'options': ['Ch', 'S', 'T', 'P'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': '친구 means "friend" in Korean.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'audio_choice', 'text': 'Match the sound "Saranghaeyo":', 'audioWord': 'Saranghaeyo', 'options': ['사랑해요', '감사합니다', '안녕하세요', '미안해요'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'arrange', 'text': 'Arrange these letters into:', 'target': 'NARA', 'letters': ['ㄴ', 'ㅏ', 'ㄹ', 'ㅏ'], 'correctAnswer': '나라', 'pose': MascotPose.reading},
];

// ── Level 5 English ──
const List<Map<String, dynamic>> _level5Part1EnglishQuestions = [
  {'type': 'blackboard', 'text': 'Which word has the "AI" sound?', 'boardText': 'AI', 'options': ['Bed', 'Sin', 'Run', 'Fine'], 'correct': 3, 'pose': MascotPose.teaching},
  {'type': 'pronunciation', 'text': 'What sound does "PH" make?', 'options': ['F', 'P', 'H', 'SH'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word contains a silent H?', 'options': ['Home', 'Happy', 'Hour', 'Hat'], 'correct': 2, 'pose': MascotPose.confused, 'watermark': 'Aa'},
  {'type': 'image_choice', 'text': 'Which word has the "z" sound?', 'options': ['Show', 'Rose', 'Sun', 'think'], 'optionImages': ['assets/stage_spotlight.png', 'assets/red_rose.png', 'assets/cartoon_sun.png', 'assets/stickman_thinking.png'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What is the pronunciation of the letter "V"?', 'options': ['Like F', 'Silent', 'Like B', 'using 👄 and 🦷'], 'correct': 3, 'pose': MascotPose.reading},
];
const List<Map<String, dynamic>> _level5Part2EnglishQuestions = [
  {'type': 'blackboard', 'text': 'Which word has the "EE" sound?', 'boardText': 'EE', 'options': ['Red', 'Meet', 'Cat', 'Dog'], 'correct': 1, 'pose': MascotPose.teaching},
  {'type': 'pronunciation', 'text': 'What sound does "CH" make?', 'options': ['Sh', 'K', 'Ch', 'S'], 'correct': 2, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word contains a silent W?', 'options': ['Write', 'Walk', 'Wet', 'Wind'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'Which word has the "SH" sound?', 'options': ['Fish', 'Sun', 'Star', 'Tree'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What is the pronunciation of the letter "G" in "Gently"?', 'options': ['Like G in "Go"', 'Like J', 'Silent', 'Like K'], 'correct': 1, 'pose': MascotPose.reading},
];
const List<Map<String, dynamic>> _level5Part3EnglishQuestions = [
  {'type': 'blackboard', 'text': 'Which word has the "OW" sound?', 'boardText': 'OW', 'options': ['Cow', 'Snow', 'Low', 'Row'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'pronunciation', 'text': 'What sound does "TH" make in "Think"?', 'options': ['F', 'S', 'T', 'Th'], 'correct': 3, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word contains a silent L?', 'options': ['Talk', 'Tall', 'Tell', 'Toll'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'Which word has the "F" sound?', 'options': ['Photo', 'Pen', 'Paper', 'Pencil'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What is the pronunciation of the letter "C" in "Circle"?', 'options': ['Like K', 'Like S', 'Like Sh', 'Silent'], 'correct': 1, 'pose': MascotPose.reading},
];

// ── Level 5 Korean ──
const List<Map<String, dynamic>> _level5Part1KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which character is the double consonant "ㄲ"?', 'options': ['ㄱ', 'ㅋ', 'ㄲ', 'ㄷ'], 'correct': 2, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What sound does "ㅗ" make?', 'options': ['O', 'U', 'A', 'E'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'blackboard', 'text': 'How do you write the syllable "Han"?', 'boardText': '한', 'options': ['한', '학', '하', '함'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'reading', 'text': 'How do you read "물"?', 'options': ['Mul', 'Bul', 'Sul', 'Kul'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'true_false', 'text': 'Is "Hangul" the name of the Korean alphabet?', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.success},
];
const List<Map<String, dynamic>> _level5Part2KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'What sound does "ㅐ" make?', 'options': ['Ae', 'E', 'Ya', 'Yo'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'reading', 'text': 'How do you read "밥"?', 'options': ['Bap', 'Bab', 'Pap', 'Mab'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'reading', 'text': 'Which word makes the sound "Sarang"?', 'options': ['사랑', '사람', '사탕', '사자'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'blackboard', 'text': 'Complete the word to spell "K-Pop":', 'boardText': '케이팝', 'options': ['팝', '요', '래', '막'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The consonant "ㅇ" has no sound when placed at the beginning of a syllable.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.confused},
];
const List<Map<String, dynamic>> _level5Part3KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which character is "ㅌ"?', 'options': ['ㄷ', 'ㅌ', 'ㄸ', 'ㅋ'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'reading', 'text': 'How do you read "한국"?', 'options': ['Hanguk', 'Hangul', 'Hangyo', 'Hangang'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'pronunciation', 'text': 'What sound does "ㅝ" make?', 'options': ['Wo', 'We', 'Wa', 'Wi'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'blackboard', 'text': 'Complete the spelling of "감사합니다" (Thank you):', 'boardText': '감사합니다', 'options': ['합', '함', '하', '밥'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The double consonant "ㅃ" is pronounced strongly.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.success},
];

// ── Level 6 English ──
const List<Map<String, dynamic>> _level6Part1EnglishQuestions = [
  {'type': 'pronunciation', 'text': 'Which word has a long E sound?', 'options': ['Bed', 'Bee', 'Run', 'Full'], 'correct': 1, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'What sound does "TH" make in "Think"?', 'options': ['T', 'D', 'TH', 'F'], 'correct': 2, 'pose': MascotPose.confused, 'watermark': 'Aa'},
  {'type': 'blackboard', 'text': 'Which word has the "OU" sound?', 'boardText': 'OU', 'options': ['Full', 'Sin', 'Cool', 'Rose'], 'correct': 2, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The letter "C" can sound like "CH".', 'options': ['True', 'False'], 'correct': 1, 'pose': MascotPose.confused},
  {'type': 'image_choice', 'text': 'Which word is pronounced with a silent K?', 'options': ['Kid', 'King', 'Knee', 'Kite'], 'optionImages': ['assets/cartoon_kid.png', 'assets/cartoon_king.png', 'assets/cartoon_knee.png', 'assets/cartoon_kite.png'], 'correct': 2, 'pose': MascotPose.confused},
];
const List<Map<String, dynamic>> _level6Part2EnglishQuestions = [
  {'type': 'blackboard', 'text': 'Which word has the "OI" sound?', 'boardText': 'OI', 'options': ['Coin', 'Cone', 'Can', 'Corn'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'pronunciation', 'text': 'What sound does "SH" make?', 'options': ['S', 'Sh', 'Ch', 'Z'], 'correct': 1, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word contains a silent W?', 'options': ['Write', 'Who', 'Wake', 'Wind'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'Which word has a soft G sound?', 'options': ['Giant', 'Game', 'Gate', 'Gold'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'true_false', 'text': 'Is the letter "L" silent in "Walk"?', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.success},
];
const List<Map<String, dynamic>> _level6Part3EnglishQuestions = [
  {'type': 'blackboard', 'text': 'Which word has the "AY" sound?', 'boardText': 'AY', 'options': ['Day', 'Dog', 'Dig', 'Den'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'pronunciation', 'text': 'What sound does "PH" make?', 'options': ['P', 'F', 'H', 'B'], 'correct': 1, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word contains a silent T?', 'options': ['Castle', 'Cat', 'Cold', 'Cart'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'Which word has a hard C sound?', 'options': ['Cat', 'City', 'Cell', 'Center'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'true_false', 'text': 'The word "Knight" has two silent letters.', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.success},
];

// ── Level 6 Korean ──
const List<Map<String, dynamic>> _level6Part1KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which double vowel represents the sound "We"?', 'options': ['ㅞ', 'ㅘ', 'ㅝ', 'ㅢ'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What is the pronunciation of "ㅂ" when it is at the bottom (batchim)?', 'options': ['P', 'B', 'M', 'N'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word contains the consonant "ㅋ"?', 'options': ['코', '고', '도', '로'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'How do you write the syllable "Guk"?', 'boardText': '국', 'options': ['국', '군', '물', '밥'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The character "ㅇ" has no sound when at the bottom of a syllable.', 'options': ['True', 'False'], 'correct': 1, 'pose': MascotPose.confused},
];
const List<Map<String, dynamic>> _level6Part2KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which character represents the double consonant "ㅃ"?', 'options': ['ㅃ', 'ㅂ', 'ㅍ', 'ㅁ'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What sound does "ㅢ" make when it\'s at the beginning of a word?', 'options': ['Ui', 'E', 'I', 'A'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word means "Water" in Korean?', 'options': ['물', '불', '풀', '줄'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'How do you write the syllable "Hyo"?', 'boardText': '효', 'options': ['효', '하', '허', '호'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'Is "Hangul" written from top to bottom and left to right?', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.success},
];
const List<Map<String, dynamic>> _level6Part3KoreanQuestions = [
  {'type': 'pronunciation', 'text': 'Which double vowel makes the sound "Wa"?', 'options': ['ㅘ', 'ㅝ', 'ㅚ', 'ㅟ'], 'correct': 0, 'pose': MascotPose.confused},
  {'type': 'pronunciation', 'text': 'What is the pronunciation of "ㄷ" when used as batchim?', 'options': ['T', 'D', 'N', 'L'], 'correct': 0, 'pose': MascotPose.listening},
  {'type': 'pronunciation', 'text': 'Which word means "Teacher" in Korean?', 'options': ['선생님', '학생', '친구', '학교'], 'correct': 0, 'pose': MascotPose.reading},
  {'type': 'blackboard', 'text': 'How do you write the syllable "Hap"?', 'boardText': '합', 'options': ['합', '한', '할', '함'], 'correct': 0, 'pose': MascotPose.teaching},
  {'type': 'true_false', 'text': 'The character "ㅎ" can sound silent in some words like "좋아".', 'options': ['True', 'False'], 'correct': 0, 'pose': MascotPose.success},
];
