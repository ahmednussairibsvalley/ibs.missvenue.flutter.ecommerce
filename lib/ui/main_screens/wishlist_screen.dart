import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../utils.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>{

  Future _future;
  List _list;

  @override
  void initState() {
    super.initState();
    Globals.controller.resetCustomer();
    _future = _getFuture();
  }

  Future _getFuture() {
    return getCustomerWishList(Globals.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('WISHLIST',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List list = snapshot.data['Items'];
                Globals.controller.resetCustomer();
                Globals.controller.populateWishList(list);
                _list = Globals.controller.customer.wishList;
                return Container(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                            [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  Globals.controller.customer.wishList.length >
                                      0
                                      ?
                                  '${Globals.controller.customer.wishList
                                      .length} Products'
                                      : 'You don\'t have any products in wishlist',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]
                        ),
                      ),
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5
                        ),
                        delegate: SliverChildListDelegate(List.generate(_list
                            .length, (index) {
                          final int _id = _list[index].id;
                          final String _title = _list[index].title;
                          final double _price = _list[index].price;
                          final String _imageUrl = _list[index].imagesUrls !=
                              null &&
                              _list[index]
                                  .imagesUrls.length > 0 ?
                          _list[index]
                              .imagesUrls[0] : '';
                          final double _sellingPrice = _list[index]
                              .sellingPrice;
                          return WishListItem(
                              _id, _title, _price, _imageUrl, _sellingPrice,
                              onDelete: () async {
                                setState(() {
                                  _future = _getFuture();
                                });
                              });
                        })),
                      ),
                    ],
                  ),
                );
              }
              else {
                return Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
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
      ),
    );
  }


}

class WishListItem extends StatefulWidget {

  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final double _sellingPrice;
  final VoidCallback onDelete;

  WishListItem(this._id, this._title, this._price, this._imageUrl,
      this._sellingPrice, {@required this.onDelete});

  @override
  _WishListItemState createState() =>
      _WishListItemState(this._id, this._title, this._price, this._imageUrl,
          this._sellingPrice, onDelete: onDelete);
}

class _WishListItemState extends State<WishListItem> {

  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final double _sellingPrice;
  final VoidCallback onDelete;

  bool _addedToCart = false;

  _WishListItemState(this._id, this._title, this._price, this._imageUrl,
      this._sellingPrice, {@required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[

            // The product image and the add to cart button
            Stack(
              children: <Widget>[

                // The product image.
                FutureBuilder(
                  future: isImageAvailable(_imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data) {
                        return Center(
                          child: Image.network(_imageUrl,
                            width: 90,
                            height: 80,
                          ),
                        );
                      } else {
                        return Text('No image available');
                      }
                    }
                    return Container(
                      height: 90,
                      width: 90,
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  },
                ),

                // The add to cart button
                FutureBuilder(
                  future: getCustomerCart(Globals.customerId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data['Items'];
                      for (int i = 0; i < list.length; i ++) {
                        if (list[i]['ProductId'] == _id) {
                          _addedToCart = true;
                          break;
                        }
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (!_addedToCart) {
                            Map addedToCart = await addToCart(_id, 1);
                            if (addedToCart != null && addedToCart['result']) {
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
                            }

                            Map result = await getCustomerCart(
                                Globals.customerId);

                            List list = result ['Items'];
                            for (int i = 0; i < list.length; i ++) {
                              if (list[i]['ProductId'] == _id) {
                                _addedToCart = true;
                                break;
                              }
                            }
                          } else {
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
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/add_to_cart.png', width: 35, height: 35,),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),

            // Product title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _title, maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                // prices
                _sellingPrice < _price ?
                Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('$_sellingPrice SR'),
                    Text('$_price SR',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  ],
                )
                    : Text('$_price SR'),

                // Delete wishlist.
                GestureDetector(
                  onTap: () async {
                    Map removedFromWishList = await removeFromWishList(
                        _id);
                    if (removedFromWishList != null &&
                        removedFromWishList['result']) {
                      this.onDelete();
                    }
                  },
                  child: Icon(Icons.delete_outline),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


//class WishListItem extends StatelessWidget {
//
//  final int _id;
//  final String _title;
//  final double _price;
//  final String _imageUrl;
//  final double _sellingPrice;
//  final VoidCallback onDelete;
//
//  bool _addedToCart = false;
//
//  WishListItem(this._id, this._title, this._price, this._imageUrl,
//      this._sellingPrice, {@required this.onDelete});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Colors.white,
//      padding: EdgeInsets.all(5),
//      child: ListView(
//        children: <Widget>[
//
//          // The product image and the add to cart button
//          Stack(
//            children: <Widget>[
//
//              // The product image.
//              FutureBuilder(
//                future: isImageAvailable(_imageUrl),
//                builder: (context, snapshot) {
//                  if (snapshot.hasData) {
//                    if (snapshot.data) {
//                      return Center(
//                        child: Image.network(_imageUrl,
//                          width: 90,
//                          height: 80,
//                        ),
//                      );
//                    } else {
//                      return Text('No image available');
//                    }
//                  }
//                  return Container(
//                    height: 90,
//                    width: 90,
//                    child: Column(
//                      children: <Widget>[
//                        CircularProgressIndicator(),
//                      ],
//                    ),
//                  );
//                },
//              ),
//
//              // The add to cart button
//              FutureBuilder(
//                future: getCustomerCart(Globals.customerId),
//                builder: (context, snapshot) {
//                  if (snapshot.hasData) {
//                    List list = snapshot.data['Items'];
//                    for (int i = 0; i < list.length; i ++) {
//                      if (list[i]['ProductId'] == _id) {
//                        _addedToCart = true;
//                        break;
//                      }
//                    }
//                    return GestureDetector(
//                      onTap: () async {
//                        if (!_addedToCart) {
//                          Map addedToCart = await addToCart(_id, 1);
//                          if (addedToCart != null && addedToCart['result']) {
//                            Scaffold.of(context).showSnackBar(
//                              SnackBar(
//                                duration: Duration(seconds: 4),
//                                backgroundColor: Colors.black87,
//                                shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(50),
//                                    side: BorderSide(
//                                      style: BorderStyle.none,
//                                      width: 1,
//                                    )
//                                ),
//                                content: Text('The item is added to the cart',
//                                  textAlign: TextAlign.center,
//                                ),
//                              ),
//                            );
//                          }
//
//                          Map result = await getCustomerCart(
//                              Globals.customerId);
//
//                          List list = result ['Items'];
//                          for (int i = 0; i < list.length; i ++) {
//                            if (list[i]['ProductId'] == _id) {
//                              _addedToCart = true;
//                              break;
//                            }
//                          }
//                        } else {
//                          Scaffold.of(context).showSnackBar(
//                            SnackBar(
//                              duration: Duration(seconds: 4),
//                              backgroundColor: Colors.black87,
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(50),
//                                  side: BorderSide(
//                                    style: BorderStyle.none,
//                                    width: 1,
//                                  )
//                              ),
//                              content: Text('The item has been already added',
//                                textAlign: TextAlign.center,
//                              ),
//                            ),
//                          );
//                        }
//                      },
//                      child: Container(
//                        alignment: Alignment.topRight,
//                        child: Image.asset(
//                          'assets/add_to_cart.png', width: 35, height: 35,),
//                      ),
//                    );
//                  }
//                  return Container();
//                },
//              ),
//            ],
//          ),
//
//          // Product title
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text(_title, maxLines: 2, overflow: TextOverflow.ellipsis,),
//          ),
//
//          // prices and delete wishlist button
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//
//              // prices
//              _sellingPrice < _price?
//              Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Text('$_sellingPrice SR'),
//                  Text('$_price SR',
//                    style: TextStyle(
//                        color: Colors.grey,
//                        decoration: TextDecoration.lineThrough
//                    ),
//                  ),
//                ],
//              )
//                  : Text('$_price SR'),
//
//              // Delete wishlist.
//              GestureDetector(
//                onTap: () async {
//                  Map removedFromWishList = await removeFromWishList(
//                      _id);
//                  if (removedFromWishList != null &&
//                      removedFromWishList['result']) {
//                    this.onDelete();
//                  }
//                },
//                child: Icon(Icons.delete_outline),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
