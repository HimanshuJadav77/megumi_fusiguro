import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => home_page_state();
}

class home_page_state extends State<home_page> {
  late CarouselSliderController outerCarouselController =
      CarouselSliderController();
  final List<String> images = [
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fwp7471881-computer-language-wallpapers.jpg?alt=media&token=2ab77995-9115-4e38-98d4-70250157c43c",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2FReact.jpg?alt=media&token=08633862-3d03-4ebf-aa96-1cc3b613bf0f ",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fhelloworld.jpg?alt=media&token=dfa13e92-c049-475a-9107-22b78f918756",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fflutter.jpg?alt=media&token=f0741192-8d85-49a8-a458-47c5d32ebaeb",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fjava-logo-3840x2160-15990.png?alt=media&token=c4e16653-f386-4ae2-8acb-adb30ccc075c",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fmean.jpg?alt=media&token=a7821de3-b14f-4d7c-af1c-fcbf45a99233",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fnodejs.jpg?alt=media&token=ca3e0ef0-89fb-4e4f-9711-e9df3ee9e30e",
    "https://firebasestorage.googleapis.com/v0/b/it-materials-point.appspot.com/o/sliderphotos%2Fpython-dark-3840x2160-16018.png?alt=media&token=aa6fa7c0-8384-4bc1-bd3d-a51c0e2c3c9a",
  ];
  int outerCurrentPage = 0;

  List<String> imageurls = [];

  fetchimageurls() async {
    final StorageRef = FirebaseStorage.instance.ref("sliderphotos");
    final listresult = await StorageRef.listAll();
    List<String> imageurl = [];
    for (var item in listresult.items) {
      final url = await item.getDownloadURL();
      imageurl.add(url);
    }
    setState(() {
      imageurls = imageurl;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchimageurls();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
        ),
        SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                carouselController: outerCarouselController,
                itemCount: imageurls.length,
                itemBuilder: (context, index, realIndex) {
                  return CachedNetworkImage(
                    imageUrl: imageurls[index],
                    fit: BoxFit.fitWidth,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  aspectRatio: 16 / 8,
                  viewportFraction: .80,
                  onPageChanged: (index, reason) {
                    setState(() {
                      outerCurrentPage = index;
                    });
                  },
                ),
              ),

              Positioned(
                left: 11,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                    onPressed: () {
                      outerCarouselController
                          .animateToPage(outerCurrentPage - 1);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),

              /// Right Icon
              Positioned(
                right: 11,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: IconButton(
                    onPressed: () {
                      outerCarouselController
                          .animateToPage(outerCurrentPage + 1);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) {
              bool isSelected = outerCurrentPage == index;
              return GestureDetector(
                onTap: () {
                  outerCarouselController.animateToPage(index);
                },
                child: AnimatedContainer(
                  width: isSelected ? 30 : 10,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.blueAccent : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.black.withOpacity(0.2),
        ),
      ],
    );
  }
}
