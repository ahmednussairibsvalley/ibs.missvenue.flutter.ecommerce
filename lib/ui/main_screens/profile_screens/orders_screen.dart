import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../globals.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Globals.controller.customer.orders.length,
        itemBuilder: (context, index){
          final int _id = Globals.controller.customer.orders[index].id;
          final String _status = Globals.controller.customer.orders[index].status;
          final DateTime _date = Globals.controller.customer.orders[index].date;
          return Column(
            children: <Widget>[
              OrderItem(_id, _status, _date),
              Divider(),
            ],
          );
        });
  }
}


class OrderItem extends StatefulWidget {
  final int _id;
  final String _status;
  final DateTime _date;

  OrderItem(this._id, this._status, this._date);
  @override
  _OrderItemState createState() => _OrderItemState(this._id, this._status, this._date);
}

class _OrderItemState extends State<OrderItem> {
  final int _id;
  final String _status;
  final DateTime _date;

  _OrderItemState(this._id, this._status, this._date);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(DateFormat.yMMMMd().format(_date),
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text('Order ID #MV$_id',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      trailing: Text(_status,
        style: TextStyle(
            color: _status == 'Delivered'? Colors.green: Colors.orange,
          fontSize: 20,
        ),
      ),
    );
  }
}
