import 'dart:convert';
import '../models/local/protocol_local.dart';
import 'protocol_export/core/builder_factory.dart';
import 'protocol_export/core/export_types.dart';

/// Главный сервис экспорта протоколов
///
/// Координирует экспорт протоколов в PDF и Excel форматы
/// используя модульную архитектуру builders
class ProtocolExportService {
  final BuilderFactory _factory = BuilderFactory();

  /// Экспорт протокола в PDF
  ///
  /// [protocol] - объект протокола с метаданными
  /// [data] - данные протокола в формате Map
  Future<void> exportToPdf(
      ProtocolLocal protocol,
      Map<String, dynamic> data,
      ) async {
    try {
      // Определяем тип протокола из строки
      final protocolType = ProtocolTypeExtension.fromString(protocol.type);

      // Получаем тип рыбалки из данных
      final fishingTypeStr = data['fishingType'] as String?;
      if (fishingTypeStr == null) {
        throw Exception('Тип рыбалки не указан в данных протокола');
      }

      final fishingType = FishingTypeExtension.fromString(fishingTypeStr);

      // Получаем соответствующий PDF builder через фабрику
      final builder = _factory.getPdfBuilder(fishingType);

      // Строим и сохраняем PDF
      await builder.buildAndSave(
        protocolType: protocolType,
        data: data,
        protocolId: protocol.id,
      );

      print('✅ PDF протокол успешно экспортирован: ${protocol.type}');
    } catch (e) {
      print('❌ Ошибка при экспорте PDF: $e');
      rethrow;
    }
  }

  /// Экспорт протокола в Excel
  ///
  /// [protocol] - объект протокола с метаданными
  /// [data] - данные протокола в формате Map
  Future<void> exportToExcel(
      ProtocolLocal protocol,
      Map<String, dynamic> data,
      ) async {
    try {
      // Определяем тип протокола из строки
      final protocolType = ProtocolTypeExtension.fromString(protocol.type);

      // Получаем тип рыбалки из данных
      final fishingTypeStr = data['fishingType'] as String?;
      if (fishingTypeStr == null) {
        throw Exception('Тип рыбалки не указан в данных протокола');
      }

      final fishingType = FishingTypeExtension.fromString(fishingTypeStr);

      // Получаем соответствующий Excel builder через фабрику
      final builder = _factory.getExcelBuilder(fishingType);

      // Строим и сохраняем Excel
      await builder.buildAndSave(
        protocolType: protocolType,
        data: data,
        protocolId: protocol.id,
      );

      print('✅ Excel протокол успешно экспортирован: ${protocol.type}');
    } catch (e) {
      print('❌ Ошибка при экспорте Excel: $e');
      rethrow;
    }
  }

  /// Проверка поддержки типа рыбалки
  ///
  /// Возвращает true, если для данного типа рыбалки есть реализованные builders
  bool isFishingTypeSupported(String fishingTypeStr) {
    try {
      final fishingType = FishingTypeExtension.fromString(fishingTypeStr);
      return _factory.isSupported(fishingType);
    } catch (e) {
      return false;
    }
  }

  /// Получение названия типа рыбалки на русском языке
  String getFishingTypeName(String fishingTypeStr) {
    try {
      final fishingType = FishingTypeExtension.fromString(fishingTypeStr);
      return _factory.getFishingTypeName(fishingType);
    } catch (e) {
      return 'Неизвестный тип';
    }
  }
}