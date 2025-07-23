import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/orchid_model.dart';

class OrchidDetailScreen extends StatelessWidget {
  final Orchid orchid;

  const OrchidDetailScreen({super.key, required this.orchid});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(orchid.name, style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (orchid.photoBytes != null)
              Center(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.memory(
                    orchid.photoBytes!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            _buildSectionHeader('Identification', textTheme),
            _buildDetailRow('Genus:', orchid.genus, textTheme),
            _buildDetailRow('Name:', orchid.name, textTheme),
            const SizedBox(height: 16),

            _buildSectionHeader('Purchase Details', textTheme),
            _buildDetailRow('Purchase Date:', _formatDate(orchid.purchaseDate), textTheme),
            _buildDetailRow('Size:', orchid.size?.name.toUpperCase(), textTheme),
            _buildDetailRow('Purchased From:', orchid.purchasedFrom, textTheme),
            _buildDetailRow('Cost:', orchid.cost?.toStringAsFixed(2), textTheme, prefix: '\$'),
            const SizedBox(height: 16),

             _buildSectionHeader('Growing Conditions', textTheme),
            _buildDetailRow('Potted/Mounted:', orchid.pottingStatus?.name, textTheme),
            _buildDetailRow('Media:', orchid.media, textTheme),
            _buildDetailRow('Location:', orchid.currentLocation, textTheme),
            _buildDetailRow('Health:', orchid.health?.name, textTheme),
            _buildDetailRow('Light:', orchid.lightRequirement?.name, textTheme),
            _buildDetailRow('Temperature:', orchid.temperatureRequirement?.name, textTheme),
            const SizedBox(height: 16),
            
            _buildSectionHeader('Care Schedule', textTheme),
            _buildDetailRow('Last Flowering:', _formatDate(orchid.lastFloweringDate), textTheme),
            _buildDetailRow('Last Repot:', _formatDate(orchid.lastRepotDate), textTheme),
            _buildDetailRow('Last Watered:', _formatDate(orchid.lastWateredDate), textTheme),
            _buildDetailRow('Watering Schedule:', orchid.wateringSchedule, textTheme),

            const SizedBox(height: 16),

            _buildSectionHeader('Treatments & Feeding', textTheme),
            _buildDetailRow('Last Fertilizer:', _formatDate(orchid.lastDosingDate), textTheme),
            _buildDetailRow('Fertilizer Used:', orchid.fertilizerUsed, textTheme),
            _buildDetailRow('Last Fungicide:', _formatDate(orchid.lastFungicideDate), textTheme),
            _buildDetailRow('Fungicide Used:', orchid.fungicideUsed, textTheme),
            _buildDetailRow('Last Insecticide:', _formatDate(orchid.lastInsecticideDate), textTheme),
            _buildDetailRow('Insecticide Used:', orchid.insecticideUsed, textTheme),
            const SizedBox(height: 16),
            
            _buildSectionHeader('Remarks', textTheme),
            _buildDetailRow('', orchid.remarks, textTheme),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
      ),
    );
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat.yMMMd().format(date);
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildDetailRow(String label, String? value, TextTheme textTheme, {String prefix = ''}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text('$prefix$value', style: textTheme.bodyLarge),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideX(begin: -0.1, end: 0);
  }
}
