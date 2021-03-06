# Mario Jump
<img src="https://user-images.githubusercontent.com/16728804/169667430-0fe73275-4a3d-43ce-9b9a-1d2b15d42ab5.png" width="120px" />
<img src="https://user-images.githubusercontent.com/16728804/169667429-dfbcad4d-55b5-454a-9ebc-21f51d72be05.png" width="120px" />
<img src="https://user-images.githubusercontent.com/16728804/169667434-d74a9324-d50b-46f8-af3d-8a766501feb9.png" width="120px" />

My wife got me a Samsung Watch4 and I discovered that there weren't enough silly
apps for the platform. So, because I'd been meaning to try and do this with my
phone anyway, and Flutter 3 had just come out, I'd go ahead and make the app.

All it really does is listen for acceleration events on the X axis and when you
hit a limit the sound file of Mario from Super Mario Bros. plays with some basic
limits to keep it from playing more than once.

If you're wearing a WearOS watch the X axis is to the left and right directions,
or 9 and 3 o'clock, if you're looking at the watch face. For a phone the
orientation is the same. A bit of polishing could be done to make left and right
hand options but if you set your G-force limit and swing your arm up like Mario
when you jump it works and makes kids (and me) laugh.

## Installation
The most current (and currently only) release can be found here:
https://github.com/justinb4003/mario_jump_flutter/releases/tag/v0.1

The sideloading process varies a bit by device but generally you head into
Settings, the About section, then tap on the version number a bunch of times.
That gets you a new Developer Mode in the Settings menu and from there you can
enable sideloading of apps.  Once done on a phone you can download the apk from
a browser and there should be some option to install it. Not sure; I'm not a
mobile developer.

For the watches WiFi, or Bluetooth needs to be used
for deployment and personal preference from there is to use the official
```adb``` debugging tool for Android. You can find that tool in the Android
command line tools package here:
https://developer.android.com/studio#command-tools

## Development

If you were to diff this against a stock Fluttert project you'd find a few lines
of code in ```main.dart``` and package entries in ```pubspec.yaml```, updates to
icon files, and that's about it. 

Once you've got the basic Flutter demo project running on a system you should be
able to clone this and with a quick ```flutter pub get``` to pull in packages it
should run locally.

## Stock Flutter "Getting Started" Section

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
