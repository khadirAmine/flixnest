class ImageAssets {
  final String errorImage = 'assets/images/error_image.jpg';
  final String logo = 'assets/images/logo.png';
}

class SvgAssets {
  final String noWifi = 'assets/svg/no_wifi.svg';
  final String error = 'assets/svg/error.svg';
  final String play = 'assets/svg/play.svg';
}

class AppAsset {
  ImageAssets get images => ImageAssets();
  SvgAssets get svgs => SvgAssets();
}
