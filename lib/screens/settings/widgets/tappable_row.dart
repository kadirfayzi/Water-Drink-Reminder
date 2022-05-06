import 'package:flutter/material.dart';

/// Build custom inkwell for setting's item
class TappableRow extends StatelessWidget {
  const TappableRow({
    Key? key,
    required this.size,
    required this.title,
    required this.icon,
    this.content,
    this.contentVisible = false,
    this.onTap,
  }) : super(key: key);

  final Size size;
  final String title;
  final Widget icon;
  final Widget? content;
  final bool contentVisible;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.grey.shade300,
          splashColor: Colors.grey.shade300,
          onTap: onTap,
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      icon,
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  contentVisible
                      ? content!
                      : const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.grey,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
}
