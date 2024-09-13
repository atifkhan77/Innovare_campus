import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/SocietiesManage/societyManagement.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/newsAnoouncement/newsManagementScreen.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/uiadmin.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/useraManage/usermanagementScreen.dart';
import 'package:innovare_campus/provider/newsProvider.dart';
import 'package:provider/provider.dart'; // Import the RotatedBackground widget

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
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
    return ChangeNotifierProvider(
      create: (context) => NewsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            RotatedBackground(imagePath: 'assets/splash.png'),
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header Section
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/admin_profile.png'),
                            ),
                            SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Welcome Back',
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
                      // Card Section with Wrap
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Wrap(
                          spacing: 16.0, // space between cards horizontally
                          runSpacing: 16.0, // space between cards vertically
                          alignment: WrapAlignment.center,
                          children: [
                            _buildAnimatedCard(
                              icon: Icons.person,
                              label: 'Add Users/View Users',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserManagementScreen()),
                                );
                              },
                            ),
                            _buildAnimatedCard(
                              icon: Icons.group,
                              label: 'Societies',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SocietyManagementScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildAnimatedCard(
                              icon: Icons.article,
                              label: 'News',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewsManagementScreen()),
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
      ),
    );
  }

  Widget _buildAnimatedCard({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value * 0.2 + 1, // Scale animation
          child: GestureDetector(
            onTap: onTap,
            child: Card(
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
                    Icon(icon, size: 48, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
