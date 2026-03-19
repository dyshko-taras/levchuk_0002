import 'package:FlutterApp/constants/app_images.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/providers/tips_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/gradient_card.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TipDetailPage extends StatelessWidget {
  const TipDetailPage({
    required this.topicId,
    super.key,
  });

  final String topicId;

  @override
  Widget build(BuildContext context) {
    final topic = context.watch<TipsProvider>().topicById(topicId);

    if (topic == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Topic not found'),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: topic.title,
                showBack: true,
              ),
              Padding(
                padding: Insets.screen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.hMd,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        AppImages.topicImage(topic.id),
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Gaps.hMd,
                    ...topic.tips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: GradientCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: AppFonts.body(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.hXs,
                              Text(
                                tip.body,
                                style: AppFonts.body(
                                  size: 13,
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Gaps.hLg,
                    InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.greenStart,
                            width: 3,
                          ),
                        ),
                        child: Text(
                          'Back',
                          textAlign: TextAlign.center,
                          style: AppFonts.body(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Gaps.hLg,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
