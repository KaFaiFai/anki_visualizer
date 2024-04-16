import 'package:anki_progress/services/database/card.dart';
import 'package:flutter/material.dart' hide Card;

class CardsGrid extends StatefulWidget {
  final List<Card> cards;

  const CardsGrid({super.key, required this.cards});

  @override
  State<CardsGrid> createState() => _CardsGridState();
}

class _CardsGridState extends State<CardsGrid> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 5),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        // mainAxisSpacing: 10,
        // crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: widget.cards.length,
      itemBuilder: (BuildContext context, int index) => Text("${widget.cards[index].id}"),
    );
  }
}
