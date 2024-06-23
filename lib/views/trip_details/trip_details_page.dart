import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tejwal/controllers/trip_cubit/trip_cubit.dart';
import 'package:tejwal/models/trip.dart';
import 'package:tejwal/utils/app_colors.dart';

class TripDetailsPage extends StatelessWidget {
  final Trip trip;
  const TripDetailsPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final tripCubit =
        BlocProvider.of<TripCubit>(context); //TripCubit passed from homepage

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //first child of main column
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  //carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                    items: trip.images.map((url) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                        //trip name and favorite icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w900),
                            ),
                            BlocBuilder<TripCubit, TripState>(
                              builder: (context, state) {
                                bool isFavorite = false;
                                if (state is TripFavoriteStatusChanged) {
                                  isFavorite = state.favorites[trip.id] ?? false;
                                }
                                return IconButton(
                                  onPressed: () {
                                  tripCubit.toggleFavoriteStatus(trip.id);
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
                        //price
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.shekelSign,
                              color: Colors.black54,
                              size: 12,
                            ),
                            Text(
                              ' ${trip.fee}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        //properties
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 24.0,
                            runSpacing: 12.0,
                            children: trip.properties.map((property) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.check_circle_outline_rounded,
                                      size: 16, color: AppColors.greenShade),
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
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(color: Colors.black26),
                        ),
                        //description
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'الوصف',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            trip.description,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        //*********************************************
                        //ExpansionTile 1
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.greenShade,
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              expansionAnimationStyle:
                                  AnimationStyle.noAnimation,
                              title: Text(
                                'موعد وتكاليف الرحلة',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                              ),
                              children: <Widget>[
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: AppColors.greenShade,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Text(
                                      'موعد الرحلة:',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      ' ${trip.day} ${trip.date}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: AppColors.greenShade,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Text(
                                      'التكلفة للفرد:',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '${trip.fee}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //ExpansionTile 2
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.greenShade,
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              expansionAnimationStyle: AnimationStyle(
                                curve: Easing.emphasizedAccelerate,
                                duration: Durations.medium1,
                              ),
                              title: Text(
                                'مسار الرحلة',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                              ),
                              children: <Widget>[
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: AppColors.greenShade,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Text(
                                      'cccccccccc',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //ExpansionTile 3
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              collapsedIconColor: AppColors.greenShade,
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              expansionAnimationStyle:
                                  AnimationStyle.noAnimation,
                              title: Text(
                                'ملاحظات مهمة',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                              ),
                              children: const <Widget>[
                                ListTile(
                                    title: Text(
                                        'مثلا ممنوع للاشخاص اقل من 18, يجب احضار ماء وحذاء رياضي')),
                              ],
                            ),
                          ),
                        ),
                      ],
                      //***********************************************
                    ),
                  ),
                ],
              ),
            )),

            //second child of main column
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: size.width > 800
                    ? EdgeInsets.symmetric(
                        horizontal: size.height * 0.08, vertical: 16)
                    : const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.052,
                        child: ElevatedButton(
                          onPressed: () {
                            tripCubit.registerForTrip();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenShade,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            'سجل الان',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget wrapItem(BuildContext context, String title, List<String> contentList) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Theme(
//       data: ThemeData().copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//           collapsedIconColor: AppColors.greenShade,
//           tilePadding: const EdgeInsets.symmetric(horizontal: 0),
//           expansionAnimationStyle: AnimationStyle.noAnimation,
//           title: Text(
//             title,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(color: Colors.black54, fontWeight: FontWeight.w600),
//           ),
//           children: contentList.map((e) {
//             return         Wrap(
//                                   alignment: WrapAlignment.start,
//                                   crossAxisAlignment: WrapCrossAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.circle,
//                                       size: 10,
//                                       color: AppColors.greenShade,
//                                     ),
//                                     const SizedBox(
//                                       width: 4.0,
//                                     ),
//                                     const Text(
//                                       'موعد الرحلة:',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     Text(
//                                       ' ${trip.day} ${trip.date}',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                       ),
//                                     )
//                                   ],
//                                 )
//           }).toList()),
//     ),
//   );
// }
