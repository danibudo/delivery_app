import 'package:flutter/material.dart';
import '../model/delivery_status.dart';
import '../components/form_field_date_time.dart';

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

  Widget _buildVehicleIdField() {
    return TextFormField(
      controller: _vehicleIdController,
      decoration: const InputDecoration(labelText: 'Vehicle ID'),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(labelText: 'Address'),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildStartedAtField() {
    return FormFieldDateTime(
      label: 'Started at',
      value: _startedAt,
      onChanged: (picked) => setState(() => _startedAt = picked),
      validator: (_) => _startedAt == null ? 'Required' : null,
    );
  }

  Widget _buildFinishedAtField() {
    return FormFieldDateTime(
      label: 'Finished at',
      value: _finishedAt,
      onChanged: (picked) => setState(() => _finishedAt = picked),
      validator: (_) {
        if (_finishedAt == null) return 'Required for delivered status';
        if (_startedAt != null && !_finishedAt!.isAfter(_startedAt!)) {
          return 'Must be after Started at';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<DeliveryStatus>(
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
      onChanged: (value) => setState(() {
        _status = value;
        if (value == DeliveryStatus.inProgress) _finishedAt = null;
      }),
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // TODO: submit
        }
      },
      child: const Text('Create Delivery'),
    );
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
              _buildVehicleIdField(),
              _buildAddressField(),
              _buildStartedAtField(),
              if (_status == DeliveryStatus.delivered) _buildFinishedAtField(),
              _buildStatusDropdown(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}