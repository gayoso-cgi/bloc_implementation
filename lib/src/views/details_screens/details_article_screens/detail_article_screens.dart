import 'package:bloc_implementation/src/blocs/details_screens_bloc/details_screens_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_artikel.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/home_screen/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:bloc_implementation/src/views/components/error.dart';

class DetailArticleScreens extends StatefulWidget {
  static const String ROUTE_ID = "DetailArticleScreens";
  KategoryContentArtikel? articles;

  DetailArticleScreens({this.articles});

  @override
  _DetailArticleScreensState createState() => _DetailArticleScreensState();
}

class _DetailArticleScreensState extends State<DetailArticleScreens> {
  ScrollController scrollController = ScrollController();
  DetailsScreenBloc? _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailsScreenBloc();
    _bloc!.fetchDetailContent(widget.articles!, CategoryContentEnum.ARTICLE);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
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
              voidContent(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget voidAppBar() {
    return Container(
      // margin: EdgeInsets.only(right: 14),
      color: primaryColor,
      // padding: EdgeInsets.all(15),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: scondaryColor,
              onPressed: () {
                Navigator.pop(context);
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
                size: 22,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/icons/bookmark_icon.png"),
              )),
            ),
          ),
          SizedBox(
            width: 14,
          ),
        ],
      ),
    );
  }

  Widget voidContent() {
    return StreamBuilder<ApiResponse<CategoryContent>>(
        stream: _bloc!.streams,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return LoadingDetailArticleComponentScreen(handling: Loading(snapshot.data!.message));

              case Status.COMPLETED:
                return ListView(
                  shrinkWrap: true,
                  controller: scrollController,
                  children: [
                    voidContainerArticleCard(
                        snapshot.data!.data!.articles()!.first),
                    titleArticle(snapshot.data!.data!.articles()!.first),
                    descriptionArticle(snapshot.data!.data!.articles()!.first),
                  ],
                );

              case Status.ERROR:
                return LoadingDetailArticleComponentScreen(
                  handling: Error(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.fetchDetailContent(widget.articles!, CategoryContentEnum.ARTICLE),
                  ),
                );
            }
          }
          return LoadingDetailArticleComponentScreen();
        });
  }

  Widget voidContainerArticleCard(KategoryContentArtikel? articles) {
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
        cardArticle(articles)
      ],
    );
  }

  Widget cardArticle(KategoryContentArtikel? articles) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 9),
      height: MediaQuery.of(context).size.width / 1.725,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage, image: articles!.cover.toString()),
    );
  }

  Widget titleArticle(KategoryContentArtikel? articles) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                fit: FlexFit.loose,
                child: Text(articles!.judul!,
                    style: textStyle16PxW700, maxLines: 2, softWrap: true)),
          ],
        ),
      ),
    );
  }

  Widget descriptionArticle(KategoryContentArtikel? articles) {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Text(articles!.body ?? "No Description",
            style: textStyle12PxW400,
            // maxLines: 4,
            softWrap: true,
            textAlign: TextAlign.start));
  }
}



class LoadingDetailArticleComponentScreen extends StatefulWidget {
  Widget? handling;
  LoadingDetailArticleComponentScreen({this.handling});

  @override
  _LoadingDetailArticleComponentScreenState createState() => _LoadingDetailArticleComponentScreenState();
}

class _LoadingDetailArticleComponentScreenState extends State<LoadingDetailArticleComponentScreen> {

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
              cardArticle(),
              titleArticle(),
              descriptionArticle(),
              // voidContainerArticleCard(),
            ],
          ),
          widget.handling??Container()
        ],
      ),
    );
  }


  Widget cardArticle() {
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
        Positioned(
          bottom: 0,
          left: 14,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              // padding: EdgeInsets.all(14),
              width: MediaQuery.of(context).size.width - 28,
              height: MediaQuery.of(context).size.width / 1.540 -28,
              decoration: BoxDecoration(color: shimmerColor),
            ),
          ),
        )
      ],
    );
  }

  Widget titleArticle() {
    return Container(
      padding: EdgeInsets.all(14),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          height: 40,
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: shimmerColor
          ),
        ),
      ),
    );
  }

  Widget descriptionArticle() {
    return Container(
      padding: EdgeInsets.all(14),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          height: MediaQuery.of(context).size.height,
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

