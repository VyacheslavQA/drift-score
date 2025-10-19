import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/remote/competition_remote.dart';
import '../screens/competition_protocols_screen.dart';

class PublicCompetitionCard extends StatelessWidget {
  final CompetitionRemote competition;

  const PublicCompetitionCard({
    super.key,
    required this.competition,
  });

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  String _getDateRange() {
    final startFormatted = _formatDate(competition.startTime);
    final finishFormatted = _formatDate(competition.finishTime);

    if (startFormatted == finishFormatted) {
      return startFormatted;
    }
    return '$startFormatted - $finishFormatted';
  }

  Color _getStatusColor() {
    return competition.status == 'active' ? AppColors.success : AppColors.textSecondary;
  }

  String _getStatusText() {
    return competition.status == 'active' ? 'Активно' : 'Завершено';
  }

  Color _getFishingTypeColor() {
    switch (competition.fishingType) {
      case 'float':
        return AppColors.primary;
      case 'spinning':
        return Color(0xFFE74C3C);
      case 'carp':
        return Color(0xFF27AE60);
      case 'feeder':
        return Color(0xFFF39C12);
      case 'ice_jig':
        return Color(0xFF3498DB);
      case 'ice_spoon':
        return Color(0xFF5DADE2);
      case 'trout':
        return Color(0xFF9B59B6);
      case 'fly':
        return Color(0xFF8E44AD);
      case 'casting':
        return Color(0xFFD35400);
      default:
        return AppColors.primary;
    }
  }

  String _getFishingTypeName() {
    switch (competition.fishingType) {
      case 'float':
        return 'Поплавочная';
      case 'spinning':
        return 'Спиннинг';
      case 'carp':
        return 'Карповая';
      case 'feeder':
        return 'Фидер';
      case 'ice_jig':
        return 'Зимняя мормышка';
      case 'ice_spoon':
        return 'Зимняя блесна';
      case 'trout':
        return 'Форель';
      case 'fly':
        return 'Нахлыст';
      case 'casting':
        return 'Кастинг';
      default:
        return competition.fishingType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getFishingTypeColor();

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompetitionProtocolsScreen(
                  competition: competition,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(
                color: typeColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и статус
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        competition.name,
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingSmall),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        border: Border.all(
                          color: _getStatusColor(),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: AppTextStyles.caption.copyWith(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppDimensions.paddingMedium),

                // Тип рыбалки
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phishing,
                            size: 16,
                            color: typeColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            _getFishingTypeName(),
                            style: AppTextStyles.caption.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppDimensions.paddingMedium),

                // Информация
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  text: competition.lakeName.isNotEmpty ? competition.lakeName : 'Не указано',
                ),
                SizedBox(height: 6),
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: _getDateRange(),
                ),

                SizedBox(height: AppDimensions.paddingMedium),

                // Кнопка просмотра протоколов
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompetitionProtocolsScreen(
                              competition: competition,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.description_outlined, size: 18),
                      label: Text('Протоколы'),
                      style: TextButton.styleFrom(
                        foregroundColor: typeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}