import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/data/models/workout_step.dart';
import 'package:FlutterApp/providers/workout_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomStepPage extends StatefulWidget {
  const CustomStepPage({super.key});

  @override
  State<CustomStepPage> createState() => _CustomStepPageState();
}

class _CustomStepPageState extends State<CustomStepPage> {
  late final TextEditingController _nameController;
  String? _nameError;
  String? _durationError;
  Duration _selectedDuration = const Duration(seconds: 25);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.greenStart,
              minimumSize: const Size.fromHeight(54),
            ),
            onPressed: _submit,
            child: Text(
              '✅ Add to Routine',
              style: AppFonts.body(
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeader(
                      title: 'Custom Step',
                      showClose: true,
                    ),
                    Padding(
                      padding: Insets.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name:',
                            style: AppFonts.body(color: AppColors.textGray),
                          ),
                          Gaps.hXs,
                          TextField(
                            controller: _nameController,
                            style: AppFonts.body(color: Colors.white),
                            decoration: _decoration(
                              'Exercise name',
                              _nameError,
                            ),
                          ),
                          Gaps.hMd,
                          Text(
                            'Duration:',
                            style: AppFonts.body(color: AppColors.textGray),
                          ),
                          Gaps.hXs,
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _pickDuration,
                            child: InputDecorator(
                              decoration:
                                  _decoration(
                                    '00:25',
                                    _durationError,
                                  ).copyWith(
                                    suffixIcon: const Icon(
                                      Icons.schedule_rounded,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                              child: Text(
                                _formatDuration(_selectedDuration.inSeconds),
                                style: AppFonts.body(color: Colors.white),
                              ),
                            ),
                          ),
                          Gaps.hXs,
                          Text(
                            'Pick a duration between 00:05 and 05:00.',
                            style: AppFonts.body(
                              size: 12,
                              color: AppColors.textGray,
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
          },
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint, String? errorText) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppFonts.body(color: AppColors.textGray),
      errorText: errorText,
      filled: true,
      fillColor: AppColors.darkCard,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _pickDuration() async {
    var tempDuration = _selectedDuration;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.darkCard,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    0,
                  ),
                        child: Row(
                          children: [
                            TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: AppFonts.body(color: AppColors.textGray),
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            _selectedDuration = tempDuration;
                            _durationError =
                                _selectedDuration.inSeconds < 5 ||
                                    _selectedDuration.inSeconds > 300
                                ? 'Duration must be between 00:05 and 05:00.'
                                : null;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Apply',
                          style: AppFonts.body(
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                    child: CupertinoTimerPicker(
                      initialTimerDuration: _selectedDuration,
                      secondInterval: 5,
                      onTimerDurationChanged: (duration) {
                        tempDuration = duration;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    final duration = _selectedDuration.inSeconds;

    setState(() {
      _nameError = name.isEmpty ? 'Name is required.' : null;
      if (duration < 5 || duration > 300) {
        _durationError = 'Duration must be between 00:05 and 05:00.';
      } else {
        _durationError = null;
      }
    });

    if (_nameError != null || _durationError != null) {
      return;
    }

    context.read<WorkoutProvider>().addCustomStep(
      WorkoutStep(
        id: 'custom-${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        durationSeconds: duration,
        isCustom: true,
      ),
    );
    Navigator.of(context).pop();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
