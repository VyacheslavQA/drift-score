import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/public_competitions_provider.dart';
import '../widgets/public_competition_card.dart';

class PublicCompetitionsListScreen extends ConsumerStatefulWidget {
  final String fishingType;

  const PublicCompetitionsListScreen({
    super.key,
    required this.fishingType,
  });

  @override
  ConsumerState<PublicCompetitionsListScreen> createState() => _PublicCompetitionsListScreenState();
}

class _PublicCompetitionsListScreenState extends ConsumerState<PublicCompetitionsListScreen> {
  CompetitionStatus _selectedStatus = CompetitionStatus.all;

  String get _fishingTypeTitle {
    switch (widget.fishingType) {
      case 'float':
        return 'fishing_type_float'.tr();
      case 'spinning':
        return 'fishing_type_spinning'.tr();
      case 'carp':
        return 'fishing_type_carp'.tr();
      case 'feeder':
        return 'fishing_type_feeder'.tr();
      case 'ice_jig':
        return 'fishing_type_ice_jig'.tr();
      case 'ice_spoon':
        return 'fishing_type_ice_spoon'.tr();
      case 'trout':
        return 'fishing_type_trout'.tr();
      case 'fly':
        return 'fishing_type_fly'.tr();
      case 'casting':
        return 'fishing_type_casting'.tr();
      default:
        return widget.fishingType;
    }
  }

  String _getStatusText(CompetitionStatus status) {
    switch (status) {
      case CompetitionStatus.all:
        return 'Все';
      case CompetitionStatus.active:
        return 'Активные';
      case CompetitionStatus.completed:
        return 'Завершённые';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = PublicCompetitionsFilter(
      fishingType: widget.fishingType,
      status: _selectedStatus,
    );

    final competitionsAsync = ref.watch(publicCompetitionsProvider(filter));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(_fishingTypeTitle, style: AppTextStyles.h2),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Фильтр по статусу
          _buildStatusFilter(),

          // Список соревнований
          Expanded(
            child: competitionsAsync.when(
              data: (competitions) {
                if (competitions.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(publicCompetitionsProvider(filter));
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppDimensions.paddingLarge),
                    itemCount: competitions.length,
                    itemBuilder: (context, index) {
                      return PublicCompetitionCard(
                        competition: competitions[index],
                      );
                    },
                  ),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'Ошибка загрузки',
                      style: AppTextStyles.h3,
                    ),
                    SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      error.toString(),
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimensions.paddingLarge),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(publicCompetitionsProvider(filter));
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Повторить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Статус:',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: CompetitionStatus.values.map((status) {
                  final isSelected = _selectedStatus == status;
                  return Padding(
                    padding: EdgeInsets.only(right: AppDimensions.paddingSmall),
                    child: FilterChip(
                      label: Text(_getStatusText(status)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                      backgroundColor: AppColors.surfaceLight,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.text : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      checkmarkColor: AppColors.text,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'Соревнований не найдено',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            _selectedStatus == CompetitionStatus.all
                ? 'Пока нет соревнований этого типа'
                : _selectedStatus == CompetitionStatus.active
                ? 'Нет активных соревнований'
                : 'Нет завершённых соревнований',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}