import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:easy_localization/easy_localization.dart';

import 'package:drift_score/data/models/local/protocol_local.dart';
import '../../core/base_pdf_builder.dart';
import '../../core/font_loader.dart';
import '../../core/export_types.dart';

/// PDF Builder для кастинговых соревнований
///
/// Поддерживает все типы протоколов кастинга:
/// - casting_attempt (Протокол попытки)
/// - casting_intermediate (Промежуточный протокол)
/// - casting_final (Финальный протокол)
class CastingPdfBuilder extends BasePdfBuilder {
  @override
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data) {
    switch (type) {
      case ProtocolType.castingAttempt:
        return 'protocol_casting_attempt'.tr().toUpperCase();
      case ProtocolType.castingIntermediate:
        return 'casting_intermediate'.tr().toUpperCase();
      case ProtocolType.castingFinal:
        return 'casting_final'.tr().toUpperCase();
      default:
        return 'protocol_casting'.tr().toUpperCase();
    }
  }

  @override
  Future<pw.Widget> buildContent(
      ProtocolType type,
      Map<String, dynamic> data,
      ) async {
    switch (type) {
      case ProtocolType.castingAttempt:
        return await _buildAttemptTable(data);
      case ProtocolType.castingIntermediate:
      case ProtocolType.castingFinal:
        return await _buildFullTable(data);
      default:
        throw UnsupportedError('protocol_type_not_supported'.tr());
    }
  }

  // ========== ПРОТОКОЛ ПОПЫТКИ ==========

  /// Построение таблицы для протокола попытки
  Future<pw.Widget> _buildAttemptTable(Map<String, dynamic> data) async {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];

    if (participantsData.isEmpty) {
      return pw.Center(
        child: pw.Text('protocol_no_participant_data'.tr()),
      );
    }

    final font = await FontLoader.loadRegularFont();

    return pw.Table.fromTextArray(
      context: null,
      border: pw.TableBorder.all(),
      headerAlignment: pw.Alignment.center,
      cellAlignment: pw.Alignment.center,
      headerStyle: pw.TextStyle(
        fontSize: 11.0,
        fontWeight: pw.FontWeight.bold,
        font: font,
      ),
      cellStyle: pw.TextStyle(fontSize: 10.0, font: font),
      headers: [
        'field_number'.tr(),
        'full_name'.tr(),
        'rod'.tr(),
        'line'.tr(),
        'field_distance'.tr(),
      ],
      data: participantsData.map((p) {
        final participant = p as Map<String, dynamic>;
        return [
          participant['place']?.toString() ?? '',
          participant['fullName']?.toString() ?? '',
          participant['rod']?.toString() ?? '',
          participant['line']?.toString() ?? '',
          participant['distance']?.toString() ?? '',
        ];
      }).toList(),
    );
  }

  // ========== ПРОМЕЖУТОЧНЫЙ/ФИНАЛЬНЫЙ ПРОТОКОЛ ==========

  /// Построение таблицы с динамическими колонками попыток
  Future<pw.Widget> _buildFullTable(Map<String, dynamic> data) async {
    final fontBold = await FontLoader.loadBoldFont();
    final font = await FontLoader.loadRegularFont();

    final participantsData = data['participantsData'] as List<dynamic>? ?? [];

    if (participantsData.isEmpty) {
      return pw.Center(
        child: pw.Text('protocol_no_participant_data'.tr()),
      );
    }

    // Определяем количество попыток
    final attemptsCount = data['attemptsCount'] as int? ??
        data['upToAttempt'] as int? ??
        5;

    // Определяем метод подсчёта
    final scoringMethod = data['scoringMethod']?.toString() ?? 'best_distance';
    final resultLabel = scoringMethod == 'best_distance'
        ? 'field_best_result'.tr()
        : 'field_average_result'.tr();

    // Формируем заголовки с локализацией
    final headers = <String>[
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
      resultLabel,
      'field_place'.tr(),
    ];

    // Формируем строки данных
    final rows = participantsData.map((p) {
      final participant = p as Map<String, dynamic>;
      final attempts = participant['attempts'] as List<dynamic>? ?? [];

      return [
        participant['number']?.toString() ?? '',
        participant['fullName']?.toString() ?? '',
        participant['rod']?.toString() ?? '',
        participant['line']?.toString() ?? '',
        ...List.generate(attemptsCount, (i) {
          if (i < attempts.length) {
            final attempt = attempts[i];
            return attempt?.toString() ?? '-';
          }
          return '-';
        }),
        participant['result']?.toString() ?? '',
        participant['place']?.toString() ?? '',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      context: null,
      border: pw.TableBorder.all(),
      headerAlignment: pw.Alignment.center,
      cellAlignment: pw.Alignment.center,
      headerStyle: pw.TextStyle(
        fontSize: 10.0,
        fontWeight: pw.FontWeight.bold,
        font: fontBold,
      ),
      cellStyle: pw.TextStyle(fontSize: 9.0, font: font),
      headers: headers,
      data: rows,
    );
  }
}