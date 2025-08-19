import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionDetailsModal extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsModal({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransactionOverview(context, isDark),
                  SizedBox(height: 3.h),
                  _buildTransactionDetails(context, isDark),
                  SizedBox(height: 3.h),
                  _buildBlockchainInfo(context, isDark),
                  SizedBox(height: 3.h),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Detalles de Transacción',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionOverview(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildTransactionIcon(),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['type'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      transaction['amount'] as String,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _getAmountColor(isDark),
                              ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fecha',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                _formatFullDate(transaction['timestamp'] as DateTime),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información de la Transacción',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),
        _buildDetailRow(
            context, 'ID de Transacción', transaction['id'].toString()),
        _buildDetailRow(context, 'Monto', transaction['amount'] as String),
        _buildDetailRow(
            context, 'Comisión de Gas', transaction['gasFee'] as String),
        _buildDetailRow(context, 'APY', transaction['apy'] as String),
        if (transaction['note'] != null)
          _buildDetailRow(context, 'Nota', transaction['note'] as String),
      ],
    );
  }

  Widget _buildBlockchainInfo(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información de Blockchain',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),
        _buildCopyableDetailRow(
            context, 'Hash de Transacción', transaction['hash'] as String),
        _buildCopyableDetailRow(context, 'Dirección del Contrato',
            transaction['contractAddress'] as String),
        _buildDetailRow(
            context, 'Número de Bloque', transaction['blockNumber'].toString()),
        _buildDetailRow(context, 'Confirmaciones',
            '${transaction['confirmations']} confirmaciones'),
        _buildDetailRow(context, 'Red', transaction['network'] as String),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableDetailRow(
      BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 0.5.h),
          GestureDetector(
            onTap: () => _copyToClipboard(context, value),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'copy',
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _viewOnExplorer(context),
            icon: CustomIconWidget(
              iconName: 'open_in_new',
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('Ver en Explorador'),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _exportTransaction(context),
                icon: CustomIconWidget(
                  iconName: 'download',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                label: const Text('Exportar'),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addNote(context),
                icon: CustomIconWidget(
                  iconName: 'note_add',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                label: const Text('Añadir Nota'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionIcon() {
    String iconName;
    Color iconColor;

    switch (transaction['type']) {
      case 'Préstamo':
        iconName = 'trending_up';
        iconColor = AppTheme.successLight;
        break;
      case 'Retiro':
        iconName = 'trending_down';
        iconColor = AppTheme.errorLight;
        break;
      case 'Recompensa':
        iconName = 'star';
        iconColor = AppTheme.warningLight;
        break;
      default:
        iconName = 'swap_horiz';
        iconColor = AppTheme.neutralLight;
    }

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (transaction['status']) {
      case 'Confirmado':
        statusColor = AppTheme.successLight;
        statusText = 'Confirmado';
        break;
      case 'Pendiente':
        statusColor = AppTheme.warningLight;
        statusText = 'Pendiente';
        break;
      case 'Fallido':
        statusColor = AppTheme.errorLight;
        statusText = 'Fallido';
        break;
      default:
        statusColor = AppTheme.neutralLight;
        statusText = 'Desconocido';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getAmountColor(bool isDark) {
    if (transaction['type'] == 'Préstamo' ||
        transaction['type'] == 'Recompensa') {
      return isDark ? AppTheme.successDark : AppTheme.successLight;
    } else if (transaction['type'] == 'Retiro') {
      return isDark ? AppTheme.errorDark : AppTheme.errorLight;
    }
    return isDark ? AppTheme.onSurfaceDark : AppTheme.onSurfaceLight;
  }

  String _formatFullDate(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copiado al portapapeles'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewOnExplorer(BuildContext context) {
    // Implementation for opening blockchain explorer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Abriendo explorador de blockchain...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportTransaction(BuildContext context) {
    // Implementation for exporting transaction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exportando transacción...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addNote(BuildContext context) {
    // Implementation for adding note
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Nota'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Escribe una nota para esta transacción...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Nota añadida correctamente'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
