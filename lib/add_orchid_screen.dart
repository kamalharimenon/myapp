import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/orchid_model.dart';

class AddOrchidScreen extends StatefulWidget {
  final List<Orchid> existingOrchids;
  const AddOrchidScreen({super.key, required this.existingOrchids});

  @override
  State<AddOrchidScreen> createState() => _AddOrchidScreenState();
}

class _AddOrchidScreenState extends State<AddOrchidScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- Controllers for Text Input ---
  final _genusController = TextEditingController();
  final _nameController = TextEditingController();
  final _purchasedFromController = TextEditingController();
  final _costController = TextEditingController();
  final _mediaController = TextEditingController();
  final _currentLocationController = TextEditingController();
  final _wateringScheduleController = TextEditingController();
  final _fertilizerUsedController = TextEditingController();
  final _fungicideUsedController = TextEditingController();
  final _insecticideUsedController = TextEditingController();
  final _remarksController = TextEditingController();

  // --- State variables for other input types ---
  Uint8List? _photoBytes;
  DateTime? _purchaseDate;
  DateTime? _lastFloweringDate;
  DateTime? _lastRepotDate;
  DateTime? _lastWateredDate;
  DateTime? _lastDosingDate;
  DateTime? _lastFungicideDate;
  DateTime? _lastInsecticideDate;

  SizeOption? _size;
  PottingStatus? _pottingStatus;
  Health? _health;
  LightRequirement? _lightRequirement;
  TemperatureRequirement? _temperatureRequirement;

  // --- Autocomplete Options ---
  late final List<String> _genusOptions;
  late final List<String> _purchasedFromOptions;
  late final List<String> _mediaOptions;
  late final List<String> _locationOptions;
  late final List<String> _fertilizerOptions;
  late final List<String> _fungicideOptions;
  late final List<String> _insecticideOptions;

  @override
  void initState() {
    super.initState();
    _genusOptions =
        widget.existingOrchids.map((o) => o.genus).whereType<String>().toSet().toList();
    _purchasedFromOptions = widget.existingOrchids
        .map((o) => o.purchasedFrom)
        .whereType<String>()
        .toSet()
        .toList();
    _mediaOptions = widget.existingOrchids
        .map((o) => o.media)
        .whereType<String>()
        .toSet()
        .toList();
     _locationOptions = widget.existingOrchids
        .map((o) => o.currentLocation)
        .whereType<String>()
        .toSet()
        .toList();
    _fertilizerOptions = widget.existingOrchids
        .map((o) => o.fertilizerUsed)
        .whereType<String>()
        .toSet()
        .toList();
    _fungicideOptions = widget.existingOrchids
        .map((o) => o.fungicideUsed)
        .whereType<String>()
        .toSet()
        .toList();
    _insecticideOptions = widget.existingOrchids
        .map((o) => o.insecticideUsed)
        .whereType<String>()
        .toSet()
        .toList();
  }

  @override
  void dispose() {
    // Dispose all controllers
    _genusController.dispose();
    _nameController.dispose();
    _purchasedFromController.dispose();
    _costController.dispose();
    _mediaController.dispose();
    _currentLocationController.dispose();
    _wateringScheduleController.dispose();
    _fertilizerUsedController.dispose();
    _fungicideUsedController.dispose();
    _insecticideUsedController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // --- Helper Methods ---
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1024);
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

  void _saveOrchid() {
    if (_formKey.currentState!.validate()) {
      final newOrchid = Orchid(
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
        lastFungicideDate: _lastFungicideDate,
        fungicideUsed: _fungicideUsedController.text,
        lastInsecticideDate: _lastInsecticideDate,
        insecticideUsed: _insecticideUsedController.text,
        remarks: _remarksController.text,
      );
      Navigator.of(context).pop(newOrchid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add New Orchid', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Photo ---
              _buildSectionHeader('Photo'),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: _photoBytes == null
                        ? Container(
                            height: 200,
                            width: 200,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 40),
                                SizedBox(height: 8),
                                Text('Tap to add photo'),
                              ],
                            ),
                          )
                        : Image.memory(
                            _photoBytes!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Basic Info ---
              _buildSectionHeader('Identification'),
              _buildAutocomplete(
                  'Genus', _genusController, _genusOptions, true),
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => v!.isEmpty ? 'Name is required' : null),
              const SizedBox(height: 24),

              // --- Purchase Details ---
              _buildSectionHeader('Purchase Details'),
              _buildDatePickerTile('Purchase Date', _purchaseDate,
                  (date) => setState(() => _purchaseDate = date)),
              _buildDropdown<SizeOption>(
                label: 'Size',
                value: _size,
                items: SizeOption.values,
                onChanged: (val) => setState(() => _size = val),
              ),
              _buildAutocomplete('Purchased From', _purchasedFromController,
                  _purchasedFromOptions),
              TextFormField(
                  controller: _costController,
                  decoration:
                      const InputDecoration(labelText: 'Cost', prefixText: '\$'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 24),

              // --- Growing Conditions ---
              _buildSectionHeader('Growing Conditions'),
              _buildDropdown<PottingStatus>(
                label: 'Potted or Mounted',
                value: _pottingStatus,
                items: PottingStatus.values,
                onChanged: (val) => setState(() => _pottingStatus = val),
              ),
              _buildAutocomplete('Media', _mediaController, _mediaOptions),
              _buildAutocomplete('Current Location',
                  _currentLocationController, _locationOptions),
              _buildDropdown<Health>(
                label: 'Health',
                value: _health,
                items: Health.values,
                onChanged: (val) => setState(() => _health = val),
              ),
              _buildDropdown<LightRequirement>(
                label: 'Light Requirement',
                value: _lightRequirement,
                items: LightRequirement.values,
                onChanged: (val) => setState(() => _lightRequirement = val),
              ),
              _buildDropdown<TemperatureRequirement>(
                label: 'Temperature Requirement',
                value: _temperatureRequirement,
                items: TemperatureRequirement.values,
                onChanged: (val) =>
                    setState(() => _temperatureRequirement = val),
              ),
              const SizedBox(height: 24),

              // --- Care Schedule ---
              _buildSectionHeader('Care Schedule'),
              _buildDatePickerTile('Last Flowering Date', _lastFloweringDate,
                  (date) => setState(() => _lastFloweringDate = date)),
              _buildDatePickerTile('Last Repot Date', _lastRepotDate,
                  (date) => setState(() => _lastRepotDate = date)),
              _buildDatePickerTile('Last Watered', _lastWateredDate,
                  (date) => setState(() => _lastWateredDate = date)),
              TextFormField(
                  controller: _wateringScheduleController,
                  decoration:
                      const InputDecoration(labelText: 'Watering Schedule')),
              const SizedBox(height: 24),

              // --- Treatments & Feeding ---
              _buildSectionHeader('Treatments & Feeding'),
              _buildDatePickerTile('Last Fertilizer Dosing', _lastDosingDate,
                  (date) => setState(() => _lastDosingDate = date)),
              _buildAutocomplete('Fertilizer Used', _fertilizerUsedController,
                  _fertilizerOptions),
              _buildDatePickerTile('Last Fungicide', _lastFungicideDate,
                  (date) => setState(() => _lastFungicideDate = date)),
              _buildAutocomplete('Fungicide Used', _fungicideUsedController,
                  _fungicideOptions),
              _buildDatePickerTile('Last Insecticide', _lastInsecticideDate,
                  (date) => setState(() => _lastInsecticideDate = date)),
              _buildAutocomplete('Insecticide Used',
                  _insecticideUsedController, _insecticideOptions),
              const SizedBox(height: 24),

              // --- Remarks ---
              _buildSectionHeader('Remarks'),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(labelText: 'Remarks'),
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _saveOrchid,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save to Collection'),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
        ),
      ),
    );
  }

  // --- Builder Widgets for Form Fields ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  Widget _buildDatePickerTile(
      String label, DateTime? date, Function(DateTime) onDateSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle:
          Text(date == null ? 'Not set' : DateFormat.yMMMd().format(date)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final pickedDate = await _selectDate(context, date);
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }

  Widget _buildDropdown<T extends Enum>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.name.toUpperCase()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildAutocomplete(String label, TextEditingController controller,
      List<String> options,
      [bool isRequired = false]) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(labelText: label),
          validator: (value) =>
              isRequired && value!.isEmpty ? '$label is required' : null,
        );
      },
    );
  }
}
