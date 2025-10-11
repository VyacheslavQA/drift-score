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

class TeamWeighingScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final WeighingLocal weighing;
  final TeamLocal team;
  final WeighingResultLocal? existingResult;

  const TeamWeighingScreen({
    super.key,
    required this.competition,
    required this.weighing,
    required this.team,
    this.existingResult,
  });

  @override
  ConsumerState<TeamWeighingScreen> createState() => _TeamWeighingScreenState();
}

class _TeamWeighingScreenState extends ConsumerState<TeamWeighingScreen> {
  late List<FishCatch> _fishes;

  @override
  void initState() {
    super.initState();
    // Если есть существующий результат, загружаем рыб
    if (widget.existingResult != null) {
      _fishes = List<FishCatch>.from(widget.existingResult!.fishes);
    } else {
      _fishes = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalWeight = _fishes.fold(0.0, (sum, f) => sum + f.weight);
    final avgWeight = _fishes.isEmpty ? 0.0 : totalWeight / _fishes.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.team.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Информация о команде и взвешивании
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.team.name,
                    style: AppTextStyles.h3,
                  ),
                  if (widget.team.sector != null) ...[
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
                  : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: _fishes.length + 1,
                itemBuilder: (context, index) {
                  if (index == _fishes.length) {
                    return _buildAddFishButton();
                  }
                  return _buildFishCard(index);
                },
              ),
            ),

            // Статистика и кнопка сохранения
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

    final notifier = ref.read(weighingResultsProvider(widget.weighing.id).notifier);
    final success = await notifier.saveTeamResult(
      teamId: widget.team.id,
      fishes: _fishes,
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