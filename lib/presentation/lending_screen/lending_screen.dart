import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/apy_calculator_widget.dart';
import './widgets/balance_header_widget.dart';
import './widgets/lending_terms_widget.dart';
import './widgets/preset_amount_buttons_widget.dart';
import './widgets/risk_assessment_widget.dart';
import './widgets/transaction_preview_modal.dart';

class LendingScreen extends StatefulWidget {
  const LendingScreen({super.key});

  @override
  State<LendingScreen> createState() => _LendingScreenState();
}

class _LendingScreenState extends State<LendingScreen> {
  final TextEditingController _amountController = TextEditingController();

  // Mock data for stablecoins
  final List<Map<String, dynamic>> _stablecoins = [
    {
      "symbol": "USDC",
      "name": "USD Coin",
      "balance": 2450.75,
      "apy": 8.5,
    },
    {
      "symbol": "USDT",
      "name": "Tether",
      "balance": 1890.32,
      "apy": 7.8,
    },
    {
      "symbol": "DAI",
      "name": "Dai Stablecoin",
      "balance": 3200.00,
      "apy": 9.2,
    },
    {
      "symbol": "BUSD",
      "name": "Binance USD",
      "balance": 1650.45,
      "apy": 7.5,
    },
  ];

  String _selectedCoin = "USDC";
  double _currentAmount = 0.0;
  int _selectedDuration = 30;
  bool _isLoading = false;
  bool _showPreviewModal = false;

  double get _availableBalance {
    final coin = _stablecoins.firstWhere(
      (coin) => coin["symbol"] == _selectedCoin,
      orElse: () => _stablecoins.first,
    );
    return (coin["balance"] as double);
  }

  double get _currentApy {
    final coin = _stablecoins.firstWhere(
      (coin) => coin["symbol"] == _selectedCoin,
      orElse: () => _stablecoins.first,
    );

    // Adjust APY based on duration
    double baseApy = (coin["apy"] as double);
    switch (_selectedDuration) {
      case 7:
        return baseApy * 0.6;
      case 30:
        return baseApy;
      case 90:
        return baseApy * 1.2;
      case 180:
        return baseApy * 1.4;
      case 365:
        return baseApy * 1.6;
      default:
        return baseApy;
    }
  }

  bool get _canStartLending {
    return _currentAmount > 0 &&
        _currentAmount <= _availableBalance &&
        !_isLoading;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    setState(() {
      _currentAmount = double.tryParse(value) ?? 0.0;
    });
  }

  void _onPercentageSelected(double amount) {
    setState(() {
      _currentAmount = amount;
      _amountController.text = amount.toStringAsFixed(2);
    });
  }

  void _onDurationSelected(int duration) {
    setState(() {
      _selectedDuration = duration;
    });
  }

  void _showCoinSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Seleccionar Stablecoin',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ..._stablecoins
                .map((coin) => ListTile(
                      leading: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            (coin["symbol"] as String).substring(0, 1),
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        coin["symbol"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Saldo: \$${(coin["balance"] as double).toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: Text(
                        '${(coin["apy"] as double).toStringAsFixed(1)}% APY',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCoin = coin["symbol"] as String;
                          _currentAmount = 0.0;
                          _amountController.clear();
                        });
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showTransactionPreview() {
    setState(() {
      _showPreviewModal = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TransactionPreviewModal(
        amount: _currentAmount,
        selectedCoin: _selectedCoin,
        duration: _selectedDuration,
        apy: _currentApy,
        gasFee: 0.0025,
        projectedEarnings:
            (_currentAmount * _currentApy / 100) * (_selectedDuration / 365),
        onConfirm: _confirmTransaction,
        onCancel: () {
          setState(() {
            _showPreviewModal = false;
          });
          Navigator.pop(context);
        },
      ),
    ).then((_) {
      setState(() {
        _showPreviewModal = false;
      });
    });
  }

  void _confirmTransaction() async {
    Navigator.pop(context); // Close modal

    setState(() {
      _isLoading = true;
    });

    // Simulate blockchain transaction processing
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    // Show success dialog
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              '¡Préstamo Exitoso!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Tu préstamo de \$${_currentAmount.toStringAsFixed(2)} $_selectedCoin ha sido procesado exitosamente.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Hash: 0x7a8b9c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f',
                style: AppTheme.getMonospaceStyle(
                  isLight: true,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/transaction-history');
                    },
                    child: Text('Ver Historial'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    child: Text('Ir al Dashboard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            BalanceHeaderWidget(
              balance: '\$${_availableBalance.toStringAsFixed(2)}',
              selectedCoin: _selectedCoin,
              onCoinTap: _showCoinSelector,
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Amount Input
                    AmountInputWidget(
                      controller: _amountController,
                      selectedCoin: _selectedCoin,
                      onAmountChanged: _onAmountChanged,
                    ),

                    // Preset Amount Buttons
                    PresetAmountButtonsWidget(
                      onPercentageSelected: _onPercentageSelected,
                      availableBalance: _availableBalance,
                    ),

                    // APY Calculator
                    ApyCalculatorWidget(
                      amount: _currentAmount,
                      apy: _currentApy,
                      duration: _selectedDuration,
                    ),

                    // Lending Terms
                    LendingTermsWidget(
                      selectedDuration: _selectedDuration,
                      onDurationSelected: _onDurationSelected,
                    ),

                    // Risk Assessment
                    RiskAssessmentWidget(),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentAmount > _availableBalance)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.errorContainer
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'warning',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Cantidad excede el saldo disponible',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 7.h,
                    child: ElevatedButton(
                      onPressed:
                          _canStartLending ? _showTransactionPreview : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canStartLending
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Iniciar Préstamo',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: _canStartLending
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Préstamo DeFi',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Ayuda'),
                  content: Text(
                      'Información sobre cómo funciona el préstamo DeFi y los riesgos asociados.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(2.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
