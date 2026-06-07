import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

/// One cell in any English grid.
/// [main]         = big top text  (e.g. "A", "1st", "Monday", "100")
/// [pronunciation]= smaller label (e.g. "Ei", "First", "Senin", "One Hundred")
/// [color]        = optional – for the Color category (coloured blob)
class EnglishItem {
  final String main;
  final String pronunciation;
  final Color? color; // non-null → show coloured blob instead of text

  const EnglishItem(this.main, this.pronunciation, {this.color});
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

enum EnglishGridMode {
  /// 3-col, large main text  (Alphabet, Numbers, Dates)
  threeColBig,

  /// 3-col, small main text  (Dates ordinals with longer labels)
  threeColSmall,

  /// 2-col, medium main text (Days, Months, Numbers 2)
  twoCol,

  /// 3-col color blobs       (Colors)
  colors,
}

class EnglishGridScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<EnglishItem> items;
  final EnglishGridMode mode;

  const EnglishGridScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.mode = EnglishGridMode.threeColBig,
  });

  @override
  Widget build(BuildContext context) {
    final int cols = (mode == EnglishGridMode.twoCol) ? 2 : 3;
    final double ratio = _aspectRatio(mode);

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
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Grid ─────────────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: ratio,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _EnglishGridCell(item: item, mode: mode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _aspectRatio(EnglishGridMode m) {
    switch (m) {
      case EnglishGridMode.threeColBig:
        return 1.05;
      case EnglishGridMode.threeColSmall:
        return 1.0;
      case EnglishGridMode.twoCol:
        return 1.6;
      case EnglishGridMode.colors:
        return 0.95;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cell widget
// ─────────────────────────────────────────────────────────────────────────────
class _EnglishGridCell extends StatelessWidget {
  final EnglishItem item;
  final EnglishGridMode mode;

  const _EnglishGridCell({required this.item, required this.mode});

  @override
  Widget build(BuildContext context) {
    // Color category — coloured blob + name
    if (mode == EnglishGridMode.colors && item.color != null) {
      return _ColorCell(item: item);
    }

    final bool bigText = mode == EnglishGridMode.threeColBig;
    final bool twoCol  = mode == EnglishGridMode.twoCol;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B7BE1).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.main,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: bigText
                  ? 32
                  : twoCol
                      ? 20
                      : 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              item.pronunciation,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: twoCol ? 12 : 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5B7BE1),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Color blob cell
// ─────────────────────────────────────────────────────────────────────────────
class _ColorCell extends StatelessWidget {
  final EnglishItem item;
  const _ColorCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B7BE1).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Colourful asterisk / blob shape
          _ColorBlob(color: item.color!),
          const SizedBox(height: 8),
          Text(
            item.main, // e.g. "Red"
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws a colourful 8-pointed asterisk/blob using CustomPaint.
class _ColorBlob extends StatelessWidget {
  final Color color;
  const _ColorBlob({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(44, 44),
      painter: _BlobPainter(color: color),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;
  const _BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2;
    final r2 = r * 0.45; // inner radius

    final path = Path();
    const spokes = 8;
    for (int i = 0; i < spokes * 2; i++) {
      final angle = (i * 3.14159265358979 / spokes) - 3.14159265358979 / 2;
      final radius = (i % 2 == 0) ? r : r2;
      final x = cx + radius * _cos(angle);
      final y = cy + radius * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double a) => (a == 0)
      ? 1.0
      : (a < 0 ? -_cos(-a) : _cosCalc(a));

  double _sin(double a) {
    return _cos(a - 3.14159265358979 / 2);
  }

  double _cosCalc(double a) {
    // Taylor series approximation — good enough for painting
    a = a % (2 * 3.14159265358979);
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= (-a * a) / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.color != color;
}
