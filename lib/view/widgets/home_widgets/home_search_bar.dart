import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/theme.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  final AppTheme _appTheme = AppTheme().instance;

  bool _isIcon = true;

  @override
  void dispose() {
    _focusNode.dispose();
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isIcon ? Get.width * 0.11 : Get.width * 0.7,
          height: _isIcon ? Get.height * 0.05 : Get.height * 0.045,
          child: _isIcon ? _buildSearchIcon() : _buildTextField(),
        ),
      ],
    );
  }

  Widget _buildTextField() => TextField(
        controller: _editingController,
        focusNode: _focusNode,
        onTapOutside: (event) {
          _focusNode.unfocus();
          _isIcon = true;
          _editingController.clear();
          setState(() {});
        },
        onSubmitted: (value) {
          _focusNode.unfocus();
          _isIcon = true;
          _editingController.clear();
          setState(() {});
        },
        cursorColor: _appTheme.theme.primaryColor,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: _appTheme.theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(2000)),
          hintText: 'أدخل الإسم',
          hintStyle: const TextStyle(color: Colors.black38),
          fillColor: _appTheme.theme.iconButtonTheme.style?.backgroundColor
              ?.resolve(RxSet()),
          filled: true,
        ),
      );

  Widget _buildSearchIcon() => IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          _isIcon = false;
          setState(() {});
          _focusNode.requestFocus();
        },
        iconSize: ((Get.width + Get.height) / 2) * 0.045,
      );
}
