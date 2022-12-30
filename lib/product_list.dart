import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart_app/cart_modal.dart';
import 'package:flutter_cart_app/cart_provider.dart';
import 'package:flutter_cart_app/cart_screen.dart';
import 'package:flutter_cart_app/db_helper.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'P R O D U C T  L I S T',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Center(
              child: Badge(
                position: BadgePosition.topEnd(),
                badgeContent: Consumer<CartProvider>(
                  builder: (context,value,child){
                    return Text(value.getCounterValue().toString(), style: TextStyle(color: Colors.white),);
                  },
                ),
                animationDuration: Duration(milliseconds: 300),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .04,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 6,
                      shadowColor: Colors.blueGrey.withOpacity(.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  image: NetworkImage(
                                      productImage[index].toString()),
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .04,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index],
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .005,
                                      ),
                                      Text(
                                        '${productUnit[index]} : ${productPrice[index]}${"\$"}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .005,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                            onTap: () {
                                              dbHelper!.insert(CartModel(
                                                  id: index,
                                                  productID: index.toString(),
                                                  productName: productName[index].toString(),
                                                  initPrice: productPrice[index],
                                                  productPrice: productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index].toString(),
                                                  image: productImage[index].toString()
                                              )).then((value) {
                                                print('Added to Cart!!');
                                                cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                                cart.addCounter();
                                              }).onError((error, stackTrace) {
                                                print(error.toString());
                                                print('NAHI HUWA');
                                              });
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blueGrey
                                                        .withOpacity(.3),
                                                    blurRadius: 10,
                                                    offset: Offset(4,
                                                        8), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                  child: Text(
                                                'Add to cart',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];

  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];
}
