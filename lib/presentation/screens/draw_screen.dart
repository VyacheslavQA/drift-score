import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../../data/models/local/protocol_local.dart';
import '../../data/services/isar_service.dart';
import '../../data/services/sync_service.dart';
import '../providers/team_provider.dart';
import '../providers/protocol_provider.dart';
import 'dart:convert';

class DrawScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const DrawScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  ConsumerState<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends ConsumerState<DrawScreen> {
  int _currentStep = 0; // 0 = очередность, 1 = сектора
  bool _isEditMode = false; // Режим редактирования

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamProvider(widget.competition.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('draw'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          // Кнопка редактирования (показываем только если жеребьевка завершена и не в режиме редактирования)
          if (!_isEditMode)
            teamsAsync.when(
              data: (teams) {
                final isDrawCompleted = teams.isNotEmpty &&
                    teams.every((t) => t.drawOrder != null && t.sector != null);

                if (isDrawCompleted) {
                  return IconButton(
                    icon: Icon(Icons.edit, color: AppColors.primary),
                    tooltip: 'Редактировать',
                    onPressed: () {
                      setState(() {
                        _isEditMode = true;
                      });
                    },
                  );
                }
                return SizedBox.shrink();
              },
              loading: () => SizedBox.shrink(),
              error: (_, __) => SizedBox.shrink(),
            ),
        ],
      ),
      body: teamsAsync.when(
        data: (teams) {
          if (teams.isEmpty) {
            return _buildEmptyState();
          }

          // Определяем текущий этап
          final hasAllOrders = teams.every((t) => t.drawOrder != null);
          final hasAllSectors = teams.every((t) => t.sector != null);
          final isDrawCompleted = hasAllOrders && hasAllSectors;

          // Если жеребьевка завершена и НЕ в режиме редактирования, показываем только просмотр
          if (isDrawCompleted && !_isEditMode) {
            return _DrawCompletedView(
              competition: widget.competition,
              teams: teams,
              onEdit: () {
                setState(() {
                  _isEditMode = true;
                });
              },
            );
          }

          // Если в режиме редактирования и жеребьевка завершена
          if (isDrawCompleted && _isEditMode) {
            return _DrawEditView(
              competition: widget.competition,
              teams: teams,
              onExitEditMode: () {
                setState(() {
                  _isEditMode = false;
                });
              },
            );
          }

          // Если жеребьевка уже полностью завершена, открываем сразу 2-й шаг
          if (hasAllOrders && hasAllSectors && _currentStep == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _currentStep = 1);
              }
            });
          }

          if (_currentStep == 0 || !hasAllOrders) {
            return _DrawOrderStep(
              competition: widget.competition,
              teams: teams,
              onComplete: () {
                setState(() => _currentStep = 1);
              },
            );
          } else {
            return _DrawSectorStep(
              competition: widget.competition,
              teams: teams,
              onEditModeExit: () {
                setState(() {
                  _isEditMode = false;
                });
              },
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'error_loading_teams'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'no_teams_for_draw'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'add_teams_first'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ========================================
// ПРОСМОТР ЗАВЕРШЁННОЙ ЖЕРЕБЬЁВКИ
// ========================================

class _DrawCompletedView extends StatelessWidget {
  final CompetitionLocal competition;
  final List<TeamLocal> teams;
  final VoidCallback onEdit;

  const _DrawCompletedView({
    required this.competition,
    required this.teams,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Сортируем команды по номеру очередности
    final sortedTeams = List<TeamLocal>.from(teams)
      ..sort((a, b) => (a.drawOrder ?? 0).compareTo(b.drawOrder ?? 0));

    return SafeArea(
      child: Column(
        children: [
          // Баннер успешного завершения
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            margin: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 28),
                SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'draw_completed'.tr(),
                        style: AppTextStyles.h3.copyWith(color: AppColors.success),
                      ),
                      Text(
                        'draw_completed_description'.tr(),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Список команд с результатами жеребьёвки
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: sortedTeams.length,
              itemBuilder: (context, index) {
                final team = sortedTeams[index];
                return Card(
                  color: AppColors.surface,
                  margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Row(
                      children: [
                        // Номер по очередности
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '${team.drawOrder}',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingMedium),

                        // Информация о команде
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(team.name, style: AppTextStyles.bodyBold),
                              SizedBox(height: 4),
                              Text(
                                team.city,
                                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),

                        // Номер сектора
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'sector'.tr(),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                '${team.sector}',
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Кнопка генерации протокола
          _buildGenerateProtocolButton(context),
        ],
      ),
    );
  }

  Widget _buildGenerateProtocolButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => _generateDrawProtocol(context, teams, competition),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description, color: AppColors.text),
              SizedBox(width: AppDimensions.paddingSmall),
              Text(
                'generate_protocol'.tr(),
                style: AppTextStyles.button,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateDrawProtocol(
      BuildContext context,
      List<TeamLocal> teams,
      CompetitionLocal competition,
      ) async {
    print('🔵 Генерация протокола жеребьёвки...');

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          color: AppColors.surface,
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: AppDimensions.paddingMedium),
                Text('Генерация протокола...', style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final sortedTeams = List<TeamLocal>.from(teams)
        ..sort((a, b) => (a.drawOrder ?? 0).compareTo(b.drawOrder ?? 0));

      final drawData = sortedTeams.map((team) {
        return {
          'drawOrder': team.drawOrder,
          'teamName': team.name,
          'city': team.city,
          'sector': team.sector,
          'members': team.members.map((m) => m.fullName).toList(),
        };
      }).toList();

      final protocolData = {
        'competitionName': competition.name,
        'venueFormatted': '${competition.cityOrRegion}, ${competition.lakeName}',
        'competitionDates': DateFormat('dd.MM.yyyy').format(competition.startTime),
        'dateKey': 'competition_date_single',
        'drawData': drawData,
        'judges': competition.judges.map((j) {
          return {
            'name': j.fullName,
            'rank': j.rank,
          };
        }).toList(),
      };

      final protocol = ProtocolLocal()
        ..competitionId = competition.id.toString()
        ..type = 'draw'
        ..dataJson = jsonEncode(protocolData)
        ..createdAt = DateTime.now()
        ..isSynced = false;

      final isarService = IsarService();
      await isarService.saveProtocol(protocol);

      print('✅ Протокол жеребьёвки создан и сохранён в Isar');

      // 🔥 Синхронизация с Firebase
      if (competition.serverId != null && competition.serverId!.isNotEmpty) {
        final syncService = SyncService();
        await syncService.syncProtocolToFirebase(protocol, competition.serverId!);
        print('📤 Протокол жеребьёвки синхронизирован с Firebase');
      } else {
        print('⚠️ Соревнование не имеет serverId - протокол не синхронизирован с Firebase');
      }

      if (!context.mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_protocol_generated'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      print('❌ Ошибка: $e');

      if (!context.mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_protocol_error'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

// ========================================
// РЕЖИМ РЕДАКТИРОВАНИЯ ЖЕРЕБЬЁВКИ
// ========================================

class _DrawEditView extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final List<TeamLocal> teams;
  final VoidCallback onExitEditMode;

  const _DrawEditView({
    required this.competition,
    required this.teams,
    required this.onExitEditMode,
  });

  @override
  ConsumerState<_DrawEditView> createState() => _DrawEditViewState();
}

class _DrawEditViewState extends ConsumerState<_DrawEditView> {
  final Map<int, TextEditingController> _orderControllers = {};
  final Map<int, TextEditingController> _sectorControllers = {};
  final Map<int, bool> _hasChanges = {};

  @override
  void initState() {
    super.initState();
    for (var team in widget.teams) {
      _orderControllers[team.id] = TextEditingController(
        text: team.drawOrder?.toString() ?? '',
      );
      _sectorControllers[team.id] = TextEditingController(
        text: team.sector?.toString() ?? '',
      );
      _hasChanges[team.id] = false;

      // Слушатели для отслеживания изменений
      _orderControllers[team.id]!.addListener(() {
        setState(() {
          _hasChanges[team.id] = true;
        });
      });
      _sectorControllers[team.id]!.addListener(() {
        setState(() {
          _hasChanges[team.id] = true;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _orderControllers.values) {
      controller.dispose();
    }
    for (var controller in _sectorControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedTeams = List<TeamLocal>.from(widget.teams)
      ..sort((a, b) => (a.drawOrder ?? 0).compareTo(b.drawOrder ?? 0));

    return SafeArea(
      child: Column(
        children: [
          // Баннер режима редактирования
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            margin: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.upcoming.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: AppColors.upcoming.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.edit, color: AppColors.upcoming, size: 24),
                SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Text(
                    'edit_mode_active'.tr(),
                    style: AppTextStyles.body.copyWith(color: AppColors.upcoming),
                  ),
                ),
              ],
            ),
          ),

          // Список команд для редактирования
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: sortedTeams.length,
              itemBuilder: (context, index) {
                final team = sortedTeams[index];
                return _buildEditCard(team);
              },
            ),
          ),

          // Кнопка завершения редактирования
          _buildCompleteEditButton(),
        ],
      ),
    );
  }

  Widget _buildEditCard(TeamLocal team) {
    final hasChanges = _hasChanges[team.id] ?? false;

    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название команды
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(team.name, style: AppTextStyles.bodyBold),
                      Text(
                        team.city,
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Кнопка сохранения (показываем только если есть изменения)
                if (hasChanges)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.save, color: AppColors.success),
                      onPressed: () => _saveTeamChanges(team),
                      tooltip: 'Сохранить',
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingMedium),

            // Поля редактирования
            Row(
              children: [
                // Очередность
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Очередность',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _orderControllers[team.id],
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '№',
                          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingSmall,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),

                // Сектор
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сектор',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _sectorControllers[team.id],
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '№',
                          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingSmall,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            borderSide: BorderSide(color: AppColors.secondary, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteEditButton() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: widget.onExitEditMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: AppColors.text),
              SizedBox(width: AppDimensions.paddingSmall),
              Text(
                'Завершить редактирование',
                style: AppTextStyles.button,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTeamChanges(TeamLocal team) async {
    final orderText = _orderControllers[team.id]?.text.trim();
    final sectorText = _sectorControllers[team.id]?.text.trim();

    // Валидация очередности
    if (orderText == null || orderText.isEmpty) {
      _showError('Введите номер очередности');
      return;
    }

    final order = int.tryParse(orderText);
    if (order == null || order <= 0) {
      _showError('Некорректный номер очередности');
      return;
    }

    // Проверка на дубликат очередности
    for (var t in widget.teams) {
      if (t.id != team.id && t.drawOrder == order) {
        _showError('Номер очередности $order уже занят');
        return;
      }
    }

    // Валидация сектора
    if (sectorText == null || sectorText.isEmpty) {
      _showError('Введите номер сектора');
      return;
    }

    final sector = int.tryParse(sectorText);
    if (sector == null || sector <= 0 || sector > widget.competition.sectorsCount) {
      _showError('Некорректный номер сектора (должен быть от 1 до ${widget.competition.sectorsCount})');
      return;
    }

    // Проверка на дубликат сектора
    for (var t in widget.teams) {
      if (t.id != team.id && t.sector == sector) {
        _showError('Сектор $sector уже занят');
        return;
      }
    }

    // Скрываем клавиатуру
    FocusScope.of(context).unfocus();

    // Сохраняем
    try {
      await ref.read(teamProvider(widget.competition.id).notifier).saveDrawResults({
        team.id: DrawData(drawOrder: order, sector: sector),
      });

      setState(() {
        _hasChanges[team.id] = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Изменения сохранены'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError('Ошибка сохранения: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

// ========================================
// ЭТАП 1: ВВОД ОЧЕРЕДНОСТИ
// ========================================

class _DrawOrderStep extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final List<TeamLocal> teams;
  final VoidCallback onComplete;

  const _DrawOrderStep({
    required this.competition,
    required this.teams,
    required this.onComplete,
  });

  @override
  ConsumerState<_DrawOrderStep> createState() => _DrawOrderStepState();
}

class _DrawOrderStepState extends ConsumerState<_DrawOrderStep> {
  final Map<int, TextEditingController> _orderControllers = {};
  final Map<int, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    for (var team in widget.teams) {
      _orderControllers[team.id] = TextEditingController(
        text: team.drawOrder?.toString() ?? '',
      );
      _focusNodes[team.id] = FocusNode();

      // Автосохранение при потере фокуса
      _focusNodes[team.id]!.addListener(() {
        if (!_focusNodes[team.id]!.hasFocus) {
          final text = _orderControllers[team.id]?.text.trim() ?? '';
          if (text.isNotEmpty) {
            _saveOrder(team);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _orderControllers.values) {
      controller.dispose();
    }
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Заголовок шага
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Text(
              'draw_order_input'.tr(),
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: widget.teams.length,
              itemBuilder: (context, index) {
                final team = widget.teams[index];
                return _buildTeamOrderCard(team, index + 1);
              },
            ),
          ),
          _buildCompleteButton(),
        ],
      ),
    );
  }

  Widget _buildTeamOrderCard(TeamLocal team, int displayNumber) {
    final hasOrder = team.drawOrder != null;

    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          children: [
            // Номер команды в списке
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasOrder
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Center(
                child: hasOrder
                    ? Icon(Icons.check, color: AppColors.success, size: 20)
                    : Text(
                  '$displayNumber',
                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.paddingMedium),

            // Название команды
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(team.name, style: AppTextStyles.bodyBold),
                  Text(
                    team.city,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            SizedBox(width: AppDimensions.paddingSmall),

            // Поле ввода очередности
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: _orderControllers[team.id],
                focusNode: _focusNodes[team.id],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: '№',
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSmall,
                    vertical: AppDimensions.paddingSmall,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onFieldSubmitted: (_) {
                  // Сохранение при нажатии Enter
                  _saveOrder(team);
                },
              ),
            ),

            SizedBox(width: AppDimensions.paddingSmall),

            // Галочка если сохранено
            SizedBox(
              width: 24,
              child: hasOrder
                  ? Icon(Icons.check_circle, color: AppColors.success, size: 24)
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    final allHaveOrders = widget.teams.every((t) => t.drawOrder != null);

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: allHaveOrders ? widget.onComplete : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.surfaceMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: Text('next_step'.tr(), style: AppTextStyles.button),
        ),
      ),
    );
  }

  Future<void> _saveOrder(TeamLocal team) async {
    final orderText = _orderControllers[team.id]?.text.trim();

    if (orderText == null || orderText.isEmpty) {
      return; // Тихо выходим если пусто
    }

    final order = int.tryParse(orderText);
    if (order == null || order <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('invalid_number'.tr()),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Проверка на дубликат
    final teams = widget.teams;
    for (var t in teams) {
      if (t.id != team.id && t.drawOrder == order) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('draw_order_duplicate'.tr()),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    // Сохраняем
    try {
      await ref.read(teamProvider(widget.competition.id).notifier).saveDrawResults({
        team.id: DrawData(drawOrder: order, sector: team.sector),
      });
      // Автосохранение - не показываем уведомление
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_saving_draw'.tr()),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

// ========================================
// ЭТАП 2: ВВОД СЕКТОРОВ
// ========================================

class _DrawSectorStep extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final List<TeamLocal> teams;
  final VoidCallback? onEditModeExit;

  const _DrawSectorStep({
    required this.competition,
    required this.teams,
    this.onEditModeExit,
  });

  @override
  ConsumerState<_DrawSectorStep> createState() => _DrawSectorStepState();
}

class _DrawSectorStepState extends ConsumerState<_DrawSectorStep> {
  final Map<int, TextEditingController> _sectorControllers = {};
  final Map<int, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    for (var team in widget.teams) {
      _sectorControllers[team.id] = TextEditingController(
        text: team.sector?.toString() ?? '',
      );
      _focusNodes[team.id] = FocusNode();

      // Автосохранение при потере фокуса
      _focusNodes[team.id]!.addListener(() {
        if (!_focusNodes[team.id]!.hasFocus) {
          final text = _sectorControllers[team.id]?.text.trim() ?? '';
          if (text.isNotEmpty) {
            _saveSector(team);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _sectorControllers.values) {
      controller.dispose();
    }
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedTeams = List<TeamLocal>.from(widget.teams)
      ..sort((a, b) => (a.drawOrder ?? 0).compareTo(b.drawOrder ?? 0));

    return SafeArea(
      child: Column(
        children: [
          // Заголовок шага
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Text(
              'draw_sector_input'.tr(),
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: sortedTeams.length,
              itemBuilder: (context, index) {
                final team = sortedTeams[index];
                return _buildTeamSectorCard(team);
              },
            ),
          ),
          _buildCompleteButton(sortedTeams),
        ],
      ),
    );
  }

  Widget _buildTeamSectorCard(TeamLocal team) {
    final hasSector = team.sector != null;

    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          children: [
            // Номер очередности
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(
                child: Text(
                  '${team.drawOrder}',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.paddingMedium),

            // Название команды
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(team.name, style: AppTextStyles.bodyBold),
                  Text(
                    team.city,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            SizedBox(width: AppDimensions.paddingSmall),

            // Поле ввода сектора
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: _sectorControllers[team.id],
                focusNode: _focusNodes[team.id],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: '№',
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSmall,
                    vertical: AppDimensions.paddingSmall,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    borderSide: BorderSide(color: AppColors.secondary, width: 2),
                  ),
                ),
                onFieldSubmitted: (_) {
                  // Сохранение при нажатии Enter
                  _saveSector(team);
                },
              ),
            ),

            SizedBox(width: AppDimensions.paddingSmall),

            // Галочка если сохранено
            SizedBox(
              width: 24,
              child: hasSector
                  ? Icon(Icons.check_circle, color: AppColors.success, size: 24)
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton(List<TeamLocal> teams) {
    final allHaveSectors = teams.every((t) => t.sector != null);

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Кнопка "Завершить жеребьёвку"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: allHaveSectors ? _completeDraw : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                disabledBackgroundColor: AppColors.surfaceMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
              ),
              child: Text('complete_draw'.tr(), style: AppTextStyles.button),
            ),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          // Кнопка "Сгенерировать протокол"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: allHaveSectors ? () => _generateDrawProtocol(teams) : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: AppColors.primary),
                  SizedBox(width: AppDimensions.paddingSmall),
                  Text(
                    'generate_protocol'.tr(),
                    style: AppTextStyles.body.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSector(TeamLocal team) async {
    final sectorText = _sectorControllers[team.id]?.text.trim();

    if (sectorText == null || sectorText.isEmpty) {
      return; // Тихо выходим если пусто
    }

    final sector = int.tryParse(sectorText);
    if (sector == null || sector <= 0 || sector > widget.competition.sectorsCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('sector_invalid'.tr()),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Проверка на дубликат
    final teams = widget.teams;
    for (var t in teams) {
      if (t.id != team.id && t.sector == sector) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('sector_duplicate'.tr()),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    // Сохраняем
    try {
      await ref.read(teamProvider(widget.competition.id).notifier).saveDrawResults({
        team.id: DrawData(drawOrder: team.drawOrder, sector: sector),
      });
      // Автосохранение - не показываем уведомление
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_saving_draw'.tr()),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _completeDraw() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('complete_draw'.tr(), style: AppTextStyles.h3),
        content: Text(
          'complete_draw_confirmation'.tr(),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'cancel'.tr(),
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: Text('complete'.tr(), style: AppTextStyles.button),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Выходим из режима редактирования
      if (widget.onEditModeExit != null) {
        widget.onEditModeExit!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_completed'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _generateDrawProtocol(List<TeamLocal> teams) async {
    print('🔵 Генерация протокола жеребьёвки...');

    final allComplete = teams.every((t) => t.drawOrder != null && t.sector != null);

    if (!allComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('complete_draw_first'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          color: AppColors.surface,
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: AppDimensions.paddingMedium),
                Text('Генерация протокола...', style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final sortedTeams = List<TeamLocal>.from(teams)
        ..sort((a, b) => (a.drawOrder ?? 0).compareTo(b.drawOrder ?? 0));

      final drawData = sortedTeams.map((team) {
        return {
          'drawOrder': team.drawOrder,
          'teamName': team.name,
          'city': team.city,
          'sector': team.sector,
          'members': team.members.map((m) => m.fullName).toList(),
        };
      }).toList();

      final protocolData = {
        'competitionName': widget.competition.name,
        'venueFormatted': '${widget.competition.cityOrRegion}, ${widget.competition.lakeName}',
        'competitionDates': DateFormat('dd.MM.yyyy').format(widget.competition.startTime),
        'dateKey': 'competition_date_single',
        'drawData': drawData,
        'judges': widget.competition.judges.map((j) {
          return {
            'name': j.fullName,
            'rank': j.rank,
          };
        }).toList(),
      };

      final protocol = ProtocolLocal()
        ..competitionId = widget.competition.id.toString()
        ..type = 'draw'
        ..dataJson = jsonEncode(protocolData)
        ..createdAt = DateTime.now()
        ..isSynced = false;

      final isarService = IsarService();
      await isarService.saveProtocol(protocol);

      print('✅ Протокол жеребьёвки создан и сохранён в Isar');

      // 🔥 Синхронизация с Firebase
      if (widget.competition.serverId != null && widget.competition.serverId!.isNotEmpty) {
        final syncService = SyncService();
        await syncService.syncProtocolToFirebase(protocol, widget.competition.serverId!);
        print('📤 Протокол жеребьёвки синхронизирован с Firebase');
      } else {
        print('⚠️ Соревнование не имеет serverId - протокол не синхронизирован с Firebase');
      }

      await ref.read(protocolProvider.notifier).loadProtocols(widget.competition.id);

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_protocol_generated'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      print('❌ Ошибка: $e');

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_protocol_error'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}