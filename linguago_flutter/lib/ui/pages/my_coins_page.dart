import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';

class MyCoinsPage extends StatefulWidget {
  const MyCoinsPage({super.key});

  @override
  State<MyCoinsPage> createState() => _MyCoinsPageState();
}

class _MyCoinsPageState extends State<MyCoinsPage> {
  // Local transactions list so we can dynamically add items on redeem
  late final List<Map<String, dynamic>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = [
      {
        'type': 'in',
        'value': 10,
        'label': 'Daily Check-in',
        'time': 'Today, 07.45 am',
      },
      {
        'type': 'out',
        'value': 30,
        'label': 'Extra Heart Collection',
        'time': 'Wednesday, 18.42 am',
      },
      {
        'type': 'in',
        'value': 20,
        'label': 'Daily Check-in',
        'time': 'Thursday, 08.55 am',
      },
      {
        'type': 'in',
        'value': 10,
        'label': 'Daily Check-in',
        'time': 'Monday, 09.27 am',
      },
    ];
  }

  void _claimTestingCoins() {
    setState(() {
      QuizProgress.setCoins(QuizProgress.coins + 20);
      _transactions.insert(0, {
        'type': 'in',
        'value': 20,
        'label': 'Free Bonus (Testing)',
        'time': 'Just Now',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Claimed +20 free testing coins! 🪙'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _redeemItem(String name, int cost) {
    if (QuizProgress.coins < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough coins to redeem $name! Need $cost coins. 🪙'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      QuizProgress.setCoins(QuizProgress.coins - cost);
      _transactions.insert(0, {
        'type': 'out',
        'value': cost,
        'label': name,
        'time': 'Just Now',
      });
    });

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Redemption Successful! 🎉',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('You have successfully redeemed $name for $cost coins.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Header (Text Centered, No Plus Icon)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 30,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'My Coins',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30), // keeps layout balanced
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // 1. Current Coins Banner Card (Double tap adds coins for testing)
                  GestureDetector(
                    onDoubleTap: _claimTestingCoins,
                    child: Container(
                      height: 148,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE5DEFF), Color(0xFFCBB8F0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            // Left: Coin Stack illustration
                            Positioned(
                              left: 6,
                              top: -15,
                              bottom: 20, // Overlaps the bottom strip to appear extremely large
                              child: Image.asset(
                                'assets/image 424.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Right: Coins balance
                            Positioned(
                              right: 24,
                              top: 28,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Current Coins',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${QuizProgress.coins} Coins',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Banner bottom row accent strip
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 38,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8C65D1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Text('🎁', style: TextStyle(fontSize: 12)),
                                        SizedBox(width: 6),
                                        Text(
                                          'Total Coins Earned',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${QuizProgress.coins} Coins',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Redeem Coins Section
                  const Text(
                    'Redeem Coins',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RedeemCard(
                        title: 'Extra Heart\nCollection',
                        cost: '15 coins',
                        floatDuration: const Duration(milliseconds: 1600),
                        illustration: Image.asset(
                          'assets/image 417.png',
                          width: 105,
                          height: 105,
                          fit: BoxFit.contain,
                        ),
                        onRedeem: () => _redeemItem('Extra Heart Collection', 15),
                      ),
                      const SizedBox(width: 8),
                      _RedeemCard(
                        title: 'Full Heart\nRefill',
                        cost: '50 coins',
                        floatDuration: const Duration(milliseconds: 2000),
                        illustration: Image.asset(
                          'assets/image 416.png',
                          width: 105,
                          height: 105,
                          fit: BoxFit.contain,
                        ),
                        onRedeem: () => _redeemItem('Full Heart Refill', 50),
                      ),
                      const SizedBox(width: 8),
                      _RedeemCard(
                        title: 'Unlimited\nHeart',
                        cost: '100 coins',
                        floatDuration: const Duration(milliseconds: 1800),
                        illustration: Image.asset(
                          'assets/image 414.png',
                          width: 105,
                          height: 105,
                          fit: BoxFit.contain,
                        ),
                        onRedeem: () => _redeemItem('Unlimited Heart', 100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Recent Transaction Section
                  const Text(
                    'Recent Transaction',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: List.generate(_transactions.length, (idx) {
                        final tx = _transactions[idx];
                        final isPlus = tx['type'] == 'in';
                        final color = isPlus ? const Color(0xFF4CAF50) : const Color(0xFFEC407A);

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  // Circle sign
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        isPlus ? '+' : '-',
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${isPlus ? '+' : '-'}${tx['value']} Coins',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: color,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          tx['label'] as String,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.disableText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Time
                                  Text(
                                    tx['time'] as String,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (idx < _transactions.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.disableBorder,
                                indent: 16,
                                endIndent: 16,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Redeem Card Child Widget ───────────────────────────────────────────────
class _RedeemCard extends StatelessWidget {
  final String title;
  final String cost;
  final Widget illustration;
  final VoidCallback onRedeem;
  final Duration floatDuration;

  const _RedeemCard({
    required this.title,
    required this.cost,
    required this.illustration,
    required this.onRedeem,
    required this.floatDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 105,
              child: _FloatingIllustration(
                duration: floatDuration,
                dy: 6.0,
                child: illustration,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                height: 1.2,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB300),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  cost,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onRedeem,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Redeem',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingIllustration extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double dy;

  const _FloatingIllustration({
    required this.child,
    required this.duration,
    this.dy = 6.0,
  });

  @override
  State<_FloatingIllustration> createState() => _FloatingIllustrationState();
}

class _FloatingIllustrationState extends State<_FloatingIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: -widget.dy, end: widget.dy).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
