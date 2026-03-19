import 'package:FlutterApp/constants/app_images.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/data/models/quote.dart';
import 'package:FlutterApp/providers/quotes_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/accent_bar.dart';
import 'package:FlutterApp/ui/widgets/common/gradient_card.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quotesProvider = context.watch<QuotesProvider>();
    final activeQuote =
        quotesProvider.currentQuote ?? quotesProvider.quoteOfTheDay;

    return Scaffold(
      body: Stack(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const ScreenHeader(
                  title: 'Inspiring Quotes',
                  accentColor: ScreenHeaderAccent.purple,
                ),
                Expanded(
                  child: Padding(
                    padding: Insets.screen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                activeQuote == null
                                    ? 'No quote available.'
                                    : '"${activeQuote.text}"',
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.body(
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.hSm,
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  activeQuote == null
                                      ? '—'
                                      : '— ${activeQuote.author}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                          onPressed: () => _showPastQuotes(
                            context,
                            quotesProvider.viewedQuotes,
                          ),
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
                ),
              ],
          ),
        ],
      ),
    );
  }

  Future<void> _showPastQuotes(
    BuildContext context,
    List<Quote> viewedQuotes,
  ) async {
    final history = viewedQuotes.reversed.toList(growable: false);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.darkCard,
      showDragHandle: true,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: Insets.screen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past quotes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.display(size: 20, color: Colors.white),
              ),
              Gaps.hSm,
              if (history.isEmpty)
                Text(
                  'Quotes you open here will appear in this list.',
                  style: AppFonts.body(color: AppColors.textGray),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: history.length,
                    separatorBuilder: (_, _) => Gaps.hSm,
                    itemBuilder: (context, index) {
                      final quote = history[index];
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.overlayLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${quote.text}"',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.body(color: Colors.white),
                            ),
                            Gaps.hXs,
                            Text(
                              '— ${quote.author}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.body(
                                size: 13,
                                color: AppColors.purpleStart,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              Gaps.hLg,
            ],
          ),
        ),
      ),
    );
  }
}
