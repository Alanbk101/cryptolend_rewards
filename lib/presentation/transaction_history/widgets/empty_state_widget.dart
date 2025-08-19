import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onStartLending;

  const EmptyStateWidget({
    Key? key,
    this.onStartLending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context, isDark),
            SizedBox(height: 4.h),
            Text(
              'No hay transacciones',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Aún no has realizado ninguna transacción. Comienza a prestar tus stablecoins para generar recompensas.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStartLending,
                icon: CustomIconWidget(
                  iconName: 'trending_up',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                label: const Text('Comenzar a Prestar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () => _showHelpDialog(context),
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              label: const Text('¿Cómo funciona?'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, bool isDark) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles for depth
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(15.w),
            ),
          ),
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.w),
            ),
          ),
          // Main icon
          CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          // Decorative elements
          Positioned(
            top: 8.w,
            right: 8.w,
            child: Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(1.5.w),
              ),
            ),
          ),
          Positioned(
            bottom: 6.w,
            left: 6.w,
            child: Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('¿Cómo funciona?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpStep(
              context,
              '1',
              'Conecta tu wallet',
              'Conecta tu billetera de criptomonedas para comenzar.',
            ),
            SizedBox(height: 2.h),
            _buildHelpStep(
              context,
              '2',
              'Deposita stablecoins',
              'Deposita USDC, USDT u otras stablecoins en el protocolo.',
            ),
            SizedBox(height: 2.h),
            _buildHelpStep(
              context,
              '3',
              'Gana recompensas',
              'Recibe intereses y puntos de recompensa automáticamente.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onStartLending != null) {
                onStartLending!();
              }
            },
            child: const Text('Comenzar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpStep(
      BuildContext context, String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Center(
            child: Text(
              number,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
