import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/controllers/attraction_cubit/attraction_cubit.dart';
import 'package:tejwal/models/attraction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tejwal/utils/app_colors.dart';

class AttractionDetailsPage extends StatelessWidget {
  final Attraction attraction;
  const AttractionDetailsPage({super.key, required this.attraction});

  Future<String?> getDownloadUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.refFromURL(imagePath).getDownloadURL();
    } catch (e) {
      return null; // Return null if the image URL cannot be fetched
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final attractionCubit = BlocProvider.of<AttractionCubit>(
        context); // AttractionCubit passed from homepage
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  height: size.height * 0.4,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
                items: attraction.images.map((url) {
                  return FutureBuilder<String?>(
                    future: getDownloadUrl(url),
                    builder: (context, snapshot) {
                      final imageUrl = snapshot.data;
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: imageUrl != null
                                ? CachedNetworkImageProvider(imageUrl)
                                : const AssetImage('assets/images/imagePlaceholder.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          attraction.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        BlocBuilder<AttractionCubit, AttractionState>(
                          builder: (context, state) {
                            bool isFavorite = false;
                            if (state is AttractionFavoriteStatusChanged) {
                              isFavorite = state.favorites[attraction.id] ?? false;
                            }
                            return IconButton(
                              onPressed: () {
                                attractionCubit.toggleFavoriteStatus(attraction.id);
                              },
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? AppColors.amber : AppColors.grey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Colors.black54,
                          size: 18,
                        ),
                        Text(
                          attraction.city,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        attraction.description,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'التقييم: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        if (attraction.rating == null) ...[
                          const Text(
                            'غير متوفر',
                            style: TextStyle(fontSize: 18),
                          )
                        ] else ...[
                          Row(
                            children: List.generate(
                                attraction.rating!.round(),
                                (index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    )),
                          ),
                        ]
                      ],
                    ),
                    dividerWithPadding(),
                    subTitle('المميزات', context),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 24.0,
                      runSpacing: 12.0,
                      children: attraction.properties.map((property) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.check_circle_outline_rounded,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              property,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    if (attraction.openAt != null) ...[
                      dividerWithPadding(),
                      subTitle('أوقات العمل', context),
                      Row(
                        children: [
                          Text(
                            attraction.openAt!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                    dividerWithPadding(),
                    subTitle('الموقع', context),
                    if (attraction.phone != null) ...[
                      dividerWithPadding(),
                      subTitle('رقم التواصل', context),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            attraction.phone!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ))
                    ],
                    dividerWithPadding(),
                    subTitle('معالم قريبة', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget subTitle(String subTitle, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        subTitle,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.black54, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget dividerWithPadding() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Divider(color: Colors.black54),
  );
}
