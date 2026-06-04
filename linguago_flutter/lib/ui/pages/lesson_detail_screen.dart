import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_screen.dart';

class LessonDetailScreen extends StatelessWidget {
  final int part;
  const LessonDetailScreen({super.key, this.part = 1});

  static const List<Map<String, dynamic>> _lessonData = [
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

  @override
  Widget build(BuildContext context) {
    final data = _lessonData[(part - 1).clamp(0, 2)];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF), // matching the #FBF9FF background
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
                  // Lesson pill
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
                  // Title text
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
                            color: AppColors.primaryPurple.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Video Thumbnail
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
                          // Dark Overlay for contrast
                          Container(
                            color: Colors.black.withOpacity(0.12),
                          ),
                          // Play Button Overlay
                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
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
                          // "Kelas Bahasa Korea #1" Badge overlay
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
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
                        // Bookmark button
                        IconButton(
                          icon: const Icon(
                            Icons.bookmark_border_rounded,
                            color: AppColors.primaryText,
                            size: 26,
                          ),
                          onPressed: () {},
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
                            color: AppColors.primaryPurple.withOpacity(0.04),
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
                          const Text(
                            'In this lesson, the speaker introduces Hangul, the Korean writing system made up of:\n'
                            ' • Konsonan (contoh: ㄱ, ㄴ, ㄷ)\n'
                            ' • Vokal (contoh: ㅏ, ㅓ, ㅣ)\n\n'
                            'The lesson explains that Hangul is not as difficult as it looks because its pronunciation system is quite similar to Indonesian phonetics.',
                            style: TextStyle(
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
                          _buildBulletPoint('Hangul is the Korean alphabet system'),
                          _buildBulletPoint('Learning starts by recognizing letter sounds'),
                          _buildBulletPoint('Korean letters combine to form syllables'),
                          _buildBulletPoint('Syllables create words and sentences'),
                          _buildBulletPoint('The key to learning Hangul is understanding patterns and practicing reading'),
                          const SizedBox(height: 20),

                          const Text(
                            '4 Steps to Learn Hangul:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── 4 Steps Columns ──────────────────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildStepItem('1', 'Learn\nconsonants &\nvowels')),
                              Expanded(child: _buildStepItem('2', 'Read\nsyllables')),
                              Expanded(child: _buildStepItem('3', 'Read\nvocabulary\nwords')),
                              Expanded(child: _buildStepItem('4', 'Read simple\nsentences')),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Navigate directly to Quiz Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => QuizScreen(part: part),
                            ),
                          );
                        },
                        child: const Text(
                          'Start Quiz!',
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

  Widget _buildMetaItem(IconData? icon, String text, {String? svgAsset, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgAsset != null)
          SvgPicture.asset(
            svgAsset,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(
              color ?? AppColors.primaryPurple,
              BlendMode.srcIn,
            ),
          )
        else if (icon != null)
          Icon(
            icon,
            size: 14,
            color: color ?? AppColors.primaryPurple,
          ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.secondaryText,
                height: 1.35,
              ),
            ),
          ),
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
          decoration: const BoxDecoration(
            color: Color(0xFFF3EEFB),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
