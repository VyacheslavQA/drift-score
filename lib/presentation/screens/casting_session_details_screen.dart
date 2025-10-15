import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/casting_session_local.dart';
import '../../data/models/local/casting_result_local.dart';
import '../../data/models/local/team_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/casting_provider.dart';
import '../providers/team_provider.dart';
import 'participant_casting_screen.dart';

class CastingSessionDetailsScreen extends ConsumerWidget {
  final CompetitionLocal competition;
  final CastingSessionLocal session;

  const CastingSessionDetailsScreen({
    super.key,
    required this.competition,
    required this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamProvider(competition.id));
    final resultsAsync = ref.watch(castingResultsProvider(session.id));

    final dateStr = DateFormat('dd.MM.yyyy').format(session.sessionTime);
    final timeStr = DateFormat('HH:mm').format(session.sessionTime);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${'casting_attempt'.tr()} ${session.sessionNumber}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Информация о сессии
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
                    '${'casting_day'.tr()}: ${session.dayNumber} | '
                        '${'casting_attempt'.tr()}: ${session.sessionNumber}',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),

            // Список участников
            Expanded(
              child: teamsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (teams) {
                  if (teams.isEmpty) {
                    return Center(
                      child: Text(
                        'no_participants_yet'.tr(),
                        style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  // Получаем всех участников из команд (для кастинга каждый участник отдельно)
                  final participants = <ParticipantInfo>[];
                  for (var team in teams) {
                    for (var member in team.members) {
                      participants.add(ParticipantInfo(
                        teamId: team.id,
                        memberId: member.fullName, // Используем имя как ID
                        fullName: member.fullName,
                        rod: member.rod ?? '',
                        line: member.line ?? competition.commonLine ?? '',
                      ));
                    }
                  }

                  if (participants.isEmpty) {
                    return Center(
                      child: Text(
                        'no_participants_yet'.tr(),
                        style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return resultsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (results) {
                      // Создаём Map для быстрого поиска результатов
                      final resultsMap = {
                        for (var r in results) r.participantFullName: r
                      };

                      return RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(castingResultsProvider(session.id));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                          itemCount: participants.length,
                          itemBuilder: (context, index) {
                            final participant = participants[index];
                            final result = resultsMap[participant.fullName];
                            return _buildParticipantCard(
                              context,
                              participant,
                              result,
                            );
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

  Widget _buildParticipantCard(
      BuildContext context,
      ParticipantInfo participant,
      CastingResultLocal? result,
      ) {
    final hasResult = result != null;
    final distance = hasResult && result.attempts.isNotEmpty
        ? result.attempts
        .firstWhere(
          (a) => a.attemptNumber == session.sessionNumber,
      orElse: () => CastingAttempt()
        ..id = ''
        ..attemptNumber = 0
        ..distance = 0.0
        ..isValid = false
        ..timestamp = DateTime.now(),
    )
        .distance
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: ListTile(
        onTap: () => _navigateToParticipantCasting(
          context,
          participant,
          result,
        ),
        leading: CircleAvatar(
          backgroundColor: hasResult && distance > 0
              ? AppColors.success
              : AppColors.textSecondary.withOpacity(0.3),
          child: Icon(
            hasResult && distance > 0 ? Icons.check : Icons.gps_fixed,
            color: hasResult && distance > 0
                ? Colors.white
                : AppColors.textSecondary,
          ),
        ),
        title: Text(
          participant.fullName,
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'rod'.tr()}: ${participant.rod}',
              style: AppTextStyles.caption,
            ),
            if (hasResult && distance > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${'casting_distance'.tr()}: ${distance.toStringAsFixed(2)} м',
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ],
        ),
        trailing: Icon(
          hasResult && distance > 0 ? Icons.edit : Icons.arrow_forward_ios,
          color: hasResult && distance > 0
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ),
    );
  }

  void _navigateToParticipantCasting(
      BuildContext context,
      ParticipantInfo participant,
      CastingResultLocal? result,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantCastingScreen(
          competition: competition,
          session: session,
          participant: participant,
          existingResult: result,
        ),
      ),
    );
  }
}

// Вспомогательный класс для хранения информации об участнике
class ParticipantInfo {
  final int teamId;
  final String memberId;
  final String fullName;
  final String rod;
  final String line;

  ParticipantInfo({
    required this.teamId,
    required this.memberId,
    required this.fullName,
    required this.rod,
    required this.line,
  });
}