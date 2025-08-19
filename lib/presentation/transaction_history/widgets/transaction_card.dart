import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onLongPress;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key(transaction['id'].toString()),
        background: _buildSwipeBackground(
          color: AppTheme.lightTheme.colorScheme.primary,
          icon: 'info',
          text: 'Ver Detalles',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeBackground(
          color: AppTheme.lightTheme.colorScheme.secondary,
          icon: 'share',
          text: 'Compartir',
          alignment: Alignment.centerRight,
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd &&
              onSwipeRight != null) {
            onSwipeRight!();
          } else if (direction == DismissDirection.endToStart &&
              onSwipeLeft != null) {
            onSwipeLeft!();
          }
        },
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  _buildTransactionIcon(),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                transaction['type'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusIndicator(),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              transaction['amount'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _getAmountColor(isDark),
                                  ),
                            ),
                            Text(
                              _formatTimestamp(
                                  transaction['timestamp'] as DateTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDark
                                        ? AppTheme.neutralDark
                                        : AppTheme.neutralLight,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hash: ${_truncateHash(transaction['hash'] as String)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontFamily: 'monospace',
                                    color: isDark
                                        ? AppTheme.neutralDark
                                        : AppTheme.neutralLight,
                                  ),
                            ),
                            if (transaction['confirmations'] != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: (isDark
                                          ? AppTheme.successDark
                                          : AppTheme.successLight)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${transaction['confirmations']} conf.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: isDark
                                            ? AppTheme.successDark
                                            : AppTheme.successLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required String icon,
    required String text,
    required Alignment alignment,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildStatusIndicator() {
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
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'hace ${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _truncateHash(String hash) {
    if (hash.length <= 12) return hash;
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 6)}';
  }
}
