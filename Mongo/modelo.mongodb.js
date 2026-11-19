// Modelo de MongoDB: colecciones, consultas e índices (requerimientos 1 a 8).
// Se corre en mongosh. Los tipos de cada colección están en el documento del proyecto.

// No visto en clase: use("...") con paréntesis. En clase se escribe use gestion_proyectos en el shell,
// pero dentro de un archivo mongosh no acepta esa forma; use("...") es lo mismo escrito como función.
use("gestion_proyectos");

// proyectos lleva embebida su plantilla ("plantilla": descripcion, duracion_estimada_semanas y tareas_base):
// son pocos datos fijos que se leen junto con el proyecto. tareas va aparte porque un proyecto llega a
// cientos de tareas que se modifican solas todo el día.
db.createCollection("proyectos");
db.createCollection("tareas");

// ----- ÍNDICES -----

// R1: buscar un proyecto por su nombre, que es lo que el usuario conoce.
// No visto en clase: { unique: true }. El índice único se vio como concepto, no su sintaxis:
// hace que Mongo rechace un segundo proyecto con el mismo nombre.
db.proyectos.createIndex({ "nombre": 1 }, { unique: true });

// R2: tablero por proyecto y etapa, ya ordenado por prioridad y fecha límite.
db.tareas.createIndex({ "proyecto.nombre": 1, "etapa": 1, "prioridad": -1, "fecha_limite": 1 });

// R3, R5 y R7: tareas de un proyecto (abiertas o todas) y, en R3, por fecha límite.
db.tareas.createIndex({ "proyecto.nombre": 1, "cerrada": 1, "fecha_limite": 1 });

// R4: búsqueda por palabras en título y descripción, en español.
db.tareas.createIndex({ "titulo": "text", "descripcion": "text" }, { default_language: "spanish" });

// R6: tareas de los proyectos activos de un cliente.
db.tareas.createIndex({ "proyecto.cliente": 1, "proyecto.activo": 1 });

// R8: proyectos de un tipo de servicio, para sacar su plantilla.
db.proyectos.createIndex({ "tipo_servicio": 1 });

// ----- CONSULTAS (find) -----

// R1: ficha completa de un proyecto
db.proyectos.find({ "nombre": "Implementación ERP Ferretero Jalisco" });

// R2: tablero de un proyecto por etapa
// No visto en clase: .sort() del cursor. En clase el orden se vio con $sort dentro de aggregate;
// .sort() hace lo mismo sobre el resultado del find (1 ascendente, -1 descendente).
db.tareas.find(
  { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", "etapa": "En progreso" },
  { "folio": 1, "titulo": 1, "asignados": 1, "prioridad": 1, "fecha_limite": 1, "horas_estimadas": 1, "etiquetas": 1, "_id": 0 }
).sort({ "prioridad": -1, "fecha_limite": 1 });

// R3: tareas vencidas de un proyecto
// No visto en clase: .sort() del cursor (ver R2).
db.tareas.find(
  { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", "cerrada": false, "fecha_limite": { $lt: ISODate("2026-11-10") } },
  { "folio": 1, "titulo": 1, "asignados": 1, "etapa": 1, "fecha_limite": 1, "_id": 0 }
).sort({ "fecha_limite": 1 });

// R4: búsqueda de tareas por palabras
// No visto en clase: { $meta: "textScore" } trae la calificación de relevancia que $text le da a cada
// tarea, y el .sort() (ver R2) la usa para ordenar de la más relevante a la menos.
db.tareas.find(
  { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", $text: { $search: "factura timbrado", $language: "spanish" } },
  { "folio": 1, "titulo": 1, "etapa": 1, "asignados": 1, "score": { $meta: "textScore" }, "_id": 0 }
).sort({ "score": { $meta: "textScore" } });

// R8: proyectos de un tipo de servicio con su plantilla, para arrancar uno nuevo con la misma estructura
db.proyectos.find(
  { "tipo_servicio": "Implementación de ERP" },
  { "nombre": 1, "etapas": 1, "plantilla": 1, "_id": 0 }
);
