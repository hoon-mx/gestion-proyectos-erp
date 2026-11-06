#!/usr/bin/env python3

def print_menu():
    mm_options = {
        "Cassandra": {
            1: "Historial de cambios de una tarea",
            2: "Horas de un empleado en una quincena",
            3: "Horas de un proyecto en un mes para facturar",
            4: "Últimos 30 eventos de actividad de un proyecto",
            5: "Movimientos del tablero en un día",
            6: "Tareas cerradas por un empleado en un mes",
            7: "Reportes semanales de estado de un proyecto",
            8: "Hitos alcanzados de un proyecto",
        },
        "MongoDB": {
            9: "Ficha completa de un proyecto por código",
            10: "Tablero de un proyecto por etapa",
            11: "Tareas vencidas de un proyecto",
            12: "Búsqueda de tareas por palabras",
            13: "Avance por etapa (agregación)",
            14: "Proyectos de un cliente que pasan el 80% de sus horas (agregación)",
            15: "Carga pendiente por empleado (agregación)",
            16: "Plantilla de proyecto por tipo de servicio",
        },
        "Dgraph": {
            17: "Cadena de dependencias de una tarea",
            18: "Tareas afectadas si una tarea se retrasa",
            19: "Candidatos para una tarea por habilidad y nivel",
            20: "Cadena de mando de un empleado",
            21: "Proyectos y clientes de un equipo",
            22: "Empleados con experiencia en un cliente",
            23: "Clientes a menos de 10 km con proyectos activos",
            24: "Tareas vencidas del equipo de un jefe",
        },
    }
    print("\n" + "=" * 60)
    print("Sistema de Gestión de Proyectos Empresariales")
    print("=" * 60)
    for base, options in mm_options.items():
        print(f"\n--- {base} ---")
        for key, value in options.items():
            print(key, '--', value)
    print("\n0 -- Salir")


if __name__ == '__main__':
    print_menu()
