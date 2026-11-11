-- Modelo de Cassandra: una tabla por consulta (requerimientos 1 a 8).
-- Lo ejecuta populate.py con session.execute(); aquí queda documentado.

CREATE KEYSPACE IF NOT EXISTS gestion_proyectos
WITH replication = { 'class': 'SimpleStrategy', 'replication_factor': 1 };

USE gestion_proyectos;

-- Tabla 1: requerimiento 1
CREATE TABLE IF NOT EXISTS cambios_by_tarea (
    tarea_id UUID,
    fecha_cambio TIMESTAMP,
    cambio_id TIMEUUID,
    campo_modificado TEXT,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    empleado TEXT,
    PRIMARY KEY (tarea_id, fecha_cambio, cambio_id)
) WITH CLUSTERING ORDER BY (fecha_cambio DESC, cambio_id ASC);

-- Tabla 2: requerimiento 2
CREATE TABLE IF NOT EXISTS horas_by_empleado (
    empleado_id UUID,
    fecha DATE,
    registro_id TIMEUUID,
    proyecto TEXT,
    tarea TEXT,
    horas DECIMAL,
    descripcion TEXT,
    facturable BOOLEAN,
    PRIMARY KEY (empleado_id, fecha, registro_id)
) WITH CLUSTERING ORDER BY (fecha DESC, registro_id ASC);

-- Tabla 3: requerimiento 3
CREATE TABLE IF NOT EXISTS horas_by_proyecto_mes (
    proyecto_id UUID,
    mes TEXT,
    fecha DATE,
    registro_id TIMEUUID,
    empleado TEXT,
    tarea TEXT,
    horas DECIMAL,
    facturable BOOLEAN,
    tarifa_hora DECIMAL,
    PRIMARY KEY ((proyecto_id, mes), fecha, registro_id)
) WITH CLUSTERING ORDER BY (fecha ASC, registro_id ASC);

-- Tabla 4: requerimiento 4
CREATE TABLE IF NOT EXISTS actividad_by_proyecto (
    proyecto_id UUID,
    fecha_evento TIMEUUID,
    tipo_evento TEXT,
    tarea TEXT,
    empleado TEXT,
    detalle TEXT,
    PRIMARY KEY (proyecto_id, fecha_evento)
) WITH CLUSTERING ORDER BY (fecha_evento DESC);

-- Tabla 5: requerimiento 5
CREATE TABLE IF NOT EXISTS movimientos_by_proyecto_dia (
    proyecto_id UUID,
    fecha DATE,
    hora TIMESTAMP,
    tarea_id UUID,
    tarea TEXT,
    etapa_anterior TEXT,
    etapa_nueva TEXT,
    empleado TEXT,
    PRIMARY KEY ((proyecto_id, fecha), hora, tarea_id)
) WITH CLUSTERING ORDER BY (hora ASC, tarea_id ASC);

-- Tabla 6: requerimiento 6
CREATE TABLE IF NOT EXISTS tareas_cerradas_by_empleado_mes (
    empleado_id UUID,
    mes TEXT,
    fecha_cierre TIMESTAMP,
    tarea_id UUID,
    tarea TEXT,
    proyecto TEXT,
    horas_estimadas DECIMAL,
    horas_reales DECIMAL,
    PRIMARY KEY ((empleado_id, mes), fecha_cierre, tarea_id)
) WITH CLUSTERING ORDER BY (fecha_cierre DESC, tarea_id ASC);

-- Tabla 7: requerimiento 7
CREATE TABLE IF NOT EXISTS reportes_by_proyecto (
    proyecto_id UUID,
    fecha_reporte DATE,
    estado TEXT,
    porcentaje_avance INT,
    comentario TEXT,
    autor TEXT,
    PRIMARY KEY (proyecto_id, fecha_reporte)
) WITH CLUSTERING ORDER BY (fecha_reporte DESC);

-- Tabla 8: requerimiento 8
CREATE TABLE IF NOT EXISTS hitos_by_proyecto (
    proyecto_id UUID,
    fecha_alcanzado DATE,
    hito_id UUID,
    hito TEXT,
    fecha_planeada DATE,
    monto_a_facturar DECIMAL,
    PRIMARY KEY (proyecto_id, fecha_alcanzado, hito_id)
) WITH CLUSTERING ORDER BY (fecha_alcanzado ASC, hito_id ASC);
