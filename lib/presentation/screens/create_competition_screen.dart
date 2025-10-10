import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/competition_provider.dart';
import '../../data/models/local/competition_local.dart';

class CreateCompetitionScreen extends ConsumerStatefulWidget {
  final String accessCode;

  const CreateCompetitionScreen({
    Key? key,
    required this.accessCode,
  }) : super(key: key);

  @override
  ConsumerState<CreateCompetitionScreen> createState() => _CreateCompetitionScreenState();
}

class _CreateCompetitionScreenState extends ConsumerState<CreateCompetitionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _lakeController = TextEditingController();
  final _organizerController = TextEditingController();
  final _sectorsController = TextEditingController(text: '24');

  DateTime _startTime = DateTime.now();
  DateTime _finishTime = DateTime.now().add(Duration(hours: 72));
  String _scoringRules = 'total_weight';

  final List<Judge> _judges = [];

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _lakeController.dispose();
    _organizerController.dispose();
    _sectorsController.dispose();
    super.dispose();
  }

  int get _durationHours {
    return _finishTime.difference(_startTime).inHours;
  }

  int get _durationDays {
    final startDate = DateTime(_startTime.year, _startTime.month, _startTime.day);
    final finishDate = DateTime(_finishTime.year, _finishTime.month, _finishTime.day);
    return finishDate.difference(startDate).inDays + 1;
  }

  // Функция склонения числительных для русского языка
  String _pluralize(int count, String one, String few, String many) {
    final remainder10 = count % 10;
    final remainder100 = count % 100;

    if (remainder10 == 1 && remainder100 != 11) {
      return one; // 1 час, 21 час, 1 день
    } else if (remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20)) {
      return few; // 2-4 часа, 22-24 часа, 2-4 дня
    } else {
      return many; // 5-20 часов, 25-30 часов, 5-20 дней
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('create_competition'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.key, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${'access_code'.tr()}: ',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        widget.accessCode,
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                _buildTextField(
                  controller: _nameController,
                  label: 'competition_name'.tr(),
                  validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                ),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildTextField(
                  controller: _cityController,
                  label: 'city_or_region'.tr(),
                  validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                ),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildTextField(
                  controller: _lakeController,
                  label: 'lake_name'.tr(),
                  validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                ),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildTextField(
                  controller: _organizerController,
                  label: 'organizer_name'.tr(),
                  validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                ),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildTextField(
                  controller: _sectorsController,
                  label: 'sectors_count'.tr(),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v?.isEmpty ?? true) return 'field_required'.tr();
                    final num = int.tryParse(v!);
                    if (num == null || num <= 0) return 'invalid_number'.tr();
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                _buildStartTimePicker(),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildFinishTimePicker(),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildDurationInfo(),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildScoringRulesSelector(),
                SizedBox(height: AppDimensions.paddingLarge),

                _buildJudgesSection(),
                SizedBox(height: AppDimensions.paddingXLarge),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: Text('create'.tr(), style: AppTextStyles.button),
                  ),
                ),

                SizedBox(height: AppDimensions.paddingXLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildStartTimePicker() {
    return InkWell(
      onTap: () => _selectDateTime(true),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('start_time'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(_startTime),
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
            Icon(Icons.calendar_today, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishTimePicker() {
    return InkWell(
      onTap: () => _selectDateTime(false),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('finish_time'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(_finishTime),
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
            Icon(Icons.calendar_today, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationInfo() {
    final hoursText = _pluralize(_durationHours, 'час', 'часа', 'часов');
    final daysText = _pluralize(_durationDays, 'день', 'дня', 'дней');

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Text(
            '${'duration'.tr()}: ',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            '$_durationHours $hoursText ($_durationDays $daysText)',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringRulesSelector() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('scoring_rules'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          SizedBox(height: 8),
          DropdownButton<String>(
            value: _scoringRules,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(value: 'total_weight', child: Text('total_weight'.tr())),
              DropdownMenuItem(value: 'top_3', child: Text('top_3'.tr())),
              DropdownMenuItem(value: 'top_5', child: Text('top_5'.tr())),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _scoringRules = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJudgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('judges'.tr(), style: AppTextStyles.h3),
            IconButton(
              icon: Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: _addJudge,
            ),
          ],
        ),
        SizedBox(height: 8),
        ..._judges.asMap().entries.map((entry) {
          final index = entry.key;
          final judge = entry.value;
          return Card(
            color: AppColors.surface,
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(judge.fullName, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
              subtitle: Text(judge.rank, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: AppColors.error),
                onPressed: () => _removeJudge(index),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Future<void> _selectDateTime(bool isStart) async {
    final initialDate = isStart ? _startTime : _finishTime;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
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
          final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

          if (isStart) {
            _startTime = newDateTime;
            if (_startTime.isAfter(_finishTime)) {
              _finishTime = _startTime.add(Duration(hours: 72));
            }
          } else {
            if (newDateTime.isBefore(_startTime)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Финиш не может быть раньше старта!')),
              );
              return;
            }
            _finishTime = newDateTime;
          }
        });
      }
    }
  }

  void _addJudge() {
    showDialog(
      context: context,
      builder: (context) => _JudgeDialog(
        onSave: (judge) {
          setState(() => _judges.add(judge));
        },
      ),
    );
  }

  void _removeJudge(int index) {
    setState(() => _judges.removeAt(index));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_judges.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('add_at_least_one_judge'.tr())),
      );
      return;
    }

    if (_finishTime.isBefore(_startTime) || _finishTime.isAtSameMomentAs(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Финиш должен быть позже старта!')),
      );
      return;
    }

    try {
      await ref.read(competitionProvider.notifier).createCompetition(
        name: _nameController.text,
        cityOrRegion: _cityController.text,
        lakeName: _lakeController.text,
        sectorsCount: int.parse(_sectorsController.text),
        startTime: _startTime,
        finishTime: _finishTime,
        scoringRules: _scoringRules,
        organizerName: _organizerController.text,
        judges: _judges,
        accessCode: widget.accessCode,
      );

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('competition_created'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
}

class _JudgeDialog extends StatefulWidget {
  final Function(Judge) onSave;

  const _JudgeDialog({required this.onSave});

  @override
  State<_JudgeDialog> createState() => _JudgeDialogState();
}

class _JudgeDialogState extends State<_JudgeDialog> {
  final _nameController = TextEditingController();
  String _rank = 'Главный судья';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('add_judge'.tr(), style: AppTextStyles.h3),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'full_name'.tr(),
              labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 16),
          DropdownButton<String>(
            value: _rank,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(value: 'Главный судья', child: Text('Главный судья')),
              DropdownMenuItem(value: 'Судья', child: Text('Судья')),
              DropdownMenuItem(value: 'Помощник судьи', child: Text('Помощник судьи')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _rank = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr(), style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;
            widget.onSave(Judge()
              ..fullName = _nameController.text
              ..rank = _rank);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text('save'.tr(), style: AppTextStyles.button),
        ),
      ],
    );
  }
}