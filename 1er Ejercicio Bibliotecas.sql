DROP TABLE Prestamo CASCADE CONSTRAINTS;
DROP TABLE Ejemplar_Revista CASCADE CONSTRAINTS;
DROP TABLE Ejemplar_Libro CASCADE CONSTRAINTS;
DROP TABLE Libro CASCADE CONSTRAINTS;
DROP TABLE Revista CASCADE CONSTRAINTS;
DROP TABLE Socio CASCADE CONSTRAINTS;
DROP TABLE Publicacion CASCADE CONSTRAINTS;
DROP TABLE Biblioteca CASCADE CONSTRAINTS;
DROP TABLE Editorial CASCADE CONSTRAINTS;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

CREATE TABLE Editorial
(Nombre VARCHAR2(50) PRIMARY KEY,
Direccion VARCHAR2(50) UNIQUE,
Telefono VARCHAR2(9) UNIQUE
);

CREATE TABLE Biblioteca
(Distrito VARCHAR2(25) PRIMARY KEY,
Direccion VARCHAR2(50) UNIQUE
);

CREATE TABLE Publicacion
(ISBN VARCHAR2(20) PRIMARY KEY,
Autores VARCHAR2(50),
Titulo VARCHAR2(50),
Idioma VARCHAR2(15),
NEditorial VARCHAR2(20) REFERENCES Editorial
);

CREATE TABLE Socio
(NCarnet VARCHAR2(15) PRIMARY KEY,
Nombre VARCHAR2(50),
DNI VARCHAR2(9) UNIQUE,
Email VARCHAR2(30) UNIQUE,
Distrito VARCHAR2(25) REFERENCES Biblioteca
);

CREATE TABLE Revista
(ISBN VARCHAR2(20) PRIMARY KEY REFERENCES Publicacion,
Periodo VARCHAR2(15)
);

CREATE TABLE Libro
(ISBN VARCHAR2(20) PRIMARY KEY REFERENCES Publicacion,
Edicion NUMBER(2),
Año NUMBER(4) UNIQUE 
);

CREATE TABLE Ejemplar_Libro
(ISBN VARCHAR2(20) REFERENCES Libro,
Distrito VARCHAR2(25) REFERENCES Biblioteca,
Numero NUMBER(3),
FechaCompra DATE,
CONSTRAINT ej_l_PK PRIMARY KEY (ISBN, Distrito, Numero)
);

CREATE TABLE Prestamo
(NCarnet VARCHAR2(15) REFERENCES Socio,
FechaPrestamo DATE,
ISBN VARCHAR2(20),
Distrito VARCHAR2(25),
Numero NUMBER(3),
NumDias NUMBER(2),
CONSTRAINT prestamo_PK PRIMARY KEY(NCarnet,FechaPrestamo),
CONSTRAINT prestamo_FK FOREIGN KEY (ISBN,Distrito,Numero) REFERENCES Ejemplar_Libro,
CONSTRAINT min_dias CHECK(NumDias > 0)
);

CREATE TABLE Ejemplar_Revista
(ISBN VARCHAR2(20) REFERENCES Revista,
Distrito VARCHAR2(25) REFERENCES Biblioteca,
Numero NUMBER(3),
FechaCompra DATE,
CONSTRAINT ej_R_PK PRIMARY KEY (ISBN, Distrito, Numero)
);

INSERT INTO Biblioteca
VALUES('Retiro', 'Dr. Esquerdo, 189');

INSERT INTO Biblioteca
VALUES('Moratalaz', 'Corregidor Alonso de Tobar, 5');

INSERT INTO Editorial
VALUES ('Addison-Wesley', 'Ribera del Loira, 28. 28042 Madrid', 911234567);

INSERT INTO Editorial
VALUES ('McGrawHill', 'Luisa Fernanda, 23. 28008 Madrid', 928843735);

INSERT INTO Editorial
VALUES ('ATI', 'Camino de Dios. 28008 Madrid', 928574275);

INSERT INTO Publicacion
VALUES ('978-84-782-9085-7', 'R. Elmasri, S.B. Navathe', 'Fundamentos de Sistemas de Bases de Datos', 'Español', 'Addison-Wesley');

INSERT INTO Publicacion
VALUES ('978-84-481-4644-1', 'A. Silberschatz, H.F. Korth, S. Sudarshan', 'Fundamentos de Bases de Datos', 'Español', 'McGrawHill');

INSERT INTO Publicacion
VALUES ('2444-6629', 'VVAA', 'Novática', 'Español', 'ATI');

INSERT INTO Libro
VALUES ('978-84-481-4644-1', 5, 2006);

INSERT INTO Libro
VALUES ('978-84-782-9085-7', 5, 2007);

INSERT INTO Revista
VALUES ('2444-6629', 'Trimestral');

INSERT INTO Ejemplar_Libro
VALUES ('978-84-481-4644-1', 'Retiro', 1, to_date('21-11-2017'));

INSERT INTO Ejemplar_Libro
VALUES ('978-84-481-4644-1', 'Retiro', 2, to_date('20-11-2017'));

INSERT INTO Ejemplar_Libro
VALUES ('978-84-782-9085-7', 'Retiro', 1, to_date('19-11-2017'));

INSERT INTO Ejemplar_Libro
VALUES ('978-84-782-9085-7', 'Moratalaz', 1, to_date('18-11-2017'));

INSERT INTO Ejemplar_Libro
VALUES ('978-84-782-9085-7', 'Moratalaz', 2, to_date('17-11-2017'));

INSERT INTO Ejemplar_Libro
VALUES ('978-84-481-4644-1', 'Moratalaz', 1, to_date('16-11-2017'));

INSERT INTO Ejemplar_Revista
VALUES ('2444-6629', 'Retiro', 1, to_date('01-01-2017'));

INSERT INTO Ejemplar_Revista
VALUES ('2444-6629', 'Retiro', 2, to_date('01-04-2017'));

INSERT INTO Ejemplar_Revista
VALUES ('2444-6629', 'Retiro', 3, to_date('01-07-2017'));

INSERT INTO Ejemplar_Revista
VALUES ('2444-6629', 'Retiro', 4, to_date('01-10-2017'));

INSERT INTO Socio
VALUES ('0000X', 'Borja Aday Guadalupe Luis', '78592137X', 'borjagua@ucm.es', 'Retiro');

INSERT INTO Socio
VALUES ('0001X', 'Eduardo Bryan de Renovales Alvarado', '78585374D', 'eddereno@ucm.es', 'Moratalaz');

INSERT INTO Prestamo
VALUES ('0000X', to_date('15-10-2017'), '978-84-782-9085-7', 'Retiro', 1, 20);

INSERT INTO Prestamo
VALUES ('0000X', to_date('30-10-2017'), '978-84-481-4644-1', 'Moratalaz', 1, 20);

INSERT INTO Prestamo
VALUES ('0001X', to_date('10-10-2017'), '978-84-782-9085-7', 'Moratalaz', 1, 5);

INSERT INTO Prestamo
VALUES ('0001X', to_date('13-10-2017'), '978-84-481-4644-1', 'Retiro', 1, 5);

COMMIT;

SELECT * FROM Socio;

UPDATE Socio SET Nombre = 'Borja Aday' WHERE Nombre = 'Borja Aday Guadalupe Luis';
    
SELECT * FROM Socio;

SELECT * FROM Prestamo;

UPDATE Prestamo SET NumDias = NumDias * 2 WHERE Distrito = 'Moratalaz';
    
SELECT * FROM Prestamo;

SELECT * FROM Socio WHERE Distrito = 'Retiro';
    
SELECT * FROM Prestamo WHERE EXTRACT (MONTH FROM FechaPrestamo) = 10;

SELECT FechaPrestamo + NumDias FROM Prestamo;

SELECT * FROM Prestamo WHERE FechaPrestamo + NumDias < to_date('16-11-2017');

SELECT * FROM Prestamo WHERE FechaPrestamo + NumDias <= SYSDATE;

SELECT * FROM PRESTAMO ORDER BY FechaPrestamo + numDias DESC;