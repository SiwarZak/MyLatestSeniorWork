import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tejwal/models/attraction.dart';
import 'package:tejwal/utils/router/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/controllers/attraction_cubit/attraction_cubit.dart';
import 'package:tejwal/utils/app_colors.dart';

class SectionWithTitleAndContainers extends StatelessWidget {
  final String title;
  final List<Attraction> contentList;
  final cubit;
  final String pageName;
  final bool isCityBased; // New parameter to determine if the section is city-based

  const SectionWithTitleAndContainers({
    super.key,
    required this.title,
    required this.contentList,
    required this.cubit,
    required this.pageName,
    this.isCityBased = false, // Default to false
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: size.height * 0.28,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: contentList.length,
            itemBuilder: (BuildContext context, int index) {
              final attraction = contentList[index];
              final imagePath = (attraction.images.isNotEmpty) ? attraction.images[0] : '';

              return FutureBuilder<String?>(
                future: getDownloadUrl(imagePath),
                builder: (context, snapshot) {
                  final imageUrl = snapshot.data;
                  return SizedBox(
                    width: size.width * 0.42,
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                AppRoutes.attractionDetails,
                                arguments: {
                                  'attraction': attraction,
                                  'cubit': cubit,
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageUrl != null
                                      ? CachedNetworkImageProvider(imageUrl)
                                      : const AssetImage('assets/images/imagePlaceholder.jpg')
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.darken,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          isCityBased ? attraction.city : attraction.category, // Check if section is city-based
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: BlocBuilder<AttractionCubit, AttractionState>(
                                      builder: (context, state) {
                                           bool isFavorite = false;
                                            if (state is AttractionFavoriteStatusChanged) {
                                                 isFavorite = state.favorites[contentList[index].id] ?? false;
                                            }
                                        return IconButton(
                                          onPressed: () {
                                            final attractionCubit = BlocProvider.of<AttractionCubit>(context);
                                            attractionCubit.toggleFavoriteStatus(contentList[index].id);
                                          },
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? AppColors.amber : AppColors.white,
                                          ),
                                        );
                                      },
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              attraction.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
