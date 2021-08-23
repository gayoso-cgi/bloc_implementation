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

class CategoryVideoCardListComponent extends StatefulWidget {
  HomeScreenBloc? homeScreenBloc;
  ScrollController? scrollController;
  bool? currentState;

  CategoryVideoCardListComponent({this.homeScreenBloc, this.scrollController, this.currentState});

  @override
  _CategoryVideoCardListComponentState createState() =>
      _CategoryVideoCardListComponentState();
}

class _CategoryVideoCardListComponentState
    extends State<CategoryVideoCardListComponent> {
  HomeScreenBloc? _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = widget.homeScreenBloc;
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
              return LoadingVideoListComponentScreen(handling: Loading(snapshot.data!.message));
              break;
            case Status.COMPLETED:
              if (snapshot.data!.data!.videos()!.length == 0) {
                //TODO No Data
                return LoadingVideoListComponentScreen(
                  handling: Text("No Data"),
                );
              }
              return voidCategoryVideo(snapshot.data!.data!.videos());
              // return Center(child: Text("masuk"),);
            case Status.ERROR:
              return LoadingVideoListComponentScreen(
                handling: Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () => _bloc!.fetchContentVideoBloc(),
                ),
              );
              break;
          }
        }
        return LoadingVideoListComponentScreen(handling: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        )),);
      },
    );
  }

  Widget voidCategoryVideo(List<KategoryContentVideo>? videos) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Video dan e-Tools",
            style: textStyle16PxW700,
          ),

          /// Category VIDEO Card
          videosList(videos)
        ],
      ),
    );
  }

  videosList(List<KategoryContentVideo>? videos) {
    return ListView(
      controller: widget.scrollController,
      shrinkWrap: true,
      children: [
        for (KategoryContentVideo video in videos!)
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
                onTap: () => Navigator.pushNamed(
                    context, DetailVideoScreens.ROUTE_ID,
                    arguments: video),
                child: Column(
                  // controller: widget.scrollController,
                  // shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            child: NetworkImageHandlingException(
                              video.meta!.thumbnail!.high!.url!,
                              placeHolder: 'assets/images/no_image.png',
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                                height: 20,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Color(0xffF8B52B),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Center(
                                    child: Text(
                                  "${Duration(
                                    hours: int.tryParse(
                                        video.meta!.length!.split(":")[0])!,
                                    minutes: int.tryParse(
                                        video.meta!.length!.split(":")[1])!,
                                    seconds: int.tryParse(
                                        video.meta!.length!.split(":")[2])!,
                                  ).inMinutes.toString()}: ${video.meta!.length!.split(":")[2]}",
                                  style: textStyle10PxW400.copyWith(
                                      color: scondaryColor),
                                ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(video.judul ?? "Tidak ada judul",
                          style: textStyle12PxW700, maxLines: 2),
                    )
                  ],
                )),
          )
      ],
    );
  }
}



class LoadingVideoListComponentScreen extends StatefulWidget {
  Widget? handling;
  LoadingVideoListComponentScreen({this.handling});

  @override
  _LoadingVideoListComponentScreenState createState() => _LoadingVideoListComponentScreenState();
}

class _LoadingVideoListComponentScreenState extends State<LoadingVideoListComponentScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: rowContainer(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              titleArticle(),
              titleArticle(),
              titleArticle(),
            ],
          ),
          widget.handling??Container()
        ],
      ),
    );
  }


  Widget titleArticle() {
    return Container(
      padding: EdgeInsets.all(14),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          height: MediaQuery.of(context).size.width / 1.540,
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: shimmerColor
          ),
        ),
      ),
    );
  }

}
