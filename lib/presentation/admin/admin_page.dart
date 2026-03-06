import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              final user = users[i];
              return ExpansionTile(
                title: Text(user["email"]),
                subtitle: Text("Role: ${user["role"]}"),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: db.collection("users")
                        .doc(user.id)
                        .collection("reports")
                        .orderBy("reportDate", descending: true)
                        .snapshots(),
                    builder: (context, reportSnap) {
                      if (!reportSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final reports = reportSnap.data!.docs;
                      return Column(
                        children: reports.map((r) {
                          return ListTile(
                            title: Text("Report: ${r["reportDate"]}"),
                            subtitle: Text("Weight: ${r["weight"]} kg, Body Fat: ${r["bodyFatPercent"]}%"),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
