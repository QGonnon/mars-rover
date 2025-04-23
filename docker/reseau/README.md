docker network create demo-network -d bridge

docker run -d --name container1 --network demo-network reseau
docker run -d --name container2 --network demo-network reseau

docker exec container1 ping container2