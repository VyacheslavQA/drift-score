import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Утилита для загрузки и кэширования шрифтов для PDF документов
class FontLoader {
  // Приватный конструктор для запрета создания экземпляров
  FontLoader._();

  /// Кэш для обычного шрифта (Regular)
  static pw.Font? _cachedRegularFont;

  /// Кэш для жирного шрифта (Bold)
  static pw.Font? _cachedBoldFont;

  /// Кэш для курсивного шрифта (Italic)
  static pw.Font? _cachedItalicFont;

  /// Кэш для жирного курсивного шрифта (Bold Italic)
  static pw.Font? _cachedBoldItalicFont;

  /// Загрузка обычного шрифта Roboto Regular
  ///
  /// Использует кэширование для оптимизации производительности.
  /// При первом вызове загружает шрифт из Google Fonts,
  /// при последующих вызовах возвращает закэшированный экземпляр.
  ///
  /// Возвращает [pw.Font] для использования в PDF документах
  static Future<pw.Font> loadRegularFont() async {
    if (_cachedRegularFont != null) {
      return _cachedRegularFont!;
    }

    try {
      final fontData = await PdfGoogleFonts.robotoRegular();
      _cachedRegularFont = fontData;
      print('✅ Roboto Regular font loaded and cached');
      return _cachedRegularFont!;
    } catch (e) {
      print('❌ Error loading Roboto Regular font: $e');
      rethrow;
    }
  }

  /// Загрузка жирного шрифта Roboto Bold
  ///
  /// Использует кэширование для оптимизации производительности.
  /// При первом вызове загружает шрифт из Google Fonts,
  /// при последующих вызовах возвращает закэшированный экземпляр.
  ///
  /// Возвращает [pw.Font] для использования в PDF документах
  static Future<pw.Font> loadBoldFont() async {
    if (_cachedBoldFont != null) {
      return _cachedBoldFont!;
    }

    try {
      final fontData = await PdfGoogleFonts.robotoBold();
      _cachedBoldFont = fontData;
      print('✅ Roboto Bold font loaded and cached');
      return _cachedBoldFont!;
    } catch (e) {
      print('❌ Error loading Roboto Bold font: $e');
      rethrow;
    }
  }

  /// Загрузка курсивного шрифта Roboto Italic
  ///
  /// Использует кэширование для оптимизации производительности.
  /// Используется реже, но полезен для специальных случаев.
  ///
  /// Возвращает [pw.Font] для использования в PDF документах
  static Future<pw.Font> loadItalicFont() async {
    if (_cachedItalicFont != null) {
      return _cachedItalicFont!;
    }

    try {
      final fontData = await PdfGoogleFonts.robotoItalic();
      _cachedItalicFont = fontData;
      print('✅ Roboto Italic font loaded and cached');
      return _cachedItalicFont!;
    } catch (e) {
      print('❌ Error loading Roboto Italic font: $e');
      rethrow;
    }
  }

  /// Загрузка жирного курсивного шрифта Roboto Bold Italic
  ///
  /// Использует кэширование для оптимизации производительности.
  /// Используется реже, но полезен для специальных случаев.
  ///
  /// Возвращает [pw.Font] для использования в PDF документах
  static Future<pw.Font> loadBoldItalicFont() async {
    if (_cachedBoldItalicFont != null) {
      return _cachedBoldItalicFont!;
    }

    try {
      final fontData = await PdfGoogleFonts.robotoBoldItalic();
      _cachedBoldItalicFont = fontData;
      print('✅ Roboto Bold Italic font loaded and cached');
      return _cachedBoldItalicFont!;
    } catch (e) {
      print('❌ Error loading Roboto Bold Italic font: $e');
      rethrow;
    }
  }

  /// Предзагрузка всех шрифтов
  ///
  /// Полезно вызвать при инициализации приложения,
  /// чтобы избежать задержек при первом экспорте PDF.
  ///
  /// Загружает все шрифты параллельно для ускорения процесса.
  static Future<void> preloadAllFonts() async {
    try {
      await Future.wait([
        loadRegularFont(),
        loadBoldFont(),
        loadItalicFont(),
        loadBoldItalicFont(),
      ]);
      print('✅ All fonts preloaded successfully');
    } catch (e) {
      print('❌ Error preloading fonts: $e');
      rethrow;
    }
  }

  /// Очистка кэша шрифтов
  ///
  /// Освобождает память, занятую закэшированными шрифтами.
  /// Используйте с осторожностью - после очистки шрифты
  /// придётся загружать заново.
  static void clearCache() {
    _cachedRegularFont = null;
    _cachedBoldFont = null;
    _cachedItalicFont = null;
    _cachedBoldItalicFont = null;
    print('✅ Font cache cleared');
  }

  /// Проверка, загружены ли основные шрифты
  ///
  /// Возвращает true, если Regular и Bold шрифты загружены
  static bool areMainFontsLoaded() {
    return _cachedRegularFont != null && _cachedBoldFont != null;
  }

  /// Проверка, загружены ли все шрифты
  ///
  /// Возвращает true, если все 4 шрифта загружены
  static bool areAllFontsLoaded() {
    return _cachedRegularFont != null &&
        _cachedBoldFont != null &&
        _cachedItalicFont != null &&
        _cachedBoldItalicFont != null;
  }
}