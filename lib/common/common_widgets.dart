
import 'package:craft_silicon/common/helpers/sizes.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

icon2ColumnData(
    {required IconData icon, required String title, required String subTitle}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(20.0),
      ),
      color: CRAFTCOLORWHITE,
      boxShadow: [
        BoxShadow(
          color: CRAFTCOLORSUCCESS.withValues(alpha: 0.5),
          spreadRadius: 2,
          blurRadius: 2,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.appHeight(
          20,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Gap(
            AppSizes.appWidth(
              10,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontSize10400,
              ),
              Text(
                subTitle,
                style: fontSize14400.copyWith(
                  color: CRAFTCOLORSUCCESS,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
