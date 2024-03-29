import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../utils.dart';
import 'product_details.dart';

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Globals.controller.resetCustomer();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Offers',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getOffers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List offersList = snapshot.data;
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

              children: List.generate(offersList.length, (index) {
                final int _id = offersList[index]['id'];
                final String _title = offersList[index]['Name'];
                final double _price = offersList[index]['Price'];
                final List _imagesUrls = offersList[index]['Images'];
                final double _sellingPrice = offersList[index]['SellingPrice'];
                return OfferItem(
                  _id, _title, _price, _imagesUrls, _sellingPrice,);
              }),
            );
          }
          return Container();
        },
      ),
    );
  }
}


class OfferItem extends StatefulWidget {
  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;

  OfferItem(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,);
  @override
  _OfferItemState createState() =>
      _OfferItemState(this._id, this._title, this._price, this._imagesUrls,
        this._sellingPrice,);
}

class _OfferItemState extends State<OfferItem> {

  final int _id;
  final String _title;
  final double _price;
  final List _imagesUrls;
  final double _sellingPrice;

  bool _addedToWishlist = false;
  bool _addedToCart = false;

  Future _addedToCartFuture;
  Future _addedToWishListFuture;

  double _discountPercentage;

  _OfferItemState(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,);

  @override
  void initState() {
    super.initState();
    _discountPercentage = 100 - ((_sellingPrice / _price) * 100);
    _addedToCartFuture = getCustomerCart(Globals.customerId);
    _addedToWishListFuture = getCustomerWishList(Globals.customerId);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: ListView(
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
                            addedToCart: _addedToCart,
                            addedToWishList: _addedToWishlist,
                            onUpdateCart: () {
                              _addedToCart = _addedToCart ? false : true;
                              setState(() {
                                _addedToCartFuture =
                                    getCustomerCart(Globals.customerId);
                              });
                            },
                            onUpdateWishList: () {
                              _addedToWishlist =
                              _addedToWishlist ? false : true;
                              setState(() {
                                _addedToWishListFuture =
                                    getCustomerWishList(Globals.customerId);
                              });
                            },

                          ),
                    ),
                    );
                  },
                  child: FutureBuilder(
                      future: isImageAvailable(_imagesUrls[0]),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data){
                            return Image.network(_imagesUrls[0],
                              width: 90,
                              height: 80,
                            );
                          } else {
                            return Center(
                              child: Text('No Image Available', textAlign: TextAlign.center,),
                            );
                          }
                        }
                        return CircularProgressIndicator();
                      }
                  ),
                ),
              ),

              // Add to cart.
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
                          Map addedToCart = await addToCart(_id, 1);
                          if (addedToCart != null && addedToCart['result']) {
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

              // The offer percentage.
              Container(
                alignment: Alignment.topLeft,
                child: Stack(
                  children: <Widget>[
                    Image.asset('assets/offerbg.png', width: 50, height: 50, fit: BoxFit.cover,),
                    Transform.rotate(
                      angle: 5.49779,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text('${_discountPercentage.toStringAsFixed(0)}%',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // The product title.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_title, overflow: TextOverflow.ellipsis, maxLines: 1,),
          ),


          // Prices and wishlist
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              // Prices
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('$_sellingPrice SR'),
                      Text('$_price SR',
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Add to wishlist.
              Flexible(
                child: FutureBuilder(
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
                                _addedToWishlist = true;
                                setState(() {
                                  _addedToWishListFuture =
                                      getCustomerWishList(Globals.customerId);
                                });
                              }
                            } else {
                              Map removeFromWishListApi = await removeFromWishList(
                                  _id);
                              if (removeFromWishListApi != null &&
                                  removeFromWishListApi['result']) {
                                _addedToWishlist = false;
                                setState(() {
                                  _addedToWishListFuture =
                                      getCustomerWishList(Globals.customerId);
                                });
                              }
                            }
                          },
                          child: _addedToWishlist ?
                          Icon(Icons.favorite, color: Colors.red, size: 30,)
                              : Icon(
                            Icons.favorite_border, color: Colors.red,
                            size: 30,),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

