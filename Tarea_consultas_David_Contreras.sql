
-- CONSULTA 01 | INSERT – Insertar propietario
-- Descripción: Agrega un nuevo propietario.

INSERT INTO owners (
    first_name, last_name, company_name, email, phone,
    city, state, country
)
VALUES (
    'Carlos', 'Mendoza', 'Turi-Stay S.A.',
    'carlos.mendoza@turistay.com', '+503-7000-1234',
    'San Salvador', 'San Salvador', 'El Salvador'
);



-- Verificación
SELECT owner_id, first_name, last_name, company_name, email, country
FROM owners
ORDER BY owner_id DESC
LIMIT 1;



-- CONSULTA 02 | INSERT – Insertar alojamiento
-- Descripción: Crea un nuevo alojamiento vinculado.

INSERT INTO accommodations (
    owner_id, accommodation_type_id, location_id, name, description,
    max_guests, bedroom_count, bathroom_count,
    base_price_per_night, currency_code, check_in_time, check_out_time, is_active
)
VALUES (
    21, 1, 1,
    'Hotel Pacífico Vista',
    'Hermoso hotel frente al mar con vistas panorámicas y servicio de primera.',
    6, 3, 2,
    150.00, 'USD', '15:00:00', '11:00:00', TRUE
);

-- Verificación
SELECT accommodation_id, name, owner_id, base_price_per_night, is_active
FROM accommodations
ORDER BY accommodation_id DESC
LIMIT 1;



-- CONSULTA 03 | INSERT – Huésped y reserva
-- Descripción: Registra un nuevo huésped en la tabla .

-- Paso A: Insertar el huésped
INSERT INTO guests (
    first_name, last_name, email, phone,
    nationality, date_of_birth
)
VALUES (
    'María', 'González', 'maria.gonzalez@email.com',
    '+503-6000-5678', 'El Salvador', '1990-05-15'
);

-- Paso B: Insertar la reserva
INSERT INTO bookings (
    guest_id, accommodation_id, booking_status_id,
    check_in_date, check_out_date, adult_count, child_count,
    subtotal_amount, tax_amount, discount_amount, total_amount,
    booking_reference
)
VALUES (
    101, 21, 1,
    '2026-07-10', '2026-07-15', 2, 1,
    750.00, 112.50, 0.00, 862.50,
    'BK-2026-0001'
);

-- Verificación: huésped + reserva
SELECT g.first_name, g.last_name, b.booking_reference,
       b.check_in_date, b.check_out_date, b.total_amount
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
WHERE g.email = 'maria.gonzalez@email.com';



-- CONSULTA 04 | INSERT – Insertar pago
-- Descripción: Registra un pago para la reserva
INSERT INTO payments (
    booking_id, amount, payment_method,
    payment_status, transaction_reference, notes
)
VALUES (
    101, 862.50, 'CreditCard',
    'Completed', 'TXN-2026-001-MC',
    'Pago completo al momento de la reserva'
);

-- Verificación
SELECT payment_id, booking_id, amount, payment_method, payment_status
FROM payments
ORDER BY payment_id DESC
LIMIT 1;



-- CONSULTA 05 | SELECT – Alojamientos activos
-- Descripción: Filtra todos los alojamientos cuyo campo is_active es TRUE
SELECT
    accommodation_id,
    name,
    base_price_per_night,
    currency_code,
    max_guests,
    is_active
FROM accommodations
WHERE is_active = TRUE
ORDER BY base_price_per_night DESC;



-- CONSULTA 06 | SELECT – Huéspedes por país
-- Descripción: Filtra los huéspedes cuya nacionalidad es Uruguay

SELECT
    guest_id,
    first_name,
    last_name,
    email,
    phone,
    nationality
FROM guests
WHERE nationality = 'Uruguay'
ORDER BY last_name;



-- CONSULTA 07 | SELECT – Reservas por fechas (BETWEEN)
-- Descripción: Obtiene todas las reservas cuyo check-in se encuentra dentro
-- de un rango de fechas específico usando el operador BETWEEN.

SELECT
    booking_id,
    booking_reference,
    guest_id,
    accommodation_id,
    check_in_date,
    check_out_date,
    total_nights,
    total_amount
FROM bookings
WHERE check_in_date BETWEEN '2025-06-01' AND '2025-12-31'
ORDER BY check_in_date;



-- CONSULTA 08 | UPDATE – Actualizar precio
-- Descripción: Modifica el precio base por noche del alojamiento con
-- accommodation_id = 5, incrementándolo en un 10%.

-- Ver precio antes
SELECT accommodation_id, name, base_price_per_night FROM accommodations WHERE accommodation_id = 5;

-- Actualizar precio
UPDATE accommodations
SET base_price_per_night = ROUND(base_price_per_night * 1.10, 2)
WHERE accommodation_id = 5;

-- Ver precio después
SELECT accommodation_id, name, base_price_per_night FROM accommodations WHERE accommodation_id = 5;


-- CONSULTA 09 | UPDATE – Estado de reserva
-- Descripción: Actualiza el estado de la reserva con booking_id = 10,
-- cambiándolo a "Confirmed" (booking_status_id = 2).
-- Ver estado antes
SELECT booking_id, booking_status_id FROM bookings WHERE booking_id = 10;

-- Actualizar estado
UPDATE bookings
SET booking_status_id = 2
WHERE booking_id = 10;

-- Ver estado después
SELECT b.booking_id, bs.status_name
FROM bookings b
JOIN booking_statuses bs ON b.booking_status_id = bs.booking_status_id
WHERE b.booking_id = 10;



-- CONSULTA 10 | DELETE – Eliminar reseña
-- Descripción: Elimina la reseña con review_id = 1 de la tabla reviews
-- utilizando DELETE con cláusula WHERE para evitar borrados masivos.

-- Ver reseña antes
SELECT review_id, guest_id, accommodation_id, rating FROM reviews WHERE review_id = 1;

-- Eliminar reseña
DELETE FROM reviews
WHERE review_id = 1;

-- Verificar eliminación
SELECT COUNT(*) AS total_resenas FROM reviews;



-- CONSULTA 11 | JOIN – Reservas + Huésped (INNER JOIN)
-- Descripción: Combina las tablas bookings y guests para mostrar los datos
-- del huésped junto con su información de reserva.

SELECT
    b.booking_id,
    b.booking_reference,
    g.first_name || ' ' || g.last_name AS huesped,
    g.email,
    g.nationality,
    b.check_in_date,
    b.check_out_date,
    b.total_amount
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id
ORDER BY b.check_in_date DESC
LIMIT 15;


-- CONSULTA 12 | JOIN – Alojamiento completo (INNER JOIN múltiple)
-- Descripción: Une las tablas accommodations, owners, locations y
-- accommodation_types para obtener una vista completa de cada alojamiento.

SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    at2.type_name AS tipo,
    o.first_name || ' ' || o.last_name AS propietario,
    l.city || ', ' || l.country AS ubicacion,
    a.base_price_per_night,
    a.currency_code,
    a.max_guests
FROM accommodations a
INNER JOIN owners o ON a.owner_id = o.owner_id
INNER JOIN locations l ON a.location_id = l.location_id
INNER JOIN accommodation_types at2 ON a.accommodation_type_id = at2.accommodation_type_id
ORDER BY a.accommodation_id;


-- CONSULTA 13 | JOIN – Pagos + Reservas (JOIN combinado)
-- Descripción: Combina payments con bookings y guests para ver qué huésped
-- realizó cada pago, monto y método de pago utilizado.

SELECT
    p.payment_id,
    b.booking_reference,
    g.first_name || ' ' || g.last_name AS huesped,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.payment_date
FROM payments p
INNER JOIN bookings b ON p.booking_id = b.booking_id
INNER JOIN guests g ON b.guest_id = g.guest_id
ORDER BY p.payment_date DESC
LIMIT 15;


-- CONSULTA 14 | LEFT JOIN – Alojamientos sin reseñas
-- Descripción: Muestra todos los alojamientos, incluyendo aquellos que NO
-- tienen reseñas registradas. Los que no tienen reseña aparecen con NULL.

SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    r.review_id,
    r.rating,
    r.review_title
FROM accommodations a
LEFT JOIN reviews r ON a.accommodation_id = r.accommodation_id
ORDER BY a.accommodation_id, r.review_id;



-- CONSULTA 15 | LEFT JOIN – Huéspedes sin reservas (filtrar NULL)
-- Descripción: Usa LEFT JOIN entre guests y bookings para encontrar
-- huéspedes que nunca han hecho una reserva (booking_id IS NULL).

SELECT
    g.guest_id,
    g.first_name || ' ' || g.last_name AS huesped,
    g.email,
    g.nationality,
    b.booking_id
FROM guests g
LEFT JOIN bookings b ON g.guest_id = b.guest_id
WHERE b.booking_id IS NULL
ORDER BY g.guest_id;



-- CONSULTA 16 | AGG – Total de ingresos (SUM)
-- Descripción: Calcula el total de ingresos recibidos agrupando los pagos
-- completados por método de pago usando la función SUM.

SELECT
    payment_method,
    COUNT(*) AS cantidad_pagos,
    SUM(amount) AS total_ingresos,
    ROUND(AVG(amount), 2) AS promedio_pago
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_ingresos DESC;



-- CONSULTA 17 | AGG – Promedio de rating (AVG)
-- Descripción: Calcula el promedio de calificaciones (rating) por alojamiento,
-- usando la función AVG junto con el nombre del alojamiento.

SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(r.review_id) AS total_resenas,
    ROUND(AVG(r.rating), 2) AS promedio_rating,
    MIN(r.rating) AS min_rating,
    MAX(r.rating) AS max_rating
FROM accommodations a
INNER JOIN reviews r ON a.accommodation_id = r.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY promedio_rating DESC;



-- CONSULTA 18 | AGG – Top alojamientos más reservados (COUNT + LIMIT)
-- Descripción: Cuenta cuántas reservas tiene cada alojamiento y muestra
-- los 5 más populares usando COUNT, GROUP BY y LIMIT.

SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas,
    SUM(b.total_amount) AS ingresos_totales
FROM accommodations a
INNER JOIN bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY total_reservas DESC
LIMIT 5;


-- CONSULTA 19 | HAVING – Alojamientos con más de 3 reservas (GROUP BY + HAVING)
-- Descripción: Agrupa las reservas por alojamiento y filtra solo aquellos
-- que tienen más de 3 reservas usando la cláusula HAVING.

SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas
FROM accommodations a
INNER JOIN bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_reservas DESC;



-- CONSULTA 20 | Subconsulta – Alojamiento más caro
-- Descripción: Usa una subconsulta (subquery) en el WHERE para encontrar
-- el o los alojamientos cuyo precio base es el más alto de toda la tabla.

SELECT
    accommodation_id,
    name AS alojamiento,
    base_price_per_night,
    currency_code,
    max_guests
FROM accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night)
    FROM accommodations
    WHERE is_active = TRUE
);

-- ESTUDIANTE: DAVID MOISES CONTRERAS AGUILAR
