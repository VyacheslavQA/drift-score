import 'package:intl/intl.dart';

/// Утилита для форматирования дат и времени в протоколах
class DateFormatter {
  // Приватный конструктор для запрета создания экземпляров
  DateFormatter._();

  /// Форматирование диапазона дат соревнования
  ///
  /// Если соревнование длится один день - возвращает одну дату.
  /// Если несколько дней - возвращает диапазон "дата1 - дата2".
  ///
  /// Параметры:
  /// - [startTime] - дата и время начала соревнования
  /// - [finishTime] - дата и время окончания соревнования
  ///
  /// Возвращает строку с форматированной датой/датами
  static String formatCompetitionDates(DateTime startTime, DateTime finishTime) {
    final start = DateFormat('dd.MM.yyyy').format(startTime);
    final finish = DateFormat('dd.MM.yyyy').format(finishTime);

    // Если даты совпадают - возвращаем одну дату
    if (start == finish) {
      return start;
    }

    // Если разные даты - возвращаем диапазон
    return '$start - $finish';
  }

  /// Определение ключа для выбора правильного лейбла даты
  ///
  /// Возвращает ключ, который используется для определения,
  /// писать "Дата соревнования" или "Даты соревнования".
  ///
  /// Параметры:
  /// - [startTime] - дата и время начала соревнования
  /// - [finishTime] - дата и время окончания соревнования
  ///
  /// Возвращает:
  /// - 'competition_date_single' - для одного дня
  /// - 'competition_dates_multiple' - для нескольких дней
  static String getDateKey(DateTime startTime, DateTime finishTime) {
    final start = DateFormat('dd.MM.yyyy').format(startTime);
    final finish = DateFormat('dd.MM.yyyy').format(finishTime);

    if (start == finish) {
      return 'competition_date_single';
    } else {
      return 'competition_dates_multiple';
    }
  }

  /// Получение лейбла для даты соревнования
  ///
  /// Определяет, использовать единственное или множественное число
  /// для слова "дата" в зависимости от продолжительности соревнования.
  ///
  /// Параметры:
  /// - [data] - данные протокола, содержащие ключ dateKey
  ///
  /// Возвращает:
  /// - 'Дата соревнования' - для одного дня
  /// - 'Даты соревнования' - для нескольких дней
  static String getDateLabel(Map<String, dynamic> data) {
    final dateKey = data['dateKey'] as String?;

    if (dateKey == 'competition_date_single') {
      return 'Дата соревнования';
    } else {
      return 'Даты соревнования';
    }
  }

  /// Форматирование места проведения (город и водоём)
  ///
  /// Параметры:
  /// - [city] - название города
  /// - [venue] - название водоёма/места проведения
  ///
  /// Возвращает строку в формате "г. Город, оз. Озеро"
  /// Если какое-то значение отсутствует - не добавляет его
  static String formatVenue(String? city, String? venue) {
    final parts = <String>[];

    if (city != null && city.isNotEmpty) {
      parts.add('г. $city');
    }

    if (venue != null && venue.isNotEmpty) {
      parts.add('оз. $venue');
    }

    return parts.join(', ');
  }

  /// Форматирование даты для отображения (без времени)
  ///
  /// Параметры:
  /// - [dateTime] - дата для форматирования
  ///
  /// Возвращает строку в формате "dd.MM.yyyy"
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  /// Форматирование даты и времени для отображения
  ///
  /// Параметры:
  /// - [dateTime] - дата и время для форматирования
  ///
  /// Возвращает строку в формате "dd.MM.yyyy HH:mm"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  /// Форматирование времени для отображения (без даты)
  ///
  /// Параметры:
  /// - [dateTime] - время для форматирования
  ///
  /// Возвращает строку в формате "HH:mm"
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Форматирование даты для имени файла
  ///
  /// Используется при генерации имён файлов для протоколов.
  ///
  /// Параметры:
  /// - [dateTime] - дата и время для форматирования
  ///
  /// Возвращает строку в формате "yyyyMMdd_HHmmss"
  static String formatForFilename(DateTime dateTime) {
    return DateFormat('yyyyMMdd_HHmmss').format(dateTime);
  }

  /// Парсинг строки с датой в DateTime
  ///
  /// Пытается распарсить строку в нескольких форматах.
  ///
  /// Параметры:
  /// - [dateString] - строка с датой
  ///
  /// Возвращает DateTime или null, если не удалось распарсить
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      // Пробуем стандартный ISO формат
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        // Пробуем формат dd.MM.yyyy
        return DateFormat('dd.MM.yyyy').parse(dateString);
      } catch (e) {
        try {
          // Пробуем формат dd.MM.yyyy HH:mm
          return DateFormat('dd.MM.yyyy HH:mm').parse(dateString);
        } catch (e) {
          print('❌ Error parsing date: $dateString');
          return null;
        }
      }
    }
  }

  /// Получение количества дней между двумя датами
  ///
  /// Параметры:
  /// - [startTime] - начальная дата
  /// - [finishTime] - конечная дата
  ///
  /// Возвращает количество дней (включительно)
  static int getDaysBetween(DateTime startTime, DateTime finishTime) {
    final start = DateTime(startTime.year, startTime.month, startTime.day);
    final finish = DateTime(finishTime.year, finishTime.month, finishTime.day);

    return finish.difference(start).inDays + 1;
  }

  /// Проверка, является ли соревнование однодневным
  ///
  /// Параметры:
  /// - [startTime] - дата и время начала
  /// - [finishTime] - дата и время окончания
  ///
  /// Возвращает true, если соревнование длится один день
  static bool isSingleDay(DateTime startTime, DateTime finishTime) {
    final start = DateTime(startTime.year, startTime.month, startTime.day);
    final finish = DateTime(finishTime.year, finishTime.month, finishTime.day);

    return start.isAtSameMomentAs(finish);
  }

  /// Получение номера дня соревнования
  ///
  /// Вычисляет, какой это день соревнования от начала.
  ///
  /// Параметры:
  /// - [currentDate] - текущая дата
  /// - [startTime] - дата начала соревнования
  ///
  /// Возвращает номер дня (1, 2, 3 и т.д.)
  static int getDayNumber(DateTime currentDate, DateTime startTime) {
    final current = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final start = DateTime(startTime.year, startTime.month, startTime.day);

    return current.difference(start).inDays + 1;
  }

  /// Форматирование длительности
  ///
  /// Преобразует Duration в человекочитаемый формат.
  ///
  /// Параметры:
  /// - [duration] - длительность
  ///
  /// Возвращает строку типа "2ч 30мин" или "45мин"
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}ч ${minutes}мин';
    } else {
      return '${minutes}мин';
    }
  }
}