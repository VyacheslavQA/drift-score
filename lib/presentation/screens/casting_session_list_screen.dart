import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/casting_session_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/casting_provider.dart';
import 'create_casting_session_screen.dart';
import 'casting_session_details_screen.dart';

class CastingSessionListScreen extends ConsumerWidget {
  final CompetitionLocal competition;

  const CastingSessionListScreen({
    super.key,
    required this.competition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(castingSessionsProvider(competition.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('casting_sessions_title'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: sessionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (sessions) {
            if (sessions.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(castingSessionsProvider(competition.id));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return _buildSessionCard(context, session);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateSession(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text('casting_add_session'.tr()),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'casting_empty_state'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          ElevatedButton.icon(
            onPressed: () => _navigateToCreateSession(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: Text('casting_add_session'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, CastingSessionLocal session) {
    final dateStr = DateFormat('dd.MM.yyyy').format(session.sessionTime);
    final timeStr = DateFormat('HH:mm').format(session.sessionTime);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: ListTile(
        onTap: () => _navigateToSessionDetails(context, session),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            '${session.sessionNumber}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${'casting_attempt'.tr()} ${session.sessionNumber}',
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$dateStr $timeStr',
              style: AppTextStyles.caption,
            ),
            Text(
              '${'casting_day'.tr()} ${session.dayNumber}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _navigateToCreateSession(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCastingSessionScreen(competition: competition),
      ),
    );
  }

  void _navigateToSessionDetails(BuildContext context, CastingSessionLocal session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CastingSessionDetailsScreen(
          competition: competition,
          session: session,
        ),
      ),
    );
  }
}