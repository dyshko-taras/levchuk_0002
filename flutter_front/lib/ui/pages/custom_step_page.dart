import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_spacing.dart';
import '../../data/models/workout_step.dart';
import '../../providers/workout_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/screen_header.dart';

class CustomStepPage extends StatefulWidget {
  const CustomStepPage({super.key});

  @override
  State<CustomStepPage> createState() => _CustomStepPageState();
}

class _CustomStepPageState extends State<CustomStepPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;
  String? _nameError;
  String? _durationError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _durationController = TextEditingController(text: '00:25');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Custom Step',
              showBack: true,
            ),
            Expanded(
              child: Padding(
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
                      decoration: _decoration('Exercise name', _nameError),
                    ),
                    Gaps.hMd,
                    Text(
                      'Duration:',
                      style: AppFonts.body(color: AppColors.textGray),
                    ),
                    Gaps.hXs,
                    TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.datetime,
                      style: AppFonts.body(color: Colors.white),
                      decoration: _decoration('00:25', _durationError),
                    ),
                    const Spacer(),
                    FilledButton(
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
                  ],
                ),
              ),
            ),
          ],
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    final duration = _parseDuration(_durationController.text.trim());

    setState(() {
      _nameError = name.isEmpty ? 'Name is required.' : null;
      if (duration == null) {
        _durationError = 'Use mm:ss format.';
      } else if (duration < 5 || duration > 300) {
        _durationError = 'Duration must be between 00:05 and 05:00.';
      } else {
        _durationError = null;
      }
    });

    if (_nameError != null || _durationError != null || duration == null) {
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

  int? _parseDuration(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final minutes = int.tryParse(parts[0]);
    final seconds = int.tryParse(parts[1]);
    if (minutes == null || seconds == null || seconds < 0 || seconds > 59) {
      return null;
    }
    return (minutes * 60) + seconds;
  }
}
