import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import '../../core/base_excel_builder.dart';
import '../../core/export_types.dart';

/// Excel Builder для протоколов зимней рыбалки на блесну
///
/// ЗАГЛУШКА: Будет реализовано при необходимости
/// Для реализации - скопировать логику из CarpExcelBuilder и адаптировать
class IceSpoonExcelBuilder extends BaseExcelBuilder {
  @override
  int buildTableContent(
      xlsio.Worksheet sheet,
      ProtocolType type,
      Map<String, dynamic> data,
      int startRow,
      ) {
    throw UnimplementedError(
      'Excel экспорт для зимней рыбалки на блесну пока не реализован.\n'
          'Тип протокола: $type',
    );
  }

  @override
  String getProtocolTitle(ProtocolType type, Map<String, dynamic> data) {
    throw UnimplementedError(
      'Получение заголовка для зимней рыбалки на блесну пока не реализовано.\n'
          'Тип протокола: $type',
    );
  }
}