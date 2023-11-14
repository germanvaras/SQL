DROP FUNCTION IF EXISTS uefa_champions_league.FN_CALCULAR_PROMEDIO_GOLES_TORNEO;
DELIMITER //
CREATE FUNCTION uefa_champions_league.FN_CALCULAR_PROMEDIO_GOLES_TORNEO(P_ID_Torneo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT DEFAULT 0;
    DECLARE totalPartidos INT DEFAULT 0;
    DECLARE promedioGoles FLOAT;

    SELECT COUNT(*) INTO totalGoles
    FROM uefa_champions_league.Gol g
    INNER JOIN uefa_champions_league.Partido p ON g.ID_partido = p.ID_partido
    WHERE p.ID_torneo = P_ID_Torneo;

    SELECT COUNT(*) INTO totalPartidos
    FROM uefa_champions_league.Partido
    WHERE ID_torneo = P_ID_Torneo;

    IF totalPartidos > 0 THEN
        SET promedioGoles = totalGoles / totalPartidos;
    ELSE
        SET promedioGoles = 0;
    END IF;

    RETURN promedioGoles;
END//
DELIMITER;
DROP FUNCTION IF EXISTS uefa_champions_league.FN_CALCULAR_PROMEDIO_EDAD_EQUIPO;
DELIMITER //
CREATE FUNCTION uefa_champions_league.FN_CALCULAR_PROMEDIO_EDAD_EQUIPO(P_ID_Equipo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE promedioEdad FLOAT;
    SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_nacimiento, CURDATE())) INTO promedioEdad
    FROM uefa_champions_league.Jugador
    WHERE ID_equipo = P_ID_Equipo;
    RETURN promedioEdad;
END//

DELIMITER ;
DELIMITER //
DROP FUNCTION IF EXISTS uefa_champions_league.FN_OBTENER_TOTAL_GOLES_PARTIDO;
DELIMITER //
CREATE FUNCTION uefa_champions_league.FN_OBTENER_TOTAL_GOLES_PARTIDO(P_ID_Partido INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT;
    SELECT COUNT(*) INTO totalGoles
    FROM uefa_champions_league.Gol
    WHERE ID_partido = P_ID_Partido;
    RETURN totalGoles;
END//
DROP FUNCTION IF EXISTS uefa_champions_league.FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO;
DELIMITER //
CREATE FUNCTION uefa_champions_league.FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO(P_ID_Equipo INT, P_ID_Torneo INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalTarjetas INT DEFAULT 0;

    SELECT COUNT(*) INTO totalTarjetas
    FROM uefa_champions_league.Tarjeta t
    JOIN uefa_champions_league.Partido p ON t.ID_partido = p.ID_partido
    JOIN uefa_champions_league.Jugador j ON t.ID_jugador = j.ID_jugador
    WHERE j.ID_equipo = P_ID_Equipo AND p.ID_torneo = P_ID_Torneo;

    RETURN totalTarjetas;
END//

DELIMITER ;
DELIMITER ;

SELECT uefa_champions_league.FN_CALCULAR_PROMEDIO_GOLES_TORNEO(22) as promedioDeGolesTorneo; -- Por el momento esta solo cargado los goles del torneo 22
SELECT uefa_champions_league.FN_CALCULAR_PROMEDIO_EDAD_EQUIPO(1) as promedioDeEdadEquipo; -- Reemplazar 1 con el ID del equipo deseado.
SELECT uefa_champions_league.FN_OBTENER_TOTAL_GOLES_PARTIDO(1) as totalGolesPartido; -- Reemplazar 1 con el ID del partido deseado.
SELECT uefa_champions_league.FN_CALCULAR_TOTAL_TARJETAS_EQUITO_TORNEO(1, 22) as TotalTarjetasEquipo; -- Reemplazar el primer 1 con el ID del equipo y el segundo 22 con el ID del torneo (por el momento solo existe el 22).





