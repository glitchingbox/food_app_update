import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class DataHelpper {
  Future foodApp(Map<String, dynamic> foodMapInfo , String id)async{
   return await FirebaseFirestore.instance.collection('food').doc(id).set(foodMapInfo);
  }



  //Update

Future updateData(String id, Map<String,dynamic> updateDetils)async{
  return  await FirebaseFirestore.instance.collection('food').doc(id).update(updateDetils);

}

}