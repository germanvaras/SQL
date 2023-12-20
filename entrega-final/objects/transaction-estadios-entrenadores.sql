use uefa_champions_league
DELIMITER //
CREATE PROCEDURE CheckAndAct()
BEGIN
    -- Variable para contar los registros
    DECLARE cnt INT;
    SELECT COUNT(*) INTO cnt FROM Entrenador;
    IF cnt > 0 THEN
        -- Si hay registros, elimina algunos entrenadores como ejemplo
        DELETE FROM Entrenador WHERE ID_entrenador IN (1, 2, 3);
    ELSE
        -- Si no hay registros, inserta nuevos entrenadores
        INSERT INTO Entrenador (Nombre, Apellido, Fecha_nacimiento, Nacionalidad) VALUES
        ('Diego', 'Simeone', '1970-04-28', 'Argentina'),
        ('Jürgen', 'Klopp', '1967-06-16', 'Alemania'),
        ('Gian Piero', 'Gasperini', '1958-01-26', 'Italia');
    END IF;
END //
DELIMITER ;
-- Inicia la transacción entrenadores
START TRANSACTION;
-- Llama al procedimiento almacenado que ejecuta la lógica condicional
CALL CheckAndAct();
-- Deja comentado el ROLLBACK para poder revertir los cambios si es necesario
-- ROLLBACK;
-- Confirma los cambios si todo está correcto
COMMIT;
-- No olvides borrar el procedimiento almacenado si ya no es necesario
-- DROP PROCEDURE IF EXISTS CheckAndAct;

-- -- Inicia la transacción de estadios
START TRANSACTION;
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 1', 'Ciudad 1', 'País 1', 10000);
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 2', 'Ciudad 2', 'País 2', 20000);
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 3', 'Ciudad 3', 'País 3', 30000);
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 4', 'Ciudad 4', 'País 4', 40000);
SAVEPOINT SavepointRegistro4; -- Crea un savepoint después del registro #4
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 5', 'Ciudad 5', 'País 5', 50000);
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 6', 'Ciudad 6', 'País 6', 60000);
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 7', 'Ciudad 7', 'País 7', 70000);
INSERT INTO Estadio (Nombre, Ciudad, Pais, Capacidad) VALUES ('Estadio 8', 'Ciudad 8', 'País 8', 80000);
SAVEPOINT SavepointRegistro8; -- Crea un savepoint después del registro #8
-- Sentencia para eliminar los registros hasta el savepoint (comentada)
-- ROLLBACK TO SavepointRegistro4; -- Deshace los cambios hasta el registro #4 (comentado para no ejecutarse)
COMMIT; -- Confirma todos los cambios
