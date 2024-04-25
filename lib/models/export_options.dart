enum ExportFormat { gif, mp4 }

class ExportOptions {
  final ExportFormat format;
  final int framerate;

  const ExportOptions({this.format = ExportFormat.gif, this.framerate = 15});
}
