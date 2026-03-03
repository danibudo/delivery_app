import 'package:flutter/material.dart';

enum DeliveryStatus { inProgress, delivered }

class CreateDelivery extends StatefulWidget {
  const CreateDelivery({super.key});

  @override
  State<CreateDelivery> createState() => _CreateDeliveryState();
}

class _CreateDeliveryState extends State<CreateDelivery> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleIdController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _startedAt;
  DateTime? _finishedAt;
  DeliveryStatus? _status;

  @override
  void dispose() {
    _vehicleIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context, {required bool isStarted}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final picked = DateTime.utc(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStarted) {
        _startedAt = picked;
      } else {
        _finishedAt = picked;
      }
    });
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} UTC';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Delivery')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              TextFormField(
                controller: _vehicleIdController,
                decoration: const InputDecoration(labelText: 'Vehicle ID'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              FormField<DateTime>(
                validator: (_) => _startedAt == null ? 'Required' : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_startedAt == null
                          ? 'Started at: not set'
                          : 'Started at: ${_formatDateTime(_startedAt!)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDateTime(context, isStarted: true),
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              FormField<DateTime>(
                validator: (_) => _finishedAt == null ? 'Required' : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_finishedAt == null
                          ? 'Finished at: not set'
                          : 'Finished at: ${_formatDateTime(_finishedAt!)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDateTime(context, isStarted: false),
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              DropdownButtonFormField<DeliveryStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                    value: DeliveryStatus.inProgress,
                    child: Text('In Progress'),
                  ),
                  DropdownMenuItem(
                    value: DeliveryStatus.delivered,
                    child: Text('Delivered'),
                  ),
                ],
                onChanged: (value) => setState(() => _status = value),
                validator: (value) => value == null ? 'Required' : null,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: submit
                  }
                },
                child: const Text('Create Delivery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}