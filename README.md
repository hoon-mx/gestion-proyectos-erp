# Sistema de Gestión de Proyectos Empresariales

Proyecto final de **Bases de Datos No Relacionales**, ITESO, otoño 2026.
Profesora: Anmol Khatri Pathry.

| Integrante | Expediente | Correo |
|---|---|---|
| Santiago Barragán Pinzón | 740433 | santiago.barragan@iteso.mx |

## Descripción

Un mini ERP de proyectos, al estilo del módulo de Proyectos y Hojas de horas de Odoo, para una
consultora que trabaja por proyecto con sus clientes. El sistema permite consultar:

- los proyectos, sus tareas en un tablero por etapas, sus descripciones y su configuración;
- la relación entre empleados, equipos, tareas, habilidades, proyectos y clientes, incluidas las
  dependencias entre tareas;
- el historial de cambios de cada tarea, las horas registradas y la actividad del proyecto.

Cada parte vive en la base que mejor la resuelve:

| Base | Qué guarda | Por qué |
|---|---|---|
| **MongoDB** | Proyectos, tareas, descripciones y plantillas de proyecto | Son documentos con estructura flexible (subtareas, etiquetas, asignados) que se leen completos y se agregan por etapa o por cliente. |
| **Dgraph** | Empleados, equipos, tareas, habilidades, proyectos y clientes, con sus relaciones | Las consultas recorren relaciones: cadena de dependencias, cadena de mando, candidatos por habilidad, clientes cercanos. |
| **Cassandra** | Historial de cambios, horas registradas, actividad y reportes de avance | Son series por llave y tiempo que crecen sin parar y se leen por rango de fechas. |

Los 24 requerimientos (8 por base), los modelos de datos y sus justificaciones están en el
documento del proyecto.

## Estructura

```
Cassandra/     modelo y consultas de Cassandra
Mongo/         modelo, índices y agregaciones de MongoDB
Dgraph/        esquema y consultas de Dgraph
data/          datos de prueba (CSV y JSON)
connect.py     conexión a las tres bases
populate.py    carga de los datos de data/ a las tres bases
main.py        menú de consultas
```

## Flujo de ejecución

1. Levantar las tres bases con Docker:

   ```bash
   docker run --name mymongodb -d -p 27017:27017 mongo
   docker run --name cassandra -d -p 9042:9042 cassandra:4.1
   docker run --name dgraph -d -p 8080:8080 -p 9080:9080 dgraph/standalone:latest
   ```

2. Crear el entorno virtual dentro del repositorio e instalar las dependencias:

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. Probar la conexión: `python connect.py`.
4. Poblar las bases con los datos de `data/`: `python populate.py`.
5. Correr el menú y elegir una consulta: `python main.py`.

## Origen de los datos

Los datos de prueba se generan con **Faker** (`es_MX`) y se guardan en `data/` como CSV (empleados,
clientes, habilidades, horas y cambios) y JSON (proyectos y tareas, que llevan arreglos y
subdocumentos). Así las tres bases se pueblan con los mismos empleados, proyectos y tareas, y las
consultas de una base se pueden cruzar con las de otra.
