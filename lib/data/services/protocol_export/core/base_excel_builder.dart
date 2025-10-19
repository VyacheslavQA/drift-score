import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:drift_score/data/models/local/protocol_local.dart';
import 'export_types.dart';
import '../utils/signature_builder.dart';
import '../utils/date_formatter.dart';

/// Базовый абстрактный класс для построения Excel документов протоколов
abstract class BaseExcelBuilder {
  /// Главный метод для построения и сохранения Excel
  Future<void> buildAndSave({
    required ProtocolType protocolType,
    required Map<String, dynamic> data,
    required int protocolId,
  }) async {
    final workbook = _createWorkbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'Protocol';

    int currentRow = 1;

    // Добавляем заголовок
    currentRow = _addHeader(sheet, protocolType, data, currentRow);
    currentRow += 1;

    // Добавляем место и дату
    currentRow = _addLocationAndDate(sheet, data, currentRow);
    currentRow += 1;

    // Добавляем таблицу с данными
    currentRow = buildTableContent(sheet, protocolType, data, currentRow);
    currentRow += 2;

    // Добавляем подписи
    _addSignatures(sheet, data, currentRow);

    // Автоподбор ширины столбцов
    for (int i = 1; i <= 12; i++) {
      sheet.autoFitColumn(i);
    }

    await _saveExcel(workbook, protocolId, protocolType, data);
  }

  /// АБСТРАКТНЫЙ: Построение содержимого таблицы
  /// Должен быть реализован в каждом наследнике
  int buildTableContent(
      xlsio.Worksheet sheet,
      ProtocolType type,
      Map<String, dynamic> data,
      int startRow,
      );

  /// АБСТРАКТНЫЙ: Получение заголовка протокола
  /// Должен быть реализован в каждом наследнике
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data);

  // ========== ДОБАВЛЕНИЕ ЗАГОЛОВКА ==========

  int _addHeader(
      xlsio.Worksheet sheet,
      ProtocolType protocolType,
      Map<String, dynamic> data,
      int startRow,
      ) {
    int currentRow = startRow;

    // Заголовок протокола
    final protocolRange = sheet.getRangeByIndex(currentRow, 1, currentRow, 10);
    protocolRange.merge();
    protocolRange.setText(getProtocolTitle(protocolType, data));
    protocolRange.cellStyle.bold = true;
    protocolRange.cellStyle.fontSize = 16;
    protocolRange.cellStyle.hAlign = xlsio.HAlignType.center;
    protocolRange.cellStyle.vAlign = xlsio.VAlignType.center;
    currentRow++;

    // Название соревнования
    if (data['competitionName'] != null) {
      final nameRange = sheet.getRangeByIndex(currentRow, 1, currentRow, 10);
      nameRange.merge();
      nameRange.setText(data['competitionName']);
      nameRange.cellStyle.bold = true;
      nameRange.cellStyle.fontSize = 14;
      nameRange.cellStyle.hAlign = xlsio.HAlignType.center;
      nameRange.cellStyle.vAlign = xlsio.VAlignType.center;
      currentRow++;
    }

    return currentRow;
  }

  // ========== МЕСТО ПРОВЕДЕНИЯ И ДАТА ==========

  int _addLocationAndDate(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    int currentRow = startRow;

    // Место проведения (слева) - с локализацией
    if (data['venueFormatted'] != null &&
        data['venueFormatted'].toString().isNotEmpty) {
      sheet.getRangeByIndex(currentRow, 1).setText(
        'protocol_venue_label'.tr() + ' ${data['venueFormatted']}',
      );
    }

    // Дата формирования протокола (справа) - с локализацией
    final dateFormationCell = sheet.getRangeByIndex(currentRow, 10);
    dateFormationCell.setText(
      'protocol_formation_date_label'.tr() +
          ' ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
    );
    dateFormationCell.cellStyle.hAlign = xlsio.HAlignType.right;
    currentRow++;

    // Дата/даты соревнования (слева) - с локализацией
    if (data['competitionDates'] != null) {
      final dateLabel = DateFormatter.getDateLabel(data);
      sheet.getRangeByIndex(currentRow, 1).setText(
        '$dateLabel: ${data['competitionDates']}',
      );
      currentRow++;
    }

    return currentRow;
  }

  // ========== ПОДПИСИ СУДЕЙ ==========

  void _addSignatures(
      xlsio.Worksheet sheet,
      Map<String, dynamic> data,
      int startRow,
      ) {
    final judges = data['judges'] as List<dynamic>? ?? [];

    if (judges.isEmpty) return;

    int currentRow = startRow;

    for (final judge in judges) {
      final judgeMap = judge as Map<String, dynamic>;
      final rank = SignatureBuilder.translateJudgeRank(
        judgeMap['rank']?.toString() ?? '',
      );
      final name = judgeMap['name']?.toString() ?? '';

      // Подпись справа (колонка 8-10)
      final signatureRange = sheet.getRangeByIndex(currentRow, 8, currentRow, 10);
      signatureRange.merge();
      signatureRange.setText('$rank: _______________ $name');
      signatureRange.cellStyle.hAlign = xlsio.HAlignType.right;
      currentRow++;
    }
  }

  // ========== СОХРАНЕНИЕ EXCEL ==========

  Future<void> _saveExcel(
      xlsio.Workbook workbook,
      int protocolId,
      ProtocolType protocolType,
      Map<String, dynamic> data,
      ) async {
    try {
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = _generateFileName(protocolId, protocolType, timestamp);
      final file = File('${output.path}/$fileName');

      print('💾 Saving Excel to: ${file.path}');
      await file.writeAsBytes(bytes);
      print('✅ Excel saved successfully: ${file.path}');

      print('📤 Sharing Excel...');
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: getProtocolTitle(protocolType, data),
      );
      print('✅ Share result: $result');
    } catch (e) {
      print('❌ Error saving/sharing Excel: $e');
      rethrow;
    }
  }

  String _generateFileName(
      int protocolId,
      ProtocolType protocolType,
      String timestamp,
      ) {
    return 'protocol_${protocolId}_${protocolType.name}_$timestamp.xlsx';
  }

  // ========== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ==========

  xlsio.Workbook _createWorkbook() {
    final workbook = xlsio.Workbook();
    return workbook;
  }

  /// Применение стиля к заголовку таблицы
  void applyHeaderStyle(xlsio.Range range) {
    range.cellStyle.bold = true;
    range.cellStyle.fontSize = 10;
    range.cellStyle.hAlign = xlsio.HAlignType.center;
    range.cellStyle.vAlign = xlsio.VAlignType.center;
    range.cellStyle.backColor = '#D3D3D3';
  }

  /// Применение стиля к ячейке данных
  void applyDataCellStyle(
      xlsio.Range range, {
        xlsio.HAlignType hAlign = xlsio.HAlignType.center,
      }) {
    range.cellStyle.fontSize = 10;
    range.cellStyle.hAlign = hAlign;
    range.cellStyle.vAlign = xlsio.VAlignType.center;
  }
}