import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../providers/competition_provider.dart';
import '../../data/models/local/competition_local.dart';
import 'create_competition_screen.dart';
import 'enter_code_screen.dart';
import 'competition_details_screen.dart';
import '../../data/services/isar_service.dart';

class MyCompetitionsScreen extends ConsumerStatefulWidget {
  final String fishingType;

  const MyCompetitionsScreen({
    Key? key,
    required this.fishingType,
  }) : super(key: key);

  @override
  ConsumerState<MyCompetitionsScreen> createState() => _MyCompetitionsScreenState();
}

class _MyCompetitionsScreenState extends ConsumerState<MyCompetitionsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final competitionsAsync = ref.watch(competitionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('my_competitions'.tr(), style: AppTextStyles.h3),
            Text(
              'fishing_type_${widget.fishingType}'.tr(),
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),

        // ⬇️ DEBUG кнопка (только для тестирования)
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: AppColors.error),
            tooltip: 'Очистить всё (DEBUG)',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogContext) =>
                    AlertDialog(
                      backgroundColor: AppColors.surface,
                      title: Text(
                          'Очистить все данные?', style: AppTextStyles.h3),
                      content: Text(
                        'Все соревнования будут удалены.\nЭто действие необратимо.',
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text('cancel'.tr(), style: AppTextStyles.body
                              .copyWith(color: AppColors.textSecondary)),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error),
                          child: Text(
                              'delete_all'.tr(), style: AppTextStyles.button),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      Center(
                        child: Card(
                          color: AppColors.surface,
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.paddingLarge),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                    color: AppColors.primary),
                                SizedBox(height: AppDimensions.paddingMedium),
                                Text('Удаление...', style: AppTextStyles.body),
                              ],
                            ),
                          ),
                        ),
                      ),
                );

                try {
                  final isarService = IsarService();
                  final allCompetitions = await isarService
                      .getAllCompetitions();
                  for (var comp in allCompetitions) {
                    await isarService.deleteCompetition(comp.id!);
                  }
                  print('✅ Deleted ${allCompetitions
                      .length} competitions with cascade');
                } catch (e) {
                  print('❌ Delete error: $e');
                }

                Navigator.of(context).pop();
                ref
                    .read(competitionProvider.notifier)
                    .loadAllCompetitionsForDevice();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Все данные удалены'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: competitionsAsync.when(
              data: (competitions) {
                final filtered = _filterCompetitions(competitions);
                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildCompetitionsList(filtered);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(
                    child: Text(
                      'error_loading_competitions'.tr(),
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.error),
                    ),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleCreateCompetition(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.text),
        label: Text('create_competition'.tr(), style: AppTextStyles.button),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildFilterChip('all', 'all'.tr()),
          SizedBox(width: AppDimensions.paddingSmall),
          _buildFilterChip('active', 'active'.tr()),
          SizedBox(width: AppDimensions.paddingSmall),
          _buildFilterChip('completed', 'completed'.tr()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filter = value);
      },
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      labelStyle: AppTextStyles.body.copyWith(
        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildCompetitionsList(List<CompetitionLocal> competitions) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(competitionProvider.notifier)
            .loadAllCompetitionsForDevice();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          final competition = competitions[index];
          return _buildCompetitionCard(competition);
        },
      ),
    );
  }

  Widget _buildCompetitionCard(CompetitionLocal competition) {
    final statusColor = _getStatusColor(competition.status);
    final statusText = _getStatusText(competition.status);
    final isSynced = competition.isSynced;

    return Dismissible(
      key: Key(competition.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Icon(Icons.delete, color: AppColors.textPrimary),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteCompetitionDialog(context, competition);
      },
      onDismissed: (direction) {
        ref.read(competitionProvider.notifier).deleteCompetition(
            competition.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('competition_deleted'.tr())),
        );
      },
      child: Card(
        color: AppColors.surface,
        margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CompetitionDetailsScreen(competition: competition),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        competition.name,
                        style: AppTextStyles.h3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isSynced ? Icons.cloud_done : Icons.cloud_off,
                          size: 16,
                          color: isSynced ? AppColors.success : AppColors
                              .upcoming,
                        ),
                        SizedBox(width: AppDimensions.paddingSmall),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingSmall,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            statusText,
                            style: AppTextStyles.caption.copyWith(
                                color: statusColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.paddingSmall),
                _buildInfoRow(Icons.location_on,
                    '${competition.cityOrRegion} • ${competition.lakeName}'),
                SizedBox(height: 4),
                _buildInfoRow(
                  Icons.calendar_today,
                  DateFormat('dd.MM.yyyy HH:mm').format(competition.startTime),
                ),
                SizedBox(height: 4),
                _buildInfoRow(Icons.access_time,
                    '${competition.durationHours} ${'hours'.tr()}'),
                SizedBox(height: 4),
                _buildInfoRow(Icons.grid_on,
                    '${competition.sectorsCount} ${'sectors'.tr()}'),
                if (competition.judges.isNotEmpty) ...[
                  SizedBox(height: AppDimensions.paddingSmall),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16,
                          color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        '${competition.judges.length} ${'judges'.tr()}',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
                if (competition.status == 'active') ...[
                  SizedBox(height: AppDimensions.paddingMedium),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _completeCompetition(competition),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.success),
                      ),
                      child: Text(
                        'complete_competition'.tr(),
                        style: AppTextStyles.body.copyWith(color: AppColors
                            .success),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'no_my_competitions'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'create_first_competition_hint'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<CompetitionLocal> _filterCompetitions(
      List<CompetitionLocal> competitions) {
    // Фильтруем по типу рыбалки И по статусу
    final byType = competitions.where((c) =>
    c.fishingType == widget.fishingType).toList();

    if (_filter == 'all') return byType;

    return byType.where((c) {
      return _filter == 'active'
          ? c.status == 'active'
          : c.status == 'completed';
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'completed':
        return AppColors.textSecondary;
      case 'draft':
        return AppColors.upcoming;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'active'.tr();
      case 'completed':
        return 'completed'.tr();
      case 'draft':
        return 'draft'.tr();
      default:
        return status;
    }
  }

  Future<void> _completeCompetition(CompetitionLocal competition) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('complete_competition'.tr(), style: AppTextStyles.h3),
            content: Text(
              'complete_competition_confirmation'.tr(),
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('cancel'.tr(), style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success),
                child: Text('complete'.tr(), style: AppTextStyles.button),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await ref.read(competitionProvider.notifier).updateCompetitionStatus(
          competition.id, 'completed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('competition_completed'.tr())),
      );
    }
  }

  Future<void> _handleCreateCompetition(BuildContext context) async {
    print('🔵 _handleCreateCompetition called for ${widget.fishingType}');

    // Сразу открываем экран ввода кода (там есть кнопка "Купить код")
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const EnterCodeScreen()),
    );

    print('🔑 Received code: $code');

    if (code != null && code.isNotEmpty && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_code', code);
      await prefs.setBool('is_admin', true);

      print('✅ Code saved to SharedPreferences: $code');

      // Открываем экран создания соревнования
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CreateCompetitionScreen(
                accessCode: code,
                fishingType: widget.fishingType,
              ),
        ),
      );

      if (mounted) {
        ref.read(competitionProvider.notifier).loadAllCompetitionsForDevice();
      }
    }
  }


  Future<bool?> _showDeleteCompetitionDialog(BuildContext context,
      CompetitionLocal competition) async {
    final TextEditingController confirmController = TextEditingController();
    bool isButtonEnabled = false;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A5F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'delete_competition'.tr(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'delete_competition_warning'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A4A6F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                competition.name,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'enter_word_to_confirm'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: confirmController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF2A4A6F),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'delete_upper'.tr(),
                                hintStyle: const TextStyle(
                                  color: Colors.white38,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isButtonEnabled =
                                      value.trim().toUpperCase() == 'DELETE' ||
                                          value.trim().toUpperCase() ==
                                              'УДАЛИТЬ' ||
                                          value.trim().toUpperCase() == 'ЖОЮ';
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(false);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      backgroundColor: Colors.white24,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'cancel'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: isButtonEnabled
                                        ? () async {
                                      Navigator.of(dialogContext).pop(true);
                                    }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      backgroundColor: isButtonEnabled
                                          ? const Color(0xFF4A90E2)
                                          : Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'delete'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}