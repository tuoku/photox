<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# PhotoX

An all-in-one solution for displaying interactive images

<img src="https://user-images.githubusercontent.com/70937274/216778063-619e86a5-a512-4cf0-af08-6bc35eb75bf6.gif" height="434" width="200">&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/70937274/216778074-3660e543-92a7-48b8-a8c7-65d181eb609e.gif" height="434" width="200">
## Features

- Smoothly animate images into fullscreen and back
- Swipe to dismiss images
- Pinch to zoom
- Automatically generate swipeable gallery when given multiple images

## Getting started

Add `photox` as a dependency in your pubspec.yaml file

```
flutter pub add photox
```

Import PhotoX:
```dart
import 'package:photox/photox.dart';
```

## Usage


```dart
@override
Widget build(BuildContext context) {
  return Container(
    height: 400,
    width: 400,
    child: PhotoX(
      items: [
        PhotoXItem(
          id: "1", resource: "assets/img1.jpg", isAsset: true),
        PhotoXItem(
          id: "2", resource: "assets/img2.jpeg", isAsset: true),
      ]
    )
  );
}
```
## Additional parameters

### dismissMode
| `DismissMode.swipeAny` | `DismissMode.swipeVertical` |
| --- | --- |
| <img src="https://user-images.githubusercontent.com/70937274/218322920-97a5040f-40ad-4052-9ef0-7ee4a176efe3.gif" height="434" width="200"> | <img src="https://user-images.githubusercontent.com/70937274/218322933-cac41507-6faa-4608-a2d0-1e640f1a562a.gif" height="434" width="200"> |

⚠️ `DismissMode.swipeAny` can only be used when provided with a single `PhotoXItem`
