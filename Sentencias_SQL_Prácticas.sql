USE TP_BBDD1_2025_G07;

-- a) Mostrar la cuadrilla que más tareas realizó en el mes de Octubre de 2025, y la cantidad de tareas realizadas.
SELECT TOP 1 id_cuad, COUNT(id_cuad) as 'tareas realizadas'
FROM tarea
WHERE fecha_final BETWEEN '2026-10-1' AND '2026-10-31'
GROUP BY id_cuad
ORDER BY COUNT(id_cuad) DESC;

-- b) Mostrar los Motivos de Reclamos que tengan más de 3 reclamos en estado no asignado (sin tarea).
SELECT r.codigo_arbol, COUNT(r.codigo_arbol) as 'Apariciones'
FROM reclamo as r
WHERE r.id_tarea is NULL
GROUP BY r.codigo_arbol
HAVING COUNT(r.codigo_arbol) > 3;

-- c) Mostrar los Árboles (código, especie y ubicación) que no tengan ningún reclamo.
SELECT codigo_arbol, nombre_comun, nombre_cientifico, calle, altura, parque
FROM arbol a
INNER JOIN ubicacion u ON a.id_ubicacion = u.id_ubicacion
INNER JOIN especie e ON a.id_especie = e.id_especie
WHERE a.codigo_arbol NOT IN (SELECT codigo_arbol FROM reclamo);

-- d) Mostrar los tres árboles (código y altura) más altos de cada especie. Mostrar los resultados ordenados por especie y luego altura decreciente.
SELECT nombre_comun, ar.codigo_arbol, altura
FROM arbol ar
INNER JOIN altura alt ON ar.codigo_arbol = alt.codigo_arbol
INNER JOIN especie e ON ar.id_especie = e.id_especie
ORDER BY e.nombre_comun, alt.altura DESC;

go

SELECT * -- Si dias_para_resolver es NULL entonces no existe un id_tarea en reclamo.
FROM V_Informe_Reclamos -- Optamos por dejarlo NULL. La interpretación es igual a "dias_para_asignar". 
ORDER BY dias_para_asignar DESC;

-- Esta consulta devuelve solo las tareas que aún le quedan más de 100 días para 
--resolverse o tengan un código árbol dado 
SELECT * 
FROM V_Informe_Reclamos
WHERE codigo_arbol = 'ARB006' OR dias_para_resolver > 100;

--Esta consulta devolverá una fila por cada tipo de tarea que tenga 
--al menos una actividad finalizada.
SELECT * 
FROM V_Resumen_Tareas_Realizadas;

--Esta consulta devolverá las tareas realizadas de un tipo si hay más de una 
--y si ocurrió l afecha de la última tarea es mayor a una fecha dada
SELECT * FROM V_Resumen_Tareas_Realizadas
WHERE cantidad_tareas_realizadas > 1
AND fecha_ultima_realizada >= '2026-01-01';

go

-- Ejemplo A: Procedimiento proxima_tarea
-- Caso 1: Existe próxima tarea 
DECLARE @out_fecha_existente DATE; 
DECLARE @codigo_arbol varchar(30);
SET @codigo_arbol = 'fdadhyfbh';
DEclare @id_tipo_tarea INT;
= 1;
EXEC proxima_tarea 
	@codigo_arbol = 'fdadhyfbh',
	@id_tipo_tarea = 1,
	@fecha_proxima_tarea = @out_fecha_existente OUTPUT;
SELECT 'proxima_tarea' AS procedimiento,
	   'fdadhyfbh' AS codigo_arbol,
	   1 AS id_tipo_tarea,
	   @out_fecha_existente AS fecha_proxima_tarea; -- Esperado: 2026-06-20

-- Caso 2: No existe próxima tarea
DECLARE @out_fecha_inexistente DATE;
EXEC proxima_tarea 
	@codigo_arbol = 'ARB003',
	@id_tipo_tarea = 2,
	@fecha_proxima_tarea = @out_fecha_inexistente OUTPUT;
SELECT 'proxima_tarea' AS procedimiento,
	   'ARB003' AS codigo_arbol,
	   2 AS id_tipo_tarea,
	   @out_fecha_inexistente AS fecha_proxima_tarea; -- Esperado: NULL

GO

-- Ejemplo B: Procedimiento verificar_tareas_pendientes
-- Caso 1: Hay tareas pendientes 
DECLARE @ret_existente INT;
EXEC @ret_existente = verificar_tareas_pendientes 
	@codigo_arbol = 'ARB007',
	@id_tipo_tarea = 1;
SELECT 'verificar_tareas_pendientes' AS procedimiento,
	   'ARB007' AS codigo_arbol,
	   1 AS id_tipo_tarea,
	   @ret_existente AS cantidad_pendiente; -- Esperado: 1

-- Caso 2: No hay tareas pendientes
DECLARE @ret_inexistente INT;
EXEC @ret_inexistente = verificar_tareas_pendientes 
	@codigo_arbol = 'ARB003',
	@id_tipo_tarea = 2;
SELECT 'verificar_tareas_pendientes' AS procedimiento,
	   'ARB003' AS codigo_arbol,
	   2 AS id_tipo_tarea,
	   @ret_inexistente AS cantidad_pendiente; -- Esperado: 0

GO