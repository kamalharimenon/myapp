
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/orchid_model.dart'; // Import the Orchid model


class AddOrchidScreen extends StatefulWidget {
  const AddOrchidScreen({
    super.key,
  });

  @override
  State<AddOrchidScreen> createState() => _AddOrchidScreenState();
}

class _AddOrchidScreenState extends State<AddOrchidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _genusController = TextEditingController();
  final _nameController = TextEditingController();
  final _purchasedFromController = TextEditingController();
  final _costController = TextEditingController();
  final _mediaController = TextEditingController();
  final _currentLocationController = TextEditingController();
  final _wateringScheduleController = TextEditingController();
  Uint8List? _photoBytes;
  DateTime? _purchaseDate;
  String? _size;
  String? _pottingStatus;
  String? _health;
  DateTime? _lastFloweringDate;
  String? _lightRequirement;
  String? _temperatureRequirement;
  DateTime? _lastRepotDate;
  DateTime? _lastWateredDate;
  DateTime? _lastDosingDate;
  final _fertilizerUsedController = TextEditingController();

  // final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _genusController.dispose();
    _nameController.dispose();
    _purchasedFromController.dispose();
    _costController.dispose();
    _mediaController.dispose();
    _currentLocationController.dispose();
    _wateringScheduleController.dispose();
    _fertilizerUsedController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _photoBytes = bytes;
      });
    }
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now()
          .add(const Duration(days: 365)), // Allow future dates for schedules
    );
  }

  void _saveOrchid() async { // Make the function async
    if (_formKey.currentState!.validate()) {
       Orchid(
        genus: _genusController.text,
        name: _nameController.text,
        photoBytes: _photoBytes,
        purchaseDate: _purchaseDate,
        size: _size,
        purchasedFrom: _purchasedFromController.text,
        cost: double.tryParse(_costController.text),
        pottingStatus: _pottingStatus,
        media: _mediaController.text,
        currentLocation: _currentLocationController.text,
        health: _health,
        lastFloweringDate: _lastFloweringDate,
        lightRequirement: _lightRequirement,
        temperatureRequirement: _temperatureRequirement,
        lastRepotDate: _lastRepotDate,
        wateringSchedule: _wateringScheduleController.text,
        lastWateredDate: _lastWateredDate,
        lastDosingDate: _lastDosingDate,
        fertilizerUsed: _fertilizerUsedController.text,
        // Add other fields as needed
      );
      // await _firestoreService.addOrchid(newOrchid); // Save to Firestore
      Navigator.pop(context); // Close the add screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Orchid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _genusController,
                decoration: const InputDecoration(labelText: 'Genus'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the genus';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              // Photo upload field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Photo (Optional)'),
                    const SizedBox(height: 8.0),
                    _photoBytes != null
                        ? Image.memory(
                      _photoBytes!,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(onPressed: _pickImage, child: const Text('Pick Image')),
                  ],
                ),
              ),
              // Purchase Date Field
              GestureDetector(
                onTap: () async {
                  final selectedDate = await _selectDate(context, _purchaseDate);
                  if (selectedDate != null) {
                    setState(() {
                      _purchaseDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Purchase Date (Optional)',
                  ),
                  baseStyle: Theme.of(context).textTheme.bodyMedium,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _purchaseDate == null
                            ? 'Select Date'
                            : DateFormat.yMd().format(_purchaseDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              // Size Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Size (Optional)'),
                value: _size,
                onChanged: (newValue) {
                  setState(() {
                    _size = newValue;
                  });
                },
                items: <String>['Seedling', 'Small', 'Medium', 'Large', 'Mounted']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _purchasedFromController,
                decoration: const InputDecoration(labelText: 'Purchased From (Optional)'),
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost', prefixText: '\$'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // Add validator if cost is required and needs specific format
              ),
              // Potting Status Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Potting Status (Optional)'),
                value: _pottingStatus,
                onChanged: (newValue) {
                  setState(() {
                    _pottingStatus = newValue;
                  });
                },
                items: <String>['Potted', 'Mounted', 'Bare Root']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _mediaController,
                decoration: const InputDecoration(labelText: 'Media (Optional)'),
              ),
              TextFormField(
                controller: _currentLocationController,
                decoration: const InputDecoration(labelText: 'Current Location (Optional)'),
              ),
              // Health Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Health (Optional)'),
                value: _health,
                onChanged: (newValue) {
                  setState(() {
                    _health = newValue;
                  });
                },
                items: <String>['Excellent', 'Good', 'Fair', 'Poor']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Last Flowering Date Field
              GestureDetector(
                onTap: () async {
                  final selectedDate = await _selectDate(context, _lastFloweringDate);
                  if (selectedDate != null) {
                    setState(() {
                      _lastFloweringDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Last Flowering Date (Optional)',
                  ),
                  baseStyle: Theme.of(context).textTheme.bodyMedium,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _lastFloweringDate == null
                            ? 'Select Date'
                            : DateFormat.yMd().format(_lastFloweringDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              // Light Requirement Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Light Requirement (Optional)'),
                value: _lightRequirement,
                onChanged: (newValue) {
                  setState(() {
                    _lightRequirement = newValue;
                  });
                },
                items: <String>['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Temperature Requirement Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Temperature Requirement (Optional)'),
                value: _temperatureRequirement,
                onChanged: (newValue) {
                  setState(() {
                    _temperatureRequirement = newValue;
                  });
                },
                items: <String>['Cool', 'Intermediate', 'Warm']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Last Repot Date Field
              GestureDetector(
                onTap: () async {
                  final selectedDate = await _selectDate(context, _lastRepotDate);
                  if (selectedDate != null) {
                    setState(() {
                      _lastRepotDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Last Repot Date (Optional)',
                  ),
                  baseStyle: Theme.of(context).textTheme.bodyMedium,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _lastRepotDate == null
                            ? 'Select Date'
                            : DateFormat.yMd().format(_lastRepotDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _wateringScheduleController,
                decoration: const InputDecoration(labelText: 'Watering Schedule (Optional)'),
              ),
              // Last Watered Date Field
              GestureDetector(
                onTap: () async {
                  final selectedDate = await _selectDate(context, _lastWateredDate);
                  if (selectedDate != null) {
                    setState(() {
                      _lastWateredDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Last Watered Date (Optional)',
                  ),
                  baseStyle: Theme.of(context).textTheme.bodyMedium,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _lastWateredDate == null
                            ? 'Select Date'
                            : DateFormat.yMd().format(_lastWateredDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              // Last Dosing Date Field
              GestureDetector(
                onTap: () async {
                  final selectedDate = await _selectDate(context, _lastDosingDate);
                  if (selectedDate != null) {
                    setState(() {
                      _lastDosingDate = selectedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Last Dosing Date (Optional)',
                  ),
                  baseStyle: Theme.of(context).textTheme.bodyMedium,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _lastDosingDate == null
                            ? 'Select Date'
                            : DateFormat.yMd().format(_lastDosingDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _fertilizerUsedController,
                decoration: const InputDecoration(labelText: 'Fertilizer Used (Optional)'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: _saveOrchid,
                  child: const Text('Save Orchid'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
