import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/weighing_local.dart';
import '../../data/models/local/weighing_result_local.dart';
import '../../data/models/local/team_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/weighing_provider.dart';
import 'weighing_confirmation_screen.dart';

class TeamWeighingScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final WeighingLocal weighing;
  final TeamLocal team;
  final WeighingResultLocal? existingResult;
  final int? memberIndex; // Для зональной системы
  final String? zone;      // Для зональной системы

  const TeamWeighingScreen({
    super.key,
    required this.competition,
    required this.weighing,
    required this.team,
    this.existingResult,
    this.memberIndex,
    this.zone,
  });

  @override
  ConsumerState<TeamWeighingScreen> createState() => _TeamWeighingScreenState();
}

class _TeamWeighingScreenState extends ConsumerState<TeamWeighingScreen> {
  late List<FishCatch> _fishes;
  bool _isReadOnly = false; // Режим просмотра (если есть подпись)
  final TextEditingController _placeInZoneController = TextEditingController();

  // Проверка: зональная система для зимней мормышки
  bool get isZonalSystem {
    return widget.competition.fishingType == 'ice_spoon' &&
        widget.competition.scoringMethod == 'zoned_placement';
  }

  @override
  void initState() {
    super.initState();
    // Если есть существующий результат, загружаем рыб
    if (widget.existingResult != null) {
      _fishes = List<FishCatch>.from(widget.existingResult!.fishes);
      // Если есть подпись - режим только просмотра
      _isReadOnly = widget.existingResult!.signatureBase64 != null &&
          widget.existingResult!.signatureBase64!.isNotEmpty;

      // Загружаем место в зоне (если есть)
      if (widget.existingResult!.placeInZone != null) {
        _placeInZoneController.text = widget.existingResult!.placeInZone.toString();
      }
    } else {
      _fishes = [];
      _isReadOnly = false;
    }
  }

  @override
  void dispose() {
    _placeInZoneController.dispose();
    super.dispose();
  }

  String _getFishTypeName(String fishType) {
    if (fishType.isEmpty) return 'weighing_fish_type'.tr();

    // Проверяем стандартные типы
    if (['carp', 'mirror_carp', 'grass_carp', 'silver_carp', 'other'].contains(fishType)) {
      return 'fish_type_$fishType'.tr();
    }

    // Произвольный тип
    return fishType;
  }

  String _getMemberDisplayName() {
    if (widget.memberIndex != null && widget.memberIndex! < widget.team.members.length) {
      return widget.team.members[widget.memberIndex!].fullName;
    }
    return widget.team.name;
  }

  @override
  Widget build(BuildContext context) {
    final totalWeight = _fishes.fold(0.0, (sum, f) => sum + f.weight);
    final avgWeight = _fishes.isEmpty ? 0.0 : totalWeight / _fishes.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isZonalSystem ? _getMemberDisplayName() : widget.team.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Информация о команде/участнике и взвешивании
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              color: _isReadOnly
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isZonalSystem ? _getMemberDisplayName() : widget.team.name,
                              style: AppTextStyles.h3,
                            ),
                            if (isZonalSystem) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.team.name,
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (_isReadOnly)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'result_confirmed'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  // Зона (для зональной системы)
                  if (isZonalSystem && widget.zone != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Text(
                            '${'zone'.tr()} ${widget.zone}',
                            style: AppTextStyles.bodyBold.copyWith(color: AppColors.secondary),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Сектор (для обычной системы)
                  if (!isZonalSystem && widget.team.sector != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${'sector'.tr()} ${widget.team.sector}',
                      style: AppTextStyles.body,
                    ),
                  ],

                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    '${'weighing_day'.tr()} ${widget.weighing.dayNumber} - '
                        '${'weighing_number'.tr()} ${widget.weighing.weighingNumber}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),

            // Список рыб
            Expanded(
              child: _fishes.isEmpty
                  ? _buildEmptyState()
                  : _isReadOnly
                  ? _buildReadOnlyList()
                  : _buildEditableList(),
            ),

            // Подпись (если есть)
            if (_isReadOnly && widget.existingResult?.signatureBase64 != null)
              _buildSignatureSection(),

            // Статистика и кнопка сохранения (только в режиме редактирования)
            if (!_isReadOnly)
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('weighing_fish_count'.tr(), '${_fishes.length}'),
                        _buildStatItem('weighing_total_weight'.tr(), '${totalWeight.toStringAsFixed(3)} kg'),
                        _buildStatItem('weighing_average_weight'.tr(), '${avgWeight.toStringAsFixed(3)} kg'),
                      ],
                    ),

                    // Поле "Место в зоне" для зональной системы
                    if (isZonalSystem) ...[
                      const SizedBox(height: AppDimensions.paddingMedium),
                      TextFormField(
                        controller: _placeInZoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'place_in_zone'.tr(),
                          hintText: 'enter_place_in_zone'.tr(),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.emoji_events),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppDimensions.paddingMedium),
                    ElevatedButton(
                      onPressed: _fishes.isNotEmpty ? _saveResult : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text('weighing_save_result'.tr()),
                    ),
                  ],
                ),
              ),

            // Статистика в режиме просмотра
            if (_isReadOnly)
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('weighing_fish_count'.tr(), '${_fishes.length}'),
                        _buildStatItem('weighing_total_weight'.tr(), '${totalWeight.toStringAsFixed(3)} kg'),
                        _buildStatItem('weighing_average_weight'.tr(), '${avgWeight.toStringAsFixed(3)} kg'),
                      ],
                    ),

                    // Показываем место в зоне (если есть)
                    if (isZonalSystem && widget.existingResult?.placeInZone != null) ...[
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events, color: AppColors.secondary),
                            const SizedBox(width: AppDimensions.paddingSmall),
                            Text(
                              '${'place_in_zone'.tr()}: ${widget.existingResult!.placeInZone}',
                              style: AppTextStyles.bodyBold.copyWith(color: AppColors.secondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.scale,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'weighing_no_fish'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          ElevatedButton.icon(
            onPressed: _addFish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: Text('weighing_add_fish'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: _fishes.length + 1,
      itemBuilder: (context, index) {
        if (index == _fishes.length) {
          return _buildAddFishButton();
        }
        return _buildFishCard(index);
      },
    );
  }

  Widget _buildReadOnlyList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: _fishes.length,
      itemBuilder: (context, index) {
        final fish = _fishes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                // Номер рыбы
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                // Информация о рыбе
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFishTypeName(fish.fishType),
                        style: AppTextStyles.bodyBold,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${'weighing_fish_length'.tr()}: ${fish.length.toStringAsFixed(1)} см',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                // Вес
                Text(
                  '${fish.weight.toStringAsFixed(3)} kg',
                  style: AppTextStyles.h3.copyWith(color: AppColors.success),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignatureSection() {
    final signatureBase64 = widget.existingResult!.signatureBase64!;
    final signatureBytes = base64Decode(signatureBase64);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sign_here'.tr(),
            style: AppTextStyles.bodyBold,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textSecondary, width: 1),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.memory(
                Uint8List.fromList(signatureBytes),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success, size: 16),
              const SizedBox(width: 4),
              Text(
                'result_confirmed'.tr(),
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFishCard(int index) {
    final fish = _fishes[index];
    final isCustomType = fish.fishType.isNotEmpty &&
        !['carp', 'mirror_carp', 'grass_carp', 'silver_carp', 'other'].contains(fish.fishType);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${'weighing_add_fish'.tr()} ${index + 1}',
                  style: AppTextStyles.bodyBold,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _removeFish(index),
                  icon: const Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Вид рыбы
            DropdownButtonFormField<String>(
              value: isCustomType ? 'other' : (fish.fishType.isEmpty ? null : fish.fishType),
              decoration: InputDecoration(
                labelText: 'weighing_fish_type'.tr(),
                hintText: 'weighing_enter_fish_type'.tr(),
                border: const OutlineInputBorder(),
              ),
              items: [
                'carp',
                'mirror_carp',
                'grass_carp',
                'silver_carp',
                'other',
              ].map((type) => DropdownMenuItem(
                value: type,
                child: Text('fish_type_$type'.tr()),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  if (value == 'other') {
                    fish.fishType = 'other';
                  } else {
                    fish.fishType = value ?? '';
                  }
                });
              },
            ),

            // Произвольный ввод вида рыбы
            if (fish.fishType == 'other' || isCustomType) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              TextFormField(
                initialValue: isCustomType ? fish.fishType : '',
                decoration: InputDecoration(
                  labelText: 'weighing_enter_custom_fish_type'.tr(),
                  hintText: 'weighing_enter_custom_fish_type'.tr(),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  fish.fishType = value.trim();
                  setState(() {});
                },
              ),
            ],

            const SizedBox(height: AppDimensions.paddingSmall),

            // Вес и длина
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: fish.weight > 0 ? fish.weight.toString() : '',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'weighing_fish_weight'.tr(),
                      hintText: 'weighing_enter_weight'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      fish.weight = double.tryParse(value) ?? 0.0;
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: TextFormField(
                    initialValue: fish.length > 0 ? fish.length.toString() : '',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'weighing_fish_length'.tr(),
                      hintText: 'weighing_enter_length'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      fish.length = double.tryParse(value) ?? 0.0;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFishButton() {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: InkWell(
        onTap: _addFish,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(
                'weighing_add_fish'.tr(),
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyBold),
      ],
    );
  }

  void _addFish() {
    final notifier = ref.read(weighingResultsProvider(widget.weighing.id).notifier);
    setState(() {
      _fishes.add(notifier.createEmptyFish());
    });
  }

  void _removeFish(int index) {
    setState(() {
      _fishes.removeAt(index);
    });
  }

  Future<void> _saveResult() async {
    if (_fishes.isEmpty) return;

    // Валидация места в зоне для зональной системы
    int? placeInZone;
    if (isZonalSystem) {
      final placeText = _placeInZoneController.text.trim();
      if (placeText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('enter_place_in_zone'.tr()),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      placeInZone = int.tryParse(placeText);
      if (placeInZone == null || placeInZone <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('invalid_place_in_zone'.tr()),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    // Вычисляем данные для экрана подтверждения
    final totalWeight = _fishes.fold(0.0, (sum, f) => sum + f.weight);
    final fishCount = _fishes.length;

    // Открываем экран подтверждения с подписью
    final signatureBase64 = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => WeighingConfirmationScreen(
          team: widget.team,
          fishes: _fishes,
          totalWeight: totalWeight,
          fishCount: fishCount,
        ),
      ),
    );

    // Если подпись получена, сохраняем результат
    if (signatureBase64 != null && mounted) {
      final notifier = ref.read(weighingResultsProvider(widget.weighing.id).notifier);
      final success = await notifier.saveTeamResult(
        teamId: widget.team.id,
        fishes: _fishes,
        signatureBase64: signatureBase64,
        placeInZone: placeInZone,
        memberIndex: widget.memberIndex,
        zone: widget.zone,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('weighing_success_save'.tr()),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('weighing_error_save'.tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}