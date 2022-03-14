# flutterr - is the alias to the latest version of flutter
alias flutterr="/Users/jyotirmoy.paul/Documents/tools/flutter_latest/bin/flutter"

# build the web app
flutterr build web --web-renderer canvaskit

# deploy
cd build/web

python3 -m http.server 8000