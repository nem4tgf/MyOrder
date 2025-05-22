import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/order.dart';

class OrderService {
  final String path = 'assets/order.json';

  Future<List<Order>> loadOrders() async {
    final data = await rootBundle.loadString(path);
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => Order.fromJson(json)).toList();
  }

  Future<void> saveOrders(List<Order> orders) async {
    // This is just placeholder logic; saving to file not supported in asset bundle.
    print("Saving: ${jsonEncode(orders)}");
  }
}
