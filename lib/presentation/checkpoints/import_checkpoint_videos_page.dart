import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/checkpoint_provider.dart';
import 'add_checkpoint_page.dart';

enum _ImportStatus { pending, saved, failed, skipped }

class _VideoCandidate {
  _VideoCandidate(this.file);
  final PlatformFile file;
  _ImportStatus status = _ImportStatus.pending;
}

class ImportCheckpointVideosPage extends StatefulWidget {
  const ImportCheckpointVideosPage({super.key});

  @override
  State<ImportCheckpointVideosPage> createState() =>
      _ImportCheckpointVideosPageState();
}

class _ImportCheckpointVideosPageState
    extends State<ImportCheckpointVideosPage> {
  final List<_VideoCandidate> _candidates = [];
  bool _picking = false;
  bool _reviewing = false;
  String? _error;

  Future<void> _pick({required bool folder}) async {
    setState(() {
      _picking = true;
      _error = null;
    });
    try {
      List<PlatformFile>? files;
      if (folder) {
        final directory = await FilePicker.platform.getDirectoryPath();
        if (directory != null && mounted) {
          files = await context
              .read<CheckpointProvider>()
              .localVideoService
              .scanDirectory(directory);
        }
      } else {
        final selection = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['mp4', 'mov', 'm4v'],
          allowMultiple: true,
          withData: false,
          allowCompression: false,
        );
        files = selection?.files;
      }
      if (!mounted || files == null) return;
      setState(() {
        for (final file in files!) {
          if (!_candidates.any(
            (candidate) => candidate.file.path == file.path,
          )) {
            _candidates.add(_VideoCandidate(file));
          }
        }
        if (files.isEmpty) _error = 'No MP4, MOV, or M4V videos were found.';
      });
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = folder
              ? 'Unable to open this folder. Try selecting video files instead.'
              : 'Unable to open Files. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _review(_VideoCandidate candidate) async {
    final provider = context.read<CheckpointProvider>();
    var failed = false;
    setState(() => _reviewing = true);
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: AddCheckpointPage(
            initialVideo: candidate.file,
            requireDateConfirmation: true,
            onSaveError: () => failed = true,
          ),
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _reviewing = false;
      candidate.status = saved == true
          ? _ImportStatus.saved
          : failed
          ? _ImportStatus.failed
          : _ImportStatus.pending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckpointProvider>();
    final saved = _candidates
        .where((candidate) => candidate.status == _ImportStatus.saved)
        .length;
    final skipped = _candidates
        .where((candidate) => candidate.status == _ImportStatus.skipped)
        .length;
    final busy = _picking || _reviewing;
    final canReview = !busy && !provider.isLoading && provider.error == null;
    return Scaffold(
      appBar: AppBar(title: const Text('Import videos')),
      body: kIsWeb
          ? const Center(
              child: Text(
                'Local video imports are unavailable in the web app.',
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Review each video and enter its workout details. Originals stay intact; a separate copy is stored on this device. Only metadata syncs.',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: busy ? null : () => _pick(folder: true),
                            icon: const Icon(Icons.folder_open),
                            label: const Text('Choose folder'),
                          ),
                          OutlinedButton.icon(
                            onPressed: busy ? null : () => _pick(folder: false),
                            icon: const Icon(Icons.video_library),
                            label: const Text('Select videos'),
                          ),
                        ],
                      ),
                      if (_picking) const LinearProgressIndicator(),
                      if (provider.isLoading)
                        const Text(
                          'Loading checkpoints before checking for duplicates…',
                        ),
                      if (provider.error != null)
                        Text(
                          provider.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      if (_error != null)
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      if (_candidates.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          '$saved saved • $skipped skipped • ${_candidates.length - saved - skipped} remaining',
                        ),
                        LinearProgressIndicator(
                          value: (saved + skipped) / _candidates.length,
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: _candidates.isEmpty
                      ? const Center(
                          child: Text(
                            'Choose a folder or select videos to get started.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: _candidates.length,
                          itemBuilder: (context, index) {
                            final candidate = _candidates[index];
                            final completed =
                                candidate.status == _ImportStatus.saved;
                            final skipped =
                                candidate.status == _ImportStatus.skipped;
                            return ListTile(
                              title: Text(candidate.file.name),
                              subtitle: Text(
                                '${(candidate.file.size / (1024 * 1024)).toStringAsFixed(1)} MB • ${candidate.status.name}',
                              ),
                              leading: Icon(
                                completed
                                    ? Icons.check_circle
                                    : Icons.video_file,
                              ),
                              trailing: Wrap(
                                children: [
                                  if (!completed)
                                    TextButton(
                                      onPressed: canReview
                                          ? () => _review(candidate)
                                          : null,
                                      child: Text(
                                        candidate.status == _ImportStatus.failed
                                            ? 'Retry'
                                            : 'Review',
                                      ),
                                    ),
                                  if (!completed && !skipped)
                                    IconButton(
                                      tooltip: 'Skip video',
                                      onPressed: busy
                                          ? null
                                          : () => setState(
                                              () => candidate.status =
                                                  _ImportStatus.skipped,
                                            ),
                                      icon: const Icon(Icons.skip_next),
                                    ),
                                  if (!completed)
                                    IconButton(
                                      tooltip: 'Remove from import list',
                                      onPressed: busy
                                          ? null
                                          : () => setState(
                                              () =>
                                                  _candidates.remove(candidate),
                                            ),
                                      icon: const Icon(Icons.close),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
