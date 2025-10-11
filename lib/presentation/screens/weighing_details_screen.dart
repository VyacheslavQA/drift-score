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

            // Список команд
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
                      // Создаём Map для быстрого поиска результатов
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
}