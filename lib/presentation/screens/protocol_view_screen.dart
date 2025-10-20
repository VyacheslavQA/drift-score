import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/local/protocol_local.dart';
import '../../data/services/protocol_export_service.dart';
import '../../core/theme/app_colors.dart';
import 'protocol_view/widgets/carp_protocol_content.dart';
import 'protocol_view/widgets/casting_protocol_content.dart';
import 'protocol_view/shared/protocol_header.dart';

class ProtocolViewScreen extends StatefulWidget {
  final ProtocolLocal protocol;

  const ProtocolViewScreen({
    Key? key,
    required this.protocol,
  }) : super(key: key);

  @override
  State<ProtocolViewScreen> createState() => _ProtocolViewScreenState();
}

class _ProtocolViewScreenState extends State<ProtocolViewScreen> {
  final ProtocolExportService _exportService = ProtocolExportService();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final data = jsonDecode(widget.protocol.dataJson) as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getProtocolTitle()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.share),
            onSelected: (value) => _handleExport(value, data),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('download_pdf'.tr()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    const Icon(Icons.table_chart, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('download_excel'.tr()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProtocolHeader(data: data),
                  const SizedBox(height: 24),
                  _buildProtocolContent(data),
                ],
              ),
            ),
          ),
          if (_isExporting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Экспорт протокола...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleExport(String format, Map<String, dynamic> data) async {
    setState(() {
      _isExporting = true;
    });

    try {
      switch (format) {
        case 'pdf':
          await _exportService.exportToPdf(widget.protocol, data);
          break;
        case 'excel':
          await _exportService.exportToExcel(widget.protocol, data);
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Протокол экспортирован успешно'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      print('Export error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка экспорта: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  String _getProtocolTitle() {
    switch (widget.protocol.type) {
      case 'weighing':
        return 'protocol_weighing_title'.tr(namedArgs: {
          'day': widget.protocol.dayNumber.toString(),
          'number': widget.protocol.weighingNumber.toString(),
        });
      case 'intermediate':
        return 'protocol_intermediate_title'.tr(namedArgs: {
          'number': widget.protocol.weighingNumber.toString(),
        });
      case 'big_fish':
        return 'protocol_big_fish_title'.tr(namedArgs: {
          'day': widget.protocol.bigFishDay.toString(),
        });
      case 'summary':
        return 'protocol_summary_title'.tr();
      case 'final':
        return 'protocol_final_title'.tr();
      case 'draw':
        return 'draw_protocol_title'.tr();
      case 'casting_attempt':
        return 'Протокол попытки №${widget.protocol.weighingNumber}';
      case 'casting_intermediate':
        return 'Промежуточный протокол (после ${widget.protocol.weighingNumber} попыток)';
      case 'casting_final':
        return 'Финальный протокол кастинга';
      default:
        return 'protocol_title'.tr();
    }
  }

  Widget _buildProtocolContent(Map<String, dynamic> data) {
    final fishingType = data['fishingType'] as String?;

    switch (fishingType) {
      case 'carp':
      case 'float':
      case 'spinning':
      case 'feeder':
        return CarpProtocolContent(protocol: widget.protocol, data: data);

      case 'casting':
        return CastingProtocolContent(protocol: widget.protocol, data: data);

      default:
        return Center(
          child: Text(
            'Неизвестный тип рыбалки: $fishingType',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }
}