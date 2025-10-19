import 'package:pdf/widgets.dart' as pw;
import '../../core/base_pdf_builder.dart';
import '../../core/export_types.dart';

/// PDF Builder для протоколов форелевой рыбалки
///
/// ЗАГЛУШКА: Будет реализовано при необходимости
/// Для реализации - скопировать логику из CarpPdfBuilder и адаптировать
class TroutPdfBuilder extends BasePdfBuilder {
  @override
  Future<pw.Widget> buildContent(
      ProtocolType type,
      Map<String, dynamic> data,
      ) async {
    throw UnimplementedError(
      'PDF экспорт для форелевой рыбалки пока не реализован.\n'
          'Тип протокола: $type',
    );
  }

  @override
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data) {
    throw UnimplementedError(
      'Получение заголовка для форелевой рыбалки пока не реализовано.\n'
          'Тип протокола: $type',
    );
  }
}