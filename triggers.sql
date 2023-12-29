-- -- таблица orders -- --
-- created_msk_dttm <= shipped_msk_dttm <= delivered_msk_dttm
CREATE FUNCTION public.created_shipped_delivered_validity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.created_msk_dttm > NEW.shipped_msk_dttm THEN
            RAISE EXCEPTION 'created_msk_dttm > shipped_msk_dttm is invalid';
        END IF;
        IF NEW.shipped_msk_dttm > NEW.delivered_msk_dttm THEN
            RAISE EXCEPTION 'shipped_msk_dttm > delivered_msk_dttm is invalid';
        END IF;
        RETURN NEW;
    END;
$$;

ALTER FUNCTION public.created_shipped_delivered_validity() 
OWNER TO ddpp;

CREATE TRIGGER created_shipped_delivered_validity_check 
BEFORE INSERT 
OR UPDATE 
ON public.orders 
FOR EACH ROW EXECUTE FUNCTION public.created_shipped_delivered_validity();


-- -- таблица promo -- --
-- если акция заводится с active_flag = False, то поля start_msk_dttm и end_msk_dttm
-- должны быть нулевые. Если же она заводится с active_flag = True, оба поля должны быть
-- заполнены. (При этом, изменить поле active_flag с True на False допустимо. 
-- Например, если акция приостановилась.)
CREATE FUNCTION public.promo_id_submission() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.active_flag = True and (
            NEW.start_msk_dttm is null 
            or NEW.end_msk_dttm is null
        )
            THEN
            RAISE EXCEPTION 'active promos must have non-null start_msk_dttm and end_msk_dttm';
        END IF;
        IF NEW.active_flag = False and (
            NEW.start_msk_dttm is not null 
            or NEW.end_msk_dttm is not null
        )
            THEN
            RAISE EXCEPTION 'initially inactive promos must have null start_msk_dttm and end_msk_dttm';
        END IF;
 RETURN NEW;
    END;
$$;

ALTER FUNCTION public.promo_id_submission() 
OWNER TO ddpp;

CREATE TRIGGER promo_id_submission_check 
BEFORE INSERT 
-- OR UPDATE 
ON public.promo
FOR EACH ROW EXECUTE FUNCTION public.promo_id_submission();


-- -- таблица sku -- --
-- Не хотим чтобы в атрибуты sku.rus_name, warehouses.name и regions.federal_name вписывали ерунду
CREATE FUNCTION public.rus_name_meaningful() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF prepare_text(NEW.rus_name) = ''
            THEN
            RAISE EXCEPTION 'sku.rus_name cannot be an empty string';
        END IF;
 RETURN NEW;
    END;
$$;

ALTER FUNCTION public.rus_name_meaningful() 
OWNER TO ddpp;

CREATE TRIGGER rus_name_meaningful_check 
BEFORE INSERT 
OR UPDATE 
ON public.sku 
FOR EACH ROW EXECUTE FUNCTION public.rus_name_meaningful();


-- -- таблица warehouses -- --
-- Не хотим чтобы в атрибуты sku.rus_name, warehouses.name и regions.federal_name вписывали ерунду
CREATE FUNCTION public.name_meaningful() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF prepare_text(NEW.name) = ''
            THEN
            RAISE EXCEPTION 'warehouse.name cannot be an empty string';
        END IF;
 RETURN NEW;
    END;
$$;

ALTER FUNCTION public.name_meaningful() 
OWNER TO ddpp;

CREATE TRIGGER name_meaningful_check 
BEFORE INSERT 
OR UPDATE 
ON public.warehouses 
FOR EACH ROW EXECUTE FUNCTION public.name_meaningful();


-- -- таблица regions -- --
-- Не хотим чтобы в атрибуты sku.rus_name, warehouses.name и regions.federal_name вписывали ерунду
CREATE FUNCTION public.federal_name_meaningful() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF prepare_text(NEW.federal_name) = ''
            THEN
            RAISE EXCEPTION 'regions.federal_name cannot be an empty string';
        END IF;
 RETURN NEW;
    END;
$$;

ALTER FUNCTION public.federal_name_meaningful() 
OWNER TO ddpp;

CREATE TRIGGER federal_name_meaningful_check 
BEFORE INSERT 
OR UPDATE 
ON public.regions 
FOR EACH ROW EXECUTE FUNCTION public.federal_name_meaningful();

