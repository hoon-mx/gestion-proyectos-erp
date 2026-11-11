// Modelo de MongoDB: colecciones, consultas e índices (requerimientos 1 a 8).
// Se corre en mongosh. Los tipos de cada colección están en el documento del proyecto.

use("gestion_proyectos");

db.createCollection("proyectos");
db.createCollection("tareas");
db.createCollection("plantillas_proyecto");

// ----- ÍNDICES -----

// R1: buscar un proyecto por su nombre, que es lo que el usuario conoce; unique evita dos proyectos con el mismo nombre.
db.proyectos.createIndex({ "nombre": 1 }, { unique: true });

// R2: tablero por proyecto y etapa, ya ordenado por prioridad y fecha límite.
db.tareas.createIndex({ "proyecto.nombre": 1, "etapa": 1, "prioridad": -1, "fecha_limite": 1 });

// R3, R5 y R7: tareas de un proyecto (abiertas o todas) y, en R3, por fecha límite.
db.tareas.createIndex({ "proyecto.nombre": 1, "cerrada": 1, "fecha_limite": 1 });

// R4: búsqueda por palabras en título y descripción, en español.
db.tareas.createIndex({ "titulo": "text", "descripcion": "text" }, { default_language: "spanish" });

// R6: tareas de los proyectos activos de un cliente.
db.tareas.createIndex({ "proyecto.cliente": 1, "proyecto.activo": 1 });

// plantillas_proyecto no lleva índice: son unas 10 plantillas y un COLLSCAN de 10 documentos
// cuesta menos que mantener un índice en cada escritura.

// ----- CONSULTAS (find) -----

// R1: ficha completa de un proyecto
db.proyectos.find({ "nombre": "Implementación ERP Ferretero Jalisco" });

// R2: tablero de un proyecto por etapa
db.tareas.find(
  { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", "etapa": "En progreso" },
  { "folio": 1, "titulo": 1, "asignados": 1, "prioridad": 1, "fecha_limite": 1, "horas_estimadas": 1, "etiquetas": 1, "_id": 0 }
).sort({ "prioridad": -1, "fecha_limite": 1 });

// R3: tareas vencidas de un proyecto
db.tareas.find(
  { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", "cerrada": false, "fecha_limite": { $lt: ISODate("2026-11-10") } },
  { "folio": 1, "titulo": 1, "asignados": 1, "etapa": 1, "fecha_limite": 1, "_id": 0 }
).sort({ "fecha_limite": 1 });

// R4: búsqueda de tareas por palabras
db.tareas.find(
  { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", $text: { $search: "factura timbrado", $language: "spanish" } },
  { "folio": 1, "titulo": 1, "etapa": 1, "asignados": 1, "score": { $meta: "textScore" }, "_id": 0 }
).sort({ "score": { $meta: "textScore" } });

// R8: plantilla de un tipo de servicio
db.plantillas_proyecto.find({ "tipo_servicio": "Implementación de ERP" });
