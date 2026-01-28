import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/data/models/proudct_model.dart';
import 'package:gym/features/custommer/componants/product_cart.dart';
import 'package:gym/features/custommer/viewmodel/product_controller.dart';
import 'package:provider/provider.dart';

class CustomProductGrid extends StatelessWidget {
  final String title;
  final bool isTopSeler;
  final bool isArrivals;
  final bool isFeatured;
  const CustomProductGrid({
    super.key,
    required this.title,
    required this.isTopSeler,
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
                  ? productController.bigSalesProduct.length > 4
                      ? 4
                      : productController.bigSalesProduct.length
                  : isArrivals
                      ? productController.arrivalsProudcts.length > 4
                          ? 4
                          : productController.arrivalsProudcts.length
                      : isFeatured
                          ? productController.featuredProducts.length > 4
                              ? 4
                              : productController.featuredProducts.length
                          : productController.discountProducts.length > 4
                              ? 4
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
