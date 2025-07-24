import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/orchid_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save orchid data to Firestore
  Future<void> saveOrchid(Orchid orchid) async {
    await _db.collection('orchids').add(orchid.toMap());
  }

  // Get a stream of orchids from Firestore
  Stream<List<Orchid>> getOrchids() {
    return _db.collection('orchids').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Orchid.fromFirestore(doc)).toList());
  }
}
