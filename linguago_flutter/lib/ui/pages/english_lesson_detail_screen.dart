import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';

/// Lesson Detail Screen for English.
/// Shown when user taps the first node on the English course map.
class EnglishLessonDetailScreen extends StatelessWidget {
  final int part;
  const EnglishLessonDetailScreen({super.key, this.part = 1});

  static const List<Map<String, dynamic>> _lessonData = [
    {
      'number': 1,
      'title': 'English Alphabet Sound',
      'desc':
          'Learn how English letters sound and how pronunciation changes in different words.',
      'duration': '15m 9s',
      'badge': 'English Pronunciation',
      'thumbnail_label': 'ENGLISH PRONUNCIATION',
      'thumbnail_sub': 'Untuk Pemula!\nPengucapan\nHURUF\nBahasa Inggris',
    },
    {
      'number': 2,
      'title': 'English Listening Practice',
      'desc':
          'Practice listening to English vowel and consonant combinations.',
      'duration': '12m 30s',
      'badge': 'English Practice',
      'thumbnail_label': 'ENGLISH LISTENING',
      'thumbnail_sub': 'Latihan\nMendengar\nBahasa Inggris',
    },
    {
      'number': 3,
      'title': 'English Grammar Basics',
      'desc':
          'Understand the basic sentence patterns in English.',
      'duration': '18m 0s',
      'badge': 'English Grammar',
      'thumbnail_label': 'ENGLISH GRAMMAR',
      'thumbnail_sub': 'Dasar\nTata Bahasa\nInggris',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = _lessonData[(part - 1).clamp(0, 2)];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────────────
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Lesson ${data['number']}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3B5BDB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data['badge'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Thumbnail Card ────────────────────────────────────────
                    _EnglishThumbnailCard(data: data),
                    const SizedBox(height: 18),

                    // ── Title + Bookmark ──────────────────────────────────────
                    Row(
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

                    // ── Metadata chips ────────────────────────────────────────
                    Row(
                      children: [
                        _buildMetaItem(Icons.access_time_rounded,
                            data['duration'] as String),
                        const SizedBox(width: 12),
                        _buildMetaItem(
                            Icons.signal_cellular_alt_rounded, 'Beginner'),
                        const SizedBox(width: 12),
                        _buildMetaItem(null, '+20 XP',
                            svgAsset: 'assets/Vector 46.svg',
                            color: const Color(0xFFFFB300)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Lesson Summary Card ───────────────────────────────────
                    _card(
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
                          const SizedBox(height: 6),
                          const Text(
                            'Main Topic:',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3B5BDB),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'English letters can have different sounds depending on the word and letter combination.\n\n'
                            'Learning pronunciation patterns will help you speak English more naturally.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.secondaryText,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Vowel Sounds Card ─────────────────────────────────────
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vowel Sounds',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The letter A can sound different :',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 8),
                          _SoundTable(rows: const [
                            ['Sound', 'Example'],
                            ['EY', 'Name'],
                            ['A', 'Car'],
                            ['EH', 'Care'],
                            ['Æ', 'Can, Bad'],
                          ], isHeader: [true, false, false, false, false]),
                          const SizedBox(height: 14),
                          const Text(
                            'The letter E can be pronounced as :',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 8),
                          _SoundTable(rows: const [
                            ['Sound', 'Example'],
                            ['IY', 'See, Tree'],
                            ['EH', 'Bed, Red'],
                            ['Silent', 'Love, Have'],
                          ], isHeader: [true, false, false, false]),
                          const SizedBox(height: 14),
                          const Text(
                            'The letter I can be pronounced as :',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 8),
                          _SoundTable(rows: const [
                            ['Sound', 'Example'],
                            ['AY', 'Like, Time'],
                            ['IH', 'Sit, Hit'],
                          ], isHeader: [true, false, false]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Consonant Sounds Card ─────────────────────────────────
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consonant Sounds',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Some consonants have unique sounds in English :',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 8),
                          _SoundTable(rows: const [
                            ['Letter', 'Sound', 'Example'],
                            ['C', 'K / S', 'Cat / City'],
                            ['G', 'G / J', 'Go / Gym'],
                            ['TH', 'Θ / Ð', 'Think / This'],
                            ['PH', 'F', 'Phone, Photo'],
                            ['GH', 'F / Silent', 'Laugh / Night'],
                          ], isHeader: [true, false, false, false, false, false]),
                          const SizedBox(height: 14),

                          // Key Points
                          const Text(
                            'Key Points :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _bulletPoint(
                              'English has 26 letters but 44 different sounds'),
                          _bulletPoint(
                              'Vowels can have multiple pronunciations'),
                          _bulletPoint(
                              'Context determines the correct pronunciation'),
                          _bulletPoint(
                              'Silent letters are common in English words'),
                          _bulletPoint(
                              'Practice with real words improves pronunciation'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Complete Lesson Button ────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B5BDB),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          if (QuizProgress.unlockedPart == 1) {
                            QuizProgress.setUnlockedPart(2);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Complete Lesson',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B5BDB).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildMetaItem(IconData? icon, String text,
      {String? svgAsset, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgAsset != null)
          SvgPicture.asset(svgAsset,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                color ?? const Color(0xFF3B5BDB),
                BlendMode.srcIn,
              ))
        else if (icon != null)
          Icon(icon, size: 14, color: color ?? const Color(0xFF3B5BDB)),
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

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText)),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.secondaryText,
                    height: 1.35)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Thumbnail card with gradient + mascot area
// ─────────────────────────────────────────────────────────────────────────────
class _EnglishThumbnailCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _EnglishThumbnailCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF7B1FA2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B5BDB).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background pattern circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 60,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: text content
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blue badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          data['thumbnail_label'] as String,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Main text — styled like the Figma mockup
                      ...() {
                        final lines =
                            (data['thumbnail_sub'] as String).split('\n');
                        return lines.map((line) {
                          // "HURUF" gets special yellow + big treatment
                          final isHighlight = line.toUpperCase() == line &&
                              line.length > 1 &&
                              line == lines[lines.length - 2];
                          return Text(
                            line,
                            style: TextStyle(
                              fontSize: isHighlight ? 24 : 13,
                              fontWeight: FontWeight.w900,
                              color: isHighlight
                                  ? const Color(0xFFFFD600)
                                  : Colors.white,
                              height: 1.2,
                            ),
                          );
                        }).toList();
                      }(),
                    ],
                  ),
                ),

                // Right: mascot avatar placeholder
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Mascot circle
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '🧑‍🏫',
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sound table (Sound | Example) matching the Figma table layout
// ─────────────────────────────────────────────────────────────────────────────
class _SoundTable extends StatelessWidget {
  final List<List<String>> rows;
  final List<bool> isHeader;

  const _SoundTable({required this.rows, required this.isHeader});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: rows[0].length == 3
          ? const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.5),
            }
          : const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1.5),
            },
      children: rows.asMap().entries.map((entry) {
        final i = entry.key;
        final row = entry.value;
        final header = isHeader[i];
        return TableRow(
          decoration: BoxDecoration(
            color: header
                ? const Color(0xFFF3F6FF)
                : (i.isEven ? Colors.transparent : const Color(0xFFFAFAFF)),
          ),
          children: row
              .map(
                (cell) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  child: Text(
                    cell,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          header ? FontWeight.w700 : FontWeight.w500,
                      color: header
                          ? const Color(0xFF3B5BDB)
                          : AppColors.primaryText,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      }).toList(),
    );
  }
}
