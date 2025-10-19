class PublicCompetitionRemote {
  final String id;
  final String name;
  final String fishingType;
  final String venue;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final int teamsCount;
  final String? organizerName;

  PublicCompetitionRemote({
    required this.id,
    required this.name,
    required this.fishingType,
    required this.venue,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.createdAt,
    this.teamsCount = 0,
    this.organizerName,
  });

  factory PublicCompetitionRemote.fromFirestore(Map<String, dynamic> data, String id) {
    return PublicCompetitionRemote(
      id: id,
      name: data['name'] ?? '',
      fishingType: data['fishingType'] ?? '',
      venue: data['venue'] ?? '',
      startDate: DateTime.parse(data['startDate']),
      endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
      isActive: data['isActive'] ?? false,
      createdAt: DateTime.parse(data['createdAt']),
      teamsCount: data['teamsCount'] ?? 0,
      organizerName: data['organizerName'],
    );
  }

  String get fishingTypeTranslated {
    switch (fishingType) {
      case 'float':
        return 'Поплавочная';
      case 'spinning':
        return 'Спиннинг';
      case 'carp':
        return 'Карповая';
      case 'feeder':
        return 'Фидер';
      case 'ice_jig':
        return 'Зимняя мормышка';
      case 'ice_spoon':
        return 'Зимняя блесна';
      case 'trout':
        return 'Форель';
      case 'fly':
        return 'Нахлыст';
      case 'casting':
        return 'Кастинг';
      default:
        return fishingType;
    }
  }

  String get statusText => isActive ? 'Активно' : 'Завершено';

  String get datesFormatted {
    if (endDate == null) {
      return '${startDate.day}.${startDate.month}.${startDate.year}';
    }
    return '${startDate.day}.${startDate.month}.${startDate.year} - ${endDate!.day}.${endDate!.month}.${endDate!.year}';
  }
}