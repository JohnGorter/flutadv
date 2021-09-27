# Theming and Resources

---
### Theming and Resources
- Share colors and styles in a Theme
- React to orientation changes
- Use custom fonts
- Use assets

---
### Theming
Share colors and styles

Two options
    - App-wide 
    - Theme Widgets

App-wide themes are Theme Widgets created at root of app
Material Widgets will use these Themes

---
### Theming
Creating an app theme

```
new MaterialApp(
  title: title,
  theme: new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
  ),
);
```

---
### Theming
Theme for part of an application
```
new Theme(
  // Create a unique theme with "new ThemeData"
  data: new ThemeData(
    accentColor: Colors.yellow,
  ),
  child: new FloatingActionButton(
    onPressed: () {},
    child: new Icon(Icons.add),
  ),
);
```

---
### Theming
Extending the parent theme
```
new Theme(
  // Find and Extend the parent theme using "copyWith". 
  data: Theme.of(context).copyWith(accentColor: Colors.yellow),
  child: new FloatingActionButton(
    onPressed: null,
    child: new Icon(Icons.add),
  ),
);
```

---
### Theming
Using a theme
```
child: new Container(
  color: Theme.of(context).accentColor,
  child: new Text(
    'Text with a background color',
    style: Theme.of(context).textTheme.title,
  ),
);
```

---
### Orientation changes
Use  OrientationBuilder widget
```
new OrientationBuilder(
  builder: (context, orientation) {
    return new GridView.count(
      // Create a grid with 2 columns in portrait mode, or 3 columns in
      // landscape mode.
      crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
    );
  },
);
```


---
### Custom Fonts
Steps
- Import and declare the font files
- Set a font as the default
- Use a font in a specific Widget

---
### Custom Fonts
Import the font files
- Store the font files in your project directory
    - assets folder
- Declare fonts in pubspec.yaml

```
flutter:
  fonts:
    - family: Raleway
      fonts:
        - asset: assets/fonts/Raleway-Regular.ttf
        - asset: assets/fonts/Raleway-Italic.ttf
          style: italic
```


---
### Custom Fonts
Use a theme to declare the custom font
```
new MaterialApp(
  title: 'Custom Fonts',
  // Set Raleway as the default app font
  theme: new ThemeData(fontFamily: 'Raleway'),
  home: new MyHomePage(),
);
```

---
### Custom Fonts
Use the font on a specific widget
```
new Text(
  'Roboto Mono sample',
  style: new TextStyle(fontFamily: 'RobotoMono'),
);
```

---
### Resources
- Resources are also called assets
- Asset is a file that is bundled and deployed with your app
- Accessible at runtime

---
### Resources
Example pubspec.yaml
```
flutter:
  assets:
   [- assets/   // <-- all files included ]
    - assets/my_icon.png
    - assets/background.png
```

---
### Resources
Asset variants
Suppose you have this configuration
```
 .../pubspec.yaml
  .../graphics/my_icon.png
  .../graphics/background.png
  .../graphics/dark/background.png
  ...etc.
```
With this pubspec
```
flutter:
  assets:
    - graphics/background.png
```
- background is called the main asset
- dark background is called a variant

---
### Resources
Loading assets
- Access assets through AssetBundle object
- rootBundle object for easy access to main asset bundle

Recommended to obtain the AssetBundle for the current BuildContext using DefaultAssetBundle. Rather than the default asset bundle that was built with the app, this  enables a parent widget to substitute a different AssetBundle at run time, which can be useful for localization or testing scenarios.


---
### Resources
- Use DefaultAssetBundle.of() to indirectly load an asset
- Outside of a Widget context, you can use rootBundle directly

```
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}
```

---
### Resources
- Resolution-aware image assets
- AssetImage maps logical requested asset onto most closely matching current device pixel ratio.

given
```
.../my_icon.png
  .../2.0x/my_icon.png
  .../3.0x/my_icon.png
```

On devices with a device pixel ratio of 1.8, the asset .../2.0x/my_icon.png would be chosen


---
### Resources
- Loading images usung AssetImage
```
Widget build(BuildContext context) {
  // ...
  return new DecoratedBox(
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('graphics/background.png'),
        // ...
      ),
      // ...
    ),
  );
  // ...
}
```

---
### Resources
Asset images in package dependencies

Inside my_icons package
```
.../pubspec.yaml
  .../icons/heart.png
  .../icons/1.5x/heart.png
  .../icons/2.0x/heart.png
  ...etc.
```

Then use it
```
    ...
    new AssetImage('icons/heart.png', package: 'my_icons')
    ...
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo. Adding images and custom fonts


---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!