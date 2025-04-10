const String imagesPath = 'assets/images';
const String iconsPath = 'assets/icons';

abstract class ImageAssets {
  static const String splashBackground = '$imagesPath/splash_background.png';
  static const String egyptImage = '$imagesPath/egypt.png';
  static const String usImage = '$imagesPath/splash_background.png';
  static const String welcomeImage = '$imagesPath/welcome.png';
  static const String resetImage = '$imagesPath/wightLogo.png';
  static const String logoImage = '$imagesPath/logo.png';
  static const String loginImage = '$imagesPath/login.png';
  static const String registerImage = '$imagesPath/register.png';
  static const String chatBackground = '$imagesPath/chat_background.png';
  static const String userPlaceholder = '$imagesPath/user_placeholder.png';
  static const String groupPlaceholder = '$imagesPath/group_placeholder.png';
  static const String emptyChat = '$imagesPath/empty_chat.png';
  static const String noMessages = '$imagesPath/no_messages.png';
  static const String noContacts = '$imagesPath/no_contacts.png';
  static const String appleIcon = '$imagesPath/apple.png';
  static const String facebookIcon = '$imagesPath/facebook.png';
  static const String googleIcon = '$imagesPath/google.png';
}

abstract class IconAssets {
  // Navigation Icons
  static const String home = '$iconsPath/home.png';
  static const String chat = '$iconsPath/chat.png';
  static const String profile = '$iconsPath/profile.png';
  static const String settings = '$iconsPath/settings.png';

  // Action Icons
  static const String send = '$iconsPath/send.png';
  static const String attachment = '$iconsPath/attachment.png';
  static const String camera = '$iconsPath/camera.png';
  static const String gallery = '$iconsPath/gallery.png';

  // Status Icons
  static const String online = '$iconsPath/online.png';
  static const String offline = '$iconsPath/offline.png';
  static const String typing = '$iconsPath/typing.png';
}

abstract class AnimationAssets {
  static const String loading = 'assets/animations/loading.json';
  static const String empty = 'assets/animations/empty.json';
  static const String error = 'assets/animations/error.json';
}
