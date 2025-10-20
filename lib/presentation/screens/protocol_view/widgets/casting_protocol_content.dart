import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/local/protocol_local.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_dimensions.dart';

class CastingProtocolContent extends StatelessWidget {
  final ProtocolLocal protocol;
  final Map<String, dynamic> data;

  const CastingProtocolContent({
    Key? key,
    required this.protocol,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (protocol.type) {
      case 'casting_attempt':
        return _buildCastingAttemptContent();
      case 'casting_intermediate':
      case 'casting_final':
        return _buildCastingIntermediateOrFinalContent();
      default:
        return Center(child: Text('protocol_type_not_supported'.tr()));
    }
  }

  Widget _buildCastingAttemptContent() {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final attemptNumber = data['attemptNumber'] as int? ?? 1;

    if (participantsData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppColors.primary.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  'Результаты попытки №$attemptNumber',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppDimensions.paddingMedium),
        Card(
          color: AppColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
              columns: [
                DataColumn(label: Text('Место', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('ФИО', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('Удилище', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('Леска', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('Дальность (м)', style: AppTextStyles.bodyBold)),
              ],
              rows: participantsData.map<DataRow>((participant) {
                final place = participant['place'] as int;
                final distance = participant['distance'] as double;

                return DataRow(
                  color: WidgetStateProperty.all(_getPlaceColor(place).withOpacity(0.2)),
                  cells: [
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPlaceColor(place).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Text(
                          '$place',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: _getPlaceColor(place),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: Text(
                          participant['fullName']?.toString() ?? '',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 120),
                        child: Text(
                          participant['rod']?.toString() ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(Text(participant['line']?.toString() ?? '')),
                    DataCell(
                      Text(
                        distance > 0 ? distance.toStringAsFixed(2) : '0',
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 16,
                          color: distance == 0 ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCastingIntermediateOrFinalContent() {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final bestInAttempts = (data['bestInAttempts'] as List<dynamic>?)?.cast<double>() ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final upToAttempt = data['upToAttempt'] as int?;
    final attemptsCount = data['attemptsCount'] as int? ?? upToAttempt ?? 3;
    final commonLine = data['commonLine'] as String?;

    if (participantsData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    Widget? commonLineInfo;
    if (commonLine != null && commonLine.isNotEmpty) {
      commonLineInfo = Card(
        color: AppColors.primary.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingSmall),
              Text(
                'Общая леска: $commonLine',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      );
    }

    Widget scoringInfo = Card(
      color: Colors.orange.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          children: [
            Icon(Icons.calculate, color: Colors.orange),
            SizedBox(width: AppDimensions.paddingSmall),
            Text(
              'Метод подсчёта: ${scoringMethod == 'best_distance' ? 'Лучший результат' : 'Средняя дальность'}',
              style: AppTextStyles.bodyBold.copyWith(color: Colors.orange.shade800),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (commonLineInfo != null) ...[
          commonLineInfo,
          SizedBox(height: AppDimensions.paddingMedium),
        ],
        scoringInfo,
        SizedBox(height: AppDimensions.paddingMedium),
        Card(
          color: AppColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
              columns: [
                DataColumn(label: Text('№', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('ФИО', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('Удилище', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('Леска', style: AppTextStyles.bodyBold)),
                ...List.generate(
                  attemptsCount,
                      (i) => DataColumn(
                    label: Text('П${i + 1}', style: AppTextStyles.bodyBold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    scoringMethod == 'best_distance' ? 'Лучший' : 'Средний',
                    style: AppTextStyles.bodyBold,
                  ),
                ),
                DataColumn(label: Text('Место', style: AppTextStyles.bodyBold)),
              ],
              rows: participantsData.asMap().entries.map<DataRow>((entry) {
                final index = entry.key;
                final participant = entry.value as Map<String, dynamic>;
                final attempts = (participant['attempts'] as List<dynamic>).cast<double>();
                final place = participant['place'] as int;

                return DataRow(
                  color: WidgetStateProperty.all(_getPlaceColor(place).withOpacity(0.2)),
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: Text(
                          participant['fullName']?.toString() ?? '',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 120),
                        child: Text(
                          participant['rod']?.toString() ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(Text(participant['line']?.toString() ?? '')),
                    ...List.generate(attemptsCount, (attemptIndex) {
                      if (attemptIndex >= attempts.length) {
                        return DataCell(Text('-'));
                      }

                      final distance = attempts[attemptIndex];
                      final isBestInAttempt = attemptIndex < bestInAttempts.length &&
                          distance > 0 &&
                          distance == bestInAttempts[attemptIndex];

                      Color? cellColor;
                      Color textColor = AppColors.textPrimary;

                      if (distance == 0) {
                        cellColor = Colors.red.withOpacity(0.2);
                        textColor = Colors.red;
                      } else if (isBestInAttempt) {
                        cellColor = Colors.green.withOpacity(0.3);
                        textColor = Colors.white;
                      }

                      return DataCell(
                        Container(
                          color: cellColor,
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            distance > 0 ? distance.toStringAsFixed(2) : '0',
                            style: AppTextStyles.bodyBold.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    }),
                    DataCell(
                      Text(
                        scoringMethod == 'best_distance'
                            ? (participant['bestDistance'] as double).toStringAsFixed(2)
                            : (participant['averageDistance'] as double).toStringAsFixed(2),
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPlaceColor(place).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Text(
                          '$place',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: _getPlaceColor(place),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPlaceColor(int place) {
    switch (place) {
      case 1:
        return Colors.green.shade600;
      case 2:
        return Colors.blue.shade600;
      case 3:
        return Colors.yellow.shade700;
      default:
        return Colors.white;
    }
  }
}