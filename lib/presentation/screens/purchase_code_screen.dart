import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';

class PurchaseCodeScreen extends ConsumerStatefulWidget {
  const PurchaseCodeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PurchaseCodeScreen> createState() => _PurchaseCodeScreenState();
}

class _PurchaseCodeScreenState extends ConsumerState<PurchaseCodeScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isLoading = true;

  // ID продуктов (измени на свои!)
  static const String singleCodeProductId = 'drift_score_single_code';
  static const String packCodeProductId = 'drift_score_pack_5_code';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        setState(() => _isLoading = false);
        return;
      }

      final Set<String> productIds = {
        singleCodeProductId,
        packCodeProductId,
      };

      final ProductDetailsResponse response = await _iap.queryProductDetails(productIds);

      setState(() {
        _products = response.productDetails;
        _isLoading = false;
      });

      print('✅ Loaded ${_products.length} products');
    } catch (e) {
      print('❌ Error loading products: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getProductPrice(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      return product.price;
    } catch (e) {
      return 'purchase_loading'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('purchase_code_title'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppDimensions.paddingLarge,
          right: AppDimensions.paddingLarge,
          top: AppDimensions.paddingLarge,
          bottom: AppDimensions.paddingLarge + 80, // ✅ Отступ снизу для навигации
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppDimensions.paddingMedium),

            // Заголовок
            Text(
              'purchase_code_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),

            SizedBox(height: AppDimensions.paddingMedium),

            // Описание
            Text(
              'purchase_code_description'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),

            SizedBox(height: AppDimensions.paddingXLarge),

            // Одно соревнование
            _buildProductCard(
              productId: singleCodeProductId,
              title: 'purchase_single_code_title'.tr(),
              description: 'purchase_single_code_description'.tr(),
              features: [
                'purchase_single_feature_1'.tr(),
                'purchase_single_feature_2'.tr(),
                'purchase_single_feature_3'.tr(),
              ],
              icon: Icons.event,
              color: AppColors.secondary,
            ),

            SizedBox(height: AppDimensions.paddingLarge),

            // Пакет 5 соревнований (рекомендуемый)
            _buildProductCard(
              productId: packCodeProductId,
              title: 'purchase_pack_code_title'.tr(),
              description: 'purchase_pack_code_description'.tr(),
              features: [
                'purchase_pack_feature_1'.tr(),
                'purchase_pack_feature_2'.tr(),
                'purchase_pack_feature_3'.tr(),
              ],
              icon: Icons.workspace_premium,
              color: AppColors.primary,
              isRecommended: true,
            ),

            SizedBox(height: AppDimensions.paddingXLarge),

            // Информация
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'purchase_info_title'.tr(),
                          style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'purchase_info_description'.tr(),
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppDimensions.paddingLarge),

            // Кнопка связи с поддержкой
            OutlinedButton.icon(
              onPressed: _contactSupport,
              icon: Icon(Icons.telegram, color: AppColors.secondary),
              label: Text(
                'contact_support'.tr(),
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

            SizedBox(height: AppDimensions.paddingLarge),

            // Ссылки на документы
            _buildDocumentLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String productId,
    required String title,
    required String description,
    required List<String> features,
    required IconData icon,
    required Color color,
    bool isRecommended = false,
  }) {
    final price = _getProductPrice(productId);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(
              color: isRecommended ? color : AppColors.divider,
              width: isRecommended ? 3 : 1,
            ),
            boxShadow: isRecommended
                ? [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.h3),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              Divider(color: AppColors.divider),
              SizedBox(height: AppDimensions.paddingMedium),
              // Фичи
              ...features.map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(height: AppDimensions.paddingLarge),
              // Цена и кнопка
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'purchase_price'.tr(),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        price,
                        style: AppTextStyles.h2.copyWith(color: color),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _products.isEmpty ? null : () => _confirmPurchase(productId, title, price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge,
                        vertical: AppDimensions.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    child: Text('purchase_buy_button'.tr(), style: AppTextStyles.button),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isRecommended)
          Positioned(
            top: -12,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'purchase_recommended'.tr(),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentLinks() {
    return Column(
      children: [
        Divider(color: AppColors.divider),
        SizedBox(height: AppDimensions.paddingSmall),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            TextButton(
              onPressed: () => _openUrl('https://drift-score.com/privacy'),
              child: Text(
                'privacy_policy'.tr(),
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ),
            Text('•', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            TextButton(
              onPressed: () => _openUrl('https://drift-score.com/terms'),
              child: Text(
                'terms_of_service'.tr(),
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ),
            Text('•', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            TextButton(
              onPressed: () => _openUrl('https://drift-score.com/guide'),
              child: Text(
                'user_guide'.tr(),
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _confirmPurchase(String productId, String title, String price) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('purchase_confirm_title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'purchase_product'.tr()}: $title', style: AppTextStyles.bodyBold),
            SizedBox(height: 8),
            Text('${'purchase_price'.tr()}: $price', style: AppTextStyles.body),
            SizedBox(height: 16),
            Text(
              'purchase_confirm_description'.tr(),
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('purchase_buy_button'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _buyProduct(productId);
    }
  }

  Future<void> _buyProduct(String productId) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      final success = await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );

      if (success) {
        _showPurchaseSuccessDialog();
      }
    } catch (e) {
      print('❌ Error buying product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'purchase_error'.tr()}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPurchaseSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: 12),
            Flexible(child: Text('purchase_success_title'.tr())),
          ],
        ),
        content: Text('purchase_success_description'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('close'.tr()),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _contactSupport();
            },
            icon: Icon(Icons.telegram, size: 18),
            label: Text('contact_support'.tr()),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Future<void> _contactSupport() async {
    final telegramUrl = 'https://t.me/driftscore_support'; // ← ЗАМЕНИ НА СВОЮ ССЫЛКУ
    await _openUrl(telegramUrl);
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${'purchase_cannot_open_url'.tr()}: $url'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error opening URL: $e');
    }
  }
}