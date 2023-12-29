-- functions

-- -- 1. -- --
-- корректное заполнение названия товара (sku.rus_name) 
-- без пробелов и специальных символов по бокам, lowercase
CREATE OR REPLACE FUNCTION prepare_text(input_text text) RETURNS text AS $$
BEGIN
    RETURN trim(LOWER(regexp_replace(input_text, '[,.!?]+', '', 'g')));
END;
$$ LANGUAGE plpgsql;

-- -- 2. -- --
-- нормализация номера телефона (в атрибутах contact_info).
-- Пускай целевой формат номера --- это +7(495)123-45-67.
-- Хотим, чтобы каждый из следующих форматов:
-- 84951234567,
-- 74951234567,
-- 4951234567,
-- 8 495 123 45 67,
-- 7 985 123 45 67,
-- 495 123 45 67
-- и их вариации с нечисленными символами внутри приводились к целевому формату.
CREATE OR REPLACE FUNCTION normalize_russian_phone(phone_number varchar) RETURNS varchar AS $$
DECLARE
    normalized_phone varchar;
BEGIN
    -- убираем не цифры
    normalized_phone := regexp_replace(phone_number, '[^0-9]', '', 'g');

    -- если нужной длины, обработать +8...
    IF length(normalized_phone) = 16 THEN
        normalized_phone := '+7' || RIGHT(
            normalized_phone, 3
        );
    END IF;
    -- если длины на 1 меньше нужной, обработать 8...
    IF length(normalized_phone) = 16 THEN
        normalized_phone := '+7' || RIGHT(
            normalized_phone, 2
        );
    END IF;

    -- если без 7 или 8 в начале, добавить 7
    IF length(normalized_phone) = 10 THEN
        normalized_phone := '7' || normalized_phone;
    END IF;

    -- добавить скобки и дефисы
    normalized_phone := '+' || substring(
        normalized_phone from 1 for 1
    ) || '(' || substring(
        normalized_phone from 2 for 3
    ) || ')' || substring(
        normalized_phone from 5 for 3
    ) || '-' || substring(
        normalized_phone from 8 for 2
    ) || '-' || substring(
        normalized_phone from 10 for 2
    );

    RETURN normalized_phone;
END;
$$ LANGUAGE plpgsql;

-- -- 3. -- -- 
-- Превращение столбца названия товара into an unnested table that has
-- granuity `word`
CREATE FUNCTION split_text_to_array(input_text text, delimiter text)
RETURNS SETOF text AS $$
BEGIN
    RETURN QUERY SELECT unnest(string_to_array(input_text, delimiter));
END;
$$ LANGUAGE plpgsql;


