DROP TABLE ejd_distribucion CASCADE CONSTRAINTS;
DROP TABLE ejd_proyecto CASCADE CONSTRAINTS;
DROP TABLE ejd_cliente CASCADE CONSTRAINTS;
DROP TABLE ejd_empleado CASCADE CONSTRAINTS;

CREATE TABLE ejd_empleado (
       idEmpleado NUMBER(5,0) PRIMARY KEY,
       nombre VARCHAR2(50),
       fecContrato DATE,
       salario NUMBER(10,2), -- salario mensual.
       CHECK (salario > 0)
);

CREATE TABLE ejd_cliente (
       idCliente NUMBER(5,0) PRIMARY KEY,
       nombre VARCHAR2(50)
);

CREATE TABLE ejd_proyecto (
       idProyecto NUMBER(5,0) PRIMARY KEY,
       idCliente NUMBER(5,0) REFERENCES ejd_cliente,
       area VARCHAR2(20),
       fecInicio DATE, -- Inicio del proyecto
       fecFin DATE, -- Fin del proyecto
       presupuesto NUMBER(10,2),
       CHECK (presupuesto > 0)
);

CREATE TABLE ejd_distribucion (
       idEmpleado NUMBER(5,0) REFERENCES ejd_empleado,
       idProyecto NUMBER(5,0) REFERENCES ejd_proyecto,
       fecInicio DATE, -- inicio de la participacion de empleado en proyecto.
       fecFin DATE, -- fin de la participacion de empleado en proyecto.
       CONSTRAINT pk_ejd_distribucion PRIMARY KEY (idEmpleado, idProyecto, fecInicio)
);

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
INSERT INTO ejd_empleado VALUES (1, 'Astrid Almendros', TO_DATE('17-08-2015'), 1825.0);
INSERT INTO ejd_empleado VALUES (2, 'Manuel Sanchez', TO_DATE('1-1-2011'), 1483.25);
INSERT INTO ejd_empleado VALUES (3,'Marta Sanchez', TO_DATE('18-10-2017'), 1520.0);
INSERT INTO ejd_empleado VALUES (4,'Alberto San Gil', TO_DATE('18-10-2017'), 1570.0);
INSERT INTO ejd_empleado VALUES (5,'Maria Puente', TO_DATE('01-11-2017'), 2640.0);
INSERT INTO ejd_empleado VALUES (6,'Juan Panero', TO_DATE('21-10-2017'), 1820.0);

INSERT INTO ejd_cliente VALUES (101,'Movigas');
INSERT INTO ejd_cliente VALUES (102,'Eurotron SA');
INSERT INTO ejd_cliente VALUES (103,'Lineas aereas Pucelanas');

INSERT INTO ejd_proyecto VALUES (201,101,'Energia',TO_DATE('01-03-2017'),TO_DATE('31-10-2019'),95000);
INSERT INTO ejd_proyecto VALUES (202,101,'Contabilidad',TO_DATE('01-04-2017'),TO_DATE('31-10-2017'),63000);
INSERT INTO ejd_proyecto VALUES (203,102,'Contabilidad',TO_DATE('01-08-2017'),TO_DATE('31-10-2021'),180000);
INSERT INTO ejd_proyecto VALUES (204,103,'Energia',TO_DATE('01-08-2017'),TO_DATE('31-10-2021'),180000);


INSERT INTO ejd_distribucion VALUES (1,201,TO_DATE('05-03-2017'),TO_DATE('31-01-2018'));
INSERT INTO ejd_distribucion VALUES (2,201,TO_DATE('05-03-2017'),TO_DATE('31-01-2018'));
INSERT INTO ejd_distribucion VALUES (3,201,TO_DATE('18-10-2017'),TO_DATE('31-01-2018'));
INSERT INTO ejd_distribucion VALUES (4,201,TO_DATE('18-10-2017'),TO_DATE('30-10-2017'));

INSERT INTO ejd_distribucion VALUES (2,202,TO_DATE('01-04-2017'),TO_DATE('31-10-2017'));

INSERT INTO ejd_distribucion VALUES (1,203,TO_DATE('01-08-2017'),TO_DATE('31-01-2018'));
INSERT INTO ejd_distribucion VALUES (6,203,TO_DATE('21-10-2017'),TO_DATE('31-01-2018'));

INSERT INTO ejd_distribucion VALUES (4,204,TO_DATE('21-10-2017'),TO_DATE('31-10-2017'));
INSERT INTO ejd_distribucion VALUES (5,204,TO_DATE('21-10-2017'),TO_DATE('31-01-2018'));
INSERT INTO ejd_distribucion VALUES (6,204,TO_DATE('21-10-2017'),TO_DATE('31-01-2018'));

COMMIT;

---1---
SELECT DISTINCT c.idCliente, c.nombre
FROM ejd_cliente c JOIN ejd_proyecto p ON c.idCliente = p.idCliente
JOIN ejd_distribucion d ON p.idProyecto = d.idProyecto
JOIN ejd_empleado e ON d.idEmpleado = e.idEmpleado
WHERE e.fecContrato < TO_DATE('01-01-2017');

---2---
SELECT distinct e.idEmpleado, e.nombre
from ejd_empleado e where e.idEmpleado not in
    (SELECT d.idEmpleado
     FROM ejd_cliente c JOIN ejd_proyecto p ON c.idCliente = p.idCliente
     JOIN ejd_distribucion d ON p.idProyecto = d.idProyecto
     WHERE c.nombre = 'Movigas');

---3---
SELECT c.idCliente, c.nombre
FROM ejd_cliente c JOIN ejd_proyecto p ON c.idCliente = p.idCliente
WHERE p.idProyecto IN 
      (SELECT d2.idProyecto
      FROM ejd_distribucion d2
      JOIN ejd_empleado e2 ON d2.idEmpleado = e2.idEmpleado
      WHERE e2.nombre = 'Astrid Almendros')
AND p.idProyecto IN 
      (SELECT d2.idProyecto
      FROM ejd_distribucion d2
      JOIN ejd_empleado e2 ON d2.idEmpleado = e2.idEmpleado
      WHERE e2.nombre = 'Manuel Sanchez');
      
---4---
SELECT p.idProyecto, c.nombre
FROM ejd_proyecto p JOIN ejd_cliente c ON p.idCliente = c.idCliente
WHERE NOT EXISTS
      (SELECT e2.idEmpleado
      FROM ejd_empleado e2 JOIN ejd_distribucion d2 ON e2.idEmpleado = d2.idEmpleado
      JOIN ejd_proyecto p2 ON d2.idProyecto = p2.idProyecto
      WHERE e2.fecContrato <= p2.fecInicio
      AND p2.idProyecto = p.idProyecto);
      
---5---
SELECT p.idProyecto, e.nombre, e.salario
FROM EJD_PROYECTO p JOIN EJD_DISTRIBUCION d ON p.idProyecto = d.IDPROYECTO
JOIN EJD_EMPLEADO e ON e.IDEMPLEADO = d.IDEMPLEADO
where e.salario > (SELECT AVG(e2.salario)
                   FROM ejd_empleado e2 JOIN EJD_DISTRIBUCION d2 ON e2.idEmpleado = d2.idEmpleado
                   JOIN EJD_PROYECTO p2 ON d2.idproyecto = p2.idproyecto
                   where p.idproyecto = p2.IDPROYECTO);
                   
---6---              
SELECT p.idProyecto, COUNT(DISTINCT e.idEmpleado), p.area
FROM ejd_proyecto p JOIN ejd_distribucion d ON d.idProyecto = p.idProyecto
JOIN ejd_empleado e ON e.idEmpleado = d.idEmpleado
GROUP BY (p.area, p.idProyecto)
HAVING COUNT(DISTINCT e.idEmpleado) >= ALL
       (SELECT COUNT(DISTINCT e2.idEmpleado)
       FROM ejd_proyecto p2
       JOIN ejd_distribucion d2 ON d2.idProyecto = p2.idProyecto
       JOIN ejd_empleado e2 ON e2.idEmpleado = d2.idEmpleado
       GROUP BY p2.area, p2.idProyecto
       HAVING p2.area = p.area);
       
---7---
SELECT DISTINCT e.nombre, NVL(actuales.nombre,'DISPONIBLE')
FROM ejd_empleado e
LEFT JOIN
     (SELECT d.idEmpleado, c.nombre
     FROM ejd_distribucion d
     JOIN ejd_proyecto p ON d.idProyecto = p.idProyecto
     JOIN ejd_cliente c ON p.idCliente = c.idCliente
     WHERE SYSDATE BETWEEN d.fecInicio AND d.fecFin) actuales
ON actuales.idEmpleado = e.idEmpleado;

---8---
SELECT c.idCliente, c.nombre, sum(e.salario)
FROM ejd_cliente c JOIN ejd_proyecto p ON c.idCliente = p.idCliente
JOIN ejd_distribucion d ON p.idProyecto = d.idProyecto
JOIN ejd_empleado e ON d.idEmpleado = e.idEmpleado
WHERE d.fecInicio <= TO_DATE('30-11-2017') AND d.fecFin >= TO_DATE('1-11-2017')
GROUP BY c.idCliente, c.nombre
HAVING sum(p.presupuesto) > 100000;
