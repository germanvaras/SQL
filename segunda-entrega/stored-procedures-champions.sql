use uefa_champions_league;
DROP PROCEDURE IF EXISTS SP_INSERTAR_O_ELIMINAR_GOL;
DELIMITER //
-- SP_INSERTAR_O_ELIMINAR_GOL: Procedimiento para insertar o eliminar un gol.
-- 'INSERTAR' añade un nuevo gol, 'ELIMINAR' borra uno existente. 
-- Maneja también las asociaciones en la tabla Asistencia para mantener la integridad de datos.
CREATE PROCEDURE SP_INSERTAR_O_ELIMINAR_GOL(
    IN Accion VARCHAR(10),      -- 'INSERTAR' para añadir un nuevo gol, 'ELIMINAR' para borrar uno.
    IN P_ID_Gol INT,            -- ID del gol (usado solo para eliminar).
    IN P_Minuto INT,            -- Minuto en el que se anotó el gol (usado solo para insertar).
    IN P_ID_Jugador INT,        -- ID del jugador que anotó el gol (usado solo para insertar).
    IN P_ID_Partido INT)        -- ID del partido del gol (usado solo para insertar).
BEGIN
    IF Accion = 'INSERT' THEN
        -- Insertar un nuevo registro en la tabla Gol.
        INSERT INTO Gol (Minuto, ID_jugador, ID_partido) VALUES (P_Minuto, P_ID_Jugador, P_ID_Partido);
    ELSEIF Accion = 'DELETE' THEN
        -- Primero eliminar cualquier asistencia asociada con el gol.
        DELETE FROM Asistencia WHERE ID_gol = P_ID_Gol;

        -- Luego eliminar el gol.
        DELETE FROM Gol WHERE ID_gol = P_ID_Gol;
    END IF;
END//
DELIMITER ;
-- Insertar un nuevo gol (los valores de P_Minuto, P_ID_Jugador, P_ID_Partido deben ser específicos).
CALL SP_INSERTAR_O_ELIMINAR_GOL('INSERT', NULL, 98, 1, 125);
SELECT * FROM gol WHERE ID_GOL = 373;
-- Eliminar un gol existente (reemplazar 1 con el ID específico del gol a eliminar).
CALL SP_INSERTAR_O_ELIMINAR_GOL('DELETE', 373, NULL, NULL, NULL);
SELECT * FROM gol WHERE ID_GOL = 373;

DROP PROCEDURE IF EXISTS SP_ORDERNAR_REGISTRO_JUGADOR;
DELIMITER //
-- SP_ORDERNAR_REGISTRO_JUGADOR: Ordena y muestra los registros de jugadores.
-- Se pueden especificar el campo de ordenamiento y el tipo de orden (ascendente o descendente).
CREATE PROCEDURE SP_ORDERNAR_REGISTRO_JUGADOR(
    IN CampoOrdenamiento VARCHAR(255),  -- Nombre del campo por el que se ordenará.
    IN OrdenAscendente BOOLEAN)         -- TRUE para orden ascendente, FALSE para descendente.
BEGIN
    -- Preparar la consulta SQL dinámica.
    SET @query = CONCAT('SELECT * FROM Jugador ORDER BY ', CampoOrdenamiento, 
                       IF(OrdenAscendente, ' ASC', ' DESC'));

    -- Preparar y ejecutar la consulta.
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- Ordenar jugadores por 'Apellido' en orden ascendente.
CALL SP_ORDERNAR_REGISTRO_JUGADOR('Apellido', TRUE);
-- Ordenar jugadores por 'Nombre' en orden descendente.
CALL SP_ORDERNAR_REGISTRO_JUGADOR('Nombre', FALSE);

-- EXTRAS

DROP PROCEDURE IF EXISTS SP_OBTENER_TOTAL_GOLES_EQUIPO;
DELIMITER //
-- SP_OBTENER_TOTAL_GOLES_EQUIPO: Calcula el total de goles marcados por un equipo en un torneo específico.
-- Utiliza los ID del equipo y del torneo para realizar el cálculo.
CREATE PROCEDURE SP_OBTENER_TOTAL_GOLES_EQUIPO(
    IN P_ID_Equipo INT,  -- ID del equipo para el cual se calcularán los goles.
    IN P_ID_Torneo INT,  -- ID del torneo en el que se quiere contar los goles.
    OUT TotalGoles INT)  -- Variable de salida que contendrá el total de goles.
BEGIN
    -- Consulta para contar el total de goles del equipo en el torneo.
    SELECT COUNT(*) INTO TotalGoles
    FROM Gol g
    JOIN Jugador j ON g.ID_jugador = j.ID_jugador
    JOIN Partido p ON g.ID_partido = p.ID_partido
    WHERE j.ID_equipo = P_ID_Equipo AND p.ID_torneo = P_ID_Torneo;
END //
DELIMITER ;

-- Ejemplo de llamada al procedimiento almacenado
CALL SP_OBTENER_TOTAL_GOLES_EQUIPO(1, 22, @TotalGoles); -- Remplazar el 1 con el id correspondiente al equipo y el 22 por id del torneo ( por el momento solo existe info para el 22)
SELECT @TotalGoles;


DROP PROCEDURE IF EXISTS SP_ACTUALIZAR_CAPACIDAD_ESTADIO;
DELIMITER //
-- SP_ACTUALIZAR_CAPACIDAD_ESTADIO: Actualiza la capacidad de un estadio y devuelve la nueva capacidad.
-- Utiliza un parámetro INOUT para la capacidad y un parámetro IN para el ID del estadio.
CREATE PROCEDURE SP_ACTUALIZAR_CAPACIDAD_ESTADIO(
    INOUT P_Capacidad INT,  -- Capacidad del estadio que será actualizada (entrada/salida).
    IN P_ID_Estadio INT)    -- ID del estadio a actualizar.
BEGIN
    -- Actualizar la capacidad del estadio en la base de datos.
    UPDATE Estadio SET Capacidad = P_Capacidad WHERE ID_estadio = P_ID_Estadio;

    -- Recuperar la nueva capacidad del estadio para confirmar la actualización.
    SELECT Capacidad INTO P_Capacidad FROM Estadio WHERE ID_estadio = P_ID_Estadio;
END //
DELIMITER ;

-- Ejemplo de llamada al procedimiento almacenado
SET @NuevaCapacidad = 50000;
CALL SP_ACTUALIZAR_CAPACIDAD_ESTADIO(@NuevaCapacidad, 1); -- Se puede utilizar cualquier nombre de variable para el primer param, y el 1 se puede remplazar por el id del estadio correspondiente
SELECT @NuevaCapacidad; -- Esto mostrará la capacidad actualizada.