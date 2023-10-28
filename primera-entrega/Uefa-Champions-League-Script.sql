DROP SCHEMA IF EXISTS uefa_champions_league;
CREATE SCHEMA uefa_champions_league;
-- Base de datos para la UEFA Champions League
USE uefa_champions_league;
CREATE TABLE IF NOT EXISTS Entrenador (
    ID_entrenador INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador del Entrenador',
    Apellido VARCHAR(255) COMMENT 'Apellido del entrenador',
    Nombre VARCHAR(255) COMMENT 'Nombre del entrenador',
    Fecha_nacimiento DATE COMMENT 'Fecha de nacimiento del entrenador',
    Nacionalidad VARCHAR(255) COMMENT 'Pais de origen del entrenador'
);
CREATE TABLE IF NOT EXISTS Estadio (
    ID_estadio INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador del Estadio',
    Nombre VARCHAR(255) COMMENT 'Nombre del Estadio',
    Ciudad VARCHAR(255) COMMENT 'Ciudad donde se ubica el estadio',
    Pais VARCHAR(255) COMMENT 'Pais donde se ubica el estadio',
    Capacidad INT COMMENT 'Capacidad total del estadio'
);
CREATE TABLE IF NOT EXISTS Equipo (
    ID_equipo INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador del Equipo',
    Nombre VARCHAR(255) COMMENT 'Nombre del Equipo',
    Ciudad VARCHAR(255) COMMENT 'Ciudad de origen del equipo',
    Pais VARCHAR(255) COMMENT 'Pais de origen del Equipo',
    ID_estadio INT,
    ID_entrenador INT,
    FOREIGN KEY (ID_estadio) REFERENCES Estadio(ID_estadio),
    FOREIGN KEY (ID_entrenador) REFERENCES Entrenador(ID_entrenador)
);
CREATE TABLE IF NOT EXISTS Jugador (
    ID_jugador INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador del Jugador',
    Apellido VARCHAR(255) COMMENT 'Apellido del jugador',
    Nombre VARCHAR(255) COMMENT 'Nombre del jugador',
    Fecha_nacimiento DATE COMMENT 'Fecha de nacimiento del jugador',
    Nacionalidad VARCHAR(255) COMMENT 'Pais de origen del jugador',
    Posición VARCHAR(255) COMMENT 'Posición que ocupa en el campo de juego',
    ID_equipo INT,
    FOREIGN KEY (ID_equipo) REFERENCES Equipo(ID_equipo)
);
CREATE TABLE IF NOT EXISTS Arbitro (
    ID_arbitro INT AUTO_INCREMENT PRIMARY KEY,
    Apellido VARCHAR(255) COMMENT 'Apellido del Arbitro',
    Nombre VARCHAR(255) COMMENT 'Nombre del Arbitro',
    Nacionalidad VARCHAR(255) COMMENT 'País de origen del Arbitro'
);
CREATE TABLE IF NOT EXISTS FaseEliminatoria (
    ID_fase INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) COMMENT 'Nombre de la fase eliminatoria (e.g. cuartos)'
);
CREATE TABLE IF NOT EXISTS Grupo (
    ID_grupo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre CHAR(1) COMMENT 'Nombre de grupo'
);
CREATE TABLE IF NOT EXISTS Torneo (
    ID_torneo INT AUTO_INCREMENT PRIMARY KEY,
    Temporada INT COMMENT 'Temporada del campeonato (e.g. 2023)',
    Nombre VARCHAR(255) COMMENT 'Nombre del campeonato (e.g Uefa Champions League)'
);
CREATE TABLE IF NOT EXISTS HistoricoCampeones (
    ID_campeon_historico INT AUTO_INCREMENT PRIMARY KEY,
    ID_torneo INT COMMENT 'Identificador del torneo',
    ID_equipo INT COMMENT 'Identificador del Equipo campeón',
    FOREIGN KEY (ID_torneo) REFERENCES Torneo(ID_torneo),
    FOREIGN KEY (ID_equipo) REFERENCES Equipo(ID_equipo)
);
CREATE TABLE IF NOT EXISTS Partido (
    ID_partido INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE COMMENT 'Fecha del partido',
    Hora TIME COMMENT 'Hora de juego',
    ID_local INT COMMENT 'Identificador equipo local',
    ID_visitante INT COMMENT 'Identificador equipo visitante',
    ID_arbitro INT COMMENT 'Identificador arbitro responsable',
    ID_estadio INT COMMENT 'Identificador estadio',
    ID_faseEliminatoria INT COMMENT 'Identificador de fase eliminatoria',
    ID_grupo INT COMMENT 'Identificador de fase grupo',
    ID_torneo INT COMMENT 'Identificador del Equipo',
    FOREIGN KEY (ID_local) REFERENCES Equipo(ID_equipo),
    FOREIGN KEY (ID_visitante) REFERENCES Equipo(ID_equipo),
    FOREIGN KEY (ID_arbitro) REFERENCES Arbitro(ID_arbitro),
    FOREIGN KEY (ID_estadio) REFERENCES Estadio(ID_estadio),
    FOREIGN KEY (ID_faseEliminatoria) REFERENCES FaseEliminatoria(ID_fase),
    FOREIGN KEY (ID_grupo) REFERENCES Grupo(ID_grupo),
    FOREIGN KEY (ID_torneo) REFERENCES Torneo(ID_torneo)
);
CREATE TABLE IF NOT EXISTS Gol (
    ID_gol INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador del Gol',
    Minuto INT COMMENT 'Nombre del equipo',
    ID_jugador INT COMMENT 'Identificador del jugador que anotó',
    ID_partido INT COMMENT 'Identificador del partido',
    Goles_marcados INT COMMENT 'Acumulador de goles del jugador',
    FOREIGN KEY (ID_jugador) REFERENCES Jugador(ID_jugador),
    FOREIGN KEY (ID_partido) REFERENCES Partido(ID_partido)
);
CREATE TABLE IF NOT EXISTS Asistencia (
    ID_asistencia INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador de la Asistencia',
    ID_jugador INT COMMENT 'Identificador del jugador que anotó',
    ID_gol INT COMMENT 'Identificador del Gol',
    Asistencias_marcadas INT COMMENT 'Acumulador de goles del jugador',
    FOREIGN KEY (ID_jugador) REFERENCES Jugador(ID_jugador),
    FOREIGN KEY (ID_gol) REFERENCES Gol(ID_gol)
);
CREATE TABLE IF NOT EXISTS TipoTarjeta (
    ID_tipo_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(255) COMMENT 'Tipo de tarjeta(amarilla/roja)'
);
CREATE TABLE IF NOT EXISTS Tarjeta (
    ID_tarjeta INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador de la Tarjeta',
    Minuto INT COMMENT 'Minuto en el que se anotó el gol',
    ID_tipo_tarjeta INT COMMENT 'Nombre del equipo',
    ID_partido INT COMMENT 'Identificador del partido',
    ID_jugador INT COMMENT 'Identificador del jugador que anotó',
    FOREIGN KEY (ID_tipo_tarjeta) REFERENCES TipoTarjeta(ID_tipo_tarjeta),
    FOREIGN KEY (ID_partido) REFERENCES Partido(ID_partido),
    FOREIGN KEY (ID_jugador) REFERENCES Jugador(ID_jugador)
);
CREATE TABLE IF NOT EXISTS Goleador (
    ID_goleador INT AUTO_INCREMENT PRIMARY KEY,
    ID_jugador INT COMMENT 'Identificador del jugador que anotó',
    ID_torneo INT COMMENT 'Identificador del torneo',
    Goles_marcados INT COMMENT 'Acumulador de goles del jugador',
    FOREIGN KEY (ID_jugador) REFERENCES Jugador(ID_jugador),
    FOREIGN KEY (ID_torneo) REFERENCES Torneo(ID_torneo)
);
CREATE TABLE IF NOT EXISTS ClasificacionGrupo (
    ID_Clasificacion INT AUTO_INCREMENT PRIMARY KEY,
    Puntos INT COMMENT 'Puntos totales en el Partido',
    Partidos_jugados INT COMMENT 'Cantidad de partidos jugados',
    Ganados INT COMMENT 'Cantidad de partidos ganados',
    Empatados INT COMMENT 'Cantidad de partidos empatados',
    Perdidos INT COMMENT 'Cantidad de partidos perdidos',
    Goles_favor INT COMMENT 'Cantidad de goles anotados',
    Goles_contra INT COMMENT 'Cantidad de goles recibidos',
    Diferencia_gol INT COMMENT 'Diferencia entre goles anotados y recibidos',
    ID_grupo INT COMMENT 'Identificador del grupo',
    ID_equipo INT COMMENT 'Identificador del Equipo',
	ID_torneo INT COMMENT 'Identificador del torneo',
    FOREIGN KEY (ID_grupo) REFERENCES Grupo(ID_grupo),
    FOREIGN KEY (ID_equipo) REFERENCES Equipo(ID_equipo),
	FOREIGN KEY (ID_torneo) REFERENCES Torneo(ID_torneo)
);

