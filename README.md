# Codespace Starter Kit


## Quick Installation in local

```bash
cp .env.example .env
```
- then
```bash

docker network create app

docker compose pull

sudo chown -R 5050:5050 storage/pgadmin/

docker compose up -d mariadb postgres redis minio phpmyadmin pgadmin meilisearch mailhog selenium nginx

```

### Ports

```text
mariadb:3306
```
```text
postgres:5432
```
```text
redis:6379
```
```text
mailhog:1025
```
```text
mongodb:27017
```
```text
mongo-express:8081
```


### Minio

- admin:
[https://minio.codespacex.ir/](https://minio.codespacex.ir/)
- api:
[https://storage.codespacex.ir/](https://storage.codespacex.ir/app)


### Phpmyadmin

- [https://phpmyadmin.codespacex.ir](https://phpmyadmin.codespacex.ir)

### Mongo-express

- [http://mongoexpress.codespacex.ir:8081](http://mongoexpress.codespacex.ir:8081)

### PGAdmin

- [https://pgadmin.codespacex.ir/](https://pgadmin.codespacex.ir/)

### Meilisearch

- [https://meilisearch.codespacex.ir](https://meilisearch.codespacex.ir)

### Mailhog

- [https://mailhog.codespacex.ir/](https://mailhog.codespacex.ir/)


### Selenium

- [https://selenium.codespacex.ir](https://selenium.codespacex.ir)


# Tools

Generate password:
```bash
date +%s | sha256sum | base64 | head -c 32 ; echo
```