import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/viewmodel/cart_controller.dart';
import 'package:gym/viewmodel/product_controller.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final productController = Provider.of<ProductController>(context);

    double totalPrice = cartController.cartItems.fold(
      0.0,
      (sum, e) => sum + (e.price as double) * (e.qty as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.black,
      ),
      body: cartController.cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: AppTextStyle.normalTextBold,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartController.cartItems[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ProductCart(
                          productId: product.productId,
                          title: product.title,
                          imageUrl: product.image,
                          priceUSD: product.price,
                          qty: product.qty,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${totalPrice.toStringAsFixed(2)} USD",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.checkOutScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    "Checkout",
                    style: AppTextStyle.normalTextBold.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}

class ProductCart extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double priceUSD;
  final int qty;
  final String productId;

  const ProductCart({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.priceUSD,
    required this.qty,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context, listen: false);

    return Card(
      color: Colors.black.withOpacity(0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // معلومات المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${priceUSD.toStringAsFixed(2)} USD",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),

            // أزرار الكمية
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (qty > 1) {
                      cartController.updateQty(productId, qty - 1);
                    } else {
                      cartController.removeProduct(productId);
                    }
                  },
                  icon: const Icon(Icons.remove_circle, color: Colors.white),
                ),
                Text(
                  qty.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    cartController.updateQty(productId, qty + 1);
                  },
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
