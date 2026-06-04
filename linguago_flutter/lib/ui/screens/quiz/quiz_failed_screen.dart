import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/ui/widgets/mascot_widget.dart';

class QuizFailedScreen extends StatelessWidget {
  final int correctCount;
  final int totalQuestions;
  final VoidCallback onRetry;

  const QuizFailedScreen({
    super.key,
    required this.correctCount,
    required this.totalQuestions,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final int accuracy = totalQuestions > 0 
        ? ((correctCount / totalQuestions) * 100).toInt() 
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28),
                    color: AppColors.primaryText,
                    onPressed: () {
                      // Return to root main page
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
            
            const Spacer(flex: 2),

            // Fail Mascot
            Center(
              child: MascotWidget(
                pose: MascotPose.fail,
                size: 180,
              ),
            ),
            
            const SizedBox(height: 32),

            // Title Text
            const Text(
              'Quiz Failed',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFFC62828), // Bold red failure color
              ),
            ),
            const SizedBox(height: 8),

            // Description Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'You ran out of lives! Keep practicing basic Hangul concepts and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryText,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Accuracy stat card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
              ),
              child: Text(
                'Accuracy: $accuracy%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFC62828),
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  // Retry Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Pop failed screen
                        onRetry(); // Restart quiz
                      },
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Back to Map Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryPurple, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        'Back to Map',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
