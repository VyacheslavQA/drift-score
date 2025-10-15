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
        elevation: 0,
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
                style: AppTextStyles.h1.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'select_fishing_type_subtitle'.tr(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingXLarge),

              // Карточки типов рыбалки - сетка 2 колонки
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppDimensions.paddingMedium,
                crossAxisSpacing: AppDimensions.paddingMedium,
                childAspectRatio: 0.9, // Увеличено с 0.85 до 0.9
                children: [
                  _buildFishingTypeCard(
                    context: context,
                    type: 'float',
                    iconPath: 'assets/images/fishing_types/float_fishing.png',
                    color: AppColors.primary,
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'spinning',
                    iconPath: 'assets/images/fishing_types/spinning.png',
                    color: Color(0xFFE74C3C),
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'carp',
                    iconPath: 'assets/images/fishing_types/carp_fishing.png',
                    color: Color(0xFF27AE60),
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'feeder',
                    iconPath: 'assets/images/fishing_types/feeder.png',
                    color: Color(0xFFF39C12),
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'ice_jig',
                    iconPath: 'assets/images/fishing_types/ice_fishing.png',
                    color: Color(0xFF3498DB),
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'ice_spoon',
                    iconPath: 'assets/images/fishing_types/ice_fishing.png',
                    color: Color(0xFF5DADE2),
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'trout',
                    iconPath: 'assets/images/fishing_types/other.png',
                    color: Color(0xFF9B59B6),
                  ),
                  _buildFishingTypeCard(
                    context: context,
                    type: 'fly',
                    iconPath: 'assets/images/fishing_types/fly_fishing.png',
                    color: Color(0xFF8E44AD),
                  ),
                ],
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
    required String iconPath,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 16,
            offset: Offset(0, 6),
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
            padding: EdgeInsets.all(AppDimensions.paddingSmall), // Уменьшено с paddingMedium
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: color.withOpacity(0.3), width: 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.05),
                  color.withOpacity(0.02),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка с анимацией
                Container(
                  width: 70, // Уменьшено с 80
                  height: 70, // Уменьшено с 80
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10), // Уменьшено с 12
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    color: color,
                  ),
                ),
                SizedBox(height: 8), // Уменьшено с paddingMedium

                // Текст
                Text(
                  'fishing_type_$type'.tr(),
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 15, // Уменьшено с 16
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2), // Уменьшено с 4
                Text(
                  'fishing_type_${type}_desc'.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10, // Уменьшено с 11
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6), // Уменьшено с 8

                // Индикатор
                Container(
                  width: 35, // Уменьшено с 40
                  height: 2.5, // Уменьшено с 3
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}