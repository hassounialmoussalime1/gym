import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/custommer/viewmodel/cart_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProudctModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool added = false;

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final cartController = Provider.of<CartController>(context);
    final flex = FlexibleSize(context);

    final discountedPrice =
        widget.product.price * (1 - widget.product.discount / 100);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(localise.productDetail, style: AppTextStyle.normalTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE CARD
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: flex.height(0.35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.contain,
                  ),
                ),

                /// DISCOUNT BADGE
                if (widget.product.discount > 0)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${widget.product.discount}%',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            /// TITLE
            Text(
              widget.product.title,
              style: AppTextStyle.normalTitle.copyWith(fontSize: 22),
            ),

            const SizedBox(height: 12),

            /// PRICE
            Row(
              children: [
                if (widget.product.discount > 0)
                  Text(
                    '${widget.product.price} KWD',
                    style: AppTextStyle.normalText.copyWith(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (widget.product.discount > 0) const SizedBox(width: 12),
                Text(
                  '${widget.product.discount > 0 ? discountedPrice.toStringAsFixed(2) : widget.product.price} KWD',
                  style: AppTextStyle.normalTitle.copyWith(
                    color: AppColor.primary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION
            Text(
              'الوصف',
              style: AppTextStyle.normalTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.descreption,
              style: AppTextStyle.normalText.copyWith(color: Colors.grey[300]),
            ),
          ],
        ),
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: widget.product.quantiti < 1
          ? const SizedBox()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (added) {
                        Navigator.pushNamed(context, AppRoutes.cartScreen);
                      } else {
                        cartController.addProduct(widget.product);
                        setState(() => added = true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: added ? Colors.white : AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      added ? localise.chekout : localise.addToCart,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: added ? AppColor.primary : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
