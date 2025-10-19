import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import 'select_fishing_type_screen.dart';
import 'public_competitions_screen.dart';
import 'admin_panel_screen.dart';
import 'public_select_fishing_type_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _logoTapCount = 0;
  DateTime? _lastTapTime;

  void _onLogoTap() {
    final now = DateTime.now();

    // Сброс счётчика если прошло больше 2 секунд
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _logoTapCount = 0;
    }

    _lastTapTime = now;
    _logoTapCount++;

    print('🔵 Logo tap: $_logoTapCount');

    if (_logoTapCount == 3) {
      _logoTapCount = 0;
      _lastTapTime = null;

      // Показываем диалог ввода пароля
      _showAdminPasswordDialog();
    }
  }

  Future<void> _showAdminPasswordDialog() async {
    final controller = TextEditingController();
    bool isLoading = false;
    String? errorMessage;
    bool isPasswordVisible = false;

    // ✅ ПРИНУДИТЕЛЬНО ОБНОВЛЯЕМ Remote Config ПЕРЕД ПОКАЗОМ ДИАЛОГА
    print('🔄 Forcing Remote Config refresh...');
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero, // БЕЗ КЭША!
    ));
    await remoteConfig.fetchAndActivate();
    print('✅ Remote Config refreshed');

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shield,
                color: AppColors.primary,
                size: AppDimensions.iconMedium,
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Flexible(
                child: Text(
                  'admin_password'.tr(),
                  style: AppTextStyles.h3,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                obscureText: !isPasswordVisible,
                autofocus: true,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: 'admin_password'.tr(),
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  errorText: errorMessage,
                ),
                onSubmitted: (_) async {
                  if (!isLoading) {
                    await _checkPassword(controller.text, dialogContext, setState, () {
                      isLoading = true;
                      errorMessage = null;
                    }, (error) {
                      isLoading = false;
                      errorMessage = error;
                    });
                  }
                },
              ),
              if (isLoading) ...[
                const SizedBox(height: 16),
                CircularProgressIndicator(color: AppColors.primary),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                await _checkPassword(controller.text, dialogContext, setState, () {
                  isLoading = true;
                  errorMessage = null;
                }, (error) {
                  isLoading = false;
                  errorMessage = error;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('login'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkPassword(
      String password,
      BuildContext dialogContext,
      StateSetter setState,
      Function() setLoading,
      Function(String) setError,
      ) async {
    if (password.isEmpty) {
      setState(() {
        setError('field_required'.tr());
      });
      return;
    }

    setState(() {
      setLoading();
    });

    try {
      // ✅ Получаем пароль из Remote Config (УЖЕ ОБНОВЛЁН выше)
      final remoteConfig = FirebaseRemoteConfig.instance;
      final adminPassword = remoteConfig.getString('admin_password');

      print('🔐 Checking password...');
      print('   Entered: ${password.substring(0, min(3, password.length))}***');
      print('   Expected: ${adminPassword.substring(0, min(3, adminPassword.length))}***');

      if (password == adminPassword) {
        print('✅ Password correct - opening Admin Panel');

        // Закрываем диалог
        Navigator.pop(dialogContext);

        // Небольшая задержка для завершения анимации
        await Future.delayed(Duration(milliseconds: 300));

        // Открываем админ-панель
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminPanelScreen()),
          );
        }
      } else {
        print('❌ Password incorrect');
        setState(() {
          setError('invalid_master_code'.tr());
        });
      }
    } catch (e) {
      print('❌ Error checking password: $e');
      setState(() {
        setError('error_checking_code'.tr());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    // ✅ СКРЫТЫЙ ВХОД - ТРОЙНОЙ ТАП ПО ЛОГОТИПУ
                    GestureDetector(
                      onTap: _onLogoTap,
                      child: Container(
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
                      MaterialPageRoute(builder: (_) => const PublicSelectFishingTypeScreen()),
                    );
                  },
                ),

                const SizedBox(height: 40),
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
}
