import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart_app/cart_modal.dart';
import 'package:flutter_cart_app/cart_provider.dart';
import 'package:flutter_cart_app/db_helper.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'P R O D U C T  C A R T',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              position: BadgePosition.topEnd(),
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounterValue().toString(),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
              animationDuration: Duration(milliseconds: 300),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .04,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<CartModel>> snapShot) {
                  if (snapShot.hasData) {

                    if(snapShot.data!.isEmpty){
                      return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Center(
                                child: Image(image: AssetImage('images/empty_cart.png'),),
                              ),
                              Text('Explore More Products 😋',style: Theme.of(context).textTheme.headline6,)
                            ],
                          )
                      );
                    }
                    else{
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapShot.data!.length,
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image(
                                              image: NetworkImage(snapShot
                                                  .data![index].image
                                                  .toString()),
                                              height: 100,
                                              width: 100,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  .04,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapShot.data![index]
                                                            .productName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            cart.minusCounter();
                                                            dbHelper!.delete(
                                                                snapShot
                                                                    .data![index]
                                                                    .id!);
                                                            cart.minusTotalPrice(
                                                                double.parse(snapShot
                                                                    .data![index]
                                                                    .productPrice
                                                                    .toString()));
                                                          },
                                                          child: Icon(
                                                            Icons.delete_outline,
                                                            color: Colors.blueGrey,
                                                          ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        .009,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${snapShot.data![index].unitTag.toString()} : ${snapShot.data![index].productPrice.toString()}${"\$"}',
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                          height: 30,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            color: Colors.cyan,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.cyan
                                                                    .withOpacity(
                                                                    .3),
                                                                blurRadius: 10,
                                                                offset: Offset(4,
                                                                    8), // Shadow position
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    int quantity = snapShot.data![index].quantity!;
                                                                    int price = snapShot.data![index].initPrice!;
                                                                    if(quantity > 1){
                                                                      quantity--;
                                                                      int? newPrice = quantity * price;
                                                                      dbHelper!.updateQ(CartModel(
                                                                          id: snapShot.data![index].id!,
                                                                          productID: snapShot.data![index].id.toString(),
                                                                          productName: snapShot.data![index].productName!,
                                                                          initPrice: snapShot.data![index].initPrice!,
                                                                          productPrice: newPrice,
                                                                          quantity: quantity,
                                                                          unitTag: snapShot.data![index].unitTag.toString(),
                                                                          image: snapShot.data![index].image.toString()))
                                                                          .then(
                                                                              (value) {
                                                                            quantity = 0;
                                                                            newPrice = 0;
                                                                            cart.minusTotalPrice(double.parse(snapShot.data![index].initPrice!.toString()));
                                                                          })
                                                                          .onError((error,
                                                                          stackTrace) {
                                                                        print(error.toString());
                                                                      });
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                    '-',
                                                                    style:
                                                                    TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 25,
                                                                    ),
                                                                  )),
                                                              Text(
                                                                snapShot
                                                                    .data![index]
                                                                    .quantity
                                                                    .toString(),
                                                                style:
                                                                const TextStyle(
                                                                  color:
                                                                  Colors.white,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    int quantity = snapShot.data![index].quantity!;
                                                                    int price = snapShot.data![index].initPrice!;
                                                                    quantity++;
                                                                    int? newPrice = quantity * price;
                                                                    dbHelper!.updateQ(
                                                                        CartModel(
                                                                            id: snapShot.data![index].id!,
                                                                            productID: snapShot.data![index].id.toString(),
                                                                            productName: snapShot.data![index].productName!,
                                                                            initPrice: snapShot.data![index].initPrice!,
                                                                            productPrice: newPrice,
                                                                            quantity: quantity,
                                                                            unitTag: snapShot.data![index].unitTag.toString(),
                                                                            image: snapShot.data![index].image.toString()))
                                                                        .then(
                                                                            (value) {
                                                                          quantity = 0;
                                                                          newPrice = 0;
                                                                          cart.addTotalPrice(double.parse(snapShot.data![index].initPrice!.toString()));
                                                                        })
                                                                        .onError((error,
                                                                        stackTrace) {
                                                                      print(error.toString());
                                                                    });
                                                                  },
                                                                  child: const Text(
                                                                    '+',
                                                                    style:
                                                                    TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 30,
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        .005,
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
                              }));
                    }
                    
                  } else {
                    return const Expanded(child: Text('Loading'));
                  }
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                    ? false
                    : true,
                child: Column(
                  children: [
                    TotalPriceWidget(
                        title: 'Sub Total',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    TotalPriceWidget(
                        title: 'Discount',
                        value: r'$3.00'),
                    TotalPriceWidget(
                        title: 'Total',
                        value: r'$127.00'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class TotalPriceWidget extends StatelessWidget {
  final String title, value;

  TotalPriceWidget({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
