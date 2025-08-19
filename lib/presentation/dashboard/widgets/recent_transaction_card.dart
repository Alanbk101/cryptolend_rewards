import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionCard extends StatelessWidget {
  final String transactionType;
  final String coinSymbol;
  final double amount;
  final String status;
  final DateTime timestamp;
  final String transactionHash;
  final VoidCallback onTap;

  const RecentTransactionCard({
    super.key,
    required this.transactionType,
    required this.coinSymbol,
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.transactionHash,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLending = transactionType.toLowerCase() == 'lending';
    final isCompleted = status.toLowerCase() == 'completado';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isLending
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: CustomIconWidget(
                iconName: isLending ? 'trending_up' : 'trending_down',
                color: isLending
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.getWarningColor(true),
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transactionType,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${isLending ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isLending
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getWarningColor(true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        coinSymbol,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getNeutralColor(true),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.getSuccessColor(true)
                                  .withValues(alpha: 0.1)
                              : AppTheme.getWarningColor(true)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isCompleted
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getWarningColor(true),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.getNeutralColor(true),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.getNeutralColor(true),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours} h';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
