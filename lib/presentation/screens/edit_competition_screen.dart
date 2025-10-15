import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/competition_provider.dart';
import '../../data/models/local/competition_local.dart';

class EditCompetitionScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const EditCompetitionScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  ConsumerState<EditCompetitionScreen> createState() => _EditCompetitionScreenState();
}

class _EditCompetitionScreenState extends ConsumerState<EditCompetitionScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _lakeController;
  late final TextEditingController _organizerController;
  late final TextEditingController _sectorsController;
  late final TextEditingController _sectorsPerZoneController;
  late final TextEditingController _commonLineController;

  late DateTime _startTime;
  late DateTime _finishTime;

  late String _scoringMethod;
  late String _sectorStructure;
  late String _zonedType;
  late int _zonesCount;
  late int _attemptsCount;

  final List<TextEditingController> _lakeNameControllers = [];
  late List<Judge> _judges;

  bool get _isCasting => widget.competition.fishingType == 'casting';

  @override
  void initState() {
    super.initState();

    // Инициализация контроллеров с существующими данными
    _nameController = TextEditingController(text: widget.competition.name);
    _cityController = TextEditingController(text: widget.competition.cityOrRegion);
    _lakeController = TextEditingController(text: widget.competition.lakeName);
    _organizerController = TextEditingController(text: widget.competition.organizerName);
    _sectorsController = TextEditingController(text: widget.competition.sectorsCount.toString());
    _sectorsPerZoneController = TextEditingController(text: widget.competition.sectorsPerZone?.toString() ?? '8');
    _commonLineController = TextEditingController(text: widget.competition.commonLine ?? '');

    // Инициализация дат
    _startTime = widget.competition.startTime;
    _finishTime = widget.competition.finishTime;

    // Инициализация настроек
    _scoringMethod = widget.competition.scoringMethod;
    _sectorStructure = widget.competition.sectorStructure ?? 'simple';
    _zonedType = widget.competition.zonedType ?? 'single_lake';
    _zonesCount = widget.competition.zonesCount ?? 3;
    _attemptsCount = widget.competition.attemptsCount ?? 3;

    // Инициализация судей (копируем список)
    _judges = List<Judge>.from(widget.competition.judges);

    // Инициализация контроллеров озёр
    _initializeLakeNameControllers();
  }

  void _initializeLakeNameControllers() {
    _lakeNameControllers.clear();
    final existingLakeNames = widget.competition.lakeNames ?? [];

    for (int i = 0; i < 4; i++) {
      final lakeName = i < existingLakeNames.length ? existingLakeNames[i] : '';
      _lakeNameControllers.add(TextEditingController(text: lakeName));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _lakeController.dispose();
    _organizerController.dispose();
    _sectorsController.dispose();
    _sectorsPerZoneController.dispose();
    _commonLineController.dispose();
    for (var controller in _lakeNameControllers) {
      controller.dispose();
    }
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

  int get _totalSectors {
    if (_isCasting) return 0;

    if (_sectorStructure == 'simple') {
      return int.tryParse(_sectorsController.text) ?? 0;
    } else if (_zonedType == 'single_lake') {
      return int.tryParse(_sectorsController.text) ?? 0;
    } else {
      return _zonesCount * (int.tryParse(_sectorsPerZoneController.text) ?? 0);
    }
  }

  int get _sectorsPerZoneCalculated {
    if (_sectorStructure == 'zoned' && _zonedType == 'single_lake') {
      final total = int.tryParse(_sectorsController.text) ?? 0;
      return total > 0 ? (total / _zonesCount).floor() : 0;
    }
    return int.tryParse(_sectorsPerZoneController.text) ?? 0;
  }

  String _pluralize(int count, String one, String few, String many) {
    final remainder10 = count % 10;
    final remainder100 = count % 100;

    if (remainder10 == 1 && remainder100 != 11) {
      return one;
    } else if (remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20)) {
      return few;
    } else {
      return many;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('edit_competition'.tr(), style: AppTextStyles.h3),
            Text(
              'fishing_type_${widget.competition.fishingType}'.tr(),
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
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
                // Код доступа (только для отображения, нельзя редактировать)
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.key, color: AppColors.textSecondary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${'access_code'.tr()}: ',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        widget.competition.accessCode ?? 'N/A',
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.textSecondary),
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

                if (!_isCasting && (_sectorStructure == 'simple' || (_sectorStructure == 'zoned' && _zonedType == 'single_lake')))
                  _buildTextField(
                    controller: _lakeController,
                    label: 'lake_name'.tr(),
                    validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                  ),

                if (_isCasting)
                  _buildTextField(
                    controller: _lakeController,
                    label: 'venue_name'.tr(),
                    validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                  ),

                if (!_isCasting && (_sectorStructure == 'simple' || (_sectorStructure == 'zoned' && _zonedType == 'single_lake')))
                  SizedBox(height: AppDimensions.paddingMedium),

                if (_isCasting)
                  SizedBox(height: AppDimensions.paddingMedium),

                _buildTextField(
                  controller: _organizerController,
                  label: 'organizer_name'.tr(),
                  validator: (v) => v?.isEmpty ?? true ? 'field_required'.tr() : null,
                ),
                SizedBox(height: AppDimensions.paddingLarge),

                _buildStartTimePicker(),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildFinishTimePicker(),
                SizedBox(height: AppDimensions.paddingMedium),

                _buildDurationInfo(),
                SizedBox(height: AppDimensions.paddingLarge),

                if (_isCasting) ...[
                  _buildAttemptsCountSelector(),
                  SizedBox(height: AppDimensions.paddingLarge),
                ],

                if (_isCasting) ...[
                  _buildCommonLineField(),
                  SizedBox(height: AppDimensions.paddingLarge),
                ],

                if (_isCasting)
                  _buildCastingScoringMethodSelector()
                else
                  _buildScoringMethodSelector(),

                SizedBox(height: AppDimensions.paddingLarge),

                if (!_isCasting) ...[
                  _buildSectorStructureSelector(),
                  SizedBox(height: AppDimensions.paddingMedium),
                ],

                if (!_isCasting && _sectorStructure == 'zoned') ...[
                  _buildZonedTypeSelector(),
                  SizedBox(height: AppDimensions.paddingMedium),
                  _buildZonesCountSelector(),
                  SizedBox(height: AppDimensions.paddingMedium),
                ],

                if (!_isCasting && _sectorStructure == 'simple')
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

                if (!_isCasting && _sectorStructure == 'zoned' && _zonedType == 'single_lake')
                  _buildTextField(
                    controller: _sectorsController,
                    label: 'total_sectors_label'.tr(),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'field_required'.tr();
                      final num = int.tryParse(v!);
                      if (num == null || num <= 0) return 'invalid_number'.tr();
                      return null;
                    },
                  ),

                if (!_isCasting && _sectorStructure == 'zoned' && _zonedType == 'multiple_lakes')
                  _buildTextField(
                    controller: _sectorsPerZoneController,
                    label: 'sectors_per_zone_label'.tr(),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'field_required'.tr();
                      final num = int.tryParse(v!);
                      if (num == null || num <= 0) return 'invalid_number'.tr();
                      return null;
                    },
                  ),

                if (!_isCasting && _sectorStructure == 'zoned') ...[
                  SizedBox(height: AppDimensions.paddingMedium),
                  _buildZoneSummary(),
                ],

                if (!_isCasting && _sectorStructure == 'zoned' && _zonedType == 'multiple_lakes') ...[
                  SizedBox(height: AppDimensions.paddingMedium),
                  _buildLakeNamesInput(),
                ],

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
                    child: Text('save_changes'.tr(), style: AppTextStyles.button),
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

  Widget _buildAttemptsCountSelector() {
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
          Text('attempts_count'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
          SizedBox(height: 12),
          DropdownButton<int>(
            value: _attemptsCount,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(value: 1, child: Text('attempts_1'.tr())),
              DropdownMenuItem(value: 2, child: Text('attempts_2'.tr())),
              DropdownMenuItem(value: 3, child: Text('attempts_3'.tr())),
              DropdownMenuItem(value: 4, child: Text('attempts_4'.tr())),
              DropdownMenuItem(value: 5, child: Text('attempts_5'.tr())),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _attemptsCount = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommonLineField() {
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
          Row(
            children: [
              Text('common_line'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
              SizedBox(width: 8),
              Tooltip(
                message: 'common_line_hint'.tr(),
                child: Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: _commonLineController,
            decoration: InputDecoration(
              hintText: 'common_line_placeholder'.tr(),
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
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
          ),
          SizedBox(height: 8),
          Text(
            'common_line_description'.tr(),
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCastingScoringMethodSelector() {
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
          Text('scoring_method'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
          SizedBox(height: 12),
          DropdownButton<String>(
            value: _scoringMethod,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(value: 'best_distance', child: Text('scoring_best_distance'.tr())),
              DropdownMenuItem(value: 'average_distance', child: Text('scoring_average_distance'.tr())),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _scoringMethod = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoringMethodSelector() {
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
          Text('scoring_method'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
          SizedBox(height: 12),
          DropdownButton<String>(
            value: _scoringMethod,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(value: 'total_weight', child: Text('scoring_total_weight'.tr())),
              DropdownMenuItem(value: 'top_3_weight', child: Text('scoring_top_3_weight'.tr())),
              DropdownMenuItem(value: 'top_5_weight', child: Text('scoring_top_5_weight'.tr())),
              DropdownMenuItem(value: 'total_length', child: Text('scoring_total_length'.tr())),
              DropdownMenuItem(value: 'top_3_length', child: Text('scoring_top_3_length'.tr())),
              DropdownMenuItem(value: 'top_5_length', child: Text('scoring_top_5_length'.tr())),
              DropdownMenuItem(value: 'total_count', child: Text('scoring_total_count'.tr())),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _scoringMethod = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectorStructureSelector() {
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
          Text('sector_structure'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
          SizedBox(height: 12),
          RadioListTile<String>(
            title: Text('sector_simple'.tr(), style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            subtitle: Text('sector_simple_desc'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            value: 'simple',
            groupValue: _sectorStructure,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _sectorStructure = value!);
            },
          ),
          RadioListTile<String>(
            title: Text('sector_zoned'.tr(), style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            subtitle: Text('sector_zoned_desc'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            value: 'zoned',
            groupValue: _sectorStructure,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _sectorStructure = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildZonedTypeSelector() {
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
          Text('zoned_type'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
          SizedBox(height: 12),
          RadioListTile<String>(
            title: Text('zoned_single_lake'.tr(), style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            value: 'single_lake',
            groupValue: _zonedType,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _zonedType = value!);
            },
          ),
          RadioListTile<String>(
            title: Text('zoned_multiple_lakes'.tr(), style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
            value: 'multiple_lakes',
            groupValue: _zonedType,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _zonedType = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildZonesCountSelector() {
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
          Text('zones_count'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          SizedBox(height: 8),
          DropdownButton<int>(
            value: _zonesCount,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            items: [
              DropdownMenuItem(value: 2, child: Text('zones_2'.tr())),
              DropdownMenuItem(value: 3, child: Text('zones_3'.tr())),
              DropdownMenuItem(value: 4, child: Text('zones_4'.tr())),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _zonesCount = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildZoneSummary() {
    final zoneLetters = ['A', 'B', 'C', 'D'];
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Text(
                '${'total_sectors_label'.tr()}: $_totalSectors',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.success),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text('distribution'.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          SizedBox(height: 8),
          ...List.generate(_zonesCount, (index) {
            final startSector = index * _sectorsPerZoneCalculated + 1;
            final endSector = (index + 1) * _sectorsPerZoneCalculated;
            final lakeName = _zonedType == 'multiple_lakes' && _lakeNameControllers[index].text.isNotEmpty
                ? ' (${_lakeNameControllers[index].text})'
                : '';
            return Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                '• ${'zone_label'.tr().replaceAll('{zone}', zoneLetters[index])}$lakeName: ${'sectors_count'.tr()} $startSector-$endSector',
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLakeNamesInput() {
    final zoneLetters = ['A', 'B', 'C', 'D'];
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
          Text('lake_names'.tr(), style: AppTextStyles.bodyBold.copyWith(color: AppColors.textPrimary)),
          SizedBox(height: 12),
          ...List.generate(_zonesCount, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _lakeNameControllers[index],
                decoration: InputDecoration(
                  labelText: '${'zone_label'.tr().replaceAll('{zone}', zoneLetters[index])}',
                  labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.background,
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
                onChanged: (_) => setState(() {}),
              ),
            );
          }),
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
              subtitle: Text(judge.rank.tr(), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
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
      firstDate: DateTime(2020),
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
                SnackBar(content: Text('finish_before_start_error'.tr())),
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
        SnackBar(content: Text('finish_after_start_error'.tr())),
      );
      return;
    }

    try {
      final lakeNames = <String>[];
      if (!_isCasting && _sectorStructure == 'zoned' && _zonedType == 'multiple_lakes') {
        for (int i = 0; i < _zonesCount; i++) {
          lakeNames.add(_lakeNameControllers[i].text.trim());
        }
      }

      await ref.read(competitionProvider.notifier).updateCompetition(
        id: widget.competition.id,
        name: _nameController.text.trim(),
        cityOrRegion: _cityController.text.trim(),
        lakeName: _lakeController.text.trim(),
        sectorsCount: _totalSectors,
        startTime: _startTime,
        finishTime: _finishTime,
        scoringMethod: _scoringMethod,
        organizerName: _organizerController.text.trim(),
        judges: _judges,
        fishingType: widget.competition.fishingType,
        sectorStructure: _isCasting ? 'none' : _sectorStructure,
        zonedType: !_isCasting && _sectorStructure == 'zoned' ? _zonedType : null,
        zonesCount: !_isCasting && _sectorStructure == 'zoned' ? _zonesCount : null,
        sectorsPerZone: !_isCasting && _sectorStructure == 'zoned' && _zonedType == 'multiple_lakes' ? _sectorsPerZoneCalculated : null,
        lakeNames: lakeNames.isNotEmpty ? lakeNames : null,
        attemptsCount: _isCasting ? _attemptsCount : null,
        commonLine: _isCasting && _commonLineController.text.trim().isNotEmpty
            ? _commonLineController.text.trim()
            : null,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('competition_updated'.tr()),
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
  String _rank = 'judge_chief';

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
              DropdownMenuItem(value: 'judge_chief', child: Text('judge_chief'.tr())),
              DropdownMenuItem(value: 'judge_regular', child: Text('judge_regular'.tr())),
              DropdownMenuItem(value: 'judge_assistant', child: Text('judge_assistant'.tr())),
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