import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/monthly_group_header.dart';
import './widgets/search_filter_bar.dart';
import './widgets/transaction_card.dart';
import './widgets/transaction_details_modal.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedType = 'Todos';
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  List<Map<String, dynamic>> _allTransactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  Map<String, bool> _expandedMonths = {};

  // Mock transaction data
  final List<Map<String, dynamic>> _mockTransactions = [
    {
      "id": 1,
      "type": "Préstamo",
      "amount": "+\$2,500.00 USDC",
      "status": "Confirmado",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "hash": "0x1a2b3c4d5e6f7890abcdef1234567890abcdef12",
      "contractAddress": "0xa0b86991c431e69f7d3aa9b26c4b1a67b5b616c2",
      "blockNumber": 18456789,
      "confirmations": 24,
      "network": "Ethereum",
      "gasFee": "\$12.45",
      "apy": "8.5%",
      "note": null,
    },
    {
      "id": 2,
      "type": "Recompensa",
      "amount": "+\$45.20 USDC",
      "status": "Confirmado",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "hash": "0x2b3c4d5e6f7890abcdef1234567890abcdef1234",
      "contractAddress": "0xa0b86991c431e69f7d3aa9b26c4b1a67b5b616c2",
      "blockNumber": 18456123,
      "confirmations": 156,
      "network": "Ethereum",
      "gasFee": "\$8.90",
      "apy": "8.5%",
      "note": "Recompensa semanal por préstamo activo",
    },
    {
      "id": 3,
      "type": "Retiro",
      "amount": "-\$1,000.00 USDC",
      "status": "Pendiente",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "hash": "0x3c4d5e6f7890abcdef1234567890abcdef123456",
      "contractAddress": "0xa0b86991c431e69f7d3aa9b26c4b1a67b5b616c2",
      "blockNumber": 18455890,
      "confirmations": 3,
      "network": "Ethereum",
      "gasFee": "\$15.30",
      "apy": "0%",
      "note": null,
    },
    {
      "id": 4,
      "type": "Préstamo",
      "amount": "+\$5,000.00 USDT",
      "status": "Confirmado",
      "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      "hash": "0x4d5e6f7890abcdef1234567890abcdef12345678",
      "contractAddress": "0xdac17f958d2ee523a2206206994597c13d831ec7",
      "blockNumber": 18454321,
      "confirmations": 432,
      "network": "Ethereum",
      "gasFee": "\$18.75",
      "apy": "7.8%",
      "note": null,
    },
    {
      "id": 5,
      "type": "Recompensa",
      "amount": "+\$78.90 USDT",
      "status": "Confirmado",
      "timestamp": DateTime.now().subtract(const Duration(days: 7)),
      "hash": "0x5e6f7890abcdef1234567890abcdef1234567890",
      "contractAddress": "0xdac17f958d2ee523a2206206994597c13d831ec7",
      "blockNumber": 18453654,
      "confirmations": 567,
      "network": "Ethereum",
      "gasFee": "\$11.20",
      "apy": "7.8%",
      "note": "Recompensa mensual acumulada",
    },
    {
      "id": 6,
      "type": "Retiro",
      "amount": "-\$2,000.00 USDT",
      "status": "Fallido",
      "timestamp": DateTime.now().subtract(const Duration(days: 10)),
      "hash": "0x6f7890abcdef1234567890abcdef12345678901a",
      "contractAddress": "0xdac17f958d2ee523a2206206994597c13d831ec7",
      "blockNumber": 18452987,
      "confirmations": 0,
      "network": "Ethereum",
      "gasFee": "\$22.10",
      "apy": "0%",
      "note": "Transacción fallida por gas insuficiente",
    },
    {
      "id": 7,
      "type": "Préstamo",
      "amount": "+\$3,200.00 DAI",
      "status": "Confirmado",
      "timestamp": DateTime.now().subtract(const Duration(days: 15)),
      "hash": "0x7890abcdef1234567890abcdef12345678901abc",
      "contractAddress": "0x6b175474e89094c44da98b954eedeac495271d0f",
      "blockNumber": 18451234,
      "confirmations": 789,
      "network": "Ethereum",
      "gasFee": "\$14.60",
      "apy": "9.2%",
      "note": null,
    },
    {
      "id": 8,
      "type": "Recompensa",
      "amount": "+\$125.40 DAI",
      "status": "Confirmado",
      "timestamp": DateTime.now().subtract(const Duration(days: 20)),
      "hash": "0x890abcdef1234567890abcdef12345678901abcd",
      "contractAddress": "0x6b175474e89094c44da98b954eedeac495271d0f",
      "blockNumber": 18450567,
      "confirmations": 1023,
      "network": "Ethereum",
      "gasFee": "\$9.80",
      "apy": "9.2%",
      "note": "Bonus por nuevo usuario",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setState(() {
      _allTransactions = List.from(_mockTransactions);
      _filteredTransactions = List.from(_allTransactions);
    });
    _initializeExpandedMonths();
  }

  void _initializeExpandedMonths() {
    final months = _getMonthlyGroups(_filteredTransactions);
    for (String month in months.keys) {
      _expandedMonths[month] = true; // All months expanded by default
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTransactions();
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate loading more data (in real app, this would be an API call)
    if (_currentPage < 3) {
      // Simulate 3 pages of data
      final newTransactions = _generateMockTransactions(_currentPage);
      setState(() {
        _allTransactions.addAll(newTransactions);
        _applyFilters();
        _currentPage++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockTransactions(int page) {
    // Generate additional mock transactions for pagination
    return List.generate(
        5,
        (index) => {
              "id": (page * 10) + index + 10,
              "type": ["Préstamo", "Retiro", "Recompensa"][index % 3],
              "amount": "+\$${(1000 + (index * 500)).toStringAsFixed(2)} USDC",
              "status": ["Confirmado", "Pendiente", "Fallido"][index % 3],
              "timestamp": DateTime.now()
                  .subtract(Duration(days: 25 + (page * 10) + index)),
              "hash":
                  "0x${(page * 10 + index).toRadixString(16).padLeft(40, '0')}",
              "contractAddress": "0xa0b86991c431e69f7d3aa9b26c4b1a67b5b616c2",
              "blockNumber": 18450000 - (page * 100) - index,
              "confirmations": 100 + index,
              "network": "Ethereum",
              "gasFee": "\$${(10 + index).toStringAsFixed(2)}",
              "apy": "${(7.5 + (index * 0.3)).toStringAsFixed(1)}%",
              "note": null,
            });
  }

  Future<void> _refreshTransactions() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _allTransactions = List.from(_mockTransactions);
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allTransactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final searchLower = _searchQuery.toLowerCase();
        return (transaction['type'] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (transaction['amount'] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (transaction['hash'] as String).toLowerCase().contains(searchLower);
      }).toList();
    }

    // Apply type filter
    if (_selectedType != 'Todos') {
      String filterType = _selectedType;
      if (filterType == 'Préstamos') filterType = 'Préstamo';
      if (filterType == 'Retiros') filterType = 'Retiro';
      if (filterType == 'Recompensas') filterType = 'Recompensa';

      filtered = filtered
          .where((transaction) => transaction['type'] == filterType)
          .toList();
    }

    // Apply date range filter
    if (_selectedDateRange != null) {
      filtered = filtered.where((transaction) {
        final transactionDate = transaction['timestamp'] as DateTime;
        return transactionDate.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            transactionDate
                .isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Sort by timestamp (newest first)
    filtered.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    setState(() {
      _filteredTransactions = filtered;
    });
    _initializeExpandedMonths();
  }

  Map<String, List<Map<String, dynamic>>> _getMonthlyGroups(
      List<Map<String, dynamic>> transactions) {
    final Map<String, List<Map<String, dynamic>>> groups = {};

    for (var transaction in transactions) {
      final date = transaction['timestamp'] as DateTime;
      final monthYear = _getMonthYearString(date);

      if (!groups.containsKey(monthYear)) {
        groups[monthYear] = [];
      }
      groups[monthYear]!.add(transaction);
    }

    return groups;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _calculateMonthlyTotal(List<Map<String, dynamic>> transactions) {
    double total = 0.0;
    for (var transaction in transactions) {
      final amountStr = transaction['amount'] as String;
      final cleanAmount = amountStr.replaceAll(RegExp(r'[^\d.-]'), '');
      final amount = double.tryParse(cleanAmount) ?? 0.0;
      total += amount;
    }
    return total >= 0
        ? '+\$${total.toStringAsFixed(2)}'
        : '-\$${(-total).toStringAsFixed(2)}';
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailsModal(transaction: transaction),
    );
  }

  void _showContextMenu(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Ver Detalles'),
              onTap: () {
                Navigator.pop(context);
                _showTransactionDetails(transaction);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'open_in_new',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Ver en Explorador'),
              onTap: () {
                Navigator.pop(context);
                // Implementation for blockchain explorer
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Exportar'),
              onTap: () {
                Navigator.pop(context);
                // Implementation for export
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Añadir Nota'),
              onTap: () {
                Navigator.pop(context);
                // Implementation for adding note
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshTransactions,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SearchFilterBar(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _applyFilters();
              },
              onTypeFilterChanged: (type) {
                setState(() {
                  _selectedType = type;
                });
                _applyFilters();
              },
              onDateRangeChanged: (range) {
                setState(() {
                  _selectedDateRange = range;
                });
                _applyFilters();
              },
              selectedType: _selectedType,
            ),
            Expanded(
              child: _filteredTransactions.isEmpty
                  ? EmptyStateWidget(
                      onStartLending: () =>
                          Navigator.pushNamed(context, '/lending-screen'),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshTransactions,
                      child: _buildTransactionList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final monthlyGroups = _getMonthlyGroups(_filteredTransactions);
    final sortedMonths = monthlyGroups.keys.toList()
      ..sort((a, b) {
        // Sort months by date (newest first)
        final dateA = _parseMonthYear(a);
        final dateB = _parseMonthYear(b);
        return dateB.compareTo(dateA);
      });

    return ListView.builder(
      controller: _scrollController,
      itemCount: _calculateListItemCount(sortedMonths, monthlyGroups) +
          (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _calculateListItemCount(sortedMonths, monthlyGroups) &&
            _isLoading) {
          return _buildLoadingIndicator();
        }

        return _buildListItem(index, sortedMonths, monthlyGroups);
      },
    );
  }

  int _calculateListItemCount(List<String> sortedMonths,
      Map<String, List<Map<String, dynamic>>> monthlyGroups) {
    int count = 0;
    for (String month in sortedMonths) {
      count++; // Header
      if (_expandedMonths[month] == true) {
        count += monthlyGroups[month]!.length; // Transactions
      }
    }
    return count;
  }

  Widget _buildListItem(int index, List<String> sortedMonths,
      Map<String, List<Map<String, dynamic>>> monthlyGroups) {
    int currentIndex = 0;

    for (String month in sortedMonths) {
      if (currentIndex == index) {
        // This is a header
        return MonthlyGroupHeader(
          monthYear: month,
          transactionCount: monthlyGroups[month]!.length,
          totalAmount: _calculateMonthlyTotal(monthlyGroups[month]!),
          isExpanded: _expandedMonths[month] ?? false,
          onToggle: () {
            setState(() {
              _expandedMonths[month] = !(_expandedMonths[month] ?? false);
            });
          },
        );
      }
      currentIndex++;

      if (_expandedMonths[month] == true) {
        final transactions = monthlyGroups[month]!;
        if (index < currentIndex + transactions.length) {
          // This is a transaction card
          final transactionIndex = index - currentIndex;
          final transaction = transactions[transactionIndex];

          return TransactionCard(
            transaction: transaction,
            onTap: () => _showTransactionDetails(transaction),
            onSwipeRight: () => _showTransactionDetails(transaction),
            onSwipeLeft: () => _shareTransaction(transaction),
            onLongPress: () => _showContextMenu(transaction),
          );
        }
        currentIndex += transactions.length;
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  DateTime _parseMonthYear(String monthYear) {
    const months = {
      'Enero': 1,
      'Febrero': 2,
      'Marzo': 3,
      'Abril': 4,
      'Mayo': 5,
      'Junio': 6,
      'Julio': 7,
      'Agosto': 8,
      'Septiembre': 9,
      'Octubre': 10,
      'Noviembre': 11,
      'Diciembre': 12
    };

    final parts = monthYear.split(' ');
    final month = months[parts[0]] ?? 1;
    final year = int.tryParse(parts[1]) ?? DateTime.now().year;

    return DateTime(year, month);
  }

  void _shareTransaction(Map<String, dynamic> transaction) {
    // Implementation for sharing transaction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiendo transacción ${transaction['id']}...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
