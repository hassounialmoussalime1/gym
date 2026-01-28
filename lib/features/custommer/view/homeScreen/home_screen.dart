import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/features/custommer/componants/custom_app_bar.dart';
import 'package:gym/features/custommer/componants/custom_drawer.dart';
import 'package:gym/features/custommer/componants/custom_footer.dart';
import 'package:gym/features/custommer/componants/custom_product_grid.dart';
import 'package:gym/features/custommer/viewmodel/categorie_controller.dart';
import 'package:gym/features/custommer/viewmodel/product_controller.dart';
import 'package:gym/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool isAppBarBlack = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !isAppBarBlack) {
        setState(() => isAppBarBlack = true);
      } else if (_scrollController.offset <= 300 && isAppBarBlack) {
        setState(() => isAppBarBlack = false);
      }
    });

    final productController =
        Provider.of<ProductController>(context, listen: false);
    Provider.of<CategorieController>(context, listen: false).getCategorie();
    productController.getbigSalesProduct();
    productController.getFutureProducts();
    productController.getArrivales();
    productController.getDiscountProducts();
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;
    Provider.of<CategorieController>(context);
    final productController = Provider.of<ProductController>(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildHeroSection(flex, isMobile, isTablet),
                  _buildWhyChooseUs(flex, isMobile, isTablet),
                  _buildCategorySection(),
                  productController.bigSalesProduct.isNotEmpty
                      ? _buildSections(context, flex, true, false, false)
                      : SizedBox(),
                  productController.arrivalsProudcts.isNotEmpty
                      ? _buildSections(context, flex, false, true, false)
                      : SizedBox(),
                  productController.featuredProducts.isNotEmpty
                      ? _buildSections(context, flex, false, false, true)
                      : SizedBox(),
                  productController.discountProducts.isNotEmpty
                      ? _buildSections(context, flex, false, false, false)
                      : SizedBox(),
                  CustomFooter(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: isAppBarBlack ? Colors.black : Colors.transparent,
                child: CustomAppBar(
                  onTapMenu: () => _scaffoldKey.currentState!.openDrawer(),
                  onChangeLanguage: () {},
                ),
              ),
            ),
          ],
        ));
  }

  // ---------------------- HERO SECTION ----------------------
  Widget _buildHeroSection(FlexibleSize flex, bool isMobile, bool isTablet) {
    return SizedBox(
      width: flex.screenWidth,
      height: isMobile
          ? flex.height(0.8)
          : isTablet
              ? flex.height(0.7)
              : flex.screenHeight,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/herosection1.jpg',
            fit: BoxFit.cover,
            width: flex.screenWidth,
            height: flex.screenHeight,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                // ignore: deprecated_member_use
                colors: [Colors.black, Colors.black.withOpacity(0.4)],
                stops: [0.0, 1],
              ),
            ),
          ),
          _buildHeroText(flex, isMobile, isTablet),
        ],
      ),
    );
  }

  // ---------------------- HERO TEXT ----------------------
  Widget _buildHeroText(FlexibleSize flex, bool isMobile, bool isTablet) {
    final localise = AppLocalizations.of(context);
    return Positioned(
      right: isMobile ? null : flex.width(0.1),
      left: isMobile ? flex.width(0.05) : null,
      bottom: isMobile ? flex.height(0.02) : flex.height(0.2),
      child: SizedBox(
        width: isMobile
            ? flex.width(0.9)
            : isTablet
                ? flex.width(0.6)
                : flex.width(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localise!.shapeYourBody,
              style: AppTextStyle.normalTitle.copyWith(
                letterSpacing: 5,
                fontSize: isMobile ? 15 : 17,
              ),
            ),
            SizedBox(height: flex.height(0.03)),
            Row(
              children: [
                Text(
                  '${localise.be} ',
                  style: AppTextStyle.largeTitle.copyWith(
                    fontSize: isMobile ? 30 : 35,
                  ),
                ),
                Text(
                  '${localise.strong} ',
                  style: AppTextStyle.largeTitle.copyWith(
                    color: AppColor.primary,
                    fontSize: isMobile ? 30 : 35,
                  ),
                ),
              ],
            ),
            Text(
              localise.trainingHard,
              style: AppTextStyle.largeTitle.copyWith(
                fontSize: isMobile ? 35 : 40,
              ),
            ),
            SizedBox(height: flex.height(0.03)),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.aboutScreen);
              },
              child: Container(
                width: isMobile ? flex.width(0.3) : flex.width(0.2),
                height: isMobile ? flex.height(0.06) : flex.height(0.08),
                color: AppColor.primary,
                alignment: Alignment.center,
                child: Text(
                  localise.info,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 15 : 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------- WHY CHOOSE US ----------------------
  Widget _buildWhyChooseUs(FlexibleSize flex, bool isMobile, bool isTablet) {
    final localise = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(flex.paddingHorizontal(0.05)),
      child: Column(
        children: [
          Text(
            localise.whyChooseUs,
            style: AppTextStyle.normalText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.primary,
            ),
          ),
          SizedBox(height: flex.height(0.02)),
          Text(localise.PUSHYOURLIMITSFORWARD, style: AppTextStyle.normalTitle),
          SizedBox(height: flex.height(0.03)),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile
                  ? 1
                  : isTablet
                      ? 2
                      : 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: isMobile
                  ? 1.4
                  : isTablet
                      ? 1.25
                      : 0.83,
            ),
            itemCount: 4,
            itemBuilder: (_, index) => CartSection(),
          ),
        ],
      ),
    );
  }

  // ---------------------- TOP PRODUCTS ----------------------
}

// ---------------------- CART SECTION ----------------------
class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          HoverDumbbell(),
          SizedBox(height: flex.height(0.020)),
          Text(
            'Modern equipment',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: flex.height(0.020)),
          Text(
            'Quis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan lacus vel facilisis.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ---------------------- HOVER ICON ----------------------
class HoverDumbbell extends StatefulWidget {
  const HoverDumbbell({super.key});

  @override
  State<HoverDumbbell> createState() => _HoverDumbbellState();
}

class _HoverDumbbellState extends State<HoverDumbbell> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color:
              isHover ? AppColor.primary : Color.fromRGBO(255, 255, 255, 0.1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/icons/dumbbell.svg',
          // ignore: deprecated_member_use
          color: isHover ? Colors.white : AppColor.primary,
          width: 33,
          height: 33,
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _buildCategorySection extends StatelessWidget {
  const _buildCategorySection();

  @override
  Widget build(BuildContext context) {
    final localise = AppLocalizations.of(context)!;
    final flex = FlexibleSize(context);
    final isMobile = flex.deviceType == DeviceType.mobile;
    final isTablet = flex.deviceType == DeviceType.tablet;
    final categorieController = Provider.of<CategorieController>(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 30,
      ),
      child: Column(
        children: [
          Text(
            localise.categories,
            style: AppTextStyle.normalTitle.copyWith(
              fontSize: isMobile ? 20 : 26,
            ),
          ),
          SizedBox(height: 20),

          // GRID
          categorieController.categories.isEmpty
              ? SizedBox()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categorieController.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile
                        ? 2
                        : isTablet
                            ? 3
                            : 5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isMobile ? 0.85 : 0.95,
                  ),
                  itemBuilder: (_, i) {
                    final categorie = categorieController.categories[i];
                    return InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.categorieDetaiScreen,
                        arguments: categorie,
                      ),
                      child: _buildCategoryCard(
                        categorie.categoryName,
                        categorie.imgUrl,
                        flex,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

Widget _buildCategoryCard(String title, String imageUrl, FlexibleSize flex) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    ),
    child: Column(
      children: [
        Expanded(
          flex: 7,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSections(
  BuildContext context,
  FlexibleSize flex,
  bool isTopSeler,
  bool isArrivals,
  bool isFeatured,
) {
  final localise = AppLocalizations.of(context)!;
  return Column(
    children: [
      SizedBox(height: flex.height(0.040)),
      Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isTopSeler
                  ? localise.bigsale
                  : isArrivals
                      ? localise.newArivvw
                      : isFeatured
                          ? localise.feature
                          : localise.discount,
              style: AppTextStyle.normalTitle,
            ),
            InkWell(
              onTap: isTopSeler
                  ? () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.futuredProductScreen,
                        arguments: {
                          'isarrivals': false,
                          'isTopSeler': true,
                          'isFeatured': false
                        },
                      );
                    }
                  : isArrivals
                      ? () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.futuredProductScreen,
                            arguments: {
                              'isarrivals': true,
                              'isTopSeler': false,
                              'isFeatured': false
                            },
                          );
                        }
                      : isFeatured
                          ? () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.futuredProductScreen,
                                arguments: {
                                  'isarrivals': false,
                                  'isTopSeler': false,
                                  'isFeatured': true
                                },
                              );
                            }
                          : () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.futuredProductScreen,
                                arguments: {
                                  'isarrivals': false,
                                  'isTopSeler': false,
                                  'isFeatured': false
                                },
                              );
                            },
              child: Text(
                localise.seeMor,
                style: AppTextStyle.normalText.copyWith(
                  color: AppColor.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      isTopSeler
          ? CustomProductGrid(
              title: '',
              isTopSeler: true,
              isArrivals: false,
              isFeatured: false,
            )
          : isArrivals
              ? CustomProductGrid(
                  title: '',
                  isTopSeler: false,
                  isArrivals: true,
                  isFeatured: false,
                )
              : isFeatured
                  ? CustomProductGrid(
                      title: '',
                      isTopSeler: false,
                      isArrivals: false,
                      isFeatured: true,
                    )
                  : CustomProductGrid(
                      title: '',
                      isTopSeler: false,
                      isArrivals: false,
                      isFeatured: false,
                    ),
    ],
  );
}
