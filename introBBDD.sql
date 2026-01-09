-- Proyecto 4: SQL
-- Archivo: IntroBBDD.sql 
-- BBDD: [https://postgrespro.com/docs/postgrespro/current/demodb-bookings-installation.html]

SET search_path TO bookings, public;

-- 1) Vuelos con estado 'On Time'
SELECT flight_id, flight_no
FROM flights
WHERE status = 'On Time';

-- 2) Reservas con importe total superior a 1.000.000
SELECT *
FROM bookings
WHERE total_amount > 1000000;

-- 3) Modelos de aviones disponibles
SELECT *
FROM aircrafts_data;

-- 4) Vuelos operados con Boeing 737 (código '733')
SELECT flight_id
FROM flights
WHERE aircraft_code = '733';

-- 5) Tickets comprados por personas llamadas Irina
SELECT *
FROM tickets
WHERE passenger_name ILIKE 'Irina%';

-- 6) Ciudades con más de un aeropuerto
SELECT city ->> 'en' AS city, COUNT(*) AS airports_count
FROM airports_data
GROUP BY city ->> 'en'
HAVING COUNT(*) > 1
ORDER BY airports_count DESC, city;

-- 7) Número de vuelos por modelo de avión
SELECT a.aircraft_code, a.model ->> 'en' AS model, COUNT(*) AS flights_count
FROM flights f
JOIN aircrafts_data a ON a.aircraft_code = f.aircraft_code
GROUP BY a.aircraft_code, a.model ->> 'en'
ORDER BY flights_count DESC, a.aircraft_code;

-- 8) Reservas con más de un billete
SELECT b.book_ref, COUNT(t.ticket_no) AS tickets_count
FROM bookings b
JOIN tickets t ON t.book_ref = b.book_ref
GROUP BY b.book_ref
HAVING COUNT(t.ticket_no) > 1
ORDER BY tickets_count DESC, b.book_ref;

-- 9) Vuelos con retraso de salida superior a 1 hora
SELECT flight_id, flight_no, scheduled_departure, actual_departure,
       (actual_departure - scheduled_departure) AS delay
FROM flights
WHERE actual_departure IS NOT NULL
  AND actual_departure - scheduled_departure > INTERVAL '1 hour'
ORDER BY delay DESC;
