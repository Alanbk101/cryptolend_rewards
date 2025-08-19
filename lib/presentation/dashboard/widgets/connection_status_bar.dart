import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectionStatusBar extends StatelessWidget {
  final bool isConnected;
  final String networkName;

  const ConnectionStatusBar({
    super.key,
    required this.isConnected,
    required this.networkName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isConnected
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: isConnected
                ? AppTheme.getSuccessColor(true).withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.lightTheme.colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            isConnected
                ? 'Conectado a $networkName'
                : 'Sin conexión a blockchain',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isConnected
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.lightTheme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isConnected) ...[
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'security',
              color: AppTheme.getSuccessColor(true),
              size: 14,
            ),
          ],
        ],
      ),
    );
  }
}
