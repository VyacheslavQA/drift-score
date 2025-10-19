import 'package:easy_localization/easy_localization.dart';
import 'base_pdf_builder.dart';
import 'base_excel_builder.dart';
import 'export_types.dart';
import '../builders/carp/carp_pdf_builder.dart';
import '../builders/carp/carp_excel_builder.dart';
import '../builders/casting/casting_pdf_builder.dart';
import '../builders/casting/casting_excel_builder.dart';

/// Фабрика для создания builders протоколов
/// Выбирает правильный builder в зависимости от типа рыбалки
class BuilderFactory {
  /// Получить PDF builder по типу рыбалки
  BasePdfBuilder getPdfBuilder(FishingType fishingType) {
    switch (fishingType) {
      case FishingType.carp:
        return CarpPdfBuilder();
      case FishingType.casting:
        return CastingPdfBuilder();
      default:
        throw UnsupportedError(
          'protocol_type_not_supported'.tr(),
        );
    }
  }

  /// Получить Excel builder по типу рыбалки
  BaseExcelBuilder getExcelBuilder(FishingType fishingType) {
    switch (fishingType) {
      case FishingType.carp:
        return CarpExcelBuilder();
      case FishingType.casting:
        return CastingExcelBuilder();
      default:
        throw UnsupportedError(
          'protocol_type_not_supported'.tr(),
        );
    }
  }

  /// Проверка поддержки типа рыбалки
  bool isSupported(FishingType fishingType) {
    return fishingType == FishingType.carp ||
        fishingType == FishingType.casting;
  }

  /// Получение человекочитаемого названия типа рыбалки
  String getFishingTypeName(FishingType fishingType) {
    return fishingType.toDisplayString();
  }

  /// Получение списка поддерживаемых типов рыбалки
  List<String> getSupportedFishingTypes() {
    return [
      FishingType.carp.toDisplayString(),
      FishingType.casting.toDisplayString(),
    ];
  }
}