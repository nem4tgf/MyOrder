import 'dart:convert';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderService {
  static const String ordersKey = 'orders';
  final String assetPath = 'assets/order.json';

  Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(ordersKey);

    if (jsonString == null) {
      // No data stored yet in SharedPreferences, load from assets/order.json
      final assetData = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(assetData);
      final orders = jsonList.map((json) => Order.fromJson(json)).toList();

      // Save loaded asset data to SharedPreferences for next time
      await saveOrders(orders);

      return orders;
    }

    // If data exists in SharedPreferences, load from there
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Order.fromJson(json)).toList();
  }

  Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(orders);
    await prefs.setString(ordersKey, jsonString);
  }

  Future<void> addOrder(Order order) async {
    final orders = await loadOrders();
    orders.add(order);
    await saveOrders(orders);
  }
}
