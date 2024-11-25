import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/cafeComponents/cafeDrawer.dart';

class CafeAdminDashboardScreen extends StatefulWidget {
  const CafeAdminDashboardScreen({super.key});

  @override
  _CafeAdminDashboardScreenState createState() =>
      _CafeAdminDashboardScreenState();
}

class _CafeAdminDashboardScreenState extends State<CafeAdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, int> orderStatusCount = {
    'Pending': 0,
    'In Process': 0,
    'Completed': 0,
  };

  Map<String, int> menuCategoriesCount = {};
  Map<String, List<double>> orderData = {};

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([
        _fetchOrderStatusCount(),
        _fetchMenuCategoriesCount(),
        _fetchOrderData(),
      ]);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error loading data: $e';
      });
    }
  }

  Future<void> _fetchOrderStatusCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    final orders = snapshot.docs;

    Map<String, int> statusCount = {
      'Pending': 0,
      'In Process': 0,
      'Completed': 0,
    };

    for (var order in orders) {
      String status = order.data()['status'] as String? ?? 'Pending';
      if (statusCount.containsKey(status)) {
        statusCount[status] = (statusCount[status] ?? 0) + 1;
      }
    }

    setState(() {
      orderStatusCount = statusCount;
    });
  }

  Future<void> _fetchMenuCategoriesCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    final menuItems = snapshot.docs;

    Map<String, int> categoriesCount = {};

    for (var item in menuItems) {
      String category = item.data()['category'] as String? ?? 'Uncategorized';
      categoriesCount[category] = (categoriesCount[category] ?? 0) + 1;
    }

    setState(() {
      menuCategoriesCount = categoriesCount;
    });
  }

  Future<void> _fetchOrderData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    final orders = snapshot.docs;

    Map<String, List<double>> data = {};

    for (var order in orders) {
      String paymentMethod =
          order.data()['paymentMethod'] as String? ?? 'Unknown';
      List<dynamic> items = order.data()['items'] as List<dynamic>? ?? [];

      double totalValue = items.fold(0.0,
          (sum, item) => sum + ((item['price'] as num?)?.toDouble() ?? 0.0));

      if (!data.containsKey(paymentMethod)) {
        data[paymentMethod] = [];
      }
      data[paymentMethod]!.add(totalValue);
    }

    data.forEach((key, value) {
      value.sort();
    });

    setState(() {
      orderData = data;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CafeAdminDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/splash.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            'assets/splash.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 800,
                          height: 800,
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/logo.png',
                                      width: 70,
                                      height: 70,
                                    ),
                                    const SizedBox(width: 24),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cafe Admin',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Manage your operations',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 20.0),
                                child: _buildChartsRow(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildChartsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOrderStatusBarChart(),
        _buildMenuCategoriesDonutChart(),
        _buildOrderGraphChart(),
      ],
    );
  }

  Widget _buildOrderStatusBarChart() {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Order Status Breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: orderStatusCount['Pending']!.toDouble(),
                            color: Colors.orange,
                            width: 20,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: orderStatusCount['In Process']!.toDouble(),
                            color: Colors.blue,
                            width: 20,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: orderStatusCount['Completed']!.toDouble(),
                            color: Colors.green,
                            width: 20,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Pending');
                              case 1:
                                return const Text('In Process');
                              case 2:
                                return const Text('Completed');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          interval: 1,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCategoriesDonutChart() {
    double total =
        menuCategoriesCount.values.fold(0, (sum, value) => sum + value);

    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.lightGreen[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Menu Categories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: menuCategoriesCount.entries.map((entry) {
                      double percentage = (entry.value / total) * 100;
                      return PieChartSectionData(
                        color: _getCategoryColor(entry.key),
                        value: entry.value.toDouble(),
                        title:
                            '${entry.key} (${percentage.toStringAsFixed(1)}%)',
                        radius: 30,
                      );
                    }).toList(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderGraphChart() {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Order Values by Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: orderData.entries.map((entry) {
                      return LineChartBarData(
                        spots: entry.value
                            .asMap()
                            .map((index, value) => MapEntry(
                                index, FlSpot(index.toDouble(), value)))
                            .values
                            .toList(),
                        isCurved: true,
                        color: _getPaymentMethodColor(entry.key),
                        belowBarData: BarAreaData(show: true),
                        aboveBarData: BarAreaData(show: false),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Drinks':
        return Colors.blue;
      case 'Fast Food':
        return Colors.green;
      case 'Desi':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'Cash':
        return Colors.yellow;
      case 'Card':
        return Colors.red;
      case 'Online':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
