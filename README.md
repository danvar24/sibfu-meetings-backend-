# SibFU Meetings — backend

Серверная часть SibFU Meetings: сервиса, который подбирает студентам и сотрудникам СФУ собеседника для кофе-брейка.

Стек: Go (REST API), PostgreSQL 16. Миграции — golang-migrate.

## Что уже есть

- `migrations/` — миграции БД. Сейчас одна: таблица пользователей `users`.
- `docs/database.md` — проект всей базы данных (ER-диаграмма и описание таблиц).
- `docker-compose.yml` — PostgreSQL для локальной разработки.

Код API появится в следующих спринтах (BE-001 и далее).

## Как поднять базу

Нужен Docker.

```bash
docker compose up -d
```

Поднимется PostgreSQL на `localhost:5432` и применятся миграции.

Подключиться: `psql postgres://sibfu:sibfu@localhost:5432/sibfu_meetings`, проверить таблицу: `\d users`.

Откатить миграцию:

```bash
docker compose run --rm migrate -path /migrations -database "postgres://sibfu:sibfu@db:5432/sibfu_meetings?sslmode=disable" down 1
```
