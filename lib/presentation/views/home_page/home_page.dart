import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/enums/session_category_enum.dart';
import '../../../domain/models/session/session_model.dart';
import '../../../domain/repositories/yoga_activities_repository.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../blocs/authentication_bloc.dart';
import '../../states/authentication_state.dart';
import '../../widgets/circular_loader.dart';
import '../../widgets/list_placeholder.dart';
import '../lessons_list_page/lessons_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _timeBasedGreeting,
          style: const TextStyle(color: AppColors.black1, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Image.asset(Assets.userAvatarPng, width: 32, height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 10),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                AuthenticationBloc().add(LoggedOut());
              },
              child: SvgPicture.asset(Assets.logoutIcon, width: 31, height: 31),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        color: AppColors.grey2,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 135,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var category = SessionCategoryEnum.values[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          margin: const EdgeInsets.only(bottom: 13),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(category.source),
                              )),
                        ),
                        Text(
                          category.text,
                          style: const TextStyle(
                            color: AppColors.black1,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemCount: SessionCategoryEnum.values.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 23, top: 24, bottom: 16),
                padding: const EdgeInsets.only(left: 24, top: 19, bottom: 24, right: 22),
                decoration: BoxDecoration(
                  color: AppColors.indigo1.withOpacity(0.71),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Yoga',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.62,
                          child: const Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(Assets.rightArrow, width: 20, height: 24),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  'Top Sessions',
                  style: TextStyle(
                    color: AppColors.black1,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: GetIt.instance<YogaActivitiesRepository>().getSessions(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(child: CircularLoader());
                }

                if (snapshot.hasData) {
                  var listData = snapshot.data;

                  if (listData == null || listData.isEmpty) {
                    return const SliverFillRemaining(
                      child: ListPlaceHolder(placeHolderText: 'No sessions available'),
                    );
                  } else {
                    List<SessionModel> topSessions = [];
                    if (listData.length >= 3) {
                      topSessions.addAll(listData.sublist(0, 3));
                    } else {
                      topSessions.addAll(listData);
                    }

                    return SliverToBoxAdapter(
                      child: ListView.separated(
                        controller: _controller,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 30, top: 17),
                        itemBuilder: (context, index) {
                          var sessionData = topSessions[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LessonsListPage(sessionData: sessionData),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 20),
                                    color: const Color(0xFF24201E).withOpacity(0.06),
                                    spreadRadius: 0,
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey3,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: sessionData.imageUrl ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) {
                                          return const CircularLoader(
                                            strokeWidth: 1.0,
                                            circleSize: 16.0,
                                          );
                                        },
                                        errorWidget: (_, __, ___) {
                                          return const Center(
                                            child: Icon(Icons.image, size: 25),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sessionData.title ?? 'N/A',
                                          style: const TextStyle(
                                            color: Color(0xFF161719),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${sessionData.lessons?.length ?? '0'} lesson${sessionData.lessons?.length == 1 ? '' : 's'}',
                                          style: TextStyle(
                                            color: AppColors.black2.withOpacity(0.70),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'By ${sessionData.instructor ?? 'N/A'}',
                                              style: const TextStyle(
                                                color: Color(0xFFAAAAAA),
                                                fontSize: 10,
                                              ),
                                            ),
                                            _roundedSeparator,
                                            Text(
                                              sessionData.category ?? 'N/A',
                                              style: const TextStyle(
                                                color: Color(0xFFAAAAAA),
                                                fontSize: 10,
                                              ),
                                            ),
                                            _roundedSeparator,
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 16,
                                              color: Color(0xFFFFC960),
                                            ),
                                            const SizedBox(width: 6.08),
                                            Text(
                                              '4.5',
                                              style: TextStyle(
                                                color: AppColors.black2.withOpacity(0.7),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemCount: topSessions.length,
                      ),
                    );
                  }
                } else {
                  return const SliverFillRemaining(child: ListPlaceHolder(placeHolderText: 'No sessions available'));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget get _roundedSeparator => Container(
        width: 3,
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          color: Color(0xFFAAAAAA),
        ),
      );

  String get _timeBasedGreeting {
    DateTime now = DateTime.now();

    int currentHour = now.hour;

    if (currentHour < 12 && currentHour > 4) {
      return 'Good Morning';
    } else if (currentHour < 17 && currentHour > 11) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
