import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/local/competition_local.dart';
import '../../data/models/local/team_local.dart';
import '../providers/team_provider.dart';

class AddTeamScreen extends ConsumerStatefulWidget {
  final CompetitionLocal competition;
  final TeamLocal? team; // Для редактирования

  const AddTeamScreen({
    Key? key,
    required this.competition,
    this.team,
  }) : super(key: key);

  @override
  ConsumerState<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends ConsumerState<AddTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _clubController = TextEditingController();

  List<_MemberData> _members = [];

  bool get _isEditing => widget.team != null;
  bool get _isCasting => widget.competition.fishingType == 'casting';

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadTeamData();
    }
  }

  void _loadTeamData() {
    final team = widget.team!;
    _nameController.text = team.name;
    _cityController.text = team.city;
    _clubController.text = team.club ?? '';

    _members = team.members.map((member) => _MemberData(
      nameController: TextEditingController(text: member.fullName),
      isCaptain: member.isCaptain,
      rank: member.rank,
      rodController: TextEditingController(text: member.rod ?? ''), // ✅ Для кастинга
      lineController: TextEditingController(text: member.line ?? ''), // ✅ Для кастинга
    )).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _clubController.dispose();
    for (var member in _members) {
      member.nameController.dispose();
      member.rodController.dispose();
      member.lineController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'edit_team'.tr() : (_isCasting ? 'add_participants'.tr() : 'add_team'.tr()),
          style: AppTextStyles.h2,
        ),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.error),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            children: [
              // Для кастинга не нужна информация о команде
              if (!_isCasting) ...[
                _buildTeamInfoSection(),
                SizedBox(height: AppDimensions.paddingLarge),
              ],

              // Для кастинга показываем общую леску, если указана
              if (_isCasting && widget.competition.commonLine != null) ...[
                _buildCommonLineInfo(),
                SizedBox(height: AppDimensions.paddingLarge),
              ],

              _buildMembersSection(),
              SizedBox(height: AppDimensions.paddingXLarge),
              _buildSaveButton(),
              SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }

  // Информация об общей леске (для кастинга)
  Widget _buildCommonLineInfo() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'common_line_for_all'.tr(),
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 4),
                Text(
                  widget.competition.commonLine!,
                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfoSection() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('team_info'.tr(), style: AppTextStyles.h3),
            SizedBox(height: AppDimensions.paddingMedium),

            // Название команды
            TextFormField(
              controller: _nameController,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'team_name'.tr(),
                labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'field_required'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingMedium),

            // Город
            TextFormField(
              controller: _cityController,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'city'.tr(),
                labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'field_required'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingMedium),

            // Клуб (необязательно)
            TextFormField(
              controller: _clubController,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'club_optional'.tr(),
                labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
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
    );
  }

  Widget _buildMembersSection() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isCasting ? 'participants'.tr() : 'members'.tr(), style: AppTextStyles.h3),
                TextButton.icon(
                  onPressed: _addMember,
                  icon: Icon(Icons.add, size: 18),
                  label: Text(_isCasting ? 'add_participant'.tr() : 'add_member'.tr()),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),

            if (_members.isEmpty) ...[
              SizedBox(height: AppDimensions.paddingMedium),
              Center(
                child: Text(
                  _isCasting ? 'no_participants_yet'.tr() : 'no_members_yet'.tr(),
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ] else ...[
              SizedBox(height: AppDimensions.paddingMedium),
              ..._members.asMap().entries.map((entry) {
                final index = entry.key;
                final member = entry.value;
                return _isCasting
                    ? _buildCastingParticipantCard(member, index)
                    : _buildMemberCard(member, index);
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  // Карточка участника для кастинга
  Widget _buildCastingParticipantCard(_MemberData member, int index) {
    final hasCommonLine = widget.competition.commonLine != null;

    return Card(
      color: AppColors.background,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'participant'.tr()} ${index + 1}',
                    style: AppTextStyles.bodyBold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.error, size: 20),
                  onPressed: () => _removeMember(index),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingSmall),

            // ФИО
            TextFormField(
              controller: member.nameController,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'participant_full_name'.tr(),
                labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'field_required'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingSmall),

            // Удилище
            TextFormField(
              controller: member.rodController,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'rod'.tr(),
                hintText: 'rod_hint'.tr(), // Например: "Shimano Aero X5"
                labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'field_required'.tr();
                }
                return null;
              },
            ),

            // Леска (только если нет общей)
            if (!hasCommonLine) ...[
              SizedBox(height: AppDimensions.paddingSmall),
              TextFormField(
                controller: member.lineController,
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'line'.tr(),
                  hintText: 'line_hint'.tr(), // Например: "0.28 мм плетёная"
                  labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'field_required'.tr();
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Карточка участника для обычной рыбалки
  Widget _buildMemberCard(_MemberData member, int index) {
    return Card(
      color: AppColors.background,
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'member'.tr()} ${index + 1}',
                    style: AppTextStyles.bodyBold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.error, size: 20),
                  onPressed: () => _removeMember(index),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingSmall),

            // ФИО
            TextFormField(
              controller: member.nameController,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'member_name'.tr(),
                labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'field_required'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingSmall),

            // Капитан
            CheckboxListTile(
              title: Text('is_captain'.tr(), style: AppTextStyles.body),
              value: member.isCaptain,
              onChanged: (value) {
                setState(() {
                  // Снять галочку "капитан" у всех остальных
                  for (var m in _members) {
                    m.isCaptain = false;
                  }
                  member.isCaptain = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
            ),

            // Разряд
            DropdownButtonFormField<String>(
              value: member.rank,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'rank'.tr(),
                labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
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
              dropdownColor: AppColors.surface,
              items: [
                DropdownMenuItem(value: 'none', child: Text('rank_none'.tr())),
                DropdownMenuItem(value: '3', child: Text('rank_3'.tr())),
                DropdownMenuItem(value: '2', child: Text('rank_2'.tr())),
                DropdownMenuItem(value: '1', child: Text('rank_1'.tr())),
                DropdownMenuItem(value: 'kms', child: Text('rank_kms'.tr())),
                DropdownMenuItem(value: 'ms', child: Text('rank_ms'.tr())),
                DropdownMenuItem(value: 'msmk', child: Text('rank_msmk'.tr())),
              ],
              onChanged: (value) {
                setState(() {
                  member.rank = value ?? 'none';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveTeam,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
        child: Text(
          _isEditing ? 'save_changes'.tr() : (_isCasting ? 'add_participants_button'.tr() : 'create_team'.tr()),
          style: AppTextStyles.button,
        ),
      ),
    );
  }

  void _addMember() {
    setState(() {
      _members.add(_MemberData(
        nameController: TextEditingController(),
        isCaptain: false,
        rank: 'none',
        rodController: TextEditingController(),
        lineController: TextEditingController(),
      ));
    });
  }

  void _removeMember(int index) {
    setState(() {
      _members[index].nameController.dispose();
      _members[index].rodController.dispose();
      _members[index].lineController.dispose();
      _members.removeAt(index);
    });
  }

  Future<void> _saveTeam() async {
    print('🔵 _saveTeam() called');
    print('   isEditing: $_isEditing');
    print('   isCasting: $_isCasting');
    print('   Team name: ${_nameController.text}');
    print('   Members count: ${_members.length}');

    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    if (_members.isEmpty) {
      print('❌ No members');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isCasting ? 'at_least_one_participant'.tr() : 'at_least_one_member'.tr())),
      );
      return;
    }

    // Проверка, что хотя бы один участник заполнен
    bool hasValidMember = false;
    for (var member in _members) {
      if (member.nameController.text.trim().isNotEmpty) {
        hasValidMember = true;
        break;
      }
    }

    if (!hasValidMember) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isCasting ? 'at_least_one_participant'.tr() : 'at_least_one_member'.tr())),
      );
      return;
    }

    final members = _members
        .where((m) => m.nameController.text.trim().isNotEmpty)
        .map((m) => TeamMember()
      ..fullName = m.nameController.text.trim()
      ..isCaptain = _isCasting ? false : m.isCaptain // Для кастинга нет капитана
      ..rank = _isCasting ? 'none' : m.rank          // Для кастинга нет разряда
      ..rod = _isCasting ? m.rodController.text.trim() : null
      ..line = _isCasting
          ? (widget.competition.commonLine ?? m.lineController.text.trim())
          : null)
        .toList();

    if (_isEditing) {
      await ref.read(teamProvider(widget.competition.id).notifier).updateTeam(
        teamId: widget.team!.id,
        name: _isCasting ? 'Participants' : _nameController.text.trim(), // Для кастинга имя не важно
        city: _isCasting ? widget.competition.cityOrRegion : _cityController.text.trim(),
        club: _clubController.text.trim().isEmpty ? null : _clubController.text.trim(),
        members: members,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isCasting ? 'participants_updated'.tr() : 'team_updated'.tr())),
      );
    } else {
      await ref.read(teamProvider(widget.competition.id).notifier).createTeam(
        name: _isCasting ? 'Participants' : _nameController.text.trim(),
        city: _isCasting ? widget.competition.cityOrRegion : _cityController.text.trim(),
        club: _clubController.text.trim().isEmpty ? null : _clubController.text.trim(),
        members: members,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isCasting ? 'participants_added'.tr() : 'team_created'.tr())),
      );
    }

    Navigator.pop(context);
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                _isCasting ? 'delete_participants'.tr() : 'delete_team'.tr(),
                style: AppTextStyles.h3.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
        content: Text(
          _isCasting ? 'delete_participants_warning'.tr() : 'delete_team_warning'.tr(),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('delete'.tr(), style: AppTextStyles.button),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(teamProvider(widget.competition.id).notifier).deleteTeam(widget.team!.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isCasting ? 'participants_deleted'.tr() : 'team_deleted'.tr())),
      );

      Navigator.pop(context);
    }
  }
}

class _MemberData {
  final TextEditingController nameController;
  bool isCaptain;
  String rank;
  final TextEditingController rodController;    // ✅ Для кастинга
  final TextEditingController lineController;   // ✅ Для кастинга

  _MemberData({
    required this.nameController,
    required this.isCaptain,
    required this.rank,
    required this.rodController,
    required this.lineController,
  });
}