class CartItem {
  final String productId;
  final String title;
  final String image;
  final double price;
  final double discount;
  int qty;

  CartItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
    required this.discount,
  });

  CartItem copyWith({
    String? productId,
    String? title,
    String? image,
    double? price,
    int? qty,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      discount: discount,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'discount': discount,
      'price': price,
      'qty': qty,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
        productId: map['productId'],
        title: map['title'],
        image: map['image'],
        price: (map['price'] as num).toDouble(),
        qty: map['qty'],
        discount: map['discount'] ?? 0.0);
  }
}
