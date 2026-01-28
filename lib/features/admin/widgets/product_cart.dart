import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';

class ProductCart extends StatefulWidget {
  final String title;
  final String imageUrl;
  final double priceUSD;
  final int qty;
  final double discount; // نسبة الخصم
  final Function(int) onQtyChanged;

  const ProductCart({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.priceUSD,
    required this.qty,
    required this.onQtyChanged,
    this.discount = 0, // قيمة افتراضية 0
  });

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  late int currentQty;

  @override
  void initState() {
    super.initState();
    currentQty = widget.qty;
  }

  void increaseQty() {
    setState(() {
      currentQty++;
    });
    widget.onQtyChanged(currentQty);
  }

  void decreaseQty() {
    if (currentQty > 1) {
      setState(() {
        currentQty--;
      });
      widget.onQtyChanged(currentQty);
    }
  }

  @override
  Widget build(BuildContext context) {
    // حساب السعر بعد الخصم
    double finalPrice = widget.priceUSD * (1 - widget.discount / 100);

    return Card(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                if (widget.discount > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${widget.discount.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${(finalPrice * currentQty).toStringAsFixed(2)} USD",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: decreaseQty,
                  icon: const Icon(Icons.remove_circle, color: Colors.white),
                ),
                Text(
                  currentQty.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                IconButton(
                  onPressed: increaseQty,
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
