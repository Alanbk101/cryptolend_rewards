import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PresetAmountButtonsWidget extends StatelessWidget {
  final Function(double) onPercentageSelected;
  final double availableBalance;

  const PresetAmountButtonsWidget({
    super.key,
    required this.onPercentageSelected,
    required this.availableBalance,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> presetOptions = [
      {'label': '25%', 'percentage': 0.25},
      {'label': '50%', 'percentage': 0.50},
      {'label': '75%', 'percentage': 0.75},
      {'label': 'MAX', 'percentage': 1.0},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: presetOptions.map((option) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: ElevatedButton(
                onPressed: () {
                  final amount =
                      availableBalance * (option['percentage'] as double);
                  onPercentageSelected(amount);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.primaryContainer,
                  foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  option['label'] as String,
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
