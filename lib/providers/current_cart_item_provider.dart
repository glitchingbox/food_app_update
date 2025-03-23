import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app_prokit/model/FoodModel.dart';

class CurrentCartItems extends Notifier<Map<String,Map<String,dynamic>>?>{ // the map will look like {biscuit:{item:FoodDish(object),count:1}}
  @override
  Map<String,Map<String,dynamic>>? build()
  {
    return null;
  }


  void addNewItemToCart(FoodDish item){
    Map<String,Map<String,dynamic>>? currentCartMap= Map<String, Map<String, dynamic>>.from(state ?? {});
    if(currentCartMap=={})
      {

        currentCartMap={item.name:{"item":item,"count":1}};

      }
    else{
      currentCartMap[item.name]={"item":item,"count":1};

    }

    state=Map.from(currentCartMap);
  }

  void updateItemCount(FoodDish item,int count){// this only gets called once an item is added to cart so cart will be non null or not empty {}  , as increment buttons will only be shown when an cartItem is added and visibility is made true

    Map<String,Map<String,dynamic>>? currentCartMap=Map<String, Map<String, dynamic>>.from(state ?? {});
    if(count==0 || count<0)
    {
    currentCartMap.remove(item.name);// current cart map will be non null or {} as we have to add an item then reduce it ad whenreceved count is below zero the visibility will false so thi function onl called agin once we add the item to cart again

    }
    else{

      currentCartMap[item.name]!.update("count",(value)=>count);

    }
    state=currentCartMap;
  }
}



final currentCartItemsProvider=NotifierProvider<CurrentCartItems, Map<String,Map<String,dynamic>>?>((){
  return CurrentCartItems();
});