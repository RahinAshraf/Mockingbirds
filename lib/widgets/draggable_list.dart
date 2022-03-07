import 'package:veloplan/widget/panel_widget.dart';

class DraggableList{
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem{
  final DynamicWidget dynamicWidget;

  const DraggableListItem({
    required this.dynamicWidget,
  });

}