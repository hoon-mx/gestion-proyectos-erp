// Agregaciones de MongoDB (requerimientos 5, 6 y 7). Se corren en mongosh.

use("gestion_proyectos");

// R5: avance del proyecto por etapa
db.tareas.aggregate([
  { $match: { "proyecto.nombre": "Implementación ERP Ferretero Jalisco" } },
  { $group: { _id: "$etapa", total_tareas: { $sum: 1 }, horas_estimadas: { $sum: "$horas_estimadas" } } },
  { $sort: { total_tareas: -1 } }
]);

// R6: proyectos activos de un cliente que ya consumieron más del 80% de sus horas
db.tareas.aggregate([
  { $match: { "proyecto.cliente": "Grupo Ferretero Jalisco", "proyecto.activo": true, "horas_estimadas": { $gt: 0 } } },
  { $group: { _id: "$proyecto.nombre", horas_estimadas: { $sum: "$horas_estimadas" }, horas_registradas: { $sum: "$horas_registradas" } } },
  { $project: {
      _id: 0, proyecto: "$_id", horas_estimadas: 1, horas_registradas: 1,
      porcentaje_consumido: { $multiply: [ { $divide: ["$horas_registradas", "$horas_estimadas"] }, 100 ] }
  } },
  { $match: { porcentaje_consumido: { $gt: 80 } } },
  { $sort: { porcentaje_consumido: -1 } }
]);

// R7: carga pendiente por empleado en un proyecto
db.tareas.aggregate([
  { $match: { "proyecto.nombre": "Implementación ERP Ferretero Jalisco", "cerrada": false } },
  { $unwind: "$asignados" },
  { $group: { _id: "$asignados.nombre", tareas_abiertas: { $sum: 1 }, horas_pendientes: { $sum: "$horas_estimadas" } } },
  { $sort: { horas_pendientes: -1 } }
]);
