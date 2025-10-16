import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/local/protocol_local.dart';

class ProtocolExportService {
  pw.Font? _regularFont;
  pw.Font? _boldFont;

  Future<pw.Font> _loadRegularFont() async {
    if (_regularFont != null) return _regularFont!;
    final fontData = await PdfGoogleFonts.robotoRegular();
    _regularFont = fontData;
    return _regularFont!;
  }

  Future<pw.Font> _loadBoldFont() async {
    if (_boldFont != null) return _boldFont!;
    final fontData = await PdfGoogleFonts.robotoBold();
    _boldFont = fontData;
    return _boldFont!;
  }

  Future<void> exportToPdf(ProtocolLocal protocol, Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final font = await _loadRegularFont();
    final fontBold = await _loadBoldFont();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape, // Альбомная ориентация для кастинга
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildPdfHeader(protocol, data, font, fontBold),
              pw.SizedBox(height: 15),
              _buildPdfLocationAndDate(protocol, data, font, fontBold),
              pw.SizedBox(height: 15),
              _buildPdfContent(protocol, data, font, fontBold),
              pw.Spacer(),
              _buildPdfSignature(data, font, fontBold),
            ],
          );
        },
      ),
    );

    await _savePdf(pdf, protocol);
  }

  Future<void> exportToExcel(ProtocolLocal protocol, Map<String, dynamic> data) async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Protocol';

    int currentRow = 1;

    currentRow = _addExcelHeader(sheet, protocol, data, currentRow);
    currentRow += 1;

    currentRow = _addExcelLocationAndDate(sheet, protocol, data, currentRow);
    currentRow += 1;

    currentRow = _addExcelTable(sheet, protocol, data, currentRow);
    currentRow += 2;

    _addExcelSignature(sheet, data, currentRow);

    for (int i = 1; i <= 12; i++) {
      sheet.autoFitColumn(i);
    }

    await _saveExcel(workbook, protocol);
  }

  pw.Widget _buildPdfHeader(ProtocolLocal protocol, Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (data['organizer'] != null)
          pw.Text(
            data['organizer'],
            style: pw.TextStyle(fontSize: 14, font: fontBold),
            textAlign: pw.TextAlign.center,
          ),
        pw.SizedBox(height: 8),
        pw.Text(
          _getProtocolTitle(protocol),
          style: pw.TextStyle(fontSize: 16, font: fontBold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 8),
        if (data['competitionName'] != null)
          pw.Text(
            data['competitionName'],
            style: pw.TextStyle(fontSize: 14, font: fontBold),
            textAlign: pw.TextAlign.center,
          ),
      ],
    );
  }

  pw.Widget _buildPdfLocationAndDate(ProtocolLocal protocol, Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final isSummaryOrFinal = protocol.type == 'summary' || protocol.type == 'final';
    final isCasting = protocol.type == 'casting';

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (data['venue'] != null && isCasting)
              pw.Text(
                'Место проведения: ${data['venue']}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),
            if (data['lake'] != null && !isCasting)
              pw.Text(
                'Место проведения: ${data['lake']}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),
            pw.SizedBox(height: 4),

            if (protocol.type == 'weighing' && data['weighingTime'] != null)
              pw.Text(
                'Дата и время: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['weighingTime']))}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),

            if (protocol.type == 'big_fish' && data['startTime'] != null && data['finishTime'] != null)
              pw.Text(
                'Период: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['finishTime']))}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),

            if ((isSummaryOrFinal || isCasting) && data['startTime'] != null && data['finishTime'] != null)
              pw.Text(
                'Даты соревнования: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy').format(DateTime.parse(data['finishTime']))}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),
          ],
        ),

        if (isSummaryOrFinal || isCasting)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Дата формирования протокола:',
                style: pw.TextStyle(fontSize: 10, font: font),
              ),
              pw.Text(
                DateFormat('dd.MM.yyyy').format(DateTime.now()),
                style: pw.TextStyle(fontSize: 11, font: fontBold),
              ),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildPdfContent(ProtocolLocal protocol, Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    switch (protocol.type) {
      case 'weighing':
      case 'intermediate':
        return _buildPdfWeighingTable(data, protocol.type == 'intermediate', font, fontBold);
      case 'big_fish':
        return _buildPdfBigFishTable(data, font, fontBold);
      case 'summary':
        return _buildPdfSummaryTable(data, font, fontBold);
      case 'final':
        return _buildPdfFinalTable(data, font, fontBold);
      case 'casting':
        return _buildPdfCastingTable(data, font, fontBold);
      default:
        return pw.Text('Тип протокола не поддерживается', style: pw.TextStyle(font: font));
    }
  }

  // ✅ НОВЫЙ МЕТОД: Таблица для кастинга (PDF)
  pw.Widget _buildPdfCastingTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final bestInAttempts = (data['bestInAttempts'] as List<dynamic>?)?.cast<double>() ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final attemptsCount = data['attemptsCount'] as int? ?? 3;

    if (participantsData.isEmpty) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    // Заголовки
    final headers = [
      '№',
      'ФИО Спортсмена',
      'Карповое удилище',
      'Леска',
      ...List.generate(attemptsCount, (i) => 'Попытка №${i + 1}'),
      scoringMethod == 'best_distance' ? 'Лучший результат' : 'Средний балл',
      'Место',
    ];

    final rows = <List<String>>[];

    for (int i = 0; i < participantsData.length; i++) {
      final participant = participantsData[i] as Map<String, dynamic>;
      final attempts = (participant['attempts'] as List<dynamic>).cast<double>();
      final place = participant['place'] as int;

      final row = [
        '${i + 1}',
        participant['fullName']?.toString() ?? '',
        participant['rod']?.toString() ?? '',
        participant['line']?.toString() ?? '',
        ...attempts.map((a) => a > 0 ? a.toStringAsFixed(2) : '0'),
        scoringMethod == 'best_distance'
            ? (participant['bestDistance'] as double).toStringAsFixed(2)
            : (participant['averageDistance'] as double).toStringAsFixed(2),
        '$place',
      ];

      rows.add(row);
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 9),
      cellStyle: pw.TextStyle(fontSize: 8, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.center,
      headers: headers,
      data: rows,
      cellDecoration: (index, data, rowNum) {
        if (rowNum == null) return pw.BoxDecoration();

        final participant = participantsData[rowNum] as Map<String, dynamic>;
        final place = participant['place'] as int;
        final attempts = (participant['attempts'] as List<dynamic>).cast<double>();

        // Выделяем места (строки целиком)
        if (place == 1) {
          return pw.BoxDecoration(color: PdfColor.fromHex('#c8e6c9')); // Зелёный
        } else if (place == 2) {
          return pw.BoxDecoration(color: PdfColor.fromHex('#bbdefb')); // Синий
        } else if (place == 3) {
          return pw.BoxDecoration(color: PdfColor.fromHex('#fff9c4')); // Жёлтый
        }

        // Выделяем лучшие результаты в попытках зелёным
        if (index >= 4 && index < 4 + attemptsCount) {
          final attemptIndex = index - 4;
          if (attemptIndex < attempts.length && attemptIndex < bestInAttempts.length) {
            if (attempts[attemptIndex] > 0 && attempts[attemptIndex] == bestInAttempts[attemptIndex]) {
              return pw.BoxDecoration(color: PdfColor.fromHex('#a5d6a7')); // Светло-зелёный
            }
          }
        }

        return pw.BoxDecoration();
      },
    );
  }

  pw.Widget _buildPdfWeighingTable(Map<String, dynamic> data, bool showPlace, pw.Font font, pw.Font fontBold) {
    final tableData = data['tableData'] as List<dynamic>? ?? [];

    if (tableData.isEmpty) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 10),
      cellStyle: pw.TextStyle(fontSize: 9, font: font),
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

  pw.Widget _buildPdfBigFishTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 10),
      cellStyle: pw.TextStyle(fontSize: 9, font: font),
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

  pw.Widget _buildPdfSummaryTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final summaryData = data['summaryData'] as List<dynamic>? ?? [];

    if (summaryData.isEmpty) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 8),
      cellStyle: pw.TextStyle(fontSize: 7, font: font),
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

  pw.Widget _buildPdfFinalTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final finalData = data['finalData'] as List<dynamic>? ?? [];

    if (finalData.isEmpty) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 7),
      cellStyle: pw.TextStyle(fontSize: 6, font: font),
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

  pw.Widget _buildPdfSignature(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 15),

        if (data['judges'] != null)
          ...((data['judges'] as List<dynamic>).map((judge) {
            final judgeMap = judge as Map<String, dynamic>;
            final rank = judgeMap['rank']?.toString() ?? 'Судья';
            final name = judgeMap['name']?.toString() ?? '';

            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '$rank: $name',
                    style: pw.TextStyle(fontSize: 11, font: font),
                  ),
                  pw.Container(
                    width: 200,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    child: pw.SizedBox(height: 1),
                  ),
                ],
              ),
            );
          })),
      ],
    );
  }
// ===== EXCEL HELPERS =====

  int _addExcelHeader(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    if (data['organizer'] != null) {
      final titleRange = sheet.getRangeByIndex(row, 1, row, 10);
      titleRange.merge();
      titleRange.setText(data['organizer']);
      titleRange.cellStyle.bold = true;
      titleRange.cellStyle.fontSize = 14;
      titleRange.cellStyle.hAlign = xlsio.HAlignType.center;
      row++;
    }

    final protocolRange = sheet.getRangeByIndex(row, 1, row, 10);
    protocolRange.merge();
    protocolRange.setText(_getProtocolTitle(protocol));
    protocolRange.cellStyle.bold = true;
    protocolRange.cellStyle.fontSize = 16;
    protocolRange.cellStyle.hAlign = xlsio.HAlignType.center;
    row++;

    if (data['competitionName'] != null) {
      final nameRange = sheet.getRangeByIndex(row, 1, row, 10);
      nameRange.merge();
      nameRange.setText(data['competitionName']);
      nameRange.cellStyle.bold = true;
      nameRange.cellStyle.fontSize = 14;
      nameRange.cellStyle.hAlign = xlsio.HAlignType.center;
      row++;
    }

    return row;
  }

  int _addExcelLocationAndDate(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    final isSummaryOrFinal = protocol.type == 'summary' || protocol.type == 'final';
    final isCasting = protocol.type == 'casting';

    if (data['venue'] != null && isCasting) {
      sheet.getRangeByIndex(row, 1).setText('Место проведения: ${data['venue']}');
      row++;
    } else if (data['lake'] != null && !isCasting) {
      sheet.getRangeByIndex(row, 1).setText('Место проведения: ${data['lake']}');
      row++;
    }

    if (protocol.type == 'weighing' && data['weighingTime'] != null) {
      sheet.getRangeByIndex(row, 1).setText(
        'Дата и время: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['weighingTime']))}',
      );
    } else if (protocol.type == 'big_fish' && data['startTime'] != null && data['finishTime'] != null) {
      sheet.getRangeByIndex(row, 1).setText(
        'Период: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['finishTime']))}',
      );
    } else if ((isSummaryOrFinal || isCasting) && data['startTime'] != null && data['finishTime'] != null) {
      sheet.getRangeByIndex(row, 1).setText(
        'Даты соревнования: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy').format(DateTime.parse(data['finishTime']))}',
      );
    }

    if (isSummaryOrFinal || isCasting) {
      sheet.getRangeByIndex(row, 10).setText(
        'Дата формирования протокола: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
      );
      sheet.getRangeByIndex(row, 10).cellStyle.hAlign = xlsio.HAlignType.right;
    }

    row++;
    return row;
  }

  int _addExcelTable(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    if (protocol.type == 'casting') {
      return _addExcelCastingTable(sheet, data, row);
    }

    final headers = _getExcelHeaders(protocol.type);
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(row, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
    }
    row++;

    final tableData = _getExcelData(protocol, data);
    for (final rowData in tableData) {
      for (int i = 0; i < rowData.length; i++) {
        sheet.getRangeByIndex(row, i + 1).setText(rowData[i]);
      }
      row++;
    }

    return row;
  }

  // ✅ НОВЫЙ МЕТОД: Таблица для кастинга (Excel)
  int _addExcelCastingTable(xlsio.Worksheet sheet, Map<String, dynamic> data, int row) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final bestInAttempts = (data['bestInAttempts'] as List<dynamic>?)?.cast<double>() ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final attemptsCount = data['attemptsCount'] as int? ?? 3;

    // Заголовки
    final headers = [
      '№',
      'ФИО Спортсмена',
      'Карповое удилище',
      'Леска',
      ...List.generate(attemptsCount, (i) => 'Попытка №${i + 1}'),
      scoringMethod == 'best_distance' ? 'Лучший результат' : 'Средний балл',
      'Место',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(row, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
    }
    row++;

    // Данные
    for (int i = 0; i < participantsData.length; i++) {
      final participant = participantsData[i] as Map<String, dynamic>;
      final attempts = (participant['attempts'] as List<dynamic>).cast<double>();
      final place = participant['place'] as int;

      int col = 1;

      // №
      sheet.getRangeByIndex(row, col++).setNumber(i + 1);

      // ФИО
      sheet.getRangeByIndex(row, col++).setText(participant['fullName']?.toString() ?? '');

      // Удилище
      sheet.getRangeByIndex(row, col++).setText(participant['rod']?.toString() ?? '');

      // Леска
      sheet.getRangeByIndex(row, col++).setText(participant['line']?.toString() ?? '');

      // Попытки
      for (int attemptIndex = 0; attemptIndex < attemptsCount; attemptIndex++) {
        final attemptCell = sheet.getRangeByIndex(row, col++);

        if (attemptIndex < attempts.length) {
          final distance = attempts[attemptIndex];

          if (distance > 0) {
            attemptCell.setNumber(distance);
            attemptCell.numberFormat = '0.00';

            // Выделяем лучший результат в попытке зелёным
            if (attemptIndex < bestInAttempts.length && distance == bestInAttempts[attemptIndex]) {
              attemptCell.cellStyle.backColor = '#A5D6A7'; // Светло-зелёный
            }
          } else {
            attemptCell.setText('0');
            attemptCell.cellStyle.backColor = '#FFCDD2'; // Красный (незасчитанная)
          }
        } else {
          attemptCell.setText('0');
        }

        attemptCell.cellStyle.hAlign = xlsio.HAlignType.center;
      }

      // Результат (лучший или средний)
      final resultCell = sheet.getRangeByIndex(row, col++);
      if (scoringMethod == 'best_distance') {
        resultCell.setNumber(participant['bestDistance'] as double);
      } else {
        resultCell.setNumber(participant['averageDistance'] as double);
      }
      resultCell.numberFormat = '0.00';
      resultCell.cellStyle.hAlign = xlsio.HAlignType.center;
      resultCell.cellStyle.bold = true;

      // Место
      final placeCell = sheet.getRangeByIndex(row, col++);
      placeCell.setNumber(place.toDouble());
      placeCell.cellStyle.hAlign = xlsio.HAlignType.center;
      placeCell.cellStyle.bold = true;

      // Выделяем места цветом (вся строка)
      String? rowColor;
      if (place == 1) {
        rowColor = '#C8E6C9'; // Зелёный
      } else if (place == 2) {
        rowColor = '#BBDEFB'; // Синий
      } else if (place == 3) {
        rowColor = '#FFF9C4'; // Жёлтый
      }

      if (rowColor != null) {
        for (int c = 1; c <= col; c++) {
          sheet.getRangeByIndex(row, c).cellStyle.backColor = rowColor;
        }
      }

      row++;
    }

    return row;
  }

  void _addExcelSignature(xlsio.Worksheet sheet, Map<String, dynamic> data, int row) {
    if (data['judges'] != null) {
      for (final judge in data['judges'] as List<dynamic>) {
        final judgeMap = judge as Map<String, dynamic>;
        final rank = judgeMap['rank']?.toString() ?? 'Судья';
        final name = judgeMap['name']?.toString() ?? '';

        sheet.getRangeByIndex(row, 1).setText('$rank: $name _______________');
        row++;
      }
    }
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
      case 'casting':
        return 'Протокол соревнования по кастингу';
      default:
        return 'Протокол соревнования';
    }
  }
}
