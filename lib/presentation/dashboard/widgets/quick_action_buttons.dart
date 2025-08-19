import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtons extends StatelessWidget {
  final VoidCallback onLendPressed;
  final VoidCallback onWithdrawPressed;
  final VoidCallback onRewardsPressed;

  const QuickActionButtons({
    super.key,
    required this.onLendPressed,
    required this.onWithdrawPressed,
    required this.onRewardsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context: context,
            icon: 'account_balance',
            label: 'Prestar',
            color: AppTheme.lightTheme.primaryColor,
            onPressed: onLendPressed,
          ),
          _buildActionButton(
            context: context,
            icon: 'account_balance_wallet',
            label: 'Retirar',
            color: AppTheme.getWarningColor(true),
            onPressed: onWithdrawPressed,
          ),
          _buildActionButton(
            context: context,
            icon: 'card_giftcard',
            label: 'Recompensas',
            color: AppTheme.getAccentColor(true),
            onPressed: onRewardsPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
