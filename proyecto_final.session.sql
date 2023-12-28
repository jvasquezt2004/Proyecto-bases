
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
    SELECT COUNT(*) INTO desastreUsado FROM afectacion WHERE Desastre = OLD.Desastre_id;
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
DROP TABLE IF EXISTS desastresocial, DesastreNatural, GruposDeInteres, Escala, Tipos, Desastre, Afectacion, Ubicacion, Pais;

-- @block
SHOW TABLES;