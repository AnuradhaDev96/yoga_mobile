import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/models/session/session_model.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';
import '../../../widgets/list_placeholder.dart';

class LessonsListView extends StatefulWidget {
  const LessonsListView({super.key, required this.sessionData, required this.toggleFunction});

  final SessionModel sessionData;
  final Function toggleFunction;

  @override
  State<LessonsListView> createState() => _LessonsListViewState();
}

class _LessonsListViewState extends State<LessonsListView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // key: _listScrollGlobalKey,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(color: AppColors.grey4, borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 14, bottom: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    '${widget.sessionData.title ?? 'N/A'} ${widget.sessionData.category ?? 'N/A'}',
                    style: const TextStyle(
                      color: AppColors.black1,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${widget.sessionData.lessons?.length ?? '0'} lesson${widget.sessionData.lessons?.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.indigo1,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: (widget.sessionData.lessons != null && widget.sessionData.lessons!.isNotEmpty)
              ? ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 30),
            itemBuilder: (context, index) {
              var lessonData = widget.sessionData.lessons![index];

              return GestureDetector(
                onTap: () => widget.toggleFunction,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 21, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 3),
                        spreadRadius: 0,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(Assets.lessonAvatar, width: 40, height: 40),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lessonData.title ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black1,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.6,
                                child: Text(
                                  lessonData.description ?? 'N/A',
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF7B7F82),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SvgPicture.asset(Assets.lessonCardPlayIcon, width: 27, height: 27),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 23),
            itemCount: widget.sessionData.lessons!.length,
          )
              : const ListPlaceHolder(placeHolderText: 'No lessons available'),
        ),
      ],
    );
  }
}