docker-compose --env-file=.env.local stop server client
docker-compose --env-file=.env.local rm server client
docker-compose --env-file=.env.local build server client