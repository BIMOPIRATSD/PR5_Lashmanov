-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres;

-- DROP SEQUENCE public.film_film_id_seq;

CREATE SEQUENCE public.film_film_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.hall_hall_id_seq;

CREATE SEQUENCE public.hall_hall_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.hall_row_hall_row_id_seq;

CREATE SEQUENCE public.hall_row_hall_row_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.screening_screening_id_seq;

CREATE SEQUENCE public.screening_screening_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.film definition

-- Drop table

-- DROP TABLE public.film;

CREATE TABLE public.film (
	film_id serial4 NOT NULL,
	names varchar(255) NULL,
	description text NULL,
	CONSTRAINT film_pkey PRIMARY KEY (film_id)
);


-- public.hall definition

-- Drop table

-- DROP TABLE public.hall;

CREATE TABLE public.hall (
	hall_id serial4 NOT NULL,
	names varchar(100) NULL,
	CONSTRAINT hall_pkey PRIMARY KEY (hall_id)
);


-- public.hall_row definition

-- Drop table

-- DROP TABLE public.hall_row;

CREATE TABLE public.hall_row (
	hall_row_id serial4 NOT NULL,
	id_hall int4 NULL,
	numbers int4 NULL,
	capasity int4 NULL,
	CONSTRAINT hall_row_pkey PRIMARY KEY (hall_row_id),
	CONSTRAINT hall_row_id_hall_fkey FOREIGN KEY (id_hall) REFERENCES public.hall(hall_id)
);


-- public.screening definition

-- Drop table

-- DROP TABLE public.screening;

CREATE TABLE public.screening (
	screening_id serial4 NOT NULL,
	id_hall int4 NULL,
	id_film int4 NULL,
	datu date NULL,
	times time NULL,
	CONSTRAINT screening_pkey PRIMARY KEY (screening_id),
	CONSTRAINT screening_id_film_fkey FOREIGN KEY (id_film) REFERENCES public.film(film_id),
	CONSTRAINT screening_id_hall_fkey FOREIGN KEY (id_hall) REFERENCES public.hall(hall_id)
);


-- public.tickets definition

-- Drop table

-- DROP TABLE public.tickets;

CREATE TABLE public.tickets (
	id_screening int4 NOT NULL,
	rowe int4 NOT NULL,
	seat int4 NOT NULL,
	costs int4 NULL,
	CONSTRAINT tickets_pkey PRIMARY KEY (id_screening, rowe, seat),
	CONSTRAINT tickets_id_screening_fkey FOREIGN KEY (id_screening) REFERENCES public.screening(screening_id)
);


-- public.films_showing_11am source

CREATE MATERIALIZED VIEW public.films_showing_11am
TABLESPACE pg_default
AS SELECT f.names AS film_name
   FROM screening s
     JOIN film f ON s.id_film = f.film_id
  WHERE s.datu = '2024-01-01'::date AND s.times > '11:00:00'::time without time zone
WITH DATA;


-- public.hall_three_row_two source

CREATE OR REPLACE VIEW public.hall_three_row_two
AS SELECT hall.names AS "Номер зала",
    hall_row.numbers AS "Номер ряда",
    hall_row.capasity AS "Количество мест"
   FROM hall_row
     JOIN hall ON hall.hall_id = hall_row.id_hall
  WHERE hall.names::text = 'Hall A'::text AND hall_row.numbers = 1;


-- public.schedule_for_film source

CREATE OR REPLACE VIEW public.schedule_for_film
AS SELECT f.names AS film_name,
    s.datu AS show_date,
    s.times AS show_time,
    h.names AS hall_name
   FROM screening s
     JOIN film f ON s.id_film = f.film_id
     JOIN hall h ON s.id_hall = h.hall_id
  WHERE s.id_film = 1;


-- public.schedule_for_hall source

CREATE OR REPLACE VIEW public.schedule_for_hall
AS SELECT f.names AS film_name,
    s.datu AS show_date,
    s.times AS show_time,
    h.names AS hall_name
   FROM screening s
     JOIN film f ON s.id_film = f.film_id
     JOIN hall h ON s.id_hall = h.hall_id
  WHERE s.id_hall = 1;
