import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/competition_provider.dart';
import 'purchase_code_screen.dart';
import '../../data/models/local/competition_local.dart';

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
                hintText: 'XXXX-XXXX-XXXX',
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

  /// ✅ ОБНОВЛЕНО: Проверка кода с лимитами
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

      // Проверка мастер-кода и тестовых кодов
      if (code == masterCode ||
          code == 'DS-ADMIN-2025' ||
          code == 'TEST-FISH-2024' ||
          code == 'TEST-CAST-2024') {
        isValid = true;
        isAdmin = true;
      } else {
        // ✅ НОВОЕ: Проверяем код в Firestore
        print('🔍 Checking code in Firestore...');
        try {
          final codeSnapshot = await FirebaseFirestore.instance
              .collection('access_codes')
              .where('code', isEqualTo: code)
              .limit(1)
              .get();

          if (codeSnapshot.docs.isNotEmpty) {
            isValid = true;
            print('✅ Code found in Firestore');
          } else {
            print('❌ Code not found in Firestore');
          }
        } catch (e) {
          print('⚠️ Error checking code in Firestore: $e');
        }
      }

      if (!isValid) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'invalid_code'.tr();
        });
        return;
      }

      if (!mounted) return;

      // ✅ НОВОЕ: Проверка лимита кода в Firebase
      print('🔍 Checking code limits in Firebase...');
      Map<String, dynamic>? codeData;
      bool canCreateNew = true;

      try {
        final codeSnapshot = await FirebaseFirestore.instance
            .collection('access_codes')
            .where('code', isEqualTo: code)
            .limit(1)
            .get();

        if (codeSnapshot.docs.isNotEmpty) {
          codeData = codeSnapshot.docs.first.data();
          final currentUses = codeData['currentUses'] ?? 0;
          final maxUses = codeData['maxUses'] ?? 1;
          final isActive = codeData['isActive'] ?? true;

          print('📊 Code info:');
          print('   Current uses: $currentUses');
          print('   Max uses: $maxUses');
          print('   Is active: $isActive');

          if (!isActive) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Код деактивирован администратором';
            });
            return;
          }

          if (currentUses >= maxUses) {
            canCreateNew = false;
            print('⚠️ Code limit reached - cannot create new competitions');
          } else {
            print('✅ Code has available slots: ${maxUses - currentUses} left');
          }
        } else {
          print('⚠️ Code not found in Firestore (might be test/admin code)');
        }
      } catch (e) {
        print('⚠️ Error checking code limits: $e');
        // Если не удалось проверить - разрешаем создание (для оффлайн режима)
        canCreateNew = true;
      }

      // ✅ Проверка: есть ли уже соревнования с этим кодом?
      print('🔍 Checking existing competitions...');
      final competitionNotifier = ref.read(competitionProvider.notifier);
      final existingCompetitions = await competitionNotifier.checkCodeExists(code);

      if (existingCompetitions.isNotEmpty) {
        // ✅ Соревнования найдены → показываем список
        print('✅ Found ${existingCompetitions.length} competition(s) with code $code');
        setState(() => _isLoading = false);

        if (!mounted) return;
        _showCompetitionsList(code, existingCompetitions, canCreateNew: canCreateNew);
      } else {
        // ✅ Соревнований нет → проверяем, можно ли создать новое
        setState(() => _isLoading = false);

        if (!canCreateNew) {
          // Лимит исчерпан, соревнований нет
          if (!mounted) return;
          setState(() {
            _errorMessage = 'Лимит кода исчерпан. Свяжитесь с организатором.';
          });
          return;
        }

        // Можно создать новое соревнование
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAdmin ? 'admin_access_granted'.tr() : 'code_accepted'.tr()),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context, code);
      }
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'error_checking_code'.tr();
      });
    }
  }

  /// ✅ ОБНОВЛЕНО: Показать список соревнований (с параметром canCreateNew)
  void _showCompetitionsList(String code, List<CompetitionLocal> competitions, {required bool canCreateNew}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Хэндл для перетаскивания
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 16),

            // Заголовок
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'competitions_by_code'.tr(),
                    style: AppTextStyles.h2,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'code_label'.tr() + ': ',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        code,
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'found_competitions'.tr(namedArgs: {'count': competitions.length.toString()}),
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Divider(color: AppColors.divider),

            // Список соревнований
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                itemCount: competitions.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final competition = competitions[index];
                  return _buildCompetitionCard(competition);
                },
              ),
            ),

            // ✅ НОВОЕ: Кнопка "Создать новое" показывается только если canCreateNew == true
            if (canCreateNew)
              Padding(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Закрыть bottom sheet
                      Navigator.pop(context, code); // Вернуть код для создания нового
                    },
                    icon: Icon(Icons.add),
                    label: Text('create_new_competition'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                  ),
                ),
              )
            else
            // ✅ НОВОЕ: Сообщение о том, что лимит исчерпан
              Padding(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Лимит кода исчерпан. Новые соревнования создать нельзя.',
                          style: AppTextStyles.caption.copyWith(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Карточка соревнования
  Widget _buildCompetitionCard(CompetitionLocal competition) {
    final isCompleted = competition.status == 'completed';
    final statusColor = isCompleted ? AppColors.success : AppColors.secondary;
    final statusText = isCompleted
        ? 'competition_status_completed'.tr()
        : 'competition_status_active'.tr();

    return InkWell(
      onTap: () {
        // TODO: Открыть экран соревнования
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'open_competition'.tr(namedArgs: {'name': competition.name}),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название + статус
            Row(
              children: [
                Expanded(
                  child: Text(
                    competition.name,
                    style: AppTextStyles.bodyBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Информация
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${competition.cityOrRegion}, ${competition.lakeName}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(competition.startTime),
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}