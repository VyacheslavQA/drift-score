import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;

  // ID продуктов (должны совпадать с ID в Google Play / App Store)
  static const String singleCodeProductId = 'drift_score_single_code';
  static const String multiCodeProductId = 'drift_score_multi_code';

  // Список доступных продуктов
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // Подписка на покупки
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Callback при успешной покупке
  Function(String productId)? onPurchaseSuccess;
  Function(String error)? onPurchaseError;

  /// Инициализация сервиса покупок
  Future<bool> initialize() async {
    try {
      // Проверяем доступность In-App Purchase
      final available = await _iap.isAvailable();
      if (!available) {
        print('❌ In-App Purchase not available');
        return false;
      }

      // Загружаем продукты
      await loadProducts();

      // Подписываемся на обновления покупок
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (error) {
          print('❌ Purchase stream error: $error');
          onPurchaseError?.call(error.toString());
        },
      );

      print('✅ Purchase service initialized');
      return true;
    } catch (e) {
      print('❌ Error initializing purchase service: $e');
      return false;
    }
  }

  /// Загрузить список продуктов из магазина
  Future<void> loadProducts() async {
    try {
      final Set<String> productIds = {
        singleCodeProductId,
        multiCodeProductId,
      };

      final ProductDetailsResponse response = await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('⚠️ Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      print('✅ Loaded ${_products.length} products:');
      for (var product in _products) {
        print('   - ${product.id}: ${product.price} (${product.title})');
      }
    } catch (e) {
      print('❌ Error loading products: $e');
    }
  }

  /// Получить цену продукта
  String? getProductPrice(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      return product.price;
    } catch (e) {
      return null;
    }
  }

  /// Купить продукт
  Future<void> buyProduct(String productId) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );

      print('🛒 Purchase initiated: $productId');
    } catch (e) {
      print('❌ Error buying product: $e');
      onPurchaseError?.call(e.toString());
    }
  }

  /// Обработка обновлений покупок
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      print('📦 Purchase update: ${purchase.productID} - ${purchase.status}');

      if (purchase.status == PurchaseStatus.purchased) {
        // ✅ Покупка успешна!
        _handleSuccessfulPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // ❌ Ошибка покупки
        print('❌ Purchase error: ${purchase.error}');
        onPurchaseError?.call(purchase.error?.message ?? 'Unknown error');
      } else if (purchase.status == PurchaseStatus.canceled) {
        // 🚫 Покупка отменена
        print('🚫 Purchase canceled');
        onPurchaseError?.call('Purchase canceled');
      }

      // Завершаем транзакцию
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  /// Обработка успешной покупки
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    print('✅ Purchase successful: ${purchase.productID}');

    // TODO: Отправить информацию о покупке на backend для генерации кода
    // Пока просто вызываем callback
    onPurchaseSuccess?.call(purchase.productID);
  }

  /// Восстановить покупки (для non-consumable)
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      print('✅ Purchases restored');
    } catch (e) {
      print('❌ Error restoring purchases: $e');
    }
  }

  /// Очистка ресурсов
  void dispose() {
    _subscription?.cancel();
  }
}