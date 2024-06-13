-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-05-2024 a las 03:58:20
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `asociacióndeportiva`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitro`
--

CREATE TABLE `arbitro` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Apellido_Paterno` varchar(50) DEFAULT NULL,
  `Apellido_Materno` varchar(50) DEFAULT NULL,
  `T_Amarillas` int(11) DEFAULT NULL,
  `T_Rojas` int(11) DEFAULT NULL,
  `Sancion` varchar(255) DEFAULT NULL,
  `Partido_ID` int(11) DEFAULT NULL,
  `Jugador_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencia`
--

CREATE TABLE `asistencia` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_jugador` int(11) DEFAULT NULL,
  `jornada` int(11) DEFAULT NULL,
  `asistencia` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asistencia`
--

INSERT INTO `asistencia` (`id`, `id_jugador`, `jornada`, `asistencia`) VALUES
(7, 2, 1, 1),
(8, 3, 1, 0),
(9, 2, 2, 0),
(10, 3, 2, 1),
(11, 2, 3, 1),
(12, 3, 3, 0),
(13, 2, 4, 1),
(14, 3, 4, 1),
(15, 2, 5, 1),
(16, 3, 5, 1),
(17, 2, 6, 0),
(18, 3, 6, 1),
(34, 51, 7, 1),
(35, 52, 8, 1),
(36, 54, 10, 1),
(37, 55, 11, 1),
(38, 57, 13, 1),
(39, 58, 14, 1),
(40, 51, 15, 1),
(41, 52, 16, 0),
(42, 54, 17, 1),
(43, 55, 18, 1),
(44, 57, 18, 1),
(45, 58, 18, 1),
(46, 51, 17, 1),
(47, 52, 18, 1),
(48, 54, 1, 1),
(49, 55, 1, 1),
(50, 57, 2, 1),
(51, 58, 4, 1),
(52, 51, 3, 1),
(53, 52, 1, 1),
(54, 54, 4, 1),
(55, 55, 5, 1),
(56, 57, 6, 1),
(57, 58, 4, 1),
(58, 51, 7, 1),
(59, 52, 8, 1),
(60, 54, 1, 1),
(61, 55, 3, 1),
(62, 57, 8, 1),
(63, 58, 9, 1),
(64, 2, 12, 14),
(65, 3, 12, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calendario`
--

CREATE TABLE `calendario` (
  `ID` int(11) NOT NULL,
  `Partido_ID` int(11) DEFAULT NULL,
  `Hora_Partido` time DEFAULT NULL,
  `Lugar` varchar(255) DEFAULT NULL,
  `Fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `campeonato`
--

CREATE TABLE `campeonato` (
  `ID` int(11) NOT NULL,
  `Nombre_Campeonato` varchar(100) DEFAULT NULL,
  `Equipos_Participantes` int(11) DEFAULT NULL,
  `Ano_Campeonato` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `campeonato_est_equipo_c`
--

CREATE TABLE `campeonato_est_equipo_c` (
  `ID` int(11) NOT NULL,
  `Campeonato_ID` int(11) DEFAULT NULL,
  `Est_Equipo_C_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `campeonato_est_jugador_c`
--

CREATE TABLE `campeonato_est_jugador_c` (
  `ID` int(11) NOT NULL,
  `Campeonato_ID` int(11) DEFAULT NULL,
  `Est_Jugador_C_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`ID`, `Nombre`) VALUES
(1, 'juvenil'),
(2, 'adulta'),
(3, 'senior'),
(4, 'super senior'),
(5, 'honor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `division`
--

CREATE TABLE `division` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `division`
--

INSERT INTO `division` (`ID`, `Nombre`) VALUES
(1, 'Primera división'),
(2, 'Segunda división');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo`
--

CREATE TABLE `equipo` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `Ciudad` varchar(100) DEFAULT NULL,
  `Ano_Fundacion` year(4) DEFAULT NULL,
  `Division_ID` int(11) DEFAULT NULL,
  `Estadio_ID` int(11) DEFAULT NULL,
  `Categoria_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipo`
--

INSERT INTO `equipo` (`ID`, `Nombre`, `Ciudad`, `Ano_Fundacion`, `Division_ID`, `Estadio_ID`, `Categoria_ID`) VALUES
(1, 'Los Tilos', 'Los Tilos', '0000', 1, 1, 1),
(2, 'Selva Negra', 'Selva Negra', '0000', 1, 2, 1),
(3, 'Cantarrana', 'Cantarrana', '0000', 1, 3, 1),
(4, 'Santa Juana', 'Santa Juana', '0000', 1, 4, 1),
(5, 'Alianza', 'Alianza', '0000', 1, 5, 1),
(6, 'Quiriquina', 'Quiriquina', '0000', 1, 6, 1),
(7, 'El Quillay', 'El Quillay', '0000', 1, 7, 1),
(8, 'Renacer', 'Renacer', '0000', 1, 8, 1),
(9, 'Pueblo Seco', 'Pueblo Seco', '0000', 1, 9, 1),
(10, 'La Greda', 'La Greda', '0000', 1, 10, 1),
(11, 'San Ignacio', 'San Ignacio', '0000', 2, 11, 2),
(12, 'Unión Barrio Alto', 'Unión Barrio Alto', '0000', 2, 12, 2),
(13, 'San Miguel', 'San Miguel', '0000', 2, 13, 2),
(14, 'El Lucero', 'El Lucero', '0000', 2, 14, 2),
(15, 'Simón Bolívar', 'Simón Bolívar', '0000', 2, 15, 2),
(16, 'Los Maitenes', 'Los Maitenes', '0000', 2, 16, 2),
(17, 'Las Quilas', 'Las Quilas', '0000', 2, 17, 2),
(18, 'Real Pueblo Seco', 'Real Pueblo Seco', '0000', 2, 18, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo_categoria`
--

CREATE TABLE `equipo_categoria` (
  `ID` int(11) NOT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Categoria_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadio`
--

CREATE TABLE `estadio` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `Ubicacion` varchar(255) DEFAULT NULL,
  `Capacidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estadio`
--

INSERT INTO `estadio` (`ID`, `Nombre`, `Ubicacion`, `Capacidad`) VALUES
(1, 'Estadio Municipal de Los Tilos', 'Los Tilos', 10000),
(2, 'Estadio Municipal de Selva Negra', 'Selva Negra', 15000),
(3, 'Estadio Municipal de Cantarrana', 'Cantarrana', 12000),
(4, 'Estadio Municipal de Santa Juana', 'Santa Juana', 11000),
(5, 'Estadio Municipal de Alianza', 'Alianza', 13000),
(6, 'Estadio Municipal de Quiriquina', 'Quiriquina', 14000),
(7, 'Estadio Municipal de El Quillay', 'El Quillay', 16000),
(8, 'Estadio Municipal de Renacer', 'Renacer', 9000),
(9, 'Estadio Municipal de Pueblo Seco', 'Pueblo Seco', 17000),
(10, 'Estadio Municipal de La Greda', 'La Greda', 8000),
(11, 'Estadio Municipal de San Ignacio', 'San Ignacio', 18000),
(12, 'Estadio Municipal de Unión Barrio Alto', 'Unión Barrio Alto', 11000),
(13, 'Estadio Municipal de San Miguel', 'San Miguel', 12000),
(14, 'Estadio Municipal de El Lucero', 'El Lucero', 14000),
(15, 'Estadio Municipal de Simón Bolívar', 'Simón Bolívar', 13000),
(16, 'Estadio Municipal de Los Maitenes', 'Los Maitenes', 15000),
(17, 'Estadio Municipal de Las Quilas', 'Las Quilas', 16000),
(18, 'Estadio Municipal de Real Pueblo Seco', 'Real Pueblo Seco', 17000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadistica`
--

CREATE TABLE `estadistica` (
  `ID` int(11) NOT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `Tarjetas_Rojas` int(11) DEFAULT NULL,
  `Tarjetas_Amarillas` int(11) DEFAULT NULL,
  `Minutos_Jugados` int(11) DEFAULT NULL,
  `Goles_Anotados` int(11) DEFAULT NULL,
  `Asistencias` int(11) DEFAULT NULL,
  `Jugador_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `est_equipo_c`
--

CREATE TABLE `est_equipo_c` (
  `ID` int(11) NOT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `Posicion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `est_jugador_c`
--

CREATE TABLE `est_jugador_c` (
  `ID` int(11) NOT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `Tarjetas_Rojas` int(11) DEFAULT NULL,
  `Tarjetas_Amarillas` int(11) DEFAULT NULL,
  `Minutos_Jugados` int(11) DEFAULT NULL,
  `Goles_Anotados` int(11) DEFAULT NULL,
  `Asistencias` int(11) DEFAULT NULL,
  `Jugador_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `est_jugador_c`
--

INSERT INTO `est_jugador_c` (`ID`, `P_Jugados`, `P_Ganados`, `P_Perdidos`, `P_Empatados`, `Tarjetas_Rojas`, `Tarjetas_Amarillas`, `Minutos_Jugados`, `Goles_Anotados`, `Asistencias`, `Jugador_ID`) VALUES
(1, 3, 2, 0, 1, 7, 17, 120, 30, 0, 2),
(2, 0, 0, 0, 0, 0, 1, 0, 5, 0, 3),
(3, 0, 0, 0, 0, 7, 27, 0, 1, 0, 4),
(4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5),
(5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6),
(6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7),
(7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8),
(8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9),
(9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51),
(10, 0, 0, 0, 0, 4, 4, 0, 5, 0, 52);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `goles_jornada`
--

CREATE TABLE `goles_jornada` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `ID_jornada` int(11) DEFAULT NULL,
  `ID_jugador` int(11) DEFAULT NULL,
  `goles` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `goles_jornada`
--

INSERT INTO `goles_jornada` (`ID`, `ID_jornada`, `ID_jugador`, `goles`) VALUES
(1, 1, 4, 1),
(3, 1, 57, 1),
(4, 1, 58, 0),
(5, 1, 60, 2),
(10, 1, 65, 0),
(11, 1, 51, 2),
(12, 1, 52, 1),
(22, 1, 51, 0),
(24, 1, 54, 0),
(25, 1, 55, 0),
(26, 1, 57, 0),
(27, 1, 58, 0),
(28, 1, 59, 0),
(29, 1, 60, 0),
(30, 1, 61, 0),
(31, 1, 62, 0),
(32, 1, 63, 0),
(33, 1, 64, 0),
(34, 1, 65, 0),
(35, 1, 66, 0),
(36, 1, 4, 2),
(37, 1, 8, 3),
(38, 1, 57, 0),
(39, 1, 58, 1),
(40, 1, 60, 1),
(41, 1, 61, 0),
(42, 1, 62, 0),
(43, 1, 63, 0),
(44, 1, 64, 0),
(45, 1, 65, 0),
(46, 1, 77, 0),
(47, 1, 95, 0),
(48, 1, 113, 0),
(49, 1, 51, 1),
(50, 1, 52, 1),
(51, 1, 59, 3),
(52, 1, 78, 0),
(53, 1, 96, 0),
(54, 1, 114, 0),
(55, 1, 4, 0),
(56, 1, 8, 0),
(57, 1, 57, 0),
(58, 1, 58, 0),
(59, 1, 60, 0),
(60, 1, 61, 0),
(61, 1, 62, 0),
(62, 1, 63, 0),
(63, 1, 64, 5),
(64, 1, 65, 0),
(65, 1, 77, 0),
(66, 1, 95, 0),
(67, 1, 113, 0),
(68, 1, 51, 0),
(69, 1, 52, 0),
(70, 1, 59, 0),
(71, 1, 78, 0),
(72, 1, 96, 0),
(73, 1, 114, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornada`
--

CREATE TABLE `jornada` (
  `ID` int(11) NOT NULL,
  `Nombre` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `jornada`
--

INSERT INTO `jornada` (`ID`, `Nombre`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugador`
--

CREATE TABLE `jugador` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `Fecha_Nacimiento` date DEFAULT NULL,
  `Posicion_ID` int(11) DEFAULT NULL,
  `Categoria_ID` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Apellido_Paterno` varchar(50) DEFAULT NULL,
  `Apellido_Materno` varchar(50) DEFAULT NULL,
  `rut` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `jugador`
--

INSERT INTO `jugador` (`ID`, `Nombre`, `Fecha_Nacimiento`, `Posicion_ID`, `Categoria_ID`, `Equipo_ID`, `Apellido_Paterno`, `Apellido_Materno`, `rut`) VALUES
(2, 'Pedro', '2000-01-01', 1, 1, 10, ' De Paul', 'Pascual', '21.454.151-7'),
(3, 'José', '1978-01-01', 1, 1, 7, 'Murillo', 'Raphina', '20.454.151-7'),
(4, 'Luis', '2000-01-01', 2, 4, 1, 'Puyol', 'Salvo', '21.454.151-6'),
(5, 'Juan', '2006-01-01', 2, 1, 7, 'Vela', 'Veloso', '16.845.948-7'),
(6, 'Pedro ', '2000-01-01', 2, 1, 13, 'Caceres', 'Mandril', '19.845.948-9'),
(7, 'José ', '1995-01-01', 2, 1, 3, 'Varas', 'Roger', '20.154.957-7'),
(8, 'Rodrigo', '1999-01-01', 2, 1, 1, 'Barbosa', 'Roque', '21.155-415-1'),
(9, 'Juan', '1997-01-01', 2, 1, 4, 'Garrido', 'Garrido', '17-897-256-k'),
(51, 'Maximo', '1808-03-08', 1, 1, 2, 'carles', 'dukovski', '5.235.789-9'),
(52, 'dtyutyutdu', '1808-03-08', 1, 1, 2, 'carles', 'dukovski', '5.235.789-8'),
(54, 'roger', '1990-03-03', 2, 1, 3, 'mujica', 'alvareez', '20.689.489-2'),
(55, 'Patricio Hernán', '1990-03-06', 3, 1, 12, 'Chavéz ', 'Benavente', '11.958.762-k'),
(57, 'luis', '2011-01-28', NULL, 1, 1, 'jara', 'jaramillo', '15.506.150-8'),
(58, 'Andres', '2013-01-24', NULL, 1, 1, 'Ferrer', 'Sandoval', '22.548.789-7'),
(59, 'Emilio', '2002-01-25', NULL, 2, 2, 'Escobar', '', '25.245.250-0'),
(60, 'gaspar', '2010-02-25', NULL, 1, 1, 'marquez', 'henriquez', '20.458.164-1'),
(61, 'Rodrigo', '1983-01-13', NULL, 3, 1, 'Echeverria', 'Carrasco', '15.124.153-7'),
(62, 'Matias', '1982-07-17', NULL, 3, 1, 'Cancino', 'Cofre', '16.489.156-1'),
(63, 'Jose', '1974-02-17', NULL, 4, 1, 'Facundo', 'Kaf', '11.256.155-k'),
(64, 'Javier|', '1977-02-27', NULL, 5, 1, 'Ramirez', 'Roy', '10.518.151-1'),
(65, 'gabriel', '2024-03-22', NULL, 1, 1, 'Torres', 'alvareez', '200.151.154-'),
(66, 'diego', '2012-06-02', NULL, 1, 5, 'Torres', 'Benavente', '20.111.440-6'),
(77, 'Pedro José', '1999-05-12', 1, 1, 1, 'González', 'Sánchez', '11.243.535-9'),
(78, 'Juan Carlos', '2001-08-25', 2, 1, 2, 'Hernández', 'López', '22.456.789-0'),
(79, 'Diego Andrés', '1998-03-17', 3, 2, 3, 'Martínez', 'Pérez', '33.987.654-1'),
(80, 'Carlos Luis', '2000-11-08', 1, 2, 4, 'Gómez', 'Rodríguez', '44.654.987-2'),
(81, 'José Luis', '1997-07-20', 2, 1, 5, 'Pérez', 'González', '55.789.654-3'),
(82, 'Juan Andrés', '2002-02-14', 3, 2, 6, 'López', 'Martínez', '66.321.987-4'),
(83, 'Luis Miguel', '1996-09-30', 1, 1, 7, 'González', 'Hernández', '77.456.789-5'),
(84, 'Pedro Pablo', '2003-04-05', 2, 2, 8, 'Rodríguez', 'Sánchez', '88.789.654-6'),
(85, 'Andrés José', '1995-12-18', 3, 1, 9, 'Martínez', 'Gómez', '99.987.654-7'),
(86, 'Miguel Juan', '2004-01-21', 1, 1, 10, 'Sánchez', 'López', '10.321.987-8'),
(87, 'María Alejandra', '1998-06-02', 2, 3, 11, 'Hernández', 'Gómez', '12.456.789-0'),
(88, 'Ana María', '2000-12-15', 3, 3, 12, 'López', 'Rodríguez', '13.987.654-1'),
(89, 'José Luis', '1997-07-20', 2, 1, 13, 'Pérez', 'González', '14.654.321-2'),
(90, 'Juan Pablo', '2002-10-10', 1, 4, 14, 'González', 'Martínez', '15.789.654-3'),
(91, 'María José', '1996-11-30', 3, 4, 15, 'Gómez', 'Hernández', '16.654.321-4'),
(92, 'Pedro Luis', '2003-09-25', 2, 5, 16, 'Martínez', 'Sánchez', '17.987.654-5'),
(93, 'Luis Andrés', '1995-04-14', 1, 5, 17, 'Rodríguez', 'López', '18.654.321-6'),
(94, 'Ana María', '1999-03-20', 3, 3, 18, 'Hernández', 'Gómez', '19.987.654-7'),
(95, 'Pablo Andrés', '2005-08-10', 2, 2, 1, 'López', 'Pérez', '20.654.321-8'),
(96, 'Carlos Eduardo', '2001-01-15', 1, 4, 2, 'González', 'Martínez', '21.987.654-0'),
(97, 'María Alejandra', '1998-06-02', 2, 4, 3, 'Gómez', 'Hernández', '22.654.321-1'),
(98, 'Juan Pablo', '2002-10-10', 3, 5, 4, 'Hernández', 'Rodríguez', '23.987.654-2'),
(99, 'Ana María', '1996-11-30', 1, 5, 5, 'Martínez', 'Sánchez', '24.654.321-3'),
(100, 'Pedro Luis', '2003-09-25', 2, 3, 6, 'Sánchez', 'López', '25.987.654-4'),
(101, 'Luis Andrés', '1995-04-14', 3, 3, 7, 'López', 'González', '26.654.321-5'),
(102, 'Ana María', '1999-03-20', 1, 1, 8, 'Gómez', 'Martínez', '27.987.654-6'),
(103, 'Pablo Andrés', '2005-08-10', 2, 1, 9, 'Martínez', 'Hernández', '28.654.321-7'),
(104, 'Carlos Eduardo', '2001-01-15', 3, 2, 10, 'Hernández', 'López', '29.987.654-8'),
(105, 'María Alejandra', '1998-06-02', 1, 2, 11, 'López', 'Gómez', '30.654.321-9'),
(106, 'Juan Pablo', '2002-10-10', 2, 3, 12, 'Gómez', 'Martínez', '31.987.654-0'),
(107, 'Ana María', '1996-11-30', 3, 3, 13, 'Martínez', 'Hernández', '32.654.321-1'),
(108, 'Pedro Luis', '2003-09-25', 1, 4, 14, 'Hernández', 'López', '33.987.654-2'),
(109, 'Luis Andrés', '1995-04-14', 2, 4, 15, 'López', 'González', '34.654.321-3'),
(110, 'Ana María', '1999-03-20', 3, 5, 16, 'González', 'Martínez', '35.987.654-4'),
(111, 'Pablo Andrés', '2005-08-10', 1, 5, 17, 'Martínez', 'Hernández', '36.654.321-5'),
(112, 'Carlos Eduardo', '2001-01-15', 2, 3, 18, 'Hernández', 'López', '37.987.654-6'),
(113, 'María Alejandra', '1998-06-02', 3, 3, 1, 'López', 'Gómez', '38.654.321-7'),
(114, 'Juan Pablo', '2002-10-10', 1, 1, 2, 'Gómez', 'Martínez', '39.987.654-8'),
(115, 'Ana María', '1996-11-30', 2, 2, 3, 'Martínez', 'Hernández', '40.654.321-9'),
(116, 'Pedro Luis', '2003-09-25', 3, 3, 4, 'Hernández', 'López', '41.987.654-0'),
(117, 'Luis Andrés', '1995-04-14', 1, 3, 5, 'López', 'González', '42.654.321-1'),
(118, 'Ana María', '1999-03-20', 2, 4, 6, 'González', 'Martínez', '43.987.654-2'),
(119, 'Pablo Andrés', '2005-08-10', 3, 5, 7, 'Martínez', 'Hernández', '44.654.321-3'),
(120, 'Carlos Eduardo', '2001-01-15', 1, 1, 8, 'Hernández', 'López', '45.987.654-4'),
(121, 'María Alejandra', '1998-06-02', 2, 2, 9, 'López', 'Gómez', '46.654.321-5'),
(122, 'Juan Pablo', '2002-10-10', 3, 3, 10, 'Gómez', 'Martínez', '47.987.654-6'),
(123, 'Ana María', '1996-11-30', 1, 3, 11, 'Martínez', 'Hernández', '48.654.321-7'),
(124, 'Pedro Luis', '2003-09-25', 2, 4, 12, 'Hernández', 'López', '49.987.654-8'),
(125, 'Luis Andrés', '1995-04-14', 3, 5, 13, 'López', 'González', '50.654.321-9');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `noticia`
--

CREATE TABLE `noticia` (
  `ID` int(11) NOT NULL,
  `Titulo` varchar(255) DEFAULT NULL,
  `Contenido` text DEFAULT NULL,
  `Fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partido`
--

CREATE TABLE `partido` (
  `ID` int(11) NOT NULL,
  `Goles_Local` int(20) DEFAULT NULL,
  `Goles_Visita` int(11) DEFAULT NULL,
  `Ubicacion` varchar(255) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `Equipo_Local_ID` int(11) DEFAULT NULL,
  `Equipo_Visitante_ID` int(11) DEFAULT NULL,
  `ID_categoria` int(11) NOT NULL,
  `ID_jornada` int(11) NOT NULL,
  `Resultado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partido`
--

INSERT INTO `partido` (`ID`, `Goles_Local`, `Goles_Visita`, `Ubicacion`, `Fecha`, `Equipo_Local_ID`, `Equipo_Visitante_ID`, `ID_categoria`, `ID_jornada`, `Resultado`) VALUES
(1, 10, 7, 'Estadio X', '2024-03-30', 1, 2, 1, 1, 'local_gana'),
(2, 3, 2, 'Estadio Y', '2024-03-31', 3, 4, 1, 1, 'local_gana'),
(3, 1, 0, 'Estadio Z', '2024-03-31', 5, 6, 1, 1, 'local_gana'),
(4, 7, 0, 'Estadio X', '2024-03-30', 1, 2, 2, 1, ''),
(5, 2, 3, 'Estadio Y', '2024-03-31', 3, 4, 2, 1, 'Perdió'),
(6, 1, 0, 'Estadio Z', '2024-03-31', 5, 6, 2, 1, ''),
(7, 8, 6, 'Estadio X', '2024-03-30', 1, 2, 3, 1, ''),
(8, 2, 0, 'Estadio Y', '2024-03-31', 3, 4, 3, 1, ''),
(9, 1, 4, 'Estadio Z', '2024-03-31', 5, 6, 3, 1, ''),
(10, 3, 4, 'Estadio X', '2024-03-30', 1, 2, 1, 2, 'visitante_gana'),
(11, 2, 3, 'Estadio Y', '2024-03-31', 3, 4, 1, 2, 'visitante_gana'),
(12, 0, 5, 'Estadio Z', '2024-03-31', 5, 6, 1, 2, ''),
(13, 1, 2, 'Estadio A', '2024-04-01', 7, 8, 2, 3, ''),
(14, 0, 1, 'Estadio B', '2024-04-02', 9, 10, 2, 3, ''),
(15, 2, 0, 'Estadio C', '2024-04-02', 11, 12, 2, 3, ''),
(16, 1, 1, 'Estadio D', '2024-04-01', 13, 14, 3, 3, ''),
(17, 3, 2, 'Estadio E', '2024-04-03', 15, 16, 3, 3, ''),
(18, 0, 3, 'Estadio F', '2024-04-03', 17, 18, 3, 3, ''),
(19, 1, 1, 'Estadio G', '2024-04-01', 1, 2, 4, 4, ''),
(20, 2, 1, 'Estadio H', '2024-04-02', 3, 4, 4, 4, ''),
(21, 1, 0, 'Estadio I', '2024-04-02', 5, 6, 4, 4, ''),
(22, 2, 3, 'Estadio J', '2024-04-01', 7, 8, 5, 4, ''),
(23, 0, 2, 'Estadio K', '2024-04-03', 9, 10, 5, 4, ''),
(24, 1, 1, 'Estadio L', '2024-04-03', 11, 12, 5, 4, ''),
(25, 3, 1, 'Estadio M', '2024-04-01', 13, 14, 1, 5, ''),
(26, 1, 0, 'Estadio N', '2024-04-02', 15, 16, 1, 5, ''),
(27, 2, 2, 'Estadio O', '2024-04-02', 17, 18, 1, 5, ''),
(28, 0, 2, 'Estadio P', '2024-04-01', 1, 2, 2, 5, ''),
(29, 2, 1, 'Estadio Q', '2024-04-03', 3, 4, 2, 5, ''),
(30, 1, 0, 'Estadio R', '2024-04-03', 5, 6, 2, 5, ''),
(31, 1, 2, 'Estadio S', '2024-04-01', 7, 8, 3, 6, ''),
(32, 2, 1, 'Estadio T', '2024-04-02', 9, 10, 3, 6, ''),
(33, 0, 1, 'Estadio U', '2024-04-02', 11, 12, 3, 6, ''),
(34, 1, 3, 'Estadio V', '2024-04-01', 13, 14, 4, 6, ''),
(35, 2, 2, 'Estadio W', '2024-04-03', 15, 16, 4, 6, ''),
(36, 0, 0, 'Estadio X', '2024-04-03', 17, 18, 4, 6, ''),
(37, 2, 0, 'Estadio Y', '2024-04-01', 1, 2, 5, 6, ''),
(38, 0, 1, 'Estadio Z', '2024-04-02', 3, 4, 5, 6, ''),
(39, 1, 1, 'Estadio A', '2024-04-02', 5, 6, 5, 6, ''),
(40, 3, 1, 'Estadio B', '2024-04-01', 7, 8, 1, 7, ''),
(41, 1, 2, 'Estadio C', '2024-04-03', 9, 10, 1, 7, ''),
(42, 2, 0, 'Estadio D', '2024-04-03', 11, 12, 1, 7, ''),
(43, 0, 3, 'Estadio E', '2024-04-01', 13, 14, 2, 7, ''),
(44, 1, 0, 'Estadio F', '2024-04-02', 15, 16, 2, 7, ''),
(45, 2, 1, 'Estadio G', '2024-04-02', 17, 18, 2, 7, ''),
(46, 1, 2, 'Estadio H', '2024-04-01', 1, 2, 3, 8, ''),
(47, 2, 1, 'Estadio I', '2024-04-03', 3, 4, 3, 8, ''),
(48, 1, 0, 'Estadio J', '2024-04-03', 5, 6, 3, 8, ''),
(49, 2, 3, 'Estadio K', '2024-04-01', 7, 8, 4, 8, ''),
(50, 0, 2, 'Estadio L', '2024-04-02', 9, 10, 4, 8, ''),
(51, 1, 1, 'Estadio M', '2024-04-02', 11, 12, 4, 8, ''),
(52, 3, 1, 'Estadio N', '2024-04-01', 13, 14, 5, 8, ''),
(53, 1, 0, 'Estadio O', '2024-04-03', 15, 16, 5, 8, ''),
(54, 2, 2, 'Estadio P', '2024-04-03', 17, 18, 5, 8, ''),
(55, 3, 4, 'Estadio Q', '2024-04-01', 1, 2, 1, 9, 'visitante_gana'),
(56, 2, 1, 'Estadio R', '2024-04-02', 3, 4, 1, 9, ''),
(57, 1, 0, 'Estadio S', '2024-04-02', 5, 6, 1, 9, ''),
(58, 1, 2, 'Estadio T', '2024-04-01', 7, 8, 2, 9, ''),
(59, 2, 1, 'Estadio U', '2024-04-03', 9, 10, 2, 9, ''),
(60, 0, 1, 'Estadio V', '2024-04-03', 11, 12, 2, 9, ''),
(61, 1, 3, 'Estadio W', '2024-04-01', 13, 14, 3, 9, ''),
(62, 2, 2, 'Estadio X', '2024-04-02', 15, 16, 3, 9, ''),
(63, 0, 0, 'Estadio Y', '2024-04-02', 17, 18, 3, 9, ''),
(64, 2, 0, 'Estadio Z', '2024-04-01', 1, 2, 4, 9, ''),
(65, 0, 1, 'Estadio A', '2024-04-03', 3, 4, 4, 9, ''),
(66, 1, 1, 'Estadio B', '2024-04-03', 5, 6, 4, 9, ''),
(67, 3, 1, 'Estadio C', '2024-04-01', 7, 8, 5, 9, ''),
(68, 1, 2, 'Estadio D', '2024-04-02', 9, 10, 5, 9, ''),
(69, 2, 0, 'Estadio E', '2024-04-02', 11, 12, 5, 9, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `posicion`
--

CREATE TABLE `posicion` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `posicion`
--

INSERT INTO `posicion` (`ID`, `Nombre`) VALUES
(2, 'Defensa'),
(4, 'Delantero'),
(3, 'Mediocampista'),
(1, 'Portero');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `Tipo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `Tipo`) VALUES
(1, 'Administrador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_adulta_p`
--

CREATE TABLE `tabla_adulta_p` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_adulta_p`
--

INSERT INTO `tabla_adulta_p` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 1, 50, 10, 10, 0, 0, 20, 10, 1),
(2, 2, 2, 40, 10, 9, 1, 0, 15, 12, 1),
(3, 3, 3, 35, 10, 9, 0, 1, 18, 15, 1),
(4, 4, 4, 30, 10, 8, 2, 0, 20, 10, 1),
(5, 5, 5, 28, 10, 7, 3, 0, 15, 12, 1),
(6, 6, 6, 26, 10, 7, 1, 2, 18, 15, 1),
(7, 7, 7, 22, 10, 6, 2, 2, 20, 10, 1),
(8, 8, 8, 20, 10, 5, 3, 2, 15, 12, 1),
(9, 9, 9, 18, 10, 4, 2, 4, 20, 10, 1),
(10, 10, 10, 14, 10, 3, 3, 4, 15, 12, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_adulta_s`
--

CREATE TABLE `tabla_adulta_s` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_adulta_s`
--

INSERT INTO `tabla_adulta_s` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 11, 50, 10, 10, 0, 0, 20, 10, 2),
(2, 2, 12, 40, 10, 9, 1, 0, 15, 12, 2),
(3, 3, 13, 35, 10, 9, 0, 1, 18, 15, 2),
(4, 4, 14, 30, 10, 8, 2, 0, 20, 10, 2),
(5, 5, 15, 28, 10, 7, 3, 0, 15, 12, 2),
(6, 6, 16, 26, 10, 7, 1, 2, 18, 15, 2),
(7, 7, 17, 22, 10, 6, 2, 2, 20, 10, 2),
(8, 8, 18, 20, 10, 5, 3, 2, 15, 12, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_honor_p`
--

CREATE TABLE `tabla_honor_p` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_honor_p`
--

INSERT INTO `tabla_honor_p` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 1, 50, 10, 10, 0, 0, 20, 10, 1),
(2, 2, 2, 40, 10, 9, 1, 0, 15, 12, 1),
(3, 3, 3, 35, 10, 9, 0, 1, 18, 15, 1),
(4, 4, 4, 30, 10, 8, 2, 0, 20, 10, 1),
(5, 5, 5, 28, 10, 7, 3, 0, 15, 12, 1),
(6, 6, 6, 26, 10, 7, 1, 2, 18, 15, 1),
(7, 7, 7, 22, 10, 6, 2, 2, 20, 10, 1),
(8, 8, 8, 20, 10, 5, 3, 2, 15, 12, 1),
(9, 9, 9, 18, 10, 4, 2, 4, 20, 10, 1),
(10, 10, 10, 14, 10, 3, 3, 4, 15, 12, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_honor_s`
--

CREATE TABLE `tabla_honor_s` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_honor_s`
--

INSERT INTO `tabla_honor_s` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 11, 50, 10, 10, 0, 0, 20, 10, 2),
(2, 2, 12, 40, 10, 9, 1, 0, 15, 12, 2),
(3, 3, 13, 35, 10, 9, 0, 1, 18, 15, 2),
(4, 4, 14, 30, 10, 8, 2, 0, 20, 10, 2),
(5, 5, 15, 28, 10, 7, 3, 0, 15, 12, 2),
(6, 6, 16, 26, 10, 7, 1, 2, 18, 15, 2),
(7, 7, 17, 22, 10, 6, 2, 2, 20, 10, 2),
(8, 8, 18, 20, 10, 5, 3, 2, 15, 12, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_juvenil_p`
--

CREATE TABLE `tabla_juvenil_p` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL,
  `Dif_Goles` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_juvenil_p`
--

INSERT INTO `tabla_juvenil_p` (`ID`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`, `Dif_Goles`) VALUES
(1, 1, 3, 3, 1, 0, 2, 16, 15, 1, 0),
(2, 2, 6, 3, 2, 0, 1, 15, 16, 1, 0),
(3, 3, 0, 1, 0, 0, 1, 2, 3, 1, 0),
(4, 4, 3, 1, 1, 0, 0, 3, 2, 1, 0),
(5, 5, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(6, 6, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(7, 7, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(8, 8, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(9, 9, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(10, 10, 0, 0, 0, 0, 0, 0, 0, 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_juvenil_s`
--

CREATE TABLE `tabla_juvenil_s` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_juvenil_s`
--

INSERT INTO `tabla_juvenil_s` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 11, 50, 10, 10, 0, 0, 20, 10, 2),
(2, 2, 12, 40, 10, 9, 1, 0, 15, 12, 2),
(3, 3, 13, 35, 10, 9, 0, 1, 18, 15, 2),
(4, 4, 14, 30, 10, 8, 2, 0, 20, 10, 2),
(5, 5, 15, 28, 10, 7, 3, 0, 15, 12, 2),
(6, 6, 16, 26, 10, 7, 1, 2, 18, 15, 2),
(7, 7, 17, 22, 10, 6, 2, 2, 20, 10, 2),
(8, 8, 18, 20, 10, 5, 3, 2, 15, 12, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_senior_p`
--

CREATE TABLE `tabla_senior_p` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_senior_p`
--

INSERT INTO `tabla_senior_p` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 1, 43, 10, 10, 0, 0, 20, 10, 1),
(2, 2, 2, 40, 10, 9, 1, 0, 15, 12, 1),
(3, 3, 3, 35, 10, 9, 0, 1, 18, 15, 1),
(4, 4, 4, 30, 10, 8, 2, 0, 20, 10, 1),
(5, 5, 5, 28, 10, 7, 3, 0, 15, 12, 1),
(6, 6, 6, 26, 10, 7, 1, 2, 18, 15, 1),
(7, 7, 7, 22, 10, 6, 2, 2, 20, 10, 1),
(8, 8, 8, 20, 10, 5, 3, 2, 15, 12, 1),
(9, 9, 9, 18, 10, 4, 2, 4, 20, 10, 1),
(10, 10, 10, 14, 10, 3, 3, 4, 15, 12, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_senior_s`
--

CREATE TABLE `tabla_senior_s` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_senior_s`
--

INSERT INTO `tabla_senior_s` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 11, 50, 10, 10, 0, 0, 20, 10, 2),
(2, 2, 12, 40, 10, 9, 1, 0, 15, 12, 2),
(3, 3, 13, 35, 10, 9, 0, 1, 18, 15, 2),
(4, 4, 14, 30, 10, 8, 2, 0, 20, 10, 2),
(5, 5, 15, 28, 10, 7, 3, 0, 15, 12, 2),
(6, 6, 16, 26, 10, 7, 1, 2, 18, 15, 2),
(7, 7, 17, 22, 10, 6, 2, 2, 20, 10, 2),
(8, 8, 18, 20, 10, 5, 3, 2, 15, 12, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_supersenior_p`
--

CREATE TABLE `tabla_supersenior_p` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_supersenior_p`
--

INSERT INTO `tabla_supersenior_p` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 1, 50, 10, 10, 0, 0, 20, 10, 1),
(2, 2, 2, 40, 10, 9, 1, 0, 15, 12, 1),
(3, 3, 3, 35, 10, 9, 0, 1, 18, 15, 1),
(4, 4, 4, 30, 10, 8, 2, 0, 20, 10, 1),
(5, 5, 5, 28, 10, 7, 3, 0, 15, 12, 1),
(6, 6, 6, 26, 10, 7, 1, 2, 18, 15, 1),
(7, 7, 7, 22, 10, 6, 2, 2, 20, 10, 1),
(8, 8, 8, 20, 10, 5, 3, 2, 15, 12, 1),
(9, 9, 9, 18, 10, 4, 2, 4, 20, 10, 1),
(10, 10, 10, 14, 10, 3, 3, 4, 15, 12, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabla_supersenior_s`
--

CREATE TABLE `tabla_supersenior_s` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabla_supersenior_s`
--

INSERT INTO `tabla_supersenior_s` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 11, 50, 10, 10, 0, 0, 20, 10, 2),
(2, 2, 12, 40, 10, 9, 1, 0, 15, 12, 2),
(3, 3, 13, 35, 10, 9, 0, 1, 18, 15, 2),
(4, 4, 14, 30, 10, 8, 2, 0, 20, 10, 2),
(5, 5, 15, 28, 10, 7, 3, 0, 15, 12, 2),
(6, 6, 16, 26, 10, 7, 1, 2, 18, 15, 2),
(7, 7, 17, 22, 10, 6, 2, 2, 20, 10, 2),
(8, 8, 18, 20, 10, 5, 3, 2, 15, 12, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneo_regular`
--

CREATE TABLE `torneo_regular` (
  `ID` int(11) NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `torneo_regular`
--

INSERT INTO `torneo_regular` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 1, 15, 5, 5, 0, 0, 15, 4, 1),
(2, 2, 8, 15, 5, 5, 0, 0, 15, 2, 1),
(3, 3, 6, 13, 5, 4, 0, 1, 16, 4, 1),
(4, 4, 7, 12, 5, 4, 1, 0, 19, 9, 1),
(5, 5, 5, 11, 5, 3, 0, 2, 11, 2, 1),
(6, 6, 4, 10, 5, 3, 1, 1, 10, 2, 1),
(7, 7, 3, 10, 5, 3, 1, 1, 9, 7, 1),
(8, 8, 9, 7, 5, 2, 3, 1, 10, 12, 1),
(9, 9, 10, 6, 5, 2, 3, 0, 6, 16, 1),
(10, 10, 2, 5, 5, 1, 2, 2, 5, 16, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneo_regular_segunda`
--

CREATE TABLE `torneo_regular_segunda` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `Posicion` int(11) DEFAULT NULL,
  `Equipo_ID` int(11) DEFAULT NULL,
  `Puntos` int(11) DEFAULT NULL,
  `P_Jugados` int(11) DEFAULT NULL,
  `P_Ganados` int(11) DEFAULT NULL,
  `P_Empatados` int(11) DEFAULT NULL,
  `P_Perdidos` int(11) DEFAULT NULL,
  `Goles_Favor` int(11) DEFAULT NULL,
  `Goles_Contra` int(11) DEFAULT NULL,
  `ID_DIVISION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `torneo_regular_segunda`
--

INSERT INTO `torneo_regular_segunda` (`ID`, `Posicion`, `Equipo_ID`, `Puntos`, `P_Jugados`, `P_Ganados`, `P_Empatados`, `P_Perdidos`, `Goles_Favor`, `Goles_Contra`, `ID_DIVISION`) VALUES
(1, 1, 11, 50, 10, 6, 2, 2, 20, 10, 2),
(2, 2, 12, 40, 10, 5, 3, 2, 15, 12, 2),
(3, 3, 13, 34, 10, 4, 3, 3, 18, 15, 2),
(4, 4, 14, 30, 10, 6, 2, 2, 20, 10, 2),
(5, 5, 15, 28, 10, 5, 3, 2, 15, 12, 2),
(6, 6, 16, 26, 10, 4, 3, 3, 18, 15, 2),
(7, 7, 17, 18, 10, 5, 3, 2, 15, 12, 2),
(8, 8, 18, 12, 10, 4, 3, 3, 18, 15, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transferencia`
--

CREATE TABLE `transferencia` (
  `ID` int(11) NOT NULL,
  `Fecha_Transferencia` date DEFAULT NULL,
  `ID_Jugador` int(11) DEFAULT NULL,
  `Equipo_Origen` int(11) DEFAULT NULL,
  `Equipo_Destino` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `id_rol` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `correo`, `password`, `id_rol`) VALUES
(1, 'ericklj@gmail.com', '123', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `arbitro`
--
ALTER TABLE `arbitro`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Partido_ID` (`Partido_ID`),
  ADD KEY `Jugador_ID` (`Jugador_ID`);

--
-- Indices de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_jugador` (`id_jugador`);

--
-- Indices de la tabla `calendario`
--
ALTER TABLE `calendario`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Partido_ID` (`Partido_ID`);

--
-- Indices de la tabla `campeonato`
--
ALTER TABLE `campeonato`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `campeonato_est_equipo_c`
--
ALTER TABLE `campeonato_est_equipo_c`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Campeonato_ID` (`Campeonato_ID`),
  ADD KEY `Est_Equipo_C_ID` (`Est_Equipo_C_ID`);

--
-- Indices de la tabla `campeonato_est_jugador_c`
--
ALTER TABLE `campeonato_est_jugador_c`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Campeonato_ID` (`Campeonato_ID`),
  ADD KEY `Est_Jugador_C_ID` (`Est_Jugador_C_ID`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `division`
--
ALTER TABLE `division`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Division_ID` (`Division_ID`),
  ADD KEY `Estadio_ID` (`Estadio_ID`);

--
-- Indices de la tabla `equipo_categoria`
--
ALTER TABLE `equipo_categoria`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `Categoria_ID` (`Categoria_ID`);

--
-- Indices de la tabla `estadio`
--
ALTER TABLE `estadio`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `estadistica`
--
ALTER TABLE `estadistica`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Jugador_ID` (`Jugador_ID`);

--
-- Indices de la tabla `est_equipo_c`
--
ALTER TABLE `est_equipo_c`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `est_jugador_c`
--
ALTER TABLE `est_jugador_c`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Jugador_ID` (`Jugador_ID`);

--
-- Indices de la tabla `goles_jornada`
--
ALTER TABLE `goles_jornada`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID_jornada` (`ID_jornada`),
  ADD KEY `ID_jugador` (`ID_jugador`);

--
-- Indices de la tabla `jornada`
--
ALTER TABLE `jornada`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `jugador`
--
ALTER TABLE `jugador`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `unique_rut_constraint` (`rut`),
  ADD KEY `Posicion_ID` (`Posicion_ID`),
  ADD KEY `Categoria_ID` (`Categoria_ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`);

--
-- Indices de la tabla `noticia`
--
ALTER TABLE `noticia`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `partido`
--
ALTER TABLE `partido`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_Local_ID` (`Equipo_Local_ID`),
  ADD KEY `Equipo_Visitante_ID` (`Equipo_Visitante_ID`),
  ADD KEY `partido_ibfk_3` (`ID_categoria`),
  ADD KEY `partido_ibfk_4` (`ID_jornada`);

--
-- Indices de la tabla `posicion`
--
ALTER TABLE `posicion`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nombre` (`Nombre`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tabla_adulta_p`
--
ALTER TABLE `tabla_adulta_p`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_adulta_s`
--
ALTER TABLE `tabla_adulta_s`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_honor_p`
--
ALTER TABLE `tabla_honor_p`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_honor_s`
--
ALTER TABLE `tabla_honor_s`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_juvenil_p`
--
ALTER TABLE `tabla_juvenil_p`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_juvenil_s`
--
ALTER TABLE `tabla_juvenil_s`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_senior_p`
--
ALTER TABLE `tabla_senior_p`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_senior_s`
--
ALTER TABLE `tabla_senior_s`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_supersenior_p`
--
ALTER TABLE `tabla_supersenior_p`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `tabla_supersenior_s`
--
ALTER TABLE `tabla_supersenior_s`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `torneo_regular`
--
ALTER TABLE `torneo_regular`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `fk_division` (`ID_DIVISION`);

--
-- Indices de la tabla `torneo_regular_segunda`
--
ALTER TABLE `torneo_regular_segunda`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Equipo_ID` (`Equipo_ID`),
  ADD KEY `ID_DIVISION` (`ID_DIVISION`);

--
-- Indices de la tabla `transferencia`
--
ALTER TABLE `transferencia`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID_Jugador` (`ID_Jugador`),
  ADD KEY `Equipo_Origen` (`Equipo_Origen`),
  ADD KEY `Equipo_Destino` (`Equipo_Destino`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `arbitro`
--
ALTER TABLE `arbitro`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT de la tabla `calendario`
--
ALTER TABLE `calendario`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `campeonato`
--
ALTER TABLE `campeonato`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `campeonato_est_equipo_c`
--
ALTER TABLE `campeonato_est_equipo_c`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `campeonato_est_jugador_c`
--
ALTER TABLE `campeonato_est_jugador_c`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `division`
--
ALTER TABLE `division`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `equipo`
--
ALTER TABLE `equipo`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `equipo_categoria`
--
ALTER TABLE `equipo_categoria`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estadio`
--
ALTER TABLE `estadio`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `estadistica`
--
ALTER TABLE `estadistica`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `est_equipo_c`
--
ALTER TABLE `est_equipo_c`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `est_jugador_c`
--
ALTER TABLE `est_jugador_c`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `goles_jornada`
--
ALTER TABLE `goles_jornada`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT de la tabla `jornada`
--
ALTER TABLE `jornada`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `jugador`
--
ALTER TABLE `jugador`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT de la tabla `noticia`
--
ALTER TABLE `noticia`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `partido`
--
ALTER TABLE `partido`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `posicion`
--
ALTER TABLE `posicion`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tabla_adulta_p`
--
ALTER TABLE `tabla_adulta_p`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tabla_adulta_s`
--
ALTER TABLE `tabla_adulta_s`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tabla_honor_p`
--
ALTER TABLE `tabla_honor_p`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tabla_honor_s`
--
ALTER TABLE `tabla_honor_s`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tabla_juvenil_p`
--
ALTER TABLE `tabla_juvenil_p`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tabla_juvenil_s`
--
ALTER TABLE `tabla_juvenil_s`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tabla_senior_p`
--
ALTER TABLE `tabla_senior_p`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tabla_senior_s`
--
ALTER TABLE `tabla_senior_s`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tabla_supersenior_p`
--
ALTER TABLE `tabla_supersenior_p`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tabla_supersenior_s`
--
ALTER TABLE `tabla_supersenior_s`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `torneo_regular`
--
ALTER TABLE `torneo_regular`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `torneo_regular_segunda`
--
ALTER TABLE `torneo_regular_segunda`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `transferencia`
--
ALTER TABLE `transferencia`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `arbitro`
--
ALTER TABLE `arbitro`
  ADD CONSTRAINT `arbitro_ibfk_1` FOREIGN KEY (`Partido_ID`) REFERENCES `partido` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `arbitro_ibfk_2` FOREIGN KEY (`Jugador_ID`) REFERENCES `jugador` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`id_jugador`) REFERENCES `jugador` (`ID`);

--
-- Filtros para la tabla `calendario`
--
ALTER TABLE `calendario`
  ADD CONSTRAINT `calendario_ibfk_1` FOREIGN KEY (`Partido_ID`) REFERENCES `partido` (`ID`);

--
-- Filtros para la tabla `campeonato_est_equipo_c`
--
ALTER TABLE `campeonato_est_equipo_c`
  ADD CONSTRAINT `campeonato_est_equipo_c_ibfk_1` FOREIGN KEY (`Campeonato_ID`) REFERENCES `campeonato` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `campeonato_est_equipo_c_ibfk_2` FOREIGN KEY (`Est_Equipo_C_ID`) REFERENCES `est_equipo_c` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `campeonato_est_jugador_c`
--
ALTER TABLE `campeonato_est_jugador_c`
  ADD CONSTRAINT `campeonato_est_jugador_c_ibfk_1` FOREIGN KEY (`Campeonato_ID`) REFERENCES `campeonato` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `campeonato_est_jugador_c_ibfk_2` FOREIGN KEY (`Est_Jugador_C_ID`) REFERENCES `est_jugador_c` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD CONSTRAINT `equipo_ibfk_1` FOREIGN KEY (`Division_ID`) REFERENCES `division` (`ID`),
  ADD CONSTRAINT `equipo_ibfk_2` FOREIGN KEY (`Estadio_ID`) REFERENCES `estadio` (`ID`);

--
-- Filtros para la tabla `equipo_categoria`
--
ALTER TABLE `equipo_categoria`
  ADD CONSTRAINT `equipo_categoria_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `equipo_categoria_ibfk_2` FOREIGN KEY (`Categoria_ID`) REFERENCES `categoria` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estadistica`
--
ALTER TABLE `estadistica`
  ADD CONSTRAINT `estadistica_ibfk_1` FOREIGN KEY (`Jugador_ID`) REFERENCES `jugador` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `est_jugador_c`
--
ALTER TABLE `est_jugador_c`
  ADD CONSTRAINT `est_jugador_c_ibfk_1` FOREIGN KEY (`Jugador_ID`) REFERENCES `jugador` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `goles_jornada`
--
ALTER TABLE `goles_jornada`
  ADD CONSTRAINT `goles_jornada_ibfk_1` FOREIGN KEY (`ID_jornada`) REFERENCES `jornada` (`ID`),
  ADD CONSTRAINT `goles_jornada_ibfk_2` FOREIGN KEY (`ID_jugador`) REFERENCES `jugador` (`ID`);

--
-- Filtros para la tabla `jugador`
--
ALTER TABLE `jugador`
  ADD CONSTRAINT `jugador_ibfk_1` FOREIGN KEY (`Posicion_ID`) REFERENCES `posicion` (`ID`),
  ADD CONSTRAINT `jugador_ibfk_2` FOREIGN KEY (`Categoria_ID`) REFERENCES `categoria` (`ID`),
  ADD CONSTRAINT `jugador_ibfk_3` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `partido`
--
ALTER TABLE `partido`
  ADD CONSTRAINT `partido_ibfk_1` FOREIGN KEY (`Equipo_Local_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `partido_ibfk_2` FOREIGN KEY (`Equipo_Visitante_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `partido_ibfk_3` FOREIGN KEY (`ID_categoria`) REFERENCES `categoria` (`ID`),
  ADD CONSTRAINT `partido_ibfk_4` FOREIGN KEY (`ID_jornada`) REFERENCES `jornada` (`ID`);

--
-- Filtros para la tabla `tabla_adulta_p`
--
ALTER TABLE `tabla_adulta_p`
  ADD CONSTRAINT `tabla_adulta_p_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_adulta_p_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_adulta_s`
--
ALTER TABLE `tabla_adulta_s`
  ADD CONSTRAINT `tabla_adulta_s_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_adulta_s_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_honor_p`
--
ALTER TABLE `tabla_honor_p`
  ADD CONSTRAINT `tabla_honor_p_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_honor_p_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_honor_s`
--
ALTER TABLE `tabla_honor_s`
  ADD CONSTRAINT `tabla_honor_s_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_honor_s_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_juvenil_p`
--
ALTER TABLE `tabla_juvenil_p`
  ADD CONSTRAINT `tabla_juvenil_p_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_juvenil_p_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_juvenil_s`
--
ALTER TABLE `tabla_juvenil_s`
  ADD CONSTRAINT `tabla_juvenil_s_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_juvenil_s_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_senior_p`
--
ALTER TABLE `tabla_senior_p`
  ADD CONSTRAINT `tabla_senior_p_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_senior_p_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_senior_s`
--
ALTER TABLE `tabla_senior_s`
  ADD CONSTRAINT `tabla_senior_s_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_senior_s_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_supersenior_p`
--
ALTER TABLE `tabla_supersenior_p`
  ADD CONSTRAINT `tabla_supersenior_p_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_supersenior_p_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `tabla_supersenior_s`
--
ALTER TABLE `tabla_supersenior_s`
  ADD CONSTRAINT `tabla_supersenior_s_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `tabla_supersenior_s_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `torneo_regular`
--
ALTER TABLE `torneo_regular`
  ADD CONSTRAINT `fk_division` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`),
  ADD CONSTRAINT `torneo_regular_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`);

--
-- Filtros para la tabla `torneo_regular_segunda`
--
ALTER TABLE `torneo_regular_segunda`
  ADD CONSTRAINT `torneo_regular_segunda_ibfk_1` FOREIGN KEY (`Equipo_ID`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `torneo_regular_segunda_ibfk_2` FOREIGN KEY (`ID_DIVISION`) REFERENCES `division` (`ID`);

--
-- Filtros para la tabla `transferencia`
--
ALTER TABLE `transferencia`
  ADD CONSTRAINT `transferencia_ibfk_1` FOREIGN KEY (`ID_Jugador`) REFERENCES `jugador` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transferencia_ibfk_2` FOREIGN KEY (`Equipo_Origen`) REFERENCES `equipo` (`ID`),
  ADD CONSTRAINT `transferencia_ibfk_3` FOREIGN KEY (`Equipo_Destino`) REFERENCES `equipo` (`ID`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
