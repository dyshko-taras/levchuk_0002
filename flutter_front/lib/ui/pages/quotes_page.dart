import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../constants/app_spacing.dart';
import '../../providers/quotes_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/accent_bar.dart';
import '../widgets/common/gradient_card.dart';
import '../widgets/common/screen_header.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quotesProvider = context.watch<QuotesProvider>();
    final activeQuote = quotesProvider.currentQuote ?? quotesProvider.quoteOfTheDay;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  AppImages.quotesBackground,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: Insets.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenHeader(
                    title: 'Inspiring Quotes',
                    accentColor: ScreenHeaderAccent.purple,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccentBar.purple,
                        Gaps.hSm,
                        Text(
                          '✨ Quote of the Day:',
                          style: AppFonts.body(
                            size: 15,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.hSm,
                        Text(
                          activeQuote == null ? 'No quote available.' : '"${activeQuote.text}"',
                          style: AppFonts.body(
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.hSm,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            activeQuote == null ? '—' : '— ${activeQuote.author}',
                            style: AppFonts.body(
                              size: 13,
                              color: AppColors.purpleStart,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      side: const BorderSide(
                        color: AppColors.greenStart,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      'Past quotes',
                      style: AppFonts.body(
                        size: 16,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gaps.hXs,
                  FilledButton(
                    onPressed: quotesProvider.showNextQuote,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: AppColors.greenStart,
                    ),
                    child: Text(
                      'Next Quote',
                      style: AppFonts.body(
                        size: 16,
                        weight: FontWeight.w700,
                        color: Colors.white,
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
    );
  }
}
