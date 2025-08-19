import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ApyCalculatorWidget extends StatelessWidget {
  final double amount;
  final double apy;
  final int duration;

  const ApyCalculatorWidget({
    super.key,
    required this.amount,
    required this.apy,
    required this.duration,
  });

  double get projectedEarnings {
    if (amount <= 0) return 0.0;
    return (amount * apy / 100) * (duration / 365);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondaryContainer,
            AppTheme.lightTheme.colorScheme.secondaryContainer
                .withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Ganancias Proyectadas',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'APY Actual',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    '${apy.toStringAsFixed(2)}%',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ganancia Estimada',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    '+\$${projectedEarnings.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            height: 1,
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.2),
          ),
          SizedBox(height: 1.h),
          Text(
            'Duración: $duration días • Total estimado: \$${(amount + projectedEarnings).toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
