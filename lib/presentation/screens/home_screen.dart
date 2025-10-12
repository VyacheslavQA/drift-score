import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import 'select_fishing_type_screen.dart';
import 'public_competitions_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium - 4),
          child: Image.asset(
            'assets/images/logo.png',
            width: AppDimensions.logoSmall,
            height: AppDimensions.logoSmall,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.emoji_events,
                color: AppColors.primary,
                size: AppDimensions.logoSmall,
              );
            },
          ),
        ),
        title: const Text(
          'Drift Score',
          style: AppTextStyles.h2,
        ),
        actions: [
          PopupMenuButton<Locale>(
            icon: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium - 4,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceMedium,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(
                  color: AppColors.borderDark,
                  width: 1,
                ),
              ),
              child: Text(
                context.locale.languageCode.toUpperCase(),
                style: AppTextStyles.language,
              ),
            ),
            onSelected: (Locale locale) {
              context.setLocale(locale);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('ru'),
                child: Text('РУС'),
              ),
              const PopupMenuItem(
                value: Locale('en'),
                child: Text('ENG'),
              ),
              const PopupMenuItem(
                value: Locale('kk'),
                child: Text('ҚАЗ'),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingXLarge,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Герой-секция
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: AppDimensions.logoLarge,
                      height: AppDimensions.logoLarge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowPrimary,
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: AppDimensions.logoLarge,
                          height: AppDimensions.logoLarge,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.emoji_events,
                              size: AppDimensions.iconXLarge,
                              color: AppColors.text,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingLarge),
                    Text(
                      'home_banner_title'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium - 4),
                    Text(
                      'home_banner_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // 1. Я организатор
                _buildRoleButton(
                  context: context,
                  icon: Icons.shield_outlined,
                  title: 'i_am_organizer'.tr(),
                  subtitle: 'organizer_description'.tr(),
                  borderColor: AppColors.primary,
                  iconBackgroundColor: AppColors.primary,
                  iconColor: AppColors.text,
                  onPressed: () {
                    // Переход на экран выбора типа рыбалки
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SelectFishingTypeScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                // 2. Я спортсмен/зритель
                _buildRoleButton(
                  context: context,
                  icon: Icons.visibility_outlined,
                  title: 'i_am_athlete'.tr(),
                  subtitle: 'athlete_description'.tr(),
                  borderColor: AppColors.secondary,
                  iconBackgroundColor: AppColors.secondary,
                  iconColor: AppColors.background,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PublicCompetitionsScreen()),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Админ-панель (внизу)
                Container(
                  padding: const EdgeInsets.only(top: AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      _showNotImplemented(context, 'admin_panel'.tr());
                    },
                    icon: Icon(
                      Icons.shield,
                      size: AppDimensions.iconSmall,
                      color: AppColors.textTertiary,
                    ),
                    label: Text(
                      'admin_panel'.tr(),
                      style: AppTextStyles.bodyMedium,
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingMedium - 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color borderColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: borderColor, width: 3),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Icon(icon, color: iconColor, size: 32),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: borderColor,
                  size: AppDimensions.paddingLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - ${'in_development'.tr()}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
    );
  }
}