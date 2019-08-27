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

class WishListItem extends StatelessWidget {
  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final double _sellingPrice;
  final VoidCallback onDelete;

  WishListItem(this._id, this._title, this._price, this._imageUrl, this._sellingPrice,{this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[

          Stack(
            children: <Widget>[
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
              GestureDetector(
                onTap: () async {

                  if (!Globals.controller.containsCartItem(_id)) {
                    Map addedToCart = await addToCart(_id, 1);
                    if (addedToCart != null && addedToCart['result']) {
                      Globals.controller.addToCart(
                          Globals.controller.getProductById(_id), 1);
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
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/add_to_cart.png', width: 35, height: 35,),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_title, maxLines: 2, overflow: TextOverflow.ellipsis,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _sellingPrice < _price?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
        ],
      ),
    );
  }
}
