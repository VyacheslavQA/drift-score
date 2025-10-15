import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/casting_session_local.dart';
import '../../data/models/local/casting_result_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/casting_provider.dart';
import 'casting_session_details_screen.dart';

class ParticipantCastingScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final CastingSessionLocal session;
  final ParticipantInfo participant;
  final CastingResultLocal? existingResult;

  const ParticipantCastingScreen({
    super.key,
    required this.competition,
    required this.session,
    required this.participant,
    this.existingResult,
  });

  @override
  ConsumerState<ParticipantCastingScreen> createState() =>
      _ParticipantCastingScreenState();
}

class _ParticipantCastingScreenState
    extends ConsumerState<ParticipantCastingScreen> {
  final _distanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    // Если есть существующий результат для этой попытки, загружаем его
    if (widget.existingResult != null) {
      final attempt = widget.existingResult!.attempts.firstWhere(
            (a) => a.attemptNumber == widget.session.sessionNumber,
        orElse: () => CastingAttempt()
          ..id = ''
          ..attemptNumber = 0
          ..distance = 0.0
          ..isValid = true
          ..timestamp = DateTime.now(),
      );

      if (attempt.attemptNumber > 0) {
        _distanceController.text = attempt.distance.toStringAsFixed(2);
        _isValid = attempt.isValid;
      }
    }
  }

  @override
  void dispose() {
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.participant.fullName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Информация об участнике
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.participant.fullName,
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    '${'rod'.tr()}: ${widget.participant.rod}',
                    style: AppTextStyles.body,
                  ),
                  Text(
                    '${'line'.tr()}: ${widget.participant.line}',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    '${'casting_attempt'.tr()} ${widget.session.sessionNumber}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            // Форма ввода дальности
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'casting_enter_distance'.tr(),
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),

                      // Ввод дальности
                      TextFormField(
                        controller: _distanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'casting_distance_label'.tr(),
                          hintText: 'casting_distance_hint'.tr(),
                          suffixText: 'м',
                          suffixStyle: AppTextStyles.h3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSmall,
                            ),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSmall,
                            ),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSmall,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'field_required'.tr();
                          }
                          final distance = double.tryParse(value);
                          if (distance == null || distance < 0) {
                            return 'casting_invalid_distance'.tr();
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Чекбокс "Засчитан"
                      Card(
                        color: AppColors.surface,
                        child: CheckboxListTile(
                          title: Text(
                            'casting_is_valid'.tr(),
                            style: AppTextStyles.bodyBold,
                          ),
                          subtitle: Text(
                            'casting_is_valid_hint'.tr(),
                            style: AppTextStyles.caption,
                          ),
                          value: _isValid,
                          activeColor: AppColors.success,
                          onChanged: (value) {
                            setState(() {
                              _isValid = value ?? true;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: AppDimensions.paddingLarge),

                      // Информационная плашка
                      Container(
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'casting_info_hint'.tr(),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Кнопка сохранения
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text('casting_save_result'.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveResult() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final distance = double.parse(_distanceController.text.trim());

    try {
      await ref
          .read(castingResultsProvider(widget.session.id).notifier)
          .saveParticipantResult(
        participantId: widget.participant.teamId,
        participantFullName: widget.participant.fullName,
        sessionNumber: widget.session.sessionNumber,
        distance: distance,
        isValid: _isValid,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('casting_result_saved'.tr()),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'error'.tr()}: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}