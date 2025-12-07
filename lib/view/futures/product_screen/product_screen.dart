import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/view/componants/custom_drawer.dart';
import 'package:gym/view/componants/custom_footer.dart';
import 'package:gym/view/componants/custom_hero_section.dart';
import 'package:gym/view/componants/custom_product_grid.dart';
import 'package:gym/view/componants/custom_search.dart';
import 'package:gym/view/componants/product_cart.dart';
import 'package:gym/viewmodel/categorie_controller.dart';
import 'package:gym/viewmodel/product_controller.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedCategoryId = ''; // لتحديد الفئة المختارة

  @override
  void initState() {
    super.initState();
    final categorieController = Provider.of<CategorieController>(
      context,
      listen: false,
    );
    categorieController.getCategorie(); // جلب جميع الفئات
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final productController = Provider.of<ProductController>(context);
    final categorieController = Provider.of<CategorieController>(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeroSection(
                title: 'Products',
                onTap: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (ctx) => false),
              ),
              SizedBox(height: flex.height(0.020)),
              CustomSearch(),
              SizedBox(height: flex.height(0.020)),

              // ---------------- CATEGORIES LIST ----------------
              Container(
                height: 37,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorieController.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = categorieController.categories[index];
                    final isSelected = selectedCategoryId == category.id;

                    return GestureDetector(
                      onTap: () async {
                        setState(() => selectedCategoryId = category.id);
                        print(category.id);
                        await productController.getProductByCategorie(
                          category.id,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.primary : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primary,
                              blurRadius: 1,
                              offset: const Offset(1, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            category.categoryName,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColor.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: flex.height(0.040)),

              _CustomProductGrid(),

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
