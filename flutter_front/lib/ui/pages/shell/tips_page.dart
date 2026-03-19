import 'package:FlutterApp/constants/app_images.dart';
import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/providers/tips_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/gradient_card.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tipsProvider = context.watch<TipsProvider>();

    return Scaffold(
      body: Column(
        children: [
          const ScreenHeader(
            title: 'Wellness Tips',
            showGear: true,
          ),
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.md,
                  AppSpacing.screenPadding,
                  AppSpacing.lg,
                ),
                itemCount: tipsProvider.topics.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final topic = tipsProvider.topics[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push(AppRoutes.tipDetail(topic.id)),
                    child: GradientCard(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    AppImages.topicImage(topic.id),
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Gaps.wSm,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topic.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFonts.body(
                                          size: 16,
                                          weight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Gaps.hXs,
                                      Text(
                                        topic.shortDescription,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFonts.body(
                                          size: 13,
                                          color: AppColors.textGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              height: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF28BAE8),
                                      Color(0xFF176ECA),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}
