import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/weighing_local.dart';
import '../../data/models/local/weighing_result_local.dart';
import '../../data/models/local/team_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/weighing_provider.dart';
import '../providers/team_provider.dart';

class WeighingScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const WeighingScreen({
    super.key,
    required this.competition,
  });

  @override
  ConsumerState<WeighingScreen> createState() => _WeighingScreenState();
}

class _WeighingScreenState extends ConsumerState<WeighingScreen> {
  int _currentStep = 0;

  int? _selectedDay;
  DateTime? _selectedTime;
  int _weighingNumber = 1;

  int? _currentWeighingId;
  int? _selectedTeamId;
  final List<FishCatch> _fishes = [];
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('weighing_title'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
      ),
    );
  }

  Widget _buildStep1() {
    final totalDays = widget.competition.durationDays;

    return Padding(
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
            onPressed: _canStartWeighing() ? _startWeighing : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
            ),
            child: Text('weighing_start'.tr()),
          ),
        ],
      ),
    );
  }

  bool _canStartWeighing() {
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

  Future<void> _startWeighing() async {
    final notifier = ref.read(weighingsProvider(widget.competition.id).notifier);
    final weighingId = await notifier.createWeighingSession(
      dayNumber: _selectedDay!,
      weighingTime: _selectedTime!,
      weighingNumber: _weighingNumber,
    );

    if (weighingId != null) {
      setState(() {
        _currentWeighingId = weighingId;
        _currentStep = 1;
      });
    }
  }

  Widget _buildStep2() {
    final teamsAsync = ref.watch(teamProvider(widget.competition.id));
    final resultsAsync = ref.watch(weighingResultsProvider(_currentWeighingId!));

    return teamsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (teams) {
        return resultsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (results) {
            final weighedTeamIds = results.map((r) => r.teamLocalId).toSet();
            final availableTeams = teams.where((t) => !weighedTeamIds.contains(t.id)).toList();

            availableTeams.sort((a, b) {
              final sectorA = a.sector ?? 999999;
              final sectorB = b.sector ?? 999999;
              return _sortAscending ? sectorA.compareTo(sectorB) : sectorB.compareTo(sectorA);
            });

            if (availableTeams.isEmpty) {
              return _buildAllTeamsWeighed();
            }

            return _buildWeighingForm(availableTeams, teams);
          },
        );
      },
    );
  }

  Widget _buildAllTeamsWeighed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: AppColors.success),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'weighing_all_teams_weighed'.tr(),
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('weighing_complete_session'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildWeighingForm(List<TeamLocal> availableTeams, List<TeamLocal> allTeams) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          color: AppColors.primary.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'weighing_select_team'.tr(),
                      style: AppTextStyles.bodyBold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _sortAscending = !_sortAscending;
                      });
                    },
                    icon: Icon(
                      _sortAscending ? Icons.arrow_downward : Icons.arrow_upward,
                      color: AppColors.primary,
                    ),
                    tooltip: _sortAscending ? 'Сортировка 1→N' : 'Сортировка N→1',
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              DropdownButtonFormField<int>(
                value: _selectedTeamId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                hint: Text('weighing_select_team'.tr()),
                items: availableTeams
                    .map((team) => DropdownMenuItem(
                  value: team.id,
                  child: Text(
                    team.sector != null
                        ? '${team.name} (${'sector'.tr()} ${team.sector})'
                        : team.name,
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeamId = value;
                    _fishes.clear();
                  });
                },
              ),
            ],
          ),
        ),
        if (_selectedTeamId != null) ...[
          Expanded(
            child: _buildFishList(),
          ),
          _buildBottomBar(allTeams.firstWhere((t) => t.id == _selectedTeamId)),
        ] else ...[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Text(
                    'weighing_select_team'.tr(),
                    style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFishList() {
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
                child: Text('weighing_fish_types.$type'.tr()),
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

  Widget _buildBottomBar(TeamLocal team) {
    final totalWeight = _fishes.fold(0.0, (sum, f) => sum + f.weight);
    final avgWeight = _fishes.isEmpty ? 0.0 : totalWeight / _fishes.length;

    return Container(
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
      child: SafeArea(
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
    final notifier = ref.read(weighingResultsProvider(_currentWeighingId!).notifier);
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
    if (_selectedTeamId == null || _fishes.isEmpty) return;

    final notifier = ref.read(weighingResultsProvider(_currentWeighingId!).notifier);
    final success = await notifier.saveTeamResult(
      teamId: _selectedTeamId!,
      fishes: _fishes,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('weighing_success_save'.tr()),
          backgroundColor: AppColors.success,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _fishes.clear();
        _selectedTeamId = null;
      });
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