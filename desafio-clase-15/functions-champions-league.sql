DELIMITER //
DROP FUNCTION IF EXISTS uefa_champions_league.CalcularPromedioGolesTorneo;
CREATE FUNCTION uefa_champions_league.CalcularPromedioGolesTorneo(pID_Torneo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT DEFAULT 0;
    DECLARE totalPartidos INT DEFAULT 0;
    DECLARE promedioGoles FLOAT;

    SELECT COUNT(*) INTO totalGoles
    FROM uefa_champions_league.Gol g
    INNER JOIN uefa_champions_league.Partido p ON g.ID_partido = p.ID_partido
    WHERE p.ID_torneo = pID_Torneo;

    SELECT COUNT(*) INTO totalPartidos
    FROM uefa_champions_league.Partido
    WHERE ID_torneo = ID_Torneo;

    IF totalPartidos > 0 THEN
        SET promedioGoles = totalGoles / totalPartidos;
    ELSE
        SET promedioGoles = 0;
    END IF;

    RETURN promedioGoles;
END //
DELIMITER ;
DELIMITER //
DROP FUNCTION IF EXISTS uefa_champions_league.CalcularPromedioEdadEquipo;
CREATE FUNCTION uefa_champions_league.CalcularPromedioEdadEquipo(pID_Equipo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE promedioEdad FLOAT;
    SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_nacimiento, CURDATE())) INTO promedioEdad
    FROM uefa_champions_league.Jugador
    WHERE ID_equipo = pID_Equipo;
    RETURN promedioEdad;
END //

DELIMITER ;
DELIMITER //

DELIMITER //
DROP FUNCTION IF EXISTS  uefa_champions_league.ObtenerTotalGolesPartido;
CREATE FUNCTION uefa_champions_league.ObtenerTotalGolesPartido(pID_Partido INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT;
    SELECT COUNT(*) INTO totalGoles
    FROM uefa_champions_league.Gol
    WHERE ID_partido = pID_Partido;
    RETURN totalGoles;
END //
DELIMITER //
DROP FUNCTION IF EXISTS uefa_champions_league.CalcularTotalTarjetasEquipoTorneo;
CREATE FUNCTION uefa_champions_league.CalcularTotalTarjetasEquipoTorneo(pID_Equipo INT, pID_Torneo INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalTarjetas INT DEFAULT 0;

    SELECT COUNT(*) INTO totalTarjetas
    FROM uefa_champions_league.Tarjeta t
    JOIN uefa_champions_league.Partido p ON t.ID_partido = p.ID_partido
    JOIN uefa_champions_league.Jugador j ON t.ID_jugador = j.ID_jugador
    WHERE j.ID_equipo = pID_Equipo AND p.ID_torneo = pID_Torneo;

    RETURN totalTarjetas;
END //

DELIMITER ;
DELIMITER ;

SELECT uefa_champions_league.CalcularPromedioGolesTorneo(22) as promedioDeGolesTorneo; -- Por el momento esta solo cargado los goles del torneo 22
SELECT uefa_champions_league.CalcularPromedioEdadEquipo(1) as promedioDeEdadEquipo; -- Reemplazar 1 con el ID del equipo deseado.
SELECT uefa_champions_league.ObtenerTotalGolesPartido(1) as totalGolesPartido; -- Reemplazar 1 con el ID del partido deseado.
SELECT uefa_champions_league.CalcularTotalTarjetasEquipoTorneo(1, 22) as TotalTarjetasEquipo; -- Reemplazar el primer 1 con el ID del equipo y el segundo 22 con el ID del torneo (por el momento solo existe el 22).





