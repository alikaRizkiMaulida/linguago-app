import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
// Import file LessonDetailScreen agar bisa membaca data list static-nya
import 'package:linguago_flutter/ui/pages/lesson_detail_screen.dart';

class SavedLessonsPage extends StatefulWidget {
  const SavedLessonsPage({super.key});

  @override
  State<SavedLessonsPage> createState() => _SavedLessonsPageState();
}

class _SavedLessonsPageState extends State<SavedLessonsPage> {
  @override
  Widget build(BuildContext context) {
    // Mengambil data real-time dari LessonDetailScreen
    final List<Map<String, dynamic>> savedLessons = LessonDetailScreen.savedLessonsData;

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primaryText, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Saved Lessons',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: savedLessons.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pelajaran yang disimpan.',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GridView.builder(
                itemCount: savedLessons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final lesson = savedLessons[index];
                  return LessonCard(
                    title: lesson['title'] ?? '',
                    description: lesson['desc'] ?? '',
                    // Otomatis bikin url thumbnail youtube dari ytId data detail
                    imageUrl: 'https://img.youtube.com/vi/${lesson['ytId']}/hqdefault.jpg',
                    onUnsave: () {
                      // Fungsi menghapus item langsung dari list saved lesson
                      setState(() {
                        LessonDetailScreen.savedLessonsData.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onUnsave;

  const LessonCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding dalam untuk bingkai putih luar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Thumbnail Video dengan rounded di 4 sisi
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1.4,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.buttonCancel,
                      child: const Icon(Icons.video_library, color: AppColors.navInActive),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Klik ikon bookmark di halaman ini untuk langsung un-save/menghapus
                        GestureDetector(
                          onTap: onUnsave,
                          child: const Icon(
                            Icons.bookmark,
                            color: AppColors.primaryPurple,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.secondaryText,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}