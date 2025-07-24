import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Orchid {
  String? id;
  String genus;
  String name;
  Uint8List? photoBytes;
  DateTime? purchaseDate;
  String? size;
  String? purchasedFrom;
  double? cost;
  String? pottingStatus;
  String? media;
  String? currentLocation;
  String? health;
  DateTime? lastFloweringDate;
  String? lightRequirement;
  String? temperatureRequirement;
  DateTime? lastRepotDate;
  String? wateringSchedule;
  DateTime? lastWateredDate;
  DateTime? lastDosingDate;
  String? fertilizerUsed;

  Orchid({
    this.id,
    required this.genus,
    required this.name,
    this.photoBytes,
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
  });

  // Convert an Orchid object into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'genus': genus,
      'name': name,
      'photoBytes': photoBytes != null ? Blob(photoBytes!) : null, // Firestore Blob type
      'purchaseDate': purchaseDate != null ? Timestamp.fromDate(purchaseDate!) : null,
      'size': size,
      'purchasedFrom': purchasedFrom,
      'cost': cost,
      'pottingStatus': pottingStatus,
      'media': media,
      'currentLocation': currentLocation,
      'health': health,
      'lastFloweringDate': lastFloweringDate != null ? Timestamp.fromDate(lastFloweringDate!) : null,
      'lightRequirement': lightRequirement,
      'temperatureRequirement': temperatureRequirement,
      'lastRepotDate': lastRepotDate != null ? Timestamp.fromDate(lastRepotDate!) : null,
      'wateringSchedule': wateringSchedule,
      'lastWateredDate': lastWateredDate != null ? Timestamp.fromDate(lastWateredDate!) : null,
      'lastDosingDate': lastDosingDate != null ? Timestamp.fromDate(lastDosingDate!) : null,
      'fertilizerUsed': fertilizerUsed,
    };
  }

  // Create an Orchid object from a Firestore document snapshot
  factory Orchid.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Orchid(
      id: doc.id,
      genus: data['genus'] ?? '',
      name: data['name'] ?? '',
      photoBytes: data['photoBytes'] != null ? (data['photoBytes'] as Blob).bytes : null,
      purchaseDate: data['purchaseDate'] != null ? (data['purchaseDate'] as Timestamp).toDate() : null,
      size: data['size'],
      purchasedFrom: data['purchasedFrom'],
      cost: data['cost']?.toDouble(),
      pottingStatus: data['pottingStatus'],
      media: data['media'],
      currentLocation: data['currentLocation'],
      health: data['health'],
      lastFloweringDate: data['lastFloweringDate'] != null ? (data['lastFloweringDate'] as Timestamp).toDate() : null,
      lightRequirement: data['lightRequirement'],
      temperatureRequirement: data['temperatureRequirement'],
      lastRepotDate: data['lastRepotDate'] != null ? (data['lastRepotDate'] as Timestamp).toDate() : null,
      wateringSchedule: data['wateringSchedule'],
      lastWateredDate: data['lastWateredDate'] != null ? (data['lastWateredDate'] as Timestamp).toDate() : null,
      lastDosingDate: data['lastDosingDate'] != null ? (data['lastDosingDate'] as Timestamp).toDate() : null,
      fertilizerUsed: data['fertilizerUsed'],
    );
  }
}
