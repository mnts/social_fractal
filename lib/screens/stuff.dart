import 'dart:convert';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_wysiwyg/slides/mslide.dart';

import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../widgets/slide.dart';

class StuffScreen extends StatefulWidget {
  const StuffScreen({super.key});

  @override
  State<StuffScreen> createState() => _StuffScreenState();
}

class Slide {
  String title = '';
  String text = '';
  String background = '';
  String id = '';
  static MatrixState? matrix;
  Slide.fromItem(item) {
    if (item is Map) {
      title = item['title'];
      text = item['text'] ?? '';
      background = item['background'] ?? '';
    } else if (item is String) {
      id = item;
      readMatrix();
    }
  }

  bool get canEdit => room != null && room!.canChangeStateEvent('m.room.text');

  Room? room;
  Future<List<MatrixEvent>>? futureState;
  readMatrix() async {
    final client = matrix!.client;
    futureState = client.getRoomState(id)
      ..then((state) {
        for (final event in state) {
          if (event.type == 'm.room.text') {
            text = event.content['text'] ?? '';
          }
          if (event.type == 'm.room.name') {
            title = event.content['name'] ?? '';
          }
          if (event.type == 'm.room.avatar') {
            background = event.content['url'] ?? '';
          }
        }
        room = matrix!.client.getRoomById(id);
      });
  }
}

class _StuffScreenState extends State<StuffScreen>
    with AutomaticKeepAliveClientMixin<StuffScreen> {
  @override
  bool get wantKeepAlive => true;

  initState() {
    super.initState();
  }

  buildMatrixSlide(Slide slide) => ReSlide(
        saver: slide.canEdit
            ? (data) {
                final client = Slide.matrix!.client;
                matrix.client.setRoomStateWithKey(
                  slide.room!.id,
                  'm.room.text',
                  '',
                  {'text': data},
                );
              }
            : null,
        loader: () => slide.text,
        ctrls: [
          IconButton(
            //color: theme.canvasColor.withAlpha(200),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                theme.canvasColor.withAlpha(180),
              ),
            ),
            icon: const Icon(Icons.chat),
            onPressed: () {
              VRouter.of(context).to(
                '/rooms/${Uri.encodeComponent(slide.id)}',
              );
            },
          ),
        ],
        background: buildImage(slide),
      );

  buildMapSlide(slide) => ReSlide(
        text: slide.text,
        background: buildImage(slide),
      );

  buildImage(slide) => slide.background.isNotEmpty
      ? slide.background.startsWith('http')
          ? Image.network(
              slide.background,
              fit: BoxFit.cover,
              width: mq.size.width,
              height: mq.size.height,
            )
          : MxcImage(
              key: Key(slide.background),
              uri: Uri.parse(slide.background),
              fit: BoxFit.cover,
              isThumbnail: false,
              width: mq.size.width,
              height: mq.size.height,
              placeholder: (_) => Text(slide.background),
              cacheKey: slide.background,
            )
      : Container(
          color: theme.primaryColor,
          width: mq.size.width,
          height: mq.size.height,
        );

  late MediaQueryData mq;
  late final theme = Theme.of(context);
  late final app = Provider.of<AppFractal>(context);
  late final List<Slide> slides = [
    ...((app.repo['slides'] ?? []) as List)
        .where((el) => (el is Map || matrix.client.isLogged()))
        .map(
          (m) => Slide.fromItem(m),
        )
  ];
  late final matrix = Slide.matrix ??= Matrix.of(context);

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context);

    // vrouter context

    /*
    client.getRoomByAlias('');
    client.search(
      Categories(
        roomEvents: RoomEventsCriteria(
          filter: SearchFilter(),
          searchTerm: 'domain.name',
        ),
      ),
    );
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        //final list = client.rooms.where((el) => el.avatar != null);
        */

    Slide.matrix ??= Matrix.of(context);

    return DefaultTabController(
      length: slides.length,
      child: Stack(
        children: [
          TabBarView(
            //physics: BouncingScrollPhysics(),
            children: [
              ...slides.map(
                (slide) => slide.futureState != null
                    ? FutureBuilder<List<MatrixEvent>>(
                        future: slide.futureState,
                        builder: (
                          context,
                          AsyncSnapshot<List<MatrixEvent>> snapshot,
                        ) {
                          if (snapshot.hasData) return buildMatrixSlide(slide);
                          return CircularProgressIndicator();
                        },
                      )
                    : buildMapSlide(slide),
              ),
            ],
          ),
          Positioned(
            bottom: 2,
            height: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.canvasColor.withAlpha(190),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabs: [
                    for (final slide in slides)
                      slide.futureState != null
                          ? Tab(
                              child: FutureBuilder<List<MatrixEvent>>(
                                future: slide.futureState,
                                builder: (
                                  context,
                                  AsyncSnapshot<List<MatrixEvent>> snapshot,
                                ) {
                                  if (snapshot.hasData)
                                    return Text(
                                      slide.title,
                                    );
                                  return CircularProgressIndicator();
                                },
                              ),
                            )
                          : Tab(
                              text: slide.title,
                            ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
