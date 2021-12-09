import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';

class BuildDialog extends StatelessWidget {
  const BuildDialog({
    Key? key,
    required this.heightPercent,
    this.widthPercent,
    required this.content,
    this.onTapOK,
  }) : super(key: key);

  final double heightPercent;
  final double? widthPercent;
  final Widget content;
  final Function()? onTapOK;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: size.height * heightPercent,
        width: size.width,
        child: Column(
          children: [
            Expanded(child: content),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: onTapOK,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
