import 'package:bloc_implementation/src/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_pdf.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/components/network_image_handling_exception.dart';
import 'package:bloc_implementation/src/views/details_screens/detail_pdf_screens/detail_pdf_screen.dart';
import 'package:flutter/material.dart';

import 'package:bloc_implementation/src/views/components/error.dart';

class CategoryPdfComponent extends StatefulWidget {
  HomeScreenBloc? homeScreenBloc;
  ScrollController? scrollController;
  bool? currentState;
  bool? titles;
  ValueChanged<CategoryContentEnum>? onTap;

  CategoryPdfComponent(
      {
        this.homeScreenBloc, this.scrollController, this.onTap, this.currentState, this.titles});

  @override
  _CategoryPdfComponentState createState() => _CategoryPdfComponentState();
}

class _CategoryPdfComponentState extends State<CategoryPdfComponent> {
  HomeScreenBloc? _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = widget.homeScreenBloc;
    // _bloc!.fetchContentPdfBloc();
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
            return _bloc!.reset(CategoryContentEnum.PDF);
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
              return LoadingPdfComponentScreen(handling: Loading(snapshot.data!.message));
              break;
            case Status.COMPLETED:
              if (snapshot.data!.data!.pdfs()!.length == 0) {
                return Container();
              }
              return voidCategoryPdf(snapshot.data!.data!.pdfs());
            case Status.ERROR:
              return LoadingPdfComponentScreen(
                handling: Error(
                  errorMessage: snapshot.data!.message,
                  onRetryPressed: () => _bloc!.fetchContentArticleBloc(),
                ),
              );
              break;
          }
        }
        return LoadingPdfComponentScreen(handling: Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        )),);
        // return Container();
      },
    );
  }

  Widget voidCategoryPdf(List<KategoryContentPDF>? pdf) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 17),
      child: Column(
        children: [
          widget.titles == false
              ? Container()
              : Row(
                  children: [
                    Text(
                      "e-Book Dan e-Journal",
                      style: textStyle16PxW700,
                    ),
                    Expanded(child: Container()),
                    widget.currentState != true
                        ? Container()
                        : InkWell(
                            onTap: () => widget.onTap!(CategoryContentEnum.PDF),
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

          /// Category Pdf Card
          widget.currentState == true
              ? articlesGridHorizontal(pdf)
              : articlesGridVertical(pdf)
        ],
      ),
    );
  }

  articlesGridHorizontal(List<KategoryContentPDF>? pdf) {
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
        itemCount: pdf!.length,
        itemBuilder: (_, index) {
          return ConstrainedBox(
              constraints: BoxConstraints.expand(), child: _card(pdf, index));
        },
      ),
    );
  }

  articlesGridVertical(List<KategoryContentPDF>? pdf) {
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
        itemCount: pdf!.length,
        itemBuilder: (_, index) {
          return ConstrainedBox(
              constraints: BoxConstraints.expand(), child: _card(pdf, index));
        },
      ),
    );
  }

  Widget _card(List<KategoryContentPDF> pdfs, index) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, DetailPdfScreens.ROUTE_ID,
          arguments: pdfs[index]),
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
                    pdfs[index].cover.toString(),
                    placeHolder: 'assets/images/no_image_pdf.png',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Text(pdfs[index].judul ?? "",
                        style: textStyle12PxW700, maxLines: 2)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingPdfComponentScreen extends StatefulWidget {
  Widget? handling;

  LoadingPdfComponentScreen({this.handling});

  @override
  _LoadingPdfComponentScreenState createState() =>
      _LoadingPdfComponentScreenState();
}

class _LoadingPdfComponentScreenState extends State<LoadingPdfComponentScreen> {
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
