import 'package:flutter/material.dart';
import '../../globals.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


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

        children: List.generate(Globals.controller.products.length, (index){
          final int _id = Globals.controller.products[index].id;
          final String _title = Globals.controller.products[index].title;
          final double _price = Globals.controller.products[index].price;
          final String _imageUrl = Globals.controller.products[index].imageUrl;
          final int _color = Globals.controller.products[index].color;
          final String _size = Globals.controller.products[index].size;
          final double _discountPecentage = Globals.controller.products[index].discountPecentage;
          return ProductItem(_id, _title, _price, _imageUrl, _color, _size, _discountPecentage);
        }),
      ),
    );

  }
}


class ProductItem extends StatefulWidget {

  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final int _color;
  final String _size;
  final double _discountPecentage;

  ProductItem(this._id, this._title, this._price, this._imageUrl, this._color, this._size, this._discountPecentage);
  @override
  _ProductItemState createState() => _ProductItemState(this._id, this._title, this._price, this._imageUrl, this._color, this._size, this._discountPecentage);
}

class _ProductItemState extends State<ProductItem> {

  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final int _color;
  final String _size;
  final double _discountPecentage;

  bool _addedToWishlist = false;
  bool _addedToCart = false;

  _ProductItemState(this._id, this._title, this._price, this._imageUrl, this._color, this._size, this._discountPecentage);

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < Globals.controller.customer.wishList.length ; i++){
      if(Globals.controller.customer.wishList.contains(Globals.controller.getProductById(_id))){
        _addedToWishlist = true;
        break;
      }
    }

    for(int i = 0; i < Globals.controller.customer.cart.length ; i++){
      if(Globals.controller.customer.cart[i].product == Globals.controller.getProductById(_id)){
        _addedToCart = true;
        break;
      }
    }
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

                  },
                  child: Image.network(_imageUrl,
                    width: 100,
                    height: 80,
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
                    child: Image.asset('assets/add_to_cart.png', width: 35, height: 35,)),
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
              _discountPecentage < 100?
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
                  )
                  : Text('$_price SR'),
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

