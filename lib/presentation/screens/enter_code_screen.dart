import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/competition_provider.dart';
import 'purchase_code_screen.dart';

class EnterCodeScreen extends ConsumerStatefulWidget {
  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends ConsumerState<EnterCodeScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('enter_code'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppDimensions.paddingXLarge),

            // Иконка
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
            ),

            SizedBox(height: AppDimensions.paddingLarge),

            // Заголовок
            Text(
              'enter_access_code'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),

            SizedBox(height: AppDimensions.paddingMedium),

            // Описание
            Text(
              'enter_code_description'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),

            SizedBox(height: AppDimensions.paddingXLarge),

            // Поле ввода кода
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(
                letterSpacing: 4,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'CARP-XXXX-XXXX',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 4,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide(color: AppColors.error, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide(color: AppColors.error, width: 2),
                ),
                errorText: _errorMessage,
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {
                setState(() => _errorMessage = null);
              },
            ),

            SizedBox(height: AppDimensions.paddingLarge),

            // Кнопка проверки
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _checkCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                  ),
                )
                    : Text('check_code'.tr(), style: AppTextStyles.button),
              ),
            ),

            // Кнопка покупки
            SizedBox(height: AppDimensions.paddingMedium),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _showPurchaseScreen,
                icon: Icon(Icons.shopping_cart, color: AppColors.secondary),
                label: Text(
                  'buy_organizer_code'.tr(),
                  style: AppTextStyles.button.copyWith(color: AppColors.secondary),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                  side: BorderSide(color: AppColors.secondary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppDimensions.paddingXLarge),

            // Информационная карточка
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('where_to_get_code'.tr(), style: AppTextStyles.bodyBold),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'where_to_get_code_purchase_only'.tr(),
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Показать экран покупки
  Future<void> _showPurchaseScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PurchaseCodeScreen()),
    );
  }

  /// Проверка кода
  Future<void> _checkCode() async {
    final code = _codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() => _errorMessage = 'code_required'.tr());
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final masterCode = remoteConfig.getString('master_code');

      print('===================');
      print('DEBUG: Master code = "$masterCode"');
      print('DEBUG: Entered code = "$code"');
      print('===================');

      bool isValid = false;
      bool isAdmin = false;

      if (code == masterCode ||
          code == 'DS-ADMIN-2025' ||
          code == 'TEST-FISH-2024' ||
          code == 'TEST-CAST-2024') {
        isValid = true;
        isAdmin = true;
      }

      if (isValid) {
        if (!mounted) return;

        print('🔍 Checking if code $code is already used...');
        final competitionNotifier = ref.read(competitionProvider.notifier);
        final existingCompetitions = await competitionNotifier.checkCodeExists(code);

        if (existingCompetitions.isNotEmpty) {
          print('❌ Code $code is already used');
          setState(() {
            _isLoading = false;
            _errorMessage = 'code_already_used'.tr();
          });
          return;
        }

        print('✅ Code $code is available');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAdmin ? 'admin_access_granted'.tr() : 'code_accepted'.tr()),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context, code);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'invalid_code'.tr();
        });
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'error_checking_code'.tr();
      });
    }
  }
}