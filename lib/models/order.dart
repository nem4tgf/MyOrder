class Order {
  String item;
  String itemName;
  double price;
  String currency;
  int quantity;

  Order({required this.item, required this.itemName, required this.price, required this.currency, required this.quantity});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      item: json['Item'],
      itemName: json['ItemName'],
      price: json['Price'].toDouble(),
      currency: json['Currency'],
      quantity: json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Item': item,
        'ItemName': itemName,
        'Price': price,
        'Currency': currency,
        'Quantity': quantity,
      };
}
