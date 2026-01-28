import 'package:flutter/material.dart';
import 'package:gym/core/constant/app_color.dart';
import 'package:gym/core/flexible.dart';

class CustomSearch extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback? onClear; // ✅ دالة التفريغ من الخارج

  const CustomSearch({super.key, required this.onChanged, this.onClear});

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  final TextEditingController _controller = TextEditingController();

  void _clearField() {
    _controller.clear();
    if (widget.onClear != null) {
      widget.onClear!(); // ✅ تنفيذ دالة التفريغ الخارجية
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final flex = FlexibleSize(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: flex.screenWidth > 580 ? flex.width(0.5) : flex.screenWidth,
      height: flex.height(0.070),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          widget.onChanged.call(value); 
          setState(() {});
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          prefixIcon: Icon(Icons.search, color: AppColor.primary),


          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColor.primary,
                  onPressed: _clearField,
                )
              : null,

          contentPadding: const EdgeInsets.all(5),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
