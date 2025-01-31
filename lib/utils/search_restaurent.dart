import 'package:flutter/material.dart';
import 'package:food_app_prokit/utils/FoodColors.dart';
import 'package:food_app_prokit/utils/FoodString.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchRestaurent extends StatefulWidget {
  const SearchRestaurent({
    super.key,
  });

  @override
  State<SearchRestaurent> createState() => _SearchRestaurentState();
}

class _SearchRestaurentState extends State<SearchRestaurent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: defaultBoxShadow(spreadRadius: 3.0),
      ),
      child: TextField(
        onChanged: (value){
          setState(() {
            food_hint_search_restaurants = value;
          });
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: food_white,
          hintText: food_hint_search_restaurants,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),

          contentPadding: EdgeInsets.only(left: 26.0, bottom: 8.0, top: 8.0, right: 50.0),
        ),
      ),
      alignment: Alignment.center,
    );
  }
}