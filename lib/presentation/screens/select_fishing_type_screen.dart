import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import 'my_competitions_screen.dart';

class SelectFishingTypeScreen extends StatelessWidget {
  const SelectFishingTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('select_fishing_type'.tr(), style: AppTextStyles.h2),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовок
              Text(
                'select_fishing_type_title'.tr(),
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'select_fishing_type_subtitle'.tr(),
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingXLarge),

              // Карточки типов рыбалки
              _buildFishingTypeCard(
                context: context,
                type: 'float',
                icon: '🎣',
                color: AppColors.primary,
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'spinning',
                icon: '🎣',
                color: Color(0xFFE74C3C),
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'carp',
                icon: '🐟',
                color: Color(0xFF27AE60),
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'feeder',
                icon: '🎣',
                color: Color(0xFFF39C12),
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'ice_jig',
                icon: '❄️',
                color: Color(0xFF3498DB),
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'ice_spoon',
                icon: '🧊',
                color: Color(0xFF5DADE2),
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'trout',
                icon: '🐠',
                color: Color(0xFF9B59B6),
              ),
              SizedBox(height: AppDimensions.paddingMedium),

              _buildFishingTypeCard(
                context: context,
                type: 'fly',
                icon: '🪰',
                color: Color(0xFF8E44AD),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFishingTypeCard({
    required BuildContext context,
    required String type,
    required String icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyCompetitionsScreen(fishingType: type),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: color, width: 3),
            ),
            child: Row(
              children: [
                // Иконка
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),

                // Текст
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'fishing_type_$type'.tr(),
                        style: AppTextStyles.h3,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'fishing_type_${type}_desc'.tr(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Стрелка
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}