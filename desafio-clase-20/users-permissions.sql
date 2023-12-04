
-- Creación de usuarios modificar los nombres y contraseña en caso de ser necesario
CREATE USER 'usuario_lectura'@'localhost' IDENTIFIED BY 'contraseña';
CREATE USER 'usuario_modificacion'@'localhost' IDENTIFIED BY 'contraseña';

-- Permisos para el usuario de solo lectura
GRANT SELECT ON uefa_champions_league.* TO 'usuario_lectura'@'localhost';

-- Permisos para el usuario con capacidad de lectura, inserción y modificación de datos
GRANT SELECT, INSERT, UPDATE ON uefa_champions_league.* TO 'usuario_modificacion'@'localhost';

-- Especificar que ninguno de los usuarios puede eliminar registros
REVOKE DELETE ON uefa_champions_league.* FROM 'usuario_lectura'@'localhost';
REVOKE DELETE ON uefa_champions_league.* FROM 'usuario_modificacion'@'localhost';

-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;
