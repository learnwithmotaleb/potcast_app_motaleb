import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetCard extends StatelessWidget {
  const NoInternetCard({super.key, required this.onTap, this.color, this.text});
  final VoidCallback onTap;
  final Color? color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const CustomImage(imageSrc: AppImages.noInternetImage),
          SizedBox(
            height: 20.h,
          ),
          Text(text ?? "Something wrong!",
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16.sp, color: color)),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize:
                    Size(MediaQuery.of(context).size.width / 1.6, 40.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32.r),
                  bottomLeft: Radius.circular(32.r),
                ))),
            child: const Text(
              "Try Again",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
