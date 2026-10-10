-- DB-001. Таблица пользователей SibFU Meetings

CREATE EXTENSION IF NOT EXISTS citext;

CREATE TYPE user_role   AS ENUM ('user', 'admin');
CREATE TYPE user_status AS ENUM ('active', 'blocked');

CREATE TABLE users (
    id                BIGSERIAL   PRIMARY KEY,
    login             CITEXT      NOT NULL UNIQUE,
    email             CITEXT      NOT NULL UNIQUE,
    password_hash     TEXT        NOT NULL,
    role              user_role   NOT NULL DEFAULT 'user',
    status            user_status NOT NULL DEFAULT 'active',
    rules_accepted_at TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT users_login_len CHECK (char_length(login) BETWEEN 3 AND 50)
);

COMMENT ON TABLE  users                   IS 'Учётные записи пользователей';
COMMENT ON COLUMN users.role              IS 'user — обычный пользователь, admin — администратор';
COMMENT ON COLUMN users.status            IS 'blocked — заблокирован администратором';
COMMENT ON COLUMN users.rules_accepted_at IS 'Когда пользователь принял правила обязательной встречи';
