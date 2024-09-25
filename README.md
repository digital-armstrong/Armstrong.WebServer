# Armstrong.Web

![cover](https://user-images.githubusercontent.com/46975515/218666180-742098ba-98f2-4979-960b-6a706436372f.png)

ARMStrong.WebServer -- a monolith analog of [Armstrong.Server](https://github.com/digital-armstrong/Armstrong.Server) 
with the ability to control polling through a web interface.

## Local installation

```bash
git clone git@github.com:digital-armstrong/Armstrong.WebServer.git && \
    cd Armstrong.WebServer && \
    make setup
```

## Starting project

```bash
make start-dev
```

## Refreshing database

```bash
make cleanup
```

## Starting tests and linting code

```bash
make check
```

Or start them separately:

```bash
make lint
```

```bash
make test
```
