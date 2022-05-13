# clean and get dependencies
flutter clean
flutter pub get

# build the web app
flutter build web --web-renderer canvaskit

# deploy
firebase deploy