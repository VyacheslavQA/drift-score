import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/local/protocol_local.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

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

  // Перевод рангов судей
  String _translateJudgeRank(String rank) {
    switch (rank.toLowerCase()) {
      case 'chief_judge':
      case 'judge_chief':
        return 'Главный судья';
      case 'judge':
      case 'judge_regular':
        return 'Судья';
      case 'secretary':
      case 'judge_assistant':
        return 'Секретарь';
      default:
        return 'Судья';
    }
  }

  Future<void> exportToPdf(ProtocolLocal protocol, Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final font = await _loadRegularFont();
    final fontBold = await _loadBoldFont();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
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

  // ========== PDF: ШАПКА (ПО ЦЕНТРУ) ==========
  pw.Widget _buildPdfHeader(ProtocolLocal protocol, Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    return pw.Center(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
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
      ),
    );
  }

  // ========== PDF: МЕСТО ПРОВЕДЕНИЯ И ДАТЫ ==========
  pw.Widget _buildPdfLocationAndDate(ProtocolLocal protocol, Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Левая часть: место и даты соревнования
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Место проведения
            if (data['venueFormatted'] != null && data['venueFormatted'].toString().isNotEmpty)
              pw.Text(
                'Место проведения: ${data['venueFormatted']}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),

            pw.SizedBox(height: 4),

            // Дата/даты соревнования
            if (data['competitionDates'] != null)
              pw.Text(
                '${_getDateLabel(data)}: ${data['competitionDates']}',
                style: pw.TextStyle(fontSize: 11, font: font),
              ),
          ],
        ),

        // Правая часть: дата формирования протокола
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Дата формирования протокола:',
              style: pw.TextStyle(fontSize: 10, font: font),
            ),
            pw.Text(
              DateFormat('dd.MM.yyyy').format(DateTime.now()),
              style: pw.TextStyle(fontSize: 10, font: fontBold),
            ),
          ],
        ),
      ],
    );
  }

  // Определение подписи даты (единственное/множественное число)
  String _getDateLabel(Map<String, dynamic> data) {
    final dateKey = data['dateKey'] as String?;
    if (dateKey == 'competition_date_single') {
      return 'Дата соревнования';
    } else {
      return 'Даты соревнования';
    }
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
      case 'casting_attempt':
        return _buildPdfCastingAttemptTable(data, font, fontBold);
      case 'casting_intermediate':
      case 'casting_final':
        return _buildPdfCastingFullTable(data, font, fontBold);
      case 'draw':
        return _buildPdfDrawTable(data, font, fontBold);
      default:
        return pw.Text('Тип протокола не поддерживается', style: pw.TextStyle(font: font));
    }
  }

  // ========== PDF: ПРОТОКОЛ ЖЕРЕБЬЁВКИ ==========
  pw.Widget _buildPdfDrawTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final drawData = data['drawData'] as List<dynamic>? ?? [];

    if (drawData.isEmpty) {
      return pw.Center(
        child: pw.Text(
          'Нет данных о жеребьёвке',
          style: pw.TextStyle(font: font, fontSize: 12),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FixedColumnWidth(40),  // № п/п
        1: const pw.FlexColumnWidth(3),    // Команда
        2: const pw.FlexColumnWidth(2),    // Город
        3: const pw.FixedColumnWidth(80),  // № жеребьёвки
        4: const pw.FixedColumnWidth(60),  // Сектор
      },
      children: [
        // Заголовок таблицы
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildPdfCell('№ п/п', fontBold, isHeader: true),
            _buildPdfCell('Команда', fontBold, isHeader: true),
            _buildPdfCell('Город', fontBold, isHeader: true),
            _buildPdfCell('№ жеребьёвки', fontBold, isHeader: true),
            _buildPdfCell('Сектор', fontBold, isHeader: true),
          ],
        ),
        // Строки данных
        ...drawData.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final row = entry.value as Map<String, dynamic>;

          return pw.TableRow(
            children: [
              _buildPdfCell('$index', font),
              _buildPdfCell(row['teamName']?.toString() ?? '', fontBold),
              _buildPdfCell(row['city']?.toString() ?? '', font),
              _buildPdfCell('${row['drawOrder'] ?? '-'}', fontBold),
              _buildPdfCell('${row['sector'] ?? '-'}', fontBold),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Вспомогательный метод для создания ячейки таблицы
  pw.Widget _buildPdfCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: isHeader ? 10 : 9,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // ========== PDF: КАСТИНГ ПРОТОКОЛ ПОПЫТКИ ==========
  pw.Widget _buildPdfCastingAttemptTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];

    if (participantsData.isEmpty) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    final headers = ['Место', 'ФИО Спортсмена', 'Карповое удилище', 'Леска', 'Дальность (м)'];

    final rows = <List<String>>[];
    for (final participant in participantsData) {
      final participantMap = participant as Map<String, dynamic>;
      rows.add([
        '${participantMap['place']}',
        participantMap['fullName']?.toString() ?? '',
        participantMap['rod']?.toString() ?? '',
        participantMap['line']?.toString() ?? '',
        (participantMap['distance'] as double).toStringAsFixed(2),
      ]);
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 10),
      cellStyle: pw.TextStyle(fontSize: 9, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.center,
      headers: headers,
      data: rows,
    );
  }

  // ========== PDF: КАСТИНГ ПРОМЕЖУТОЧНЫЙ/ФИНАЛЬНЫЙ ==========
  pw.Widget _buildPdfCastingFullTable(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final attemptsCount = (data['attemptsCount'] as int?) ?? (data['upToAttempt'] as int?) ?? 3;

    if (participantsData.isEmpty) {
      return pw.Text('Нет данных', style: pw.TextStyle(font: font));
    }

    final headers = [
      '№',
      'ФИО',
      'Удилище',
      'Леска',
      ...List.generate(attemptsCount, (i) => 'Попытка №${i + 1}'),
      scoringMethod == 'best_distance' ? 'Лучший' : 'Средний',
      'Место',
    ];

    final rows = <List<String>>[];

    for (int i = 0; i < participantsData.length; i++) {
      final participant = participantsData[i] as Map<String, dynamic>;
      final attempts = (participant['attempts'] as List<dynamic>).cast<double>();

      final row = [
        '${i + 1}',
        participant['fullName']?.toString() ?? '',
        participant['rod']?.toString() ?? '',
        participant['line']?.toString() ?? '',
        ...attempts.map((a) => a > 0 ? a.toStringAsFixed(2) : '0'),
        scoringMethod == 'best_distance'
            ? (participant['bestDistance'] as double).toStringAsFixed(2)
            : (participant['averageDistance'] as double).toStringAsFixed(2),
        '${participant['place']}',
      ];

      rows.add(row);
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 8),
      cellStyle: pw.TextStyle(fontSize: 7, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.center,
      headers: headers,
      data: rows,
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
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
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

  // ========== PDF: ПОДПИСИ СУДЕЙ (СПРАВА ВНИЗУ) ==========
  pw.Widget _buildPdfSignature(Map<String, dynamic> data, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.SizedBox(height: 10),

        if (data['judges'] != null)
          ...((data['judges'] as List<dynamic>).map((judge) {
            final judgeMap = judge as Map<String, dynamic>;
            final rank = _translateJudgeRank(judgeMap['rank']?.toString() ?? '');
            final name = judgeMap['name']?.toString() ?? '';

            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    '$rank: ',
                    style: pw.TextStyle(fontSize: 10, font: font),
                  ),
                  pw.Container(
                    width: 150,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    child: pw.SizedBox(height: 1),
                  ),
                  pw.SizedBox(width: 5),
                  pw.Text(
                    name,
                    style: pw.TextStyle(fontSize: 10, font: font),
                  ),
                ],
              ),
            );
          })),
      ],
    );
  }

  // ========== EXCEL: ШАПКА ==========

  int _addExcelHeader(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    final protocolRange = sheet.getRangeByIndex(row, 1, row, 10);
    protocolRange.merge();
    protocolRange.setText(_getProtocolTitle(protocol));
    protocolRange.cellStyle.bold = true;
    protocolRange.cellStyle.fontSize = 16;
    protocolRange.cellStyle.hAlign = xlsio.HAlignType.center;
    protocolRange.cellStyle.vAlign = xlsio.VAlignType.center;
    row++;

    if (data['competitionName'] != null) {
      final nameRange = sheet.getRangeByIndex(row, 1, row, 10);
      nameRange.merge();
      nameRange.setText(data['competitionName']);
      nameRange.cellStyle.bold = true;
      nameRange.cellStyle.fontSize = 14;
      nameRange.cellStyle.hAlign = xlsio.HAlignType.center;
      nameRange.cellStyle.vAlign = xlsio.VAlignType.center;
      row++;
    }

    return row;
  }

  int _addExcelLocationAndDate(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    // Место проведения (слева)
    if (data['venueFormatted'] != null && data['venueFormatted'].toString().isNotEmpty) {
      sheet.getRangeByIndex(row, 1).setText('Место проведения: ${data['venueFormatted']}');
    }

    // Дата формирования протокола (справа)
    final dateFormationCell = sheet.getRangeByIndex(row, 10);
    dateFormationCell.setText('Дата формирования протокола: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}');
    dateFormationCell.cellStyle.hAlign = xlsio.HAlignType.right;
    row++;

    // Дата/даты соревнования (слева)
    if (data['competitionDates'] != null) {
      sheet.getRangeByIndex(row, 1).setText('${_getDateLabel(data)}: ${data['competitionDates']}');
      row++;
    }

    return row;
  }

  int _addExcelTable(xlsio.Worksheet sheet, ProtocolLocal protocol, Map<String, dynamic> data, int row) {
    if (protocol.type == 'casting_attempt') {
      return _addExcelCastingAttemptTable(sheet, data, row);
    } else if (protocol.type == 'casting_intermediate' || protocol.type == 'casting_final') {
      return _addExcelCastingFullTable(sheet, data, row);
    } else if (protocol.type == 'draw') {
      return _addExcelDrawTable(sheet, data, row);
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

  // ========== EXCEL: ПРОТОКОЛ ЖЕРЕБЬЁВКИ ==========
  int _addExcelDrawTable(xlsio.Worksheet sheet, Map<String, dynamic> data, int startRow) {
    final drawData = data['drawData'] as List<dynamic>? ?? [];

    if (drawData.isEmpty) {
      sheet.getRangeByIndex(startRow, 1).setText('Нет данных о жеребьёвке');
      return startRow + 1;
    }

    int currentRow = startRow;

    // Заголовки таблицы
    final headers = ['№ п/п', 'Команда', 'Город', '№ жеребьёвки', 'Сектор'];

    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.getRangeByIndex(currentRow, col + 1);
      cell.setText(headers[col]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#E0E0E0';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      cell.cellStyle.vAlign = xlsio.VAlignType.center;
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    }

    currentRow++;

    // Данные таблицы
    for (int i = 0; i < drawData.length; i++) {
      final row = drawData[i] as Map<String, dynamic>;
      final rowNumber = i + 1;

      // № п/п
      var cell = sheet.getRangeByIndex(currentRow, 1);
      cell.setNumber(rowNumber.toDouble());
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

      // Команда
      cell = sheet.getRangeByIndex(currentRow, 2);
      cell.setText(row['teamName']?.toString() ?? '');
      cell.cellStyle.bold = true;
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

      // Город
      cell = sheet.getRangeByIndex(currentRow, 3);
      cell.setText(row['city']?.toString() ?? '');
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

      // № жеребьёвки
      cell = sheet.getRangeByIndex(currentRow, 4);
      final drawOrder = row['drawOrder'];
      if (drawOrder != null) {
        cell.setNumber(drawOrder.toDouble());
      } else {
        cell.setText('-');
      }
      cell.cellStyle.bold = true;
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      cell.cellStyle.backColor = '#BBDEFB';
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

      // Сектор
      cell = sheet.getRangeByIndex(currentRow, 5);
      final sector = row['sector'];
      if (sector != null) {
        cell.setNumber(sector.toDouble());
      } else {
        cell.setText('-');
      }
      cell.cellStyle.bold = true;
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      cell.cellStyle.backColor = '#C8E6C9';
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

      currentRow++;
    }

    // Автоподбор ширины столбцов
    sheet.getRangeByIndex(startRow, 1, currentRow - 1, 5).autoFitColumns();

    return currentRow;
  }

  // ========== EXCEL: КАСТИНГ ПОПЫТКА ==========
  int _addExcelCastingAttemptTable(xlsio.Worksheet sheet, Map<String, dynamic> data, int row) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];

    final headers = ['Место', 'ФИО Спортсмена', 'Карповое удилище', 'Леска', 'Дальность (м)'];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(row, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#D3D3D3';
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
    }
    row++;

    for (final participant in participantsData) {
      final participantMap = participant as Map<String, dynamic>;
      final place = participantMap['place'] as int;

      sheet.getRangeByIndex(row, 1).setNumber(place.toDouble());
      sheet.getRangeByIndex(row, 2).setText(participantMap['fullName']?.toString() ?? '');
      sheet.getRangeByIndex(row, 3).setText(participantMap['rod']?.toString() ?? '');
      sheet.getRangeByIndex(row, 4).setText(participantMap['line']?.toString() ?? '');

      final distanceCell = sheet.getRangeByIndex(row, 5);
      distanceCell.setNumber(participantMap['distance'] as double);
      distanceCell.numberFormat = '0.00';

      row++;
    }

    return row;
  }

  // ========== EXCEL: КАСТИНГ ПРОМЕЖУТОЧНЫЙ/ФИНАЛЬНЫЙ ==========
  int _addExcelCastingFullTable(xlsio.Worksheet sheet, Map<String, dynamic> data, int row) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final attemptsCount = (data['attemptsCount'] as int?) ?? (data['upToAttempt'] as int?) ?? 3;

    final headers = [
      '№',
      'ФИО',
      'Удилище',
      'Леска',
      ...List.generate(attemptsCount, (i) => 'Попытка №${i + 1}'),
      scoringMethod == 'best_distance' ? 'Лучший' : 'Средний',
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

    for (int i = 0; i < participantsData.length; i++) {
      final participant = participantsData[i] as Map<String, dynamic>;
      final attempts = (participant['attempts'] as List<dynamic>).cast<double>();
      final place = participant['place'] as int;

      int col = 1;

      sheet.getRangeByIndex(row, col++).setNumber((i + 1).toDouble());
      sheet.getRangeByIndex(row, col++).setText(participant['fullName']?.toString() ?? '');
      sheet.getRangeByIndex(row, col++).setText(participant['rod']?.toString() ?? '');
      sheet.getRangeByIndex(row, col++).setText(participant['line']?.toString() ?? '');

      for (int attemptIndex = 0; attemptIndex < attemptsCount; attemptIndex++) {
        final attemptCell = sheet.getRangeByIndex(row, col++);

        if (attemptIndex < attempts.length) {
          final distance = attempts[attemptIndex];

          if (distance > 0) {
            attemptCell.setNumber(distance);
            attemptCell.numberFormat = '0.00';
          } else {
            attemptCell.setText('0');
          }
        } else {
          attemptCell.setText('0');
        }

        attemptCell.cellStyle.hAlign = xlsio.HAlignType.center;
      }

      final resultCell = sheet.getRangeByIndex(row, col++);
      if (scoringMethod == 'best_distance') {
        resultCell.setNumber(participant['bestDistance'] as double);
      } else {
        resultCell.setNumber(participant['averageDistance'] as double);
      }
      resultCell.numberFormat = '0.00';
      resultCell.cellStyle.hAlign = xlsio.HAlignType.center;
      resultCell.cellStyle.bold = true;

      final placeCell = sheet.getRangeByIndex(row, col++);
      placeCell.setNumber(place.toDouble());
      placeCell.cellStyle.hAlign = xlsio.HAlignType.center;
      placeCell.cellStyle.bold = true;

      row++;
    }

    return row;
  }

  // ========== EXCEL: ПОДПИСИ СУДЕЙ (СПРАВА) ==========
  void _addExcelSignature(xlsio.Worksheet sheet, Map<String, dynamic> data, int row) {
    if (data['judges'] != null) {
      for (final judge in data['judges'] as List<dynamic>) {
        final judgeMap = judge as Map<String, dynamic>;
        final rank = _translateJudgeRank(judgeMap['rank']?.toString() ?? '');
        final name = judgeMap['name']?.toString() ?? '';

        // Подпись справа (колонка 8-10)
        final signatureRange = sheet.getRangeByIndex(row, 8, row, 10);
        signatureRange.merge();
        signatureRange.setText('$rank: _______________ $name');
        signatureRange.cellStyle.hAlign = xlsio.HAlignType.right;
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
      case 'draw':
        return ['№ п/п', 'Команда', 'Город', '№ жеребьёвки', 'Сектор'];
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

  Future<void> _savePdf(pw.Document pdf, ProtocolLocal protocol) async {
    try {
      final output = await getTemporaryDirectory();
      final fileName = 'protocol_${protocol.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');

      print('💾 Saving PDF to: ${file.path}');
      await file.writeAsBytes(await pdf.save());
      print('✅ PDF saved successfully: ${file.path}');

      print('📤 Sharing PDF...');
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: _getProtocolTitle(protocol),
      );
      print('✅ Share result: $result');
    } catch (e) {
      print('❌ Error saving/sharing PDF: $e');
      rethrow;
    }
  }

  Future<void> _saveExcel(xlsio.Workbook workbook, ProtocolLocal protocol) async {
    try {
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final output = await getTemporaryDirectory();
      final fileName = 'protocol_${protocol.id}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File('${output.path}/$fileName');

      print('💾 Saving Excel to: ${file.path}');
      await file.writeAsBytes(bytes);
      print('✅ Excel saved successfully: ${file.path}');

      print('📤 Sharing Excel...');
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: _getProtocolTitle(protocol),
      );
      print('✅ Share result: $result');
    } catch (e) {
      print('❌ Error saving/sharing Excel: $e');
      rethrow;
    }
  }

  String _getProtocolTitle(ProtocolLocal protocol) {
    switch (protocol.type) {
      case 'weighing':
        return 'Протокол взвешивания День ${protocol.dayNumber}, №${protocol.weighingNumber}';
      case 'intermediate':
        return 'Промежуточный протокол';
      case 'big_fish':
        return 'Big Fish - День ${protocol.bigFishDay}';
      case 'summary':
        return 'Сводный протокол';
      case 'final':
        return 'Финальный протокол';
      case 'casting_attempt':
        return 'Попытка №${protocol.weighingNumber}';
      case 'casting_intermediate':
        return 'Промежуточный протокол после ${protocol.weighingNumber} попыток';
      case 'casting_final':
        return 'Финальный протокол';
      case 'draw':
        return 'Протокол жеребьёвки';
      default:
        return 'Протокол соревнования';
    }
  }
}