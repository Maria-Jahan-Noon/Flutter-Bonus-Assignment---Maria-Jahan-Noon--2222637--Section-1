import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/coffee_records_model.dart';

class CoffeeStateManagement {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = "coffee_records";
  final Uuid _uuid = const Uuid();

  // READ (real-time) — used with StreamBuilder
  Stream<List<CoffeeRecordsModel>> getRecordsStream() {
    return _firestore
        .collection(_collectionPath)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] =
              (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }
        return CoffeeRecordsModel.fromJson(data);
      }).toList();
    });
  }

  // CREATE — send data to Firebase
  Future<void> addCoffeeRecord(CoffeeRecordsModel record) async {
    final String newId = _uuid.v4();
    final CoffeeRecordsModel newRecord = CoffeeRecordsModel(
      id: newId,
      beanOrigin: record.beanOrigin,
      roastProfile: record.roastProfile,
      brewMethod: record.brewMethod,
      tastingNotes: record.tastingNotes,
      rating: record.rating,
      createdAt: DateTime.now(),
    );
    await _firestore
        .collection(_collectionPath)
        .doc(newId)
        .set(newRecord.toJson());
  }

  // UPDATE
  Future<void> updateRecord(
      String docId, Map<String, dynamic> updatedData) async {
    await _firestore.collection(_collectionPath).doc(docId).update(updatedData);
  }

  // DELETE
  Future<void> deleteRecord(String docId) async {
    await _firestore.collection(_collectionPath).doc(docId).delete();
  }
}