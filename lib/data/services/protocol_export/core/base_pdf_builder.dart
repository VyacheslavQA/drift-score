import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:drift_score/data/models/local/protocol_local.dart';
import 'export_types.dart';
import 'font_loader.dart';
import '../utils/signature_builder.dart';
import '../utils/date_formatter.dart';

/// Базовый класс для построения PDF протоколов
///
/// Предоставляет общую функциональность для всех PDF builders
abstract class BasePdfBuilder {
  pw.Font? _regularFont;
  pw.Font? _boldFont;

  /// Загрузка обычного шрифта с кэшированием
  Future<pw.Font> _loadRegularFont() async {
    _regularFont ??= await FontLoader.loadRegularFont();
    return _regularFont!;
  }

  /// Загрузка жирного шрифта с кэшированием
  Future<pw.Font> _loadBoldFont() async {
    _boldFont ??= await FontLoader.loadBoldFont();
    return _boldFont!;
  }

  /// Главный метод для построения и сохранения PDF
  Future<void> buildAndSave({
    required ProtocolType protocolType,
    required Map<String, dynamic> data,
    required int protocolId,
  }) async {
    final pdf = pw.Document();
    final font = await _loadRegularFont();
    final fontBold = await _loadBoldFont();

    // Строим содержимое заранее
    final content = await buildContent(protocolType, data);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(protocolType, data, font, fontBold),
              pw.SizedBox(height: 15),
              _buildLocationAndDate(data, font, fontBold),
              pw.SizedBox(height: 15),
              content, // Используем готовый контент
              pw.Spacer(),
              _buildSignatures(data, font, fontBold),
            ],
          );
        },
      ),
    );

    await _savePdf(pdf, protocolId, protocolType, data);
  }

  /// Абстрактный метод для построения содержимого протокола
  ///
  /// Каждый конкретный builder должен реализовать этот метод
  Future<pw.Widget> buildContent(
      ProtocolType type,
      Map<String, dynamic> data,
      );

  /// Абстрактный метод для получения заголовка протокола
  ///
  /// Каждый конкретный builder должен реализовать этот метод
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data);

  // ========== ШАПКА ПРОТОКОЛА ==========

  pw.Widget _buildHeader(
      ProtocolType protocolType,
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    return pw.Center(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            getProtocolTitle(protocolType, data),
            style: pw.TextStyle(
              fontSize: 16.0,
              font: fontBold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          if (data['competitionName'] != null)
            pw.Text(
              data['competitionName'],
              style: pw.TextStyle(
                fontSize: 14.0,
                font: fontBold,
              ),
              textAlign: pw.TextAlign.center,
            ),
        ],
      ),
    );
  }

  // ========== МЕСТО ПРОВЕДЕНИЯ И ДАТЫ ==========

  pw.Widget _buildLocationAndDate(
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Левая часть: место и даты соревнования
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Место проведения - с локализацией
            if (data['venueFormatted'] != null &&
                data['venueFormatted'].toString().isNotEmpty)
              pw.Text(
                'protocol_venue_label'.tr() + ' ${data['venueFormatted']}',
                style: pw.TextStyle(
                  fontSize: 11.0,
                  font: font,
                ),
              ),

            pw.SizedBox(height: 4),

            // Дата/даты соревнования - с локализацией через DateFormatter
            if (data['competitionDates'] != null)
              pw.Text(
                '${DateFormatter.getDateLabel(data)}: ${data['competitionDates']}',
                style: pw.TextStyle(
                  fontSize: 11.0,
                  font: font,
                ),
              ),
          ],
        ),

        // Правая часть: дата формирования протокола - с локализацией
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'protocol_formation_date_label'.tr(),
              style: pw.TextStyle(
                fontSize: 10.0,
                font: font,
              ),
            ),
            pw.Text(
              DateFormat('dd.MM.yyyy').format(DateTime.now()),
              style: pw.TextStyle(
                fontSize: 10.0,
                font: fontBold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== СОХРАНЕНИЕ PDF ==========

  Future<void> _savePdf(
      pw.Document pdf,
      int protocolId,
      ProtocolType protocolType,
      Map<String, dynamic> data,
      ) async {
    try {
      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = _generateFileName(protocolId, protocolType, timestamp);
      final file = File('${output.path}/$fileName');

      print('💾 Saving PDF to: ${file.path}');
      await file.writeAsBytes(await pdf.save());
      print('✅ PDF saved successfully: ${file.path}');

      print('📤 Sharing PDF...');
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: getProtocolTitle(protocolType, data),
      );
      print('✅ Share result: $result');
    } catch (e) {
      print('❌ Error saving/sharing PDF: $e');
      rethrow;
    }
  }

  /// Построение блока подписей
  pw.Widget _buildSignatures(
      Map<String, dynamic> data,
      pw.Font font,
      pw.Font fontBold,
      ) {
    final judges = data['judges'] as List<dynamic>? ?? [];

    if (judges.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.SizedBox(height: 10),
        ...judges.map((judge) {
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
        }).toList(),
      ],
    );
  }

  /// Перевод рангов судей - с локализацией
  String _translateJudgeRank(String rank) {
    switch (rank.toLowerCase()) {
      case 'chief_judge':
      case 'judge_chief':
        return 'judge_chief'.tr();
      case 'judge':
      case 'judge_regular':
        return 'judge_regular'.tr();
      case 'secretary':
      case 'judge_assistant':
        return 'judge_secretary'.tr();
      default:
        return 'judge_regular'.tr();
    }
  }

  String _generateFileName(
      int protocolId,
      ProtocolType protocolType,
      String timestamp,
      ) {
    return 'protocol_${protocolId}_${protocolType.name}_$timestamp.pdf';
  }
}