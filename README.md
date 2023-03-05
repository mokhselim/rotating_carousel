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

A simple package with a carousel widget having web look and feel. It let's you pass any number of widgets(yeah widgets, not just images) to be displayed. It also gives you control over how much of the cards containing your widgets you want to overlap(or not). It's lightweight and doesn't depend on any other packages. 


## Usage
The `minRatio` is the ratio of the width of the smallest card to the width of the largest(i.e middle) card. If we pass a positive `overlapRatio` then it tells the RotatingCarousel widget how much of each cards' width we want to overlap with its corresponding neighbouring card. But if we instead pass a negative value they will spaced apart with the same value rather than overlap.

<img src="./demo/gif-0-9-0-3.gif" width="400" height="268"/>

```
RotatingCarousel(
    panels: [
    ...
    ],
    height: 250,
    width: 350,
    minRatio: 0.9,
    overlapRatio: -0.3,
)
```
<img src="./demo/gif-0-7-0-7.gif" width="400" height="268"/>


```
RotatingCarousel(
    panels: [
    ...
    ],
    height: 250,
    width: 350,
    minRatio: 0.7,
    overlapRatio: 0.7,
)
```

<img src="./demo/gif-0-9-0-1(1).gif" width="400" height="268"/>


```
RotatingCarousel(
    panels: [
    ...
    ],
    height: 250,
    width: 350,
    minRatio: 0.9,
    overlapRatio: -0.1,
)
```

<img src="./demo/gif-0-9-0-1.gif" width="400" height="268"/>


```
RotatingCarousel(
    panels: [
    ...
    ],
    height: 250,
    width: 350,
    minRatio: 0.9,
    overlapRatio: 0.1,
)
```

