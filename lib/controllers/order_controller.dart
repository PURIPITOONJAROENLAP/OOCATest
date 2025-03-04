import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ooca/data/models/menu_item.dart';

class OrderController extends GetxController {
  var orders = <MenuItem, int>{}.obs;
  var hasMemberCard = false.obs;

  void addItem(MenuItem item) {
    orders[item] = (orders[item] ?? 0) + 1;
  }

  void removeItem(MenuItem item) {
    if (orders.containsKey(item) && orders[item]! > 0) {
      orders[item] = orders[item]! - 1;
      if (orders[item] == 0) {
        orders.remove(item);
      }
    }
  }
  void removeAllItem() {
    orders.clear();
  }

  num calculateDiscountedPrice(MenuItem item, int quantity) {
    int totalPrice = item.price * quantity;

    if ((item.name == 'Orange set' || item.name == 'Pink set' || item.name == 'Green set') && quantity >= 2) {
      return totalPrice * 0.95;
    }
    return totalPrice;
  }


  double calculateTotal() {
    double total = orders.entries.fold(0, (sum, entry) => sum + (entry.key.price * entry.value));

    for (var entry in orders.entries) {
      if ((entry.key.name == 'Orange set' || entry.key.name == 'Pink set' || entry.key.name == 'Green set') && entry.value >= 2) {
        total -= ((entry.key.price * entry.value) * 0.05);
      }
    }

    if (hasMemberCard.value) {
      total -= (total * 0.10);
    }

    return total;
  }
}