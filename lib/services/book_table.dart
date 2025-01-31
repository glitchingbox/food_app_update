import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';

class FirestoreServiceBookTable {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReservation(int people, String date, String time, String foodPreference) async {
    try {
      await _firestore.collection('reservations').add({
        'people': people,
        'date': date,
        'time': time,
        'foodPreference': foodPreference,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Message.show(msg: "Reservation added successfully!");
    } catch (e) {
      Message.show(msg: "Error adding reservation: $e");
      throw e; 
    }
  }
}
