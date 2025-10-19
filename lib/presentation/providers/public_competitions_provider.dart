import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/firebase_service.dart';
import '../../data/models/remote/competition_remote.dart';
import '../../data/models/remote/protocol_remote.dart';

/// Provider для FirebaseService
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// Provider для списка соревнований по типу рыбалки и статусу
final publicCompetitionsProvider = StreamProvider.family<List<CompetitionRemote>, PublicCompetitionsFilter>((ref, filter) {
  final firebaseService = ref.watch(firebaseServiceProvider);

  if (filter.status == CompetitionStatus.all) {
    return firebaseService.watchCompetitionsByFishingType(filter.fishingType);
  } else if (filter.status == CompetitionStatus.active) {
    return firebaseService.watchActiveCompetitionsByFishingType(filter.fishingType);
  } else {
    return firebaseService.watchCompletedCompetitionsByFishingType(filter.fishingType);
  }
});

/// Provider для протоколов соревнования
final competitionProtocolsProvider = StreamProvider.family<List<ProtocolRemote>, String>((ref, competitionId) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.watchProtocolsByCompetition(competitionId);
});

/// Provider для протоколов определённого типа
final protocolsByTypeProvider = StreamProvider.family<List<ProtocolRemote>, ProtocolFilter>((ref, filter) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.watchProtocolsByType(filter.competitionId, filter.type);
});

/// Фильтр для соревнований
class PublicCompetitionsFilter {
  final String fishingType;
  final CompetitionStatus status;

  const PublicCompetitionsFilter({
    required this.fishingType,
    this.status = CompetitionStatus.all,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PublicCompetitionsFilter &&
              runtimeType == other.runtimeType &&
              fishingType == other.fishingType &&
              status == other.status;

  @override
  int get hashCode => fishingType.hashCode ^ status.hashCode;
}

/// Статус соревнования
enum CompetitionStatus {
  all,      // Все
  active,   // Активные
  completed // Завершённые
}

/// Фильтр для протоколов по типу
class ProtocolFilter {
  final String competitionId;
  final String type;

  const ProtocolFilter({
    required this.competitionId,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProtocolFilter &&
              runtimeType == other.runtimeType &&
              competitionId == other.competitionId &&
              type == other.type;

  @override
  int get hashCode => competitionId.hashCode ^ type.hashCode;
}