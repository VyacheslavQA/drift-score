import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';

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

                // 1. Создать соревнование (главная кнопка)
                _buildMainButton(
                  context: context,
                  icon: Icons.add_circle_outline,
                  label: 'create_competition'.tr(),
                  borderColor: AppColors.primary,
                  iconBackgroundColor: AppColors.primary,
                  iconColor: AppColors.text,
                  onPressed: () {
                    _showCreateCompetitionDialog(context);
                  },
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                // 2. Просмотр протоколов
                _buildMainButton(
                  context: context,
                  icon: Icons.list,
                  label: 'view_protocols'.tr(),
                  borderColor: AppColors.secondary,
                  iconBackgroundColor: AppColors.secondary,
                  iconColor: AppColors.background,
                  onPressed: () {
                    _showNotImplemented(context, 'view_protocols'.tr());
                  },
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                // 3. Статистика
                _buildMainButton(
                  context: context,
                  icon: Icons.bar_chart,
                  label: 'statistics'.tr(),
                  borderColor: AppColors.upcoming,
                  iconBackgroundColor: AppColors.upcoming,
                  iconColor: AppColors.text,
                  onPressed: () {
                    _showNotImplemented(context, 'statistics'.tr());
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

  // Диалог для создания соревнования
  void _showCreateCompetitionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.text,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Expanded(
                      child: Text(
                        'create_competition'.tr(),
                        style: AppTextStyles.h2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.textTertiary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingLarge),

                // Описание
                Text(
                  'create_competition_description'.tr(),
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.paddingLarge),

                // Кнопка: Ввести код
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showNotImplemented(context, 'enter_code'.tr());
                  },
                  icon: const Icon(Icons.qr_code, size: AppDimensions.iconMedium),
                  label: Text('enter_code'.tr()),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surfaceMedium,
                    foregroundColor: AppColors.text,
                    side: BorderSide(
                      color: AppColors.borderMedium,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    textStyle: AppTextStyles.buttonMedium,
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingMedium - 4),

                // Разделитель
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.borderLight,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                      child: Text(
                        'or'.tr(),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.borderLight,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingMedium - 4),

                // Кнопка: Купить код
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowUpcoming,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showNotImplemented(context, 'buy_code'.tr());
                    },
                    icon: const Icon(Icons.shopping_cart, size: 20),
                    label: Text('buy_code'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.upcoming,
                      foregroundColor: AppColors.text,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      textStyle: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainButton({
    required BuildContext context,
    required IconData icon,
    required String label,
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
                  width: AppDimensions.buttonIconSize,
                  height: AppDimensions.buttonIconSize,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(AppDimensions.buttonIconRadius),
                  ),
                  child: Icon(icon, color: iconColor, size: AppDimensions.iconLarge),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Text(label, style: AppTextStyles.buttonLarge),
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