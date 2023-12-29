-- -- created_shipped_delivered_validity_check -- -- 
INSERT INTO public.orders VALUES
    (111, 1, 1, 1, 1, 1, 'shipped', '2023-12-30 16:34:25+03', '2023-12-29 16:01:23+03', NULL, 1, 1, 2, 251.44);


-- -- promo_id_submission_check -- -- 
INSERT INTO public.promo VALUES
    (11, null, 100, 1, 3, '2023-12-27 04:08:26+03', '2024-01-01 00:00:12+03', False);


-- -- rus_name_meaningful_check -- -- 
INSERT INTO public.sku VALUES
    (1111, '   .,?    ', ARRAY[1, 2], 'Аптека', 'Санитария', 'Жидкости');


-- -- name_meaningful_check -- -- 
INSERT INTO public.warehouses VALUES
    (5, '  , ,   . .. .  ???? ???? ?', 1);

-- -- federal_name_meaningful_check -- -- 
INSERT INTO public.regions VALUES
    (1, ' , , , , .. . . .. . . ., , , , ,, , , , ,, , , . . .. . . .. . . .');





