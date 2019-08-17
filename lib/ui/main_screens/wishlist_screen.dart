import 'package:flutter/material.dart';

import '../../globals.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>{

  List _list = List.generate(Globals.controller.customer.wishList.length, (i) => Globals.controller.customer.wishList[i]);
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
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(Globals.controller.customer.wishList.length > 0 ?
                          '${Globals.controller.customer.wishList.length} Products'
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
                delegate: SliverChildListDelegate(List.generate(_list.length, (index){
                  final int _id = _list[index].id;
                  final String _title = _list[index].title;
                  final double _price = _list[index].price;
                  final String _imageUrl = _list[index].imageUrl;
                  final double _discountPecentage = _list[index].discountPecentage;
                  return WishListItem(_id, _title, _price, _imageUrl, _discountPecentage, onDelete: (){
                    setState(() {
                      Globals.controller.customer.wishList.removeAt(index);
                      _list = Globals.controller.customer.wishList;
                    });
                  });
                })),
              ),
            ],
          ),
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
  final double _discountPecentage;
  final VoidCallback onDelete;

  WishListItem(this._id, this._title, this._price, this._imageUrl, this._discountPecentage,{this.onDelete});
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
                child: Image.network(_imageUrl,
                  width: 90,
                  height: 80,
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(!Globals.controller.containsCartItem(_id)) {
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
                    child: Image.asset('assets/add_to_cart.png', width: 35, height: 35,),
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
              _discountPecentage < 100?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${_price * (_discountPecentage / 100)} SR'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
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
                onTap: this.onDelete,
                child: Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


