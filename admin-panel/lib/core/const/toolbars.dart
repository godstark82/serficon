import 'package:html_editor_enhanced/utils/toolbar.dart';

const customToolbarOptions = [
  FontButtons(),
  FontSettingButtons(fontSizeUnit: false),
  ColorButtons(),
  ListButtons(),
  ParagraphButtons(),
  StyleButtons(),
  InsertButtons(
    video: false,
  ),

];
