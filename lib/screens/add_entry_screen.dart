import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/currency_utils.dart';
import '../widgets/top_message.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({
    super.key,
    required this.storage,
    this.existingTip,
    this.currencyCode = 'USD',
    this.roundUpEnabled = false,
    this.jobs = const <JobEntry>[],
    this.initialJobId,
  });

  final StorageService storage;

  /// When set, screen edits this tip instead of creating a new one.
  final TipEntry? existingTip;
  final String currencyCode;
  final bool roundUpEnabled;
  final List<JobEntry> jobs;
  final String? initialJobId;

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late DateTime _selectedDateTime;
  String _type = 'cash';
  String? _selectedJobId;

  bool get _isEditing => widget.existingTip != null;

  @override
  void initState() {
    super.initState();
    final TipEntry? e = widget.existingTip;
    _selectedJobId = e?.jobId ?? widget.initialJobId;
    if (_selectedJobId == null && widget.jobs.isNotEmpty) {
      _selectedJobId = widget.jobs.first.id;
    }
    if (e != null) {
      _amountController.text = e.amount == e.amount.roundToDouble()
          ? e.amount.toStringAsFixed(0)
          : e.amount.toStringAsFixed(2);
      _notesController.text = e.notes ?? '';
      _selectedDateTime = e.date.toLocal();
      _type = e.type.toLowerCase() == 'card' ? 'card' : 'cash';
    } else {
      _selectedDateTime = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  String? _validateAmount(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Amount is required';
    final double? n = double.tryParse(trimmed);
    if (n == null || n <= 0) return 'Enter a valid number';
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (widget.jobs.isNotEmpty && _selectedJobId == null) {
      showTopMessage(context, message: 'Please choose a job');
      return;
    }

    HapticFeedback.lightImpact();
    final double parsedAmount = double.parse(_amountController.text.trim());
    final double amount = widget.roundUpEnabled
        ? parsedAmount.ceilToDouble()
        : parsedAmount;
    final String notesTrimmed = _notesController.text.trim();

    if (_isEditing) {
      await widget.storage.updateTip(
        TipEntry(
          id: widget.existingTip!.id,
          amount: amount,
          date: _selectedDateTime,
          type: _type,
          notes: notesTrimmed.isEmpty ? null : notesTrimmed,
          jobId: _selectedJobId,
        ),
      );
    } else {
      await widget.storage.addTip(
        TipEntry(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          amount: amount,
          date: _selectedDateTime,
          type: _type,
          notes: notesTrimmed.isEmpty ? null : notesTrimmed,
          jobId: _selectedJobId,
        ),
      );
    }
    HapticFeedback.mediumImpact();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final String localeName = Localizations.localeOf(context).toString();
    final String dateLabel = DateFormat(
      'dd MMM yyyy',
      localeName,
    ).format(_selectedDateTime.toLocal());
    final String timeLabel = DateFormat(
      'hh:mm a',
      localeName,
    ).format(_selectedDateTime.toLocal());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(_isEditing ? 'Edit Tip' : 'Add Tip')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: '0.00',
                        prefixText:
                            '${currencySymbolFromCode(widget.currencyCode)} ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      validator: _validateAmount,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Note (optional)',
                        hintText: 'Shift, table, etc.',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    if (widget.jobs.isNotEmpty) ...<Widget>[
                      DropdownButtonFormField<String>(
                        value: _selectedJobId,
                        decoration: const InputDecoration(labelText: 'Job'),
                        items: widget.jobs
                            .map(
                              (JobEntry job) => DropdownMenuItem<String>(
                                value: job.id,
                                child: Text(job.title),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (String? value) {
                          setState(() => _selectedJobId = value);
                        },
                        validator: (String? value) {
                          if (widget.jobs.isEmpty) return null;
                          if (value == null || value.isEmpty) {
                            return 'Please choose a job';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      'Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const <ButtonSegment<String>>[
                        ButtonSegment<String>(
                          value: 'cash',
                          label: Text('Cash'),
                          icon: Icon(Icons.money),
                        ),
                        ButtonSegment<String>(
                          value: 'card',
                          label: Text('Card'),
                          icon: Icon(Icons.credit_card),
                        ),
                      ],
                      selected: <String>{_type},
                      onSelectionChanged: (Set<String> selection) {
                        setState(() => _type = selection.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.calendar_month_outlined),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                dateLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _pickTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.schedule),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                timeLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.brandOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Update Tip' : 'Save Tip',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
