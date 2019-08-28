import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../utils.dart';
import 'product_details.dart';

class ProductsScreen extends StatelessWidget {

  final int sectorIndex;
  final int categoryIndex;

  ProductsScreen ({@required this.sectorIndex, @required this.categoryIndex,});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProductsList(
          Globals.controller.sectors[sectorIndex].categories[categoryIndex].id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Globals.controller.populateProducts(
              sectorIndex, categoryIndex, snapshot.data);
          return FutureBuilder(
            future: getCustomerWishList(Globals.customerId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List list = snapshot.data['Items'];
                return Center(
                  child: GridView(
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
                            .categories[categoryIndex].products.length, (
                        index) {
                      final int _id = Globals.controller.sectors[sectorIndex]
                          .categories[categoryIndex].products[index].id;
                      final String _title = Globals.controller
                          .sectors[sectorIndex]
                          .categories[categoryIndex].products[index].title;
                      final double _price = Globals.controller
                          .sectors[sectorIndex]
                          .categories[categoryIndex].products[index].price;
                      final List _imagesUrls = Globals.controller
                          .sectors[sectorIndex]
                          .categories[categoryIndex].products[index].imagesUrls;
                      final double _sellingPrice = Globals.controller
                          .sectors[sectorIndex].categories[categoryIndex]
                          .products[index].sellingPrice;
                      return ProductItem(
                        _id, _title, _price, _imagesUrls, _sellingPrice,
                        sectorIndex: sectorIndex,
                        categoryIndex: categoryIndex,
                        wishList: list,);
                    }),
                  ),
                );
              }
              return Container();
            },
          );
        } else {
          return Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );

  }
}

class ProductItem extends StatefulWidget {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;
  final int sectorIndex;
  final int categoryIndex;
  final List wishList;
  ProductItem(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,
      {@required this.sectorIndex, @required this.categoryIndex, @required this.wishList});
  @override
  _ProductItemState createState() =>
      _ProductItemState(this._id, this._title, this._price, this._imagesUrls,
          this._sellingPrice, sectorIndex: sectorIndex,
          categoryIndex: categoryIndex, wishList: wishList);
}

class _ProductItemState extends State<ProductItem> {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;
  final int sectorIndex;
  final int categoryIndex;
  final List wishList;

  bool _addedToWishlist = false;
  bool _addedToCart = false;

  Future _addedToCartFuture;

  _ProductItemState(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,
      {@required this.sectorIndex, @required this.categoryIndex, @required this.wishList});

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < wishList.length; i++) {
      if (wishList[i]['ProductId'] == _id) {
        _addedToWishlist = true;
        break;
      }
    }
    _addedToCartFuture = getCustomerCart(Globals.customerId);
//    _addedToWishlist = Globals.controller.containsWishListItem(_id);
    //getCustomerDetails(Globals.customerId)
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
                  onTap: (){
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
                            addedToCart: _addedToCart,
                            onUpdateWishList: () async {
                              Map result = await getCustomerWishList(
                                  Globals.customerId);
                              List list = result['Items'];

                              bool added = false;
                              for (int i = 0; i < list.length; i++) {
                                if (list[i]['ProductId'] == _id) {
                                  added = true;
                                  break;
                                }
                              }
                              setState(() {
                                _addedToWishlist = added;
                              });
                            },
                            onUpdateCart: () async {
                              Map result = await getCustomerCart(
                                  Globals.customerId);
                              List list = result['Items'];
                              bool added = false;
                              for (int i = 0; i < list.length; i++) {
                                if (list[i]['ProductId'] == _id) {
                                  added = true;
                                  break;
                                }
                              }
                              setState(() {
                                _addedToCart = added;
                              });
                            },
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

              // Add to cart
              FutureBuilder(
                future: _addedToCartFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List list = snapshot.data['Items'];
                    for (int i = 0; i < list.length; i++) {
                      if (list[i]['ProductId'] == _id) {
                        _addedToCart = true;
                        break;
                      }
                    }
                    return GestureDetector(
                      onTap: () async {
                        if (!_addedToCart) {
                          Map addedToCartMap = await addToCart(_id, 1);
                          if (addedToCartMap != null &&
                              addedToCartMap['result']) {
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
                    );
                  }
                  return Container();
                },
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

              // Prices.
              _sellingPrice < _price?
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

              // Add to wishlist.
              GestureDetector(
                onTap: () async {
                  if (!_addedToWishlist) {
                    Map addedToWishListMap = await addToWishList(_id);
                    if (addedToWishListMap != null &&
                        addedToWishListMap['result'] == true) {
                      setState(() {
                        _addedToWishlist = true;
                      });
                    }
                  } else {
                    Map removedFromWishListApi = await removeFromWishList(_id);
                    if (removedFromWishListApi != null &&
                        removedFromWishListApi['result']) {
                      setState(() {
                        _addedToWishlist = false;
                      });
                    }
                  }

                },
                child: _addedToWishlist?
                Icon(Icons.favorite, color: Colors.red, size: 30,)
                    :Icon(Icons.favorite_border, color: Colors.red, size: 30,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

