

import 'package:bloc_implementation/src/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/kategory_artikel_component.dart';
import 'components/kategory_pdf_component.dart';
import 'components/kategory_video_card_list_component.dart';
import 'components/kategory_video_component.dart';
import 'components/search_component.dart';

abstract class UiState {

  Widget build(BuildContext context);
}

class StateHomeContent extends StatefulWidget {
  ScrollController? scrollController;
  ValueChanged selected;
  HomeScreenBloc? bloc;
  Function? function;
  StateHomeContent({this.function,this.scrollController, required this.selected, this.bloc});

  @override
  _StateHomeContentState createState() => _StateHomeContentState();
}

class _StateHomeContentState extends State<StateHomeContent> implements UiState {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _update(value){
    setState(() {
      widget.selected(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return voidContent(widget.bloc!.application.currentCategory);
  }

  Widget voidContent(CategoryContentEnum state) {
    switch (state) {
      case CategoryContentEnum.PDF:
        return CategoryPdfComponent(
          homeScreenBloc: widget.bloc,
          currentState: widget.bloc!.application.isLihatSemua,
          onTap: (value) => _update(value),
          scrollController: widget.scrollController,
        );
      case CategoryContentEnum.ARTICLE:
        return CategoryArticleComponent(
          homeScreenBloc: widget.bloc,
          currentState: widget.bloc!.application.isLihatSemua,
          onTap: (value) => _update(value),
          scrollController: widget.scrollController,
        );
      case CategoryContentEnum.VIDEO:
        return CategoryVideoCardListComponent(
          homeScreenBloc: widget.bloc,
          currentState: widget.bloc!.application.isLihatSemua,
          scrollController: widget.scrollController,
        );
      case CategoryContentEnum.SEARCH:
        return SearchComponent(
          currentState: widget.bloc!.application.isLihatSemua,
          scrollController: widget.scrollController,
          onTap: (value) => _update(value),
          searchRepository: widget.bloc,
        );
      default:
        return ListView(
          shrinkWrap: true,
          controller: widget.scrollController,
          children: [
            CategoryPdfComponent(
              homeScreenBloc: widget.bloc,
              currentState: widget.bloc!.application.isLihatSemua,
              onTap: (value) => _update(value),
              scrollController: widget.scrollController,
            ),
            CategoryArticleComponent(
              homeScreenBloc: widget.bloc,
              currentState: widget.bloc!.application.isLihatSemua,
              onTap: (value) => _update(value),
              scrollController: widget.scrollController,
            ),
            CategoryVideoComponent(
              homeScreenBloc: widget.bloc,
              currentState: widget.bloc!.application.isLihatSemua,
              onTap: (value) => _update(value),
              scrollController: widget.scrollController,
            ),
          ],
        );
    }
  }

}
