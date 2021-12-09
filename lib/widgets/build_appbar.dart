import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildAppBar extends StatelessWidget with PreferredSizeWidget {
  const BuildAppBar({
    Key? key,
    this.bottom,
    this.title,
  }) : super(key: key);
  final PreferredSizeWidget? bottom;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      bottom: bottom,
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
