import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:signature/signature.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/local/team_local.dart';
import '../../data/models/local/weighing_result_local.dart';

class WeighingConfirmationScreen extends StatefulWidget {
  final TeamLocal team;
  final List<FishCatch> fishes;
  final double totalWeight;
  final int fishCount;

  const WeighingConfirmationScreen({
    super.key,
    required this.team,
    required this.fishes,
    required this.totalWeight,
    required this.fishCount,
  });

  @override
  State<WeighingConfirmationScreen> createState() => _WeighingConfirmationScreenState();
}

class _WeighingConfirmationScreenState extends State<WeighingConfirmationScreen> {
  late SignatureController _signatureController;
  bool _isSigned = false;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      exportPenColor: Colors.black,
      onDrawStart: () {
        print('🖊️ Drawing started');
      },
      onDrawEnd: () {
        print('🖊️ Drawing ended');
      },
    );

    _signatureController.addListener(() {
      print('🖊️ Signature changed. isEmpty: ${_signatureController.isEmpty}');
      setState(() {
        _isSigned = _signatureController.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  String _getFishTypeName(String fishType) {
    if (fishType.isEmpty) return 'weighing_fish_type'.tr();

    // Проверяем стандартные типы
    if (['carp', 'mirror_carp', 'grass_carp', 'silver_carp', 'other'].contains(fishType)) {
      return 'fish_type_$fishType'.tr();
    }

    // Произвольный тип
    return fishType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('confirmation'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Информация о команде
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.team.name,
                    style: AppTextStyles.h2,
                  ),
                  if (widget.team.sector != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${'sector'.tr()} ${widget.team.sector}',
                      style: AppTextStyles.body,
                    ),
                  ],
                ],
              ),
            ),

            // Список рыб и область подписи
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок результата
                    Text(
                      '${'result'.tr()}',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),

                    // Список рыб
                    ...widget.fishes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final fish = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                          child: Row(
                            children: [
                              // Номер рыбы
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.paddingSmall),
                              // Вид рыбы
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getFishTypeName(fish.fishType),
                                      style: AppTextStyles.bodyBold,
                                    ),
                                    Text(
                                      '${'weighing_fish_length'.tr()}: ${fish.length.toStringAsFixed(1)} см',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              // Вес
                              Text(
                                '${fish.weight.toStringAsFixed(3)} ${'kg'.tr()}',
                                style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: AppDimensions.paddingSmall),

                    // Итоговая информация
                    Card(
                      color: AppColors.primary.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${'weighing_fish_count'.tr()}:',
                                  style: AppTextStyles.bodyBold,
                                ),
                                Text(
                                  '${widget.fishCount}',
                                  style: AppTextStyles.h3,
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${'weighing_total_weight'.tr()}:',
                                  style: AppTextStyles.h3,
                                ),
                                Text(
                                  '${widget.totalWeight.toStringAsFixed(3)} ${'kg'.tr()}',
                                  style: AppTextStyles.h2.copyWith(color: AppColors.success),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Область подписи
                    Text(
                      'sign_here'.tr(),
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),

                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Signature(
                          controller: _signatureController,
                          width: double.infinity,
                          height: 200,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingSmall),

                    // Индикатор состояния
                    Center(
                      child: Text(
                        _isSigned ? '✅ ${'signature_saved'.tr()}' : '⚠️ ${'please_sign'.tr()}',
                        style: TextStyle(
                          color: _isSigned ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Кнопка "Очистить"
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print('🗑️ Clearing signature');
                          _signatureController.clear();
                          setState(() {
                            _isSigned = false;
                          });
                        },
                        icon: const Icon(Icons.clear),
                        label: Text('clear'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Кнопка подтверждения
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSigned ? _handleConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    disabledBackgroundColor: AppColors.textSecondary.withOpacity(0.3),
                  ),
                  child: Text('confirm'.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    if (!_isSigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_sign'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      print('💾 Exporting signature...');
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        print('✅ Signature exported: ${signature.length} bytes');
        final base64Signature = base64Encode(signature);
        print('✅ Base64 length: ${base64Signature.length} chars');

        if (mounted) {
          Navigator.pop(context, base64Signature);
        }
      } else {
        print('❌ Signature is null');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('error'.tr()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error exporting signature: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error'.tr()}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}