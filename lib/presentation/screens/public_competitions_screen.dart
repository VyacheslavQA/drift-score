import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/competition_provider.dart';
import '../../data/models/local/competition_local.dart';

class PublicCompetitionsScreen extends ConsumerStatefulWidget {
  const PublicCompetitionsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PublicCompetitionsScreen> createState() => _PublicCompetitionsScreenState();
}

class _PublicCompetitionsScreenState extends ConsumerState<PublicCompetitionsScreen> {
  String _filter = 'all'; // all, active, completed

  @override
  void initState() {
    super.initState();
    // Загружаем ВСЕ соревнования (публичный просмотр)
    Future.microtask(() {
      ref.read(competitionProvider.notifier).loadAllCompetitions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final competitionsAsync = ref.watch(competitionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('public_competitions'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: competitionsAsync.when(
              data: (competitions) {
                final filtered = _filterCompetitions(competitions);
                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildCompetitionsList(filtered);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'error_loading_competitions'.tr(),
                  style: AppTextStyles.body.copyWith(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildFilterChip('all', 'all'.tr()),
          SizedBox(width: AppDimensions.paddingSmall),
          _buildFilterChip('active', 'active'.tr()),
          SizedBox(width: AppDimensions.paddingSmall),
          _buildFilterChip('completed', 'completed'.tr()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filter = value);
      },
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      labelStyle: AppTextStyles.body.copyWith(
        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildCompetitionsList(List<CompetitionLocal> competitions) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(competitionProvider.notifier).loadAllCompetitions();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          final competition = competitions[index];
          return _buildCompetitionCard(competition);
        },
      ),
    );
  }

  Widget _buildCompetitionCard(CompetitionLocal competition) {
    final statusColor = _getStatusColor(competition.status);
    final statusText = _getStatusText(competition.status);

    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: InkWell(
        onTap: () {
          // TODO: Переход к публичному просмотру протоколов
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('view_protocols_coming_soon'.tr())),
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      competition.name,
                      style: AppTextStyles.h3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Text(
                      statusText,
                      style: AppTextStyles.caption.copyWith(color: statusColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              _buildInfoRow(Icons.location_on, '${competition.cityOrRegion} • ${competition.lakeName}'),
              SizedBox(height: 4),
              _buildInfoRow(
                Icons.calendar_today,
                DateFormat('dd.MM.yyyy HH:mm').format(competition.startTime),
              ),
              SizedBox(height: 4),
              _buildInfoRow(Icons.access_time, '${competition.durationHours} ${'hours'.tr()}'),
              SizedBox(height: 4),
              _buildInfoRow(Icons.grid_on, '${competition.sectorsCount} ${'sectors'.tr()}'),
              if (competition.judges.isNotEmpty) ...[
                SizedBox(height: AppDimensions.paddingSmall),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Text(
                      '${competition.judges.length} ${'judges'.tr()}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'no_public_competitions'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'no_public_competitions_hint'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<CompetitionLocal> _filterCompetitions(List<CompetitionLocal> competitions) {
    if (_filter == 'all') return competitions;

    return competitions.where((c) {
      return _filter == 'active'
          ? c.status == 'active'
          : c.status == 'completed';
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'completed':
        return AppColors.textSecondary;
      case 'draft':
        return AppColors.upcoming;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'active'.tr();
      case 'completed':
        return 'completed'.tr();
      case 'draft':
        return 'draft'.tr();
      default:
        return status;
    }
  }
}