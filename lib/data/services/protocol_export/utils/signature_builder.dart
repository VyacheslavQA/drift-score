import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

/// Утилита для построения блока подписей судей в PDF и Excel документах
class SignatureBuilder {
  // Приватный конструктор для запрета создания экземпляров
  SignatureBuilder._();

  /// Построение блока подписей для PDF документа
  ///
  /// Параметры:
  /// - [judges] - список судей из данных протокола
  /// - [font] - обычный шрифт для текста
  /// - [fontBold] - жирный шрифт для заголовков
  ///
  /// Возвращает [pw.Widget] с блоком подписей
  static pw.Widget buildPdfSignatures(
      List<dynamic> judges,
      pw.Font font,
      pw.Font fontBold,
      ) {
    if (judges.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: judges.map((judge) {
        final judgeMap = judge as Map<String, dynamic>;
        final rank = translateJudgeRank(judgeMap['rank']?.toString() ?? '');
        final name = judgeMap['name']?.toString() ?? '';

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              // Ранг судьи
              pw.Text(
                '$rank: ',
                style: pw.TextStyle(fontSize: 10, font: font),
              ),

              // Линия для подписи
              pw.Container(
                width: 150,
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 1),
                  ),
                ),
                child: pw.SizedBox(height: 1),
              ),

              pw.SizedBox(width: 5),

              // Имя судьи
              pw.Text(
                name,
                style: pw.TextStyle(fontSize: 10, font: font),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Добавление блока подписей в Excel документ
  ///
  /// Параметры:
  /// - [sheet] - рабочий лист Excel
  /// - [judges] - список судей из данных протокола
  /// - [startRow] - начальная строка для добавления подписей
  ///
  /// Возвращает номер последней использованной строки
  static int addExcelSignatures(
      xlsio.Worksheet sheet,
      List<dynamic> judges,
      int startRow,
      ) {
    if (judges.isEmpty) {
      return startRow;
    }

    int currentRow = startRow;

    // Пустая строка перед подписями
    currentRow++;

    for (final judge in judges) {
      final judgeMap = judge as Map<String, dynamic>;
      final rank = translateJudgeRank(judgeMap['rank']?.toString() ?? '');
      final name = judgeMap['name']?.toString() ?? '';

      // Ранг судьи (столбец 8)
      final rankCell = sheet.getRangeByIndex(currentRow, 8);
      rankCell.setText('$rank:');
      rankCell.cellStyle.fontSize = 10;
      rankCell.cellStyle.hAlign = xlsio.HAlignType.right;
      rankCell.cellStyle.vAlign = xlsio.VAlignType.center;

      // Линия для подписи (столбец 9)
      final signatureCell = sheet.getRangeByIndex(currentRow, 9);
      signatureCell.setText('_______________');
      signatureCell.cellStyle.fontSize = 10;
      signatureCell.cellStyle.hAlign = xlsio.HAlignType.center;
      signatureCell.cellStyle.vAlign = xlsio.VAlignType.center;

      // Имя судьи (столбец 10)
      final nameCell = sheet.getRangeByIndex(currentRow, 10);
      nameCell.setText(name);
      nameCell.cellStyle.fontSize = 10;
      nameCell.cellStyle.hAlign = xlsio.HAlignType.left;
      nameCell.cellStyle.vAlign = xlsio.VAlignType.center;

      // Установка высоты строки
      sheet.setRowHeightInPixels(currentRow, 20);

      currentRow++;
    }

    return currentRow;
  }

  /// Перевод ранга судьи на русский язык
  ///
  /// Параметры:
  /// - [rank] - ранг судьи на английском или русском
  ///
  /// Возвращает русское название ранга
  static String translateJudgeRank(String rank) {
    final normalizedRank = rank.toLowerCase().trim();

    switch (normalizedRank) {
    // Главный судья
      case 'chief_judge':
      case 'judge_chief':
      case 'главный судья':
      case 'главный':
        return 'Главный судья';

    // Обычный судья
      case 'judge':
      case 'judge_regular':
      case 'судья':
        return 'Судья';

    // Секретарь / Помощник судьи
      case 'secretary':
      case 'judge_assistant':
      case 'assistant':
      case 'секретарь':
      case 'помощник':
        return 'Секретарь';

    // Заместитель главного судьи
      case 'deputy_chief':
      case 'deputy':
      case 'заместитель':
        return 'Заместитель главного судьи';

    // Старший судья
      case 'senior_judge':
      case 'старший судья':
        return 'Старший судья';

    // По умолчанию - Судья
      default:
        return 'Судья';
    }
  }

  /// Получение списка всех возможных рангов судей
  ///
  /// Полезно для UI выбора ранга при добавлении судьи
  static List<String> getAllJudgeRanks() {
    return [
      'Главный судья',
      'Заместитель главного судьи',
      'Старший судья',
      'Судья',
      'Секретарь',
    ];
  }

  /// Получение английского ключа ранга по русскому названию
  ///
  /// Параметры:
  /// - [russianRank] - русское название ранга
  ///
  /// Возвращает английский ключ для сохранения в базе данных
  static String getRankKey(String russianRank) {
    switch (russianRank) {
      case 'Главный судья':
        return 'chief_judge';
      case 'Заместитель главного судьи':
        return 'deputy_chief';
      case 'Старший судья':
        return 'senior_judge';
      case 'Судья':
        return 'judge';
      case 'Секретарь':
        return 'secretary';
      default:
        return 'judge';
    }
  }

  /// Проверка валидности данных судьи
  ///
  /// Параметры:
  /// - [judgeMap] - данные судьи в виде Map
  ///
  /// Возвращает true, если данные валидны
  static bool isValidJudge(Map<String, dynamic> judgeMap) {
    final rank = judgeMap['rank']?.toString() ?? '';
    final name = judgeMap['name']?.toString() ?? '';

    return rank.isNotEmpty && name.isNotEmpty;
  }

  /// Фильтрация валидных судей из списка
  ///
  /// Параметры:
  /// - [judges] - список судей
  ///
  /// Возвращает отфильтрованный список только с валидными судьями
  static List<Map<String, dynamic>> filterValidJudges(List<dynamic> judges) {
    return judges
        .whereType<Map<String, dynamic>>()
        .where((judge) => isValidJudge(judge))
        .toList();
  }
}