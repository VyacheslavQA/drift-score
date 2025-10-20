import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:easy_localization/easy_localization.dart';

import 'package:drift_score/data/models/local/protocol_local.dart';
import '../../core/base_pdf_builder.dart';
import '../../core/export_types.dart';
import '../../core/font_loader.dart';

class CarpPdfBuilder extends BasePdfBuilder {
  @override
  Future<pw.Widget> buildContent(
      ProtocolType type,
      Map<String, dynamic> data,
      ) async {
    final font = await FontLoader.loadRegularFont();
    final fontBold = await FontLoader.loadBoldFont();

    switch (type) {
      case ProtocolType.weighing:
        return _buildPdfWeighingTable(data, false, font, fontBold);

      case ProtocolType.intermediate:
        return _buildPdfWeighingTable(data, true, font, fontBold);

      case ProtocolType.bigFish:
        return _buildPdfBigFishTable(data, font, fontBold);

      case ProtocolType.summary:
        return _buildPdfSummaryTable(data, font, fontBold);

      case ProtocolType.finalProtocol:
        return _buildPdfFinalTable(data, font, fontBold);

      case ProtocolType.draw:
        return _buildPdfDrawTable(data, font, fontBold);

      default:
        return pw.Text(
          'protocol_type_not_supported'.tr(),
          style: pw.TextStyle(fontSize: 12, font: font),
        );
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

  pw.Widget _buildPdfWeighingTable(
      Map<String, dynamic> data,
      bool showPlace,
      pw.Font font,
      pw.Font fontBold,
      ) {
    final tableData = data['tableData'] as List<dynamic>? ?? [];

    if (tableData.isEmpty) {
      return pw.Text(
        'protocol_no_data'.tr(),
        style: pw.TextStyle(fontSize: 11, font: font),
      );
    }

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

    final rows = <List<String>>[];

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

      rows.add(rowData);
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 10),
      cellStyle: pw.TextStyle(fontSize: 9, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
      headers: headers,
      data: rows,
    );
  }

  pw.Widget _buildPdfBigFishTable(
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return pw.Text(
        'protocol_big_fish_no_data'.tr(),
        style: pw.TextStyle(fontSize: 11, font: font),
      );
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 10),
      cellStyle: pw.TextStyle(fontSize: 9, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: [
        'team'.tr(),
        'field_fish_type'.tr(),
        'weight'.tr(),
        'length'.tr(),
        'sector'.tr(),
        'field_time'.tr(),
      ],
      data: [
        [
          bigFish['teamName']?.toString() ?? '',
          bigFish['fishType']?.toString() ?? '',
          ((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3),
          '${bigFish['length'] ?? ''}',
          '${bigFish['sector'] ?? ''}',
          bigFish['weighingTime'] != null
              ? _formatDateTime(bigFish['weighingTime'])
              : '',
        ],
      ],
    );
  }

  pw.Widget _buildPdfSummaryTable(
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    final summaryData = data['summaryData'] as List<dynamic>? ?? [];

    if (summaryData.isEmpty) {
      return pw.Text(
        'protocol_no_data'.tr(),
        style: pw.TextStyle(fontSize: 11, font: font),
      );
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 8),
      cellStyle: pw.TextStyle(fontSize: 7, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: [
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
      ],
      data: summaryData.map((teamData) {
        final teamMap = teamData as Map<String, dynamic>;
        final members = (teamMap['members'] as List<dynamic>?) ?? [];
        final memberNames = members
            .map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '')
            .join('\n');
        final memberRanks = members
            .map((m) => (m as Map<String, dynamic>)['rank']?.toString() ?? '')
            .join('\n');

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

  pw.Widget _buildPdfFinalTable(
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    final finalData = data['finalData'] as List<dynamic>? ?? [];
    final competitionBiggestFish = data['competitionBiggestFish'] as Map<String, dynamic>?;

    if (finalData.isEmpty) {
      return pw.Text(
        'protocol_no_data'.tr(),
        style: pw.TextStyle(fontSize: 11, font: font),
      );
    }

    final mainTable = pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 7),
      cellStyle: pw.TextStyle(fontSize: 6, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: [
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
      ],
      data: finalData.map((row) {
        final rowMap = row as Map<String, dynamic>;
        final members = (rowMap['members'] as List<dynamic>?) ?? [];
        final memberNames = members
            .map((m) => (m as Map<String, dynamic>)['fullName']?.toString() ?? '')
            .join('\n');
        final memberRanks = members
            .map((m) => (m as Map<String, dynamic>)['rank']?.toString() ?? '')
            .join('\n');

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

    if (competitionBiggestFish == null) {
      return mainTable;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        mainTable,
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.amber100,
            border: pw.Border.all(color: PdfColors.amber, width: 2),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BIG FISH',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 14,
                  color: PdfColors.orange900,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.amber),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.amber200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('team'.tr(), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('field_fish_type'.tr(), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('weight'.tr(), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                      ),
                      if ((competitionBiggestFish['length'] as int?) != null && competitionBiggestFish['length'] != 0)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('length'.tr(), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                        ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('sector'.tr(), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('field_time'.tr(), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(competitionBiggestFish['teamName']?.toString() ?? '', style: pw.TextStyle(font: font, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(competitionBiggestFish['fishType']?.toString() ?? '', style: pw.TextStyle(font: font, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          ((competitionBiggestFish['weight'] as num?) ?? 0).toStringAsFixed(3),
                          style: pw.TextStyle(font: fontBold, fontSize: 10),
                        ),
                      ),
                      if ((competitionBiggestFish['length'] as int?) != null && competitionBiggestFish['length'] != 0)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('${competitionBiggestFish['length']}', style: pw.TextStyle(font: font, fontSize: 8)),
                        ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('${competitionBiggestFish['sector'] ?? ''}', style: pw.TextStyle(font: font, fontSize: 8)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          competitionBiggestFish['weighingTime'] != null
                              ? _formatDateTime(competitionBiggestFish['weighingTime'])
                              : '',
                          style: pw.TextStyle(font: font, fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfDrawTable(
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    final drawData = data['drawData'] as List<dynamic>? ?? [];

    if (drawData.isEmpty) {
      return pw.Text(
        'no_draw_data'.tr(),
        style: pw.TextStyle(fontSize: 11, font: font),
      );
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(font: fontBold, fontSize: 10),
      cellStyle: pw.TextStyle(fontSize: 9, font: font),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.center,
      headers: [
        'field_order'.tr(),
        'team'.tr(),
        'city'.tr(),
        'draw_number'.tr(),
        'sector'.tr(),
      ],
      data: drawData.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final row = entry.value as Map<String, dynamic>;

        return [
          '$index',
          row['teamName']?.toString() ?? '',
          row['city']?.toString() ?? '',
          '${row['drawOrder'] ?? '-'}',
          '${row['sector'] ?? '-'}',
        ];
      }).toList(),
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }
}