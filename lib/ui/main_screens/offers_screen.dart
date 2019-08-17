import 'package:flutter/material.dart';
import '../../globals.dart';

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          final String _imageUrl = Globals.controller.offers[index].imageUrl;
          final int _color = Globals.controller.offers[index].color;
          final String _size = Globals.controller.offers[index].size;
          final double _discountPecentage = Globals.controller.offers[index].discountPecentage;
          return OfferItem(_id, _title, _price, _imageUrl, _color, _size, _discountPecentage);
        }),
      ),
    );
  }
}


class OfferItem extends StatefulWidget {
  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final int _color;
  final String _size;
  final double _discountPecentage;

  OfferItem(this._id, this._title, this._price, this._imageUrl, this._color, this._size, this._discountPecentage);
  @override
  _OfferItemState createState() => _OfferItemState(this._id, this._title, this._price, this._imageUrl, this._color, this._size, this._discountPecentage);
}

class _OfferItemState extends State<OfferItem> {

  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final int _color;
  final String _size;
  final double _discountPecentage;
  bool _addedToWishlist = false;

  _OfferItemState(this._id, this._title, this._price, this._imageUrl, this._color, this._size, this._discountPecentage);

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < Globals.controller.customer.wishList.length ; i++){
      if(Globals.controller.customer.wishList.contains(Globals.controller.getProductById(_id))){
        _addedToWishlist = true;
        break;
      }
    }
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

                  },
                  child: Image.network(_imageUrl,
                    width: 150,
                    height: 100,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(!Globals.controller.containsCartItem(_id)){
                    Globals.controller.addToCart(Globals.controller.getProductById(_id), 1);
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
                    Image.asset('assets/offerbg.png', width: 55, height: 55, fit: BoxFit.cover,),
                    Transform.rotate(
                      angle: 5.49779,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text('$_discountPecentage%',
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
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('${_price - (_price * (_discountPecentage / 100))} SR'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('$_price SR',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _addedToWishlist = _addedToWishlist?false: true;
                    if(_addedToWishlist){
                      Globals.controller.customer.wishList.add(
                          Globals.controller.getProductById(_id)
                      );
                    } else {
                      Globals.controller.customer.wishList.remove(
                          Globals.controller.getProductById(_id)
                      );
                    }
                  });
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

