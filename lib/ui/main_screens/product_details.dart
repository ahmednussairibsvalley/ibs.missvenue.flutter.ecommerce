import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../globals.dart';
import '../../utils.dart';
import 'attributes_controllers/checkboxes.dart';
import 'attributes_controllers/drop_down_list.dart';
import 'attributes_controllers/radio_list.dart';
import 'product_attributes_controllers.dart';

/// Displays the product details.

class ProductDetails extends StatefulWidget {
  final int id;
  final String title;
  final double price;
  final List imagesUrls;
  final double sellingPrice;
  final Function onUpdateWishList;
  final Function onUpdateCart;
  final bool addedToWishList;
  final bool addedToCart;

  ProductDetails({@required this.id, @required this.title, @required this.price,
    @required this.imagesUrls, @required this.sellingPrice,
    @required this.addedToWishList, @required this.addedToCart,
    @required this.onUpdateWishList, @required this.onUpdateCart,
  });
  @override
  _ProductDetailsState createState() => _ProductDetailsState(
    id: id,
    title: title,
    price: price,
    imagesUrls: imagesUrls,
    sellingPrice: sellingPrice,
    onUpdateWishList: onUpdateWishList,
    onUpdateCart: onUpdateCart,
  );
}

class _ProductDetailsState extends State<ProductDetails> {
  final int id;
  final String title;
  final double price;
  final List imagesUrls;
  final double sellingPrice;
  final Function onUpdateWishList;
  final Function onUpdateCart;

  bool _addedToWishlist = false;
  bool _addedToCart = false;

  Future _addedToWishListFuture;
  Future _addedToCartFuture;


  _ProductDetailsState(
      {@required this.id, @required this.title, @required this.price,
        @required this.imagesUrls, @required this.sellingPrice,
        @required this.onUpdateWishList, @required this.onUpdateCart,
      });

  @override
  void initState() {
    super.initState();
    super.initState();
    _addedToWishListFuture = getCustomerWishList(Globals.customerId);
    _addedToCartFuture = getCustomerCart(Globals.customerId);
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
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

            // Product gallery
            ProductGallery(
              list: imagesUrls,
            ),

            // Product name title
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

            // Product price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: sellingPrice < price ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),

            // Divider
            Divider(),

            // Product Attributes.
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List list = snapshot.data;
                      List attributesList = List();
                      for (int i = 0; i < list.length; i++) {
                        if (list[i]['id'] == id) {
                          attributesList = list[i]['Attributes'];
                          break;
                        }
                      }

                      return Column(
                        children: List.generate(attributesList.length, (index) {
                          return Text('${attributesList[index]['Name']}');
                        }),
                      );
                    }
                    return Container();
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Product Specifications.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List list = snapshot.data;
                      List specsList = List();
                      for (int i = 0; i < list.length; i++) {
                        if (list[i]['id'] == id) {
                          specsList = list[i]['SpecificationAttribute'];
                          break;
                        }
                      }
                      return Column(
                        children: List.generate(specsList.length, (index) {
                          return Row(
                            children: <Widget>[
                              Text('${specsList[index]['Name']}: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${specsList[index]['Value']}',)
                            ],
                          );
                        }),
                      );
                    }
                    return Container();
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Divider
            Divider(),

            // Related Products
            FutureBuilder(
              future: getAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List list = snapshot.data;
                    List relatedProductsList = List();
                    for (int i = 0; i < list.length; i++) {
                      if (list[i]['id'] == id) {
                        relatedProductsList = list[i]['RelatedProducts'];
                        break;
                      }
                    }

                    return GridView(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(
                          relatedProductsList.length, (index) {
                        final int _id = relatedProductsList[index]['id'];
                        final String _title = relatedProductsList[index]['Name'];
                        final double _price = relatedProductsList[index]['Price'];
                        final List _imagesUrls = relatedProductsList[index]['Images'];
                        final double _sellingPrice = relatedProductsList[index]['SellingPrice'];

                        return RelatedProductItem(
                          _id, _title, _price, _imagesUrls, _sellingPrice,);
                      }),
                    );
                  }
                  return Container();
                }
                return Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: Row(
          children: <Widget>[

            // wishtlist
            FutureBuilder(
              future: _addedToWishListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List list = snapshot.data['Items'];
                    for (int i = 0; i < list.length; i++) {
                      if (list[i]['ProductId'] == id) {
                        _addedToWishlist = true;
                        break;
                      }
                    }
                    return GestureDetector(
                      onTap: () async {
                        onUpdateWishList();
                        if (!_addedToWishlist) {
                          Map addedToWishlistMap = await addToWishList(id);
                          if (addedToWishlistMap != null &&
                              addedToWishlistMap['result']) {
                            this.setState(() {
                              _addedToWishlist = true;
                              _addedToWishListFuture =
                                  getCustomerWishList(Globals.customerId);
                            });
                          }
                        } else {
                          Map removeFromWishListApi = await removeFromWishList(
                              id);
                          if (removeFromWishListApi != null &&
                              removeFromWishListApi['result']) {
                            _addedToWishlist = false;
                            this.setState(() {
                              _addedToWishListFuture =
                                  getCustomerWishList(Globals.customerId);
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            Icons.favorite_border, color: Colors.red,
                            size: 30,),
                        ),
                      ),
                    );
                  }
                  return Container();
                }
                return Container(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, top: 8.0, bottom: 8.0),
                child: FutureBuilder(
                  future: _addedToCartFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data['Items'];
                      for (int i = 0; i < list.length; i++) {
                        if (list[i]['ProductId'] == id) {
                          _addedToCart = true;
                          break;
                        }
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (!_addedToCart) {
                            Map addedToCartApi = await addToCart(id, 1);
                            if (addedToCartApi != null &&
                                addedToCartApi['result']) {
                              onUpdateCart();
                              _addedToCart = true;
                              setState(() {
                                _addedToCartFuture =
                                    getCustomerCart(Globals.customerId);
                              });
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
                                  content: Text(
                                    'The item is added to the cart',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
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
                                content: Text(
                                  'The item has been already added',
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
                      );
                    }
                    return Container();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class ProductGallery extends StatefulWidget {
  final List list;

  ProductGallery({@required this.list});

  @override
  _ProductGalleryState createState() => _ProductGalleryState(list: list);
}

class _ProductGalleryState extends State<ProductGallery>
    with TickerProviderStateMixin {

  final List list;

  int _current = 0;

  _ProductGalleryState({@required this.list});

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final List child = map<Widget>(
      list,
          (index, i) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return Image.network(i,
                  width: _width,
                  height: _width,
                  fit: BoxFit.cover,
                );
              } else {
                return Center(
                  child: Text('Product Image is not available',
                    textAlign: TextAlign.center,),
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
          future: isImageAvailable(i),
        );
      },
    ).toList();

    return list.length > 1 ? Stack(children: [
      CarouselSlider(
        items: child,
        aspectRatio: 1.0, viewportFraction: 1.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            list,
                (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4)),
              );
            },
          ),
        ),
      ),
    ])
        : list.length == 1 ? FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return Image.network(list[0],
              width: _width,
              height: _width,
              fit: BoxFit.cover,
            );
          } else {
            return Center(
              child: Text(
                'Product Image is not available', textAlign: TextAlign.center,),
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
      future: isImageAvailable(list[0]),
    )
        : Center(
      child: Text('No images available for this product',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class RelatedProductItem extends StatefulWidget {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;

  RelatedProductItem(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,);

  @override
  _RelatedProductItemState createState() =>
      _RelatedProductItemState(
          this._id, this._title, this._price, this._imagesUrls,
        this._sellingPrice,);
}

class _RelatedProductItemState extends State<RelatedProductItem> {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;

  bool _addedToWishlist = false;
  Future _addedToWishListFuture;

  _RelatedProductItemState(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,);

  @override
  void initState() {
    super.initState();
    _addedToWishListFuture = getCustomerWishList(Globals.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[

          Stack(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
//                    Navigator.of(context).pop();
//                    Navigator.of(context).push(MaterialPageRoute(
//                      builder: (context) =>
//                          ProductDetails(
//                            id: _id,
//                            title: _title,
//                            price: _price,
//                            imagesUrls: _imagesUrls,
//                            sellingPrice: _sellingPrice,
//                            addedToWishList: _addedToWishlist,
//                            onUpdateWishList: onUpdateWishList,
//                          ),
//                    ),
//                    );
                  },
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data) {
                          return Image.network(_imagesUrls[0],
                            width: 90,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Center(
                            child: Text('Product Image is not available',
                              textAlign: TextAlign.center,),
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
                    future: isImageAvailable(_imagesUrls[0]),
                  ),
                ),
              ),

              // Add to cart button.
              GestureDetector(
                onTap: () async {
                  if (!Globals.controller.containsCartItem(_id)) {
                    Map addedToCartApi = await addToCart(_id, 1);
                    if (addedToCartApi != null && addedToCartApi['result']) {

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
                      'assets/add_to_cart.png', width: 35, height: 35,)),
              ),
            ],
          ),

          // Product name title.
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),

          // Prices and wishlist
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Prices
              _sellingPrice < _price ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

              // WishList
              FutureBuilder(
                future: _addedToWishListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List list = snapshot.data['Items'];
                      for (int i = 0; i < list.length; i++) {
                        if (list[i]['ProductId'] == _id) {
                          _addedToWishlist = true;
                          break;
                        }
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (!_addedToWishlist) {
                            Map addedToWishlistMap = await addToWishList(_id);
                            if (addedToWishlistMap != null &&
                                addedToWishlistMap['result']) {
                              setState(() {
                                _addedToWishlist = true;
                                _addedToWishListFuture =
                                    getCustomerWishList(Globals.customerId);
                              });
                            }
                          } else {
                            Map removeFromWishListApi = await removeFromWishList(
                                _id);
                            if (removeFromWishListApi != null &&
                                removeFromWishListApi['result']) {
                              setState(() {
                                _addedToWishlist = false;
                                _addedToWishListFuture =
                                    getCustomerWishList(Globals.customerId);
                              });
                            }
                          }
                        },
                        child: _addedToWishlist ?
                        Icon(Icons.favorite, color: Colors.red, size: 30,)
                            : Icon(
                          Icons.favorite_border, color: Colors.red, size: 30,),
                      );
                    }
                    return Container();
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

