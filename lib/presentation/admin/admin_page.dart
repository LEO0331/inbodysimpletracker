import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/auth_provider.dart';

class AdminPage extends StatelessWidget {
  final FirebaseFirestore? firestore;
  const AdminPage({super.key, this.firestore});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final FirebaseFirestore db = firestore ?? FirebaseFirestore.instance;

    // 🛡️ 安全防護：非管理員禁止進入
    if (!(auth.isAdmin ?? false)) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Management"),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return Column(
            children: [
              // 📊 頂部統計數據
              _buildAdminSummary(users.length),
              
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, i) {
                    final user = users[i];
                    final userData = user.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: userData["role"] == "admin" ? Colors.red : Colors.blue,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(userData["email"] ?? "No Email"),
                        subtitle: Text("Role: ${userData["role"]} | UID: ${user.id.substring(0, 5)}..."),
                        children: [
                          _buildUserReportsList(db, user.id),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 📝 建立特定使用者的報告列表
  Widget _buildUserReportsList(FirebaseFirestore db, String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection("users").doc(uid).collection("reports")
          .orderBy("reportDate", descending: true).snapshots(),
      builder: (context, reportSnap) {
        if (!reportSnap.hasData) return const LinearProgressIndicator();
        
        final reports = reportSnap.data!.docs;
        if (reports.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text("No reports found."));

        return Column(
          children: reports.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            
            // ✅ 安全日期解析
            DateTime reportDate;
            var rawDate = data["reportDate"];
            if (rawDate is Timestamp) {
              reportDate = rawDate.toDate();
            } else if (rawDate is String) {
              reportDate = DateTime.tryParse(rawDate) ?? DateTime.now();
            } else {
              reportDate = DateTime.now();
            }

            return ListTile(
              dense: true,
              leading: const Icon(Icons.analytics, size: 20),
              title: Text(DateFormat('yyyy-MM-dd HH:mm').format(reportDate)),
              subtitle: Text("W: ${data["weight"]}kg | F: ${data["bodyFatPercent"]}% | M: ${data["muscleMass"]}kg"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => _deleteUserReport(db, uid, doc.id),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // 🗑️ 管理員刪除功能
  Future<void> _deleteUserReport(FirebaseFirestore db, String uid, String reportId) async {
    await db.collection("users").doc(uid).collection("reports").doc(reportId).delete();
  }

  // 🏷️ 統計卡片
  Widget _buildAdminSummary(int userCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.red[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("Total Users", userCount.toString(), Colors.blue),
          _summaryItem("Status", "Admin Active", Colors.red),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
