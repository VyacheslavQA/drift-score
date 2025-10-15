import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/competition_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/casting_provider.dart';

class CreateCastingSessionScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const CreateCastingSessionScreen({
    super.key,
    required this.competition,
  });

  @override
  ConsumerState<CreateCastingSessionScreen> createState() => _CreateCastingSessionScreenState();
}

class _CreateCastingSessionScreenState extends ConsumerState<CreateCastingSessionScreen> {
  int _dayNumber = 1;
  int _sessionNumber = 1;
  DateTime _sessionTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Вычисляем текущий день соревнования
    final now = DateTime.now();
    final startDate = DateTime(
      widget.competition.startTime.year,
      widget.competition.startTime.month,
      widget.competition.startTime.day,
    );
    final currentDate = DateTime(now.year, now.month, now.day);
    final daysDiff = currentDate.difference(startDate).inDays;

    if (daysDiff >= 0 && daysDiff < widget.competition.durationDays) {
      _dayNumber = daysDiff + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('casting_create_session'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Информация о соревновании
              Card(
                color: AppColors.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.competition.name,
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${'duration'.tr()}: ${widget.competition.durationDays} ${_pluralizeDays(widget.competition.durationDays)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Выбор дня
              Text('casting_select_day'.tr(), style: AppTextStyles.h3),
              const SizedBox(height: AppDimensions.paddingSmall),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    children: List.generate(widget.competition.durationDays, (index) {
                      final day = index + 1;
                      final dayDate = widget.competition.startTime.add(Duration(days: index));
                      final dayStr = DateFormat('dd.MM.yyyy').format(dayDate);

                      return RadioListTile<int>(
                        title: Text(
                          '${'casting_day'.tr()} $day',
                          style: AppTextStyles.body,
                        ),
                        subtitle: Text(dayStr, style: AppTextStyles.caption),
                        value: day,
                        groupValue: _dayNumber,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _dayNumber = value);
                          }
                        },
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Выбор номера попытки
              Text('casting_select_attempt'.tr(), style: AppTextStyles.h3),
              const SizedBox(height: AppDimensions.paddingSmall),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    children: List.generate(widget.competition.attemptsCount ?? 3, (index) {
                      final attemptNumber = index + 1;
                      return RadioListTile<int>(
                        title: Text(
                          '${'casting_attempt'.tr()} $attemptNumber',
                          style: AppTextStyles.body,
                        ),
                        value: attemptNumber,
                        groupValue: _sessionNumber,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sessionNumber = value);
                          }
                        },
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              // Выбор времени
              Text('casting_select_time'.tr(), style: AppTextStyles.h3),
              const SizedBox(height: AppDimensions.paddingSmall),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.access_time, color: AppColors.primary),
                  title: Text(
                    DateFormat('HH:mm').format(_sessionTime),
                    style: AppTextStyles.h3,
                  ),
                  trailing: const Icon(Icons.edit, color: AppColors.primary),
                  onTap: _selectTime,
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXLarge),

              // Кнопка создания
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text('casting_create_session_button'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _pluralizeDays(int count) {
    final remainder10 = count % 10;
    final remainder100 = count % 100;

    if (remainder10 == 1 && remainder100 != 11) {
      return 'день';
    } else if (remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20)) {
      return 'дня';
    } else {
      return 'дней';
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_sessionTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _sessionTime = DateTime(
          _sessionTime.year,
          _sessionTime.month,
          _sessionTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _createSession() async {
    try {
      await ref.read(castingSessionsProvider(widget.competition.id).notifier).createSession(
        dayNumber: _dayNumber,
        sessionNumber: _sessionNumber,
        sessionTime: _sessionTime,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('casting_session_created'.tr()),
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