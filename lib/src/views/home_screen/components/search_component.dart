import 'package:bloc_implementation/src/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_artikel.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_pdf.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:bloc_implementation/src/models/CategoryContent/icategory_content.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/components/network_image_handling_exception.dart';
import 'package:bloc_implementation/src/views/details_screens/detail_pdf_screens/detail_pdf_screen.dart';
import 'package:bloc_implementation/src/views/details_screens/detail_video_screens/detail_video_screens.dart';
import 'package:bloc_implementation/src/views/details_screens/details_article_screens/detail_article_screens.dart';
import 'package:flutter/material.dart';
import 'package:bloc_implementation/src/views/components/error.dart';



class SearchComponent extends StatefulWidget {
  ScrollController? scrollController;
  bool? titles;
  bool? currentState;
  HomeScreenBloc? searchRepository;
  ValueChanged<CategoryContentEnum>? onTap;
  SearchComponent(
      {this.titles = true,
        this.onTap,
        this.searchRepository,
      this.scrollController,
      this.currentState});

  @override
  _SearchComponentState createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  HomeScreenBloc? _bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = widget.searchRepository;
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
            return _bloc!.reset(CategoryContentEnum.SEARCH, search: _bloc!.application.textSearch);
          },
          child: voidContent(),
        ));
  }

  Widget voidContent() {
    return StreamBuilder<ApiResponse<CategoryContent>>(
      stream: _bloc!.streams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return LoadingSearchComponentScreen(handling: Loading(snapshot.data!.message));
            case Status.COMPLETED:
              if (snapshot.data!.data!.categoryContentList.length == 0) {
                //TODO NO DATA
                return Center(
                  child: Text("No Data"),
                );
              }
              return voidCategoryVideo(snapshot.data!.data!);

            case Status.ERROR:
              return LoadingSearchComponentScreen(handling: Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () => _bloc!.fetchSearchBloc(""),
                ),
              );
              break;
          }
        }
        return LoadingSearchComponentScreen(handling: Center(child: CircularProgressIndicator(
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
                "Pencarian",
                style: textStyle16PxW700,
              ),
              Expanded(child: Container()),
              widget.currentState != true
                  ? Container()
                  : InkWell(
                onTap: () {
                  // return widget.onTap!(CategoryContentEnum.SEARCH);
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


  videosGrid(ICategoryContent contents) {
    return Card(
      elevation: 2,
      child: Container(
        // padding: EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: (){
            if(contents is KategoryContentVideo){
              Navigator.pushNamed(context, DetailVideoScreens.ROUTE_ID,
                  arguments: contents);
            } else if(contents is KategoryContentPDF){
              Navigator.pushNamed(context, DetailPdfScreens.ROUTE_ID,
                  arguments: contents);
            } else if(contents is KategoryContentArtikel){
              Navigator.pushNamed(context, DetailArticleScreens.ROUTE_ID,
                  arguments: contents);
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
                child:ClipRRect(
                  // borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: NetworkImageHandlingException(
                    contents.jenisContent == "video" ? contents.meta!.thumbnail!.medium!.url!: contents.cover!,
                    placeHolder: 'assets/images/no_image.png',
                    stackImage: contents.jenisContent == "video" ? Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/play_icon_with_shape_icons.png"),
                          )),
                    ): null,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          contents.judul ?? "",
                          style: textStyle12PxW700,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                        Text(
                          contents.deskripsiSingkat ?? "",
                          style: textStyle10PxW400,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          softWrap: true,
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

  videosGridList(CategoryContent content) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      // padding: EdgeInsets.symmetric(horizontal: 14),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          for (ICategoryContent i in content.categoryContentList)
            videosGrid(i)
        ],
      ),
    );
  }
}


class LoadingSearchComponentScreen extends StatefulWidget {
  Widget? handling;
  LoadingSearchComponentScreen({this.handling});

  @override
  _LoadingSearchComponentScreenState createState() => _LoadingSearchComponentScreenState();
}

class _LoadingSearchComponentScreenState extends State<LoadingSearchComponentScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              videosGrid(),
              videosGrid(),
              videosGrid(),
              videosGrid(),
            ],
          ),
          widget.handling??Container()
        ],
      ),
    );
  }


  videosGrid() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
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

