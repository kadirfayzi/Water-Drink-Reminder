import 'package:flutter/material.dart';
class BuildAppBar extends StatelessWidget with PreferredSizeWidget {
  const BuildAppBar({
    Key? key,
    this.bottom,
    this.title,
  }) : super(key: key);
  final PreferredSizeWidget? bottom;
  final Widget? title;

  @override
  Widget build(BuildContext context) => AppBar(
        bottom: bottom,
        title: title,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black26, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
