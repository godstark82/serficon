import 'package:html_editor_enhanced/utils/toolbar.dart';

const customToolbarOptions = [
  FontButtons(),
  ColorButtons(),
  ListButtons(),
  ParagraphButtons(),
  InsertButtons(
      video: true,
      audio: true,
      link: true,
      picture: true,
      table: true,
      hr: true)
];
