import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final int part;
  const LessonDetailScreen({super.key, this.part = 1});

  // List global static untuk menyimpan data pelajaran yang di-save
  static final List<Map<String, dynamic>> savedLessonsData = [];

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  static const List<Map<String, dynamic>> _lessonDataKorea = [
    {
      'number': 1,
      'title': 'Basic Hangul',
      'desc': 'Learn how to greet and introduce yourself in Korean.',
      'ytId': 'hsLzVlK9odM',
      'badge': 'Kelas Bahasa Korea #1',
    },
    {
      'number': 2,
      'title': 'Listening Practice',
      'desc': 'Practice listening to Korean vowels and consonant combinations.',
      'ytId': 'sK42kCo2s7o',
      'badge': 'Kelas Bahasa Korea #2',
    },
    {
      'number': 3,
      'title': 'Korean Grammar',
      'desc': 'Understand the basic sentence patterns and particles in Korean.',
      'ytId': 'y15m4V_g6a8',
      'badge': 'Kelas Bahasa Korea #3',
    },
  ];

  static const List<Map<String, dynamic>> _lessonDataEnglish = [
    {
      'number': 1,
      'title': 'Basic Phonics',
      'desc': 'Learn basic English vowels, consonants, and short sounds.',
      'ytId': '723QdG9wO8Q',
      'badge': 'English Class #1',
    },
    {
      'number': 2,
      'title': 'English Listening',
      'desc': 'Practice listening to English word sounds and spelling patterns.',
      'ytId': '723QdG9wO8Q',
      'badge': 'English Class #2',
    },
    {
      'number': 3,
      'title': 'English Grammar',
      'desc': 'Understand basic English sentence structure and pronouns.',
      'ytId': 'y15m4V_g6a8',
      'badge': 'English Class #3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isKorea = QuizProgress.learningLanguage == 'Korea';
    final dataList = isKorea ? _lessonDataKorea : _lessonDataEnglish;
    final data = dataList[(widget.part - 1).clamp(0, 2)];

    // Cek apakah pelajaran ini sudah ada di dalam list savedLessonsData
    final bool isSaved = LessonDetailScreen.savedLessonsData.any(
      (element) => element['title'] == data['title'] && element['ytId'] == data['ytId'],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar / Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 30),
                    color: AppColors.primaryText,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEFB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Lesson ${data['number']}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── YouTube Video Player Container ──────────────────────────
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            'https://img.youtube.com/vi/${data['ytId']}/hqdefault.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF1C1135),
                                child: const Center(
                                  child: Icon(
                                    Icons.video_library_rounded,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            color: Colors.black.withValues(alpha: 0.12),
                          ),
                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.primaryPurple,
                                size: 36,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                data['badge'] as String,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ── Title & Description Row ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 🌟 LOGIKA TOMBOL BOOKMARK (SAVE/UNSAVE)
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: isSaved ? AppColors.primaryPurple : AppColors.primaryText,
                            size: 26,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSaved) {
                                // Jika sudah di-save, hapus dari list
                                LessonDetailScreen.savedLessonsData.removeWhere(
                                  (element) => element['title'] == data['title'] && element['ytId'] == data['ytId'],
                                );
                              } else {
                                // Jika belum di-save, masukkan ke list
                                LessonDetailScreen.savedLessonsData.add(data);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Metadata Pill Indicators ──────────────────────────────
                    Row(
                      children: [
                        _buildMetaItem(Icons.access_time_rounded, '10m 15s'),
                        const SizedBox(width: 12),
                        _buildMetaItem(Icons.signal_cellular_alt_rounded, 'Beginner'),
                        const SizedBox(width: 12),
                        _buildMetaItem(null, '+20 XP', svgAsset: 'assets/Vector 46.svg', color: const Color(0xFFFFB300)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Lesson Summary Card Container ───────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lesson Summary',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isKorea
                                ? 'In this lesson, the speaker introduces Hangul, the Korean writing system made up of:\n'
                                  ' • Konsonan (contoh: ㄱ, ㄴ, ㄷ)\n'
                                  ' • Vokal (contoh: ㅏ, ㅓ, ㅣ)\n\n'
                                  'The lesson explains that Hangul is not as difficult as it looks because its pronunciation system is quite similar to Indonesian phonetics.'
                                : 'In this lesson, the speaker introduces English alphabet phonics, the writing system made up of:\n'
                                  ' • Consonants (e.g. B, C, D)\n'
                                  ' • Vowels (e.g. A, E, I)\n\n'
                                  'The lesson explains that English phonics is the foundation for reading and spelling words correctly.',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.secondaryText,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Key Points :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isKorea) ...[
                            _buildBulletPoint('Hangul is the Korean alphabet system'),
                            _buildBulletPoint('Learning starts by recognizing letter sounds'),
                            _buildBulletPoint('Korean letters combine to form syllables'),
                            _buildBulletPoint('Syllables create words and sentences'),
                            _buildBulletPoint('The key to learning Hangul is understanding patterns and practicing reading'),
                          ] else ...[
                            _buildBulletPoint('English uses the 26-letter Latin alphabet'),
                            _buildBulletPoint('Learning starts by recognizing short vowel and consonant sounds'),
                            _buildBulletPoint('Letters combine to form basic words'),
                            _buildBulletPoint('Understanding phonics helps in fluent reading and spelling'),
                            _buildBulletPoint('The key is practicing sounds regularly'),
                          ],
                          const SizedBox(height: 20),
                          Text(
                            isKorea ? '4 Steps to Learn Hangul:' : '4 Steps to Learn English:',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildStepItem('1', isKorea ? 'Learn\nconsonants &\nvowels' : 'Learn\nvowels &\nconsonants')),
                              Expanded(child: _buildStepItem('2', isKorea ? 'Read\nsyllables' : 'Read\nshort words')),
                              Expanded(child: _buildStepItem('3', isKorea ? 'Read\nvocabulary\nwords' : 'Read\ndaily vocab\nwords')),
                              Expanded(child: _buildStepItem('4', isKorea ? 'Read simple\nsentences' : 'Read simple\nsentences')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Bottom Start Lesson/Quiz Button ───────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          if (QuizProgress.unlockedPart == widget.part) {
                            QuizProgress.setUnlockedPart(widget.part + 1);
                          }
                          int quizPart = widget.part;
                          if (widget.part == 3) {
                            quizPart = 5;
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(builder: (_) => QuizScreen(part: quizPart)),
                          );
                        },
                        child: const Text(
                          'Start Quiz',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Tetap pertahankan fungsi helper _buildMetaItem, _buildBulletPoint, dan _buildStepItem milikmu di bawah sini)
  Widget _buildMetaItem(IconData? icon, String text, {String? svgAsset, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgAsset != null)
          SvgPicture.asset(
            svgAsset,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(color ?? AppColors.primaryPurple, BlendMode.srcIn),
          )
        else if (icon != null)
          Icon(icon, size: 14, color: color ?? AppColors.primaryPurple),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryText)),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryText)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10.5, color: AppColors.secondaryText, height: 1.35))),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String label) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(color: Color(0xFFF3EEFB), shape: BoxShape.circle),
          child: Center(child: Text(number, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryPurple))),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: AppColors.primaryText, height: 1.3)),
      ],
    );
  }
}