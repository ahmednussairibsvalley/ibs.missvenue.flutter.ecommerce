import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../utils.dart';

/// Displays the product details.

class ProductDetails extends StatefulWidget {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final double sellingPrice;
  ProductDetails({@required this.id, @required this.title, @required this.price, @required this.imageUrl, @required this.sellingPrice});
  @override
  _ProductDetailsState createState() => _ProductDetailsState(
    id: id, title: title, price: price, imageUrl: imageUrl, sellingPrice: sellingPrice,
  );
}

class _ProductDetailsState extends State<ProductDetails> {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final double sellingPrice;

  bool _addedToWishlist = false;

  _ProductDetailsState({@required this.id, @required this.title, @required this.price, @required this.imageUrl, @required this.sellingPrice});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    for (int i = 0; i < Globals.controller.customer.wishList.length; i++) {
      if (Globals.controller.customer.wishList.contains(
          Globals.controller.getProductById(id))) {
        _addedToWishlist = true;
        break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            FutureBuilder(
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data){
                    return Image.network(imageUrl,
                      width: _width,
                      height: _width,
                    );
                  } else {
                    return Center(
                      child: Text('Product Image is not available', textAlign: TextAlign.center,),
                    );
                  }
                }
                return Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              },
              future: isImageAvailable(imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            sellingPrice < price ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$sellingPrice SR', textAlign: TextAlign.center,),
                Text('$price SR',
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
                : Text('$price SR', textAlign: TextAlign.center,),
            Divider(),
            _productSpecs(),
          ],
        ),
        bottomNavigationBar: Builder(builder: (context) {
          return Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _addedToWishlist = _addedToWishlist ? false : true;
                      if (_addedToWishlist) {
                        Globals.controller.customer.wishList.add(
                            Globals.controller.getProductById(id)
                        );
                      } else {
                        Globals.controller.customer.wishList.remove(
                            Globals.controller.getProductById(id)
                        );
                      }
                    });
                  },
                  child: Container(
                    width: _width / 10,
                    height: _width / 10,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        )
                    ),
                    child: _addedToWishlist ?
                    Icon(Icons.favorite, color: Colors.red, size: 30,)
                        : Icon(
                      Icons.favorite_border, color: Colors.red, size: 30,),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0, top: 8.0, bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (!Globals.controller.containsCartItem(id)) {
                        Globals.controller.addToCart(
                            Globals.controller.getProductById(id), 1);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 4),
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  style: BorderStyle.none,
                                  width: 1,
                                )
                            ),
                            content: Text('The item is added to the cart',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        //debugPrint('Added Already');
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 4),
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  style: BorderStyle.none,
                                  width: 1,
                                )
                            ),
                            content: Text('The item has been already added',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: _width / 10,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Add to Cart',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _productSpecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Description:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(Globals.controller
                .getProductById(id)
                .specifications
                .length, (index) {
              return Row(
                children: <Widget>[
                  Text('${Globals.controller
                      .getProductById(id)
                      .specifications[index].name}:\t',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(Globals.controller
                      .getProductById(id)
                      .specifications[index].value),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
