
import 'package:kol/map.dart';

import '../../../../core/models/menu_models/category_model.dart';
import '../../../../core/models/menu_models/item_model.dart';
import '../../../../core/models/order_model.dart';

CategoryModel firstCategory = restaurantData.menu.reversed.toList()[0];
ItemModel thisItem = firstCategory.items[0];
ItemModel itemInfo = firstCategory.items[0];
SizeModel choosenSize = SizeModel(id: '' ,name: '', price: 0);

List<OrderItemModel> meals = [];
double total = 0;

getItems(int index) {
  restaurantData.menu.sort((a,b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));
  firstCategory = restaurantData.menu.reversed.toList()[index];
  firstCategory.items.sort((a,b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));
  thisItem = firstCategory.items.isNotEmpty? firstCategory.items[0] : ItemModel(id: '', firestoreId: '', name: '', image: '', description: '', ordered: 0, time: '', images: [], prices: []);
  itemInfo = firstCategory.items.isNotEmpty? firstCategory.items[0] : ItemModel(id: '', firestoreId: '', name: '', image: '', description: '', ordered: 0, time: '', images: [], prices: []);
  choosenSize = SizeModel(id: '' ,name: '', price: 0);
}



