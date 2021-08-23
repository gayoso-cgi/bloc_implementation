import 'dart:collection';
import 'dart:io';

import 'package:bloc_implementation/src/blocs/details_screens_bloc/details_screens_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_pdf.dart';
import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/views/components/loading.dart';
import 'package:bloc_implementation/src/views/home_screen/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_implementation/src/views/components/error.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flowder/flowder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class DetailPdfScreens extends StatefulWidget {
  static const String ROUTE_ID = "DetailPdfScreens";
  KategoryContentPDF? pdfs;

  DetailPdfScreens({this.pdfs});

  @override
  _DetailPdfScreensState createState() => _DetailPdfScreensState();
}

class _DetailPdfScreensState extends State<DetailPdfScreens> {
  ScrollController scrollController = ScrollController();
  DetailsScreenBloc? _bloc;

  CategoryContentEnum stateLihatSemua = CategoryContentEnum.PDF;

  late DownloaderUtils options;
  late DownloaderCore core;
  String? path;
  final GlobalKey webViewKey = GlobalKey();
  bool isLoading = true;
  String? title, url;
  InAppWebViewController? webViewController;

  late PullToRefreshController pullToRefreshController;
  double progress = 0;

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = (await getApplicationDocumentsDirectory()).path;
  }

  @override
  void initState() {
    super.initState();
    _bloc = DetailsScreenBloc();
    _bloc!.fetchDetailContent(widget.pdfs!, CategoryContentEnum.PDF);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
    initPlatformState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: scondaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                // voidAppBar()
                Container(
                  margin: EdgeInsets.only(right: 14),
                  color: primaryColor,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreens()),
                          );
                        },
                        child: Container(
                          height: 18,
                          width: 18,
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () => downloadFile(),
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/icons/download_icon.png"),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Share.share(widget.pdfs!.file!,
                              subject: widget.pdfs!.judul!);
                        },
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/icons/share_icon.png"),
                          )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            body: Container(
              child: voidContent(),
            )));
  }

  void downloadFile() async {
    _showToast(context, 'Sedang Mendownload File', 'OK');
    if (widget.pdfs!.file!.isNotEmpty) {
      final filename =
          widget.pdfs!.file!.substring(widget.pdfs!.file!.lastIndexOf("/") + 1);
      options = DownloaderUtils(
        progressCallback: (current, total) {
          final progress = (current / total) * 100;
          print("Download $progress");
        },
        file: File('$path/$filename'),
        progress: ProgressImplementation(),
        onDone: () => _showToast(context, 'Download 100% Selesai', 'OK'),
        deleteOnCancel: true,
      );
      core = await Flowder.download(widget.pdfs!.file!, options);
    }
  }

  void _showToast(BuildContext context, title, label) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(title),
        action: SnackBarAction(
            label: label, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget voidContent() {
    return StreamBuilder<ApiResponse<CategoryContent>>(
      stream: _bloc!.streams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              return Center(child: Loading(snapshot.data!.message));
            case Status.COMPLETED:
              return voidPdfViewer(snapshot.data!.data!.pdfs()!.first);
            case Status.ERROR:
              return Center(
                child: Error(
                    errorMessage: snapshot.data!.message,
                    onRetryPressed: () => _bloc!.fetchDetailContent(
                        widget.pdfs!, CategoryContentEnum.PDF)),
              );
          }
        }
        return Container();
      },
    );
  }

  voidPdfViewer(KategoryContentPDF pdf) {
    return Stack(
      children: [
        SizedBox(height: 20),
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
              url: Uri.parse(
                  "https://docs.google.com/gview?embedded=true&url=" +
                      pdf.file!)),
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          pullToRefreshController: pullToRefreshController,
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              )),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            pullToRefreshController.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
            });
          },
        ),
        progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
      ],
    );
  }
}
