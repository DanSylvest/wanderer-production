#!/bin/sh

export UPDATE=true
docker-compose --env-file=.env.local up server client builder zkb-provider