import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder(String itemName, int quantity, double price) async {
    try {
      await _firestore.collection('orders').add({
        'itemName': itemName,
        'quantity': quantity,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
      });
      // print("Order added successfully!");
      Message.show(msg: "Order added successfully!");
    } catch (e) {
      Message.show(msg: "Error adding order: $e");
    }
  }

  addReservation(int parse, String formatted, String time, String foodPreference) {}
}