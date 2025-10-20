import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProtocolHeader extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProtocolHeader({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasCity = data['city'] != null;
    final hasLake = data['lake'] != null;
    final hasVenue = data['venue'] != null;
    final hasOrganizer = data['organizer'] != null;
    final hasWeighingTime = data['weighingTime'] != null;
    final hasSessionTime = data['sessionTime'] != null;
    final hasTimeRange = data['startTime'] != null && data['finishTime'] != null;
    final hasJudges = data['judges'] != null;

    if (!hasCity && !hasLake && !hasVenue && !hasOrganizer && !hasWeighingTime && !hasSessionTime && !hasTimeRange && !hasJudges) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasCity)
              _buildInfoRow(Icons.location_on, data['city']),
            if (hasVenue)
              _buildInfoRow(Icons.water, data['venue']),
            if (hasLake && !hasVenue)
              _buildInfoRow(Icons.water, data['lake']),
            if (hasOrganizer)
              _buildInfoRow(Icons.person, '${'protocol_organizer'.tr()}: ${data['organizer']}'),
            if (hasSessionTime)
              _buildInfoRow(
                Icons.access_time,
                'Время сессии: ${DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.parse(data['sessionTime']),
                )}',
              ),
            if (hasWeighingTime)
              _buildInfoRow(
                Icons.access_time,
                DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.parse(data['weighingTime']),
                ),
              ),
            if (hasTimeRange)
              _buildInfoRow(
                Icons.calendar_today,
                '${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['startTime']))} - ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(data['finishTime']))}',
              ),
            if (hasJudges)
              _buildJudges(data['judges'] as List<dynamic>),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimensions.paddingSmall),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          SizedBox(width: AppDimensions.paddingSmall),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJudges(List<dynamic> judges) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimensions.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'protocol_judges'.tr()}:',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          ...judges.map((judge) => Padding(
            padding: EdgeInsets.only(left: AppDimensions.paddingSmall, top: 2),
            child: Text(
              '• ${judge['name']} - ${(judge['rank'] as String).tr()}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          )),
        ],
      ),
    );
  }
}