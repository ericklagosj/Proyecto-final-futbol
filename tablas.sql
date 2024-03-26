-- Creación de tabla para la entidad DIVISIÓN
CREATE TABLE DIVISION (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50)
);

-- Creación de tabla para la entidad ESTADIO
CREATE TABLE ESTADIO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Ubicacion VARCHAR(255),
    Capacidad INT
);

-- Creación de tabla para la entidad EQUIPO
CREATE TABLE EQUIPO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Ciudad VARCHAR(100),
    Ano_Fundacion YEAR,
    Division_ID INT,
    Estadio_ID INT, 
    FOREIGN KEY (Division_ID) REFERENCES DIVISION(ID),
    FOREIGN KEY (Estadio_ID) REFERENCES ESTADIO(ID)  -- Clave foránea para la relación con ESTADIO
);

-- Creación de tabla para la entidad CATEGORÍA
CREATE TABLE CATEGORIA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50)
);

-- Creación de tabla para la entidad EQUIPO_CATEGORIA
CREATE TABLE EQUIPO_CATEGORIA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Equipo_ID INT,
    Categoria_ID INT,
    FOREIGN KEY (Equipo_ID) REFERENCES EQUIPO(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Categoria_ID) REFERENCES CATEGORIA(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para la entidad POSICION
CREATE TABLE POSICION (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE
);

-- Modificación de la tabla para la entidad JUGADOR
CREATE TABLE JUGADOR (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Fecha_Nacimiento DATE,
    Posicion_ID INT,
    Categoria_ID INT,
    Equipo_ID INT, 
    FOREIGN KEY (Posicion_ID) REFERENCES POSICION(ID),
    FOREIGN KEY (Categoria_ID) REFERENCES CATEGORIA(ID),
    FOREIGN KEY (Equipo_ID) REFERENCES EQUIPO(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de tabla para la entidad NOTICIA
CREATE TABLE NOTICIA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(255),
    Contenido TEXT,
    Fecha DATE
);

-- Creación de tabla para la entidad PARTIDO
CREATE TABLE PARTIDO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Resultado VARCHAR(20),
    Ubicacion VARCHAR(255),
    Fecha DATE,
    Equipo_Local_ID INT,
    Equipo_Visitante_ID INT,
    FOREIGN KEY (Equipo_Local_ID) REFERENCES EQUIPO(ID),
    FOREIGN KEY (Equipo_Visitante_ID) REFERENCES EQUIPO(ID)
);

-- Creación de tabla para la entidad CALENDARIO
CREATE TABLE CALENDARIO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Partido_ID INT,
    Hora_Partido TIME,
    Lugar VARCHAR(255),
    Fecha DATE,
    FOREIGN KEY (Partido_ID) REFERENCES PARTIDO(ID)
);

-- Creación de tabla para la entidad ÁRBITRO
CREATE TABLE ARBITRO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido_Paterno VARCHAR(50),
    Apellido_Materno VARCHAR(50),
    T_Amarillas INT,
    T_Rojas INT,
    Sancion VARCHAR(255),
    Partido_ID INT,  -- Nueva columna para la relación con PARTIDO
    Jugador_ID INT,  -- Nueva columna para la relación con JUGADOR
    FOREIGN KEY (Partido_ID) REFERENCES PARTIDO(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Jugador_ID) REFERENCES JUGADOR(ID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Creación de tabla para la entidad TRANSFERENCIA
CREATE TABLE TRANSFERENCIA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Transferencia DATE,
    ID_Jugador INT,
    Equipo_Origen INT,
    Equipo_Destino INT,
    FOREIGN KEY (ID_Jugador) REFERENCES JUGADOR(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Equipo_Origen) REFERENCES EQUIPO(ID),
    FOREIGN KEY (Equipo_Destino) REFERENCES EQUIPO(ID)
);

-- Creación de tabla para la entidad TORNEO_REGULAR
CREATE TABLE TORNEO_REGULAR (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    P_Jugados INT,
    P_Ganados INT,
    P_Perdidos INT,
    P_Empatados INT,
    Goles_Favor INT,
    Goles_Contra INT,
    Puntos INT,
    Posicion INT,
    Equipo_ID INT,
    FOREIGN KEY (Equipo_ID) REFERENCES EQUIPO(ID)
);

-- Creación de tabla para la entidad ESTADÍSTICA
CREATE TABLE ESTADISTICA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    P_Jugados INT,
    P_Ganados INT,
    P_Perdidos INT,
    P_Empatados INT,
    Tarjetas_Rojas INT,
    Tarjetas_Amarillas INT,
    Minutos_Jugados INT,
    Goles_Anotados INT,
    Asistencias INT,
    Jugador_ID INT,
    FOREIGN KEY (Jugador_ID) REFERENCES JUGADOR(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de tabla para la entidad CAMPEONATO
CREATE TABLE CAMPEONATO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Campeonato VARCHAR(100),
    Equipos_Participantes INT,
    Ano_Campeonato YEAR
);

-- Creación de tabla para la entidad EST_JUGADOR_C
CREATE TABLE EST_JUGADOR_C (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    P_Jugados INT,
    P_Ganados INT,
    P_Perdidos INT,
    P_Empatados INT,
    Tarjetas_Rojas INT,
    Tarjetas_Amarillas INT,
    Minutos_Jugados INT,
    Goles_Anotados INT,
    Asistencias INT,
    Jugador_ID INT,
    FOREIGN KEY (Jugador_ID) REFERENCES JUGADOR(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creación de tabla para la entidad EST_EQUIPO_C
CREATE TABLE EST_EQUIPO_C (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    P_Jugados INT,
    P_Ganados INT,
    P_Perdidos INT,
    P_Empatados INT,
    Goles_Favor INT,
    Goles_Contra INT,
    Puntos INT,
    Posicion INT
);

-- Relación entre CAMPEONATO_EST_JUGADOR_C y CAMPEONATO
CREATE TABLE CAMPEONATO_EST_JUGADOR_C (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Campeonato_ID INT,
    Est_Jugador_C_ID INT,
    FOREIGN KEY (Campeonato_ID) REFERENCES CAMPEONATO(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Est_Jugador_C_ID) REFERENCES EST_JUGADOR_C(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Relación entre CAMPEONATO_EST_EQUIPO_C y CAMPEONATO
CREATE TABLE CAMPEONATO_EST_EQUIPO_C (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Campeonato_ID INT,
    Est_Equipo_C_ID INT,
    FOREIGN KEY (Campeonato_ID) REFERENCES CAMPEONATO(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Est_Equipo_C_ID) REFERENCES EST_EQUIPO_C(ID) ON DELETE CASCADE ON UPDATE CASCADE
);





INSERT INTO DIVISION (nombre)
VALUES 
('Primera división'),
('Segunda división');

-- Equipos de primera división
INSERT INTO equipo (nombre, ciudad, Ano_Fundacion, division_id, estadio_id)
VALUES 
('Los Tilos', 'Los Tilos', 0, 1, 1),
('Selva Negra', 'Selva Negra', 0, 1, 2),
('Cantarrana', 'Cantarrana', 0, 1, 3),
('Santa Juana', 'Santa Juana', 0, 1, 4),
('Alianza', 'Alianza', 0, 1, 5),
('Quiriquina', 'Quiriquina', 0, 1, 6),
('El Quillay', 'El Quillay', 0, 1, 7),
('Renacer', 'Renacer', 0, 1, 8),
('Pueblo Seco', 'Pueblo Seco', 0, 1, 9),
('La Greda', 'La Greda', 0, 1, 10);

-- Equipos de segunda división
INSERT INTO equipo (nombre, ciudad, Ano_Fundacion, division_id, estadio_id)
VALUES 
('San Ignacio', 'San Ignacio', 0, 2, 11),
('Unión Barrio Alto', 'Unión Barrio Alto', 0, 2, 12),
('San Miguel', 'San Miguel', 0, 2, 13),
('El Lucero', 'El Lucero', 0, 2, 14),
('Simón Bolívar', 'Simón Bolívar', 0, 2, 15),
('Los Maitenes', 'Los Maitenes', 0, 2, 16),
('Las Quilas', 'Las Quilas', 0, 2, 17),
('Real Pueblo Seco', 'Real Pueblo Seco', 0, 2, 18);

-- Insertar datos en la tabla de categorías

INSERT INTO CATEGORIA (NOMBRE) 
VALUES
('juvenil'),
('adulta'),
('senior'),
('super senior'),
('honor');

-- Insertar datos en la tabla de estadios
INSERT INTO estadio (nombre, ubicacion, capacidad)  
VALUES 
('Estadio Municipal de Los Tilos', 'Los Tilos', 0),
('Estadio Municipal de Selva Negra', 'Selva Negra', 0),
('Estadio Municipal de Cantarrana', 'Cantarrana', 0),
('Estadio Municipal de Santa Juana', 'Santa Juana', 0),
('Estadio Municipal de Alianza', 'Alianza', 0),
('Estadio Municipal de Quiriquina', 'Quiriquina', 0),
('Estadio Municipal de El Quillay', 'El Quillay', 0),
('Estadio Municipal de Renacer', 'Renacer', 0),
('Estadio Municipal de Pueblo Seco', 'Pueblo Seco', 0),
('Estadio Municipal de La Greda', 'La Greda', 0),
('Estadio Municipal de San Ignacio', 'San Ignacio', 0),
('Estadio Municipal de Unión Barrio Alto', 'Unión Barrio Alto', 0),
('Estadio Municipal de San Miguel', 'San Miguel', 0),
('Estadio Municipal de El Lucero', 'El Lucero', 0),
('Estadio Municipal de Simón Bolívar', 'Simón Bolívar', 0),
('Estadio Municipal de Los Maitenes', 'Los Maitenes', 0),
('Estadio Municipal de Las Quilas', 'Las Quilas', 0),
('Estadio Municipal de Real Pueblo Seco', 'Real Pueblo Seco', 0);


ALTER TABLE JUGADOR
DROP COLUMN EST_JUGADOR_C_ID;

-- Insertar datos en la tabla de jugadores
INSERT INTO JUGADOR (Posicion, Nombre, Fecha_Nacimiento, Categoria_ID, Equipo_ID)
VALUES 
('Delantero', 'Rodrigo Goes', '2000-03-01', 1, 11),
('Defensa', 'Pedro De Paul', '2000-01-01', 1, 10),
('Portero', 'José Murillo', '1978-01-01', 1, 7),
('Medio', 'Luis Puyol', '2000-01-01', 1, 1),
('Delantero', 'Juan Vela', '2006-01-01', 1, 7),
('Defensa', 'Pedro Caceres', '2000-01-01', 1, 13),
('Portero', 'José Varas', '1995-01-01', 1, 3),
('Medio', 'Rodrigo Barbosa', '1999-01-01', 1, 1),
('Delantero', 'Juan Garrido', '1997-01-01', 1, 4),
('Defensa', 'Pedro Coler', '2001-01-01', 1, 14),
('Portero', 'Manuel Vargas', '2008-01-01', 1, 17),
('Medio', 'Rosamel Troncoso', '1975-01-01', 1, 16),
('Delantero', 'Pepe Pezzela', '1968-01-01', 1, 6),
('Defensa', 'Pablo Mbappe', '1988-01-01', 1, 2),
('Portero', 'Matias Hazard', '1990-01-01', 1, 9),
('Medio', 'Erick Puentes', '2005-01-01', 1, 15),
('Delantero', 'Carlos Junior', '2000-01-01', 1, 4),
('Defensa', 'Claudio Sanchez', '1999-01-01', 1, 3),
('Portero', 'Moises Ronaldo', '2003-01-01', 1, 14),
('Medio', 'Luis Cassano', '2006-01-01', 1, 10);


-- Insertar datos en la tabla de noticias
INSERT INTO NOTICIA (Titulo, Contenido, Fecha)
VALUES 
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Rodrigo Goes', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Pedro De Paul', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador José Murillo', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Luis Puyol', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Juan Vela', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Pedro Caceres', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador José Varas', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Rodrigo Barbosa', '2021-01-01'),
('Nuevo fichaje', 'El equipo Los Tilos ha fichado al jugador Juan Garrido', '2021-01-01');

-- Insertar datos en la tabla de partidos
INSERT INTO PARTIDO (Resultado, Ubicacion, Fecha, Equipo_Local_ID, Equipo_Visitante_ID)
VALUES 
('2-1', 'Estadio Municipal de Los Tilos', '2021-01-01', 1, 2),
('1-0', 'Estadio Municipal de Los Tilos', '2021-01-01', 3, 4),
('3-2', 'Estadio Municipal de Los Tilos', '2021-01-01', 5, 6),
('2-1', 'Estadio Municipal de Los Tilos', '2021-01-01', 7, 8),
('1-0', 'Estadio Municipal de Los Tilos', '2021-01-01', 9, 10),
('2-1', 'Estadio Municipal de Los Tilos', '2021-01-01', 11, 12),
('1-0', 'Estadio Municipal de Los Tilos', '2021-01-01', 13, 14),
('3-2', 'Estadio Municipal de Los Tilos', '2021-01-01', 15, 16),
('2-1', 'Estadio Municipal de Los Tilos', '2021-01-01', 17, 18),
('1-0', 'Estadio Municipal de Los Tilos', '2021-01-01', 11, 2);


-- Insertar datos en la tabla de calendario
INSERT INTO CALENDARIO (Partido_ID, Hora_Partido, Lugar, Fecha)
VALUES 
(11, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(12, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(13, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(14, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(15, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(16, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(17, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(18, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(19, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01'),
(20, '15:00:00', 'Estadio Municipal de Los Tilos', '2021-01-01');



ALTER TABLE jugadores
ADD COLUMN ID_DIVISION INT;
ALTER TABLE jugadores
ADD FOREIGN KEY (ID_DIVISION) REFERENCES divisiones(id);

ALTER TABLE categoria
DROP FOREIGN KEY categoria_ibfk_1;
ALTER TABLE categoria
DROP COLUMN ID_DIVISION;

USE asociacion_de_futbol;
DROP TABLE partido;