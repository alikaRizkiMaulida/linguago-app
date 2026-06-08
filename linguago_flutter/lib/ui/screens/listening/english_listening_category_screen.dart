import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/screens/listening/english_grid_screen.dart';

/// English Listening Category Screen.
/// Shown when Learning Language = English.
class EnglishListeningCategoryScreen extends StatelessWidget {
  const EnglishListeningCategoryScreen({super.key});

  // ── All English categories ──────────────────────────────────────────────
  static final List<_EnglishCategoryData> _categories = [
    // ── 1. Alphabet ──────────────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Alphabet',
      subtitle: 'Latin-script alphabet',
      desc: 'Learn how English letters sound and pronounce them correctly.',
      bg: const Color(0xFFFFF0F5),
      illustration: '🔤',
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

    // ── 2. Numbers ───────────────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Numbers',
      subtitle: 'Latin-script numbers',
      desc: 'Learn how to read and pronounce numbers from 0–100.',
      bg: const Color(0xFFFFF5E6),
      illustration: '🔢',
      gridTitle: 'English numbers',
      gridSubtitle: 'Latin-script numbers',
      mode: EnglishGridMode.threeColBig,
      items: const [
        EnglishItem('0',  'Zero'),     EnglishItem('1',  'One'),
        EnglishItem('2',  'Two'),      EnglishItem('3',  'Three'),
        EnglishItem('4',  'Four'),     EnglishItem('5',  'Five'),
        EnglishItem('6',  'Six'),      EnglishItem('7',  'Seven'),
        EnglishItem('8',  'Eight'),    EnglishItem('9',  'Nine'),
        EnglishItem('10', 'Ten'),      EnglishItem('11', 'Eleven'),
        EnglishItem('12', 'Twelve'),   EnglishItem('13', 'Thirteen'),
        EnglishItem('14', 'Fourteen'), EnglishItem('15', 'Fifteen'),
        EnglishItem('16', 'Sixteen'),  EnglishItem('17', 'Seventeen'),
        EnglishItem('18', 'Eighteen'), EnglishItem('19', 'Nineteen'),
        EnglishItem('20', 'Twenty'),   EnglishItem('30', 'Thirty'),
        EnglishItem('40', 'Forty'),    EnglishItem('50', 'Fifty'),
        EnglishItem('60', 'Sixty'),    EnglishItem('70', 'Seventy'),
        EnglishItem('80', 'Eighty'),   EnglishItem('90', 'Ninety'),
      ],
    ),

    // ── 3. Numbers 2 (100+) ──────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Numbers 2',
      subtitle: 'Latin-script numbers',
      desc: 'Learn how to read and pronounce numbers from 100 and above.',
      bg: const Color(0xFFEDE7FF),
      illustration: '💯',
      gridTitle: 'English numbers 2',
      gridSubtitle: 'Latin-script numbers',
      mode: EnglishGridMode.twoCol,
      items: const [
        EnglishItem('100',   'One Hundred'),
        EnglishItem('101',   'One Hundred One'),
        EnglishItem('110',   'One Hundred Ten'),
        EnglishItem('1,000', 'One Thousand'),
        EnglishItem('1,001', 'One Thousand\nOne'),
        EnglishItem('1,010', 'One Thousand\nTen'),
        EnglishItem('1,100', 'One Thousand\na Hundred'),
        EnglishItem('1,101', 'One Thousand\na Hundred One'),
        EnglishItem('10,000',  'Ten Thousand'),
        EnglishItem('100,000', 'One Hundred\nThousand'),
        EnglishItem('1,000,000', 'One Million'),
      ],
    ),

    // ── 4. Dates ─────────────────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Dates',
      subtitle: 'English dates',
      desc: 'Learn how to read, write, and say dates naturally in English.',
      bg: const Color(0xFFF3EEFB),
      illustration: '📅',
      gridTitle: 'English dates',
      gridSubtitle: 'Latin-script dates',
      mode: EnglishGridMode.threeColSmall,
      items: const [
        EnglishItem('1st',  'First'),         EnglishItem('2nd',  'Second'),
        EnglishItem('3rd',  'Third'),         EnglishItem('4th',  'Fourth'),
        EnglishItem('5th',  'Fifth'),         EnglishItem('6th',  'Sixth'),
        EnglishItem('7th',  'Seventh'),       EnglishItem('8th',  'Eighth'),
        EnglishItem('9th',  'Ninth'),         EnglishItem('10th', 'Tenth'),
        EnglishItem('11th', 'Eleventh'),      EnglishItem('12th', 'Twelfth'),
        EnglishItem('13th', 'Thirteenth'),    EnglishItem('14th', 'Fourteenth'),
        EnglishItem('15th', 'Fifteenth'),     EnglishItem('16th', 'Sixteenth'),
        EnglishItem('17th', 'Seventeenth'),   EnglishItem('18th', 'Eighteenth'),
        EnglishItem('19th', 'Nineteenth'),    EnglishItem('20th', 'Twentieth'),
        EnglishItem('21st', 'Twenty-first'),  EnglishItem('22nd', 'Twenty-second'),
        EnglishItem('30th', 'Thirtieth'),     EnglishItem('31st', 'Thirty-first'),
      ],
    ),

    // ── 5. Days ──────────────────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Days',
      subtitle: 'Days of the week',
      desc: 'Learn the names and pronunciation of the days of the week.',
      bg: const Color(0xFFE8F4F8),
      illustration: '📆',
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

    // ── 6. Months ─────────────────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Months',
      subtitle: 'Months of the year',
      desc: 'Learn the name and pronunciation of the months of the year.',
      bg: const Color(0xFFE8FFE8),
      illustration: '🗓️',
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

    // ── 7. Colors ─────────────────────────────────────────────────────────
    _EnglishCategoryData(
      title: 'Colors',
      subtitle: 'Common colors',
      desc: 'Learn common color names and simple descriptions.',
      bg: const Color(0xFFFFFBE6),
      illustration: '🎨',
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
            // ── App bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                  const Expanded(
                    child: Text(
                      'Listening',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Header ───────────────────────────────────────────────
            Text(
              'Hello! 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose the English category you want to learn.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // ── List ─────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EnglishGridScreen(
                            title: cat.gridTitle,
                            subtitle: cat.gridSubtitle,
                            items: cat.items,
                            mode: cat.mode,
                          ),
                        ),
                      );
                    },
                    child: _EnglishListeningCard(
                      title: cat.title,
                      subtitle: cat.subtitle,
                      desc: cat.desc,
                      bg: cat.bg,
                      illustration: cat.illustration,
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
class _EnglishCategoryData {
  final String title;
  final String subtitle;
  final String desc;
  final Color bg;
  final String illustration;
  final String gridTitle;
  final String gridSubtitle;
  final EnglishGridMode mode;
  final List<EnglishItem> items;

  const _EnglishCategoryData({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.bg,
    required this.illustration,
    required this.gridTitle,
    required this.gridSubtitle,
    required this.mode,
    required this.items,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Category card
// ─────────────────────────────────────────────────────────────────────────────
class _EnglishListeningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String desc;
  final Color bg;
  final String illustration;

  const _EnglishListeningCard({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.bg,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFA19EAA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                illustration,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
