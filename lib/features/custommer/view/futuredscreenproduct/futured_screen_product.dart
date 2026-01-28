import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/custommer/componants/custom_footer.dart';
import 'package:gym/features/custommer/componants/product_cart.dart';
import 'package:gym/features/custommer/viewmodel/product_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FuturedScreenProduct extends StatefulWidget {
  final bool isTopSeler;
  final bool isarrivals;
  final bool isFeatured;
  const FuturedScreenProduct({
    super.key,
    required this.isTopSeler,
    required this.isarrivals,
    required this.isFeatured,
  });

  @override
  State<FuturedScreenProduct> createState() => _FuturedScreenProductState();
}

class _FuturedScreenProductState extends State<FuturedScreenProduct> {
  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final localise = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: !widget.isarrivals
              ? Text(
                  widget.isTopSeler
                      ? localise.bigsale
                      : widget.isFeatured
                          ? localise.featureProduct
                          : localise.discount,
                  style: AppTextStyle.normalTitle,
                )
              : Text(localise.newArivvw, style: AppTextStyle.normalTitle),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: flex.height(0.030)),
              widget.isarrivals
                  ? _CustomProductGrid(
                      false,
                      isArrivals: true,
                      isFeatured: false,
                    )
                  : widget.isTopSeler
                      ? _CustomProductGrid(
                          true,
                          isArrivals: false,
                          isFeatured: false,
                        )
                      : widget.isFeatured
                          ? _CustomProductGrid(
                              false,
                              isArrivals: false,
                              isFeatured: true,
                            )
                          : _CustomProductGrid(
                              false,
                              isArrivals: false,
                              isFeatured: false,
                            ),
              SizedBox(height: flex.height(0.030)),
              CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomProductGrid extends StatelessWidget {
  final bool isTopSeler;
  final bool isArrivals;
  final bool isFeatured;
  const _CustomProductGrid(
    this.isTopSeler, {
    required this.isArrivals,
    required this.isFeatured,
  });

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    double width = MediaQuery.of(context).size.width;

    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1024;

    // عدد الأعمدة
    int cross = isMobile
        ? 2
        : isTablet
            ? 3
            : 4;

    // أفضل نسب للكارد الجديد (بدون تأثيرات)
    double aspect = isMobile
        ? width < 370
            ? 0.55
            : 0.58 // perfect for mobile
        : isTablet
            ? width < 870
                ? 0.61
                : 0.61
            : width < 1210
                ? 0.61
                : 0.67; // desktop

    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 16
            : isTablet
                ? 40
                : 80,
        // vertical: 10,
      ),
      child: productController.isLoad
          ? SizedBox(
              height: 100,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isTopSeler
                  ? productController.bigSalesProduct.length
                  : isArrivals
                      ? productController.arrivalsProudcts.length
                      : isFeatured
                          ? productController.featuredProducts.length
                          : productController.discountProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 22,
                mainAxisSpacing: 22,
                childAspectRatio: aspect,
              ),
              itemBuilder: (_, i) {
                ProudctModel product = isTopSeler
                    ? productController.bigSalesProduct[i]
                    : isArrivals
                        ? productController.arrivalsProudcts[i]
                        : isFeatured
                            ? productController.featuredProducts[i]
                            : productController.discountProducts[i];
                return ProductCart(product: product);
              },
            ),
    );
  }
}
