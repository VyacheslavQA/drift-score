import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/remote/protocol_remote.dart';
import '../../data/models/remote/competition_remote.dart';

class ProtocolDetailScreen extends StatelessWidget {
  final ProtocolRemote protocol;
  final CompetitionRemote competition;

  const ProtocolDetailScreen({
    super.key,
    required this.protocol,
    required this.competition,
  });

  String _getProtocolTitle() {
    switch (protocol.type) {
      case 'draw':
        return 'Жеребьёвка';
      case 'weighing':
        return 'Взвешивание День ${protocol.dayNumber}, №${protocol.weighingNumber}';
      case 'intermediate':
        return 'Промежуточный протокол после ${protocol.weighingNumber} взвешивания';
      case 'big_fish':
        return 'Big Fish - День ${protocol.bigFishDay}';
      case 'summary':
        return 'Сводный протокол';
      case 'final':
        return 'Финальный протокол';
      case 'casting_attempt':
        return 'Попытка №${protocol.weighingNumber}';
      case 'casting_intermediate':
        return 'Промежуточный протокол после ${protocol.weighingNumber} попыток';
      case 'casting_final':
        return 'Финальный протокол';
      default:
        return 'Протокол';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  Map<String, dynamic> _parseProtocolData() {
    try {
      return json.decode(protocol.dataJson);
    } catch (e) {
      print('❌ Error parsing protocol data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _parseProtocolData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getProtocolTitle(),
              style: AppTextStyles.h3.copyWith(fontSize: 16),
            ),
            Text(
              competition.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о протоколе
            _buildInfoCard(),

            SizedBox(height: AppDimensions.paddingLarge),

            // Содержимое протокола
            _buildProtocolContent(data),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Создан:',
            value: _formatDateTime(protocol.createdAt),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Место:',
            value: competition.lakeName.isNotEmpty ? competition.lakeName : 'Не указано',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
        SizedBox(width: AppDimensions.paddingSmall),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: AppDimensions.paddingSmall),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolContent(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingXLarge),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              Text(
                'Данные протокола недоступны',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    switch (protocol.type) {
      case 'draw':
        return _buildDrawProtocol(data);
      case 'weighing':
      case 'intermediate':
        return _buildWeighingProtocol(data);
      case 'big_fish':
        return _buildBigFishProtocol(data);
      case 'summary':
        return _buildSummaryProtocol(data);
      case 'final':
        return _buildFinalProtocol(data);
      case 'casting_attempt':
        return _buildCastingAttemptProtocol(data);
      case 'casting_intermediate':
      case 'casting_final':
        return _buildCastingFullProtocol(data);
      default:
        return _buildGenericProtocol(data);
    }
  }

  // ========== ЖЕРЕБЬЁВКА ==========
  Widget _buildDrawProtocol(Map<String, dynamic> data) {
    final drawData = (data['drawData'] as List<dynamic>?) ?? [];

    if (drawData.isEmpty) {
      return _buildEmptyState('Нет данных о жеребьёвке');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Результаты жеребьёвки',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        ...drawData.asMap().entries.map((entry) {
          final index = entry.key;
          final team = entry.value as Map<String, dynamic>;
          return _buildDrawTeamCard(index + 1, team);
        }).toList(),
      ],
    );
  }

  Widget _buildDrawTeamCard(int index, Map<String, dynamic> team) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team['teamName']?.toString() ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (team['city'] != null && team['city'].toString().isNotEmpty)
                      Text(
                        team['city'].toString(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Row(
            children: [
              _buildDrawInfoChip(
                'Жеребьёвка',
                '№${team['drawOrder'] ?? '-'}',
                Colors.blue,
              ),
              SizedBox(width: AppDimensions.paddingSmall),
              _buildDrawInfoChip(
                'Сектор',
                '${team['sector'] ?? '-'}',
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawInfoChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ========== ВЗВЕШИВАНИЕ / ПРОМЕЖУТОЧНЫЙ ==========
  Widget _buildWeighingProtocol(Map<String, dynamic> data) {
    final tableData = (data['tableData'] as List<dynamic>?) ?? [];
    final isIntermediate = protocol.type == 'intermediate';

    if (tableData.isEmpty) {
      return _buildEmptyState('Нет данных о взвешивании');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isIntermediate ? 'Промежуточные результаты' : 'Результаты взвешивания',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        ...tableData.map((row) {
          final rowMap = row as Map<String, dynamic>;
          return _buildWeighingResultCard(rowMap, isIntermediate);
        }).toList(),
      ],
    );
  }

  Widget _buildWeighingResultCard(Map<String, dynamic> data, bool showPlace) {
    final totalWeight = (data['totalWeight'] as num?) ?? 0;
    final fishCount = (data['fishCount'] as int?) ?? 0;
    final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showPlace)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getPlaceColor(data['place'] as int?).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      '${data['place'] ?? '-'}',
                      style: AppTextStyles.h3.copyWith(
                        color: _getPlaceColor(data['place'] as int?),
                      ),
                    ),
                  ),
                ),
              if (showPlace) SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['teamName']?.toString() ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Сектор ${data['sector'] ?? '-'}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  'Рыб',
                  '$fishCount',
                  Icons.phishing,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: _buildStatChip(
                  'Общий вес',
                  '${totalWeight.toStringAsFixed(3)} кг',
                  Icons.scale,
                  Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          _buildStatChip(
            'Средний вес',
            '${avgWeight.toStringAsFixed(3)} кг',
            Icons.analytics,
            Colors.green,
          ),
        ],
      ),
    );
  }

  // ========== BIG FISH ==========
  Widget _buildBigFishProtocol(Map<String, dynamic> data) {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return _buildEmptyState('Нет данных о трофее');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Самая большая рыба',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD700).withOpacity(0.3),
                Color(0xFFFFA500).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: Color(0xFFFFD700), width: 2),
          ),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events,
                size: 64,
                color: Color(0xFFFFD700),
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              Text(
                bigFish['teamName']?.toString() ?? '',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              Text(
                bigFish['fishType']?.toString() ?? '',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Вес',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3)} кг',
                        style: AppTextStyles.h3.copyWith(
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Длина',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${bigFish['length'] ?? '-'} см',
                        style: AppTextStyles.h3.copyWith(
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              Divider(),
              SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'Сектор ${bigFish['sector'] ?? '-'}',
                style: AppTextStyles.body,
              ),
              if (bigFish['weighingTime'] != null)
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(
                    DateTime.parse(bigFish['weighingTime']),
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== СВОДНЫЙ ПРОТОКОЛ ==========
  Widget _buildSummaryProtocol(Map<String, dynamic> data) {
    final summaryData = (data['summaryData'] as List<dynamic>?) ?? [];

    if (summaryData.isEmpty) {
      return _buildEmptyState('Нет данных');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сводные результаты',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        ...summaryData.map((team) {
          final teamMap = team as Map<String, dynamic>;
          return _buildSummaryTeamCard(teamMap);
        }).toList(),
      ],
    );
  }

  Widget _buildSummaryTeamCard(Map<String, dynamic> data) {
    final totalWeight = (data['totalWeight'] as num?) ?? 0;
    final fishCount = (data['totalFishCount'] as int?) ?? 0;
    final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;
    final place = data['place'] as int?;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: place != null && place <= 3
              ? _getPlaceColor(place)
              : AppColors.borderDark,
          width: place != null && place <= 3 ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (place != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getPlaceColor(place).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      '$place',
                      style: AppTextStyles.h3.copyWith(
                        color: _getPlaceColor(place),
                      ),
                    ),
                  ),
                ),
              if (place != null) SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['teamName']?.toString() ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Сектор ${data['sector'] ?? '-'}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Wrap(
            spacing: AppDimensions.paddingSmall,
            runSpacing: AppDimensions.paddingSmall,
            children: [
              _buildStatChip('Рыб', '$fishCount', Icons.phishing, Colors.blue),
              _buildStatChip('Вес', '${totalWeight.toStringAsFixed(3)} кг', Icons.scale, Colors.orange),
              _buildStatChip('Средний', '${avgWeight.toStringAsFixed(3)} кг', Icons.analytics, Colors.green),
              _buildStatChip(
                'Трофей',
                '${((data['biggestFish'] as num?) ?? 0).toStringAsFixed(3)} кг',
                Icons.emoji_events,
                Color(0xFFFFD700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== ФИНАЛЬНЫЙ ПРОТОКОЛ ==========
  Widget _buildFinalProtocol(Map<String, dynamic> data) {
    final finalData = (data['finalData'] as List<dynamic>?) ?? [];

    if (finalData.isEmpty) {
      return _buildEmptyState('Нет данных');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Финальные результаты',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        ...finalData.asMap().entries.map((entry) {
          final index = entry.key;
          final teamMap = entry.value as Map<String, dynamic>;
          return _buildFinalTeamCard(index, teamMap);
        }).toList(),
      ],
    );
  }

  Widget _buildFinalTeamCard(int index, Map<String, dynamic> data) {
    final place = data['place'] as int?;
    final totalWeight = (data['totalWeight'] as num?) ?? 0;
    final fishCount = (data['totalFishCount'] as int?) ?? 0;
    final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

    // Медальки для топ-3
    Widget? medalIcon;
    if (place != null && place <= 3) {
      medalIcon = Icon(
        Icons.emoji_events,
        color: _getPlaceColor(place),
        size: 32,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: place != null && place <= 3
              ? _getPlaceColor(place)
              : AppColors.borderDark,
          width: place != null && place <= 3 ? 3 : 1,
        ),
        boxShadow: place != null && place <= 3
            ? [
          BoxShadow(
            color: _getPlaceColor(place).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (place != null)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: place <= 3
                          ? [
                        _getPlaceColor(place),
                        _getPlaceColor(place).withOpacity(0.7),
                      ]
                          : [
                        AppColors.textSecondary.withOpacity(0.3),
                        AppColors.textSecondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Center(
                    child: medalIcon ??
                        Text(
                          '$place',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),
              if (place != null) SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['teamName']?.toString() ?? '',
                      style: AppTextStyles.h3.copyWith(fontSize: 16),
                    ),
                    if (data['city'] != null)
                      Text(
                        data['city'].toString(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Divider(),
          SizedBox(height: AppDimensions.paddingSmall),
          Wrap(
            spacing: AppDimensions.paddingSmall,
            runSpacing: AppDimensions.paddingSmall,
            children: [
              _buildStatChip('Сектор', '${data['sector'] ?? '-'}', Icons.location_on, Colors.purple),
              _buildStatChip('Рыб', '$fishCount', Icons.phishing, Colors.blue),
              _buildStatChip('Вес', '${totalWeight.toStringAsFixed(3)} кг', Icons.scale, Colors.orange),
              _buildStatChip('Средний', '${avgWeight.toStringAsFixed(3)} кг', Icons.analytics, Colors.green),
              _buildStatChip(
                'Трофей',
                '${((data['biggestFish'] as num?) ?? 0).toStringAsFixed(3)} кг',
                Icons.emoji_events,
                Color(0xFFFFD700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== КАСТИНГ ПОПЫТКА ==========
  Widget _buildCastingAttemptProtocol(Map<String, dynamic> data) {
    final participantsData = (data['participantsData'] as List<dynamic>?) ?? [];

    if (participantsData.isEmpty) {
      return _buildEmptyState('Нет данных');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Результаты попытки',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        ...participantsData.map((participant) {
          final participantMap = participant as Map<String, dynamic>;
          return _buildCastingAttemptCard(participantMap);
        }).toList(),
      ],
    );
  }

  Widget _buildCastingAttemptCard(Map<String, dynamic> data) {
    final place = data['place'] as int?;
    final distance = data['distance'] as double;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: place != null && place <= 3
              ? _getPlaceColor(place)
              : AppColors.borderDark,
        ),
      ),
      child: Row(
        children: [
          if (place != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPlaceColor(place).withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Center(
                child: Text(
                  '$place',
                  style: AppTextStyles.h3.copyWith(
                    color: _getPlaceColor(place),
                  ),
                ),
              ),
            ),
          if (place != null) SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['fullName']?.toString() ?? '',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${data['rod'] ?? '-'} / ${data['line'] ?? '-'}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Text(
              '${distance.toStringAsFixed(2)} м',
              style: AppTextStyles.h3.copyWith(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== КАСТИНГ ПРОМЕЖУТОЧНЫЙ/ФИНАЛЬНЫЙ ==========
  Widget _buildCastingFullProtocol(Map<String, dynamic> data) {
    final participantsData = (data['participantsData'] as List<dynamic>?) ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final attemptsCount = (data['attemptsCount'] as int?) ?? (data['upToAttempt'] as int?) ?? 3;

    if (participantsData.isEmpty) {
      return _buildEmptyState('Нет данных');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          protocol.type == 'casting_final' ? 'Финальные результаты' : 'Промежуточные результаты',
          style: AppTextStyles.h3,
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        ...participantsData.map((participant) {
          final participantMap = participant as Map<String, dynamic>;
          return _buildCastingFullCard(participantMap, scoringMethod, attemptsCount);
        }).toList(),
      ],
    );
  }

  Widget _buildCastingFullCard(Map<String, dynamic> data, String scoringMethod, int attemptsCount) {
    final place = data['place'] as int?;
    final attempts = (data['attempts'] as List<dynamic>).cast<double>();
    final resultValue = scoringMethod == 'best_distance'
        ? data['bestDistance'] as double
        : data['averageDistance'] as double;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: place != null && place <= 3
              ? _getPlaceColor(place)
              : AppColors.borderDark,
          width: place != null && place <= 3 ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (place != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getPlaceColor(place).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      '$place',
                      style: AppTextStyles.h3.copyWith(
                        color: _getPlaceColor(place),
                      ),
                    ),
                  ),
                ),
              if (place != null) SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['fullName']?.toString() ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${data['rod'] ?? '-'} / ${data['line'] ?? '-'}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingMedium),

          // Попытки
          Wrap(
            spacing: AppDimensions.paddingSmall,
            runSpacing: AppDimensions.paddingSmall,
            children: List.generate(attemptsCount, (index) {
              final distance = index < attempts.length ? attempts[index] : 0.0;
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: distance > 0
                      ? Colors.blue.withOpacity(0.15)
                      : AppColors.surfaceMedium,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  border: Border.all(
                    color: distance > 0 ? Colors.blue.withOpacity(0.5) : AppColors.borderDark,
                  ),
                ),
                child: Text(
                  'Попытка ${index + 1}: ${distance > 0 ? distance.toStringAsFixed(2) : '0'} м',
                  style: AppTextStyles.caption.copyWith(
                    color: distance > 0 ? Colors.blue : AppColors.textSecondary,
                    fontWeight: distance > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: AppDimensions.paddingMedium),
          Divider(),
          SizedBox(height: AppDimensions.paddingSmall),

          // Итоговый результат
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                scoringMethod == 'best_distance' ? 'Лучший результат:' : 'Средний результат:',
                style: AppTextStyles.bodyLarge,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.green.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  '${resultValue.toStringAsFixed(2)} м',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.text,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== ОБЩИЙ ПРОТОКОЛ (ЕСЛИ ТИП НЕ РАСПОЗНАН) ==========
  Widget _buildGenericProtocol(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Данные протокола',
            style: AppTextStyles.h3,
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Text(
            json.encode(data),
            style: AppTextStyles.caption.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // ========== ВСПОМОГАТЕЛЬНЫЕ ВИДЖЕТЫ ==========

  Widget _buildStatChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            Text(
              message,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPlaceColor(int? place) {
    if (place == null) return AppColors.textSecondary;
    switch (place) {
      case 1:
        return Color(0xFFFFD700); // Золото
      case 2:
        return Color(0xFFC0C0C0); // Серебро
      case 3:
        return Color(0xFFCD7F32); // Бронза
      default:
        return AppColors.textSecondary;
    }
  }
}