import 'package:flutter/material.dart';
import 'package:miss_venue/utils.dart';

import '../../globals.dart';
import 'checkout/checkout_screen.dart';


class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {

  double _totalPrice = 0;


  @override
  void initState() {
    super.initState();

    Globals.controller.resetCustomer();

    _totalPrice = Globals.controller.calculateTotalPrice();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Cart',
            style: TextStyle(
              color: Colors.black,
            ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCustomerCart(Globals.customerId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List list = snapshot.data['Items'];
            Globals.controller.populateCart(list);
            return ListView(
              children: List.generate(
                  Globals.controller.customer.cart.length, (index) {
                final int _id = Globals.controller.customer.cart[index].id;
                final String _title = Globals.controller.customer.cart[index]
                    .product
                    .title;
                final double _price = Globals.controller.customer.cart[index]
                    .product
                    .price;
                final int _quantity = Globals.controller.customer.cart[index]
                    .quantity;
                final String _imageUrl = Globals.controller.customer.cart[index]
                    .product.imagesUrls[0];
//          final int _color = _list[index].product.color;
//          final String _size = _list[index].product.size;
                final double _sellingPrice = Globals.controller.customer
                    .cart[index]
                    .product.sellingPrice;

                int _quantityValue = _quantity;
                return Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CartItem(
                              quantity: _quantity,
                              id: _id,
                              title: _title,
                              price: _price,
                              imageUrl: _imageUrl,
//                    color: _color,
//                    size: _size,
                              sellingPrice: _sellingPrice,
                              onDelete: () async {
                                print('Item ID: $_id');
                                Map removedFromCartApi = await removeFromCart(
                                    _id);
                                print('$removedFromCartApi');
                                if (removedFromCartApi != null &&
                                    removedFromCartApi['result']) {
                                  setState(() {
                                    Globals.controller.customer.cart.removeAt(
                                        index);
                                    _totalPrice =
                                        Globals.controller
                                            .calculateTotalPrice();
                                  });
                                }
                              },
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 8.0),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      _quantityValue ++;
                                      Map updatedCartItemQuantity = await updateCartItem(
                                          _id, _quantityValue);
                                      print('$updatedCartItemQuantity');
                                      if (updatedCartItemQuantity != null &&
                                          updatedCartItemQuantity['result']) {
                                        setState(() {
                                          Globals.controller.customer
                                              .cart[index]
                                              .quantity = _quantityValue;
                                          _totalPrice =
                                              Globals.controller
                                                  .calculateTotalPrice();
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.add),
                                    ),
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        border: Border.all(
                                            width: 1
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: Text('$_quantityValue'),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_quantityValue > 1) {
                                        _quantityValue --;
                                        Map updatedCartItemQuantity = await updateCartItem(
                                            _id, _quantityValue);
                                        print('$updatedCartItemQuantity');
                                        if (updatedCartItemQuantity != null &&
                                            updatedCartItemQuantity['result']) {
                                          setState(() {
                                            Globals.controller.customer
                                                .cart[index]
                                                .quantity = _quantityValue;
                                            ;
                                            _totalPrice =
                                                Globals.controller
                                                    .calculateTotalPrice();
                                          });
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              top: 0.0,
                              bottom: 0.0,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: _sellingPrice < _price ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                          '${_sellingPrice *
                                              _quantityValue} SR'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${_price * _quantityValue} SR',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration
                                                .lineThrough
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                    : Text('${_price * _quantityValue} SR'),
                              ),
                            ),
                          ],

                        ),
                        Divider(),
                      ],
                    ),
                  ],
                );
              }),
            );
          }
          return Container(
            height: 100,
            width: 100,
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getCustomerCart(Globals.customerId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _totalPrice = snapshot.data['Total_Amount'];

              return _totalPrice > 0 ? ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CheckoutScreen()));
                },
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Place this order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.more_vert,
                          color: Colors.white,
                        ),
                        Text('$_totalPrice SR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('You don\'t have any item in your cart',
                      textAlign: TextAlign.center,),
                  ),
                ),
              );
            }
            return ListTile(
              title: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  final double sellingPrice;
//  final int color;
//  final String size;
  final VoidCallback onDelete;

  CartItem({this.id,
        this.title,
        this.price,
        this.imageUrl,
        this.quantity,
//        this.color,
//        this.size,
        this.sellingPrice,

        this.onDelete,

      }
    );

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image(
                              image: NetworkImage(imageUrl),
                              width: 100,
                              height: 90,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 150,
                                  child: Text('$title',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Padding(
//                                      padding: const EdgeInsets.only(right: 8.0),
//                                      child: Text('Size: $size',
//                                        style: TextStyle(
//                                          fontSize: 15,
//                                          color: Colors.grey,
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text('Color: ${Globals.controller.getColorName(color)}',
//                                        style: TextStyle(
//                                          fontSize: 15,
//                                          color: Colors.grey,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),

                  ],
                )
            ),
            GestureDetector(
              onTap: this.onDelete,
              child: Container(
                alignment: Alignment.topLeft,
                child: Icon(Icons.delete_outline),
              ),
            ),
          ],
        ),

      ],
    );
  }
}





