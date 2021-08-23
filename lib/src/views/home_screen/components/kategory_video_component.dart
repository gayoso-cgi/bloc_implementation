import 'package:bloc_implementation/src/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/components/network_image_handling_exception.dart';
import 'package:bloc_implementation/src/views/details_screens/detail_video_screens/detail_video_screens.dart';
import 'package:flutter/material.dart';
import 'package:bloc_implementation/src/views/components/error.dart';

class CategoryVideoComponent extends StatefulWidget {
  ScrollController? scrollController;
  bool? titles;
  bool? currentState;
  bool? fromDetail;
  HomeScreenBloc? homeScreenBloc;
  ValueChanged<CategoryContentEnum>? onTap;

  CategoryVideoComponent(
      {this.titles = true,
        this.homeScreenBloc,
      this.scrollController,
      this.onTap,
      this.currentState,
      this.fromDetail = false});

  @override
  _CategoryVideoComponentState createState() => _CategoryVideoComponentState();
}

class _CategoryVideoComponentState extends State<CategoryVideoComponent> {
  HomeScreenBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.homeScreenBloc;
    if(_bloc == null){
      _bloc = HomeScreenBloc();
      _bloc!.fetchContentVideoBloc();
    }
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: widget.scrollController,
        child: RefreshIndicator(
          onRefresh: ()async{
            _bloc!.application.clearData();
            return _bloc!.reset(CategoryContentEnum.VIDEO);
          },
          child: voidContent(),
        ));
  }

  Widget voidContent() {
    return StreamBuilder<ApiResponse<CategoryContent>>(
      stream: _bloc!.streams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              return LoadingVideoComponentScreen(handling: Loading(snapshot.data!.message));
            case Status.COMPLETED:
              if (snapshot.data!.data!.videos()!.length == 0) {
                //TODO No Data
                return LoadingVideoComponentScreen(handling: Text("No Data"),);
              }
              return voidCategoryVideo(snapshot.data!.data!);

            case Status.ERROR:
              return LoadingVideoComponentScreen(
                handling: Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () => _bloc!.fetchContentVideoBloc(),
                ),
              );
              break;
          }
        }
        return LoadingVideoComponentScreen(handling: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        )),);
      },
    );
  }

  Widget voidCategoryVideo(content) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 17),
      child: Column(
        children: [
          widget.titles == false
              ? Container()
              : Row(
                  children: [
                    Text(
                      "Video dan e-Tools",
                      style: textStyle16PxW700,
                    ),
                    Expanded(child: Container()),
                    widget.currentState != true
                        ? Container()
                        : InkWell(
                            onTap: () {
                              return widget.onTap!(CategoryContentEnum.VIDEO);
                            },
                            child: Container(
                                height: 20,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Center(
                                    child: Text(
                                  "Lihat Semua",
                                  style: textStyle12PxW400.copyWith(
                                      color: scondaryColor),
                                ))),
                          )
                  ],
                ),

          /// Category VIDEO Card
          videosGridList(content),
        ],
      ),
    );
  }

  videosGrid(KategoryContentVideo video) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: () => {
            if (widget.fromDetail!)
              {
                Navigator.pushReplacementNamed(
                    context, DetailVideoScreens.ROUTE_ID,
                    arguments: video)
              }
            else
              {
                Navigator.pushNamed(context, DetailVideoScreens.ROUTE_ID,
                    arguments: video)
              }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width - 72),
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width - 72),
                // alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: NetworkImageHandlingException(
                    video.meta!.thumbnail!.medium!.url!,
                    placeHolder: 'assets/images/no_image.png',
                    stackImage: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(
                            "assets/icons/play_icon_with_shape_icons.png"),
                      )),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      video.judul ?? "",
                      style: textStyle12PxW700,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                    )),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Durasi",
                      style: textStyle12PxW400,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3, top: 5),
                            child: Text(
                                Duration(
                                  hours: int.tryParse(
                                      video.meta!.length!.split(":")[0])!,
                                  minutes: int.tryParse(
                                      video.meta!.length!.split(":")[1])!,
                                  seconds: int.tryParse(
                                      video.meta!.length!.split(":")[2])!,
                                ).inMinutes.toString(),
                                style: new TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text(
                              "min",
                              style: textStyle14PxW400,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Text(video.meta!.length!, style: textStyle34PxW700),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  videosGridList(CategoryContent content) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          for (KategoryContentVideo i in content.videos()!) videosGrid(i)
        ],
      ),
    );
  }
}



class LoadingVideoComponentScreen extends StatefulWidget {
  Widget? handling;
  LoadingVideoComponentScreen({this.handling});

  @override
  _LoadingVideoComponentScreenState createState() => _LoadingVideoComponentScreenState();
}

class _LoadingVideoComponentScreenState extends State<LoadingVideoComponentScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      // child: rowContainer(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          videosGrid(),
          widget.handling??Container()
        ],
      ),
    );
  }


  videosGrid() {
    return Container(
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width - 72),
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width - 72),
                // alignment: Alignment.center,
                child:ClipRRect(
                  // borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: shimmerColor
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          height: 24,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: shimmerColor
                          ),
                        ),
                        Container(
                          height: 18,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: shimmerColor
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


