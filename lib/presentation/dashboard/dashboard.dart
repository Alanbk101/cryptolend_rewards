import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/connection_status_bar.dart';
import './widgets/educational_progress_widget.dart';
import './widgets/portfolio_value_card.dart';
import './widgets/quick_action_buttons.dart';
import './widgets/recent_transaction_card.dart';
import './widgets/stablecoin_balance_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data for dashboard
  final List<Map<String, dynamic>> stablecoins = [
    {
      "name": "USD Coin",
      "symbol": "USDC",
      "icon":
          "https://images.unsplash.com/photo-1621761191319-c6fb62004040?w=100&h=100&fit=crop&crop=center",
      "balance": 15420.50,
      "apy": 8.5,
      "change": 0.12,
      "isPositive": true,
    },
    {
      "name": "Tether",
      "symbol": "USDT",
      "icon":
          "https://images.unsplash.com/photo-1640340434855-6084b1f4901c?w=100&h=100&fit=crop&crop=center",
      "balance": 8750.25,
      "apy": 7.8,
      "change": -0.05,
      "isPositive": false,
    },
    {
      "name": "Dai",
      "symbol": "DAI",
      "icon":
          "https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=100&h=100&fit=crop&crop=center",
      "balance": 3200.00,
      "apy": 9.2,
      "change": 0.08,
      "isPositive": true,
    },
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {
      "type": "Lending",
      "symbol": "USDC",
      "amount": 5000.00,
      "status": "Completado",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "hash": "0x1a2b3c4d5e6f7890abcdef1234567890abcdef12",
    },
    {
      "type": "Withdrawal",
      "symbol": "USDT",
      "amount": 1250.50,
      "status": "Pendiente",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "hash": "0x9876543210fedcba0987654321fedcba09876543",
    },
    {
      "type": "Lending",
      "symbol": "DAI",
      "amount": 2000.00,
      "status": "Completado",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "hash": "0xabcdef1234567890abcdef1234567890abcdef12",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    // Simulate network delay for refresh
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        // Refresh data here
      });
    }
  }

  double get _totalPortfolioValue {
    return (stablecoins as List)
        .fold(0.0, (sum, coin) => sum + (coin["balance"] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(children: [
          // Connection Status Bar
          const ConnectionStatusBar(
              isConnected: true, networkName: 'Ethereum Mainnet'),

          // App Header
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CryptoLend',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.lightTheme.primaryColor)),
                          Text('Rewards',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                      color: AppTheme.getNeutralColor(true))),
                        ]),
                    Row(children: [
                      GestureDetector(
                          onTap: () {
                            // Navigate to QR scanner
                          },
                          child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8)),
                              child: CustomIconWidget(
                                  iconName: 'qr_code_scanner',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 24))),
                      SizedBox(width: 3.w),
                      GestureDetector(
                          onTap: () {
                            // Navigate to notifications
                          },
                          child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8)),
                              child: CustomIconWidget(
                                  iconName: 'notifications',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 24))),
                    ]),
                  ])),

          // Main Content
          Expanded(
              child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshData,
                  color: AppTheme.lightTheme.primaryColor,
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Portfolio Value Card
                            PortfolioValueCard(
                                totalValue: _totalPortfolioValue,
                                changePercentage: 2.45,
                                isPositiveChange: true),

                            // Quick Action Buttons
                            QuickActionButtons(onLendPressed: () {
                              Navigator.pushNamed(context, '/lending-screen');
                            }, onWithdrawPressed: () {
                              // Handle withdraw action
                            }, onRewardsPressed: () {
                              Navigator.pushNamed(context, '/rewards-center');
                            }),

                            // Stablecoin Balance Cards
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.h),
                                child: Text('Mis Stablecoins',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600))),
                            ...stablecoins
                                .map((coin) => StablecoinBalanceCard(
                                    coinName: coin["name"] as String,
                                    coinSymbol: coin["symbol"] as String,
                                    iconUrl: coin["icon"] as String,
                                    balance: coin["balance"] as double,
                                    apyRate: coin["apy"] as double,
                                    changePercentage: coin["change"] as double,
                                    isPositiveChange:
                                        coin["isPositive"] as bool))
                                .toList(),

                            // Educational Progress Widget
                            EducationalProgressWidget(
                                currentCourse:
                                    'Fundamentos de DeFi y Préstamos Descentralizados',
                                progressPercentage: 65.0,
                                completedLessons: 13,
                                totalLessons: 20,
                                onContinuePressed: () {
                                  // Navigate to course
                                }),

                            // Recent Transactions
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.h),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Transacciones Recientes',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600)),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                '/transaction-history');
                                          },
                                          child: Text('Ver todas',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: AppTheme.lightTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                    ])),
                            ...recentTransactions
                                .take(3)
                                .map((transaction) => RecentTransactionCard(
                                    transactionType:
                                        transaction["type"] as String,
                                    coinSymbol: transaction["symbol"] as String,
                                    amount: transaction["amount"] as double,
                                    status: transaction["status"] as String,
                                    timestamp:
                                        transaction["timestamp"] as DateTime,
                                    transactionHash:
                                        transaction["hash"] as String,
                                    onTap: () {
                                      // Show transaction details
                                    }))
                                .toList(),

                            SizedBox(
                                height: 10.h), // Bottom padding for tab bar
                          ])))),
        ])),

        // Bottom Navigation Bar
        bottomNavigationBar: Container(
            decoration:
                BoxDecoration(color: AppTheme.lightTheme.cardColor, boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, -2)),
            ]),
            child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.lightTheme.primaryColor,
                unselectedLabelColor: AppTheme.getNeutralColor(true),
                indicatorColor: Colors.transparent,
                labelStyle: AppTheme.lightTheme.textTheme.labelSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall
                    ?.copyWith(fontWeight: FontWeight.w400),
                tabs: [
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'dashboard',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24),
                      text: 'Dashboard'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'account_balance',
                          color: AppTheme.getNeutralColor(true),
                          size: 24),
                      text: 'Préstamos'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'card_giftcard',
                          color: AppTheme.getNeutralColor(true),
                          size: 24),
                      text: 'Recompensas'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'school',
                          color: AppTheme.getNeutralColor(true),
                          size: 24),
                      text: 'Aprender'),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      // Already on dashboard
                      break;
                    case 1:
                      Navigator.pushNamed(context, '/lending-screen');
                      break;
                    case 2:
                      Navigator.pushNamed(context, '/rewards-center');
                      break;
                    case 3:
                      // Navigate to learning section
                      break;
                  }
                })),

        // Floating Action Button for New Lending
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/lending-screen');
            },
            backgroundColor: AppTheme.lightTheme.primaryColor,
            foregroundColor: Colors.white,
            icon: CustomIconWidget(
                iconName: 'add', color: Colors.white, size: 24),
            label: Text('Nuevo Préstamo',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
