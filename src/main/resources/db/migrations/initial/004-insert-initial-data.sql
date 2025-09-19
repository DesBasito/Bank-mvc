INSERT INTO roles (id, name, description)
VALUES (1, 'USER', 'Обычный пользователь'),
       (2, 'ADMIN', 'Администратор системы');

SELECT setval('roles_id_seq', 2, true);

-- Пароль у всех - qwe
INSERT INTO users (id,role_id, phone_number, password, first_name, middle_name, last_name, enabled)
VALUES (1, 2,'+7(900)1234567', '$2a$12$WB2YUbFcCN0tm44SBcKUjua9yiFBsfB3vW02IjuwzY7HGtlQIKzy2', 'Администратор', 'Главный', 'Системы', true),
       (2, 1,'+7(900)1234568', '$2a$12$WB2YUbFcCN0tm44SBcKUjua9yiFBsfB3vW02IjuwzY7HGtlQIKzy2', 'Иван', 'Иванович', 'Иванов', true),
       (3, 1,'+7(900)1234569', '$2a$12$WB2YUbFcCN0tm44SBcKUjua9yiFBsfB3vW02IjuwzY7HGtlQIKzy2', 'Петр', 'Петрович', 'Петров', true),
       (4, 1,'+7(900)1234570', '$2a$12$WB2YUbFcCN0tm44SBcKUjua9yiFBsfB3vW02IjuwzY7HGtlQIKzy2', 'Мария', 'Александровна', 'Сидорова', true),
       (5, 1,'+7(900)1234571', '$2a$12$WB2YUbFcCN0tm44SBcKUjua9yiFBsfB3vW02IjuwzY7HGtlQIKzy2', 'Анна', 'Сергеевна', 'Кузнецова', false),
       (6, 1,'+7(900)1234572', '$2a$12$WB2YUbFcCN0tm44SBcKUjua9yiFBsfB3vW02IjuwzY7HGtlQIKzy2', 'Дмитрий', 'Владимирович', 'Смирнов', true);

SELECT setval('users_id_seq', 6, true);

INSERT INTO cards (card_number, owner_id, expiry_date, type, status, balance)
VALUES ('4111111111111111', 2, DATE '2026-12-31','DEBIT', 'ACTIVE', 15000.50),
       ('4222222222222222', 2, DATE '2027-06-30','DEBIT', 'ACTIVE', 5000.00),
       ('4333333333333333', 3, DATE '2026-08-31','DEBIT', 'ACTIVE', 25000.75),
       ('4444444444444444', 4, DATE '2025-12-31','DEBIT', 'EXPIRED', 0.00),
       ('4555555555555555', 4, DATE '2027-03-31','DEBIT', 'ACTIVE', 12500.25),
       ('4666666666666666', 6, DATE '2026-11-30','DEBIT', 'BLOCKED', 3000.00);

INSERT INTO transactions (from_card_id, to_card_id, amount, description, status, processed_at)
VALUES (1, 3, 1000.00, 'Перевод другу', 'SUCCESS', NOW() - INTERVAL '2 days'),
       (3, 1, 500.00, 'Возврат долга', 'SUCCESS', NOW() - INTERVAL '1 day'),
       (1, 5, 750.50, 'Оплата за услуги', 'SUCCESS', NOW() - INTERVAL '3 hours'),
       (5, 1, 200.00, 'Перевод за покупки', 'SUCCESS', NULL),
       (3, 6, 1500.00, 'Перевод на заблокированную карту', 'CANCELLED', NOW() - INTERVAL '1 hour'),
       (1, 3, 100.00, 'Тестовый перевод', 'REFUNDED', NOW() - INTERVAL '6 hours');

INSERT INTO card_applications (user_id, status, type, processed_at)
VALUES (2, 'APPROVED','DEBIT', NOW() - INTERVAL '10 days'),
       (3, 'APPROVED','DEBIT', NOW() - INTERVAL '7 days'),
       (4, 'APPROVED','DEBIT', NOW() - INTERVAL '12 days'),
       (5, 'REJECTED','DEBIT', NOW() - INTERVAL '3 days'),
       (6, 'APPROVED','DEBIT', NOW() - INTERVAL '15 days'),
       (5, 'PENDING','DEBIT', NULL),
       (6, 'CANCELLED','DEBIT', NULL);