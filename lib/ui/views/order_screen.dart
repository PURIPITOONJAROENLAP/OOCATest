import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ooca/data/models/menu_product.dart';
import '../../controllers/order_controller.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});
  final OrderController controller = Get.put(OrderController());

  final List<MenuProduct> menuItems = [
    MenuProduct("Red set", 50, Colors.red),
    MenuProduct("Green set", 40, Colors.green),
    MenuProduct("Blue set", 30, Colors.blue),
    MenuProduct("Yellow set", 50, Colors.yellow),
    MenuProduct("Pink set", 80, Colors.pink),
    MenuProduct("Purple set", 90, Colors.purple),
    MenuProduct("Orange set", 120, Colors.orange),
  ];

  Future _showPaymentPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Summary'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(16),
          backgroundColor:Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: controller.orders.entries.map((entry) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${entry.key.name} ',
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            TextSpan(
                              text: 'x ${entry.value} ',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text('฿${controller.calculateDiscountedPrice(entry.key,entry.value)}'),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'รวม: ฿${controller.calculateTotal()}',
                      style: const TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: '${controller.hasMemberCard.value ? ' (Member Price)': ''}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.green, width: 1)
                ),
              ),
              child: const Text("ยกเลิก",style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยืนยันการจ่าย', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Store",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          padding: const EdgeInsets.all(5),
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Obx(() => Container(
            margin:const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green.shade300),
              borderRadius: BorderRadius.circular(15),
              color: Colors.green,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){controller.hasMemberCard.value = !controller.hasMemberCard.value;},
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: controller.hasMemberCard.value ? Colors.blue.shade100 : Colors.red.shade100,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Member Card \n (10% discount)",textAlign: TextAlign.center,),
                          const SizedBox(width: 10,),
                          controller.hasMemberCard.value
                            ? const Icon(Icons.check)
                            : const Icon(Icons.close)
                        ],
                      )
                    ),
                  )
                ),
                Expanded(
                  child: Text("Total: ${controller.calculateTotal()} THB", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,)
                ),
              ],
            ),
          ),),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [
                Text('Menu',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (menuItems.length / 2).ceil(),
              itemBuilder: (context, rowIndex) {
                int firstIndex = rowIndex * 2;
                int secondIndex = firstIndex + 1;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: buildMenuItem(menuItems[firstIndex])),
                    secondIndex < menuItems.length
                      ? Expanded(child: buildMenuItem(menuItems[secondIndex]))
                      : const Expanded(child: SizedBox(),)
                  ],
                );
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Obx(() => Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 0,
            child: FloatingActionButton(
              backgroundColor: controller.orders.isEmpty ? Colors.grey :Colors.green,
              onPressed: controller.orders.isEmpty ? null : () {
                _showPaymentPopup(context);
              },
              child: const Icon(Icons.payment,color: Colors.white,),
              tooltip: 'จ่ายเงิน',
            ),
          ),
          Positioned(
            right: 10,
            bottom: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                controller.removeAllProduct();
              },
              child: const Icon(Icons.delete,color: Colors.white,),
              tooltip: 'ล้างตะกร้า',
            ),
          ),
        ],
      )),
    );
  }

  Widget buildMenuItem(MenuProduct item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15)
      ),
      child: InkWell(
        onTap: (){controller.addProduct(item);},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: item.color,
                  ),
                  height: 150,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    alignment: Alignment.center,
                    child: Text("${item.name} - ${item.price} THB", style: const TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => controller.removeProduct(item),
                ),
                Obx(() => Text(controller.orders[item]?.toString() ?? "0")),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => controller.addProduct(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
