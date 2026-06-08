# Práctica SQL – Gestión de Alojamientos Turísticos

Práctica de 20 consultas SQL sobre la base de datos `accommodations_tourism`.

## Motor de base de datos

**PostgreSQL 18.4**

## Archivo de consultas

| Archivo | Descripción |
|---|---|
| `consultas_alojamientos.sql` | 20 consultas guiadas (INSERT, SELECT, UPDATE, DELETE, JOIN, AGG, HAVING, Subconsulta) |

## Esquema de la base de datos

```
accommodations_tourism
│
├── owners               — Propietarios de los alojamientos
├── locations            — Ubicaciones geográficas (país, ciudad, dirección)
├── accommodation_types  — Tipos de alojamiento (Hotel, Hostel, Villa, etc.)
├── accommodations       — Alojamientos (vinculados a owner, location y type)
├── rooms                — Habitaciones dentro de un alojamiento
├── amenities            — Servicios disponibles (WiFi, piscina, etc.)
├── accommodation_amenities — Relación alojamiento ↔ amenidad (N:M)
│
├── guests               — Huéspedes registrados
├── bookings             — Reservas (vincula guest ↔ accommodation)
├── booking_guests       — Huéspedes adicionales por reserva
├── booking_statuses     — Estados posibles de reserva (Pending, Confirmed, etc.)
│
├── payments             — Pagos asociados a reservas
├── reviews              — Reseñas y calificaciones por reserva
│
└── staff_users          — Usuarios del sistema (recepcionistas, managers, etc.)
```

