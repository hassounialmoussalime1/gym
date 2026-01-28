import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/custommer/viewmodel/cart_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
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
    final localise = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, size) {
        double w = size.maxWidth;

        bool isMobile = w < 200;
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

        double buttonFont = isMobile ? 12.5 : 14;
        double buttonHeight = isMobile ? 36 : 42;

        // ---------- PRICE LOGIC ----------
        double discount = widget.product.discount;
        double originalPrice = widget.product.price;

        double discountedPrice =
            discount > 0 ? originalPrice * (1 - discount / 100) : originalPrice;

        // KWD
        double rate = 1;
        String originalPriceKWD =
            "${(originalPrice * rate).toStringAsFixed(2)} KWD";
        String discountedPriceKWD =
            "${(discountedPrice * rate).toStringAsFixed(2)} KWD";
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // IMAGE
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.productDetail,
                          arguments: widget.product);
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(imageRadius),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              widget.product.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // TITLE
                        Text(
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

                        const SizedBox(height: 6),

                        // PRICE

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (discount > 0)
                              Text(
                                originalPriceKWD,
                                style: AppTextStyle.normalText.copyWith(
                                  fontSize: priceSubSize,
                                  color: Colors.white54,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              discountedPriceKWD,
                              style: AppTextStyle.normalTextBold.copyWith(
                                fontSize: priceMainSize,
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

                  const SizedBox(height: 10),

                  // BUTTON
                  SizedBox(
                    height: buttonHeight,
                    child: widget.product.quantiti < 1
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              if (added) {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.cartScreen);
                              } else {
                                cartController.addProduct(widget.product);
                                setState(() {
                                  added = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: added
                                  ? Colors.white
                                  // ignore: deprecated_member_use
                                  : AppColor.primary.withOpacity(0.85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              added ? localise.chekout : localise.addToCart,
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

              // DISCOUNT BADGE
              if (discount > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-${discount.toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              // OUT OF STOCK
              if (widget.product.quantiti < 1)
                Positioned.fill(
                  child: Container(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.4),
                    alignment: Alignment.center,
                    child: Container(
                      height: 30,
                      color: AppColor.primary,
                      alignment: Alignment.center,
                      child: Text(
                        localise.outOfStock,
                        style: AppTextStyle.normalTextBold,
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
