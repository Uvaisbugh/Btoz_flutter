# App Icon Generation Guide

## Current App Icon Design
The app uses a modern, clean design featuring:
- Blue gradient background (#007AFF)
- White book with text lines
- Graduation cap
- "BTOZ" text

## Required Icon Sizes

### Android
- mipmap-hdpi: 72x72 px
- mipmap-mdpi: 48x48 px  
- mipmap-xhdpi: 96x96 px
- mipmap-xxhdpi: 144x144 px
- mipmap-xxxhdpi: 192x192 px

### iOS
- AppIcon.appiconset: 1024x1024 px (master)
- Various sizes: 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5

## Steps to Generate Icons

1. **Convert SVG to PNG**
   - Use online tools like: https://convertio.co/svg-png/
   - Or use Inkscape, Figma, or Adobe Illustrator
   - Export at 1024x1024 pixels

2. **Generate Android Icons**
   - Use Android Studio's Image Asset Studio
   - Or use online tools like: https://appicon.co/
   - Replace files in `android/app/src/main/res/mipmap-*/`

3. **Generate iOS Icons**
   - Use Xcode's Asset Catalog
   - Or use online tools like: https://appicon.co/
   - Replace files in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Quick Setup
1. Open `assets/images/app_icon.svg` in a vector editor
2. Export as PNG at 1024x1024
3. Use an icon generator tool to create all required sizes
4. Replace the existing icon files in the project

## Alternative: Use flutter_launcher_icons
Add to pubspec.yaml:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/app_icon.png"
  min_sdk_android: 21
```

Then run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
``` 