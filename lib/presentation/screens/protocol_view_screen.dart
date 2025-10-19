import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/protocol_local.dart';
import '../../data/services/protocol_export_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';

class ProtocolViewScreen extends StatefulWidget {
  final ProtocolLocal protocol;

  const ProtocolViewScreen({
    Key? key,
    required this.protocol,
  }) : super(key: key);

  @override
  State<ProtocolViewScreen> createState() => _ProtocolViewScreenState();
}

class _ProtocolViewScreenState extends State<ProtocolViewScreen> {
  final ProtocolExportService _exportService = ProtocolExportService();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final data = jsonDecode(widget.protocol.dataJson) as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getProtocolTitle()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.share),
            onSelected: (value) => _handleExport(value, data),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('download_pdf'.tr()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    const Icon(Icons.table_chart, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('download_excel'.tr()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
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
          if (_isExporting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Экспорт протокола...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleExport(String format, Map<String, dynamic> data) async {
    setState(() {
      _isExporting = true;
    });

    try {
      switch (format) {
        case 'pdf':
          await _exportService.exportToPdf(widget.protocol, data);
          break;
        case 'excel':
          await _exportService.exportToExcel(widget.protocol, data);
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Протокол экспортирован успешно'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      print('Export error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка экспорта: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  String _getProtocolTitle() {
    switch (widget.protocol.type) {
      case 'weighing':
        return 'protocol_weighing_title'.tr(namedArgs: {
          'day': widget.protocol.dayNumber.toString(),
          'number': widget.protocol.weighingNumber.toString(),
        });
      case 'intermediate':
        return 'protocol_intermediate_title'.tr(namedArgs: {
          'number': widget.protocol.weighingNumber.toString(),
        });
      case 'big_fish':
        return 'protocol_big_fish_title'.tr(namedArgs: {
          'day': widget.protocol.bigFishDay.toString(),
        });
      case 'summary':
        return 'protocol_summary_title'.tr();
      case 'final':
        return 'protocol_final_title'.tr();
      case 'draw':
        return 'draw_protocol_title'.tr();
      case 'casting_attempt':
        return 'Протокол попытки №${widget.protocol.weighingNumber}';
      case 'casting_intermediate':
        return 'Промежуточный протокол (после ${widget.protocol.weighingNumber} попыток)';
      case 'casting_final':
        return 'Финальный протокол кастинга';
      default:
        return 'protocol_title'.tr();
    }
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    final hasCity = data['city'] != null;
    final hasLake = data['lake'] != null;
    final hasVenue = data['venue'] != null;
    final hasOrganizer = data['organizer'] != null;
    final hasWeighingTime = data['weighingTime'] != null;
    final hasSessionTime = data['sessionTime'] != null;
    final hasTimeRange = data['startTime'] != null && data['finishTime'] != null;
    final hasJudges = data['judges'] != null;

    if (!hasCity && !hasLake && !hasVenue && !hasOrganizer && !hasWeighingTime && !hasSessionTime && !hasTimeRange && !hasJudges) {
      return SizedBox.shrink();
    }

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasCity)
              _buildInfoRow(Icons.location_on, data['city']),
            if (hasVenue)
              _buildInfoRow(Icons.water, data['venue']),
            if (hasLake && !hasVenue)
              _buildInfoRow(Icons.water, data['lake']),
            if (hasOrganizer)
              _buildInfoRow(Icons.person, '${'protocol_organizer'.tr()}: ${data['organizer']}'),
            if (hasSessionTime)
              _buildInfoRow(
                Icons.access_time,
                'Время сессии: ${DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.parse(data['sessionTime']),
                )}',
              ),
            if (hasWeighingTime)
              _buildInfoRow(
                Icons.access_time,
                DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.parse(data['weighingTime']),
                ),
              ),
            if (hasTimeRange)
              _buildInfoRow(
                Icons.calendar_today,
                '${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['finishTime']))}',
              ),
            if (hasJudges)
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
            '${'protocol_judges'.tr()}:',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 4),
          ...judges.map((judge) => Padding(
            padding: EdgeInsets.only(left: AppDimensions.paddingSmall, top: 2),
            child: Text(
              '• ${judge['name']} - ${(judge['rank'] as String).tr()}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProtocolContent(Map<String, dynamic> data) {
    switch (widget.protocol.type) {
      case 'weighing':
      case 'intermediate':
        return _buildWeighingTable(data);
      case 'big_fish':
        return _buildBigFishContent(data);
      case 'summary':
        return _buildSummaryContent(data);
      case 'final':
        return _buildFinalContent(data);
      case 'draw':
        return _buildDrawTable(data);
      case 'casting_attempt':
        return _buildCastingAttemptContent(data);
      case 'casting_intermediate':
      case 'casting_final':
        return _buildCastingIntermediateOrFinalContent(data);
      default:
        return Center(child: Text('protocol_type_not_supported'.tr()));
    }
  }

  // ========== ПРОТОКОЛ ЖЕРЕБЬЁВКИ ==========
  Widget _buildDrawTable(Map<String, dynamic> data) {
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
          final index = entry.key + 1; // Порядковый номер
          final row = entry.value as Map<String, dynamic>;

          return DataRow(cells: [
            // № п/п
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
            // Команда
            DataCell(Text(row['teamName']?.toString() ?? '', style: AppTextStyles.bodyBold)),
            // Город
            DataCell(Text(row['city']?.toString() ?? '', style: AppTextStyles.body)),
            // № жеребьёвки (очередность выбора)
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
            // Сектор
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

  // ========== КАСТИНГ: ПРОТОКОЛ ПОПЫТКИ ==========
  Widget _buildCastingAttemptContent(Map<String, dynamic> data) {
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

  // ========== КАСТИНГ: ПРОМЕЖУТОЧНЫЙ И ФИНАЛЬНЫЙ ==========
  Widget _buildCastingIntermediateOrFinalContent(Map<String, dynamic> data) {
    final participantsData = data['participantsData'] as List<dynamic>? ?? [];
    final bestInAttempts = (data['bestInAttempts'] as List<dynamic>?)?.cast<double>() ?? [];
    final scoringMethod = data['scoringMethod'] as String? ?? 'average_distance';
    final upToAttempt = data['upToAttempt'] as int?;
    final attemptsCount = data['attemptsCount'] as int? ?? upToAttempt ?? 3;
    final commonLine = data['commonLine'] as String?;

    if (participantsData.isEmpty) {
      return Center(child: Text('protocol_no_data'.tr()));
    }

    // Информация об общей леске
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

    // Информация о методе подсчёта
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

  // ========== РЫБАЛКА ПРОТОКОЛЫ ==========

  Widget _buildWeighingTable(Map<String, dynamic> data) {
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
            if (widget.protocol.type == 'intermediate')
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
                if (widget.protocol.type == 'intermediate')
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
      return Center(child: Text('protocol_big_fish_no_data'.tr()));
    }

    // ✅ ИСПРАВЛЕНО: Убрали неиспользуемые поля dayNumber, dayStart, dayEnd
    // Эти поля отсутствуют в JSON, поэтому вызывали ошибку

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ УБРАЛИ: Card с периодом (dayStart/dayEnd)
        // Эта информация отсутствует в JSON протокола

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
                            bigFish['teamName']?.toString() ?? 'Unknown', // ✅ Добавлена проверка
                            style: AppTextStyles.bodyBold.copyWith(color: Colors.amber.shade800),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(bigFish['fishType']?.toString() ?? '-')), // ✅ Добавлена проверка
                    DataCell(
                      Text(
                        '${((bigFish['weight'] as num?) ?? 0).toStringAsFixed(3)}', // ✅ Добавлена проверка
                        style: AppTextStyles.bodyBold.copyWith(
                          color: Colors.amber.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DataCell(Text('${bigFish['length'] ?? 0}')), // ✅ Добавлена проверка
                    DataCell(Text('${bigFish['sector'] ?? 0}')), // ✅ Добавлена проверка
                    DataCell(
                      Text(
                        bigFish['weighingTime'] != null
                            ? DateFormat('dd.MM HH:mm').format(
                          DateTime.parse(bigFish['weighingTime']),
                        )
                            : '-', // ✅ Добавлена проверка
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

  Widget _buildSummaryContent(Map<String, dynamic> data) {
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
            DataColumn(label: Text('protocol_table_trophy'.tr(), style: AppTextStyles.bodyBold)),
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
                DataCell(Text('${teamData['biggestFish'].toStringAsFixed(3)}')),
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

  Widget _buildFinalContent(Map<String, dynamic> data) {
    final finalData = data['finalData'] as List<dynamic>? ?? [];

    if (finalData.isEmpty) {
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
    );
  }

  Color _getPlaceColor(int place) {
    switch (place) {
      case 1:
        return Colors.green.shade600; // 🥇 Зелёный
      case 2:
        return Colors.blue.shade600;  // 🥈 Синий
      case 3:
        return Colors.yellow.shade700; // 🥉 Жёлтый
      default:
        return Colors.white;
    }
  }
}