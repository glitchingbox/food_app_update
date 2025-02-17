import 'package:flutter/material.dart';
import 'package:food_app_prokit/services/order_class_helper.dart';
import 'package:food_app_prokit/utils/FlutterToast.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderOnline extends StatefulWidget {
  const OrderOnline({super.key});

  @override
  State<OrderOnline> createState() => _OrderOnlineState();
}

class _OrderOnlineState extends State<OrderOnline> {
  final FirestoreService _firestoreService = FirestoreService();

  void placeOrder() {
    _firestoreService.addOrder('Pizza', 2, 9.99).then((_) {
      Message.show(msg: "Order placed successfully!");
    }).catchError((error) {
      Message.show(msg:"Failed to place order: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: placeOrder,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
             gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(158, 228, 87, 90),
                                  food_colorPrimary,
                                ], // Change colors as needed
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.171),
              blurRadius: 15,
              spreadRadius: 0,
              offset: Offset(
                0,
                5,
              ),
            ),
          ],
        ),
        child: Text(food_lbl_order_online,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
            .center(),
      ),
    );
  }
}
