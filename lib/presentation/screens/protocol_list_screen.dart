import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/protocol_local.dart';
import '../providers/protocol_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/services/isar_service.dart';
import 'protocol_view_screen.dart';
import '../../data/services/protocol_export_service.dart';
import 'dart:convert';

class ProtocolListScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const ProtocolListScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  ConsumerState<ProtocolListScreen> createState() => _ProtocolListScreenState();
}

class _ProtocolListScreenState extends ConsumerState<ProtocolListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isCasting;

  @override
  void initState() {
    super.initState();
    _isCasting = widget.competition.fishingType == 'casting';

    // Для кастинга: 3 вкладки (Попытки, Промежуточный, Финальный)
    // Для рыбалки: 5 вкладок (как было)
    _tabController = TabController(length: _isCasting ? 3 : 5, vsync: this);

    Future.microtask(() {
      _loadProtocols();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProtocols() async {
    await ref.read(protocolProvider.notifier).loadProtocols(widget.competition.id!);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(protocolProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('protocols_title'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _isCasting
              ? [
            Tab(text: 'protocols_attempts'.tr()), // Протоколы попыток
            Tab(text: 'protocols_intermediate'.tr()), // Промежуточный
            Tab(text: 'protocols_final'.tr()), // Финальный
          ]
              : [
            Tab(text: 'protocols_weighing'.tr()),
            Tab(text: 'protocols_intermediate'.tr()),
            Tab(text: 'protocols_big_fish'.tr()),
            Tab(text: 'protocols_summary'.tr()),
            Tab(text: 'protocols_final'.tr()),
          ],
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          controller: _tabController,
          children: _isCasting
              ? [
            _buildCastingAttemptsTab(state.protocols),
            _buildCastingIntermediateTab(state.protocols),
            _buildCastingFinalTab(state.protocols),
          ]
              : [
            _buildWeighingProtocolsTab(state.protocols),
            _buildIntermediateProtocolsTab(state.protocols),
            _buildBigFishProtocolsTab(state.protocols),
            _buildSummaryProtocolTab(state.protocols),
            _buildFinalProtocolTab(state.protocols),
          ],
        ),
      ),
    );
  }

  // ========== КАСТИНГ ПРОТОКОЛЫ ==========

  Widget _buildCastingAttemptsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'casting_attempt').toList();
    protocols.sort((a, b) => (a.weighingNumber ?? 0).compareTo(b.weighingNumber ?? 0));

    final attemptsCount = widget.competition.attemptsCount ?? 3;

    return Column(
      children: [
        // Кнопки для генерации протоколов попыток
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            children: List.generate(attemptsCount, (index) {
              final attemptNumber = index + 1;
              final existingProtocol = protocols.where((p) => p.weighingNumber == attemptNumber).firstOrNull;

              return Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: existingProtocol == null
                        ? () => _generateCastingAttemptProtocol(attemptNumber)
                        : null,
                    icon: Icon(
                      existingProtocol == null ? Icons.auto_fix_high : Icons.check_circle,
                      size: 18,
                    ),
                    label: Text(
                      existingProtocol == null
                          ? 'Сгенерировать протокол попытки №$attemptNumber'
                          : 'Протокол попытки №$attemptNumber создан',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: existingProtocol == null
                          ? AppColors.primary
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: protocols.isEmpty
              ? _buildEmptyState('protocols_no_casting'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                final protocol = protocols[index];
                return _buildProtocolCard(
                  protocol: protocol,
                  title: 'Протокол попытки №${protocol.weighingNumber}',
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.gps_fixed,
                  color: AppColors.primary,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCastingIntermediateTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'casting_intermediate').toList();
    protocols.sort((a, b) => (a.weighingNumber ?? 0).compareTo(b.weighingNumber ?? 0));

    final attemptsCount = widget.competition.attemptsCount ?? 3;

    return Column(
      children: [
        // Кнопки для генерации промежуточных протоколов
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            children: [
              // Промежуточный после 2-й попытки
              if (attemptsCount >= 2)
                Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: protocols.where((p) => p.weighingNumber == 2).isEmpty
                          ? () => _generateCastingIntermediateProtocol(2)
                          : null,
                      icon: Icon(
                        protocols.where((p) => p.weighingNumber == 2).isEmpty
                            ? Icons.auto_fix_high
                            : Icons.check_circle,
                        size: 18,
                      ),
                      label: Text(
                        protocols.where((p) => p.weighingNumber == 2).isEmpty
                            ? 'Промежуточный после 2 попыток'
                            : 'Промежуточный протокол (2) создан',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: protocols.where((p) => p.weighingNumber == 2).isEmpty
                            ? Colors.orange
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                      ),
                    ),
                  ),
                ),
              // Промежуточный после 3-й попытки
              if (attemptsCount >= 3)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: protocols.where((p) => p.weighingNumber == 3).isEmpty
                        ? () => _generateCastingIntermediateProtocol(3)
                        : null,
                    icon: Icon(
                      protocols.where((p) => p.weighingNumber == 3).isEmpty
                          ? Icons.auto_fix_high
                          : Icons.check_circle,
                      size: 18,
                    ),
                    label: Text(
                      protocols.where((p) => p.weighingNumber == 3).isEmpty
                          ? 'Промежуточный после 3 попыток'
                          : 'Промежуточный протокол (3) создан',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: protocols.where((p) => p.weighingNumber == 3).isEmpty
                          ? Colors.orange
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: protocols.isEmpty
              ? _buildEmptyState('protocols_no_intermediate'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                final protocol = protocols[index];
                return _buildProtocolCard(
                  protocol: protocol,
                  title: 'Промежуточный после ${protocol.weighingNumber} попыток',
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.leaderboard,
                  color: Colors.orange,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCastingFinalTab(List<ProtocolLocal> allProtocols) {
    final protocol = allProtocols.where((p) => p.type == 'casting_final').firstOrNull;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: protocol == null ? () => _generateCastingFinalProtocol() : null,
              icon: Icon(
                protocol == null ? Icons.auto_fix_high : Icons.check_circle,
                size: 18,
              ),
              label: Text(
                protocol == null
                    ? 'protocols_generate_final'.tr()
                    : 'Финальный протокол создан',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: protocol == null ? Colors.red : Colors.grey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              ),
            ),
          ),
        ),
        Expanded(
          child: protocol == null
              ? _buildEmptyState('protocols_no_final'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              children: [
                _buildProtocolCard(
                  protocol: protocol,
                  title: 'protocols_final_title'.tr(),
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.emoji_events,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ========== РЫБАЛКА ПРОТОКОЛЫ ==========

  Widget _buildWeighingProtocolsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'weighing').toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAllWeighingProtocols(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: Text('protocols_generate_all_weighing'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              ),
            ),
          ),
        ),
        Expanded(
          child: protocols.isEmpty
              ? _buildEmptyState('protocols_no_weighing'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                final protocol = protocols[index];
                return _buildProtocolCard(
                  protocol: protocol,
                  title: 'protocols_weighing_title'.tr(namedArgs: {
                    'day': protocol.dayNumber.toString(),
                    'number': protocol.weighingNumber.toString(),
                  }),
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.scale,
                  color: AppColors.primary,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntermediateProtocolsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'intermediate').toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAllIntermediateProtocols(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: Text('protocols_generate_all_intermediate'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              ),
            ),
          ),
        ),
        Expanded(
          child: protocols.isEmpty
              ? _buildEmptyState('protocols_no_intermediate'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                final protocol = protocols[index];
                return _buildProtocolCard(
                  protocol: protocol,
                  title: 'protocols_intermediate_title'.tr(namedArgs: {
                    'number': protocol.weighingNumber.toString(),
                  }),
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.leaderboard,
                  color: Colors.orange,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBigFishProtocolsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'big_fish').toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAllBigFishProtocols(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: Text('protocols_generate_all_big_fish'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              ),
            ),
          ),
        ),
        Expanded(
          child: protocols.isEmpty
              ? _buildEmptyState('protocols_no_big_fish'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: protocols.length,
              itemBuilder: (context, index) {
                final protocol = protocols[index];
                return _buildProtocolCard(
                  protocol: protocol,
                  title: 'protocols_big_fish_title'.tr(namedArgs: {
                    'day': protocol.bigFishDay.toString(),
                  }),
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryProtocolTab(List<ProtocolLocal> allProtocols) {
    final protocol = allProtocols.where((p) => p.type == 'summary').firstOrNull;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateSummaryProtocol(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: Text('protocols_generate_summary'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              ),
            ),
          ),
        ),
        Expanded(
          child: protocol == null
              ? _buildEmptyState('protocols_no_summary'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              children: [
                _buildProtocolCard(
                  protocol: protocol,
                  title: 'protocols_summary_title'.tr(),
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.table_chart,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalProtocolTab(List<ProtocolLocal> allProtocols) {
    final protocol = allProtocols.where((p) => p.type == 'final').firstOrNull;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateFinalProtocol(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: Text('protocols_generate_final'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
              ),
            ),
          ),
        ),
        Expanded(
          child: protocol == null
              ? _buildEmptyState('protocols_no_final'.tr())
              : RefreshIndicator(
            onRefresh: _loadProtocols,
            child: ListView(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              children: [
                _buildProtocolCard(
                  protocol: protocol,
                  title: 'protocols_final_title'.tr(),
                  subtitle: _formatDateTime(protocol.createdAt),
                  icon: Icons.emoji_events,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ========== ОБЩИЕ МЕТОДЫ ==========

  Widget _buildProtocolCard({
    required ProtocolLocal protocol,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.primary),
              onPressed: () => _shareProtocol(protocol),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteProtocol(protocol),
            ),
          ],
        ),
        onTap: () => _viewProtocol(protocol),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ========== ГЕНЕРАЦИЯ ПРОТОКОЛОВ: КАСТИНГ ==========

  Future<void> _generateCastingAttemptProtocol(int attemptNumber) async {
    _showLoadingDialog('Генерация протокола попытки №$attemptNumber...');

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateCastingAttemptProtocol(widget.competition.id!, attemptNumber);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        if (mounted) setState(() {});
        _showSnackBar('Протокол попытки №$attemptNumber создан!');
      } else {
        _showSnackBar('Недостаточно данных для генерации', isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: ${e.toString()}', isError: true);
    }
  }

  Future<void> _generateCastingIntermediateProtocol(int upToAttempt) async {
    _showLoadingDialog('Генерация промежуточного протокола...');

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateCastingIntermediateProtocol(widget.competition.id!, upToAttempt);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        if (mounted) setState(() {});
        _showSnackBar('Промежуточный протокол создан!');
      } else {
        _showSnackBar('Недостаточно данных для генерации', isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: ${e.toString()}', isError: true);
    }
  }

  Future<void> _generateCastingFinalProtocol() async {
    _showLoadingDialog('Генерация финального протокола...');

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateCastingFinalProtocol(widget.competition.id!);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        if (mounted) setState(() {});
        _showSnackBar('Финальный протокол создан!');
      } else {
        _showSnackBar('Недостаточно данных для генерации', isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: ${e.toString()}', isError: true);
    }
  }

  // ========== ГЕНЕРАЦИЯ ПРОТОКОЛОВ: РЫБАЛКА ==========

  Future<void> _generateAllWeighingProtocols() async {
    _showLoadingDialog('protocols_generating_weighing'.tr());

    try {
      final isarService = IsarService();
      final weighings = await isarService.getWeighingsByCompetition(widget.competition.id!);

      if (weighings.isEmpty) {
        Navigator.pop(context);
        _showSnackBar('protocols_no_weighings_to_generate'.tr());
        return;
      }

      int generated = 0;
      for (var weighing in weighings) {
        final protocol = await ref.read(protocolProvider.notifier)
            .generateWeighingProtocol(widget.competition.id!, weighing.id!);
        if (protocol != null) generated++;
      }

      Navigator.pop(context);
      await _loadProtocols();
      _showSnackBar('protocols_generated_weighing'.tr(namedArgs: {'count': generated.toString()}));
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('protocols_generation_error'.tr(namedArgs: {'error': e.toString()}), isError: true);
    }
  }

  Future<void> _generateAllIntermediateProtocols() async {
    _showLoadingDialog('protocols_generating_intermediate'.tr());

    try {
      final isarService = IsarService();
      final weighings = await isarService.getWeighingsByCompetition(widget.competition.id!);

      if (weighings.isEmpty) {
        Navigator.pop(context);
        _showSnackBar('protocols_no_weighings_to_generate'.tr());
        return;
      }

      final maxWeighingNumber = weighings.map((w) => w.weighingNumber).reduce((a, b) => a > b ? a : b);

      int generated = 0;
      for (int i = 1; i <= maxWeighingNumber; i++) {
        final protocol = await ref.read(protocolProvider.notifier)
            .generateIntermediateProtocol(widget.competition.id!, i);
        if (protocol != null) generated++;
      }

      Navigator.pop(context);
      await _loadProtocols();
      _showSnackBar('protocols_generated_intermediate'.tr(namedArgs: {'count': generated.toString()}));
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('protocols_generation_error'.tr(namedArgs: {'error': e.toString()}), isError: true);
    }
  }

  Future<void> _generateAllBigFishProtocols() async {
    _showLoadingDialog('protocols_generating_big_fish'.tr());

    try {
      final daysCount = widget.competition.durationDays;

      int generated = 0;
      for (int day = 1; day <= daysCount; day++) {
        final protocol = await ref.read(protocolProvider.notifier)
            .generateBigFishProtocol(widget.competition.id!, day);
        if (protocol != null) generated++;
      }

      Navigator.pop(context);
      await _loadProtocols();
      _showSnackBar('protocols_generated_big_fish'.tr(namedArgs: {'count': generated.toString()}));
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('protocols_generation_error'.tr(namedArgs: {'error': e.toString()}), isError: true);
    }
  }

  Future<void> _generateSummaryProtocol() async {
    _showLoadingDialog('protocols_generating_summary'.tr());

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateSummaryProtocol(widget.competition.id!);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        _showSnackBar('protocols_generated_summary_success'.tr());
      } else {
        _showSnackBar('protocols_insufficient_data'.tr(), isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('protocols_generation_error'.tr(namedArgs: {'error': e.toString()}), isError: true);
    }
  }

  Future<void> _generateFinalProtocol() async {
    _showLoadingDialog('protocols_generating_final'.tr());

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateFinalProtocol(widget.competition.id!);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        _showSnackBar('protocols_generated_final_success'.tr());
      } else {
        _showSnackBar('protocols_insufficient_data'.tr(), isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('protocols_generation_error'.tr(namedArgs: {'error': e.toString()}), isError: true);
    }
  }

  // ========== ДЕЙСТВИЯ С ПРОТОКОЛАМИ ==========

  void _viewProtocol(ProtocolLocal protocol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProtocolViewScreen(protocol: protocol),
      ),
    );
  }

  Future<void> _shareProtocol(ProtocolLocal protocol) async {
    try {
      _showSnackBar('protocols_export_start'.tr());

      // Показываем диалог выбора формата
      final format = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('export_format'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.picture_as_pdf, color: AppColors.error),
                title: Text('PDF'),
                onTap: () => Navigator.pop(context, 'pdf'),
              ),
              ListTile(
                leading: Icon(Icons.table_chart, color: AppColors.success),
                title: Text('Excel'),
                onTap: () => Navigator.pop(context, 'excel'),
              ),
            ],
          ),
        ),
      );

      if (format == null) return;

      // Парсим JSON данные протокола
      final data = Map<String, dynamic>.from(jsonDecode(protocol.dataJson));

      if (data.isEmpty) {
        _showSnackBar('protocols_export_error'.tr());
        return;
      }

      // Экспортируем
      final exportService = ProtocolExportService();

      if (format == 'pdf') {
        await exportService.exportToPdf(protocol, data);
      } else if (format == 'excel') {
        await exportService.exportToExcel(protocol, data);
      }

      _showSnackBar('protocols_export_success'.tr());
    } catch (e) {
      _showSnackBar('protocols_export_error'.tr());
      print('Export error: $e');
    }
  }

  Future<void> _deleteProtocol(ProtocolLocal protocol) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('protocols_delete_confirm_title'.tr()),
        content: Text('protocols_delete_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common_cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('common_delete'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(protocolProvider.notifier).deleteProtocol(protocol.id);
      _showSnackBar('protocols_deleted'.tr());
    }
  }

  // ========== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ==========

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: AppDimensions.paddingMedium),
                Text(message, style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }
}
