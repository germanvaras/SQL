use uefa_champions_league;
-- FN_CALCULAR_PROMEDIO_EDAD_EQUIPO: Calcula la edad promedio de los jugadores de un equipo.
-- Utiliza la tabla Jugador para calcular la edad promedio basada en la fecha de nacimiento.
-- Retorna un valor FLOAT representando la edad promedio.
DROP FUNCTION IF EXISTS FN_CALCULAR_PROMEDIO_GOLES_TORNEO;
DELIMITER //
CREATE FUNCTION FN_CALCULAR_PROMEDIO_GOLES_TORNEO(P_ID_Torneo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT DEFAULT 0;
    DECLARE totalPartidos INT DEFAULT 0;
    DECLARE promedioGoles FLOAT;

    SELECT COUNT(*) INTO totalGoles
    FROM Gol g
    INNER JOIN Partido p ON g.ID_partido = p.ID_partido
    WHERE p.ID_torneo = P_ID_Torneo;

    SELECT COUNT(*) INTO totalPartidos
    FROM Partido
    WHERE ID_torneo = P_ID_Torneo;

    IF totalPartidos > 0 THEN
        SET promedioGoles = totalGoles / totalPartidos;
    ELSE
        SET promedioGoles = 0;
    END IF;

    RETURN promedioGoles;
END//
DELIMITER;
-- FN_CALCULAR_PROMEDIO_EDAD_EQUIPO: Calcula la edad promedio de los jugadores de un equipo.
-- Utiliza la tabla Jugador para calcular la edad promedio basada en la fecha de nacimiento.
-- Retorna un valor FLOAT representando la edad promedio.
DROP FUNCTION IF EXISTS FN_CALCULAR_PROMEDIO_EDAD_EQUIPO;
DELIMITER //
CREATE FUNCTION FN_CALCULAR_PROMEDIO_EDAD_EQUIPO(P_ID_Equipo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE promedioEdad FLOAT;
    SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_nacimiento, CURDATE())) INTO promedioEdad
    FROM Jugador
    WHERE ID_equipo = P_ID_Equipo;
    RETURN promedioEdad;
END//

DELIMITER ;
DELIMITER //
-- FN_OBTENER_TOTAL_GOLES_PARTIDO: Determina el número total de goles marcados en un partido específico.
-- Consulta la tabla Gol para contar los goles asociados con el ID del partido.
-- Retorna un valor INT que representa el total de goles en ese partido.
DROP FUNCTION IF EXISTS FN_OBTENER_TOTAL_GOLES_PARTIDO;
DELIMITER //
CREATE FUNCTION FN_OBTENER_TOTAL_GOLES_PARTIDO(P_ID_Partido INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT;
    SELECT COUNT(*) INTO totalGoles
    FROM Gol
    WHERE ID_partido = P_ID_Partido;
    RETURN totalGoles;
END//
-- FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO: Calcula el total de tarjetas (amarillas y rojas) recibidas
-- por un equipo en un torneo específico. Utiliza las tablas Tarjeta, Partido y Jugador para determinar
-- el total de tarjetas. Retorna un valor INT que indica el número total de tarjetas.
DROP FUNCTION IF EXISTS FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO;
DELIMITER //
CREATE FUNCTION FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO(P_ID_Equipo INT, P_ID_Torneo INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalTarjetas INT DEFAULT 0;

    SELECT COUNT(*) INTO totalTarjetas
    FROM Tarjeta t
    JOIN Partido p ON t.ID_partido = p.ID_partido
    JOIN Jugador j ON t.ID_jugador = j.ID_jugador
    WHERE j.ID_equipo = P_ID_Equipo AND p.ID_torneo = P_ID_Torneo;

    RETURN totalTarjetas;
END//

DELIMITER ;
DELIMITER ;

SELECT FN_CALCULAR_PROMEDIO_GOLES_TORNEO(22) as promedioDeGolesTorneo; -- Por el momento esta solo cargado los goles del torneo 22
SELECT FN_CALCULAR_PROMEDIO_EDAD_EQUIPO(1) as promedioDeEdadEquipo; -- Reemplazar 1 con el ID del equipo deseado.
SELECT FN_OBTENER_TOTAL_GOLES_PARTIDO(1) as totalGolesPartido; -- Reemplazar 1 con el ID del partido deseado.
SELECT FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO(1, 22) as TotalTarjetasEquipo; -- Reemplazar el primer 1 con el ID del equipo y el segundo 22 con el ID del torneo (por el momento solo existe el 22).





