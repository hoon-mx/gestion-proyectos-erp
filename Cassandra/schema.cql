-- Modelo de Cassandra: 7 tablas para los requerimientos 1 a 8 (la tabla 4 sirve a los requerimientos 4 y 5).
-- Identificadores legibles: la tarea por su folio, el proyecto por su nombre y el empleado por su correo.
-- Lo ejecuta populate.py con session.execute(); aquí queda documentado.

CREATE KEYSPACE IF NOT EXISTS gestion_proyectos
WITH replication = { 'class': 'SimpleStrategy', 'replication_factor': 1 };

USE gestion_proyectos;

-- Tabla 1: requerimiento 1
CREATE TABLE IF NOT EXISTS cambios_by_tarea (
    folio TEXT,
    fecha_cambio TIMESTAMP,
    cambio_id TIMEUUID,
    campo_modificado TEXT,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    empleado TEXT,
    PRIMARY KEY (folio, fecha_cambio, cambio_id)
) WITH CLUSTERING ORDER BY (fecha_cambio DESC, cambio_id ASC);

-- Tabla 2: requerimiento 2
-- No visto en clase: BOOLEAN guarda verdadero o falso; aquí, si la hora se le cobra al cliente.
CREATE TABLE IF NOT EXISTS horas_by_empleado (
    correo_empleado TEXT,
    fecha DATE,
    registro_id TIMEUUID,
    proyecto TEXT,
    tarea TEXT,
    horas FLOAT,
    descripcion TEXT,
    facturable BOOLEAN,
    PRIMARY KEY (correo_empleado, fecha, registro_id)
) WITH CLUSTERING ORDER BY (fecha DESC, registro_id ASC);

-- Tabla 3: requerimiento 3
-- No visto en clase: BOOLEAN (ver tabla 2).
CREATE TABLE IF NOT EXISTS horas_by_proyecto_mes (
    nombre_proyecto TEXT,
    mes TEXT,
    fecha DATE,
    registro_id TIMEUUID,
    empleado TEXT,
    tarea TEXT,
    horas FLOAT,
    facturable BOOLEAN,
    tarifa_hora FLOAT,
    PRIMARY KEY ((nombre_proyecto, mes), fecha, registro_id)
) WITH CLUSTERING ORDER BY (fecha ASC, registro_id ASC);

-- Tabla 4: requerimientos 4 y 5
-- Las dos consultas leen la misma partición, el proyecto. La 5 solo agrega la fecha, que ya es
-- clustering key, así que una tabla sirve a las dos sin ALLOW FILTERING.
CREATE TABLE IF NOT EXISTS actividad_by_proyecto (
    nombre_proyecto TEXT,
    fecha DATE,
    hora TIMESTAMP,
    folio TEXT,
    tipo_evento TEXT,
    tarea TEXT,
    empleado TEXT,
    etapa_anterior TEXT,
    etapa_nueva TEXT,
    detalle TEXT,
    PRIMARY KEY (nombre_proyecto, fecha, hora, folio)
) WITH CLUSTERING ORDER BY (fecha DESC, hora DESC, folio ASC);

-- R4: los últimos 30 eventos del proyecto, del más reciente al más antiguo.
-- No visto en clase: LIMIT corta el resultado a las primeras 30 filas de la partición.
-- SELECT fecha, hora, tipo_evento, tarea, empleado, detalle FROM actividad_by_proyecto
-- WHERE nombre_proyecto = 'Implementación ERP Ferretero Jalisco' LIMIT 30;

-- R5: toda la actividad del proyecto en un día, ordenada por hora.
-- SELECT hora, folio, tipo_evento, tarea, etapa_anterior, etapa_nueva, empleado FROM actividad_by_proyecto
-- WHERE nombre_proyecto = 'Implementación ERP Ferretero Jalisco' AND fecha = '2026-11-12'
-- ORDER BY fecha ASC, hora ASC;

-- Tabla 5: requerimiento 6
CREATE TABLE IF NOT EXISTS tareas_cerradas_by_empleado_mes (
    correo_empleado TEXT,
    mes TEXT,
    fecha_cierre TIMESTAMP,
    folio TEXT,
    tarea TEXT,
    proyecto TEXT,
    horas_estimadas FLOAT,
    horas_reales FLOAT,
    PRIMARY KEY ((correo_empleado, mes), fecha_cierre, folio)
) WITH CLUSTERING ORDER BY (fecha_cierre DESC, folio ASC);

-- Tabla 6: requerimiento 7
CREATE TABLE IF NOT EXISTS reportes_by_proyecto (
    nombre_proyecto TEXT,
    fecha_reporte DATE,
    estado TEXT,
    porcentaje_avance INT,
    comentario TEXT,
    autor TEXT,
    PRIMARY KEY (nombre_proyecto, fecha_reporte)
) WITH CLUSTERING ORDER BY (fecha_reporte DESC);

-- Tabla 7: requerimiento 8
CREATE TABLE IF NOT EXISTS hitos_by_proyecto (
    nombre_proyecto TEXT,
    fecha_alcanzado DATE,
    hito TEXT,
    fecha_planeada DATE,
    monto_a_facturar FLOAT,
    PRIMARY KEY (nombre_proyecto, fecha_alcanzado, hito)
) WITH CLUSTERING ORDER BY (fecha_alcanzado ASC, hito ASC);
