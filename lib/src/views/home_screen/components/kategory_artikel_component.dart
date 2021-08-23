import 'package:bloc_implementation/src/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_artikel.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/components/network_image_handling_exception.dart';
import 'package:bloc_implementation/src/views/details_screens/details_article_screens/detail_article_screens.dart';
import 'package:flutter/material.dart';
import 'package:bloc_implementation/src/views/components/error.dart';

class CategoryArticleComponent extends StatefulWidget {
  ScrollController? scrollController;
  HomeScreenBloc? homeScreenBloc;
  ValueChanged<CategoryContentEnum>? onTap;
  bool? currentState;
  bool? titles;

  CategoryArticleComponent(
      {
        this.homeScreenBloc,
        this.scrollController,
      this.onTap,
      this.currentState,
      this.titles = true});

  @override
  _CategoryArticleComponentState createState() =>
      _CategoryArticleComponentState();
}

class _CategoryArticleComponentState extends State<CategoryArticleComponent> {
  HomeScreenBloc? _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = widget.homeScreenBloc;
    // _bloc!.fetchContentArticleBloc();
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
            return _bloc!.reset(CategoryContentEnum.ARTICLE);
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
              return LoadingArtikelComponentScreen(handling: Loading(snapshot.data!.message));
            case Status.COMPLETED:
              if (snapshot.data!.data!.articles()!.length == 0) {
                //TODO No Data
                return LoadingArtikelComponentScreen(handling: Text("No Data"),);
              }
              return voidCategoryArticle(snapshot.data!.data!.articles());
            case Status.ERROR:
              return LoadingArtikelComponentScreen(
                handling: Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () => _bloc!.fetchContentArticleBloc(),
                ),
              );
          }
        }
        return LoadingArtikelComponentScreen(handling: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        )),);
        // return Container();
      },
    );
  }

  Widget voidCategoryArticle(List<KategoryContentArtikel>? articles) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 17),
      child: Column(
        children: [
          widget.titles == false
              ? Container()
              : Row(
                  children: [
                    Text(
                      "Artikel Dan Tulisan Ilmiah",
                      style: textStyle16PxW700,
                    ),
                    Expanded(child: Container()),
                    widget.currentState != true
                        ? Container()
                        : InkWell(
                            onTap: () =>
                                widget.onTap!(CategoryContentEnum.ARTICLE),
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
                                ))))
                  ],
                ),

          /// Category Article Card
          widget.currentState == true
              ? articlesGridHorizontal(articles)
              : articlesGridVertical(articles),
        ],
      ),
    );
  }

  articlesGridHorizontal(List<KategoryContentArtikel>? articles) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: MediaQuery.of(context).size.width / 1.65,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.height / 2,
            childAspectRatio: 210 / 161,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1),
        itemCount: articles!.length,
        itemBuilder: (_, index) {
          return ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: _card(articles, index));
        },
      ),
    );
  }

  articlesGridVertical(List<KategoryContentArtikel>? articles) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: MediaQuery.of(context).size.height * 0.7,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            childAspectRatio: 161 / 210,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1),
        itemCount: articles!.length,
        itemBuilder: (_, index) {
          return ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: _card(articles, index));
        },
      ),
    );
  }

  Widget _card(List<KategoryContentArtikel> articles, int index) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, DetailArticleScreens.ROUTE_ID,
          arguments: articles[index]),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        elevation: 1,
        shadowColor: primaryColor,
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: NetworkImageHandlingException(
                    articles[index].cover.toString(),
                    placeHolder: 'assets/images/no_image.png',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      articles[index].judul ?? "",
                      style: textStyle12PxW700,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    )),
                    Center(
                        child: Text(
                      articles[index].deskripsiSingkat ?? "",
                      style: textStyle10PxW400,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingArtikelComponentScreen extends StatefulWidget {
  Widget? handling;

  LoadingArtikelComponentScreen({this.handling});

  @override
  _LoadingArtikelComponentScreenState createState() =>
      _LoadingArtikelComponentScreenState();
}

class _LoadingArtikelComponentScreenState
    extends State<LoadingArtikelComponentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      // child: rowContainer(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              rowContainer(context),
              articlesGridHorizontal(context),
            ],
          ),
          widget.handling ?? Container()
        ],
      ),
    );
  }

  Widget rowContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: shimmerColor
              ),
            ),
          ),
          Expanded(child: Container()),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.25,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: shimmerColor
              ),
            ),
          )
        ],
      ),
    );
  }

  articlesGridHorizontal(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: MediaQuery.of(context).size.width / 1.65,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.height / 2,
            childAspectRatio: 210 / 161,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1),
        itemCount: 2,
        itemBuilder: (_, index) {
          return ConstrainedBox(
              constraints: BoxConstraints.expand(), child: _card());
        },
      ),
    );
  }

  Widget _card() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 1,
      shadowColor: primaryColor,
      child: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: shimmerColor
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Container(
                height: 40,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: shimmerColor
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
