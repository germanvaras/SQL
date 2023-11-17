use uefa_champions_league;
DROP TABLE IF EXISTS LogJugador;
CREATE TABLE IF NOT EXISTS LogJugador (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(255),
    Fecha DATE,
    Hora TIME,
    Accion VARCHAR(50),
    Detalle TEXT
);
DROP TABLE IF EXISTS LogPartido;
CREATE TABLE LogPartido (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(255),
    Fecha DATE,
    Hora TIME,
    Accion VARCHAR(50),
    Detalle TEXT
);
DELIMITER //
DROP TRIGGER IF EXISTS TRG_BEFORE_INSERT_JUGADOR;
CREATE TRIGGER TRG_BEFORE_INSERT_JUGADOR
BEFORE INSERT ON Jugador FOR EACH ROW
BEGIN
    INSERT INTO LogJugador (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Insert', CONCAT('Intentando agregar a ', NEW.Nombre, ' ', NEW.Apellido));
END //
DELIMITER ;
DELIMITER //
DROP TRIGGER IF EXISTS TRG_AFTER_UPDATE_JUGADOR;
CREATE TRIGGER TRG_AFTER_UPDATE_JUGADOR
AFTER UPDATE ON Jugador FOR EACH ROW
BEGIN
    INSERT INTO LogJugador (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Update', CONCAT('Actualizado jugador ID ', OLD.ID_jugador));
END //
DELIMITER ;
DROP TRIGGER IF EXISTS uefa_champions_league.TRG_BEFORE_DELETE_JUGADOR;
DELIMITER //
CREATE TRIGGER TRG_BEFORE_DELETE_JUGADOR
BEFORE DELETE ON Jugador FOR EACH ROW
BEGIN
    INSERT INTO LogJugador (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Delete', CONCAT('Eliminando jugador ID: ', OLD.ID_jugador));
END //
DELIMITER ;
DELIMITER //
DROP TRIGGER IF EXISTS TRG_BEFORE_DELETE_PARTIDO;
CREATE TRIGGER TRG_BEFORE_DELETE_PARTIDO
BEFORE DELETE ON Partido FOR EACH ROW
BEGIN
    INSERT INTO LogPartido (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Delete', CONCAT('Eliminando partido ID ', OLD.ID_partido));
END //
DELIMITER ;
DROP TRIGGER IF EXISTS TRG_BEFORE_UPDATE_PARTIDO;
DELIMITER //
CREATE TRIGGER uefa_champions_league.TRG_BEFORE_UPDATE_PARTIDO
BEFORE UPDATE ON Partido FOR EACH ROW
BEGIN
    INSERT INTO LogPartido (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Update', CONCAT('Actualizando partido ID: ', OLD.ID_partido));
END //
DELIMITER ;
DELIMITER //
DROP TRIGGER IF EXISTS TRG_AFTER_INSERT_PARTIDO;
CREATE TRIGGER TRG_AFTER_INSERT_PARTIDO
AFTER INSERT ON Partido FOR EACH ROW
BEGIN
    INSERT INTO LogPartido (Usuario, Fecha, Hora, Accion, Detalle)
    VALUES (USER(), CURDATE(), CURTIME(), 'Insert', CONCAT('Nuevo partido agregado ID ', NEW.ID_partido));
END //
DELIMITER ;
INSERT INTO Jugador (Nombre, Apellido, Fecha_nacimiento, Nacionalidad, Posicion, ID_equipo)
VALUES ('Jugador', 'Insertado', '1987-06-24', 'Argentina', 'Delantero', 1);
UPDATE Jugador SET  Apellido = 'Modificado' where ID_jugador = 1144;
DELETE from Jugador where ID_jugador = 1144;
INSERT INTO Partido (Fecha, ID_local, ID_visitante, ID_arbitro, ID_estadio, ID_faseEliminatoria, ID_grupo, ID_torneo)
VALUES (CURDATE(), 1, 2, 1, 1, 1, 'A', 22);
UPDATE Partido  SET  ID_Local  = 2  where ID_partido = 126;
DELETE FROM Partido WHERE ID_partido = 126

-- TRG_BEFORE_INSERT_JUGADOR: Registra un intento de agregar un nuevo jugador, incluyendo quién lo hace y cuándo. Útil para auditorías y seguimiento de inserciones en la tabla Jugador
-- TRG_AFTER_UPDATE_JUGADOR: Registra cuando un jugador ha sido actualizado, proporcionando detalles sobre qué jugador fue afectado. Importante para rastrear cambios en los datos de los jugadores.
-- TRG_BEFORE_DELETE_JUGADOR: Registra cuando un jugador ha sido eliminado, proporcionando detalles del jugador que fue eliminado. Esto es de suma utilidad, ya que de jugador dependen muchas otras tablas.
-- TRG_BEFORE_UPDATE_PARTIDO: Registra cuando se hace un update de la tabla partido, proporcionando detalles del partido afectado, es de suma importancia para evitar fraudes.
-- TRG_BEFORE_DELETE_PARTIDO: Actúa antes de la eliminación de un partido, registrando información crítica para entender qué registros están siendo eliminados y por quién-.
-- TRG_AFTER_INSERT_PARTIDO: Registra la inserción de un nuevo partido, proporcionando una traza de cuándo y quién agregó el registro.
-- Estos triggers ayudarán a mantener un registro detallado de las operaciones importantes en las tablas Jugador y Partido, lo que es esencial para la auditoría y el 
-- seguimiento de cambios en una base de datos. Asegúrate de reemplazar '[Usuario]' con la lógica o mecanismo