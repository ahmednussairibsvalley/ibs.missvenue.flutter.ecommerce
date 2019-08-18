import 'package:flutter/material.dart';

import '../../utils.dart';

/// Displays the product details.

class ProductDetails extends StatefulWidget {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final double sellingPrice;
  ProductDetails({@required this.id, @required this.title, @required this.price, @required this.imageUrl, @required this.sellingPrice});
  @override
  _ProductDetailsState createState() => _ProductDetailsState(
    id: id, title: title, price: price, imageUrl: imageUrl, sellingPrice: sellingPrice,
  );
}

class _ProductDetailsState extends State<ProductDetails> {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final double sellingPrice;

  _ProductDetailsState({@required this.id, @required this.title, @required this.price, @required this.imageUrl, @required this.sellingPrice});
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            FutureBuilder(
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data){
                    return Image.network(imageUrl,
                      width: _width,
                      height: _width,
                    );
                  } else {
                    return Center(
                      child: Text('Product Image is not available', textAlign: TextAlign.center,),
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
              future: isImageAvailable(imageUrl),
            ),
          ],
        ),
      ),
    );
  }
}
