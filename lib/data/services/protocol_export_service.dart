import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/local/protocol_local.dart';

class ProtocolExportService {
  // Экспорт в PDF
  Future<void> exportToPdf(ProtocolLocal protocol, Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Добавляем страницу с протоколом
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Шапка протокола
              _buildPdfHeader(protocol, data),
              pw.SizedBox(height: 20),

              // Содержимое протокола
              _buildPdfContent(protocol, data),

              pw.Spacer(),

              // Подпись судьи внизу
              _buildPdfSignature(data),
            ],
          );
        },
      ),
    );

    // Сохраняем и делимся файлом
    await _savePdf(pdf, protocol);
  }

  // Экспорт в Excel
  Future<void> exportToExcel(ProtocolLocal protocol, Map<String, dynamic> data) async {
    // Создаём новый Excel файл
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Protocol';

    int currentRow = 1;

    // Шапка
    currentRow = _addExcelHeader(sheet, protocol, data, currentRow);
    currentRow += 2;

    // Таблица данных
    currentRow = _addExcelTable(sheet, protocol, data, currentRow);
    currentRow += 2;

    // Подпись
    _addExcelSignature(sheet, data, currentRow);

    // Автоматическая ширина колонок
    for (int i = 1; i <= 12; i++) {
      sheet.autoFitColumn(i);
    }

    // Сохраняем и делимся файлом
    await _saveExcel(workbook, protocol);
  }

  // Экспорт в Word (через PDF с расширением .doc)
  Future<void> exportToWord(ProtocolLocal protocol, Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildPdfHeader(protocol, data),
              pw.SizedBox(height: 20),
              _buildPdfContent(protocol, data),
              pw.Spacer(),
              _buildPdfSignature(data),
            ],
          );
        },
      ),
    );

    await _saveAsWord(pdf, protocol);
  }

  // ===== PDF HELPERS =====

  pw.Widget _buildPdfHeader(ProtocolLocal protocol, Map<String, dynamic> data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _getProtocolTitle(protocol),
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          if (data['city'] != null)
            pw.Text('Город: ${data['city']}', style: const pw.TextStyle(fontSize: 12)),
          if (data['lake'] != null)
            pw.Text('Озеро: ${data['lake']}', style: const pw.TextStyle(fontSize: 12)),
          if (data['organizer'] != null)
            pw.Text('Организатор: ${data['organizer']}', style: const pw.TextStyle(fontSize: 12)),
          if (data['weighingTime'] != null)
            pw.Text(
              'Время: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['weighingTime']))}',
              style: const pw.TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfContent(ProtocolLocal protocol, Map<String, dynamic> data) {
    switch (protocol.type) {
      case 'weighing':
      case 'intermediate':
        return _buildPdfWeighingTable(data, protocol.type == 'intermediate');
      case 'big_fish':
        return _buildPdfBigFishTable(data);
      case 'summary':
        return _buildPdfSummaryTable(data);
      case 'final':
        return _buildPdfFinalTable(data);
      default:
        return pw.Text('Тип протокола не поддерживается');
    }
  }

  pw.Widget _buildPdfWeighingTable(Map<String, dynamic> data, bool showPlace) {
    final tableData = data['tableData'] as List<dynamic>? ?? [];

    if (tableData.isEmpty) {
      return pw.Text('Нет данных');
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
      headers: [
        '№',
        'Команда',
        'Сектор',
        'Рыб',
        'Общий вес',
        'Средний вес',
        if (showPlace) 'Место',
      ],
      data: tableData.map((row) {
        final rowMap = row as Map<String, dynamic>;
        final totalWeight = (rowMap['totalWeight'] as num?) ?? 0;
        final fishCount = (rowMap['fishCount'] as int?) ?? 0;
        final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

        return [
          '${rowMap['order'] ?? ''}',
          rowMap['teamName']?.toString() ?? '',
          '${rowMap['sector'] ?? ''}',
          '$fishCount',
          totalWeight.toStringAsFixed(3),
          avgWeight.toStringAsFixed(3),
          if (showPlace) '${rowMap['place'] ?? ''}',
        ];
      }).toList(),
    );
  }

  pw.Widget _buildPdfBigFishTable(Map<String, dynamic> data) {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return pw.Text('Нет данных');
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.amber100),
      headers: ['Команда', 'Вид рыбы', 'Вес (кг)', 'Длина (см)', 'Сектор', 'Время'],
      data: [
        [
          bigFish['teamName']?.toString() ?? '',
          bigFish['fishType']?.toString() ?? '',
          ((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3),
          '${bigFish['length'] ?? ''}',
          '${bigFish['sector'] ?? ''}',
          bigFish['weighingTime'] != null
              ? DateFormat('dd.MM HH:mm').format(DateTime.parse(bigFish['weighingTime']))
              : '',
        ],
      ],
    );
  }

  pw.Widget _buildPdfSummaryTable(Map<String, dynamic> data) {
    final summaryData = data['summaryData'] as List<dynamic>? ?? [];

    if (summaryData.isEmpty) {
      return pw.Text('Нет данных');
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      cellStyle: const pw.TextStyle(fontSize: 7),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: [
        'Команда',
        'Участники',
        'Разряды',
        'Сектор',
        'Рыб',
        'Общий вес',
        'Ср. вес',
        'Трофей',
        'Штрафы',
        'Место',
      ],
      data: summaryData.map((teamData) {
        final teamMap = teamData as Map<String, dynamic>;
        final members = (teamMap['members'] as List<dynamic>?) ?? [];
        final memberNames = members.map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '').join('\n');
        final memberRanks = members.map((m) => (m as Map<String, dynamic>)['rank']?.toString() ?? '').join('\n');

        final totalWeight = (teamMap['totalWeight'] as num?) ?? 0;
        final fishCount = (teamMap['totalFishCount'] as int?) ?? 0;
        final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

        return [
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
      }).toList(),
    );
  }

  pw.Widget _buildPdfFinalTable(Map<String, dynamic> data) {
    final finalData = data['finalData'] as List<dynamic>? ?? [];

    if (finalData.isEmpty) {
      return pw.Text('Нет данных');
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
      cellStyle: const pw.TextStyle(fontSize: 6),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: [
        'Команда',
        'Город',
        'Клуб',
        'Участники',
        'Разряды',
        'Сектор',
        'Рыб',
        'Общий вес',
        'Ср. вес',
        'Трофей',
        'Штрафы',
        'Место',
      ],
      data: finalData.map((row) {
        final rowMap = row as Map<String, dynamic>;
        final members = (rowMap['members'] as List<dynamic>?) ?? [];
        final memberNames = members.map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '').join('\n');
        final memberRanks = members.map((m) => (m as Map<String, dynamic>)['rank']?.toString() ?? '').join('\n');

        final totalWeight = (rowMap['totalWeight'] as num?) ?? 0;
        final fishCount = (rowMap['totalFishCount'] as int?) ?? 0;
        final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

        return [
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
      }).toList(),
    );
  }

  pw.Widget _buildPdfSignature(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Подписи судей:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        if (data['judges'] != null)
          ...((data['judges'] as List<dynamic>).map((judge) {
            final judgeMap = judge as Map<String, dynamic>;
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 15),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '${judgeMap['name'] ?? ''} (${judgeMap['rank'] ?? ''})',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Container(
                    width: 150,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    child: pw.SizedBox(height: 20),
                  ),
                ],
              ),
            );
          })),
        pw.SizedBox(height: 10),
        pw.Text(
          'Дата: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  // ===== EXCEL HELPERS =====

  int _addExcelHeader(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    // Заголовок протокола
    sheet.getRangeByIndex(row, 1).setText(_getProtocolTitle(protocol));
    sheet.getRangeByIndex(row, 1).cellStyle.bold = true;
    sheet.getRangeByIndex(row, 1).cellStyle.fontSize = 16;
    row++;

    if (data['city'] != null) {
      sheet.getRangeByIndex(row, 1).setText('Город: ${data['city']}');
      row++;
    }

    if (data['lake'] != null) {
      sheet.getRangeByIndex(row, 1).setText('Озеро: ${data['lake']}');
      row++;
    }

    if (data['organizer'] != null) {
      sheet.getRangeByIndex(row, 1).setText('Организатор: ${data['organizer']}');
      row++;
    }

    return row;
  }

  int _addExcelTable(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    // Заголовки таблицы
    final headers = _getExcelHeaders(protocol.type);
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(row, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
    }
    row++;

    // Данные таблицы
    final tableData = _getExcelData(protocol, data);
    for (final rowData in tableData) {
      for (int i = 0; i < rowData.length; i++) {
        sheet.getRangeByIndex(row, i + 1).setText(rowData[i]);
      }
      row++;
    }

    return row;
  }

  void _addExcelSignature(xlsio.Worksheet sheet, Map<String, dynamic> data, int row) {
    sheet.getRangeByIndex(row, 1).setText('Подписи судей:');
    sheet.getRangeByIndex(row, 1).cellStyle.bold = true;
    row += 2;

    if (data['judges'] != null) {
      for (final judge in data['judges'] as List<dynamic>) {
        final judgeMap = judge as Map<String, dynamic>;
        sheet.getRangeByIndex(row, 1).setText(
          '${judgeMap['name'] ?? ''} (${judgeMap['rank'] ?? ''}): _______________',
        );
        row++;
      }
    }

    row += 1;
    sheet.getRangeByIndex(row, 1).setText('Дата: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}');
  }

  List<String> _getExcelHeaders(String type) {
    switch (type) {
      case 'weighing':
        return ['№', 'Команда', 'Сектор', 'Рыб', 'Общий вес', 'Средний вес'];
      case 'intermediate':
        return ['№', 'Команда', 'Сектор', 'Рыб', 'Общий вес', 'Средний вес', 'Место'];
      case 'big_fish':
        return ['Команда', 'Вид рыбы', 'Вес (кг)', 'Длина (см)', 'Сектор', 'Время'];
      case 'summary':
        return ['Команда', 'Участники', 'Сектор', 'Рыб', 'Общий вес', 'Трофей', 'Место'];
      case 'final':
        return ['Команда', 'Участники', 'Сектор', 'Рыб', 'Общий вес', 'Трофей', 'Место'];
      default:
        return [];
    }
  }

  List<List<String>> _getExcelData(ProtocolLocal protocol, Map<String, dynamic> data) {
    switch (protocol.type) {
      case 'weighing':
      case 'intermediate':
        final tableData = data['tableData'] as List<dynamic>? ?? [];
        return tableData.map((row) {
          final rowMap = row as Map<String, dynamic>;
          final totalWeight = (rowMap['totalWeight'] as num?) ?? 0;
          final fishCount = (rowMap['fishCount'] as int?) ?? 0;
          final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

          final result = [
            '${rowMap['order'] ?? ''}',
            rowMap['teamName']?.toString() ?? '',
            '${rowMap['sector'] ?? ''}',
            '$fishCount',
            totalWeight.toStringAsFixed(3),
            avgWeight.toStringAsFixed(3),
          ];

          if (protocol.type == 'intermediate') {
            result.add('${rowMap['place'] ?? ''}');
          }

          return result;
        }).toList();

      case 'big_fish':
        final bigFish = data['bigFish'] as Map<String, dynamic>?;
        if (bigFish == null) return [];

        return [
          [
            bigFish['teamName']?.toString() ?? '',
            bigFish['fishType']?.toString() ?? '',
            ((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3),
            '${bigFish['length'] ?? ''}',
            '${bigFish['sector'] ?? ''}',
            bigFish['weighingTime'] != null
                ? DateFormat('dd.MM HH:mm').format(DateTime.parse(bigFish['weighingTime']))
                : '',
          ]
        ];

      case 'summary':
        final summaryData = data['summaryData'] as List<dynamic>? ?? [];
        return summaryData.map((teamData) {
          final teamMap = teamData as Map<String, dynamic>;
          final members = (teamMap['members'] as List<dynamic>?) ?? [];
          final memberNames = members.map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '').join(', ');

          final totalWeight = (teamMap['totalWeight'] as num?) ?? 0;
          final fishCount = (teamMap['totalFishCount'] as int?) ?? 0;
          final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

          return [
            teamMap['teamName']?.toString() ?? '',
            memberNames,
            '${teamMap['sector'] ?? ''}',
            '$fishCount',
            totalWeight.toStringAsFixed(3),
            ((teamMap['biggestFish'] as num?) ?? 0).toStringAsFixed(3),
            '${teamMap['place'] ?? ''}',
          ];
        }).toList();

      case 'final':
        final finalData = data['finalData'] as List<dynamic>? ?? [];
        return finalData.map((row) {
          final rowMap = row as Map<String, dynamic>;
          final members = (rowMap['members'] as List<dynamic>?) ?? [];
          final memberNames = members.map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '').join(', ');

          final totalWeight = (rowMap['totalWeight'] as num?) ?? 0;
          final fishCount = (rowMap['totalFishCount'] as int?) ?? 0;
          final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

          return [
            rowMap['teamName']?.toString() ?? '',
            memberNames,
            '${rowMap['sector'] ?? ''}',
            '$fishCount',
            totalWeight.toStringAsFixed(3),
            ((rowMap['biggestFish'] as num?) ?? 0).toStringAsFixed(3),
            '${rowMap['place'] ?? ''}',
          ];
        }).toList();

      default:
        return [];
    }
  }

  // ===== SAVE & SHARE =====

  Future<void> _savePdf(pw.Document pdf, ProtocolLocal protocol) async {
    try {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/protocol_${protocol.id}_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: _getProtocolTitle(protocol),
      );
    } catch (e) {
      print('Error saving PDF: $e');
      rethrow;
    }
  }

  Future<void> _saveExcel(xlsio.Workbook workbook, ProtocolLocal protocol) async {
    try {
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/protocol_${protocol.id}_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: _getProtocolTitle(protocol),
      );
    } catch (e) {
      print('Error saving Excel: $e');
      rethrow;
    }
  }

  Future<void> _saveAsWord(pw.Document pdf, ProtocolLocal protocol) async {
    try {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/protocol_${protocol.id}_${DateTime.now().millisecondsSinceEpoch}.doc');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: _getProtocolTitle(protocol),
      );
    } catch (e) {
      print('Error saving Word: $e');
      rethrow;
    }
  }

  String _getProtocolTitle(ProtocolLocal protocol) {
    switch (protocol.type) {
      case 'weighing':
        return 'Протокол взвешивания День ${protocol.dayNumber}, №${protocol.weighingNumber}';
      case 'intermediate':
        return 'Промежуточный протокол №${protocol.weighingNumber}';
      case 'big_fish':
        return 'Big Fish - День ${protocol.bigFishDay}';
      case 'summary':
        return 'Сводный протокол';
      case 'final':
        return 'Финальный протокол';
      default:
        return 'Протокол соревнования';
    }
  }
}