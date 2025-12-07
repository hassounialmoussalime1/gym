import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/viewmodel/cart_controller.dart';
import 'package:provider/provider.dart';

class ProductCart extends StatefulWidget {
  final ProudctModel product;

  const ProductCart({super.key, required this.product});

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  bool added = false;
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    return LayoutBuilder(
      builder: (context, size) {
        double w = size.maxWidth; // ← الحجم الحقيقي داخل Grid item

        // ---------------- Responsive Sizes by CARD WIDTH --------------------
        bool isMobile = w < 200; // بطاقات صغيرة (موبايل)
        bool isTablet = w >= 200 && w < 300;

        double cardPadding = isMobile
            ? 10
            : isTablet
            ? 12
            : 15;
        double imageRadius = isMobile
            ? 12
            : isTablet
            ? 14
            : 16;

        // Text Sizes
        double titleSize = isMobile
            ? 13
            : isTablet
            ? 15
            : 17;
        double priceMainSize = isMobile
            ? 14
            : isTablet
            ? 16
            : 18;
        double priceSubSize = isMobile
            ? 11
            : isTablet
            ? 12
            : 14;

        // Button
        double buttonFont = isMobile ? 12.5 : 14;
        double buttonHeight = isMobile ? 36 : 42;

        // سعر KWD
        double rate = 0.31;
        String priceKWD =
            "${(widget.product.price * rate).toStringAsFixed(2)} KWD";

        return Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1.2,
              // ignore: deprecated_member_use
              color: AppColor.primary.withOpacity(0.5),
            ),
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.35),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // IMAGE — Always Square inside card
              ClipRRect(
                borderRadius: BorderRadius.circular(imageRadius),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(widget.product.image, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 10),

              // TITLE
              SizedBox(
                height: 38,
                child: Text(
                  widget.product.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.normalText.copyWith(
                    fontSize: titleSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // PRICE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    priceKWD,
                    style: AppTextStyle.normalTextBold.copyWith(
                      fontSize: priceMainSize,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${widget.product.price.toStringAsFixed(2)} USD",
                    style: AppTextStyle.normalText.copyWith(
                      fontSize: priceSubSize,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // BUTTON
              SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    added
                        ? Navigator.of(context).pushNamed(AppRoutes.cartScreen)
                        : cartController.addProduct(widget.product);
                    setState(() {
                      added = true;
                    });
                    ;
                  },
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    backgroundColor: added
                        ? Colors.white
                        : AppColor.primary.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    added ? 'go to cart ->' : "ADD TO CART",
                    style: TextStyle(
                      fontSize: buttonFont,
                      color: added ? AppColor.primary : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
