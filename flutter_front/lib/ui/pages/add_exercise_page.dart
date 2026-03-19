import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/providers/workout_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    if (_controller.text != workoutProvider.searchQuery) {
      _controller.value = TextEditingValue(
        text: workoutProvider.searchQuery,
        selection: TextSelection.collapsed(
          offset: workoutProvider.searchQuery.length,
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.greenStart,
                  minimumSize: const Size.fromHeight(54),
                ),
                onPressed: () {
                  workoutProvider.commitSelectedExercises();
                  context.pop();
                },
                child: Text(
                  'Add Selected',
                  style: AppFonts.body(
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.hSm,
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  side: const BorderSide(color: AppColors.greenStart),
                ),
                onPressed: () => context.push(AppRoutes.customStep),
                child: Text(
                  '+ Custom Step',
                  style: AppFonts.body(
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Add Exercise',
              showBack: true,
            ),
            Expanded(
              child: Padding(
                padding: Insets.screen,
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      onChanged: workoutProvider.setSearchQuery,
                      style: AppFonts.body(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '🔍 Search exercises...',
                        hintStyle: AppFonts.body(color: AppColors.textGray),
                        filled: true,
                        fillColor: AppColors.darkCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Gaps.hMd,
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        itemCount: workoutProvider.filteredExercises.length,
                        separatorBuilder: (_, _) => Gaps.hXs,
                        itemBuilder: (context, index) {
                          final exercise =
                              workoutProvider.filteredExercises[index];
                          final selected = workoutProvider.isExerciseSelected(
                            exercise.id,
                          );

                          return InkWell(
                            onTap: () => workoutProvider
                                .toggleExerciseSelection(exercise),
                            borderRadius: BorderRadius.circular(14),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.overlayLight,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected
                                          ? AppColors.greenStart
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: AppColors.greenStart,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      selected ? '✓' : '',
                                      style: AppFonts.body(
                                        weight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Gaps.wMd,
                                  Expanded(
                                    child: Text(
                                      '${exercise.emoji} ${exercise.name}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.body(color: Colors.white),
                                    ),
                                  ),
                                  Gaps.wSm,
                                  Text(
                                    _formatDuration(exercise.durationSeconds),
                                    style: AppFonts.body(
                                      color: AppColors.greenStart,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
