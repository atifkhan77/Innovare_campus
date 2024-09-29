import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/cafeComponents/cafeDrawer.dart';

class CafeAdminDashboardScreen extends StatefulWidget {
  @override
  _CafeAdminDashboardScreenState createState() => _CafeAdminDashboardScreenState();
}

class _CafeAdminDashboardScreenState extends State<CafeAdminDashboardScreen> with SingleTickerProviderStateMixin {
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
    final snapshot = await FirebaseFirestore.instance.collection('orders').get();
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
    final snapshot = await FirebaseFirestore.instance.collection('orders').get();
    final orders = snapshot.docs;

    Map<String, List<double>> data = {};

    for (var order in orders) {
      String paymentMethod = order.data()['paymentMethod'] as String? ?? 'Unknown';
      List<dynamic> items = order.data()['items'] as List<dynamic>? ?? [];
      
      double totalValue = items.fold(0.0, (sum, item) => sum + ((item['price'] as num?)?.toDouble() ?? 0.0));

      if (!data.containsKey(paymentMethod)) {
        data[paymentMethod] = [];
      }
      data[paymentMethod]!.add(totalValue);
    }

    // Sort the values for each payment method
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
        title: const Text('Cafe Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(79, 76, 116, 1),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
    return Expanded(
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
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          interval: 1,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: false),
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
    return Expanded(
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
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: _getMenuCategorySections(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getMenuCategorySections() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    return menuCategoriesCount.entries.map((entry) {
      int index = menuCategoriesCount.keys.toList().indexOf(entry.key);
      double percentage = entry.value / menuCategoriesCount.values.reduce((a, b) => a + b) * 100;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }



  // This method remains the same for other charts

  Widget _buildOrderGraphChart() {
    if (orderData.isEmpty) {
      return Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('No order data available'),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Order Values by Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: _getLineBarsData(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}',
                                style: const TextStyle(color: Colors.black, fontSize: 12),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${value.toInt()}',
                                style: const TextStyle(color: Colors.black, fontSize: 12),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _getLineBarsData() {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];

    return orderData.entries.map((entry) {
      int index = orderData.keys.toList().indexOf(entry.key);
      return LineChartBarData(
        spots: entry.value.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value);
        }).toList(),
        isCurved: true,
        gradient: LinearGradient(
          colors: [colors[index % colors.length]],
        ),
        barWidth: 4,
        belowBarData: BarAreaData(show: false),
      );
    }).toList();
  }
}


