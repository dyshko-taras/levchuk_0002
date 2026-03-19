import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_spacing.dart';
import '../../providers/workout_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/gradient_card.dart';
import '../widgets/common/screen_header.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const ScreenHeader(
              title: 'Create Workout',
              subtitle: 'Build your personalized desk routine',
              showGear: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppImages.workoutHero,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: Insets.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📋 Current Routine:',
                          style: AppFonts.body(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.hSm,
                        if (!workoutProvider.hasDraft)
                          Text(
                            'No steps yet. Add exercises or create a custom step.',
                            style: AppFonts.body(color: AppColors.textGray),
                          ),
                        ...List.generate(
                          workoutProvider.draftSteps.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: _DraftStepTile(
                              index: index,
                              name: workoutProvider.draftSteps[index].name,
                              durationSeconds: workoutProvider
                                  .draftSteps[index]
                                  .durationSeconds,
                              onRemove: () =>
                                  workoutProvider.removeDraftStepAt(index),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.hMd,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      side: BorderSide(
                        color: AppColors.greenStart.withValues(alpha: 0.65),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => context.push(AppRoutes.addExercise),
                    child: Text(
                      '+ Add Exercise',
                      style: AppFonts.body(
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gaps.hLg,
                  Row(
                    children: [
                      Text(
                        'Total time',
                        style: AppFonts.body(color: AppColors.textGray),
                      ),
                      const Spacer(),
                      Text(
                        _formatDuration(workoutProvider.draftTotalSeconds),
                        style: AppFonts.body(
                          weight: FontWeight.w700,
                          color: AppColors.greenStart,
                        ),
                      ),
                    ],
                  ),
                  if (workoutProvider.savedWorkouts.isNotEmpty) ...[
                    Gaps.hSm,
                    Text(
                      'Saved routines: ${workoutProvider.savedWorkouts.length}',
                      style: AppFonts.body(
                        size: 13,
                        color: AppColors.textGray3,
                      ),
                    ),
                  ],
                  Gaps.hXl,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      side: const BorderSide(color: AppColors.greenStart),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    onPressed: workoutProvider.hasDraft
                        ? () => _showSaveDialog(context, workoutProvider)
                        : null,
                    child: Text(
                      '💾 Save Routine',
                      style: AppFonts.body(
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gaps.hSm,
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.greenStart,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    onPressed: workoutProvider.hasDraft
                        ? () {
                            workoutProvider.startDraftSession();
                            context.push(AppRoutes.workoutSession);
                          }
                        : null,
                    child: Text(
                      '▶ Start Routine',
                      style: AppFonts.body(
                        weight: FontWeight.w700,
                        color: Colors.white,
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

  Future<void> _showSaveDialog(
    BuildContext context,
    WorkoutProvider provider,
  ) async {
    final controller = TextEditingController(
      text: 'Desk Flow ${provider.savedWorkouts.length + 1}',
    );
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Save Routine'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Routine name',
              errorText: errorText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  setState(() {
                    errorText = 'Name is required.';
                  });
                  return;
                }
                await provider.saveDraftAs(name);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Save'),
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

class _DraftStepTile extends StatelessWidget {
  const _DraftStepTile({
    required this.index,
    required this.name,
    required this.durationSeconds,
    required this.onRemove,
  });

  final int index;
  final String name;
  final int durationSeconds;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            '${(index + 1).toString().padLeft(2, '0')}',
            style: AppFonts.body(
              weight: FontWeight.w700,
              color: AppColors.greenStart,
            ),
          ),
          Gaps.wMd,
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.body(color: Colors.white),
            ),
          ),
          Gaps.wSm,
          Text(
            _formatDuration(durationSeconds),
            style: AppFonts.body(
              weight: FontWeight.w600,
              color: AppColors.greenStart,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: AppColors.textGray),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
