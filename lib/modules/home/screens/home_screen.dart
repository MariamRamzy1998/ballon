import 'package:arrows/constants/colors.dart';
import 'package:arrows/modules/bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import 'package:arrows/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../components/arrows_app_bar.dart';
import '../../../components/custom_main_screen_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    final bottomNavBarController = Get.put(BottomNavBarController());
    PageController pageController = PageController(initialPage: 0);

    return Scaffold(
      appBar: ArrowsAppBar(
        'home'.tr,
      ),
      body: SingleChildScrollView(
          child: Obx(
        () => homeController.isLoading.value
            ? Container(
                height: 500.h,
                child: Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                ))
            : Column(
                children: [
                  SizedBox(height: 10.h),
                  Obx(() => CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            height: Get.height / 3.h,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              homeController.currentImageIndex.value = index;
                            }),
                        items: homeController.homeAdsImages
                            .map((item) => Container(
                                clipBehavior: Clip.antiAlias,
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: mainColor, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: OctoImage(
                                  image: CachedNetworkImageProvider(
                                    item!,
                                  ),
                                  placeholderBuilder: OctoPlaceholder.blurHash(
                                      'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                      fit: BoxFit.cover),
                                  errorBuilder: (context, url, error) {
                                    return BlurHash(
                                        hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj');
                                  },
                                  fit: BoxFit.cover,
                                )))
                            .toList(),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() => AnimatedSmoothIndicator(
                        activeIndex: homeController.currentImageIndex.value,
                        count: 3,
                        effect: ExpandingDotsEffect(
                            dotHeight: 5,
                            dotWidth: 5,
                            activeDotColor: mainColor,
                            dotColor: mainColor),
                      )),
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الفئات'.tr,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'عرض المزيد'.tr,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.w),
                      child: GridView.builder(
                          shrinkWrap: true,
                          cacheExtent: 1500,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 120.w,
                                  childAspectRatio: 6 / 9,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 20.w),
                          itemCount: homeController.category!.data!.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                // mainCategoriesController.index = index;
                                // Get.to(() => SubCategoriesScreen(
                                //     title: mainCategoriesController
                                //         .categories[index].name!.tr));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 12 / 10,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: CachedNetworkImage(
                                              imageUrl: homeController.category!
                                                  .data![index].photo!,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Center(
                                                    child: SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: kPrimaryColor
                                                            .withOpacity(0.6),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        height: 50.h,
                                        padding: EdgeInsets.all(2.r),
                                        child: Text(
                                          homeController
                                              .category!.data![index].name!,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          })),
                ],
              ),
      )),
    );
  }
}