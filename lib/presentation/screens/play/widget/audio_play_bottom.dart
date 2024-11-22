import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast/core/custom_assets/assets.gen.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';

class AudioPlayBottom extends StatelessWidget {
  const AudioPlayBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final double width= MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
          color:const  Color(0xFF1C1C77),
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: ()=>AppRouter.route.pushNamed(RoutePath.commentsScreen),
            child: Assets.icons.comments.svg(height: 20.h,width: 20.h),
          ),
          GestureDetector(
            onTap: (){},
            child: Assets.icons.donate.svg(height: 20.h,width: 20.h),
          ),
        ],
      ),
    );
  }
}
