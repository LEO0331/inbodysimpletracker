import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';
import '../dashboard/dashboard_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  Uint8List? _webImage;
  String _extractedText = "";
  Map<String, dynamic> _parsedMetrics = {};

  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();

  // 1. 選擇圖片與平台判斷邏輯
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = pickedFile;
          _extractedText = "The web platform does not currently support automatic recognition. Please click the button below to manually enter the data.";
        });
        // Web 直接彈出輸入視窗
        _showManualInputDialog();
      } else {
        setState(() {
          _imageFile = pickedFile;
        });
        await _processImage(pickedFile);
      }
    }
  }

  // 2. 行動裝置 OCR 處理邏輯
  Future<void> _processImage(XFile imageFile) async {
    if (kIsWeb) return;

    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
      });

      final metrics = _parseMetrics(recognizedText.text);
      setState(() {
        _parsedMetrics = metrics;
      });

      // 自動儲存至 Firestore
      await _saveReportToFirestore(metrics);
    } catch (e) {
      developer.log("OCR Error", error: e, name: "upload_page");
    }
  }

  // 3. 手動輸入對話框 (用於 Web 或辨識失敗時)
  Future<void> _showManualInputDialog() async {
    final weightController = TextEditingController(text: _parsedMetrics["weight"]?.toString());
    final fatController = TextEditingController(text: _parsedMetrics["bodyFatPercent"]?.toString());
    final muscleController = TextEditingController(text: _parsedMetrics["muscleMass"]?.toString());
    final visceralController = TextEditingController(text: _parsedMetrics["visceralFat"]?.toString());

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Manual Input"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildManualTextField(weightController, "weight (kg)", Icons.monitor_weight),
              _buildManualTextField(fatController, "bodyFatPercent (%)", Icons.pie_chart),
              _buildManualTextField(muscleController, "muscleMass (kg)", Icons.fitness_center),
              _buildManualTextField(visceralController, "visceralFat", Icons.opacity),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("cancel")),
          ElevatedButton(
            onPressed: () async {
              final metrics = {
                "weight": double.tryParse(weightController.text) ?? 0.0,
                "bodyFatPercent": double.tryParse(fatController.text) ?? 0.0,
                "muscleMass": double.tryParse(muscleController.text) ?? 0.0,
                "visceralFat": double.tryParse(visceralController.text) ?? 0.0,
                "reportDate": DateTime.now().toIso8601String(),
              };
              setState(() {
                _parsedMetrics = metrics;
              });
              await _saveReportToFirestore(metrics);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("confirm"),
          ),
        ],
      ),
    );
  }

  // 4. 儲存至 Firestore 的統一方法
  Future<void> _saveReportToFirestore(Map<String, dynamic> metrics) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("please login to save reports")));
      return;
    }

    try {
      final report = InbodyReport(
        id: '',
        reportDate: DateTime.parse(metrics["reportDate"]),
        weight: (metrics["weight"] as num).toDouble(),
        bodyFatPercent: (metrics["bodyFatPercent"] as num).toDouble(),
        muscleMass: (metrics["muscleMass"] as num).toDouble(),
        visceralFat: (metrics["visceralFat"] as num).toDouble(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.user!.uid)
          .collection("reports")
          .add(report.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The data has been successfully saved to the cloud.")));
      }
    } catch (e) {
      developer.log("Firestore Save Error", error: e, name: "upload_page");
    }
  }

  // 輔助：正則表達式解析
  Map<String, dynamic> _parseMetrics(String text) {
    final weightRegex = RegExp(r'Weight[:\s]*([\d.]+)');
    final fatRegex = RegExp(r'Body\s*Fat[:\s]*([\d.]+)');
    final muscleRegex = RegExp(r'Muscle\s*Mass[:\s]*([\d.]+)');
    final visceralRegex = RegExp(r'Visceral\s*Fat[:\s]*([\d.]+)');

    double getValue(RegExp regex) {
      final match = regex.firstMatch(text);
      return match != null ? (double.tryParse(match.group(1)!) ?? 0.0) : 0.0;
    }

    return {
      "weight": getValue(weightRegex),
      "bodyFatPercent": getValue(fatRegex),
      "muscleMass": getValue(muscleRegex),
      "visceralFat": getValue(visceralRegex),
      "reportDate": DateTime.now().toIso8601String(),
    };
  }

  // Handle logout
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      textRecognizer.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("InBody Report Analysis"),
        elevation: 0,
        actions: [
          // Dashboard button
          Tooltip(
            message: 'View Dashboard',
            child: IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(),
                  ),
                );
              },
            ),
          ),
          // User profile button
          Tooltip(
            message: 'User: ${auth.user?.email ?? "Unknown"}',
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _handleLogout();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'profile',
                  enabled: false,
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            auth.user?.email ?? 'Unknown',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout, size: 20, color: Colors.red),
                      const SizedBox(width: 12),
                      const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  (auth.user?.email?.substring(0, 1) ?? 'U').toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildImagePreview(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Select Image"),
                  onPressed: _pickImage,
                ),
                if (kIsWeb)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Manual Entry"),
                    onPressed: _showManualInputDialog,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_extractedText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Divider(),
                    if (_parsedMetrics.isNotEmpty) ...[
                      _buildMetricTile("weight", "${_parsedMetrics["weight"]} kg"),
                      _buildMetricTile("bodyFatPercent", "${_parsedMetrics["bodyFatPercent"]} %"),
                      _buildMetricTile("muscleMass", "${_parsedMetrics["muscleMass"]} kg"),
                      _buildMetricTile("visceralFat", "${_parsedMetrics["visceralFat"]}"),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Image.asset("assets/images/sample_report.jpg", fit: BoxFit.cover);
    }
    if (kIsWeb && _webImage != null) {
      return Image.memory(_webImage!, fit: BoxFit.cover);
    } else if (!kIsWeb) {
      return Image.file(File(_imageFile!.path), fit: BoxFit.cover);
    }
    return const Center(child: Text("Failed to load preview."));
  }

  Widget _buildMetricTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), Text(value)],
      ),
    );
  }

  Widget _buildManualTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}