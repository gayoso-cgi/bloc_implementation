import 'package:bloc_implementation/src/blocs/details_screens_bloc/details_screens_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/home_screen/components/kategory_video_component.dart';
import 'package:bloc_implementation/src/views/home_screen/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'player_component/player_component.dart';

class DetailVideoScreens extends StatefulWidget {
  static const String ROUTE_ID = "DetailVideoScreens";
  KategoryContentVideo? video;

  DetailVideoScreens(this.video);

  @override
  _DetailVideoScreensState createState() => _DetailVideoScreensState();
}

class _DetailVideoScreensState extends State<DetailVideoScreens> {
  ScrollController scrollController = ScrollController();
  DetailsScreenBloc? _bloc;

  CategoryContentEnum stateLihatSemua = CategoryContentEnum.VIDEO;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailsScreenBloc();
    _bloc!.fetchDetailContent(widget.video!, CategoryContentEnum.VIDEO);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              voidAppBar(),
              voidContainerVideosCard(),
              titleVideos(),
              descriptionVideos(),
              deviderVideos(),
              videoLainnyaCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget voidAppBar() {
    return Container(
      color: primaryColor,
      // padding: EdgeInsets.all(15),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.chevron_left),
              color: scondaryColor,
              onPressed: () {
                Navigator.of(context).pop();
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              }),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreens()),
              );
            },
            child: Container(
              height: 18,
              width: 18,
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Share.share(widget.video!.youtubeUrl!,
                  subject: widget.video!.judul!);
            },
            child: Container(
              margin: EdgeInsets.only(top: 8),
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/icons/share_icon.png"),
              )),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/icons/bookmark_icon.png"),
              )),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget voidContainerVideosCard() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 1.540,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: primaryColor),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.17,
                decoration: BoxDecoration(color: scondaryColor),
              )
            ],
          ),
        ),
        PlayerVideoComponent(widget.video),
      ],
    );
  }

  Widget titleVideos() {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0)),
            child: Container(
              color: scondaryColor,
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              height: MediaQuery.of(context).size.height * 0.90,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.video!.judul!,
                      style: textStyle16PxW700, maxLines: 2, softWrap: true),
                  SizedBox(
                    height: 15,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Text(widget.video!.body ?? "No Description",
                          style: textStyle12PxW400,
                          maxLines: 4,
                          softWrap: true,
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  fit: FlexFit.loose,
                  child: Text(widget.video!.judul!,
                      style: textStyle16PxW700, maxLines: 2, softWrap: true)),
              IconButton(
                  icon: Icon(Icons.arrow_drop_down_outlined), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionVideos() {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Text(widget.video!.body ?? "No Description",
            style: textStyle12PxW400,
            maxLines: 4,
            softWrap: true,
            textAlign: TextAlign.start));
  }

  Widget deviderVideos() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 10),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(
                color: Colors.black,
                height: 1,
              )),
        ),
        Text("Video dan e-Tools Lainnya"),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: 1,
              )),
        ),
      ]),
    );
  }

  Widget videoLainnyaCard() {
    return StreamBuilder<ApiResponse<CategoryContent>>(
        stream: _bloc!.streams,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Center(child: Loading(snapshot.data!.message));
                break;
              case Status.COMPLETED:
                return CategoryVideoComponent(
                  titles: false,
                  scrollController: scrollController,
                  currentState: true,
                  fromDetail: true,
                );
              default:
                return Center(
                  child: Text("no more data"),
                );
            }
          } else {
            return Center(
              child: Text("no more data"),
            );
          }
        });
  }
}
