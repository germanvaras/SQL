DROP SCHEMA IF EXISTS prensa_uefa_champions_league;
CREATE SCHEMA prensa_uefa_champions_league;
use prensa_uefa_champions_league;
CREATE OR REPLACE VIEW prensa_uefa_champions_league.vw_InfoJugador AS
SELECT 
    j.ID_jugador, 
    j.Nombre, 
    j.Apellido, 
    j.Fecha_nacimiento, 
    j.Nacionalidad, 
    j.Posicion, 
    e.Nombre AS NombreEquipo, 
    et.Nombre AS NombreEntrenador, 
    et.Apellido AS ApellidoEntrenador
FROM 
    uefa_champions_league.Jugador j
    JOIN uefa_champions_league.Equipo e ON j.ID_equipo = e.ID_equipo
    JOIN uefa_champions_league.Entrenador et ON e.ID_entrenador = et.ID_entrenador;
CREATE OR REPLACE VIEW prensa_uefa_champions_league.vw_DetallesPartido AS
SELECT 
    p.ID_partido,
    e1.Nombre AS EquipoLocal,
    e2.Nombre AS EquipoVisitante,
    p.Fecha,
    (SELECT COUNT(*) FROM uefa_champions_league.Gol g WHERE g.ID_partido = p.ID_partido AND g.ID_jugador IN (SELECT ID_jugador FROM uefa_champions_league.Jugador WHERE ID_equipo = p.ID_local)) AS GolesLocal,
    (SELECT COUNT(*) FROM uefa_champions_league.Gol g WHERE g.ID_partido = p.ID_partido AND g.ID_jugador IN (SELECT ID_jugador FROM uefa_champions_league.Jugador WHERE ID_equipo = p.ID_visitante)) AS GolesVisitante,
    (SELECT COUNT(*) FROM uefa_champions_league.Tarjeta WHERE ID_partido = p.ID_partido AND ID_tipo_tarjeta = 1) AS TarjetasAmarillas,
    (SELECT COUNT(*) FROM uefa_champions_league.Tarjeta WHERE ID_partido = p.ID_partido AND ID_tipo_tarjeta = 2) AS TarjetasRojas,
    (SELECT COUNT(a.ID_asistencia) FROM uefa_champions_league.Asistencia a JOIN uefa_champions_league.Gol g ON a.ID_gol = g.ID_gol WHERE g.ID_partido = p.ID_partido) AS AsistenciasTotales
FROM 
    uefa_champions_league.Partido p
    JOIN uefa_champions_league.Equipo e1 ON p.ID_local = e1.ID_equipo
    JOIN uefa_champions_league.Equipo e2 ON p.ID_visitante = e2.ID_equipo;

CREATE OR REPLACE VIEW prensa_uefa_champions_league.vw_GoleadoresTorneo AS
SELECT 
    g.ID_jugador, 
    j.Nombre, 
    j.Apellido, 
    g.ID_torneo, 
    t.Temporada, 
    g.Goles_marcados
FROM 
    uefa_champions_league.Goleador g
    JOIN uefa_champions_league.Jugador j ON g.ID_jugador = j.ID_jugador
    JOIN uefa_champions_league.Torneo t ON g.ID_torneo = t.ID_torneo
ORDER BY g.Goles_marcados DESC;
CREATE OR REPLACE VIEW prensa_uefa_champions_league.vw_ClasificacionGrupos AS
SELECT 
    c.ID_Clasificacion, 
    c.Puntos, 
    c.Partidos_jugados, 
    c.Ganados, 
    c.Empatados, 
    c.Perdidos, 
    c.Goles_favor, 
    c.Goles_contra, 
    c.Diferencia_gol, 
    c.ID_grupo, 
    e.Nombre AS NombreEquipo, 
    t.Temporada
FROM 
    uefa_champions_league.ClasificacionGrupo c
    JOIN uefa_champions_league.Equipo e ON c.ID_equipo = e.ID_equipo
    JOIN uefa_champions_league.Torneo t ON c.ID_torneo = t.ID_torneo;
CREATE OR REPLACE VIEW prensa_uefa_champions_league.vw_RendimientoEquipoTorneo AS
SELECT 
    e.ID_equipo,
    e.Nombre AS NombreEquipo,
    t.ID_torneo,
    t.Temporada,
    COUNT(p.ID_partido) AS PartidosJugados,
    SUM(CASE 
            WHEN g.ID_equipo = p.ID_local AND g.GolesLocal > g.GolesVisitante THEN 1 
            WHEN g.ID_equipo = p.ID_visitante AND g.GolesVisitante > g.GolesLocal THEN 1 
            ELSE 0 
        END) AS PartidosGanados,
    SUM(CASE 
            WHEN g.GolesLocal = g.GolesVisitante THEN 1 
            ELSE 0 
        END) AS PartidosEmpatados,
    SUM(CASE 
            WHEN g.ID_equipo = p.ID_local AND g.GolesLocal < g.GolesVisitante THEN 1 
            WHEN g.ID_equipo = p.ID_visitante AND g.GolesVisitante < g.GolesLocal THEN 1 
            ELSE 0 
        END) AS PartidosPerdidos
FROM 
    uefa_champions_league.Equipo e
    JOIN uefa_champions_league.Partido p ON e.ID_equipo = p.ID_local OR e.ID_equipo = p.ID_visitante
    JOIN uefa_champions_league.Torneo t ON p.ID_torneo = t.ID_torneo
    JOIN (
        SELECT 
            p.ID_partido,
            p.ID_local AS ID_equipo,
            (SELECT COUNT(*) FROM uefa_champions_league.Gol WHERE ID_partido = p.ID_partido AND ID_jugador IN (SELECT ID_jugador FROM uefa_champions_league.Jugador WHERE ID_equipo = p.ID_local)) AS GolesLocal,
            (SELECT COUNT(*) FROM uefa_champions_league.Gol WHERE ID_partido = p.ID_partido AND ID_jugador IN (SELECT ID_jugador FROM uefa_champions_league.Jugador WHERE ID_equipo = p.ID_visitante)) AS GolesVisitante
        FROM uefa_champions_league.Partido p
    ) g ON g.ID_partido = p.ID_partido
GROUP BY e.ID_equipo, e.Nombre, t.ID_torneo, t.Temporada;



