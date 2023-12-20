# UEFA Champions League Database Model - CoderHouse Project

Este proyecto es un modelo de base de datos para la UEFA Champions League, diseñado como parte del curso de base de datos en CoderHouse. Contiene todos los scripts SQL necesarios para crear, poblar y gestionar una base de datos que representa la estructura y la dinámica del torneo de fútbol más prestigioso de Europa.

# Estructura de la entrega final

<pre>
entrega-final/
│
├── objects/                         # Scripts para la creación de objetos de la base de datos
│   ├── functions-champions.sql      # Funciones
│   ├── stored-procedures-champions.sql  # Procedimientos almacenados
│   ├── triggers-uefa-champions.sql  # Triggers
│   ├── uefa-champions-league-script.sql # Script principal de estructura de la base de datos
│   ├── users-permissions.sql        # Permisos de usuario
│   └── views-prensa-champions.sql   # Vistas para la prensa
│
├── champions-league.pdf             # Documentación del proyecto
├── instrucciones-db.txt             # Instrucciones para la implementación de la base de datos
│
├── backup/                          # Backup inicial de la base de datos
│   └── Dump20231211.sql             # Archivo de backup
</pre>

Para configurar la base de datos, siga los pasos a continuación en el orden dado:

1. **Script de Estructura Principal**: `uefa-champions-league-script.sql`
2. **Triggers**: `triggers-uefa-champions.sql`
3. **Población de Datos Iniciales**: `populate-uefa-champions.sql`
4. **Funciones**: `functions-champions.sql`
5. **Procedimientos Almacenados**: `stored-procedures-champions.sql`
6. **Vistas para la Prensa**: `views-prensa-champions.sql`
7. **Transacciones**: `transaction-estadios-entrenadores.sql`
8. **Permisos de Usuario**: `users-permissions.sql`

## Backup

Antes de iniciar el proceso de implementación, realice un backup usando `Dump20231211.sql`.

## Restauración y Rollback

Si necesita revertir los cambios, utilice los puntos de guardado dentro de las transacciones o restaure la base de datos desde el último backup.

## Nota para los Estudiantes

Este modelo es una herramienta educativa. Se anima a los estudiantes a explorar, modificar y mejorar el diseño proporcionado. La participación activa y la experimentación son clave para el aprendizaje efectivo en CoderHouse. No te quedés solo con la entrega final, animate a revisar el resto de los desafios.

---

**¡Feliz codificación!**
