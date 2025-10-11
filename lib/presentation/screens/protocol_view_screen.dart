import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/protocol_local.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';

class ProtocolViewScreen extends StatelessWidget {
  final ProtocolLocal protocol;

  const ProtocolViewScreen({
    Key? key,
    required this.protocol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = jsonDecode(protocol.dataJson) as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getProtocolTitle()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Экспорт - в разработке')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              SizedBox(height: AppDimensions.paddingLarge),
              _buildProtocolContent(data),
            ],
          ),
        ),
      ),
    );
  }

  String _getProtocolTitle() {
    switch (protocol.type) {
      case 'weighing':
        return 'Протокол взвешивания День ${protocol.dayNumber}, №${protocol.weighingNumber}';
      case 'intermediate':
        return 'Промежуточный протокол №${protocol.weighingNumber}';
      case 'big_fish':
        return 'Big Fish - День ${protocol.bigFishDay}';
      case 'summary':
        return 'Сводный протокол';
      case 'final':
        return 'Финальный протокол';
      default:
        return 'Протокол';
    }
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['competitionName'] ?? '',
              style: AppTextStyles.h2,
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            if (data['city'] != null)
              _buildInfoRow(Icons.location_on, data['city']),
            if (data['lake'] != null)
              _buildInfoRow(Icons.water, data['lake']),
            if (data['organizer'] != null && (protocol.type == 'summary' || protocol.type == 'final'))
              _buildInfoRow(Icons.person, 'Организатор: ${data['organizer']}'),
            if (data['weighingTime'] != null)
              _buildInfoRow(
                Icons.access_time,
                DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.parse(data['weighingTime']),
                ),
              ),
            if (data['startTime'] != null && data['finishTime'] != null)
              _buildInfoRow(
                Icons.calendar_today,
                '${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['finishTime']))}',
              ),
            if (data['judges'] != null && (protocol.type == 'summary' || protocol.type == 'final'))
              _buildJudges(data['judges'] as List<dynamic>),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimensions.paddingSmall),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          SizedBox(width: AppDimensions.paddingSmall),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJudges(List<dynamic> judges) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimensions.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Судьи:',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 4),
          ...judges.map((judge) => Padding(
            padding: EdgeInsets.only(left: AppDimensions.paddingSmall, top: 2),
            child: Text(
              '• ${judge['name']} - ${judge['rank']}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProtocolContent(Map<String, dynamic> data) {
    switch (protocol.type) {
      case 'weighing':
      case 'intermediate':
        return _buildWeighingTable(data);
      case 'big_fish':
        return _buildBigFishContent(data);
      case 'summary':
        return _buildSummaryContent(data);
      case 'final':
        return _buildFinalContent(data);
      default:
        return const Text('Тип протокола не поддерживается');
    }
  }

  Widget _buildWeighingTable(Map<String, dynamic> data) {
    final tableData = data['tableData'] as List<dynamic>? ?? [];

    if (tableData.isEmpty) {
      return const Center(child: Text('Нет данных'));
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
            DataColumn(label: Text('№', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Команда', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Сектор', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Кол-во', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Вес (кг)', style: AppTextStyles.bodyBold)),
            if (protocol.type == 'intermediate')
              DataColumn(label: Text('Место', style: AppTextStyles.bodyBold)),
          ],
          rows: tableData.map<DataRow>((row) {
            return DataRow(
              cells: [
                DataCell(Text('${row['order']}')),
                DataCell(Text(row['teamName'] ?? '')),
                DataCell(Text('${row['sector']}')),
                DataCell(Text('${row['fishCount']}')),
                DataCell(Text('${(row['totalWeight'] as num).toStringAsFixed(3)}')),
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

  Widget _buildBigFishContent(Map<String, dynamic> data) {
    final bigFish = data['bigFish'] as Map<String, dynamic>?;

    if (bigFish == null) {
      return const Center(child: Text('Нет данных о самой крупной рыбе'));
    }

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: Colors.amber,
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            Text(
              bigFish['teamName'] ?? '',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Text(
              '${(bigFish['weight'] as num).toStringAsFixed(3)} кг',
              style: AppTextStyles.h1.copyWith(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            Divider(),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildBigFishRow('Вид', bigFish['fishType'] ?? ''),
            _buildBigFishRow('Длина', '${bigFish['length']} см'),
            _buildBigFishRow('Сектор', '${bigFish['sector']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(Map<String, dynamic> data) {
    final summaryData = data['summaryData'] as List<dynamic>? ?? [];

    if (summaryData.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }

    return Column(
      children: summaryData.map<Widget>((teamData) {
        return Card(
          color: AppColors.surface,
          margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
          child: ExpansionTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPlaceColor(teamData['place']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Center(
                child: Text(
                  '${teamData['place']}',
                  style: AppTextStyles.h3.copyWith(
                    color: _getPlaceColor(teamData['place']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              teamData['teamName'] ?? '',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Сектор ${teamData['sector']} • ${teamData['totalWeight'].toStringAsFixed(3)} кг',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Участники:', style: AppTextStyles.bodyBold),
                    SizedBox(height: AppDimensions.paddingSmall),
                    ...(teamData['members'] as List<dynamic>).map((m) => Padding(
                      padding: EdgeInsets.only(left: AppDimensions.paddingSmall, top: 2),
                      child: Text(
                        '• ${m['fullName']} (${m['rank']})',
                        style: AppTextStyles.bodyMedium,
                      ),
                    )),
                    SizedBox(height: AppDimensions.paddingMedium),
                    Divider(),
                    SizedBox(height: AppDimensions.paddingSmall),
                    _buildSummaryRow('Общий вес:', '${teamData['totalWeight'].toStringAsFixed(3)} кг'),
                    _buildSummaryRow('Кол-во рыбы:', '${teamData['totalFishCount']}'),
                    _buildSummaryRow('Трофей:', '${teamData['biggestFish'].toStringAsFixed(3)} кг'),
                    _buildSummaryRow('Штрафы:', '${teamData['penalties']}'),
                    SizedBox(height: AppDimensions.paddingMedium),
                    Text('Взвешивания:', style: AppTextStyles.bodyBold),
                    SizedBox(height: AppDimensions.paddingSmall),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          AppColors.primary.withOpacity(0.1),
                        ),
                        columns: [
                          DataColumn(label: Text('День', style: AppTextStyles.bodyMedium)),
                          DataColumn(label: Text('№', style: AppTextStyles.bodyMedium)),
                          DataColumn(label: Text('Время', style: AppTextStyles.bodyMedium)),
                          DataColumn(label: Text('Кол-во', style: AppTextStyles.bodyMedium)),
                          DataColumn(label: Text('Вес (кг)', style: AppTextStyles.bodyMedium)),
                        ],
                        rows: (teamData['weighings'] as List<dynamic>).map<DataRow>((w) {
                          return DataRow(
                            cells: [
                              DataCell(Text('${w['dayNumber']}', style: AppTextStyles.bodyMedium)),
                              DataCell(Text('${w['weighingNumber']}', style: AppTextStyles.bodyMedium)),
                              DataCell(Text(
                                DateFormat('HH:mm').format(DateTime.parse(w['weighingTime'])),
                                style: AppTextStyles.bodyMedium,
                              )),
                              DataCell(Text('${w['fishCount']}', style: AppTextStyles.bodyMedium)),
                              DataCell(Text('${(w['totalWeight'] as num).toStringAsFixed(3)}', style: AppTextStyles.bodyMedium)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFinalContent(Map<String, dynamic> data) {
    final finalData = data['finalData'] as List<dynamic>? ?? [];

    if (finalData.isEmpty) {
      return const Center(child: Text('Нет данных'));
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
            DataColumn(label: Text('Место', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Команда', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Город', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Клуб', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Сектор', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Кол-во', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Вес (кг)', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Трофей (кг)', style: AppTextStyles.bodyBold)),
            DataColumn(label: Text('Штрафы', style: AppTextStyles.bodyBold)),
          ],
          rows: finalData.map<DataRow>((row) {
            return DataRow(
              cells: [
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
                DataCell(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(row['teamName'] ?? '', style: AppTextStyles.bodyBold),
                      ...(row['members'] as List<dynamic>).map((m) => Text(
                        '${m['fullName']} (${m['rank']})',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      )),
                    ],
                  ),
                ),
                DataCell(Text(row['city'] ?? '')),
                DataCell(Text(row['club'] ?? '-')),
                DataCell(Text('${row['sector']}')),
                DataCell(Text('${row['totalFishCount']}')),
                DataCell(Text('${(row['totalWeight'] as num).toStringAsFixed(3)}')),
                DataCell(Text('${(row['biggestFish'] as num).toStringAsFixed(3)}')),
                DataCell(Text('${row['penalties']}')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBigFishRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getPlaceColor(int place) {
    switch (place) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return AppColors.textSecondary;
    }
  }
}