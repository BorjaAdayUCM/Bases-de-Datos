DROP TABLE EMPLEADOS;
DROP TABLE DEPARTAMENTOS;
DROP TABLE CAMBIOS;

CREATE TABLE Departamentos(
CodDept CHAR(5) PRIMARY KEY,
Nombre VARCHAR(100)
);
CREATE TABLE Empleados(
DNI CHAR(9) PRIMARY KEY,
Nombre VARCHAR(100),
CodDept CHAR(5) REFERENCES Departamentos ON DELETE SET NULL,
Salario NUMBER(4,0)
);
CREATE TABLE Cambios(
IdCambio VARCHAR(10) PRIMARY KEY,
Usuario VARCHAR(20),
SalarioAnt NUMBER(4,0),
SalarioNew NUMBER(4,0)
);

INSERT INTO Departamentos VALUES ('1', 'Informatica');
INSERT INTO Departamentos VALUES ('2', 'Matematicas');
INSERT INTO Departamentos VALUES ('3', 'Lengua');
INSERT INTO Departamentos VALUES ('4', 'Ingles');

INSERT INTO empleados VALUES ('78592137X', 'Borja', '1', 500);
INSERT INTO empleados VALUES ('78592137C', 'Borj', '1', 3);
INSERT INTO empleados VALUES ('78592137Y', 'Bryan', '1', 1);
INSERT INTO empleados VALUES ('78592137Z', 'Tole', '2', 300);
INSERT INTO empleados VALUES ('78592137A', 'Reema', '3', 43);
INSERT INTO empleados VALUES ('78592137B', 'Claudia', '4', 42);

DELETE DEPARTAMENTOS;
DELETE EMPLEADOS;

COMMIT;


---a---
CREATE OR REPLACE TRIGGER Cambio
AFTER UPDATE ON Empleados
for each row
DECLARE
  vUser VARCHAR2(100);
begin
    vUser := USER;
    INSERT INTO CAMBIOS VALUES(SEQCAMBIOS.NEXTVAL, vUser, :old.salario, :new.salario);
end;
/

UPDATE empleados e set e.salario = e.salario * 2;

SELECT e.nombre, e.codDept, e.salario
        from empleados e join DEPARTAMENTOS d on e.codDept = d.codDept
        where e.salario < (SELECT avg(e2.salario) as media from empleados e2 where e2.codDept = e.codDept);
        
---b--- MAAAAAAAAAAAAAAAAAL
CREATE OR REPLACE PROCEDURE DEPARTS is
    cursor cr_empleado is
        SELECT e.nombre, e.codDept, e.salario
        from empleado e join DEPARTAMENTOS d on e.codDept = d.codDept
        where e.salario < (SELECT avg(e2.salario)from empleado e2 where e2.codDept = e.codDept);
BEGIN
    FOR r_empleado in cr_empleado loop
        
    end loop;
END;
/















