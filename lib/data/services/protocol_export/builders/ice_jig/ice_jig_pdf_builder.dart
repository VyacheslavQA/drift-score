import 'package:pdf/widgets.dart' as pw;
import '../../core/base_pdf_builder.dart';
import '../../core/export_types.dart';

/// PDF Builder для протоколов зимней рыбалки на мормышку
///
/// ЗАГЛУШКА: Будет реализовано при необходимости
/// Для реализации - скопировать логику из CarpPdfBuilder и адаптировать
class IceJigPdfBuilder extends BasePdfBuilder {
  @override
  Future<pw.Widget> buildContent(
      ProtocolType type,
      Map<String, dynamic> data,
      ) async {
    throw UnimplementedError(
      'PDF экспорт для зимней рыбалки на мормышку пока не реализован.\n'
          'Тип протокола: $type',
    );
  }

  @override
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data) {
    throw UnimplementedError(
      'Получение заголовка для зимней рыбалки на мормышку пока не реализовано.\n'
          'Тип протокола: $type',
    );
  }
}