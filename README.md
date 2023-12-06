# yoga_app

Flutter project for keepyoga mobile app.

Project name: yoga_app
App name: keepyoga
Package name: anuradha

## Project structure
- **Data layer:** Include implementations of processing data
- **Domain layer:** Middle layer between data layer and bloc layer. Include interfaces and dependency relations that can be used in bloc layer and data layer
- **Presentation layer (bloc layer):** Middle layer between views and domain layer
- **Presentation layer (views layer):** Layer directly accessible by the user

## Features
- Home page can be refreshed using RefreshIndicator
- Proper error handling with widgets for displaying errors
- Enter full screen on double tab or vertical drag in video player
- Read more/less feature in lesson player page. When user clicks on the description of lesson, they can toggle the appearance.

- Home page session list has top sessions (only 5 top sessions)
- Created page to view lesson by category
- Categories are
  - Full Body
  - Upper Body
  - Lower Body
  - Hips

- Lesson list sorted by title

## Release
- APK release is Signed
- APK is a fat APK (Did not executed --split-per-abi)
- Use App Center to download and install the APK
