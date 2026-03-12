import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import '../../logic/providers/mqtt_provider.dart';
import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';
import '../dashboard/dashboard_page.dart';
import '../../core/services/ocr_service.dart';
import '../../core/utils/inbody_parser.dart';
import '../../core/services/file_service.dart';

class UploadPage extends StatefulWidget {
  final FirebaseFirestore? firestore;
  final FileService? fileService;
  const UploadPage({super.key, this.firestore, this.fileService});

  @override
  State<UploadPage> createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  Uint8List? _fileBytes;
  String _extractedText = "";
  Map<String, dynamic> _parsedMetrics = {};
  bool _isProcessing = false;
  String? _selectedFileName;
  bool _isPdf = false;

  final ImagePicker _picker = ImagePicker();
  late final FileService _fileService;

  @override
  void initState() {
    super.initState();
    _fileService = widget.fileService ?? FileService();
  }

  // ===== Unified file picker: supports images AND PDFs =====
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'pdf'],
      withData: true, // needed for web to get bytes
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final bytes = file.bytes;
      final name = file.name.toLowerCase();
      final isPdf = name.endsWith('.pdf');

      setState(() {
        _fileBytes = bytes;
        _selectedFileName = file.name;
        _isPdf = isPdf;
        _imageFile = null; // clear old image_picker reference
        _extractedText = "";
        _parsedMetrics = {};
      });

      if (bytes != null) {
        if (isPdf) {
          await processPdf(bytes);
        } else {
          await processImageBytes(bytes, kIsWeb ? null : file.path);
        }
      }
    }
  }

  // ===== Process image on all platforms =====
  @visibleForTesting
  Future<void> processImageBytes(Uint8List bytes, String? filePath) async {
    setState(() => _isProcessing = true);

    try {
      String recognizedText = await _fileService.recognizeImage(bytes, filePath);

      setState(() {
        _extractedText = recognizedText.isNotEmpty
            ? recognizedText
            : "No text recognized. Please use manual entry.";
      });

      if (recognizedText.isNotEmpty) {
        final metrics = InbodyParser.parse(recognizedText);
        setState(() => _parsedMetrics = metrics);

        // If we got useful data, auto-save
        if (metrics["weight"] != 0.0 ||
            metrics["bodyFatPercent"] != 0.0 ||
            metrics["muscleMass"] != 0.0) {
          await _saveReportToFirestore(metrics);
        } else {
          // Parsed but no useful metrics → show manual input
          _showManualInputDialog();
        }
      } else {
        // No text → manual entry
        _showManualInputDialog();
      }
    } catch (e) {
      developer.log("OCR Error", error: e, name: "upload_page");
      setState(() {
        _extractedText = "OCR failed: $e\nPlease use manual entry.";
      });
      _showManualInputDialog();
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // ===== Process PDF using Syncfusion (works on web + mobile) =====
  @visibleForTesting
  Future<void> processPdf(Uint8List bytes) async {
    setState(() => _isProcessing = true);

    try {
      String extractedText = await _fileService.extractPdfText(bytes);

      setState(() {
        _extractedText = extractedText.isNotEmpty
            ? extractedText
            : "No text found in PDF. Please use manual entry.";
      });

      if (extractedText.isNotEmpty) {
        final metrics = InbodyParser.parse(extractedText);
        setState(() => _parsedMetrics = metrics);

        if (metrics["weight"] != 0.0 ||
            metrics["bodyFatPercent"] != 0.0 ||
            metrics["muscleMass"] != 0.0) {
          await _saveReportToFirestore(metrics);
        } else {
          _showManualInputDialog();
        }
      } else {
        _showManualInputDialog();
      }
    } catch (e) {
      developer.log("PDF Extract Error", error: e, name: "upload_page");
      setState(() {
        _extractedText = "PDF extraction failed: $e\nPlease use manual entry.";
      });
      _showManualInputDialog();
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // ===== Manual input dialog (fallback) =====
  Future<void> _showManualInputDialog() async {
    final weightController =
        TextEditingController(text: _parsedMetrics["weight"]?.toString());
    final fatController =
        TextEditingController(text: _parsedMetrics["bodyFatPercent"]?.toString());
    final muscleController =
        TextEditingController(text: _parsedMetrics["muscleMass"]?.toString());
    final visceralController =
        TextEditingController(text: _parsedMetrics["visceralFat"]?.toString());

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Manual Input"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildManualTextField(
                  weightController, "weight (kg)", Icons.monitor_weight),
              _buildManualTextField(
                  fatController, "bodyFatPercent (%)", Icons.pie_chart),
              _buildManualTextField(
                  muscleController, "muscleMass (kg)", Icons.fitness_center),
              _buildManualTextField(
                  visceralController, "visceralFat", Icons.opacity),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("cancel")),
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

  // ===== Save to Firestore =====
  Future<void> _saveReportToFirestore(Map<String, dynamic> metrics) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("please login to save reports")));
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

      await (widget.firestore ?? FirebaseFirestore.instance)
          .collection("users")
          .doc(auth.user!.uid)
          .collection("reports")
          .add(report.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The data has been successfully saved to the cloud.")));
      }
    } catch (e) {
      developer.log("Firestore Save Error", error: e, name: "upload_page");
    }
  }


  // ===== Logout =====
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
      final mqtt = Provider.of<MqttProvider>(context, listen: false);
      await auth.logout();
      mqtt.disconnect();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  @override
  void dispose() {
    if (widget.fileService == null) {
      _fileService.dispose();
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
                          const Text('Profile',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            auth.user?.email ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
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
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildFilePreview(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload Image / PDF"),
                  onPressed: _isProcessing ? null : _pickFile,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Manual Entry"),
                  onPressed: _showManualInputDialog,
                ),
              ],
            ),
            if (_isProcessing) ...[
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text("Processing... please wait",
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_extractedText,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Divider(),
                    if (_parsedMetrics.isNotEmpty) ...[
                      _buildMetricTile(
                          "weight", "${_parsedMetrics["weight"]} kg"),
                      _buildMetricTile("bodyFatPercent",
                          "${_parsedMetrics["bodyFatPercent"]} %"),
                      _buildMetricTile(
                          "muscleMass", "${_parsedMetrics["muscleMass"]} kg"),
                      _buildMetricTile(
                          "visceralFat", "${_parsedMetrics["visceralFat"]}"),
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

  // ===== File preview (images or PDF placeholder) =====
  Widget _buildFilePreview() {
    if (_fileBytes == null && _imageFile == null) {
      return Container(
        color: Colors.grey[200],
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images/sample_report.jpg",
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "SAMPLE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // PDF selected → show icon + filename
    if (_isPdf) {
      return Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _selectedFileName ?? "PDF File",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Image selected
    return Container(
      color: Colors.black,
      child: _fileBytes != null
          ? Image.memory(_fileBytes!, fit: BoxFit.contain)
          : !kIsWeb && _imageFile != null
              ? Image.file(File(_imageFile!.path), fit: BoxFit.contain)
              : const Center(
                  child: Text("Failed to load preview.",
                      style: TextStyle(color: Colors.white))),
    );
  }

  // ===== Metric tile =====
  Widget _buildMetricTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 15)),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  // ===== Manual text field =====
  Widget _buildManualTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}