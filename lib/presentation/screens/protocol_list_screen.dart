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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // ✅ Используем Future.microtask для загрузки
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
          tabs: [
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
          children: [
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

  // ============================================================
  // 1. ПРОТОКОЛЫ ВЗВЕШИВАНИЯ
  // ============================================================

  Widget _buildWeighingProtocolsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'weighing').toList();

    return Column(
      children: [
        // Кнопка генерации
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAllWeighingProtocols(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Сгенерировать все протоколы взвешивания'),
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

  // ============================================================
  // 2. ПРОМЕЖУТОЧНЫЕ ПРОТОКОЛЫ
  // ============================================================

  Widget _buildIntermediateProtocolsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'intermediate').toList();

    return Column(
      children: [
        // Кнопка генерации
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAllIntermediateProtocols(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Сгенерировать все промежуточные протоколы'),
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

  // ============================================================
  // 3. BIG FISH ПРОТОКОЛЫ
  // ============================================================

  Widget _buildBigFishProtocolsTab(List<ProtocolLocal> allProtocols) {
    final protocols = allProtocols.where((p) => p.type == 'big_fish').toList();

    return Column(
      children: [
        // Кнопка генерации
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateAllBigFishProtocols(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Сгенерировать все Big Fish протоколы'),
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

  // ============================================================
  // 4. СВОДНЫЙ ПРОТОКОЛ
  // ============================================================

  Widget _buildSummaryProtocolTab(List<ProtocolLocal> allProtocols) {
    final protocol = allProtocols.where((p) => p.type == 'summary').firstOrNull;

    return Column(
      children: [
        // Кнопка генерации
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateSummaryProtocol(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Сгенерировать сводный протокол'),
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

  // ============================================================
  // 5. ФИНАЛЬНЫЙ ПРОТОКОЛ
  // ============================================================

  Widget _buildFinalProtocolTab(List<ProtocolLocal> allProtocols) {
    final protocol = allProtocols.where((p) => p.type == 'final').firstOrNull;

    return Column(
      children: [
        // Кнопка генерации
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generateFinalProtocol(),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: const Text('Сгенерировать финальный протокол'),
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

  // ============================================================
  // UI HELPERS
  // ============================================================

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

  // ============================================================
  // ACTIONS - ГЕНЕРАЦИЯ ПРОТОКОЛОВ
  // ============================================================

  Future<void> _generateAllWeighingProtocols() async {
    _showLoadingDialog('Генерация протоколов взвешивания...');

    try {
      final isarService = IsarService();
      final weighings = await isarService.getWeighingsByCompetition(widget.competition.id!);

      if (weighings.isEmpty) {
        Navigator.pop(context);
        _showSnackBar('Нет взвешиваний для генерации протоколов');
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
      _showSnackBar('Сгенерировано $generated протоколов взвешивания');
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: $e', isError: true);
    }
  }

  Future<void> _generateAllIntermediateProtocols() async {
    _showLoadingDialog('Генерация промежуточных протоколов...');

    try {
      final isarService = IsarService();
      final weighings = await isarService.getWeighingsByCompetition(widget.competition.id!);

      if (weighings.isEmpty) {
        Navigator.pop(context);
        _showSnackBar('Нет взвешиваний для генерации протоколов');
        return;
      }

      // Получаем максимальный номер взвешивания
      final maxWeighingNumber = weighings.map((w) => w.weighingNumber).reduce((a, b) => a > b ? a : b);

      int generated = 0;
      for (int i = 1; i <= maxWeighingNumber; i++) {
        final protocol = await ref.read(protocolProvider.notifier)
            .generateIntermediateProtocol(widget.competition.id!, i);
        if (protocol != null) generated++;
      }

      Navigator.pop(context);
      await _loadProtocols();
      _showSnackBar('Сгенерировано $generated промежуточных протоколов');
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: $e', isError: true);
    }
  }

  Future<void> _generateAllBigFishProtocols() async {
    _showLoadingDialog('Генерация Big Fish протоколов...');

    try {
      // Рассчитываем количество дней соревнования
      final daysCount = widget.competition.durationDays;

      int generated = 0;
      for (int day = 1; day <= daysCount; day++) {
        final protocol = await ref.read(protocolProvider.notifier)
            .generateBigFishProtocol(widget.competition.id!, day);
        if (protocol != null) generated++;
      }

      Navigator.pop(context);
      await _loadProtocols();
      _showSnackBar('Сгенерировано $generated Big Fish протоколов');
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: $e', isError: true);
    }
  }

  Future<void> _generateSummaryProtocol() async {
    _showLoadingDialog('Генерация сводного протокола...');

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateSummaryProtocol(widget.competition.id!);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        _showSnackBar('Сводный протокол сгенерирован');
      } else {
        _showSnackBar('Недостаточно данных для генерации', isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: $e', isError: true);
    }
  }

  Future<void> _generateFinalProtocol() async {
    _showLoadingDialog('Генерация финального протокола...');

    try {
      final protocol = await ref.read(protocolProvider.notifier)
          .generateFinalProtocol(widget.competition.id!);

      Navigator.pop(context);

      if (protocol != null) {
        await _loadProtocols();
        _showSnackBar('Финальный протокол сгенерирован');
      } else {
        _showSnackBar('Недостаточно данных для генерации', isError: true);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ошибка генерации: $e', isError: true);
    }
  }

  // ============================================================
  // ACTIONS - ПРОЧЕЕ
  // ============================================================

  void _viewProtocol(ProtocolLocal protocol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProtocolViewScreen(protocol: protocol),
      ),
    );
  }

  void _shareProtocol(ProtocolLocal protocol) {
    _showSnackBar('Экспорт протокола: ${protocol.type}');
    // TODO: Реализовать экспорт в PDF/Excel/Word
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

  // ============================================================
  // UTILS
  // ============================================================

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