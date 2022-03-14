# flutterr - is the alias to the latest version of flutter
alias flutterr="/Users/jyotirmoy.paul/Documents/tools/flutter_latest/bin/flutter"

# clean and get dependencies
flutterr clean
flutterr pub get

# build the web app
flutterr build web

# deploy
firebase deploy