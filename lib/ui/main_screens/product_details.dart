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
  final int sectorIndex;
  final int categoryIndex;
  final bool addedToWishList;
  final Function onUpdateWishList;

  ProductDetails({@required this.id, @required this.title, @required this.price,
    @required this.imagesUrls, @required this.sellingPrice,
    @required this.sectorIndex, @required this.categoryIndex,
    @required this.addedToWishList, @required this.onUpdateWishList});
  @override
  _ProductDetailsState createState() => _ProductDetailsState(
    id: id,
    title: title,
    price: price,
    imagesUrls: imagesUrls,
    sellingPrice: sellingPrice,
    sectorIndex: sectorIndex,
    categoryIndex: categoryIndex,
    addedToWishList: addedToWishList,
    onUpdateWishList: onUpdateWishList,
  );
}

class _ProductDetailsState extends State<ProductDetails> {
  final int id;
  final String title;
  final double price;
  final List imagesUrls;
  final double sellingPrice;
  final int sectorIndex;
  final int categoryIndex;
  final bool addedToWishList;
  final Function onUpdateWishList;

  bool _addedToWishlist = false;


  _ProductDetailsState(
      {@required this.id, @required this.title, @required this.price,
        @required this.imagesUrls, @required this.sellingPrice,
        @required this.sectorIndex, @required this.categoryIndex,
        @required this.addedToWishList, @required this.onUpdateWishList});

  @override
  void initState() {
    super.initState();
    super.initState();
    _addedToWishlist = addedToWishList;
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final int _productIndex = _getProductIndex(sectorIndex, categoryIndex, id);
    return sectorIndex > -1 && categoryIndex > -1 ?
    SafeArea(
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
            Divider(),
            Column(
              children: List.generate(Globals.controller
                  .getProductById(id)
                  .attributes
                  .length, (index) {
                int controlType = Globals.controller
                    .getProductById(id)
                    .attributes[index]
                    .controlType;
                return Column(
                  children: <Widget>[
                    Text('${Globals.controller
                        .getProductById(id)
                        .attributes[index].name}'),
                    controlType == AttributesController.dropDownListControlType
                        ?
                    DropDownList(
                      sectorIndex: sectorIndex,
                      categoryIndex: categoryIndex,
                      productIndex: Globals.controller.getProductIndex(id),
                      attributeIndex: index,
                    )
                        :
                    controlType == AttributesController.radioListControlType ?
                    RadioList(
                      sectorIndex: sectorIndex,
                      categoryIndex: categoryIndex,
                      productIndex: Globals.controller.getProductIndex(id),
                      attributeIndex: index,
                    ) :
                    CheckBoxes(
                      sectorIndex: sectorIndex,
                      categoryIndex: categoryIndex,
                      productIndex: Globals.controller.getProductIndex(id),
                      attributeIndex: index,
                    ),
                    Divider(),
                  ],
                );
              }),
            ),
            _productSpecs(),
            Divider(),
            _productIndex >= 0 && sectorIndex >= 0 && categoryIndex >= 0 ?
            _relatedProducts(sectorIndex, categoryIndex, _productIndex) :
            Container(),
          ],
        ),
        bottomNavigationBar: Builder(builder: (context) {
          return Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    onUpdateWishList();
                    if (!_addedToWishlist) {
                      Map addedToWishList = await addToWishList(id);
                      if (addedToWishList != null &&
                          addedToWishList['result'] == true) {
                        setState(() {
                          _addedToWishlist = true;
                        });
                        Globals.controller.customer.wishList.add(
                            Globals.controller.getProductById(id)
                        );
                      }
                    } else {
                      Map removedFromWishListApi = await removeFromWishList(id);
                      if (removedFromWishListApi != null &&
                          removedFromWishListApi['result']) {
                        setState(() {
                          _addedToWishlist = false;
                        });
                        Globals.controller.customer.wishList.remove(
                            Globals.controller.getProductById(id)
                        );
                      }
                    }
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
                    onTap: () async {
                      if (!Globals.controller.containsCartItem(id)) {
                        Map addedToCartApi = await addToCart(id, 1);
                        if (addedToCartApi != null &&
                            addedToCartApi['result']) {
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
    )
        : SafeArea(
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
        body: Container(),
      ),
    );
  }

  int _getProductIndex(int sectorIndex, int categoryIndex, int productId) {
    int result = -1;
    try {
      List list = Globals.controller.sectors[sectorIndex]
          .categories[categoryIndex].products;
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == productId) {
          result = i;
          break;
        }
      }
    } catch (e) {

    }

    return result;
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
          child: Globals.controller.getProductById(id) != null ?
          Column(
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
          ) : Container(),
        ),
      ],
    );
  }

  Widget _relatedProducts(int sectorIndex, int categoryIndex,
      int productIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('You May Also Like',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: FutureBuilder(
            future: getCustomerWishList(Globals.customerId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List list = snapshot.data['Items'];

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
                      Globals.controller.sectors[sectorIndex]
                          .categories[categoryIndex]
                          .products[productIndex].relatedProducts.length, (
                      index) {
                    final int _id = Globals.controller.sectors[sectorIndex]
                        .categories[categoryIndex].products[productIndex]
                        .relatedProducts[index].id;
                    final String _title = Globals.controller
                        .sectors[sectorIndex]
                        .categories[categoryIndex].products[productIndex]
                        .relatedProducts[index].title;
                    final double _price = Globals.controller
                        .sectors[sectorIndex]
                        .categories[categoryIndex].products[productIndex]
                        .relatedProducts[index].price;
                    final List _imagesUrls = Globals.controller
                        .sectors[sectorIndex]
                        .categories[categoryIndex].products[productIndex]
                        .relatedProducts[index].imagesUrls;
                    final double _sellingPrice = Globals.controller
                        .sectors[sectorIndex]
                        .categories[categoryIndex].products[productIndex]
                        .relatedProducts[index].sellingPrice;

                    final int _sectorIndex = Globals.controller
                        .getProductSectorIndex(
                        _id);
                    final int _categoryIndex = Globals.controller
                        .getProductCategoryIndex(_id);

                    bool wishListed = false;
                    for (int i = 0; i < list.length; i++) {
                      if (list[i]['ProductId'] == _id) {
                        wishListed = true;
                        break;
                      }
                    }
                    return RelatedProductItem(
                      _id, _title, _price, _imagesUrls, _sellingPrice,
                      sectorIndex: _sectorIndex,
                      categoryIndex: _categoryIndex,
                      onUpdateWishList: onUpdateWishList,
                      addedToWishList: wishListed,
                    );
                  }),
                );
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

class RelatedProductItem extends StatefulWidget {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;
  final int sectorIndex;
  final int categoryIndex;
  final bool addedToWishList;

  final Function onUpdateWishList;

  RelatedProductItem(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,
      {@required this.sectorIndex, @required this.categoryIndex,
        @required this.onUpdateWishList, @required this.addedToWishList});

  @override
  _RelatedProductItemState createState() =>
      _RelatedProductItemState(
          this._id, this._title, this._price, this._imagesUrls,
          this._sellingPrice, sectorIndex: sectorIndex,
          categoryIndex: categoryIndex, onUpdateWishList: onUpdateWishList,
          addedToWishList: addedToWishList);
}

class _RelatedProductItemState extends State<RelatedProductItem> {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;
  final int sectorIndex;
  final int categoryIndex;
  final bool addedToWishList;

  final Function onUpdateWishList;

  bool _addedToWishlist = false;

  _RelatedProductItemState(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,
      {@required this.sectorIndex, @required this.categoryIndex, @required this.onUpdateWishList, @required this.addedToWishList});

  @override
  void initState() {
    super.initState();

    _addedToWishlist = addedToWishList;
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
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProductDetails(
                            id: _id,
                            title: _title,
                            price: _price,
                            imagesUrls: _imagesUrls,
                            sellingPrice: _sellingPrice,
                            sectorIndex: sectorIndex,
                            categoryIndex: categoryIndex,
                            addedToWishList: _addedToWishlist,
                            onUpdateWishList: onUpdateWishList,
                          ),
                    ),
                    );
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
              GestureDetector(
                onTap: () async {
                  if (!Globals.controller.containsCartItem(_id)) {
                    Map addedToCartApi = await addToCart(_id, 1);
//                    print('$addedToCartApi');
                    if (addedToCartApi != null && addedToCartApi['result']) {
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
                      'assets/add_to_cart.png', width: 35, height: 35,)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
              GestureDetector(
                onTap: () async {
                  if (!_addedToWishlist) {
                    Map addedToWishlistMap = await addToWishList(_id);
                    if (addedToWishlistMap != null &&
                        addedToWishlistMap['result']) {
                      setState(() {
                        _addedToWishlist = true;
//                        Globals.controller.customer.wishList.add(
//                            Globals.controller.getProductById(_id)
//                        );
                      });
                    }
                  } else {
                    Map removeFromWishListApi = await removeFromWishList(_id);
                    if (removeFromWishListApi != null &&
                        removeFromWishListApi['result']) {
                      setState(() {
                        _addedToWishlist = false;
                      });
//                      setState(() {
//                        _addedToWishlist = true;
////                        Globals.controller.customer.wishList.remove(
////                            Globals.controller.getProductById(_id)
////                        );
//                      });
                    }
                  }
                },
                child: _addedToWishlist ?
                Icon(Icons.favorite, color: Colors.red, size: 30,)
                    : Icon(Icons.favorite_border, color: Colors.red, size: 30,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

