import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/remote/competition_remote.dart';
import '../../data/models/remote/protocol_remote.dart';
import '../providers/public_competitions_provider.dart';
import '../widgets/protocol_list_item_widget.dart';

class CompetitionProtocolsScreen extends ConsumerStatefulWidget {
  final CompetitionRemote competition;

  const CompetitionProtocolsScreen({
    super.key,
    required this.competition,
  });

  @override
  ConsumerState<CompetitionProtocolsScreen> createState() => _CompetitionProtocolsScreenState();
}

class _CompetitionProtocolsScreenState extends ConsumerState<CompetitionProtocolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Типы протоколов для рыбалки
  final List<String> _fishingProtocolTypes = [
    'draw', // Жеребьёвка
    'weighing', // Взвешивания
    'intermediate', // Промежуточные
    'big_fish', // Big Fish
    'summary', // Сводный
    'final', // Финальный
  ];

  // Типы протоколов для кастинга
  final List<String> _castingProtocolTypes = [
    'draw', // Жеребьёвка
    'casting_attempt', // Попытки
    'casting_intermediate', // Промежуточные
    'casting_final', // Финальный
  ];

  List<String> get _protocolTypes {
    return widget.competition.fishingType == 'casting'
        ? _castingProtocolTypes
        : _fishingProtocolTypes;
  }

  String _getTabName(String type) {
    switch (type) {
      case 'draw':
        return 'Жеребьёвка';
      case 'weighing':
        return 'Взвешивания';
      case 'intermediate':
        return 'Промежуточные';
      case 'big_fish':
        return 'Big Fish';
      case 'summary':
        return 'Сводный';
      case 'final':
        return 'Финальный';
      case 'casting_attempt':
        return 'Попытки';
      case 'casting_intermediate':
        return 'Промежуточные';
      case 'casting_final':
        return 'Финальный';
      default:
        return type;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _protocolTypes.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.competition.name,
              style: AppTextStyles.h3.copyWith(fontSize: 16),
            ),
            Text(
              _getDateRange(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: AppTextStyles.body,
          tabs: _protocolTypes.map((type) {
            return Tab(text: _getTabName(type));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _protocolTypes.map((type) {
          return _buildProtocolsList(type);
        }).toList(),
      ),
    );
  }

  Widget _buildProtocolsList(String type) {
    final filter = ProtocolFilter(
      competitionId: widget.competition.id,
      type: type,
    );

    final protocolsAsync = ref.watch(protocolsByTypeProvider(filter));

    return protocolsAsync.when(
      data: (protocols) {
        if (protocols.isEmpty) {
          return _buildEmptyState(type);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(protocolsByTypeProvider(filter));
          },
          child: ListView.builder(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            itemCount: protocols.length,
            itemBuilder: (context, index) {
              return ProtocolListItemWidget(
                protocol: protocols[index],
                competition: widget.competition,
              );
            },
          ),
        );
      },
      loading: () =>
          Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
      error: (error, stack) =>
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  'Ошибка загрузки',
                  style: AppTextStyles.h3,
                ),
                SizedBox(height: AppDimensions.paddingSmall),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLarge),
                  child: Text(
                    error.toString(),
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingLarge),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(protocolsByTypeProvider(filter));
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Повторить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Text(
            'Протоколов пока нет',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXLarge),
            child: Text(
              'Протоколы появятся здесь после их создания организатором',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getDateRange() {
    final startDate = DateFormat('dd.MM.yyyy').format(
        widget.competition.startTime);
    final finishDate = DateFormat('dd.MM.yyyy').format(
        widget.competition.finishTime);

    if (startDate == finishDate) {
      return startDate;
    }
    return '$startDate - $finishDate';
  }
}