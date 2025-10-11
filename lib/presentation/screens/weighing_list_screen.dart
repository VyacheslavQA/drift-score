import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/weighing_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/weighing_provider.dart';
import 'create_weighing_screen.dart';
import 'weighing_details_screen.dart';

class WeighingListScreen extends ConsumerWidget {
  final CompetitionLocal competition;

  const WeighingListScreen({
    super.key,
    required this.competition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weighingsAsync = ref.watch(weighingsProvider(competition.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('weighing_list_title'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: weighingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (weighings) {
            if (weighings.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(weighingsProvider(competition.id));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: weighings.length,
                itemBuilder: (context, index) {
                  final weighing = weighings[index];
                  return _buildWeighingCard(context, weighing);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateWeighing(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text('weighing_add'.tr()),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            'weighing_empty_state'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          ElevatedButton.icon(
            onPressed: () => _navigateToCreateWeighing(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: Text('weighing_add'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildWeighingCard(BuildContext context, WeighingLocal weighing) {
    final date = competition.startTime.add(Duration(days: weighing.dayNumber - 1));
    final dateStr = DateFormat('dd.MM.yyyy').format(date);
    final timeStr = DateFormat('HH:mm').format(weighing.weighingTime);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: ListTile(
        onTap: () => _navigateToWeighingDetails(context, weighing),
        leading: CircleAvatar(
          backgroundColor: weighing.isCompleted ? AppColors.success : AppColors.primary,
          child: Text(
            '${weighing.weighingNumber}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${'weighing_day'.tr()} ${weighing.dayNumber} - ${'weighing_number'.tr()} ${weighing.weighingNumber}',
          style: AppTextStyles.bodyBold,
        ),
        subtitle: Text(
          '$dateStr $timeStr',
          style: AppTextStyles.caption,
        ),
        trailing: Icon(
          weighing.isCompleted ? Icons.check_circle : Icons.arrow_forward_ios,
          color: weighing.isCompleted ? AppColors.success : AppColors.textSecondary,
        ),
      ),
    );
  }

  void _navigateToCreateWeighing(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWeighingScreen(competition: competition),
      ),
    );
  }

  void _navigateToWeighingDetails(BuildContext context, WeighingLocal weighing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeighingDetailsScreen(
          competition: competition,
          weighing: weighing,
        ),
      ),
    );
  }
}