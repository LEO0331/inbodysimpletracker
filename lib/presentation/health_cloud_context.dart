import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models/training_checkpoint.dart';
import '../logic/providers/auth_provider.dart';
import '../logic/providers/health_provider.dart';

/// Optional read-only legacy context; no Health observations cross into Firestore.
class HealthCloudContext extends StatefulWidget {
  const HealthCloudContext({super.key});
  @override
  State<HealthCloudContext> createState() => _HealthCloudContextState();
}

class _HealthCloudContextState extends State<HealthCloudContext> {
  bool _show = false;
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider?>()?.user;
    if (user == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Local Health works without login. Sign in through the existing cloud area to view InBody reports and checkpoint metadata here.',
        ),
      );
    }
    final week = context.watch<HealthProvider>().week;
    final from = DateTime(week.year, week.month, week.day);
    final to = from.add(const Duration(days: 7));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _show = !_show),
          icon: const Icon(Icons.cloud_outlined),
          label: Text(
            _show ? 'Hide cloud-backed context' : 'Show cloud-backed context',
          ),
        ),
        if (_show) ...[
          const Text(
            'Read-only InBody / checkpoint metadata for this week. Health observations and local notes are not uploaded.',
          ),
          _records(user.uid, 'reports', 'reportDate', from, to),
          _records(user.uid, 'checkpoints', 'checkpointDate', from, to),
          Wrap(
            spacing: 12,
            children: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                child: const Text('Open InBody dashboard'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/checkpoints'),
                child: const Text('Open training videos'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _records(
    String uid,
    String collection,
    String dateField,
    DateTime from,
    DateTime to,
  ) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      key: ValueKey('$uid/$collection/$from'),
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(collection)
          .where(dateField, isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .where(dateField, isLessThan: Timestamp.fromDate(to))
          .orderBy(dateField, descending: true)
          .limit(21)
          .snapshots(includeMetadataChanges: true),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'Cloud-backed records are unavailable. The local vault is unaffected.',
          );
        }
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final docs = snapshot.data!.docs
            .where((doc) => !doc.metadata.hasPendingWrites)
            .toList();
        if (docs.isEmpty) {
          return Text(
            collection == 'reports'
                ? 'No InBody reports for this week.'
                : 'No training checkpoints for this week.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final doc in docs.take(20))
              _recordCard(collection, doc.id, doc.data(), dateField),
            if (docs.length > 20)
              const Text(
                'Showing 20 records. Open the original history for more.',
              ),
          ],
        );
      },
    );
  }

  Widget _recordCard(
    String collection,
    String id,
    Map<String, dynamic> data,
    String dateField,
  ) {
    if (collection == 'checkpoints') {
      final checkpoint = TrainingCheckpoint.fromMap(id, data);
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.video_library_outlined),
        title: Text(checkpoint.exerciseName),
        subtitle: Text(
          '${DateFormat.yMMMd().format(checkpoint.checkpointDate)} · checkpoint metadata in cloud; video on its original device',
        ),
      );
    }
    final date = data[dateField];
    String metric(String field) {
      final value = data[field];
      final parsed = value is num
          ? value.toDouble()
          : value is String
          ? double.tryParse(value)
          : null;
      return parsed != null && parsed.isFinite
          ? parsed.toStringAsFixed(1)
          : 'unavailable';
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.assessment_outlined),
      title: Text(
        date is Timestamp
            ? DateFormat.yMMMd().format(date.toDate())
            : 'InBody report',
      ),
      subtitle: Text(
        'Cloud report · weight ${metric('weight')} kg · body fat ${metric('bodyFatPercent')}% · muscle ${metric('muscleMass')} kg',
      ),
    );
  }
}
