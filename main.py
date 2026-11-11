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
            9: "Ficha completa de un proyecto por nombre",
            10: "Tablero de un proyecto por etapa",
            11: "Tareas vencidas de un proyecto",
            12: "Búsqueda de tareas por palabras",
            13: "Avance por etapa (agregación)",
            14: "Proyectos de un cliente que pasan el 80% de sus horas (agregación)",
            15: "Carga pendiente por empleado (agregación)",
            16: "Plantilla de proyecto por tipo de servicio",
        },
        "Dgraph": {
            17: "Dependencias de una tarea (antes y afectadas)",
            18: "Candidatos para una tarea por habilidad y nivel",
            19: "Cadena de mando de un empleado",
            20: "Ruta más corta entre dos empleados",
            21: "Reemplazo de un empleado",
            22: "Impacto en cadena si un empleado sale",
            23: "Clientes a menos de 10 km con proyectos activos",
            24: "Proyectos que dependen de otro proyecto",
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


def main():
    while True:
        print_menu()
        option = input("\nElige una consulta: ").strip()
        if option == "0":
            print("Hasta luego.")
            break
        if not option.isdigit() or not 1 <= int(option) <= 24:
            print("Opción no válida, elige un número del 0 al 24.")
            continue
        option = int(option)
        if option <= 8:
            base = "Cassandra"
        elif option <= 16:
            base = "MongoDB"
        else:
            base = "Dgraph"
        # Las consultas se conectan con connect.py y se programan en la siguiente entrega.
        print(f"Consulta {option} ({base}): pendiente para la entrega final.")


if __name__ == '__main__':
    main()
