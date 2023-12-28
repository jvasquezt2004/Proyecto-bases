
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
DROP TABLE IF EXISTS desastresocial, DesastreNatural, GruposDeInteres, Escala, Tipos, Desastre, Afectacion, Ubicacion, Pais;

-- @block
SHOW TABLES;