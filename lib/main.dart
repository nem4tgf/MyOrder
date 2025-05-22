import 'package:flutter/material.dart';
import 'models/order.dart';
import 'services/order_service.dart';

void main() => runApp(OrderApp());

class OrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'My Order', home: OrderPage(), debugShowCheckedModeBanner: false);
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];

  final _itemCtrl = TextEditingController();
  final _itemNameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController(text: 'USD');
  final _qtyCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    List<Order> orders = await _orderService.loadOrders();
    setState(() {
      _orders = orders;
      _filteredOrders = List.from(orders);
    });
  }

  void _addOrder() async {
    final newOrder = Order(
      item: _itemCtrl.text,
      itemName: _itemNameCtrl.text,
      price: double.tryParse(_priceCtrl.text) ?? 0.0,
      currency: _currencyCtrl.text,
      quantity: int.tryParse(_qtyCtrl.text) ?? 1,
    );
    setState(() {
      _orders.add(newOrder);
      _filteredOrders = List.from(_orders);
    });
    await _orderService.saveOrders(_orders);
  }

  void _searchOrder(String text) {
    setState(() {
      _filteredOrders = _orders
          .where((o) => o.itemName.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _deleteOrder(int index) async {
    setState(() {
      _orders.removeAt(index);
      _filteredOrders = List.from(_orders);
    });
    await _orderService.saveOrders(_orders);
  }

  Widget _buildInput(String label, TextEditingController controller, {double width = 150}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Expanded(
      child: Center(
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _tableCell(String text) {
    return Expanded(child: Center(child: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(height: 30),
        const Text("My Order", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildInput("Item", _itemCtrl),
              const SizedBox(width: 10),
              _buildInput("Item Name", _itemNameCtrl),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildInput("Price", _priceCtrl),
              const SizedBox(width: 10),
              _buildInput("Quantity", _qtyCtrl),
              const SizedBox(width: 10),
              _buildInput("Currency", _currencyCtrl),
            ]),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _addOrder,
                child: const Text("Add Item to Cart"),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(155, 255, 93, 34)),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            color: const Color.fromARGB(155, 255, 93, 34),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              _tableHeader("Id"),
              _tableHeader("Item"),
              _tableHeader("Item Name"),
              _tableHeader("Quantity"),
              _tableHeader("Price"),
              _tableHeader("Currency"),
              SizedBox(width: 40),
            ]),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredOrders.length,
            itemBuilder: (context, index) {
              final o = _filteredOrders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    _tableCell((index + 1).toString()),
                    _tableCell(o.item),
                    _tableCell(o.itemName),
                    _tableCell(o.quantity.toString()),
                    _tableCell(o.price.toStringAsFixed(1)),
                    _tableCell(o.currency),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () => _deleteOrder(index),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          color: const Color.fromARGB(193, 221, 108, 2),
          padding: const EdgeInsets.all(10),
          child: const Text("Số 8, Tôn Thất Thuyết, Cầu Giấy, Hà Nội",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        ),
      ]),
    );
  }
}
