import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:easy_localization/easy_localization.dart';
import '../../core/base_excel_builder.dart';
import '../../core/export_types.dart';
import '../../utils/signature_builder.dart';
import '../../utils/date_formatter.dart';

/// Excel Builder для протоколов кастинга
///
/// Поддерживает 3 типа протоколов:
/// - casting_attempt: Протокол попытки
/// - casting_intermediate: Промежуточный протокол
/// - casting_final: Финальный протокол
class CastingExcelBuilder extends BaseExcelBuilder {
  @override
  int buildTableContent(
      xlsio.Worksheet sheet,
      ProtocolType type,
      Map<String, dynamic> data,
      int startRow,
      ) {
    switch (type) {
      case ProtocolType.castingAttempt:
        return _buildAttemptTable(sheet, data, startRow);
      case ProtocolType.castingIntermediate:
      case ProtocolType.castingFinal:
        return _buildFullTable(sheet, data, startRow);
      default:
        throw UnsupportedError(
          'protocol_type_not_supported'.tr(),
        );
    }
  }

  @override
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data) {
    switch (type) {
      case ProtocolType.castingAttempt:
        final attemptNumber = data['weighingNumber'] ?? 1;
        return 'protocol_attempt_number'.tr(namedArgs: {
          'number': attemptNumber.toString(),
        });
      case ProtocolType.castingIntermediate:
        final upToAttempt = data['weighingNumber'] ?? data['upToAttempt'] ?? 3;
        return 'intermediate_protocol_after_attempts'.tr(namedArgs: {
          'count': upToAttempt.toString(),
        });
      case ProtocolType.castingFinal:
        return 'final_protocol_title'.tr();
      default:
        return 'protocol_casting'.tr();
    }
  }

  // ========== ПРОТОКОЛ ПОПЫТКИ ==========

  /// Построение таблицы для протокола попытки
  ///
  /// Отображает результаты одной попытки с местами
  int _buildAttemptTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];

    if (participantsData.isEmpty) {
      sheet.getRangeByIndex(startRow, 1).setText(
        'protocol_no_participant_data'.tr(),
      );
      return startRow + 1;
    }

    int currentRow = startRow;

    // Заголовки с локализацией
    final headers = [
      'field_place'.tr(),
      'full_name'.tr(),
      'rod'.tr(),
      'line'.tr(),
      'field_distance'.tr(),
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
    }
    currentRow++;

    // Данные
    for (final participant in participantsData) {
      final participantMap = participant as Map<String, dynamic>;
      final place = participantMap['place'] as int? ?? 0;

      sheet.getRangeByIndex(currentRow, 1).setNumber(place.toDouble());
      sheet.getRangeByIndex(currentRow, 2).setText(
        participantMap['fullName']?.toString() ?? '',
      );
      sheet.getRangeByIndex(currentRow, 3).setText(
        participantMap['rod']?.toString() ?? '',
      );
      sheet.getRangeByIndex(currentRow, 4).setText(
        participantMap['line']?.toString() ?? '',
      );

      final distanceCell = sheet.getRangeByIndex(currentRow, 5);
      final distance = participantMap['distance'] as num? ?? 0;
      distanceCell.setNumber(distance.toDouble());
      distanceCell.numberFormat = '0.00';
      distanceCell.cellStyle.hAlign = xlsio.HAlignType.center;

      currentRow++;
    }

    return currentRow;
  }

  // ========== ПРОМЕЖУТОЧНЫЙ И ФИНАЛЬНЫЙ ПРОТОКОЛЫ ==========

  /// Построение таблицы для промежуточного/финального протокола
  ///
  /// Отображает все попытки, итоговый результат и место
  int _buildFullTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final attemptsCount = (data['attemptsCount'] as int?) ??
        (data['upToAttempt'] as int?) ?? 3;

    if (participantsData.isEmpty) {
      sheet.getRangeByIndex(startRow, 1).setText(
        'protocol_no_participant_data'.tr(),
      );
      return startRow + 1;
    }

    int currentRow = startRow;

    // Динамические заголовки с попытками и локализацией
    final headers = [
      'field_number'.tr(),
      'full_name'.tr(),
      'rod'.tr(),
      'line'.tr(),
      ...List.generate(
        attemptsCount,
            (i) => 'protocol_attempt_number'.tr(namedArgs: {
          'number': (i + 1).toString(),
        }),
      ),
      scoringMethod == 'best_distance'
          ? 'field_best_result'.tr()
          : 'field_average_result'.tr(),
      'field_place'.tr(),
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
    }
    currentRow++;

    // Данные участников
    for (int i = 0; i < participantsData.length; i++) {
      final participant = participantsData[i] as Map<String, dynamic>;
      final attempts = (participant['attempts'] as List<dynamic>?)
          ?.cast<num>() ??
          [];
      final place = participant['place'] as int? ?? 0;

      int col = 1;

      // № п/п
      sheet.getRangeByIndex(currentRow, col++).setNumber((i + 1).toDouble());

      // ФИО
      sheet.getRangeByIndex(currentRow, col++).setText(
        participant['fullName']?.toString() ?? '',
      );

      // Удилище
      sheet.getRangeByIndex(currentRow, col++).setText(
        participant['rod']?.toString() ?? '',
      );

      // Леска
      sheet.getRangeByIndex(currentRow, col++).setText(
        participant['line']?.toString() ?? '',
      );

      // Попытки
      for (int attemptIndex = 0; attemptIndex < attemptsCount; attemptIndex++) {
        final attemptCell = sheet.getRangeByIndex(currentRow, col++);

        if (attemptIndex < attempts.length) {
          final distance = attempts[attemptIndex];

          if (distance > 0) {
            attemptCell.setNumber(distance.toDouble());
            attemptCell.numberFormat = '0.00';
          } else {
            attemptCell.setText('0');
          }
        } else {
          attemptCell.setText('0');
        }

        attemptCell.cellStyle.hAlign = xlsio.HAlignType.center;
      }

      // Итоговый результат (лучший или средний)
      final resultCell = sheet.getRangeByIndex(currentRow, col++);
      if (scoringMethod == 'best_distance') {
        final bestDistance = participant['bestDistance'] as num? ?? 0;
        resultCell.setNumber(bestDistance.toDouble());
      } else {
        final averageDistance = participant['averageDistance'] as num? ?? 0;
        resultCell.setNumber(averageDistance.toDouble());
      }
      resultCell.numberFormat = '0.00';
      resultCell.cellStyle.hAlign = xlsio.HAlignType.center;
      resultCell.cellStyle.bold = true;

      // Место
      final placeCell = sheet.getRangeByIndex(currentRow, col++);
      placeCell.setNumber(place.toDouble());
      placeCell.cellStyle.hAlign = xlsio.HAlignType.center;
      placeCell.cellStyle.bold = true;

      currentRow++;
    }

    return currentRow;
  }
}