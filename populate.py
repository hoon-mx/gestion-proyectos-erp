#!/usr/bin/env python3
# Cómo se van a poblar las tres bases. Todavía no se carga nada: este archivo describe el plan.
#
# 1. Datos de prueba (data/)
#    Se generan con Faker (es_MX) y se guardan en data/ para que las tres bases compartan los mismos
#    empleados, clientes, proyectos y tareas:
#    - empleados.csv: empleado_id, nombre, correo, puesto, fecha_ingreso, equipo, jefe_id
#    - clientes.csv: cliente_id, nombre, industria, latitud, longitud (Zona Metropolitana de Guadalajara)
#    - habilidades.csv: habilidad_id, nombre, categoria
#    - proyectos.json: proyectos con su código (PRJ-2026-001...), cliente, responsable,
#      horas presupuestadas y etapa
#    - tareas.json: tareas con proyecto embebido, etapa, prioridad, etiquetas, asignados, subtareas,
#      fecha límite, horas estimadas y dependencias
#    - horas.csv: registros de horas por empleado, tarea y día (facturable o no, tarifa por hora)
#    - cambios.csv: historial de cambios de cada tarea (campo, valor anterior, valor nuevo, quién)
#
# 2. MongoDB (connect_mongo)
#    - Lee proyectos.json, tareas.json y las plantillas, y los inserta con insert_many en las
#      colecciones proyectos, tareas y plantillas_proyecto.
#    - Calcula horas_registradas de cada tarea sumando horas.csv antes de insertarla.
#    - Crea los índices del modelo: tablero por proyecto, etapa, prioridad y fecha límite;
#      tareas abiertas por fecha límite; índice de texto en título y descripción; cliente activo.
#
# 3. Cassandra (connect_cassandra)
#    - Crea las tablas del modelo (cambios_by_tarea, horas_by_empleado, horas_by_proyecto_mes y las
#      demás) con CREATE TABLE IF NOT EXISTS.
#    - Lee cambios.csv y horas.csv y los inserta con sentencias preparadas y batch por partición,
#      generando los TIMEUUID con time_uuid a partir de la fecha de cada registro.
#    - Cada registro de horas se escribe dos veces: por empleado (horas_by_empleado) y por proyecto y
#      mes (horas_by_proyecto_mes), porque en Cassandra cada consulta tiene su tabla.
#
# 4. Dgraph (connect_dgraph)
#    - Aplica el esquema (tipos Empleado, Equipo, Tarea, Proyecto, Cliente y Habilidad, sus
#      predicados, índices y @reverse) con alter.
#    - Arma una mutación JSON con blank nodes (_:emp1, _:tarea1...) a partir de los CSV y JSON, con
#      las relaciones REPORTA_A, MIEMBRO_DE, ASIGNADO_A, DEPENDE_DE, PERTENECE_A, RESPONSABLE_DE,
#      TRABAJA_EN, TIENE_HABILIDAD, REQUIERE y PARA_CLIENTE y sus facets (rol, desde, nivel,
#      horas_asignadas, nivel_minimo).
#    - Ejecuta la mutación en una transacción y hace commit.
