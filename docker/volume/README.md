docker build -t volume .
docker run -v "$(pwd)/site:/usr/share/nginx/html" -p 8080:80 nginx