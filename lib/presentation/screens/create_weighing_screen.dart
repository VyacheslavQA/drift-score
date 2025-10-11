import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../data/models/local/competition_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/weighing_provider.dart';

class CreateWeighingScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const CreateWeighingScreen({
    super.key,
    required this.competition,
  });

  @override
  ConsumerState<CreateWeighingScreen> createState() => _CreateWeighingScreenState();
}

class _CreateWeighingScreenState extends ConsumerState<CreateWeighingScreen> {
  int? _selectedDay;
  DateTime? _selectedTime;
  int _weighingNumber = 1;

  @override
  Widget build(BuildContext context) {
    final totalDays = widget.competition.durationDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('weighing_create_title'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'weighing_select_day_time'.tr(),
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: AppDimensions.paddingLarge),

              Text(
                'weighing_day'.tr(),
                style: AppTextStyles.bodyBold,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              DropdownButtonFormField<int>(
                value: _selectedDay,
                decoration: InputDecoration(
                  hintText: 'weighing_select_day_hint'.tr(),
                  border: const OutlineInputBorder(),
                ),
                items: List.generate(totalDays, (index) {
                  final dayNumber = index + 1;
                  final date = widget.competition.startTime.add(Duration(days: index));
                  final dateStr = DateFormat('dd.MM.yyyy').format(date);

                  return DropdownMenuItem(
                    value: dayNumber,
                    child: Text('${'weighing_day'.tr()} $dayNumber ($dateStr)'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              Text(
                'weighing_time'.tr(),
                style: AppTextStyles.bodyBold,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              InkWell(
                onTap: _selectTime,
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'weighing_select_time_hint'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedTime != null
                        ? DateFormat('HH:mm').format(_selectedTime!)
                        : 'weighing_select_time_hint'.tr(),
                    style: _selectedTime != null
                        ? AppTextStyles.body
                        : AppTextStyles.caption,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              Text(
                'weighing_number'.tr(),
                style: AppTextStyles.bodyBold,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              TextFormField(
                initialValue: _weighingNumber.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _weighingNumber = int.tryParse(value) ?? 1;
                },
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: _canCreate() ? _createWeighing : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                ),
                child: Text('weighing_create'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canCreate() {
    return _selectedDay != null && _selectedTime != null;
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime != null
          ? TimeOfDay.fromDateTime(_selectedTime!)
          : TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      final now = DateTime.now();
      _selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _createWeighing() async {
    final notifier = ref.read(weighingsProvider(widget.competition.id).notifier);
    final weighingId = await notifier.createWeighingSession(
      dayNumber: _selectedDay!,
      weighingTime: _selectedTime!,
      weighingNumber: _weighingNumber,
    );

    if (weighingId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('weighing_created_success'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('weighing_created_error'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}