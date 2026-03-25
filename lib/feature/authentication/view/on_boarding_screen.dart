import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/feature/authentication/view/login_screen.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static final pagePath = '/on_boarding_page';
  static final pageName = 'OnBoardingPage';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _buildGradientBackground(),
              _buildLogo(context),
              _cardBrowonyPlus(constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Opacity(
        opacity: 0.07,
        child: Assets.png.patternBrowny.image(
          width: 1.sw,
          height: 0.7.sh,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 100.h),
          Assets.images.brownyPlusLogo.image(width: 200.w, height: 200.w),
        ],
      ),
    );
  }

  Widget _cardBrowonyPlus(BoxConstraints constraints) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.productBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDims.primaryRadius * 1.5),
            topRight: Radius.circular(AppDims.primaryRadius * 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDims.size_18.w,
          vertical: AppDims.size_32.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppDims.size_8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDims.size_8.w),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: AppDims.size_20.w,
              ),
            ),
            AppDims.vericalPadding_16,
            Text(
              "พื้นที่สำหรับทีมงาน Browny เท่านั้น",
              style: AppTextStyles.labelMedium.copyWith(
                color: const Color(0xFF593817),
                fontSize: 21.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDims.vericalPadding_4,
            Text(
              "แอพพลิเคชันนี้ สำหรับการใช้งานของพนักงานเท่านั้น",
              style: AppTextStyles.labelSmallSlim.copyWith(
                color: const Color(0xFF616161),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 120.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pushNamed(LoginScreen.pageName);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppDims.size_12.w),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      Assets.svg.icForward,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      width: AppDims.size_20.w,
                      height: AppDims.size_20.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
