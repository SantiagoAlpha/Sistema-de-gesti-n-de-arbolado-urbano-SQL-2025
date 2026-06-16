-- 2) Sentencias SQL requeridas para la creación de la base de datos y la estructura completa de la misma (tablas, vistas, procedimientos, etc.)

CREATE DATABASE TP_BBDD1_2025_G07;

go 

USE TP_BBDD1_2025_G07;

CREATE TABLE especie(
	id_especie int PRIMARY KEY IDENTITY,
	nombre_comun varchar(70),
	nombre_cientifico varchar(120) NOT NULL
);

CREATE TABLE salud(
	id_salud int PRIMARY KEY IDENTITY,
	estado varchar(30) NOT NULL
);

CREATE TABLE ubicacion(
id_ubicacion int PRIMARY KEY IDENTITY,
calle varchar(30) NOT NULL,
altura int NOT NULL,
parque varchar(30)
);

CREATE TABLE arbol(
codigo_arbol varchar(100) PRIMARY KEY NOT NULL, 
id_ubicacion int NOT NULL,
id_especie int NOT NULL,
id_salud int NOT NULL,
coordenada GEOMETRY NOT NULL,
fecha_plantado date,
FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion),
FOREIGN KEY (id_especie) REFERENCES especie(id_especie),
FOREIGN KEY (id_salud) REFERENCES salud(id_salud)
);

CREATE TABLE altura(
	codigo_arbol varchar(100) NOT NULL,
	fecha_medido date NOT NULL,
	PRIMARY KEY (codigo_arbol, fecha_medido),
	FOREIGN KEY (codigo_arbol) REFERENCES arbol(codigo_arbol),
	altura float(2) NOT NULL
);

CREATE TABLE cuadrillas(
	id_cuadrilla int PRIMARY KEY IDENTITY
);

CREATE TABLE empleado(
	cuil varchar(18) PRIMARY KEY NOT NULL,
	id_cuad int,
	nombre varchar(25) NOT NULL,
	apellido varchar(30) NOT NULL,
	tel1 varchar(18) NOT NULL,
	tel2 varchar(18),
	fecha_ingreso date NOT NULL,
	FOREIGN KEY (id_cuad) REFERENCES cuadrillas(id_cuadrilla)
);

CREATE TABLE mail(
	id_mail int PRIMARY KEY IDENTITY,
	informacion varchar(300) NOT NULL 
);

CREATE TABLE tipo_tarea(
	id_tipo_tarea int PRIMARY KEY IDENTITY,
	tipo_tarea varchar(20) NOT NULL
);

CREATE TABLE tarea(
	id_tarea int PRIMARY KEY,
	id_tipo_tarea int NOT NULL,
	id_cuad int NOT NULL,
	comentario varchar(200),
	fecha_planificada date NOT NULL,
	fecha_final date,
	FOREIGN KEY (id_tipo_tarea) REFERENCES tipo_tarea(id_tipo_tarea),
	FOREIGN KEY (id_cuad) REFERENCES cuadrillas(id_cuadrilla)
);

CREATE TABLE reclamo(
	id_reclamo int PRIMARY KEY IDENTITY,
	motivo varchar(400) NOT NULL,
	codigo_arbol varchar(100) NOT NULL, 
	id_mail int NOT NULL,
	fecha_reclamo date NOT NULL,
	fecha_asignacion date,
	id_tarea int,
	FOREIGN KEY (codigo_arbol) REFERENCES arbol(codigo_arbol),
	FOREIGN KEY (id_mail) REFERENCES mail(id_mail),
	FOREIGN KEY (id_tarea) REFERENCES tarea(id_tarea)
);

CREATE TABLE tarea_arbol(
codigo_arbol varchar(100) NOT NULL,
id_tarea int NOT NULL,
PRIMARY KEY (codigo_arbol, id_tarea),
FOREIGN KEY (codigo_arbol) REFERENCES arbol(codigo_arbol),
FOREIGN KEY (id_tarea) REFERENCES tarea(id_tarea)
);

go 



CREATE VIEW V_Informe_Reclamos 
AS
SELECT   r.id_reclamo, r.fecha_reclamo,   r.codigo_arbol,
    
    -- 1. Días que se tardó en asignar
    -- Si Fecha Asignación es NULL, usa la Fecha Actual (GETDATE)
    DATEDIFF(day, r.fecha_reclamo, ISNULL(r.fecha_asignacion, GETDATE())) AS dias_para_asignar,

    -- 2. Días que se tardó en resolver
    -- Si la Tarea no finalizó, usa la Fecha Actual.
    -- CASE: Solo calculamos esto si el reclamo ya fue asignado. Si no está asignado, devuelve NULL.
    CASE 
        WHEN r.fecha_asignacion IS NOT NULL 
        THEN 
            DATEDIFF(day, r.fecha_asignacion, ISNULL(t.fecha_final, GETDATE()))
        ELSE 
            NULL 
    END 
AS dias_para_resolver

FROM TP_BBDD1_2025_G07.dbo.reclamo r
LEFT JOIN TP_BBDD1_2025_G07.dbo.tarea t ON r.id_tarea = t.id_tarea;



GO

CREATE VIEW V_Resumen_Tareas_Realizadas AS
SELECT 
    tt.tipo_tarea,
    
    -- Fecha de la primera tarea realizada
    MIN(t.fecha_final) AS fecha_primera_realizada,
    
    -- Fecha de la última tarea realizada
    MAX(t.fecha_final) AS fecha_ultima_realizada,
    
    -- Cantidad total
    COUNT(t.id_tarea) AS cantidad_tareas_realizadas

FROM TP_BBDD1_2025_G07.dbo.tipo_tarea tt
INNER JOIN TP_BBDD1_2025_G07.dbo.tarea t 
    ON tt.id_tipo_tarea = t.id_tipo_tarea
WHERE t.fecha_final IS NOT NULL
GROUP BY tt.tipo_tarea;

GO

CREATE PROCEDURE proxima_tarea -- Crea el procedimiento con el nombre
@codigo_arbol VARCHAR(100),           -- Le paso como dato el cod de un arbol a consultar
@id_tipo_tarea INT,                   -- Le paso la ID del tipo de tarea a buscar
@fecha_proxima_tarea DATE OUTPUT      -- La función devuelve la fecha de la próxima tarea
AS
BEGIN -- Inicio del procedimiento
 
-- Obtener la fecha de la próxima tarea (más cercana) no realizada
SELECT TOP 1 @fecha_proxima_tarea = t.fecha_planificada -- Nos devuelve la fecha de la proxima tarea a realizar (1 solamente)
FROM tarea t -- Selecciona la tabla tarea
INNER JOIN tarea_arbol ta ON t.id_tarea = ta.id_tarea -- Une la tabla tarea_arbol con tarea comparando las id's de las tareas
WHERE ta.codigo_arbol = @codigo_arbol AND t.id_tipo_tarea = @id_tipo_tarea AND t.fecha_final IS NULL
-- Se tiene que cumplir que el codigo de arbol de tarea_arbol con el codigo pasado como parametro sean iguales, que el tipo de 
-- arbol de la tabla tarea coincida con el tipo pasado como parametro y que la fecha final sea null (es decir que no se haya terminado la tarea)
ORDER BY t.fecha_planificada ASC;        -- Ordena por fecha más cercana
END; -- Cierra el CREATE PROCEDURE (finaliza el procedimiento)

GO

-- B) Debe retornar (como valor de retorno) la cantidad de tareas pendientes de realizar para el tipo 
-- de tarea y árbol proporcionados.

CREATE PROCEDURE verificar_tareas_pendientes -- Crea el procedimiento con el nombre
@codigo_arbol VARCHAR(100),           -- Le paso como dato el cod de un arbol a consultar
@id_tipo_tarea INT                    -- Le paso la ID del tipo de tarea a buscar
AS
BEGIN -- Inicio del procedimiento

DECLARE @cantidad_pendientes INT;     -- Contardor de las tareas pendientes

-- Contar la cantidad total de tareas pendientes
SELECT @cantidad_pendientes = COUNT(*)
FROM tarea t
INNER JOIN tarea_arbol ta ON t.id_tarea = ta.id_tarea
WHERE ta.codigo_arbol = @codigo_arbol
AND t.id_tipo_tarea = @id_tipo_tarea
AND t.fecha_final IS NULL;             -- Tarea no realizada

-- Retornar la cantidad de tareas pendientes como valor de retorno
RETURN @cantidad_pendientes;
END;

GO