DELIMITER //

CREATE FUNCTION uefa_champions_league.CalcularPromedioGolesTorneo(ID_Torneo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT DEFAULT 0;
    DECLARE totalPartidos INT DEFAULT 0;
    DECLARE promedioGoles FLOAT;

    SELECT COUNT(*) INTO totalGoles
    FROM uefa_champions_league.Gol g
    INNER JOIN uefa_champions_league.Partido p ON g.ID_partido = p.ID_partido
    WHERE p.ID_torneo = ID_Torneo;

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

CREATE FUNCTION uefa_champions_league.CalcularPromedioEdadEquipo(ID_Equipo INT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE promedioEdad FLOAT;
    SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_nacimiento, CURDATE())) INTO promedioEdad
    FROM uefa_champions_league.Jugador
    WHERE ID_equipo = ID_Equipo;
    RETURN promedioEdad;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION uefa_champions_league.ObtenerTotalGolesPartido(ID_Partido INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalGoles INT;
    SELECT COUNT(*) INTO totalGoles
    FROM uefa_champions_league.Gol
    WHERE ID_partido = ID_Partido;
    RETURN totalGoles;
END //

DELIMITER ;
SELECT uefa_champions_league.CalcularPromedioGolesTorneo(22) as promedioDeGolesTorneo; -- Por el momento esta solo cargado los goles del torneo 22
SELECT uefa_champions_league.CalcularPromedioEdadEquipo(1) as promedioDeEdadEquipo; -- Reemplazar 1 con el ID del equipo deseado.
SELECT uefa_champions_league.ObtenerTotalGolesPartido(1) as totalGolesPartido; -- Reemplazar 1 con el ID del partido deseado.





