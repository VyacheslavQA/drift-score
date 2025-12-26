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
import 'team_weighing_screen.dart';

class WeighingDetailsScreen extends ConsumerWidget {
  final CompetitionLocal competition;
  final WeighingLocal weighing;

  const WeighingDetailsScreen({
    super.key,
    required this.competition,
    required this.weighing,
  });

  // Проверка: зональная система для зимней мормышки
  bool get isZonalSystem {
    return competition.fishingType == 'ice_spoon' &&
        competition.scoringMethod == 'zoned_placement';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamProvider(competition.id));
    final resultsAsync = ref.watch(weighingResultsProvider(weighing.id));

    final date = competition.startTime.add(Duration(days: weighing.dayNumber - 1));
    final dateStr = DateFormat('dd.MM.yyyy').format(date);
    final timeStr = DateFormat('HH:mm').format(weighing.weighingTime);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${'weighing_day'.tr()} ${weighing.dayNumber} #${weighing.weighingNumber}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Информация о взвешивании
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$dateStr $timeStr',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    '${'weighing_number'.tr()}: ${weighing.weighingNumber}',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),

            // Список команд или участников
            Expanded(
              child: teamsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (teams) {
                  if (teams.isEmpty) {
                    return Center(
                      child: Text(
                        'weighing_no_teams'.tr(),
                        style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return resultsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (results) {
                      // Для зональной системы показываем участников по зонам
                      if (isZonalSystem) {
                        return _buildZonalMembersList(context, ref, teams, results);
                      }

                      // Для обычной системы показываем команды
                      return _buildTeamsList(context, ref, teams, results);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Обычный список команд
  Widget _buildTeamsList(BuildContext context, WidgetRef ref, List<TeamLocal> teams, List<WeighingResultLocal> results) {
    final resultsMap = {for (var r in results) r.teamLocalId: r};

    // Сортируем команды по секторам
    final sortedTeams = List<TeamLocal>.from(teams);
    sortedTeams.sort((a, b) {
      final sectorA = a.sector ?? 999999;
      final sectorB = b.sector ?? 999999;
      return sectorA.compareTo(sectorB);
    });

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(weighingResultsProvider(weighing.id));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: sortedTeams.length,
        itemBuilder: (context, index) {
          final team = sortedTeams[index];
          final result = resultsMap[team.id];
          return _buildTeamCard(context, team, result);
        },
      ),
    );
  }

  // Зональный список участников
  Widget _buildZonalMembersList(BuildContext context, WidgetRef ref, List<TeamLocal> teams, List<WeighingResultLocal> results) {
    // Группируем участников по зонам
    final zones = ['A', 'B', 'C'];
    final membersByZone = <String, List<_MemberInfo>>{};

    for (var zone in zones) {
      membersByZone[zone] = [];
    }

    // Собираем всех участников с их зонами
    for (var team in teams) {
      for (var draw in team.memberDraws) {
        if (draw.zone != null) {
          final member = team.members[draw.memberIndex];
          final result = results.firstWhere(
                (r) => r.teamLocalId == team.id &&
                r.memberIndex == draw.memberIndex &&
                r.zone == draw.zone,
            orElse: () => WeighingResultLocal()..id = -1, // Пустой результат
          );

          membersByZone[draw.zone]!.add(_MemberInfo(
            team: team,
            member: member,
            memberIndex: draw.memberIndex,
            zone: draw.zone!,
            result: result.id != -1 ? result : null,
          ));
        }
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(weighingResultsProvider(weighing.id));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: zones.length,
        itemBuilder: (context, zoneIndex) {
          final zone = zones[zoneIndex];
          final members = membersByZone[zone]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок зоны
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingSmall,
                  horizontal: AppDimensions.paddingSmall,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Text(
                        '${'zone'.tr()} $zone',
                        style: AppTextStyles.h3.copyWith(color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      '${members.length} ${'participants'.tr()}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              // Список участников зоны
              ...members.map((memberInfo) => _buildMemberCard(context, memberInfo)),

              const SizedBox(height: AppDimensions.paddingMedium),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamLocal team, WeighingResultLocal? result) {
    final hasResult = result != null;
    final sectorText = team.sector != null ? '${'sector'.tr()} ${team.sector}' : '';

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: ListTile(
        onTap: () => _navigateToTeamWeighing(context, team, result),
        leading: CircleAvatar(
          backgroundColor: hasResult ? AppColors.success : AppColors.textSecondary.withOpacity(0.3),
          child: Icon(
            hasResult ? Icons.check : Icons.scale,
            color: hasResult ? Colors.white : AppColors.textSecondary,
          ),
        ),
        title: Text(
          team.name,
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sectorText.isNotEmpty)
              Text(
                sectorText,
                style: AppTextStyles.caption,
              ),
            if (hasResult) ...[
              const SizedBox(height: 4),
              Text(
                '${'weighing_fish_count'.tr()}: ${result.fishCount} | '
                    '${'weighing_total_weight'.tr()}: ${result.totalWeight.toStringAsFixed(3)} kg',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ],
        ),
        trailing: Icon(
          hasResult ? Icons.edit : Icons.arrow_forward_ios,
          color: hasResult ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, _MemberInfo memberInfo) {
    final hasResult = memberInfo.result != null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: ListTile(
        onTap: () => _navigateToMemberWeighing(context, memberInfo),
        leading: CircleAvatar(
          backgroundColor: hasResult ? AppColors.success : AppColors.textSecondary.withOpacity(0.3),
          child: Icon(
            hasResult ? Icons.check : Icons.scale,
            color: hasResult ? Colors.white : AppColors.textSecondary,
          ),
        ),
        title: Text(
          memberInfo.member.fullName,
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${memberInfo.team.name} | ${memberInfo.member.rank}',
              style: AppTextStyles.caption,
            ),
            if (hasResult) ...[
              const SizedBox(height: 4),
              Text(
                '${'weighing_fish_count'.tr()}: ${memberInfo.result!.fishCount} | '
                    '${'weighing_total_weight'.tr()}: ${memberInfo.result!.totalWeight.toStringAsFixed(3)} kg | '
                    '${'place_in_zone'.tr()}: ${memberInfo.result!.placeInZone}',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ],
        ),
        trailing: Icon(
          hasResult ? Icons.edit : Icons.arrow_forward_ios,
          color: hasResult ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  void _navigateToTeamWeighing(BuildContext context, TeamLocal team, WeighingResultLocal? result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamWeighingScreen(
          competition: competition,
          weighing: weighing,
          team: team,
          existingResult: result,
        ),
      ),
    );
  }

  void _navigateToMemberWeighing(BuildContext context, _MemberInfo memberInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamWeighingScreen(
          competition: competition,
          weighing: weighing,
          team: memberInfo.team,
          existingResult: memberInfo.result,
          // TODO: Добавим параметры memberIndex и zone в следующем файле
        ),
      ),
    );
  }
}

// Вспомогательный класс для хранения информации об участнике
class _MemberInfo {
  final TeamLocal team;
  final TeamMember member;
  final int memberIndex;
  final String zone;
  final WeighingResultLocal? result;

  _MemberInfo({
    required this.team,
    required this.member,
    required this.memberIndex,
    required this.zone,
    this.result,
  });
}