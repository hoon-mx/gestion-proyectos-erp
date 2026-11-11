-- Modelo de Cassandra: una tabla por consulta (requerimientos 1 a 8).
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
CREATE TABLE IF NOT EXISTS horas_by_empleado (
    correo_empleado TEXT,
    fecha DATE,
    registro_id TIMEUUID,
    proyecto TEXT,
    tarea TEXT,
    horas DECIMAL,
    descripcion TEXT,
    facturable BOOLEAN,
    PRIMARY KEY (correo_empleado, fecha, registro_id)
) WITH CLUSTERING ORDER BY (fecha DESC, registro_id ASC);

-- Tabla 3: requerimiento 3
CREATE TABLE IF NOT EXISTS horas_by_proyecto_mes (
    nombre_proyecto TEXT,
    mes TEXT,
    fecha DATE,
    registro_id TIMEUUID,
    empleado TEXT,
    tarea TEXT,
    horas DECIMAL,
    facturable BOOLEAN,
    tarifa_hora DECIMAL,
    PRIMARY KEY ((nombre_proyecto, mes), fecha, registro_id)
) WITH CLUSTERING ORDER BY (fecha ASC, registro_id ASC);

-- Tabla 4: requerimiento 4
CREATE TABLE IF NOT EXISTS actividad_by_proyecto (
    nombre_proyecto TEXT,
    fecha_evento TIMEUUID,
    tipo_evento TEXT,
    tarea TEXT,
    empleado TEXT,
    detalle TEXT,
    PRIMARY KEY (nombre_proyecto, fecha_evento)
) WITH CLUSTERING ORDER BY (fecha_evento DESC);

-- Tabla 5: requerimiento 5
CREATE TABLE IF NOT EXISTS movimientos_by_proyecto_dia (
    nombre_proyecto TEXT,
    fecha DATE,
    hora TIMESTAMP,
    folio TEXT,
    tarea TEXT,
    etapa_anterior TEXT,
    etapa_nueva TEXT,
    empleado TEXT,
    PRIMARY KEY ((nombre_proyecto, fecha), hora, folio)
) WITH CLUSTERING ORDER BY (hora ASC, folio ASC);

-- Tabla 6: requerimiento 6
CREATE TABLE IF NOT EXISTS tareas_cerradas_by_empleado_mes (
    correo_empleado TEXT,
    mes TEXT,
    fecha_cierre TIMESTAMP,
    folio TEXT,
    tarea TEXT,
    proyecto TEXT,
    horas_estimadas DECIMAL,
    horas_reales DECIMAL,
    PRIMARY KEY ((correo_empleado, mes), fecha_cierre, folio)
) WITH CLUSTERING ORDER BY (fecha_cierre DESC, folio ASC);

-- Tabla 7: requerimiento 7
CREATE TABLE IF NOT EXISTS reportes_by_proyecto (
    nombre_proyecto TEXT,
    fecha_reporte DATE,
    estado TEXT,
    porcentaje_avance INT,
    comentario TEXT,
    autor TEXT,
    PRIMARY KEY (nombre_proyecto, fecha_reporte)
) WITH CLUSTERING ORDER BY (fecha_reporte DESC);

-- Tabla 8: requerimiento 8
CREATE TABLE IF NOT EXISTS hitos_by_proyecto (
    nombre_proyecto TEXT,
    fecha_alcanzado DATE,
    hito TEXT,
    fecha_planeada DATE,
    monto_a_facturar DECIMAL,
    PRIMARY KEY (nombre_proyecto, fecha_alcanzado, hito)
) WITH CLUSTERING ORDER BY (fecha_alcanzado ASC, hito ASC);
