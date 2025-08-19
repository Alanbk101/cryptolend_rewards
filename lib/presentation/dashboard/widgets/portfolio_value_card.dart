import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PortfolioValueCard extends StatefulWidget {
  final double totalValue;
  final double changePercentage;
  final bool isPositiveChange;

  const PortfolioValueCard({
    super.key,
    required this.totalValue,
    required this.changePercentage,
    required this.isPositiveChange,
  });

  @override
  State<PortfolioValueCard> createState() => _PortfolioValueCardState();
}

class _PortfolioValueCardState extends State<PortfolioValueCard> {
  bool _isPrivacyEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor Total del Portafolio',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getNeutralColor(true),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPrivacyEnabled = !_isPrivacyEnabled;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName:
                        _isPrivacyEnabled ? 'visibility_off' : 'visibility',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            _isPrivacyEnabled
                ? '••••••'
                : '\$${widget.totalValue.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName:
                    widget.isPositiveChange ? 'trending_up' : 'trending_down',
                color: widget.isPositiveChange
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.lightTheme.colorScheme.error,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${widget.isPositiveChange ? '+' : ''}${widget.changePercentage.toStringAsFixed(2)}% (24h)',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: widget.isPositiveChange
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
