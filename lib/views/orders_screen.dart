import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Orders>(context, listen: false).loadOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => OrderWidget(orders.orders[i]),
              ),
      ),
    );
  }
}
