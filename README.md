# Mario Jump

My wife got me a Samsung Watch4 and I discovered that there weren't enough silly apps for the platform. So, because I'd been meaning to try and do this with my phone anyway, and Flutter 3 had just come out, I'd go ahead and make the app.

All it really does is listen for acceleration events on the X axis and when you hit a limit the sound file of Mario from Super Mario Bros. plays with some basic limits to keep it from playing more than once.

If you're wearing a WearOS watch the X axis is to the left and right directions, or 9 and 3 o'clock, if you're looking at the watch face. For a phone the orientation is the same. A bit of polishing could be done to make left and right hand options but if you set your G-force limit and swing your arm up like Mario when you jump it works and makes kids (and me) laugh.

## Installation

There are Android apk files in the ```releases``` folder that you can side load into your phone or watch. The process varies a bit by device but generally you head into Settings, the About section, then tap on the version number a bunch of times. That gets you a new Developer Mode in the Settings menu and from there you can enable sideloading of apps either via USB, WiFi, or Bluetooth. Personal preference from there is to use the official ```adb``` debugging tool for Android. You can find that tool in the Android command line tools package here: https://developer.android.com/studio#command-tools

## Development

If you were to diff this against a stock Fluttert project you'd find a few lines of code in ```main.dart``` and package entries in ```pubspec.yaml```, updates to icon files, and that's about it. 

Once you've got the basic Flutter demo project running on a system you should be able to clone this and with a quick ```flutter pub get``` to pull in packages it should run locally.

## Stock Flutter "Getting Started" Section

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
