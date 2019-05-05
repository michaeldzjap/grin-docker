# grin-docker
Run a Grin node and wallet listener inside individual Docker containers

## Description
This repository showcases a somewhat flexible setup for running a _Grin_ [node](https://github.com/mimblewimble/grin) in a [Docker](https://www.docker.com/) container and a _Grin_ [wallet listener](https://github.com/mimblewimble/grin-wallet) (and optionally a wallet listening on the owner API) in another _Docker_ container.

## Usage
An example _Docker Compose_ file (assuming running on floonet) may look like:

```yaml
version: "3.4"
services:
    grin-server:
        build:
            context: ./server
            dockerfile: Dockerfile
        image: grin-docker-server
        ports:
            - 13413:13413
            - 13414:13414
        env_file:
            - .env

    grin-wallet:
        build:
            context: ./wallet
            dockerfile: Dockerfile
        image: grin-docker-wallet
        ports:
            - 13415:13415
            - 3420:3420
        env_file:
            - .env
        depends_on:
            - grin-server
```
