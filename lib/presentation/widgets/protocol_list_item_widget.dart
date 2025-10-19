import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../data/models/remote/protocol_remote.dart';
import '../../data/models/remote/competition_remote.dart';
import '../screens/protocol_detail_screen.dart';

class ProtocolListItemWidget extends StatelessWidget {
  final ProtocolRemote protocol;
  final CompetitionRemote competition;

  const ProtocolListItemWidget({
    super.key,
    required this.protocol,
    required this.competition,
  });

  String _getProtocolTitle() {
    switch (protocol.type) {
      case 'draw':
        return 'Жеребьёвка';
      case 'weighing':
        return 'Взвешивание День ${protocol.dayNumber}, №${protocol.weighingNumber}';
      case 'intermediate':
        return 'Промежуточный протокол после ${protocol.weighingNumber} взвешивания';
      case 'big_fish':
        return 'Big Fish - День ${protocol.bigFishDay}';
      case 'summary':
        return 'Сводный протокол';
      case 'final':
        return 'Финальный протокол';
      case 'casting_attempt':
        return 'Попытка №${protocol.weighingNumber}';
      case 'casting_intermediate':
        return 'Промежуточный протокол после ${protocol.weighingNumber} попыток';
      case 'casting_final':
        return 'Финальный протокол';
      default:
        return 'Протокол';
    }
  }

  IconData _getProtocolIcon() {
    switch (protocol.type) {
      case 'draw':
        return Icons.shuffle;
      case 'weighing':
        return Icons.scale;
      case 'intermediate':
        return Icons.timeline;
      case 'big_fish':
        return Icons.emoji_events;
      case 'summary':
        return Icons.summarize;
      case 'final':
        return Icons.flag;
      case 'casting_attempt':
        return Icons.sports_baseball;
      case 'casting_intermediate':
        return Icons.timeline;
      case 'casting_final':
        return Icons.flag;
      default:
        return Icons.description;
    }
  }

  Color _getProtocolColor() {
    switch (protocol.type) {
      case 'draw':
        return Color(0xFF9C27B0);
      case 'weighing':
        return Color(0xFF2196F3);
      case 'intermediate':
        return Color(0xFFFF9800);
      case 'big_fish':
        return Color(0xFFFFD700);
      case 'summary':
        return Color(0xFF4CAF50);
      case 'final':
        return Color(0xFFE91E63);
      case 'casting_attempt':
        return Color(0xFF2196F3);
      case 'casting_intermediate':
        return Color(0xFFFF9800);
      case 'casting_final':
        return Color(0xFFE91E63);
      default:
        return AppColors.primary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final protocolColor = _getProtocolColor();

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProtocolDetailScreen(
                  protocol: protocol,
                  competition: competition,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: protocolColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Иконка
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: protocolColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Icon(
                    _getProtocolIcon(),
                    color: protocolColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),

                // Информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getProtocolTitle(),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDateTime(protocol.createdAt),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Стрелка
                Icon(
                  Icons.chevron_right,
                  color: protocolColor,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}