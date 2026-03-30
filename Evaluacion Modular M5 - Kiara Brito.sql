-- Creación de base de datos

CREATE DATABASE clinica_veterinaria;

-- Creación de tablas

CREATE TABLE duenios
(
	id_duenio INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	direccion VARCHAR(200),
	telefono VARCHAR(20) NOT NULL
);

CREATE TABLE mascotas
(
	id_mascota INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	id_duenio INT REFERENCES duenios(id_duenio) 
	ON DELETE CASCADE
	ON UPDATE CASCADE
	NOT NULL
);

CREATE TABLE profesionales
(
	id_profesional INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	especialidad VARCHAR(100) NOT NULL
);

CREATE TABLE Atenciones
(
	id_atencion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	fecha_atencion DATE NOT NULL,
	descripcion TEXT NOT NULL,
	id_mascota INT REFERENCES mascotas(id_mascota) NOT NULL,
	id_profesional INT REFERENCES profesionales(id_profesional) NOT NULL
);

-- Inserción de datos

INSERT INTO duenios 
(nombre, direccion, telefono)
VALUES
('Juan Pérez', 'Calle Falsa 123', '555-1234'),
('Ana Gómez', 'Avenida Siempre Viva 456', '555-5678'),
('Carlos Ruiz', 'Calle 8 de Octubre 789', '555-8765');

INSERT INTO mascotas
(nombre, tipo, fecha_nacimiento, id_duenio)
VALUES
('Rex', 'Perro', '2020-05-10', 1),
('Luna', 'Gato', '2019-02-20', 2),
('Fido', 'Perro', '2021-03-15', 3);

INSERT INTO profesionales
(nombre, especialidad)
VALUES
('Dr. Martínez', 'Veterinario'),
('Dr. Pérez', 'Dermatólogo'),
('Dr. López', 'Cardiólogo');

INSERT INTO atenciones
(fecha_atencion, descripcion, id_mascota, id_profesional)
VALUES
('2025-03-01', 'Chequeo general', 1, 1),
('2025-03-05', 'Tratamiento dermatológico', 2, 2),
('2025-03-07', 'Consulta cardiológica', 3, 3);

-- Consultas

-- Obtener todos los dueños y sus mascotas

SELECT 
duenios.nombre,
mascotas.nombre,
mascotas.tipo
FROM duenios
INNER JOIN mascotas ON duenios.id_duenio = mascotas.id_duenio;

-- Obtener las atenciones realizadas a las mascotas con los detalles del profesional que las atendió

SELECT 
mascotas.nombre,
atenciones.descripcion,
atenciones.fecha_atencion,
profesionales.nombre
FROM atenciones
INNER JOIN mascotas ON mascotas.id_mascota = atenciones.id_mascota
INNER JOIN profesionales ON atenciones.id_profesional = profesionales.id_profesional;

-- Contar la cantidad de atenciones por profesional

SELECT
profesionales.nombre,
profesionales.especialidad,
COUNT(atenciones.id_atencion) as cantidad_atenciones
FROM profesionales
INNER JOIN atenciones ON atenciones.id_profesional = profesionales.id_profesional
GROUP BY profesionales.nombre, profesionales.especialidad;

-- Actualizar la dirección de un dueño (por ejemplo, cambiar la dirección de Juan Pérez)

SELECT nombre FROM duenios WHERE nombre LIKE 'Juan%';

UPDATE duenios
SET direccion = 'Los Jardines 256'
WHERE nombre = 'Juan Pérez';

-- Eliminar una atención (por ejemplo, eliminar la atención con el id 2)

DELETE FROM atenciones
WHERE id_atencion = 2;

-- Realizar una transacción para agregar una nueva mascota, atención, y actualización de la información

BEGIN;

INSERT INTO mascotas
(fecha_nacimiento, nombre, tipo, id_duenio)
VALUES
('2025-01-30', 'Fanshop', 'Perro', 3);

INSERT INTO atenciones
(fecha_atencion, descripcion, id_mascota, id_profesional)
VALUES
('2026-03-31', 'Revisión general', 4, 1);

COMMIT;

-- (Repetir consulta de datos de mascotas y atenciones)