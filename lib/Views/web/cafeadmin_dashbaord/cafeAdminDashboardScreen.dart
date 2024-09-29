import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manageOrdersScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manage_menuScreen.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/viewOrdersScreen.dart';

class CafeAdminDashboardScreen extends StatefulWidget {
  @override
  _CafeAdminDashboardScreenState createState() => _CafeAdminDashboardScreenState();
}

class _CafeAdminDashboardScreenState extends State<CafeAdminDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
        title: Text('Cafe Admin Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/splash.png', // Background image for the dashboard
              fit: BoxFit.cover,
            ),
          ),
          // Diagonal background image
          Positioned.fill(
            child: Transform.rotate(
              angle: -0.2, // Adjust angle for diagonal effect
              child: Opacity(
                opacity: 0.2, // Adjust opacity for diagonal effect
                child: Image.asset(
                  'assets/splash.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Centered and faded logo image
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
          // Content of the page
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
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
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildAnimatedCard(
                            icon: Icons.person,
                            label: 'Manage Menu',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ManageMenuScreen()),
                              );
                            },
                          ),
                          _buildAnimatedCard(
                            icon: Icons.fastfood,
                            label: 'Manage Orders',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ManageOrderScreen()),
                              );
                            },
                          ),
                          _buildAnimatedCard(
                            icon: Icons.list,
                            label: 'View Orders',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewOrdersScreen()),
                              );
                            },
                          ),
                        ],
                      ),
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

  Widget _buildAnimatedCard({required IconData icon, required String label, required VoidCallback? onTap}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value * 0.2 + 1,
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              color: const Color.fromRGBO(49, 42, 119, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Container(
                width: 160,
                height: 160,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
