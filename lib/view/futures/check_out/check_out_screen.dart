import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/constant/app_text_style.dart';
import 'package:gym/core/flexible.dart';
import 'package:gym/core/navigation/app_routes.dart';
import 'package:gym/viewmodel/cart_controller.dart';
import 'package:gym/viewmodel/order_controller.dart';
import 'package:provider/provider.dart';

class CashOutPage extends StatefulWidget {
  const CashOutPage({super.key});

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);
    final cartController = Provider.of<CartController>(context);
    final orderController = Provider.of<OrderController>(context);

    final cartItems = cartController.cartItems;

    double subTotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.qty),
    );
    double shipping = cartItems.isEmpty ? 0 : 5.0;
    double total = subTotal + shipping;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: flex.deviceType == DeviceType.mobile ? 20 : 80,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...cartItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item.title} x${item.qty}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "\$${(item.price * item.qty).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 30),
                    _buildSummaryLine("Subtotal", subTotal),
                    _buildSummaryLine("Shipping", shipping),
                    _buildSummaryLine("Total", total, bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Input Fields
              _buildTextField("Name", nameController),
              const SizedBox(height: 20),
              _buildTextField(
                "Phone",
                phoneController,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Delivery Address",
                addressController,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: (cartItems.isEmpty || isLoading)
                ? null
                : () async {
                    setState(() => isLoading = true);

                    // إضافة الطلب
                    orderController.addOrder(
                      total,
                      nameController.text,
                      phoneController.text,
                      addressController.text,
                    );

                    // تفريغ الكارت
                    cartController.clearCart();

                    setState(() => isLoading = false);

                    // الانتقال لصفحة شكرا لك
                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ThankYouPage()),
                      );
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Confirm Payment",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryLine(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? AppColor.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColor.primary.withOpacity(0.5)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.primary),
          ),
        ),
      ),
    );
  }
}

// ------------------ THANK YOU PAGE ------------------
class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('GY', style: AppTextStyle.largeTitle),
                Text(
                  'M',
                  style: AppTextStyle.largeTitle.copyWith(
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Icon(Icons.check_circle, color: AppColor.primary, size: 80),
            SizedBox(height: 20),
            Text(
              "Thank you for your order!",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Your request will be processed as quickly as possible and you will be contacted via WhatsApp.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'serif',
                ),
              ),
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (context) => true);
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.primary,

                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                child: Center(
                  child: Text(
                    'Go to home',
                    style: AppTextStyle.normalTextBold.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
