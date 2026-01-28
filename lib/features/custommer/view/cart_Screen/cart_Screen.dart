// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/viewmodel/cart_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final localise = AppLocalizations.of(context)!;

    // ================= TOTAL AFTER DISCOUNT =================
    double totalPrice = cartController.cartItems.fold(
      0.0,
      (sum, e) {
        double discount = e.discount;
        double finalPrice =
            discount > 0 ? e.price * (1 - discount / 100) : e.price;
        return sum + finalPrice * e.qty;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(localise.cart),
        backgroundColor: Colors.black,
      ),
      body: cartController.cartItems.isEmpty
          ? Center(
              child: Text(
                localise.emptycart,
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
                        child: CartProductItem(
                          productId: product.productId,
                          title: product.title,
                          imageUrl: product.image,
                          price: product.price,
                          discount: product.discount,
                          qty: product.qty,
                        ),
                      );
                    },
                  ),
                ),

                // ================= TOTAL =================
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${localise.totale}:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${totalPrice.toStringAsFixed(2)} KWD",
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
                    localise.checkOut,
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

class CartProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final double discount;
  final int qty;
  final String productId;

  const CartProductItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.qty,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context, listen: false);

    double finalPrice = discount > 0 ? price * (1 - discount / 100) : price;

    return Card(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ================= IMAGE =================
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

            // ================= INFO =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ================= PRICE =================
                  Wrap(
                    spacing: 6,
                    children: [
                      if (discount > 0)
                        Text(
                          "${price.toStringAsFixed(2)} KWD",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white54,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        "${finalPrice.toStringAsFixed(2)} KWD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: discount > 0
                              ? Colors.greenAccent
                              : AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= QTY CONTROLS =================
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
