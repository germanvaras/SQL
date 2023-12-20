use uefa_champions_league;
DROP TABLE IF EXISTS LogJugador;
-- Creación de la tabla LogJugador para registrar acciones realizadas sobre la tabla Jugador.
-- Cada log incluye un ID autoincremental, usuario que realiza la acción, fecha, hora, tipo de acción y detalles.
CREATE TABLE IF NOT EXISTS LogJugador (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(255),
    Fecha DATE,
    Hora TIME,
    Accion VARCHAR(50),
    Detalle TEXT
);
DROP TABLE IF EXISTS LogPartido;
-- Creación de la tabla LogPartido para registrar acciones realizadas sobre la tabla Partido.
-- Similar a LogJugador, pero específica para la tabla Partido.
CREATE TABLE LogPartido (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(255),
    Fecha DATE,
    Hora TIME,
    Accion VARCHAR(50),
    Detalle TEXT
);
DROP TRIGGER IF EXISTS TRG_BEFORE_INSERT_JUGADOR;
DELIMITER //
-- TRG_BEFORE_INSERT_JUGADOR: Trigger que registra en LogJugador cada intento de inserción en la tabla Jugador.
-- Se ejecuta antes del INSERT y registra detalles del jugador que se intenta agregar.

CREATE TRIGGER TRG_BEFORE_INSERT_JUGADOR
BEFORE INSERT ON Jugador FOR EACH ROW
BEGIN
    INSERT INTO LogJugador (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Insert', CONCAT('Intentando agregar a ', NEW.Nombre, ' ', NEW.Apellido));
END //
DELIMITER ;
DROP TRIGGER IF EXISTS TRG_AFTER_UPDATE_JUGADOR;
DELIMITER //
-- TRG_AFTER_UPDATE_JUGADOR: Trigger que registra en LogJugador cada actualización en la tabla Jugador.
-- Se ejecuta después del UPDATE y registra los cambios realizados en el jugador.
CREATE TRIGGER TRG_AFTER_UPDATE_JUGADOR
AFTER UPDATE ON Jugador FOR EACH ROW
BEGIN
    SET @cambios = '';
    IF OLD.Nombre <> NEW.Nombre THEN
        SET @cambios = CONCAT(@cambios, ' Nombre cambiado de "', OLD.Nombre, '" a "', NEW.Nombre, '"');
    END IF;
    IF OLD.Apellido <> NEW.Apellido THEN
        SET @cambios = CONCAT(@cambios, ' Apellido cambiado de "', OLD.Apellido, '" a "', NEW.Apellido, '"');
    END IF;
    IF OLD.Fecha_nacimiento <> NEW.Fecha_nacimiento THEN
        SET @cambios = CONCAT(@cambios, ' Fecha de nacimiento cambiada de "', OLD.Fecha_nacimiento, '" a "', NEW.Fecha_nacimiento, '"');
    END IF;
    IF OLD.ID_equipo <> NEW.ID_equipo THEN
        SET @cambios = CONCAT(@cambios, ' ID de equipo cambiado de ', OLD.ID_equipo, ' a ', NEW.ID_equipo);
    END IF;
    IF LENGTH(@cambios) > 0 THEN
        INSERT INTO LogJugador (Usuario, Fecha, Hora, Accion, Detalle)
        VALUES (USER(), CURDATE(), CURTIME(), 'Update', CONCAT('Jugador ID ', OLD.ID_jugador, ' actualizado.', @cambios));
    END IF;
END //
DELIMITER ;
DROP TRIGGER IF EXISTS uefa_champions_league.TRG_BEFORE_DELETE_JUGADOR;
DELIMITER //
-- TRG_BEFORE_DELETE_JUGADOR: Trigger que registra en LogJugador cada eliminación en la tabla Jugador.
-- Se ejecuta antes del DELETE y registra el ID del jugador eliminado.
CREATE TRIGGER TRG_BEFORE_DELETE_JUGADOR
BEFORE DELETE ON Jugador FOR EACH ROW
BEGIN
    INSERT INTO LogJugador (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Delete', CONCAT('Eliminando jugador ID: ', OLD.ID_jugador));
END //
DELIMITER ;
DROP TRIGGER IF EXISTS TRG_BEFORE_DELETE_PARTIDO;
DELIMITER //
-- TRG_BEFORE_DELETE_PARTIDO: Trigger que registra en LogPartido cada eliminación en la tabla Partido.
-- Se ejecuta antes del DELETE y registra el ID del partido eliminado.
CREATE TRIGGER TRG_BEFORE_DELETE_PARTIDO
BEFORE DELETE ON Partido FOR EACH ROW
BEGIN
    INSERT INTO LogPartido (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Delete', CONCAT('Eliminando partido ID ', OLD.ID_partido));
END //
DELIMITER ;
DROP TRIGGER IF EXISTS TRG_BEFORE_UPDATE_PARTIDO;
DELIMITER //
-- TRG_BEFORE_UPDATE_PARTIDO: Trigger que registra en LogPartido cada actualización en la tabla Partido.
-- Se ejecuta antes del UPDATE y registra los cambios realizados en el partido.
CREATE TRIGGER TRG_BEFORE_UPDATE_PARTIDO
BEFORE UPDATE ON Partido FOR EACH ROW
BEGIN
    SET @cambios = '';

    IF OLD.Fecha <> NEW.Fecha THEN
        SET @cambios = CONCAT(@cambios, ' Fecha cambiada de "', OLD.Fecha, '" a "', NEW.Fecha, '"');
    END IF;

    IF OLD.ID_arbitro <> NEW.ID_arbitro THEN
        SET @cambios = CONCAT(@cambios, ' ID de árbitro cambiado de ', OLD.ID_arbitro, ' a ', NEW.ID_arbitro);
    END IF;

    IF LENGTH(@cambios) > 0 THEN
        INSERT INTO LogPartido (Usuario, Fecha, Hora, Accion, Detalle)
        VALUES (USER(), CURDATE(), CURTIME(), 'Update', CONCAT('Partido ID ', OLD.ID_partido, ' actualizado.', @cambios));
    END IF;
END //
DELIMITER ;
DROP TRIGGER IF EXISTS TRG_AFTER_INSERT_PARTIDO;
DELIMITER //
-- TRG_AFTER_INSERT_PARTIDO: Trigger que registra en LogPartido cada inserción en la tabla Partido.
-- Se ejecuta después del INSERT y registra el ID del nuevo partido agregado.
CREATE TRIGGER TRG_AFTER_INSERT_PARTIDO
AFTER INSERT ON Partido FOR EACH ROW
BEGIN
    INSERT INTO LogPartido (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Insert', CONCAT('Nuevo partido agregado ID ', NEW.ID_partido));
END //
DELIMITER ;
INSERT INTO Jugador (Nombre, Apellido, Fecha_nacimiento, Nacionalidad, Posicion, ID_equipo)
VALUES ('Jugador', 'Insertado', '1987-06-24', 'Argentina', 'Delantero', 1);
UPDATE Jugador
SET Apellido = 'Modificado'
WHERE ID_jugador = (
    SELECT MAX(ID_jugador) FROM (SELECT * FROM Jugador) AS maxID
);
DELETE FROM Jugador WHERE ID_jugador = (
    SELECT MAX(ID_jugador) FROM (SELECT * FROM Jugador) AS maxID
);
INSERT INTO Partido (Fecha, ID_local, ID_visitante, ID_arbitro, ID_estadio, ID_faseEliminatoria, ID_grupo, ID_torneo)
VALUES (CURDATE(), 1, 2, 1, 1, 1, 'A', 22);
UPDATE Partido  SET  ID_Arbitro  = 6  WHERE ID_partido = (
    SELECT MAX(ID_partido) FROM (SELECT * FROM Partido) AS maxID
);
DELETE FROM Partido WHERE ID_partido = (
    SELECT MAX(ID_partido) FROM (SELECT * FROM Partido) AS maxID
);
