import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/componants/custom_app_bar.dart';
import 'package:gym/features/custommer/componants/custom_drawer.dart';
import 'package:gym/features/custommer/componants/custom_footer.dart';
import 'package:gym/features/custommer/componants/custom_hero_section.dart';
import 'package:gym/features/custommer/componants/custom_search.dart';
import 'package:gym/features/custommer/componants/product_cart.dart';
import 'package:gym/features/custommer/viewmodel/categorie_controller.dart';
import 'package:gym/features/custommer/viewmodel/product_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedCategoryId = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  bool isAppBarBlack = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 250 && !isAppBarBlack) {
        setState(() => isAppBarBlack = true);
      } else if (_scrollController.offset <= 250 && isAppBarBlack) {
        setState(() => isAppBarBlack = false);
      }
    });
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<CategorieController>(context, listen: false).getCategorie();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final localise = AppLocalizations.of(context)!;
    final productController = Provider.of<ProductController>(context);
    final categorieController = Provider.of<CategorieController>(context);

 
    if (categorieController.categories.isNotEmpty &&
        selectedCategoryId.isEmpty) {
      final firstCategory = categorieController.categories.first;

      Future.delayed(Duration.zero, () async {
        if (!mounted) return;

        setState(() {
          selectedCategoryId = firstCategory.id;
        });

        await productController.getProductByCategorie(firstCategory.id);
      });
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomHeroSection(
                    title: localise.product,
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.home, (ctx) => false),
                    onTapMenu: () => _scaffoldKey.currentState!.openDrawer(),
                  ),

                  SizedBox(height: flex.height(0.020)),

                  CustomSearch(
                    onChanged: (value) {
                      productController.setSearchQuery(value);
                    },
                    onClear: () {
                      productController.setSearchQuery('');
                    },
                  ),

                  SizedBox(height: flex.height(0.020)),

                  // ---------------- CATEGORIES LIST ----------------
                  Container(
                    height: 37,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
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

                            productController.setSearchQuery(''); // تصفير البحث

                            await productController.getProductByCategorie(
                              category.id,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? AppColor.primary : Colors.black,
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

                  const _CustomProductGrid(),

                  const CustomFooter(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: isAppBarBlack ? Colors.black : Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CustomAppBar(
                  onTapMenu: () => _scaffoldKey.currentState!.openDrawer(),
                  onChangeLanguage: () {},
                ),
              ),
            ),
          ],
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

    int cross = isMobile
        ? 2
        : isTablet
            ? 3
            : 4;

    double aspect = isMobile
        ? width < 370
            ? 0.55
            : 0.58
        : isTablet
            ? 0.61
            : width < 1210
                ? 0.61
                : 0.67;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 16
            : isTablet
                ? 40
                : 80,
      ),
      child: productController.isLoad
          ? SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.filteredProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 22,
                mainAxisSpacing: 22,
                childAspectRatio: aspect,
              ),
              itemBuilder: (_, i) =>
                  ProductCart(product: productController.filteredProducts[i]),
            ),
    );
  }
}
