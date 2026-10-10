# Проект базы данных SibFU Meetings

СУБД: PostgreSQL 16. Схема составлена по пользовательским требованиям (роли Guest, User, Admin).

В Sprint 2 (задача DB-001) создаётся только таблица `users`, миграция `migrations/000001_create_users.up.sql`.
Остальные таблицы появятся миграциями в тех спринтах, где реализуются соответствующие функции.

## ER-диаграмма

```mermaid
erDiagram
    users ||--o| profiles : "имеет"
    institutes ||--o{ profiles : "учится/работает"
    users ||--o{ user_interests : ""
    interests ||--o{ user_interests : ""
    users ||--o| search_queue : "ищет пару"
    users ||--o{ meetings : "участник"
    users ||--o{ complaints : "автор / нарушитель"
    meetings ||--o{ complaints : "по встрече"
    users ||--o{ password_reset_tokens : ""

    users {
        bigint id PK
        citext login UK
        citext email UK
        text password_hash
        user_role role
        user_status status
        timestamptz rules_accepted_at
        timestamptz created_at
        timestamptz updated_at
    }
    profiles {
        bigint user_id PK, FK
        text first_name
        text last_name
        smallint institute_id FK
        smallint course
        text position
        text telegram
        text phone
        text contact_email
    }
    institutes {
        smallint id PK
        text short_name UK
        text full_name
    }
    interests {
        int id PK
        citext name UK
    }
    user_interests {
        bigint user_id PK, FK
        int interest_id PK, FK
    }
    search_queue {
        bigint user_id PK, FK
        timestamptz queued_at
    }
    meetings {
        bigint id PK
        bigint user1_id FK
        bigint user2_id FK
        meeting_status status
        bool user1_confirmed
        bool user2_confirmed
        timestamptz matched_at
        timestamptz confirmed_at
    }
    complaints {
        bigint id PK
        bigint author_id FK
        bigint target_id FK
        bigint meeting_id FK
        text reason
        complaint_status status
        bigint resolved_by FK
        timestamptz created_at
    }
    password_reset_tokens {
        text token_hash PK
        bigint user_id FK
        timestamptz expires_at
        timestamptz used_at
    }
```

## Таблицы

| Таблица | Назначение | Пользовательские истории | Когда создаётся |
|---|---|---|---|
| `users` | логин, почта, хеш пароля, роль, статус блокировки, согласие с правилами | US-g-02, US-g-03, US-g-04, US-a-01, US-a-02 | **Sprint 2, DB-001** |
| `profiles` | имя, институт, курс или должность, контакты | US-u-01, US-u-03 | с задачей профиля |
| `institutes` | справочник институтов СФУ | US-u-01 | с задачей профиля |
| `interests`, `user_interests` | интересы пользователя для подбора пары | US-u-01, US-u-02 | с задачей профиля |
| `search_queue` | очередь «Хочу найти собеседника» | US-u-02 | с задачей подбора пары |
| `meetings` | пары и подтверждение встречи обеими сторонами | US-u-03, US-u-04, US-u-05 | с задачей подбора пары |
| `complaints` | жалобы и их обработка администратором | US-u-06, US-a-03 | с задачей жалоб |
| `password_reset_tokens` | восстановление пароля | US-g-05 | с задачей восстановления пароля |

## Таблица users

| Поле | Тип | Ограничения | Описание |
|---|---|---|---|
| id | BIGSERIAL | PK | идентификатор |
| login | CITEXT | NOT NULL, UNIQUE, 3–50 символов | логин (без учёта регистра) |
| email | CITEXT | NOT NULL, UNIQUE | почта для восстановления пароля |
| password_hash | TEXT | NOT NULL | хеш пароля (bcrypt), сам пароль не хранится |
| role | user_role | NOT NULL, по умолчанию `user` | `user` или `admin` |
| status | user_status | NOT NULL, по умолчанию `active` | `active` или `blocked` |
| rules_accepted_at | TIMESTAMPTZ | | когда приняты правила обязательной встречи |
| created_at | TIMESTAMPTZ | NOT NULL, now() | дата регистрации |
| updated_at | TIMESTAMPTZ | NOT NULL, now() | дата изменения |
