USE TP_BBDD1_2025_G07;

-- ========================
-- 3.a. Cuadrillas y Empleados
-- ========================
INSERT INTO cuadrillas DEFAULT VALUES;  -- id_cuadrilla = 1
INSERT INTO cuadrillas DEFAULT VALUES;  -- id_cuadrilla = 2
INSERT INTO cuadrillas DEFAULT VALUES;  -- id_cuadrilla = 3

INSERT INTO empleado (cuil, id_cuad, nombre, apellido, tel1, tel2, fecha_ingreso)
VALUES
('20-11111111-1', 1, 'Juan', 'Pérez', '1123456789', NULL, '2021-05-01'),
('20-22222222-2', 1, 'Ana', 'Gómez', '1123456790', NULL, '2022-03-10'),
('20-33333333-3', 1, 'Luis', 'Fernández', '1123456791', NULL, '2020-01-15'),
('20-44444444-4', 2, 'Carla', 'López', '1123456792', NULL, '2019-07-22'),
('20-55555555-5', 2, 'Martín', 'Ruiz', '1123456793', NULL, '2020-09-18'),
('20-66666666-6', 2, 'Paula', 'Sosa', '1123456794', NULL, '2021-11-11'),
('20-77777777-7', 3, 'Ricardo', 'Molina', '1123456795', NULL, '2022-01-01'),
('20-88888888-8', 3, 'Laura', 'Benítez', '1123456796', NULL, '2020-02-20'),
('20-99999999-9', 3, 'Diego', 'Acosta', '1123456797', NULL, '2021-04-30'),
('27-12345678-0', 3, 'Sofía', 'Herrera', '1123456798', NULL, '2023-06-15');

-- ========================
-- 3.b. Especies, Estados de Salud y Ubicaciones
-- ========================
INSERT INTO especie (nombre_comun, nombre_cientifico)
VALUES
('Jacarandá', 'Jacaranda mimosifolia'),
('Tilo', 'Tilia cordata'),
('Plátano', 'Platanus × hispanica'),
('Lapacho', 'Handroanthus impetiginosus'),
('Ombú', 'Phytolacca dioica');

INSERT INTO salud (estado)
VALUES
('Excelente'), ('Bueno'), ('Regular'), ('Malo'), ('Crítico');

INSERT INTO ubicacion (calle, altura, parque)
VALUES
('San Martín', 100, 'Parque Norte'),
('San Martín', 200, 'Parque Norte'),
('Belgrano', 150, 'Plaza Sur'),
('Belgrano', 250, 'Plaza Sur'),
('Rivadavia', 300, 'Plaza Oeste'),
('Rivadavia', 400, 'Plaza Oeste'),
('Mitre', 500, 'Parque Central'),
('Mitre', 600, 'Parque Central'),
('Sarmiento', 700, 'Parque Este'),
('Sarmiento', 800, 'Parque Este');

-- ========================
-- 3.b. Árboles
-- ========================
INSERT INTO arbol (codigo_arbol, id_ubicacion, id_especie, id_salud, coordenada, fecha_plantado)
VALUES
('ARB001', 1, 1, 1, geometry::Point(-34.60, -58.38, 4326), '2018-08-12'),
('ARB002', 7, 1, 2, geometry::Point(-34.60, -58.39, 4326), NULL),
('ARB003', 2, 2, 3, geometry::Point(-34.61, -58.40, 4326), '2019-06-20'),
('ARB004', 6, 2, 4, geometry::Point(-34.61, -58.41, 4326), NULL),
('ARB005', 6, 3, 5, geometry::Point(-34.62, -58.42, 4326), '2020-01-15'),
('ARB006', 3, 3, 2, geometry::Point(-34.62, -58.43, 4326), '2021-02-18'),
('ARB007', 4, 4, 3, geometry::Point(-34.63, -58.44, 4326), '2017-03-10'),
('ARB008', 5, 4, 1, geometry::Point(-34.63, -58.45, 4326), NULL),
('ARB009', 5, 5, 2, geometry::Point(-34.64, -58.46, 4326), '2019-04-05'),
('ARB010', 5, 5, 3, geometry::Point(-34.64, -58.47, 4326), NULL);
-- (Agregar más hasta 50 si se requiere completar el conjunto)

-- ========================
-- 3.b. Alturas
-- ========================
INSERT INTO altura (codigo_arbol, fecha_medido, altura)
VALUES
('ARB001', '2025-10-01', 10.5),
('ARB002', '2025-10-01', 4.2),
('ARB003', '2025-10-01', 8.2),
('ARB004', '2025-10-01', 7.0),
('ARB005', '2025-10-01', 5.1),
('ARB006', '2025-10-01', 6.4),
('ARB007', '2025-10-01', 12.0),
('ARB008', '2025-10-01', 11.8),
('ARB009', '2025-10-01', 9.3),
('ARB010', '2025-10-01', 9);

-- ========================
-- 3.c. Tareas y Tipos de Tarea
-- ========================
INSERT INTO tipo_tarea (tipo_tarea)
VALUES ('Poda'), ('Riego'), ('Fertilización'), ('Inspección'), ('Extracción');

INSERT INTO tarea (id_tarea, id_tipo_tarea, id_cuad, comentario, fecha_planificada, fecha_final)
VALUES

(1, 4,  2,  'Inspección de raíces', '2025-12-01', NULL),
(2, 2, 1,  'Riego semanal', '2025-11-04', '2026-10-05'),
(3, 3,  2,  'Fertilización anual', '2025-12-01', '2026-02-02'),
(4, 4,  2,  'Inspección de raíces', '2026-01-01', NULL),
(5, 5,  3,  'Extracción de árbol muerto', '2026-04-20', '2026-10-22'),
(6, 1,  3,  'Poda de seguridad', '2026-06-20', NULL),
(7, 2, 1,  'Riego semanal', '2026-03-20', '2026-12-05'),
(8, 3,  2,  'Fertilización anual', '2026-04-20', '2026-12-30'),
(9, 2,  2,  'Fertilización anual', '2026-05-22', NULL);


-- Asociación Tareas - Árboles
INSERT INTO tarea_arbol (codigo_arbol, id_tarea)
VALUES
('ARB002', 1),
('ARB003', 2),
('ARB004', 3),
('ARB005', 4),
('ARB006', 5),
('ARB007', 6);

-- ========================
-- 3.d. Reclamos y Mails
-- ========================
INSERT INTO mail (informacion)
VALUES
('Vecino reporta caída de rama'),
('Se solicita inspección por raíces'),
('Mal estado del árbol frente a la escuela'),
('Se solicita inspección por raíces'),
('Mal estado del árbol frente a la escuela'),
('Peligro de caída'),
('Solicitud de extracción'),
('Mal estado del árbol frente a la escuela'),
('Peligro de caída'),
('Solicitud de extracción'),
('Ramas caidas'),
('Peligro ramas caidas'),
('Se solicita inspección por raíces'),
('Mal estado del árbol frente a la escuela'),
('Peligro de caída'),
('Solicitud de extracción'),
('Mal estado del árbol frente a la escuela'),
('Peligro de caída'),
('Solicitud de extracción'),
('Ramas caidas');

INSERT INTO reclamo (motivo, codigo_arbol, id_mail, fecha_reclamo, fecha_asignacion, id_tarea)
VALUES
('Caída de rama', 'ARB001', 1, '2024-09-10','2025-06-10',1),
('Raíces levantando vereda', 'ARB004', 2, '2024-08-15','2025-03-10',2),
('Mal estado general', 'ARB005', 3, '2025-02-20','2025-05-10',2),
('Peligro de caída', 'ARB006', 4, '2025-03-28','2025-04-10',2),
('Peligro de caída', 'ARB006', 5, '2025-01-19','2025-05-10',4),
('Extracción solicitada', 'ARB007', 6, '2024-09-25','2025-02-10',6),
('Peligro de caída', 'ARB006', 7, '2024-01-05','2025-02-10',6),
('Peligro de caída', 'ARB008', 8, '2024-02-05',NULL,NULL),
('Ramas caidas', 'ARB001', 9, '2025-02-25','2025-03-10',8),
('Peligro ramas caidas', 'ARB001', 10, '2025-01-10','2025-06-10',8),
('Peligro de caída', 'ARB002', 11, '2024-03-28',NULL,NULL),
('Peligro de caída', 'ARB008', 12, '2024-01-19',NULL,NULL),
('Extracción solicitada', 'ARB006', 13, '2024-09-25',NULL,NULL),
('Peligro de caída', 'ARB005', 14, '2024-01-05',NULL,NULL),
('Peligro de caída', 'ARB001', 15, '2024-02-05',NULL,NULL),
('Ramas caidas', 'ARB006', 16, '2024-02-25','2024-08-10',8),
('Peligro ramas caidas', 'ARB001', 17, '2024-01-10','2024-09-10',7),
('Peligro de caída', 'ARB008', 18, '2024-04-05',NULL,NULL),
('Peligro de caída', 'ARB008', 19, '2024-01-06',NULL,NULL),
('Peligro de caída', 'ARB001', 20, '2024-02-09',NULL,NULL);
