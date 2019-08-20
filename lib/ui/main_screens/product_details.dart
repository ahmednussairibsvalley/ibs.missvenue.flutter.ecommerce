import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../globals.dart';
import '../../utils.dart';

/// Displays the product details.

class ProductDetails extends StatefulWidget {
  final int id;
  final String title;
  final double price;
  final List imagesUrls;
  final double sellingPrice;

  ProductDetails(
      {@required this.id, @required this.title, @required this.price, @required this.imagesUrls, @required this.sellingPrice});
  @override
  _ProductDetailsState createState() => _ProductDetailsState(
    id: id,
    title: title,
    price: price,
    imagesUrls: imagesUrls,
    sellingPrice: sellingPrice,
  );
}

class _ProductDetailsState extends State<ProductDetails> {
  final int id;
  final String title;
  final double price;
  final List imagesUrls;
  final double sellingPrice;

  bool _addedToWishlist = false;

  _ProductDetailsState(
      {@required this.id, @required this.title, @required this.price, @required this.imagesUrls, @required this.sellingPrice});

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
            ProductGallery(
              list: imagesUrls,
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
            Divider(),
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

