import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/local/protocol_local.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_dimensions.dart';

class CarpProtocolContent extends StatelessWidget {
  final ProtocolLocal protocol;
  final Map<String, dynamic> data;

  const CarpProtocolContent({
    Key? key,
    required this.protocol,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (protocol.type) {
      case 'weighing':
      case 'intermediate':
        return _buildWeighingTable();
      case 'big_fish':
        return _buildBigFishContent();
      case 'summary':
        return _buildSummaryContent();
      case 'final':
        return _buildFinalContent();
      case 'draw':
        return _buildDrawTable();
      default:
        return Center(child: Text('protocol_type_not_supported'.tr()));
    }
  }

  Widget _buildWeighingTable() {
    final tableData = data['tableData'] as List<dynamic>? ?? [];

    if (tableData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    return Card(
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppColors.primary.withOpacity(0.1),
          ),
          columns: [
            DataColumn(label: Text('protocol_table_number'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_team'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_sector'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_count'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_total_weight'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_avg_weight'.tr(), style: AppTextStyles.bodyBold)),
            if (protocol.type == 'intermediate')
              DataColumn(label: Text('protocol_table_place'.tr(), style: AppTextStyles.bodyBold)),
          ],
          rows: tableData.map<DataRow>((row) {
            final totalWeight = row['totalWeight'] as num;
            final fishCount = row['fishCount'] as int;
            final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

            return DataRow(
              cells: [
                DataCell(Text('${row['order']}')),
                DataCell(Text(row['teamName'] ?? '')),
                DataCell(Text('${row['sector']}')),
                DataCell(Text('$fishCount')),
                DataCell(Text('${totalWeight.toStringAsFixed(3)}')),
                DataCell(Text('${avgWeight.toStringAsFixed(3)}')),
                if (protocol.type == 'intermediate')
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPlaceColor(row['place']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Text(
                        '${row['place']}',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: _getPlaceColor(row['place']),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBigFishContent() {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return Center(child: Text('protocol_big_fish_no_data'.tr()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colors.amber.withOpacity(0.2),
              ),
              columns: [
                DataColumn(label: Text('🏆 ${'protocol_table_team'.tr()}', style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_fish_type'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_weight'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_length'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_sector'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_weighing_time'.tr(), style: AppTextStyles.bodyBold)),
              ],
              rows: [
                DataRow(
                  color: WidgetStateProperty.all(Colors.amber.withOpacity(0.1)),
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            bigFish['teamName']?.toString() ?? 'Unknown',
                            style: AppTextStyles.bodyBold.copyWith(color: Colors.amber.shade800),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(bigFish['fishType']?.toString() ?? '-')),
                    DataCell(
                      Text(
                        '${((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3)}',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: Colors.amber.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DataCell(Text('${bigFish['length'] ?? 0}')),
                    DataCell(Text('${bigFish['sector'] ?? 0}')),
                    DataCell(
                      Text(
                        bigFish['weighingTime'] != null
                            ? DateFormat('dd.MM HH:mm').format(
                          DateTime.parse(bigFish['weighingTime']),
                        )
                            : '-',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryContent() {
    final summaryData = data['summaryData'] as List<dynamic>? ?? [];

    if (summaryData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    return Card(
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppColors.primary.withOpacity(0.1),
          ),
          columns: [
            DataColumn(label: Text('protocol_table_team'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_members'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_rank'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_sector'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_count'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_total_weight'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_avg_weight'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(
              label: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text('protocol_table_trophy'.tr(), style: AppTextStyles.bodyBold),
                ],
              ),
            ),
            DataColumn(label: Text('protocol_table_penalties'.tr(), style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('protocol_table_place'.tr(), style: AppTextStyles.bodyBold)),
          ],
          rows: summaryData.map<DataRow>((teamData) {
            final members = (teamData['members'] as List<dynamic>);
            final memberNames = members.map((m) => m['fullName'] as String).join('\n');
            final memberRanks = members.map((m) => m['rank'] as String).join('\n');

            final totalWeight = teamData['totalWeight'] as num;
            final fishCount = teamData['totalFishCount'] as int;
            final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;
            final biggestFish = teamData['biggestFish'] as num;

            return DataRow(
              cells: [
                DataCell(Text(teamData['teamName'] ?? '', style: AppTextStyles.bodyBold)),
                DataCell(
                  Container(
                    constraints: BoxConstraints(maxWidth: 150),
                    child: Text(
                      memberNames,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    constraints: BoxConstraints(maxWidth: 80),
                    child: Text(
                      memberRanks,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                    ),
                  ),
                ),
                DataCell(Text('${teamData['sector']}')),
                DataCell(Text('$fishCount')),
                DataCell(Text('${totalWeight.toStringAsFixed(3)}')),
                DataCell(Text('${avgWeight.toStringAsFixed(3)}')),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Text(
                      '${biggestFish.toStringAsFixed(3)}',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: Colors.amber.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                DataCell(Text('${teamData['penalties']}')),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPlaceColor(teamData['place']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Text(
                      '${teamData['place']}',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: _getPlaceColor(teamData['place']),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFinalContent() {
    final finalData = data['finalData'] as List<dynamic>? ?? [];
    final competitionBiggestFish = data['competitionBiggestFish'] as Map<String, dynamic>?;

    if (finalData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
              columns: [
                DataColumn(label: Text('protocol_table_team'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_city'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_club'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_members'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_rank'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_sector'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_count'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_total_weight'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_avg_weight'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_trophy'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_penalties'.tr(), style: AppTextStyles.bodyBold)),
                DataColumn(label: Text('protocol_table_place'.tr(), style: AppTextStyles.bodyBold)),
              ],
              rows: finalData.map<DataRow>((row) {
                final members = (row['members'] as List<dynamic>);
                final memberNames = members.map((m) => m['fullName'] as String).join('\n');
                final memberRanks = members.map((m) => m['rank'] as String).join('\n');

                final totalWeight = row['totalWeight'] as num;
                final fishCount = row['totalFishCount'] as int;
                final avgWeight = fishCount > 0 ? totalWeight / fishCount : 0.0;

                return DataRow(
                  cells: [
                    DataCell(Text(row['teamName'] ?? '', style: AppTextStyles.bodyBold)),
                    DataCell(Text(row['city'] ?? '')),
                    DataCell(Text(row['club'] ?? '-')),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 150),
                        child: Text(
                          memberNames,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 80),
                        child: Text(
                          memberRanks,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                    DataCell(Text('${row['sector']}')),
                    DataCell(Text('$fishCount')),
                    DataCell(Text('${totalWeight.toStringAsFixed(3)}')),
                    DataCell(Text('${avgWeight.toStringAsFixed(3)}')),
                    DataCell(Text('${(row['biggestFish'] as num).toStringAsFixed(3)}')),
                    DataCell(Text('${row['penalties']}')),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSmall,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPlaceColor(row['place']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Text(
                          '${row['place']}',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: _getPlaceColor(row['place']),
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

        if (competitionBiggestFish != null) ...[
          SizedBox(height: AppDimensions.paddingLarge),
          Card(
            color: Colors.amber.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                      SizedBox(width: AppDimensions.paddingMedium),
                      Text(
                        'BIG FISH',
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.amber.shade700, thickness: 2),
                  SizedBox(height: AppDimensions.paddingMedium),
                  _buildBigFishInfoRow('Команда', competitionBiggestFish['teamName']?.toString() ?? 'Unknown'),
                  _buildBigFishInfoRow('Вид рыбы', competitionBiggestFish['fishType']?.toString() ?? '-'),
                  _buildBigFishInfoRow(
                    'Вес',
                    '${((competitionBiggestFish['weight'] as num?) ?? 0).toStringAsFixed(3)} кг',
                    isHighlighted: true,
                  ),
                  if ((competitionBiggestFish['length'] as num?) != null && (competitionBiggestFish['length'] as num) != 0)
                    _buildBigFishInfoRow('Длина', '${competitionBiggestFish['length']} см'),
                  _buildBigFishInfoRow('Сектор', '${competitionBiggestFish['sector'] ?? 0}'),
                  _buildBigFishInfoRow(
                    'Время взвешивания',
                    competitionBiggestFish['weighingTime'] != null
                        ? DateFormat('dd.MM.yyyy HH:mm').format(
                      DateTime.parse(competitionBiggestFish['weighingTime']),
                    )
                        : '-',
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDrawTable() {
    final drawData = data['drawData'] as List<dynamic>? ?? [];

    if (drawData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppDimensions.paddingMedium,
        headingRowColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.1)),
        columns: [
          DataColumn(label: Text('protocol_table_order'.tr(), style: AppTextStyles.bodyBold)),
          DataColumn(label: Text('protocol_table_team'.tr(), style: AppTextStyles.bodyBold)),
          DataColumn(label: Text('protocol_table_city'.tr(), style: AppTextStyles.bodyBold)),
          DataColumn(label: Text('protocol_table_draw_number'.tr(), style: AppTextStyles.bodyBold)),
          DataColumn(label: Text('protocol_table_sector'.tr(), style: AppTextStyles.bodyBold)),
        ],
        rows: drawData.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final row = entry.value as Map<String, dynamic>;

          return DataRow(cells: [
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSmall,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMedium,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text('$index', style: AppTextStyles.bodyBold),
              ),
            ),
            DataCell(Text(row['teamName']?.toString() ?? '', style: AppTextStyles.bodyBold)),
            DataCell(Text(row['city']?.toString() ?? '', style: AppTextStyles.body)),
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  '${row['drawOrder'] ?? '-'}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  '${row['sector'] ?? '-'}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.success),
                ),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildBigFishInfoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyBold.copyWith(
                color: Colors.amber.shade800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: isHighlighted
                  ? AppTextStyles.h2.copyWith(
                color: Colors.amber.shade900,
                fontWeight: FontWeight.bold,
              )
                  : AppTextStyles.bodyMedium.copyWith(
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
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