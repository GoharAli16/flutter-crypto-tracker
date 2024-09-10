import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'Market Cap';
  String _filterBy = 'All';

  final List<Map<String, dynamic>> _cryptocurrencies = [
    {
      'id': '1',
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'price': 45000.00,
      'change24h': 2500.00,
      'changePercent24h': 5.88,
      'marketCap': 850000000000,
      'volume24h': 25000000000,
      'rank': 1,
      'logo': 'https://example.com/btc.png',
    },
    {
      'id': '2',
      'symbol': 'ETH',
      'name': 'Ethereum',
      'price': 3000.00,
      'change24h': 150.00,
      'changePercent24h': 5.26,
      'marketCap': 360000000000,
      'volume24h': 15000000000,
      'rank': 2,
      'logo': 'https://example.com/eth.png',
    },
    {
      'id': '3',
      'symbol': 'BNB',
      'name': 'Binance Coin',
      'price': 320.00,
      'change24h': -10.00,
      'changePercent24h': -3.03,
      'marketCap': 50000000000,
      'volume24h': 2000000000,
      'rank': 3,
      'logo': 'https://example.com/bnb.png',
    },
    {
      'id': '4',
      'symbol': 'ADA',
      'name': 'Cardano',
      'price': 0.45,
      'change24h': 0.02,
      'changePercent24h': 4.65,
      'marketCap': 15000000000,
      'volume24h': 800000000,
      'rank': 4,
      'logo': 'https://example.com/ada.png',
    },
    {
      'id': '5',
      'symbol': 'SOL',
      'name': 'Solana',
      'price': 95.00,
      'change24h': 5.00,
      'changePercent24h': 5.56,
      'marketCap': 40000000000,
      'volume24h': 1200000000,
      'rank': 5,
      'logo': 'https://example.com/sol.png',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Gainers'),
            Tab(text: 'Losers'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCryptocurrenciesList(_cryptocurrencies),
          _buildCryptocurrenciesList(_cryptocurrencies.where((crypto) => crypto['changePercent24h'] > 0).toList()),
          _buildCryptocurrenciesList(_cryptocurrencies.where((crypto) => crypto['changePercent24h'] < 0).toList()),
          _buildCryptocurrenciesList(_cryptocurrencies.where((crypto) => crypto['isFavorite'] == true).toList()),
        ],
      ),
    );
  }

  Widget _buildCryptocurrenciesList(List<Map<String, dynamic>> cryptocurrencies) {
    if (cryptocurrencies.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: cryptocurrencies.length,
      itemBuilder: (context, index) {
        final crypto = cryptocurrencies[index];
        return _buildCryptocurrencyItem(crypto);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No cryptocurrencies found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptocurrencyItem(Map<String, dynamic> crypto) {
    final isPositive = crypto['changePercent24h'] >= 0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.currency_bitcoin, size: 20),
        ),
        title: Row(
          children: [
            Text(
              crypto['symbol'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              crypto['name'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '#${crypto['rank']}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Market Cap: \$${_formatNumber(crypto['marketCap'])}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              'Volume 24h: \$${_formatNumber(crypto['volume24h'])}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${crypto['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${crypto['changePercent24h'].toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _openCryptocurrencyDetails(crypto),
        onLongPress: () => _showCryptocurrencyOptions(crypto),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: CryptocurrencySearchDelegate(_cryptocurrencies),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Sort By'),
              trailing: DropdownButton<String>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(value: 'Market Cap', child: Text('Market Cap')),
                  DropdownMenuItem(value: 'Price', child: Text('Price')),
                  DropdownMenuItem(value: 'Change 24h', child: Text('Change 24h')),
                  DropdownMenuItem(value: 'Volume 24h', child: Text('Volume 24h')),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Filter By'),
              trailing: DropdownButton<String>(
                value: _filterBy,
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All')),
                  DropdownMenuItem(value: 'Gainers', child: Text('Gainers')),
                  DropdownMenuItem(value: 'Losers', child: Text('Losers')),
                  DropdownMenuItem(value: 'Top 100', child: Text('Top 100')),
                ],
                onChanged: (value) {
                  setState(() {
                    _filterBy = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCryptocurrencyDetails(Map<String, dynamic> crypto) {
    // Implement cryptocurrency details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${crypto['name']} details...')),
    );
  }

  void _showCryptocurrencyOptions(Map<String, dynamic> crypto) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text(crypto['isFavorite'] == true ? 'Remove from Favorites' : 'Add to Favorites'),
              onTap: _toggleFavorite,
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Set Price Alert'),
              onTap: _setPriceAlert,
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: _shareCryptocurrency,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() {
    Navigator.pop(context);
    // Implement toggle favorite
  }

  void _setPriceAlert() {
    Navigator.pop(context);
    // Implement set price alert
  }

  void _shareCryptocurrency() {
    Navigator.pop(context);
    // Implement share cryptocurrency
  }
}

class CryptocurrencySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> cryptocurrencies;

  CryptocurrencySearchDelegate(this.cryptocurrencies);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = cryptocurrencies.where((crypto) {
      return crypto['name'].toLowerCase().contains(query.toLowerCase()) ||
             crypto['symbol'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final crypto = results[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.currency_bitcoin, size: 20),
          ),
          title: Text(crypto['name']),
          subtitle: Text(crypto['symbol']),
          trailing: Text('\$${crypto['price'].toStringAsFixed(2)}'),
          onTap: () {
            close(context, crypto);
          },
        );
      },
    );
  }
}
