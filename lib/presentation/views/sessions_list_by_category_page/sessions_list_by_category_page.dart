import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/enums/session_category_enum.dart';
import '../../../domain/models/session/session_model.dart';
import '../../../domain/repositories/yoga_activities_repository.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../widgets/circular_loader.dart';
import '../../widgets/list_placeholder.dart';
import '../lessons_list_page/lessons_list_page.dart';

class SessionsListByCategoryPage extends StatelessWidget {
  const SessionsListByCategoryPage({super.key, required this.category});

  final SessionCategoryEnum category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: SvgPicture.asset(Assets.leftArrow, width: 24, height: 24),
          ),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${category.text} Sessions',
            maxLines: 2,
            style: const TextStyle(
              color: AppColors.black1,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: GetIt.instance<YogaActivitiesRepository>().getSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularLoader();
          }

          if (snapshot.hasData) {
            var listData = snapshot.data;

            if (listData == null || listData.isEmpty) {
              return _listPlaceHolder;
            } else {
              List<SessionModel> topSessions =
                  listData.where((element) => element.category?.toLowerCase() == category.text.toLowerCase()).toList();

              if (topSessions.isEmpty) {
                return _listPlaceHolder;
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
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
              );
            }
          } else {
            return _listPlaceHolder;
          }
        },
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

  Widget get _listPlaceHolder => const ListPlaceHolder(placeHolderText: 'No sessions available');
}
