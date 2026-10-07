import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/training_checkpoint.dart';
import '../../logic/providers/checkpoint_provider.dart';
import 'widgets/checkpoint_form_validation.dart';
import 'widgets/checkpoint_labels.dart';

class AddCheckpointPage extends StatefulWidget {
  const AddCheckpointPage({super.key});
  @override
  State<AddCheckpointPage> createState() => _AddCheckpointPageState();
}

class _AddCheckpointPageState extends State<AddCheckpointPage> {
  final _form = GlobalKey<FormState>();
  final _exercise = TextEditingController();
  final _load = TextEditingController();
  final _unit = TextEditingController(text: 'kg');
  final _sets = TextEditingController();
  final _reps = TextEditingController();
  final _rpe = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();
  CheckpointSide _side = CheckpointSide.notApplicable;
  CameraAngle _angle = CameraAngle.side;
  PlatformFile? _video;
  bool _saving = false;
  bool _picking = false;
  String? _videoError;

  @override
  void dispose() {
    for (final controller in [
      _exercise,
      _load,
      _unit,
      _sets,
      _reps,
      _rpe,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _maxVideoBytes =>
      Provider.of<CheckpointProvider?>(context, listen: false)?.maxVideoBytes ??
      defaultMaxVideoBytes;

  String? _validateVideo(PlatformFile? video) => requiredVideo(
    video?.path,
    fileName: video?.name,
    sizeBytes: video?.size,
    maxSizeBytes: _maxVideoBytes,
  );

  Future<void> _pickVideo() async {
    setState(() => _picking = true);
    try {
      final selection = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'm4v'],
        withData: false,
        allowCompression: false,
      );
      if (!mounted) return;
      if (selection != null && selection.files.isNotEmpty) {
        final video = selection.files.single;
        setState(() {
          _videoError = _validateVideo(video);
          _video = _videoError == null ? video : null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _videoError = 'Unable to open Files. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    final valid = _form.currentState!.validate();
    setState(() => _videoError = _validateVideo(_video));
    if (!valid || _videoError != null) return;
    setState(() => _saving = true);
    try {
      await context.read<CheckpointProvider>().saveCheckpoint(
        checkpointDate: _date,
        exerciseName: _exercise.text.trim(),
        side: _side,
        cameraAngle: _angle,
        video: _video!,
        load: double.tryParse(_load.text.trim()),
        loadUnit: _unit.text.trim().isEmpty ? 'kg' : _unit.text.trim(),
        sets: int.tryParse(_sets.text.trim()),
        reps: int.tryParse(_reps.text.trim()),
        rpe: double.tryParse(_rpe.text.trim()),
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is CheckpointOperationException
                  ? error.message
                  : error is ArgumentError && error.message is String
                  ? error.message as String
                  : 'Unable to save checkpoint. Please try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _numeric(
    String label,
    TextEditingController controller, {
    bool integer = false,
    bool rpe = false,
  }) => TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    keyboardType: TextInputType.numberWithOptions(decimal: !integer),
    validator: (value) => optionalNumber(value, integer: integer, rpe: rpe),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Checkpoint')),
      body: kIsWeb
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Adding local video checkpoints is currently available on mobile.',
                ),
              ),
            )
          : PopScope(
              canPop: !_saving,
              child: AbsorbPointer(
                absorbing: _saving,
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'The video stays on this device. Only checkpoint metadata is synced.',
                        ),
                        Text(
                          'MP4, MOV, or M4V, up to ${(_maxVideoBytes / (1024 * 1024)).toStringAsFixed(0)} MB.',
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Date'),
                          subtitle: Text(DateFormat.yMMMd().format(_date)),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (date != null && mounted) {
                              setState(() => _date = date);
                            }
                          },
                        ),
                        TextFormField(
                          controller: _exercise,
                          decoration: const InputDecoration(
                            labelText: 'Exercise name',
                          ),
                          validator: requiredExercise,
                        ),
                        DropdownButtonFormField<CheckpointSide>(
                          initialValue: _side,
                          decoration: const InputDecoration(labelText: 'Side'),
                          items: CheckpointSide.values
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(sideLabel(s)),
                                ),
                              )
                              .toList(),
                          onChanged: (s) => setState(() => _side = s!),
                        ),
                        DropdownButtonFormField<CameraAngle>(
                          initialValue: _angle,
                          decoration: const InputDecoration(
                            labelText: 'Camera angle',
                          ),
                          items: CameraAngle.values
                              .map(
                                (a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(angleLabel(a)),
                                ),
                              )
                              .toList(),
                          onChanged: (a) => setState(() => _angle = a!),
                        ),
                        _numeric('Load (optional)', _load),
                        TextFormField(
                          controller: _unit,
                          decoration: const InputDecoration(
                            labelText: 'Load unit',
                          ),
                          validator: optionalLoadUnit,
                        ),
                        _numeric('Sets (optional)', _sets, integer: true),
                        _numeric('Reps (optional)', _reps, integer: true),
                        _numeric('RPE (1–10, optional)', _rpe, rpe: true),
                        TextFormField(
                          controller: _notes,
                          decoration: const InputDecoration(
                            labelText: 'Notes (optional)',
                          ),
                          maxLines: 3,
                          validator: optionalNotes,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _picking ? null : _pickVideo,
                          icon: const Icon(Icons.folder_open),
                          label: Text(
                            _picking
                                ? 'Opening Files…'
                                : 'Select video from Files',
                          ),
                        ),
                        if (_video != null)
                          Text(
                            '${_video!.name} • ${(_video!.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                          ),
                        if (_videoError != null)
                          Text(
                            _videoError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _saving || _picking ? null : _save,
                          child: _saving
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        'Copying video and saving metadata…',
                                      ),
                                    ),
                                  ],
                                )
                              : const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
