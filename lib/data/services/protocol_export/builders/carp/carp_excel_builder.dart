import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:drift_score/data/models/local/protocol_local.dart';
import '../../core/base_excel_builder.dart';
import '../../core/export_types.dart';

/// Excel Builder для карповой рыбалки
///
/// Поддерживает все типы протоколов:
/// - weighing - Протокол взвешивания
/// - intermediate - Промежуточный протокол
/// - big_fish - Big Fish протокол
/// - summary - Сводный протокол
/// - finalProtocol - Финальный протокол
/// - draw - Протокол жеребьёвки
class CarpExcelBuilder extends BaseExcelBuilder {
  @override
  int buildTableContent(
      xlsio.Worksheet sheet,
      ProtocolType type,
      Map<String, dynamic> data,
      int startRow,
      ) {
    switch (type) {
      case ProtocolType.weighing:
        return _addWeighingTable(sheet, data, false, startRow);

      case ProtocolType.intermediate:
        return _addWeighingTable(sheet, data, true, startRow);

      case ProtocolType.bigFish:
        return _addBigFishTable(sheet, data, startRow);

      case ProtocolType.summary:
        return _addSummaryTable(sheet, data, startRow);

      case ProtocolType.finalProtocol:
        return _addFinalTable(sheet, data, startRow);

      case ProtocolType.draw:
        return _addDrawTable(sheet, data, startRow);

      default:
        return startRow;
    }
  }

  @override
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data) {
    switch (type) {
      case ProtocolType.weighing:
        final dayNumber = data['dayNumber'] ?? 1;
        final weighingNumber = data['weighingNumber'] ?? 1;
        return 'protocol_weighing_title'.tr(namedArgs: {
          'day': dayNumber.toString(),
          'number': weighingNumber.toString(),
        });

      case ProtocolType.intermediate:
        final number = data['intermediateNumber'] ?? 1;
        return 'protocol_intermediate_title'.tr(namedArgs: {
          'number': number.toString(),
        });

      case ProtocolType.bigFish:
        final dayNumber = data['bigFishDay'] ?? data['dayNumber'] ?? 1;
        return 'protocol_big_fish_title'.tr(namedArgs: {
          'day': dayNumber.toString(),
        });

      case ProtocolType.summary:
        return 'protocol_summary_title'.tr();

      case ProtocolType.finalProtocol:
        return 'protocol_final_title'.tr();

      case ProtocolType.draw:
        return 'protocol_draw_title'.tr();

      default:
        return 'protocol_title'.tr();
    }
  }

  /// Добавление таблицы взвешивания/промежуточного протокола
  int _addWeighingTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      bool showPlace,
      int startRow,
      ) {
    final tableData = data['tableData'] as List<dynamic>? ?? [];

    if (tableData.isEmpty) {
      return startRow;
    }

    int currentRow = startRow;

    // Заголовки с локализацией
    final headers = showPlace
        ? [
      'field_number'.tr(),
      'team'.tr(),
      'sector'.tr(),
      'fish_count'.tr(),
      'total_weight'.tr(),
      'average_weight'.tr(),
      'field_place'.tr(),
    ]
        : [
      'field_number'.tr(),
      'team'.tr(),
      'sector'.tr(),
      'fish_count'.tr(),
      'total_weight'.tr(),
      'average_weight'.tr(),
    ];

    // Добавляем заголовок
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
    }
    currentRow++;

    // Данные
    for (final row in tableData) {
      final rowMap = row as Map<String, dynamic>;
      final totalWeight = (rowMap['totalWeight'] as num?) ?? 0;
      final fishCount = (rowMap['fishCount'] as int?) ?? 0;
      final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

      final rowData = [
        '${rowMap['order'] ?? ''}',
        rowMap['teamName']?.toString() ?? '',
        '${rowMap['sector'] ?? ''}',
        '$fishCount',
        totalWeight.toStringAsFixed(3),
        avgWeight.toStringAsFixed(3),
      ];

      if (showPlace) {
        rowData.add('${rowMap['place'] ?? ''}');
      }

      for (int i = 0; i < rowData.length; i++) {
        sheet.getRangeByIndex(currentRow, i + 1).setText(rowData[i]);
      }
      currentRow++;
    }

    return currentRow;
  }

  /// Добавление таблицы Big Fish
  int _addBigFishTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return startRow;
    }

    int currentRow = startRow;

    // Заголовки с локализацией
    final headers = [
      'team'.tr(),
      'field_fish_type'.tr(),
      'weight'.tr(),
      'length'.tr(),
      'sector'.tr(),
      'field_time'.tr(),
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
    final rowData = [
      bigFish['teamName']?.toString() ?? '',
      bigFish['fishType']?.toString() ?? '',
      ((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3),
      '${bigFish['length'] ?? ''}',
      '${bigFish['sector'] ?? ''}',
      bigFish['weighingTime'] != null
          ? _formatDateTime(bigFish['weighingTime'])
          : '',
    ];

    for (int i = 0; i < rowData.length; i++) {
      sheet.getRangeByIndex(currentRow, i + 1).setText(rowData[i]);
    }
    currentRow++;

    return currentRow;
  }

  /// Добавление таблицы сводного протокола
  int _addSummaryTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final summaryData = data['summaryData'] as List<dynamic>? ?? [];

    if (summaryData.isEmpty) {
      return startRow;
    }

    int currentRow = startRow;

    // Заголовки с локализацией
    final headers = [
      'team'.tr(),
      'participants'.tr(),
      'field_ranks'.tr(),
      'sector'.tr(),
      'fish_count'.tr(),
      'total_weight'.tr(),
      'average_weight'.tr(),
      'trophy'.tr(),
      'penalties'.tr(),
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

    // Данные
    for (final teamData in summaryData) {
      final teamMap = teamData as Map<String, dynamic>;
      final members = (teamMap['members'] as List<dynamic>?) ?? [];
      final memberNames = members
          .map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '')
          .join(', ');
      final memberRanks = members
          .map((m) => (m as Map<String, dynamic>)['rank']?.toString() ?? '')
          .join(', ');

      final totalWeight = (teamMap['totalWeight'] as num?) ?? 0;
      final fishCount = (teamMap['totalFishCount'] as int?) ?? 0;
      final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

      final rowData = [
        teamMap['teamName']?.toString() ?? '',
        memberNames,
        memberRanks,
        '${teamMap['sector'] ?? ''}',
        '$fishCount',
        totalWeight.toStringAsFixed(3),
        avgWeight.toStringAsFixed(3),
        ((teamMap['biggestFish'] as num?) ?? 0).toStringAsFixed(3),
        '${teamMap['penalties'] ?? ''}',
        '${teamMap['place'] ?? ''}',
      ];

      for (int i = 0; i < rowData.length; i++) {
        sheet.getRangeByIndex(currentRow, i + 1).setText(rowData[i]);
      }
      currentRow++;
    }

    return currentRow;
  }

  /// Добавление таблицы финального протокола
  int _addFinalTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final finalData = data['finalData'] as List<dynamic>? ?? [];

    if (finalData.isEmpty) {
      return startRow;
    }

    int currentRow = startRow;

    // Заголовки с локализацией
    final headers = [
      'team'.tr(),
      'city'.tr(),
      'club'.tr(),
      'participants'.tr(),
      'field_ranks'.tr(),
      'sector'.tr(),
      'fish_count'.tr(),
      'total_weight'.tr(),
      'average_weight'.tr(),
      'trophy'.tr(),
      'penalties'.tr(),
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

    // Данные
    for (final row in finalData) {
      final rowMap = row as Map<String, dynamic>;
      final members = (rowMap['members'] as List<dynamic>?) ?? [];
      final memberNames = members
          .map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '')
          .join(', ');
      final memberRanks = members
          .map((m) => (m as Map<String, dynamic>)['rank']?.toString() ?? '')
          .join(', ');

      final totalWeight = (rowMap['totalWeight'] as num?) ?? 0;
      final fishCount = (rowMap['totalFishCount'] as int?) ?? 0;
      final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

      final rowData = [
        rowMap['teamName']?.toString() ?? '',
        rowMap['city']?.toString() ?? '',
        rowMap['club']?.toString() ?? '-',
        memberNames,
        memberRanks,
        '${rowMap['sector'] ?? ''}',
        '$fishCount',
        totalWeight.toStringAsFixed(3),
        avgWeight.toStringAsFixed(3),
        ((rowMap['biggestFish'] as num?) ?? 0).toStringAsFixed(3),
        '${rowMap['penalties'] ?? ''}',
        '${rowMap['place'] ?? ''}',
      ];

      for (int i = 0; i < rowData.length; i++) {
        sheet.getRangeByIndex(currentRow, i + 1).setText(rowData[i]);
      }
      currentRow++;
    }

    return currentRow;
  }

  /// Добавление таблицы жеребьёвки
  int _addDrawTable(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final drawData = data['drawData'] as List<dynamic>? ?? [];

    if (drawData.isEmpty) {
      return startRow;
    }

    int currentRow = startRow;

    // Заголовки с локализацией
    final headers = [
      'field_order'.tr(),
      'team'.tr(),
      'city'.tr(),
      'draw_number'.tr(),
      'sector'.tr(),
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
    for (int i = 0; i < drawData.length; i++) {
      final row = drawData[i] as Map<String, dynamic>;
      final index = i + 1;

      final rowData = [
        '$index',
        row['teamName']?.toString() ?? '',
        row['city']?.toString() ?? '',
        '${row['drawOrder'] ?? '-'}',
        '${row['sector'] ?? '-'}',
      ];

      for (int j = 0; j < rowData.length; j++) {
        sheet.getRangeByIndex(currentRow, j + 1).setText(rowData[j]);
      }
      currentRow++;
    }

    return currentRow;
  }

  /// Форматирование даты и времени
  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd.MM HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }
}