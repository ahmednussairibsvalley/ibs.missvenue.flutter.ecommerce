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
      body: GridView(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,

        children: List.generate(Globals.controller.offers.length, (index){
          final int _id = Globals.controller.offers[index].id;
          final String _title = Globals.controller.offers[index].title;
          final double _price = Globals.controller.offers[index].price;
          final List _imagesUrls = Globals.controller.offers[index]
              .imagesUrls;
          final double _sellingPrice = Globals.controller.offers[index].sellingPrice;
          return OfferItem(_id, _title, _price, _imagesUrls, _sellingPrice,);
        }),
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

  double _discountPercentage;
  bool _addedToWishlist = false;

  _OfferItemState(this._id, this._title, this._price, this._imagesUrls,
      this._sellingPrice,);

  @override
  void initState() {
    super.initState();
    _discountPercentage = 100 - ((_sellingPrice / _price) * 100);

    _addedToWishlist = Globals.controller.containsWishListItem(_id);
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
                            sectorIndex: Globals.controller
                                .getProductSectorIndex(_id),
                            categoryIndex: Globals.controller
                                .getProductCategoryIndex(_id),
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

                  }else{
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
                    child: Image.asset('assets/add_to_cart.png', width: 35, height: 35,)),
              ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_title),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
              ),
              GestureDetector(
                onTap: () async {
                  if (!_addedToWishlist) {
                    Map addedToWishList = await addToWishList(_id);
                    if (addedToWishList != null &&
                        addedToWishList['result'] == true) {
                      setState(() {
                        _addedToWishlist = true;

                      });
                      Globals.controller.customer.wishList.add(
                          Globals.controller.getProductById(_id)
                      );
                    }
                  } else {
                    Map removedFromWishListApi = await removeFromWishList(_id);
                    if (removedFromWishListApi != null &&
                        removedFromWishListApi['result']) {
                      setState(() {
                        _addedToWishlist = false;
                      });
                      Globals.controller.customer.wishList.remove(
                          Globals.controller.getProductById(_id)
                      );
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

