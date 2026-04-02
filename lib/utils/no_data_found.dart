import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'app_text_style.dart';
import 'colors.dart';

class NoDataFound extends StatefulWidget {
  final String? title;
  const NoDataFound({Key? key, this.title}) : super(key: key);

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content vertically
          children: [
            Lottie.asset('assets/json/nodata.json'),
            Text(
              "Oops! No ${widget.title ?? ".trData"} Available",
              style: AppTextStyle.normalBold16
                  .copyWith(color: lightBlackColor.withOpacity(.4)),
            )
          ],
        ),
      ),
    );
  }
}
