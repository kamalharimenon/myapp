import 'dart:typed_data';

enum Health { excellent, good, fair, poor }
enum LightRequirement { low, medium, high }
enum TemperatureRequirement { cool, intermediate, warm }
enum PottingStatus { potted, mounted }
enum SizeOption { ss, ms, bs } // SS: Small Seedling, MS: Medium Sized, BS: Blooming Size

class Orchid {
  final String genus;
  final String name;
  final Uint8List? photoBytes;
  final String? photoUrl;
  final DateTime? purchaseDate;
  final SizeOption? size;
  final String? purchasedFrom;
  final double? cost;
  final PottingStatus? pottingStatus;
  final String? media;
  final String? currentLocation;
  final Health? health;
  final DateTime? lastFloweringDate;
  final LightRequirement? lightRequirement;
  final TemperatureRequirement? temperatureRequirement;
  final DateTime? lastRepotDate;
  final String? wateringSchedule;
  final DateTime? lastWateredDate;
  final DateTime? lastDosingDate;
  final String? fertilizerUsed;
  final DateTime? lastFungicideDate;
  final String? fungicideUsed;
  final DateTime? lastInsecticideDate;
  final String? insecticideUsed;
  final String? remarks;

  Orchid({
    required this.genus,
    required this.name,
    this.photoBytes,
    this.photoUrl,
    this.purchaseDate,
    this.size,
    this.purchasedFrom,
    this.cost,
    this.pottingStatus,
    this.media,
    this.currentLocation,
    this.health,
    this.lastFloweringDate,
    this.lightRequirement,
    this.temperatureRequirement,
    this.lastRepotDate,
    this.wateringSchedule,
    this.lastWateredDate,
    this.lastDosingDate,
    this.fertilizerUsed,
    this.lastFungicideDate,
    this.fungicideUsed,
    this.lastInsecticideDate,
    this.insecticideUsed,
    this.remarks,
  });
}
