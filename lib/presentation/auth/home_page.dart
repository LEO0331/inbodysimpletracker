import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // ✅ 修正點 1：不再直接回傳 UploadPage，而是統一回傳帶有條件判斷的 Scaffold
        return Scaffold(
          appBar: AppBar(
            title: const Text('InBody Tracker'),
            elevation: 0,
            // ✅ 修正點 2：已登入則顯示漢堡選單 (Drawer)，未登入則不顯示
            leading: auth.isAuthenticated 
                ? Builder(builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ))
                : null,
          ),
          // ✅ 修正點 3：側邊欄只在登入時載入
          drawer: auth.isAuthenticated ? _buildDrawer(context, auth) : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    auth.isAuthenticated 
                        ? 'Hello, ${auth.user?.email?.split('@')[0]}!' 
                        : 'Welcome to InBody Tracker',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Track your fitness journey by scanning InBody reports',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // ✅ 修正點 4：已登入顯示「進入分析」，未登入顯示「立即登入」
                  if (auth.isAuthenticated) ...[
                    _buildActionButton(
                      context,
                      label: 'Start Analysis (Scan)',
                      icon: Icons.camera_alt,
                      color: Colors.blue[700]!,
                      onPressed: () => Navigator.pushNamed(context, '/upload'),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      label: 'View Dashboard',
                      icon: Icons.dashboard,
                      color: Colors.green[600]!,
                      isOutlined: true,
                      onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                    ),
                  ] else ...[
                    _buildActionButton(
                      context,
                      label: 'Login',
                      icon: Icons.login,
                      color: Colors.blue[600]!,
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      label: 'Sign Up',
                      icon: Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      isOutlined: true,
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                    ),
                  ],

                  const SizedBox(height: 60),
                  _buildFeatureCard(
                    icon: Icons.camera,
                    title: 'Smart Scan',
                    description: 'Automatically extract data from InBody reports',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    icon: Icons.cloud_upload,
                    title: 'Cloud Storage',
                    description: 'Save your reports securely in the cloud',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    icon: Icons.assessment,
                    title: 'Track Progress',
                    description: 'Monitor your fitness journey over time',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 側邊欄組件
  Widget _buildDrawer(BuildContext context, AuthProvider auth) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(auth.isAdmin ? "Administrator" : "Member"),
            accountEmail: Text(auth.user?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: auth.isAdmin ? Colors.red : Colors.blue,
                size: 40,
              ),
            ),
            decoration: BoxDecoration(color: auth.isAdmin ? Colors.red : Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pop(context), // 關閉選單，回到當前首頁
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text("Scan Report"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/upload');
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("My Dashboard"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          const Divider(),
          if (auth.isAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
              title: const Text("Admin Dashboard", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin');
              },
            ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 輔助方法：動作按鈕
  Widget _buildActionButton(BuildContext context,
      {required String label, required IconData icon, required Color color, bool isOutlined = false, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: color),
              label: Text(label, style: TextStyle(color: color, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label, style: const TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
    );
  }

  // 輔助方法：功能卡片
  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.blue[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
