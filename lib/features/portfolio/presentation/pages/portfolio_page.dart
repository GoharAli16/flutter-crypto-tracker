import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, dynamic> _portfolioSummary = {
    'totalValue': 12547.89,
    'totalChange': 1247.89,
    'totalChangePercent': 11.05,
    'totalInvested': 11300.00,
    'totalProfit': 1247.89,
    'profitPercent': 11.05,
  };

  final List<Map<String, dynamic>> _holdings = [
    {
      'id': '1',
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'amount': 0.25,
      'price': 45000.00,
      'value': 11250.00,
      'change': 1250.00,
      'changePercent': 12.5,
      'logo': 'https://example.com/btc.png',
    },
    {
      'id': '2',
      'symbol': 'ETH',
      'name': 'Ethereum',
      'amount': 2.5,
      'price': 3000.00,
      'value': 7500.00,
      'change': 500.00,
      'changePercent': 7.14,
      'logo': 'https://example.com/eth.png',
    },
    {
      'id': '3',
      'symbol': 'ADA',
      'name': 'Cardano',
      'amount': 1000.0,
      'price': 0.45,
      'value': 450.00,
      'change': -50.00,
      'changePercent': -10.0,
      'logo': 'https://example.com/ada.png',
    },
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'type': 'buy',
      'symbol': 'BTC',
      'amount': 0.1,
      'price': 42000.00,
      'total': 4200.00,
      'timestamp': '2024-01-15T10:30:00Z',
      'status': 'completed',
    },
    {
      'id': '2',
      'type': 'sell',
      'symbol': 'ETH',
      'amount': 0.5,
      'price': 3200.00,
      'total': 1600.00,
      'timestamp': '2024-01-14T15:45:00Z',
      'status': 'completed',
    },
    {
      'id': '3',
      'type': 'buy',
      'symbol': 'ADA',
      'amount': 500.0,
      'price': 0.50,
      'total': 250.00,
      'timestamp': '2024-01-13T09:20:00Z',
      'status': 'pending',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTransaction,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Holdings'),
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildHoldingsTab(),
          _buildTransactionsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portfolio Summary Card
          _buildPortfolioSummaryCard(),
          const SizedBox(height: 24),
          
          // Performance Chart
          _buildPerformanceChart(),
          const SizedBox(height: 24),
          
          // Quick Actions
          _buildQuickActions(),
          const SizedBox(height: 24),
          
          // Recent Transactions
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Portfolio Value',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${_portfolioSummary['totalValue'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _portfolioSummary['totalChange'] >= 0 
                      ? Icons.trending_up 
                      : Icons.trending_down,
                  color: _portfolioSummary['totalChange'] >= 0 
                      ? Colors.green 
                      : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '\$${_portfolioSummary['totalChange'].abs().toStringAsFixed(2)} (${_portfolioSummary['totalChangePercent'].abs().toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: _portfolioSummary['totalChange'] >= 0 
                        ? Colors.green 
                        : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Invested',
                    '\$${_portfolioSummary['totalInvested'].toStringAsFixed(2)}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Total Profit',
                    '\$${_portfolioSummary['totalProfit'].toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio Performance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Performance Chart',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add,
                    label: 'Buy',
                    color: Colors.green,
                    onTap: _buyCrypto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.remove,
                    label: 'Sell',
                    color: Colors.red,
                    onTap: _sellCrypto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.swap_horiz,
                    label: 'Swap',
                    color: Colors.blue,
                    onTap: _swapCrypto,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _viewAllTransactions,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._transactions.take(3).map((transaction) => 
                _buildTransactionItem(transaction)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction['type'] == 'buy' ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction['type'] == 'buy' ? Icons.add : Icons.remove,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction['type'].toUpperCase()} ${transaction['symbol']}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${transaction['amount']} ${transaction['symbol']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction['total'].toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                _formatTimestamp(transaction['timestamp']),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _holdings.length,
      itemBuilder: (context, index) {
        final holding = _holdings[index];
        return _buildHoldingItem(holding);
      },
    );
  }

  Widget _buildHoldingItem(Map<String, dynamic> holding) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.currency_bitcoin, size: 24),
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holding['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    holding['symbol'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${holding['amount']} ${holding['symbol']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Value
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${holding['value'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      holding['change'] >= 0 
                          ? Icons.trending_up 
                          : Icons.trending_down,
                      color: holding['change'] >= 0 ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${holding['changePercent'].toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: holding['change'] >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _addTransaction() {
    // Implement add transaction
  }

  void _showMoreOptions() {
    // Implement more options
  }

  void _buyCrypto() {
    // Implement buy crypto
  }

  void _sellCrypto() {
    // Implement sell crypto
  }

  void _swapCrypto() {
    // Implement swap crypto
  }

  void _viewAllTransactions() {
    // Implement view all transactions
  }
}
