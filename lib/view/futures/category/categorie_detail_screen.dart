import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/data/models/category_model.dart';
import 'package:gym/view/componants/custom_footer.dart';
import 'package:gym/view/componants/custom_search.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/view/componants/product_cart.dart';
import 'package:gym/viewmodel/product_controller.dart';
import 'package:provider/provider.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  void initState() {
    Provider.of<ProductController>(
      context,
      listen: false,
    ).getProductByCategorie(widget.category.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: false,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GY",
                style: AppTextStyle.normalTitle.copyWith(color: Colors.white),
              ),
              Text(
                "M",
                style: AppTextStyle.normalTitle.copyWith(
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 IMAGE + TITLE (Header Section)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: flex.height(0.30),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.category.imgUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  /// Dark overlay
                  Container(
                    width: double.infinity,
                    height: flex.height(0.30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  /// TITLE over image
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      widget.category.categoryName,
                      style: AppTextStyle.normalTitle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: flex.height(0.015)),

              /// 📌 Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: flex.width(0.04)),
                child: Text(
                  widget.category.descreption,
                  style: AppTextStyle.normalText.copyWith(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: flex.height(0.050)),
              CustomSearch(),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30),
                child: Text(
                  '${widget.category.categoryName} products',
                  style: AppTextStyle.normalTitle.copyWith(
                    color: AppColor.primary,
                  ),
                ),
              ),
              _CustomProductGrid(),
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
  const _CustomProductGrid();

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
          ? Container(
              height: 100,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.productByCategorie.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 22,
                mainAxisSpacing: 22,
                childAspectRatio: aspect,
              ),
              itemBuilder: (_, i) =>
                  ProductCart(product: productController.productByCategorie[i]),
            ),
    );
  }
}
