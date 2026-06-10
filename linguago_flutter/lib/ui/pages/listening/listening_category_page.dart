import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/pages/listening/hangul_grid_page.dart';

class ListeningCategoryPage extends StatelessWidget {
  const ListeningCategoryPage({super.key});

  static const List<Map<String, dynamic>> _categoriesKorea = [
    {
      'title': 'Vokal Dasar',
      'gridTitle': 'Basic Vowels',
      'subtitle': '기본 모음 Gibon Moeum',
      'desc': 'Vokal dasar Hangul adalah huruf utama untuk membentuk bunyi dan membaca kata dalam bahasa Korea.',
      'bg': Color(0xFFFFF0F5),
      'illustration': '👄 〰️',
      'items': [
        HangulItem('ㅏ', 'A'), HangulItem('ㅑ', 'Ya'), HangulItem('ㅓ', 'Eo'),
        HangulItem('ㅕ', 'Yeo'), HangulItem('ㅣ', 'I'), HangulItem('ㅗ', 'O'),
        HangulItem('ㅛ', 'Yo'), HangulItem('ㅜ', 'U'), HangulItem('ㅠ', 'Yu'),
        HangulItem('ㅡ', 'Eu'),
      ],
    },
    {
      'title': 'Vokal Lanjutan',
      'gridTitle': 'Vokal Lanjutan',
      'subtitle': '모음 Moeum',
      'desc': 'Vokal lanjutan Hangul adalah gabungan vokal dasar yang menghasilkan bunyi baru.',
      'bg': Color(0xFFFFF5E6),
      'illustration': '사 내\n+ 셔',
      'items': [
        HangulItem('ㅐ', 'Ae'), HangulItem('ㅒ', 'Yae'), HangulItem('ㅔ', 'E'),
        HangulItem('ㅖ', 'Ye'), HangulItem('ㅚ', 'Wei'), HangulItem('ㅘ', 'Wa'),
        HangulItem('ㅙ', 'Wae'), HangulItem('ㅟ', 'Wi'), HangulItem('ㅝ', 'Weo'),
        HangulItem('ㅞ', 'We'), HangulItem('ㅢ', 'Eui'),
      ],
    },
    {
      'title': 'Konsonan Dasar',
      'gridTitle': 'Konsonan Dasar',
      'subtitle': '자음 Jaeum',
      'desc': 'Konsonan dasar Hangul adalah huruf utama untuk membentuk bunyi dalam bahasa Korea.',
      'bg': Color(0xFFF3EEFB),
      'illustration': 'ㄱ ㄴ\nㄷ ㄹ ✏️',
      'items': [
        HangulItem('ㄱ', 'G/K'), HangulItem('ㄴ', 'N'), HangulItem('ㄷ', 'D/T'),
        HangulItem('ㄹ', 'L'), HangulItem('ㅁ', 'M'), HangulItem('ㅂ', 'B/P'),
        HangulItem('ㅅ', 'S'), HangulItem('ㅇ', 'Ng'), HangulItem('ㅈ', 'J'),
        HangulItem('ㅊ', 'Ch'), HangulItem('ㅋ', 'Kh'), HangulItem('ㅌ', 'Th'),
        HangulItem('ㅍ', 'Ph'), HangulItem('ㅎ', 'H'),
      ],
    },
    {
      'title': 'Konsonan Ganda',
      'gridTitle': 'Konsonan Ganda',
      'subtitle': '쌍 자음 Ssang Jaeum',
      'desc': 'Konsonan ganda Hangul adalah konsonan dengan bunyi lebih kuat dan tegas.',
      'bg': Color(0xFFF3EEFB),
      'illustration': 'ㄲ ㄸ\nㅃ ㅆ ⚡',
      'items': [
        HangulItem('ㄲ', 'Kk'), HangulItem('ㄸ', 'Tt'), HangulItem('ㅃ', 'Pp'),
        HangulItem('ㅆ', 'Ss'), HangulItem('ㅉ', 'Jj'),
      ],
    },
  ];

  static const List<Map<String, dynamic>> _categoriesEnglish = [
    {
      'title': 'Vokal Dasar',
      'gridTitle': 'Basic Vowels',
      'subtitle': 'A, E, I, O, U',
      'desc': 'Vokal dasar bahasa Inggris adalah huruf utama untuk membentuk bunyi kata.',
      'bg': Color(0xFFFFF0F5),
      'illustration': '👄 〰️',
      'items': [
        HangulItem('A', 'Ah'), HangulItem('E', 'Eh'), HangulItem('I', 'Ih'),
        HangulItem('O', 'Oh'), HangulItem('U', 'Uh'),
      ],
    },
    {
      'title': 'Konsonan Dasar (B-H)',
      'gridTitle': 'Basic Consonants (B-H)',
      'subtitle': 'Phonics Part 1',
      'desc': 'Konsonan dasar bagian pertama untuk membentuk bunyi awal kata dalam bahasa Inggris.',
      'bg': Color(0xFFFFF5E6),
      'illustration': 'B C\nD F ✏️',
      'items': [
        HangulItem('B', 'Buh'), HangulItem('C', 'Kuh'), HangulItem('D', 'Duh'),
        HangulItem('F', 'Fuh'), HangulItem('G', 'Guh'), HangulItem('H', 'Huh'),
      ],
    },
    {
      'title': 'Konsonan Dasar (J-P)',
      'gridTitle': 'Basic Consonants (J-P)',
      'subtitle': 'Phonics Part 2',
      'desc': 'Konsonan dasar bagian kedua untuk membentuk bunyi awal kata dalam bahasa Inggris.',
      'bg': Color(0xFFF3EEFB),
      'illustration': 'J K\nL M ✏️',
      'items': [
        HangulItem('J', 'Juh'), HangulItem('K', 'Kuh'), HangulItem('L', 'Luh'),
        HangulItem('M', 'Muh'), HangulItem('N', 'Nuh'), HangulItem('P', 'Puh'),
      ],
    },
    {
      'title': 'Konsonan Dasar (Q-Z)',
      'gridTitle': 'Basic Consonants (Q-Z)',
      'subtitle': 'Phonics Part 3',
      'desc': 'Konsonan dasar bagian ketiga untuk membentuk bunyi awal kata dalam bahasa Inggris.',
      'bg': Color(0xFFF3EEFB),
      'illustration': 'Q R\nS T ⚡',
      'items': [
        HangulItem('Q', 'Kwuh'), HangulItem('R', 'Ruh'), HangulItem('S', 'Suh'),
        HangulItem('T', 'Tuh'), HangulItem('V', 'Vuh'), HangulItem('W', 'Wuh'),
        HangulItem('X', 'Eks'), HangulItem('Y', 'Yuh'), HangulItem('Z', 'Zuh'),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isKorea = QuizProgress.learningLanguage == 'Korea';
    final categories = isKorea ? _categoriesKorea : _categoriesEnglish;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
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
                  Expanded(
                    child: Text(
                      'Listening',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
            const SizedBox(height: 24),

            // ── Header ───────────────────────────────────────────────
            Text(
              isKorea ? 'Annyeong! 👋' : 'Hello! 👋',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isKorea
                  ? 'Choose the Hangul category you want to learn.'
                  : 'Choose the Phonics category you want to learn.',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // ── List ─────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HangulGridPage(
                            title: cat['gridTitle'] as String,
                            subtitle: cat['subtitle'] as String,
                            items: cat['items'] as List<HangulItem>,
                          ),
                        ),
                      );
                    },
                    child: _ListeningCard(
                      title: cat['title'] as String,
                      subtitle: cat['subtitle'] as String,
                      desc: cat['desc'] as String,
                      bg: cat['bg'] as Color,
                      illustration: cat['illustration'] as String,
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

class _ListeningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String desc;
  final Color bg;
  final String illustration;

  const _ListeningCard({
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
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
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
                      style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xFFA19EAA), // Light grey text
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  illustration,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
