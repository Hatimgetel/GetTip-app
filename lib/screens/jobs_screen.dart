import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/job_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'add_job_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({
    super.key,
    required this.storage,
    required this.currencyCode,
    required this.activeJobId,
  });

  final StorageService storage;
  final String currencyCode;
  final String? activeJobId;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<JobEntry> _jobs = <JobEntry>[];
  bool _loading = true;
  String? _activeJobId;

  @override
  void initState() {
    super.initState();
    _activeJobId = widget.activeJobId;
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final List<JobEntry> jobs = await widget.storage.loadJobs();
    if (!mounted) return;
    setState(() {
      _jobs = jobs;
      _loading = false;
      if (_activeJobId != null &&
          !_jobs.any((JobEntry j) => j.id == _activeJobId)) {
        _activeJobId = null;
      }
      if (_jobs.isNotEmpty && _activeJobId == null) {
        _activeJobId = _jobs.first.id;
      }
    });
  }

  Future<void> _addJob() async {
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => AddJobScreen(
          storage: widget.storage,
          currencyCode: widget.currencyCode,
        ),
      ),
    );
    if (saved == true) {
      await _loadJobs();
    }
  }

  Future<void> _editJob(JobEntry job) async {
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => AddJobScreen(
          storage: widget.storage,
          currencyCode: widget.currencyCode,
          existingJob: job,
        ),
      ),
    );
    if (saved == true) {
      await _loadJobs();
    }
  }

  Future<void> _deleteJob(JobEntry job) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteJobTitle),
          content: Text(
            l10n.deleteJobBody(_jobDisplayName(job)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await widget.storage.deleteJob(job.id);
    await _loadJobs();
  }

  String _jobDisplayName(JobEntry job) {
    final String employer = (job.employer ?? '').trim();
    if (employer.isEmpty) return job.title;
    return '${job.title} — $employer';
  }

  void _confirmSelection() {
    Navigator.of(context).pop<String?>(_activeJobId);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final Color onSurface = theme.colorScheme.onSurface;
    final Color muted = theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.jobs,
          style: TextStyle(
            color: onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 34,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _confirmSelection,
            child: Text(
              l10n.done,
              style: TextStyle(
                color: AppTheme.brandOrangeDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_jobs',
        onPressed: _addJob,
        backgroundColor: AppTheme.brandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.brandOrange),
            )
          : _jobs.isEmpty
          ? Center(
              child: Text(
                l10n.noJobsYet,
                style: TextStyle(color: muted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: _jobs.length,
              itemBuilder: (BuildContext context, int index) {
                final JobEntry job = _jobs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    leading: Radio<String>(
                      value: job.id,
                      groupValue: _activeJobId,
                      activeColor: AppTheme.brandOrange,
                      onChanged: (String? value) {
                        setState(() => _activeJobId = value);
                      },
                    ),
                    title: Row(
                      children: <Widget>[
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _jobColorFromKey(job.colorKey),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: job.employer == null
                        ? null
                        : Text(
                            job.employer!,
                            style: TextStyle(color: muted),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => _editJob(job),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppTheme.brandOrangeDeep,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteJob(job),
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => setState(() => _activeJobId = job.id),
                  ),
                );
              },
            ),
    );
  }
}

Color _jobColorFromKey(String colorKey) {
  switch (colorKey) {
    case 'green':
      return const Color(0xFF4CAF50);
    case 'blue':
      return const Color(0xFF2196F3);
    case 'red':
      return const Color(0xFFE53935);
    case 'orange':
      return const Color(0xFFFF9800);
    case 'purple':
      return const Color(0xFF9C27B0);
    case 'pink':
      return const Color(0xFFE91E63);
    case 'teal':
      return const Color(0xFF009688);
    default:
      return AppTheme.brandOrange;
  }
}
