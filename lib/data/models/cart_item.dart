class CartItem {
  final String productId;
  final String title;
  final String image;
  final double price;
  int qty;

  CartItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    this.qty = 1,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      productId: data['productId'],
      title: data['title'],
      image: data['image'],
      price: data['price'],
      qty: data['qty'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'qty': qty,
      'title': title,
      'image': image,
      'price': price,
    };
  }
}
