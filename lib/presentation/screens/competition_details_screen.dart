import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../providers/team_provider.dart';
import 'add_team_screen.dart';
import 'draw_screen.dart';
import 'weighing_list_screen.dart';
import 'casting_session_list_screen.dart';
import 'protocol_list_screen.dart';
import 'edit_competition_screen.dart';

class CompetitionDetailsScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;

  const CompetitionDetailsScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  ConsumerState<CompetitionDetailsScreen> createState() => _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends ConsumerState<CompetitionDetailsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamProvider(widget.competition.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.competition.name,
          style: AppTextStyles.h2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: () => _navigateToEditCompetition(context),
            tooltip: 'edit'.tr(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _selectedTab == 0
                ? _buildInfoTab()
                : _buildTeamsTab(teamsAsync),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 1
          ? FloatingActionButton.extended(
        onPressed: () => _navigateToAddTeam(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.text),
        label: Text(
            widget.competition.fishingType == 'casting'
                ? 'add_participant'.tr()
                : 'add_team'.tr(),
            style: AppTextStyles.button
        ),
      )
          : null,
      bottomNavigationBar: SafeArea(
        child: _buildActionButtons(),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              index: 0,
              icon: Icons.info_outline,
              label: 'competition_info'.tr(),
            ),
          ),
          Expanded(
            child: _buildTab(
              index: 1,
              icon: Icons.groups,
              label: 'teams_list'.tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTab == index;

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(width: AppDimensions.paddingSmall),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          SizedBox(height: AppDimensions.paddingMedium),
          _buildJudgesCard(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final isCasting = widget.competition.fishingType == 'casting';

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('competition_info'.tr(), style: AppTextStyles.h3),
            SizedBox(height: AppDimensions.paddingMedium),
            _buildInfoRow(Icons.location_on, 'city'.tr(),
                widget.competition.cityOrRegion),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow(
              Icons.water,
              isCasting ? 'venue'.tr() : 'lake'.tr(),
              widget.competition.lakeName,
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow(
              Icons.calendar_today,
              'start_date'.tr(),
              DateFormat('dd.MM.yyyy HH:mm').format(
                  widget.competition.startTime),
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow(
              Icons.access_time,
              'duration'.tr(),
              '${widget.competition.durationHours} ${'hours'.tr()}',
            ),

            if (!isCasting) ...[
              SizedBox(height: AppDimensions.paddingSmall),
              _buildInfoRow(
                Icons.grid_on,
                'sectors'.tr(),
                '${widget.competition.sectorsCount}',
              ),
            ],

            if (isCasting && widget.competition.attemptsCount != null) ...[
              SizedBox(height: AppDimensions.paddingSmall),
              _buildInfoRow(
                Icons.repeat,
                'attempts_count'.tr(),
                '${widget.competition.attemptsCount}',
              ),
            ],

            if (isCasting && widget.competition.commonLine != null) ...[
              SizedBox(height: AppDimensions.paddingSmall),
              _buildInfoRow(
                Icons.line_weight,
                'common_line'.tr(),
                widget.competition.commonLine!,
              ),
            ],

            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow(
              Icons.calculate,
              'rules'.tr(),
              _getScoringRulesText(widget.competition.scoringMethod),
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow(
              Icons.person,
              'organizer'.tr(),
              widget.competition.organizerName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJudgesCard() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, size: 20, color: AppColors.textPrimary),
                SizedBox(width: AppDimensions.paddingSmall),
                Text('judges'.tr(), style: AppTextStyles.h3),
              ],
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            ...widget.competition.judges.map((judge) =>
                Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingSmall),
                      Expanded(
                        child: Text(
                          '${judge.fullName} — ${judge.rank.tr()}',
                          style: AppTextStyles.body,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: AppDimensions.paddingSmall),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary),
              children: [
                TextSpan(text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value,
                    style: TextStyle(color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsTab(AsyncValue<List<TeamLocal>> teamsAsync) {
    return teamsAsync.when(
      data: (teams) {
        if (teams.isEmpty) {
          return _buildEmptyTeamsState();
        }
        return _buildTeamsList(teams);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(
            child: Text(
              'error_loading_teams'.tr(),
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          ),
    );
  }

  Widget _buildEmptyTeamsState() {
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
            'no_teams'.tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'add_first_team'.tr(),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsList(List<TeamLocal> teams) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(teamProvider(widget.competition.id).notifier)
            .loadTeams();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return _buildTeamCard(team);
        },
      ),
    );
  }

  Widget _buildTeamCard(TeamLocal team) {
    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: InkWell(
        onTap: () => _navigateToEditTeam(context, team),
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
                      team.name,
                      style: AppTextStyles.h3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (team.sector != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall),
                      ),
                      child: Text(
                        '${'sector'.tr()} ${team.sector}',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingSmall),
              _buildTeamInfoRow(Icons.location_city, team.city),
              if (team.club != null && team.club!.isNotEmpty) ...[
                SizedBox(height: 4),
                _buildTeamInfoRow(Icons.shield, team.club!),
              ],
              SizedBox(height: 4),
              _buildTeamInfoRow(
                Icons.people,
                '${team.members.length} ${team.members.length == 1 ? 'member'
                    .tr() : 'members'.tr()}',
              ),
              if (team.members.isNotEmpty) ...[
                SizedBox(height: AppDimensions.paddingSmall),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: team.members.map((member) {
                    return Chip(
                      avatar: member.isCaptain
                          ? Icon(
                          Icons.star, size: 16, color: AppColors.upcoming)
                          : null,
                      label: Text(
                        member.fullName,
                        style: AppTextStyles.caption,
                      ),
                      backgroundColor: AppColors.surfaceMedium,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfoRow(IconData icon, String text) {
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

  Widget _buildActionButtons() {
    final isCasting = widget.competition.fishingType == 'casting';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCasting) ...[
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DrawScreen(competition: widget.competition),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  side: BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shuffle, size: 24),
                    SizedBox(width: 12),
                    Text('draw'.tr(), style: AppTextStyles.bodyBold),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
          ],

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    isCasting
                        ? CastingSessionListScreen(
                        competition: widget.competition)
                        : WeighingListScreen(competition: widget.competition),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                side: BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isCasting ? Icons.gps_fixed : Icons.scale, size: 24),
                  SizedBox(width: 12),
                  Text(
                    isCasting ? 'casting_results'.tr() : 'weighing_title'.tr(),
                    style: AppTextStyles.bodyBold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProtocolListScreen(competition: widget.competition),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'protocols_title'.tr(),
                    style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScoringRulesText(String rules) {
    switch (rules) {
      case 'total_weight':
        return 'total_weight'.tr();
      case 'top_3':
        return 'top_3_fish'.tr();
      case 'top_5':
        return 'top_5_fish'.tr();
      case 'best_distance':
        return 'scoring_best_distance'.tr();
      case 'average_distance':
        return 'scoring_average_distance'.tr();
      default:
        return rules;
    }
  }

  Future<void> _navigateToAddTeam(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTeamScreen(competition: widget.competition),
      ),
    );
  }

  Future<void> _navigateToEditTeam(BuildContext context, TeamLocal team) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddTeamScreen(
              competition: widget.competition,
              team: team,
            ),
      ),
    );
  }

  Future<void> _navigateToEditCompetition(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCompetitionScreen(competition: widget.competition),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }
}