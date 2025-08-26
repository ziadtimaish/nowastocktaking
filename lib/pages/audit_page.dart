import 'package:flutter/material.dart';
import 'package:elite_stocktaking/models/stock_model.dart';
import 'package:elite_stocktaking/models/stock_transaction_model.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';

@NowaGenerated()
class AuditPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() {
    return _AuditPageState();
  }
}

@NowaGenerated()
class _AuditPageState extends State<AuditPage> {
  List<StockModel> _stocks = [];

  bool _isLoading = true;

  String? _errorMessage;

  final Set<String> _expandedStocks = {};

  final Map<String, List<StockTransactionModel>> _stockTransactions = {};

  final Map<String, bool> _loadingTransactions = {};

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  Future<void> _loadStocks() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final stocks = await SupabaseService().getAllStocks();
      if (mounted) {
        setState(() {
          _stocks = stocks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load stocks. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshStocks() async {
    await _loadStocks();
    _stockTransactions.clear();
    _expandedStocks.clear();
  }

  Future<void> _loadTransactionHistory(String stockId, String? sku) async {
    if (_stockTransactions.containsKey(stockId)) {
      return;
    }
    setState(() {
      _loadingTransactions[stockId] = true;
    });
    try {
      List<StockTransactionModel> transactions = [];
      if (sku != null && sku.isNotEmpty) {
        transactions = await SupabaseService().getStockTransactionsBySku(sku);
      } else {
        transactions = await SupabaseService().getStockTransactionsByStockId(
          stockId,
        );
      }
      if (mounted) {
        setState(() {
          _stockTransactions[stockId] = transactions;
          _loadingTransactions[stockId] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _stockTransactions[stockId] = [];
          _loadingTransactions[stockId] = false;
        });
      }
    }
  }

  void _toggleStockExpansion(String stockId, String? sku) {
    setState(() {
      if (_expandedStocks.contains(stockId)) {
        _expandedStocks.remove(stockId);
      } else {
        _expandedStocks.add(stockId);
        _loadTransactionHistory(stockId, sku);
      }
    });
  }

  Widget _buildTransactionHistory(String stockId) {
    final transactions = _stockTransactions[stockId] ?? [];
    final isLoading = _loadingTransactions[stockId] ?? false;
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade500, size: 20.0),
            const SizedBox(width: 12.0),
            Text(
              'No transaction history available',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.history, color: Colors.blue.shade600, size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                'Transaction History (${transactions.length} entries)',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...transactions.map(
          (transaction) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: _getTransactionColor(
                      transaction.transactionType,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Icon(
                    _getTransactionIcon(transaction.transactionType),
                    color: _getTransactionColor(
                      transaction.transactionType,
                    ),
                    size: 16.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getTransactionDescription(transaction),
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatDateTime(transaction.createdAt),
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (transaction.notes != null) ...[
                        const SizedBox(height: 4.0),
                        Text(
                          transaction.notes ?? '',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getTransactionColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'add':
        return Colors.green;
      case 'update':
        return Colors.blue;
      case 'remove':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'add':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'remove':
        return Icons.remove_circle;
      default:
        return Icons.circle;
    }
  }

  String _getTransactionDescription(StockTransactionModel transaction) {
    final quantityText =
        transaction.quantityAdded != null ? '${transaction.quantityAdded! > 0 ? '+' : ''}${transaction.quantityAdded}' : '0';
    final totalText = transaction.totalQuantityAfter != null ? ' (Total: ${transaction.totalQuantityAfter})' : '';
    return '$quantityText$totalText';
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) {
      return 'Unknown';
    }
    try {
      final dt = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(dt);
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else {
        if (difference.inHours > 0) {
          return '${difference.inHours}h ago';
        } else {
          if (difference.inMinutes > 0) {
            return '${difference.inMinutes}m ago';
          } else {
            return 'Just now';
          }
        }
      }
    } catch (e) {
      return dateTime.substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Stock Audit',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStocks,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStocks,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.0,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: _loadStocks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : _stocks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64.0,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'No Stock Items Found',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Add some stock items to start auditing',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade600, Colors.blue.shade800],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200,
                                    blurRadius: 10.0,
                                    offset: const Offset(0.0, 4.0),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.inventory_2,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '${_stocks.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Total Items',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 1.0,
                                    color: Colors.white30,
                                  ),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.numbers,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '${_stocks.where((stock) => stock.quantity != null).fold(0, (sum, stock) => sum + (stock.quantity ?? 0))}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Total Quantity',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 1.0,
                                    color: Colors.white30,
                                  ),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.category,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '${_stocks.where((stock) => stock.category != null).map((stock) => stock.category!).toSet().length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Categories',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Stock Items',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Tap to view history',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _stocks.length,
                                itemBuilder: (context, index) {
                                  final stock = _stocks[index];
                                  final stockId = stock.stockId ?? '';
                                  final isExpanded = _expandedStocks.contains(stockId);
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 6.0,
                                          offset: const Offset(0.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () => _toggleStockExpansion(stockId, stock.sku),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 12.0,
                                          ),
                                          leading: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Icon(
                                              Icons.inventory_2,
                                              color: Colors.blue.shade600,
                                              size: 28.0,
                                            ),
                                          ),
                                          title: Text(
                                            stock.name ?? 'Unnamed Item',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (stock.sku != null) ...[
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  'SKU: ${stock.sku}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                              if (stock.category != null) ...[
                                                const SizedBox(height: 2.0),
                                                Text(
                                                  stock.category!,
                                                  style: TextStyle(
                                                    color: Colors.blue.shade600,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                              if (stock.location != null) ...[
                                                const SizedBox(height: 2.0),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 12.0,
                                                      color: Colors.grey.shade500,
                                                    ),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      stock.location!,
                                                      style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 4.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: stock.quantity != null && stock.quantity! > 0
                                                      ? Colors.green.shade50
                                                      : Colors.red.shade50,
                                                  borderRadius: BorderRadius.circular(
                                                    8.0,
                                                  ),
                                                  border: Border.all(
                                                    color: stock.quantity != null && stock.quantity! > 0
                                                        ? Colors.green.shade200
                                                        : Colors.red.shade200,
                                                  ),
                                                ),
                                                child: Text(
                                                  stock.quantity?.toString() ?? '0',
                                                  style: TextStyle(
                                                    color: stock.quantity != null && stock.quantity! > 0
                                                        ? Colors.green.shade700
                                                        : Colors.red.shade700,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Icon(
                                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isExpanded) _buildTransactionHistory(stockId),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
