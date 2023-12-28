
-- @block
CREATE TABLE IF NOT EXISTS Desastre (
    Desastre_id INT AUTO_INCREMENT PRIMARY KEY
);

-- @block
CREATE TABLE IF NOT EXISTS Escala (
    Escala_id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Tipos (
    Tipos_id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255)
);

-- @block
CREATE TABLE IF NOT EXISTS DesastreNatural (
    Desastre_id INT PRIMARY KEY,
    Tipo INT,
    Escala INT,
    Magnitud INT,
    Causa VARCHAR(255),
    FOREIGN KEY (Desastre_id) REFERENCES Desastre(Desastre_id),
    FOREIGN KEY (Tipo) REFERENCES Tipos(Tipos_id),
    FOREIGN KEY (Escala) REFERENCES Escala(Escala_id)
);

-- @block
CREATE TABLE IF NOT EXISTS GruposDeInteres(
    Grupo_id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255)
);

-- @block
CREATE TABLE IF NOT EXISTS DesastreSocial (
    Desastre_id INT PRIMARY KEY,
    Grupo INT,
    Objetivos VARCHAR(255),
    Nombre_evento VARCHAR(255),
    FOREIGN KEY (Desastre_id) REFERENCES Desastre(Desastre_id),
    FOREIGN KEY (Grupo) REFERENCES GruposDeInteres(Grupo_id)
);

-- @block
CREATE TABLE IF NOT EXISTS Pais(
    Pais_id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255)
);

-- @block
CREATE TABLE IF NOT EXISTS Ubicacion(
    Nombre VARCHAR(255) PRIMARY KEY,
    Pais INT,
    Poblacion INT,
    Susceptibilidad VARCHAR(255),
    FOREIGN KEY (Pais) REFERENCES Pais(Pais_id)
);

-- @block
CREATE TABLE IF NOT EXISTS Afectacion(
    Afectacion_id INT AUTO_INCREMENT PRIMARY KEY,
    Ubicacion VARCHAR(255),
    Desastre INT,
    Fecha_inicio DATE,
    Fecha_final DATE,
    FOREIGN KEY (Ubicacion) REFERENCES Ubicacion(Nombre),
    FOREIGN KEY (Desastre) REFERENCES Desastre(Desastre_id)
);

-- @block
-- Trigger para asegurarse de que la fecha final sea mayor que la fecha inicial en la tabla de afectacion
CREATE TRIGGER verificarFechas
BEFORE INSERT ON Afectacion
FOR EACH ROW
BEGIN
    IF NEW.Fecha_inicio > NEW.Fecha_final THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio no puede ser mayor a la final';
    END IF;
END;

-- @block
-- Trigger que previene que se borre un registro en desastres si ya esta referenciado en Afectacion
CREATE TRIGGER permitirEliminacionDesastre
BEFORE DELETE ON Desastre
FOR EACH ROW
BEGIN
    DECLARE desastreUsado INT;
    SELECT COUNT(*) INTO desastreUsado FROM Afectacion WHERE Desastre = OLD.Desastre_id;
    IF desastreUsado > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un desastre que esta en uso';
    END IF;
END;

-- @block
-- Trigger para asegurar que al registrar un desastre en las entidades hijas, tambien lo haga en la padre
CREATE TRIGGER insertarEnDesastreNatural
BEFORE INSERT ON DesastreNatural
FOR EACH ROW
BEGIN
    INSERT INTO Desastre (Desastre_id) VALUES (NEW.Desastre_id);
END;

CREATE TRIGGER insertarEnSocial
BEFORE INSERT ON DesastreSocial
FOR EACH ROW
BEGIN
    INSERT INTO Desastre (Desastre_id) VALUES (NEW.Desastre_id);
END;

-- @block
-- Aserto para reforzar que no ocurra un problema de fechas
ALTER TABLE Afectacion
ADD CONSTRAINT chk_Fechas CHECK (Fecha_inicio <= Fecha_final);

-- @block
ALTER TABLE DesastreNatural
-- Asegurar que la magnitud en desastre natural no pase de 10
ADD CONSTRAINT chk_Magnitud CHECK (Magnitud BETWEEN 1 AND 10);

-- @block
INSERT INTO Escala (Nombre) VALUES 
('Escala de Richter'),
('Escala Saffir-Simpson'),
('Escala Fujita'),
('Escala de Mercalli Modificada'),
('Escala Torro'),
('Escala de Beaufort'),
('Escala de Mohs'),
('Escala de Decibelios'),
('Escala de Munsell'),
('Escala de Scoville'),
('Escala de Sievert'),
('Escala de Defcon'),
('Escala de Rossi-Forel'),
('Escala de Medvedev-Sponheuer-Karnik'),
('Escala de Shindo'),
('Escala de Rohn'),
('Escala de Volcanes Explosivos'),
('Escala de Duración de Terremotos'),
('Escala de Inundaciones'),
('Escala de Severidad de Sequía');

-- @block
INSERT INTO Tipos (Nombre) VALUES 
('Geológico'),
('Marítimo'),
('Meteorológico'),
('Climático'),
('Hidrológico'),
('Biológico'),
('Tectónico'),
('Volcánico'),
('Incendio Forestal'),
('Tormenta Eléctrica'),
('Sequía'),
('Ola de Calor'),
('Ola de Frío'),
('Deslizamiento de Tierra'),
('Avalancha'),
('Tsunami'),
('Erupción Volcánica'),
('Contaminación Ambiental'),
('Pandemia'),
('Infestación de Plagas');

-- @block
INSERT INTO DesastreNatural (Desastre_id, Tipo, Escala, Magnitud, Causa) VALUES 
(1, 1, 1, 7.5, 'Movimiento de placas tectónicas'),
(2, 2, 2, 5, 'Ciclón tropical'),
(3, 3, 3, 3, 'Tormenta severa'),
(4, 4, 1, 6, 'Cambios climáticos extremos'),
(5, 5, 2, 4, 'Inundaciones por lluvias intensas'),
(6, 6, 3, 2, 'Brote de enfermedad'),
(7, 1, 1, 8, 'Actividad sísmica'),
(8, 2, 2, 5, 'Tsunami'),
(9, 3, 3, 3, 'Huracán'),
(10, 4, 4, 9, 'Ola de calor'),
(11, 5, 5, 6, 'Deslizamiento de tierra'),
(12, 6, 6, 7, 'Erupción volcánica'),
(13, 1, 1, 5.5, 'Terremoto'),
(14, 2, 2, 4, 'Maremoto'),
(15, 3, 3, 8, 'Tornado'),
(16, 4, 4, 2, 'Sequía prolongada'),
(17, 5, 5, 7, 'Avalancha'),
(18, 6, 6, 6, 'Incendio forestal'),
(19, 1, 1, 9, 'Colapso geológico'),
(20, 2, 2, 10, 'Gran tormenta invernal');

-- @block
INSERT INTO GruposDeInteres (Nombre) VALUES 
('Frente de Liberación Nacional'),
('Movimiento Democrático Unido'),
('Alianza por la Justicia'),
('Consejo de Reforma Agraria'),
('Unión de Trabajadores Industriales'),
('Colectivo de Paz y Derechos'),
('Federación de Comunidades Autónomas'),
('Grupo de Acción Ecológica'),
('Red de Solidaridad Urbana'),
('Coalición por la Libertad de Expresión'),
('Iniciativa de Desarrollo Sostenible'),
('Asociación de Empoderamiento Local'),
('Liga de Educación y Cultura'),
('Frente de Resistencia Civil'),
('Movimiento por la Equidad Social'),
('Consejo para la Protección del Patrimonio'),
('Grupo de Intervención en Crisis'),
('Comité de Acción Humanitaria'),
('Plataforma de Innovación Comunitaria'),
('Red de Apoyo Comunal');

-- @block
INSERT INTO DesastreSocial (Desastre_id, Grupo, Objetivos, Nombre_evento) VALUES 
(21, 1, 'Restauración del orden', 'Revuelta en la Capital'),
(22, 2, 'Estabilidad regional', 'Conflicto Fronterizo'),
(23, 3, 'Derechos humanos', 'Protestas masivas por derechos'),
(24, 4, 'Acceso a recursos', 'Enfrentamientos por recursos naturales'),
(25, 5, 'Equidad económica', 'Disturbios por crisis económica'),
(26, 6, 'Reforma social', 'Movimiento de desobediencia civil'),
(27, 7, 'Control territorial', 'Conflicto armado interno'),
(28, 8, 'Reconocimiento de derechos', 'Manifestación nacional'),
(29, 9, 'Resolución de disputas', 'Enfrentamiento entre facciones'),
(30, 10, 'Lucha por la independencia', 'Movimiento separatista'),
(31, 11, 'Reivindicación de derechos', 'Huelga general violenta'),
(32, 12, 'Preservación cultural', 'Conflicto étnico'),
(33, 13, 'Justicia económica', 'Protestas contra la desigualdad'),
(34, 14, 'Autodeterminación', 'Levantamiento popular'),
(35, 15, 'Soberanía nacional', 'Guerra civil'),
(36, 16, 'Reforma política', 'Crisis política nacional'),
(37, 17, 'Gobernabilidad', 'Coup d état'),
(38, 18, 'Reparto de tierras', 'Conflicto agrario'),
(39, 19, 'Reforma educativa', 'Protestas estudiantiles violentas'),
(40, 20, 'Autonomía regional', 'Movimiento de insurgencia');

-- @block
INSERT INTO Pais (Nombre) VALUES 
('México'),
('Canadá'),
('Brasil'),
('España'),
('Japón'),
('Sudáfrica'),
('India'),
('Nueva Zelanda'),
('Egipto'),
('Noruega'),
('Rusia'),
('Malasia'),
('Grecia'),
('Turquía'),
('Kenia'),
('Chile'),
('Irlanda'),
('Filipinas'),
('Vietnam'),
('Polonia');

-- @block
INSERT INTO Ubicacion (Nombre, Pais, Poblacion, Susceptibilidad) VALUES 
('Ciudad de México', 1, 9000000, 'Alta: Propensa a terremotos y problemas de infraestructura'),
('Toronto', 2, 2800000, 'Baja: Buen manejo de emergencias y clima moderado'),
('São Paulo', 3, 12300000, 'Moderada: Riesgos de inundaciones y deslizamientos, pero con respuesta efectiva'),
('Madrid', 4, 3200000, 'Baja: Infraestructura sólida, riesgo bajo de desastres naturales'),
('Tokio', 5, 13900000, 'Alta: Frecuentes terremotos y tsunamis, aunque con excelente preparación'),
('Ciudad del Cabo', 6, 4300000, 'Moderada: Riesgo de sequías e incendios, infraestructura en desarrollo'),
('Mumbai', 7, 18400000, 'Alta: Vulnerable a inundaciones y alta densidad poblacional'),
('Auckland', 8, 1500000, 'Baja: Riesgos geológicos limitados y buena gestión de emergencias'),
('El Cairo', 9, 9500000, 'Moderada: Problemas de contaminación y gestión del agua'),
('Oslo', 10, 680000, 'Baja: Excelente infraestructura y gestión de riesgos naturales'),
('Moscú', 11, 11900000, 'Moderada: Clima extremo en invierno, pero buena infraestructura'),
('Kuala Lumpur', 12, 1800000, 'Moderada: Riesgos de inundaciones, pero con respuestas eficientes'),
('Atenas', 13, 660000, 'Moderada: Riesgo de terremotos y crisis económica'),
('Estambul', 14, 15000000, 'Alta: Alta actividad sísmica y desafíos urbanos'),
('Nairobi', 15, 4400000, 'Alta: Desafíos de urbanización y gestión de desastres naturales'),
('Santiago', 16, 6000000, 'Moderada: Riesgo sísmico y problemas de sequía'),
('Dublín', 17, 540000, 'Baja: Riesgo de inundaciones limitado y buena infraestructura'),
('Manila', 18, 17800000, 'Alta: Frecuentes tifones y problemas de urbanización'),
('Hanoi', 19, 8000000, 'Moderada: Riesgos de inundaciones y tormentas, infraestructura en mejora'),
('Varsovia', 20, 1750000, 'Baja: Riesgos naturales limitados, buena preparación para emergencias');

-- @block
INSERT INTO Afectacion (Ubicacion, Desastre, Fecha_inicio, Fecha_final) VALUES 
('Ciudad de México', 21, '2021-01-10', '2021-01-20'),
('Toronto', 23, '2020-05-15', '2020-05-25'),
('São Paulo', 25, '2021-02-20', '2021-03-01'),
('Madrid', 27, '2020-11-10', '2020-11-15'),
('Tokio', 29, '2021-04-05', '2021-04-15'),
('Ciudad del Cabo', 31, '2021-07-22', '2021-08-02'),
('Mumbai', 33, '2020-12-01', '2020-12-10'),
('Auckland', 35, '2021-08-15', '2021-08-25'),
('El Cairo', 37, '2020-09-10', '2020-09-20'),
('Oslo', 39, '2021-06-05', '2021-06-15'),
('Moscú', 22, '2021-03-10', '2021-03-20'),
('Kuala Lumpur', 24, '2020-07-15', '2020-07-25'),
('Atenas', 26, '2021-05-20', '2021-05-30'),
('Estambul', 28, '2020-10-05', '2020-10-15'),
('Nairobi', 30, '2021-09-01', '2021-09-11'),
('Santiago', 32, '2021-02-12', '2021-02-22'),
('Dublín', 34, '2020-08-20', '2020-08-30'),
('Manila', 36, '2021-01-15', '2021-01-25'),
('Hanoi', 38, '2020-04-10', '2020-04-20'),
('Varsovia', 40, '2021-03-15', '2021-03-25');


-- @block
DROP TABLE IF EXISTS desastresocial, DesastreNatural, GruposDeInteres, Escala, Tipos, Desastre, Afectacion, Ubicacion, Pais;

-- @block
DROP TRIGGER IF EXISTS verificarFechas;
DROP TRIGGER IF EXISTS permitirEliminacionDesastre;
DROP TRIGGER IF EXISTS insertarEnDesastreNatural;
DROP TRIGGER IF EXISTS insertarEnSocial;

-- @block
SHOW TABLES;

-- @block
DELETE FROM DesastreNatural;

-- @block
DELETE FROM DesastreSocial;

-- @block
DELETE FROM Desastre;


-- @block
SELECT * FROM Escala;
SELECT * FROM Tipos;
SELECT * FROM Desastre;
SELECT * FROM DesastreNatural;
SELECT * FROM GruposDeInteres;
SELECT * FROM DesastreSocial;
SELECT * FROM Pais;
SELECT * FROM Ubicacion;
SELECT * FROM Afectacion;