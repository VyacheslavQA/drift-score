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
  final String accessCode; // Код передаётся из EnterCodeScreen

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
  int _durationHours = 72;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('create_competition'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Показываем код доступа
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.key, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${'access_code'.tr()}: ',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary),
                    ),
                    Text(
                      widget.accessCode,
                      style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.paddingLarge),

              _buildTextField(
                controller: _nameController,
                label: 'competition_name'.tr(),
                validator: (v) =>
                v?.isEmpty ?? true
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildTextField(
                controller: _cityController,
                label: 'city_or_region'.tr(),
                validator: (v) =>
                v?.isEmpty ?? true
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildTextField(
                controller: _lakeController,
                label: 'lake_name'.tr(),
                validator: (v) =>
                v?.isEmpty ?? true
                    ? 'field_required'.tr()
                    : null,
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildTextField(
                controller: _organizerController,
                label: 'organizer_name'.tr(),
                validator: (v) =>
                v?.isEmpty ?? true
                    ? 'field_required'.tr()
                    : null,
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

              _buildDateTimePicker(),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildDurationSelector(),
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
                    padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium),
                    ),
                  ),
                  child: Text('create'.tr(), style: AppTextStyles.button),
                ),
              ),
            ],
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

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: _selectDateTime,
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
                Text('start_time'.tr(), style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(_startTime),
                  style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary),
                ),
              ],
            ),
            Icon(Icons.calendar_today, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
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
          Text('duration'.tr(), style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [48, 72, 96].map((hours) {
              final isSelected = _durationHours == hours;
              return ChoiceChip(
                label: Text('$hours ${'hours'.tr()}'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _durationHours = hours);
                },
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary,
                labelStyle: AppTextStyles.body.copyWith(
                  color: isSelected ? AppColors.textPrimary : AppColors
                      .textSecondary,
                ),
              );
            }).toList(),
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
          Text('scoring_rules'.tr(), style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary)),
          SizedBox(height: 8),
          DropdownButton<String>(
            value: _scoringRules,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(
                  value: 'total_weight', child: Text('total_weight'.tr())),
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
        ..._judges
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final judge = entry.value;
          return Card(
            color: AppColors.surface,
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(judge.fullName, style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary)),
              subtitle: Text(judge.rank, style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary)),
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

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
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
        initialTime: TimeOfDay.fromDateTime(_startTime),
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
          _startTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  void _addJudge() {
    showDialog(
      context: context,
      builder: (context) =>
          _JudgeDialog(
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

    try {
      // Передаём accessCode в провайдер
      await ref.read(competitionProvider.notifier).createCompetition(
        name: _nameController.text,
        cityOrRegion: _cityController.text,
        lakeName: _lakeController.text,
        sectorsCount: int.parse(_sectorsController.text),
        startTime: _startTime,
        durationHours: _durationHours,
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
      // Обработка ошибки (код уже использован)
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