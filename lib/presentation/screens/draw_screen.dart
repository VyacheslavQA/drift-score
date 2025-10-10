import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../providers/team_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamProvider(widget.competition.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('draw'.tr(), style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: teamsAsync.when(
        data: (teams) {
          if (teams.isEmpty) {
            return _buildEmptyState();
          }

          // Определяем текущий этап
          final hasAllOrders = teams.every((t) => t.drawOrder != null);

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

  @override
  void initState() {
    super.initState();
    for (var team in widget.teams) {
      _orderControllers[team.id] = TextEditingController(
        text: team.drawOrder?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _orderControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildStepIndicator(),
          _buildInfoCard(),
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

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildStepBadge(1, true),
          Expanded(
            child: Container(
              height: 2,
              color: AppColors.divider,
              margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
            ),
          ),
          _buildStepBadge(2, false),
        ],
      ),
    );
  }

  Widget _buildStepBadge(int step, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceMedium,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: AppTextStyles.h3.copyWith(
            color: isActive ? AppColors.text : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      margin: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 24),
              SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: Text(
                  'draw_step_1_title'.tr(),
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'draw_step_1_info'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
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
            ),

            SizedBox(width: AppDimensions.paddingSmall),

            // Кнопка сохранения
            IconButton(
              icon: Icon(Icons.save, color: AppColors.primary),
              onPressed: () => _saveOrder(team),
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
        child: ElevatedButton.icon(
          onPressed: allHaveOrders ? widget.onComplete : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.surfaceMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          icon: Icon(Icons.arrow_forward, color: AppColors.text),
          label: Text('next_step'.tr(), style: AppTextStyles.button),
        ),
      ),
    );
  }

  Future<void> _saveOrder(TeamLocal team) async {
    final orderText = _orderControllers[team.id]?.text.trim();

    if (orderText == null || orderText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('enter_draw_order'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final order = int.tryParse(orderText);
    if (order == null || order <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('invalid_number'.tr()),
          backgroundColor: AppColors.error,
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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_order_saved'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_saving_draw'.tr()),
          backgroundColor: AppColors.error,
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

  const _DrawSectorStep({
    required this.competition,
    required this.teams,
  });

  @override
  ConsumerState<_DrawSectorStep> createState() => _DrawSectorStepState();
}

class _DrawSectorStepState extends ConsumerState<_DrawSectorStep> {
  final Map<int, TextEditingController> _sectorControllers = {};

  @override
  void initState() {
    super.initState();
    for (var team in widget.teams) {
      _sectorControllers[team.id] = TextEditingController(
        text: team.sector?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _sectorControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Сортируем команды по очередности
    final sortedTeams = List<TeamLocal>.from(widget.teams)
      ..sort((a, b) => (a.drawOrder ?? 0).compareTo(b.drawOrder ?? 0));

    return SafeArea(
      child: Column(
        children: [
          _buildStepIndicator(),
          _buildInfoCard(),
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

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildStepBadge(1, false),
          Expanded(
            child: Container(
              height: 2,
              color: AppColors.primary,
              margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
            ),
          ),
          _buildStepBadge(2, true),
        ],
      ),
    );
  }

  Widget _buildStepBadge(int step, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.success,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: step == 1 && !isActive
            ? Icon(Icons.check, color: AppColors.text, size: 20)
            : Text(
          '$step',
          style: AppTextStyles.h3.copyWith(color: AppColors.text),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      margin: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 24),
              SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: Text(
                  'draw_step_2_title'.tr(),
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'draw_step_2_info'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasSector
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Center(
                child: hasSector
                    ? Icon(Icons.check, color: AppColors.success, size: 20)
                    : Text(
                  '${team.drawOrder}',
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

            // Поле ввода сектора
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: _sectorControllers[team.id],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'С',
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
            ),

            SizedBox(width: AppDimensions.paddingSmall),

            // Кнопка сохранения
            IconButton(
              icon: Icon(Icons.save, color: AppColors.primary),
              onPressed: () => _saveSector(team),
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
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: allHaveSectors ? _completeDraw : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            disabledBackgroundColor: AppColors.surfaceMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          icon: Icon(Icons.check, color: AppColors.text),
          label: Text('complete_draw'.tr(), style: AppTextStyles.button),
        ),
      ),
    );
  }

  Future<void> _saveSector(TeamLocal team) async {
    final sectorText = _sectorControllers[team.id]?.text.trim();

    if (sectorText == null || sectorText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('enter_sector'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final sector = int.tryParse(sectorText);
    if (sector == null || sector <= 0 || sector > widget.competition.sectorsCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('sector_invalid'.tr()),
          backgroundColor: AppColors.error,
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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('sector_saved'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_saving_draw'.tr()),
          backgroundColor: AppColors.error,
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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('draw_completed'.tr()),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}