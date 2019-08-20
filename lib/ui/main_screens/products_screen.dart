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

        children: List.generate(Globals.controller.sectors[sectorIndex].categories[categoryIndex].products.length, (index){
          final int _id = Globals.controller.sectors[sectorIndex].categories[categoryIndex].products[index].id;
          final String _title = Globals.controller.sectors[sectorIndex].categories[categoryIndex].products[index].title;
          final double _price = Globals.controller.sectors[sectorIndex].categories[categoryIndex].products[index].price;
          final String _imageUrl = Globals.controller.sectors[sectorIndex].categories[categoryIndex].products[index].imageUrl;
          final double _sellingPrice = Globals.controller.sectors[sectorIndex].categories[categoryIndex].products[index].sellingPrice;
          return ProductItem(_id, _title, _price, _imageUrl, _sellingPrice);
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
  final double _sellingPrice;

  ProductItem(this._id, this._title, this._price, this._imageUrl, this._sellingPrice);
  @override
  _ProductItemState createState() => _ProductItemState(this._id, this._title, this._price, this._imageUrl, this._sellingPrice);
}

class _ProductItemState extends State<ProductItem> {

  final int _id;
  final String _title;
  final double _price;
  final String _imageUrl;
  final double _sellingPrice;

  bool _addedToWishlist = false;
  bool _addedToCart = false;

  _ProductItemState(this._id, this._title, this._price, this._imageUrl, this._sellingPrice);

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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          id: _id,
                          title:_title,
                          price: _price,
                          imageUrl: _imageUrl,
                          sellingPrice: _sellingPrice,
                        ),
                      ),
                    );
                  },
                  child: FutureBuilder(
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data){
                            return Image.network(_imageUrl,
                              width: 90,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Center(
                              child: Text('Product Image is not available', textAlign: TextAlign.center,),
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
                    future: isImageAvailable(_imageUrl),
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
            padding: const EdgeInsets.all(4.0),
            child: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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

