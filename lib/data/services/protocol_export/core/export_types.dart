import 'package:easy_localization/easy_localization.dart';

/// Типы протоколов и рыбалки для экспорта
///
/// Содержит перечисления и константы для системы экспорта протоколов

// ========== ТИПЫ ПРОТОКОЛОВ ==========

enum ProtocolType {
  weighing,
  intermediate,
  bigFish,
  summary,
  finalProtocol, // ← ИСПРАВЛЕНО: было 'final'
  draw,
  castingAttempt,
  castingIntermediate,
  castingFinal,
}

extension ProtocolTypeExtension on ProtocolType {
  static ProtocolType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'weighing':
        return ProtocolType.weighing;
      case 'intermediate':
        return ProtocolType.intermediate;
      case 'big_fish':
        return ProtocolType.bigFish;
      case 'summary':
        return ProtocolType.summary;
      case 'final':
        return ProtocolType.finalProtocol; // ← ИСПРАВЛЕНО
      case 'draw':
        return ProtocolType.draw;
      case 'casting_attempt':
        return ProtocolType.castingAttempt;
      case 'casting_intermediate':
        return ProtocolType.castingIntermediate;
      case 'casting_final':
        return ProtocolType.castingFinal;
      default:
        throw ArgumentError('protocol_type_not_supported'.tr());
    }
  }

  String toDisplayString() {
    switch (this) {
      case ProtocolType.weighing:
        return 'protocol_weighing'.tr();
      case ProtocolType.intermediate:
        return 'protocol_intermediate'.tr();
      case ProtocolType.bigFish:
        return 'protocol_big_fish'.tr();
      case ProtocolType.summary:
        return 'protocol_summary'.tr();
      case ProtocolType.finalProtocol: // ← ИСПРАВЛЕНО
        return 'protocol_final'.tr();
      case ProtocolType.draw:
        return 'protocol_draw'.tr();
      case ProtocolType.castingAttempt:
        return 'protocol_casting_attempt'.tr();
      case ProtocolType.castingIntermediate:
        return 'casting_intermediate'.tr();
      case ProtocolType.castingFinal:
        return 'casting_final'.tr();
    }
  }
}

// ========== ТИПЫ РЫБАЛКИ ==========

enum FishingType {
  carp,
  casting,
  float,
  spinning,
  feeder,
  iceJig,
  iceSpoon,
  trout,
  fly,
}

extension FishingTypeExtension on FishingType {
  static FishingType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'carp':
        return FishingType.carp;
      case 'casting':
        return FishingType.casting;
      case 'float':
        return FishingType.float;
      case 'spinning':
        return FishingType.spinning;
      case 'feeder':
        return FishingType.feeder;
      case 'ice_jig':
        return FishingType.iceJig;
      case 'ice_spoon':
        return FishingType.iceSpoon;
      case 'trout':
        return FishingType.trout;
      case 'fly':
        return FishingType.fly;
      default:
        throw ArgumentError('protocol_type_not_supported'.tr());
    }
  }

  String toDisplayString() {
    switch (this) {
      case FishingType.carp:
        return 'fishing_type_carp'.tr();
      case FishingType.casting:
        return 'fishing_type_casting'.tr();
      case FishingType.float:
        return 'fishing_type_float'.tr();
      case FishingType.spinning:
        return 'fishing_type_spinning'.tr();
      case FishingType.feeder:
        return 'fishing_type_feeder'.tr();
      case FishingType.iceJig:
        return 'fishing_type_ice_jig'.tr();
      case FishingType.iceSpoon:
        return 'fishing_type_ice_spoon'.tr();
      case FishingType.trout:
        return 'fishing_type_trout'.tr();
      case FishingType.fly:
        return 'fishing_type_fly'.tr();
    }
  }
}

// ========== КОНСТАНТЫ ЭКСПОРТА ==========

class ExportConstants {
  // PDF константы
  static const double pdfFontSizeHeader = 16.0;
  static const double pdfFontSizeSubheader = 14.0;
  static const double pdfFontSizeNormal = 11.0;
  static const double pdfFontSizeSmall = 10.0;
  static const double pdfFontSizeTableHeader = 10.0;
  static const double pdfFontSizeTableCell = 9.0;

  // Excel константы
  static const int excelHeaderRowHeight = 40;
  static const int excelDataRowHeight = 25;
  static const int excelDefaultColumnWidth = 15;
  static const String excelHeaderBackColor = '#D3D3D3';
  static const String excelDateBackColor = '#F0F0F0';

  // Общие
  static const String dateFormat = 'dd.MM.yyyy';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
}