import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/screens/listening/english_grid_screen.dart';
export 'package:linguago_flutter/ui/screens/listening/english_grid_screen.dart' show EnglishItem, EnglishGridMode;

/// English Script Category Screen — "Let's Begin! Learn English from beginner to advanced!"
/// Shown when Learning Language = English.
class EnglishScriptCategoryScreen extends StatelessWidget {
  const EnglishScriptCategoryScreen({super.key});

  static final List<_EnglishScriptCategory> _categories = [
    _EnglishScriptCategory(
      title: 'Alphabet',
      desc: 'Learn English letter sounds and common pronunciation patterns.',
      emoji: '🔤',
      bg: const Color(0xFFFFB3BA),
      unlocked: true,
      lockLevel: null,
      gridTitle: 'English alphabet',
      gridSubtitle: 'Latin-script alphabet',
      mode: EnglishGridMode.threeColBig,
      items: const [
        EnglishItem('A', 'Ei'),       EnglishItem('B', 'Bi'),
        EnglishItem('C', 'Si'),       EnglishItem('D', 'Di'),
        EnglishItem('E', 'I'),        EnglishItem('F', 'Ef'),
        EnglishItem('G', 'Ji'),       EnglishItem('H', 'Eyc'),
        EnglishItem('I', 'Ay'),       EnglishItem('J', 'Jey'),
        EnglishItem('K', 'Key'),      EnglishItem('L', 'El'),
        EnglishItem('M', 'Em'),       EnglishItem('N', 'En'),
        EnglishItem('O', 'Ou'),       EnglishItem('P', 'Pi'),
        EnglishItem('Q', 'Kyu'),      EnglishItem('R', 'Ar'),
        EnglishItem('S', 'Es'),       EnglishItem('T', 'Ti'),
        EnglishItem('U', 'Yu'),       EnglishItem('V', 'Vi'),
        EnglishItem('W', 'Dabelyu'), EnglishItem('X', 'Eks'),
        EnglishItem('Y', 'Way'),      EnglishItem('Z', 'Zi'),
      ],
    ),
    _EnglishScriptCategory(
      title: 'Numbers',
      desc: 'Learn numbers from 0 to 100 and how they are used in English.',
      emoji: '🔢',
      bg: const Color(0xFFD4C4F0),
      unlocked: false,
      lockLevel: 2,
      gridTitle: 'English numbers',
      gridSubtitle: 'Latin-script numbers',
      mode: EnglishGridMode.threeColBig,
      items: const [
        EnglishItem('0',  'Zero'),     EnglishItem('1',  'One'),
        EnglishItem('2',  'Two'),      EnglishItem('3',  'Three'),
        EnglishItem('4',  'Four'),     EnglishItem('5',  'Five'),
        EnglishItem('6',  'Six'),      EnglishItem('7',  'Seven'),
        EnglishItem('8',  'Eight'),    EnglishItem('9',  'Nine'),
        EnglishItem('10', 'Ten'),      EnglishItem('20', 'Twenty'),
        EnglishItem('30', 'Thirty'),   EnglishItem('50', 'Fifty'),
        EnglishItem('100','Hundred'),
      ],
    ),
    _EnglishScriptCategory(
      title: 'Dates',
      desc: 'Learn how to read, write, and say dates naturally in English.',
      emoji: '📅',
      bg: const Color(0xFFFFF0B3),
      unlocked: false,
      lockLevel: 3,
      gridTitle: 'English dates',
      gridSubtitle: 'Latin-script dates',
      mode: EnglishGridMode.threeColSmall,
      items: const [
        EnglishItem('1st',  'First'),        EnglishItem('2nd',  'Second'),
        EnglishItem('3rd',  'Third'),        EnglishItem('4th',  'Fourth'),
        EnglishItem('5th',  'Fifth'),        EnglishItem('10th', 'Tenth'),
        EnglishItem('11th', 'Eleventh'),     EnglishItem('12th', 'Twelfth'),
        EnglishItem('20th', 'Twentieth'),    EnglishItem('21st', 'Twenty-first'),
        EnglishItem('30th', 'Thirtieth'),    EnglishItem('31st', 'Thirty-first'),
      ],
    ),
    _EnglishScriptCategory(
      title: 'Days',
      desc: 'Learn the days of the week and their everyday usage.',
      emoji: '📆',
      bg: const Color(0xFFE8E8FF),
      unlocked: false,
      lockLevel: 4,
      gridTitle: 'English days',
      gridSubtitle: 'Latin-script days',
      mode: EnglishGridMode.twoCol,
      items: const [
        EnglishItem('Monday',    'Senin'),
        EnglishItem('Tuesday',   'Selasa'),
        EnglishItem('Wednesday', 'Rabu'),
        EnglishItem('Thursday',  'Kamis'),
        EnglishItem('Friday',    'Jumat'),
        EnglishItem('Saturday',  'Sabtu'),
        EnglishItem('Sunday',    'Minggu'),
      ],
    ),
    _EnglishScriptCategory(
      title: 'Months',
      desc: 'Learn the months of the year and their everyday usage.',
      emoji: '🗓️',
      bg: const Color(0xFFFFDAB9),
      unlocked: false,
      lockLevel: 5,
      gridTitle: 'English months',
      gridSubtitle: 'Latin-script months',
      mode: EnglishGridMode.twoCol,
      items: const [
        EnglishItem('January',   'Januari'),
        EnglishItem('February',  'Februari'),
        EnglishItem('March',     'Maret'),
        EnglishItem('April',     'April'),
        EnglishItem('May',       'Mei'),
        EnglishItem('June',      'Juni'),
        EnglishItem('July',      'Juli'),
        EnglishItem('August',    'Agustus'),
        EnglishItem('September', 'September'),
        EnglishItem('October',   'Oktober'),
        EnglishItem('November',  'November'),
        EnglishItem('December',  'Desember'),
      ],
    ),
    _EnglishScriptCategory(
      title: 'Colors',
      desc: 'Learn common color names and simple descriptions.',
      emoji: '🎨',
      bg: const Color(0xFFE0F7FA),
      unlocked: false,
      lockLevel: 6,
      gridTitle: 'English colors',
      gridSubtitle: 'Latin-script colors',
      mode: EnglishGridMode.colors,
      items: const [
        EnglishItem('Red',    '', color: Color(0xFFE53935)),
        EnglishItem('Pink',   '', color: Color(0xFFEC407A)),
        EnglishItem('Orange', '', color: Color(0xFFFF7043)),
        EnglishItem('Yellow', '', color: Color(0xFFFDD835)),
        EnglishItem('Green',  '', color: Color(0xFF43A047)),
        EnglishItem('Cyan',   '', color: Color(0xFF00BCD4)),
        EnglishItem('Blue',   '', color: Color(0xFF1E88E5)),
        EnglishItem('Purple', '', color: Color(0xFF8E24AA)),
        EnglishItem('Brown',  '', color: Color(0xFF6D4C41)),
        EnglishItem('Grey',   '', color: Color(0xFF757575)),
        EnglishItem('White',  '', color: Color(0xFFBDBDBD)),
        EnglishItem('Black',  '', color: Color(0xFF212121)),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ── App bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 30,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Header ────────────────────────────────────────────────
            const Text(
              "Let's Begin!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Learn English from beginner to advanced! ✨',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),

            // ── Category grid ─────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 50,
                  childAspectRatio: 0.65,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return GestureDetector(
                    onTap: cat.unlocked
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EnglishGridScreen(
                                  title: cat.gridTitle,
                                  subtitle: cat.gridSubtitle,
                                  items: cat.items,
                                  mode: cat.mode,
                                ),
                              ),
                            )
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Unlock at Level ${cat.lockLevel}!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    child: _EnglishScriptCard(
                      title: cat.title,
                      desc: cat.desc,
                      emoji: cat.emoji,
                      bg: cat.bg,
                      unlocked: cat.unlocked,
                      lockLevel: cat.lockLevel,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data class
// ─────────────────────────────────────────────────────────────────────────────
class _EnglishScriptCategory {
  final String title;
  final String desc;
  final String emoji;
  final Color bg;
  final bool unlocked;
  final int? lockLevel;
  final String gridTitle;
  final String gridSubtitle;
  final EnglishGridMode mode;
  final List<EnglishItem> items;

  const _EnglishScriptCategory({
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.unlocked,
    required this.lockLevel,
    required this.gridTitle,
    required this.gridSubtitle,
    required this.mode,
    required this.items,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Card widget
// ─────────────────────────────────────────────────────────────────────────────
class _EnglishScriptCard extends StatelessWidget {
  final String title;
  final String desc;
  final String emoji;
  final Color bg;
  final bool unlocked;
  final int? lockLevel;

  const _EnglishScriptCard({
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.unlocked,
    this.lockLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // White card
        Container(
          margin: const EdgeInsets.only(top: 36),
          padding: const EdgeInsets.fromLTRB(14, 48, 14, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B7BE1).withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 8),
              if (unlocked)
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: null, // tapped via GestureDetector above
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B7BE1),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF5B7BE1),
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: AppColors.navInActive, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Unlocked at Level $lockLevel',
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.navInActive,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Floating circle emoji at top
        Positioned(
          top: 0,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
