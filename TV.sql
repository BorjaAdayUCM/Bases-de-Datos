DROP TABLE ejb_programacion CASCADE CONSTRAINTS;
DROP TABLE ejb_canal CASCADE CONSTRAINTS;
DROP TABLE ejb_programa CASCADE CONSTRAINTS;

CREATE TABLE ejb_programa (
       codPrograma NUMBER(4,0) PRIMARY KEY,
       titulo VARCHAR2(50),
       duracion NUMBER(4,0), -- duracion en minutos.
       tipo VARCHAR2(20)     -- Puede ser 'documental', 'informativo', 'entretenimiento', 'deporte', 'ficcion'
);

CREATE TABLE ejb_canal (
       idCanal NUMBER(4,0) PRIMARY KEY,
       nombre VARCHAR2(50)
);

CREATE TABLE ejb_programacion (
       idEmision NUMBER(10,0) PRIMARY KEY,
       codPrograma NUMBER(4,0) REFERENCES ejb_programa,
       idCanal NUMBER(4,0) REFERENCES ejb_canal,
       fec_hora DATE -- fecha y hora de emision.
);

INSERT INTO ejb_programa VALUES (1,'Lo que el viento se llevo', 238, 'ficcion');
INSERT INTO ejb_programa VALUES (2,'Juego de trinos. T1 Ep1', 55, 'ficcion');
INSERT INTO ejb_programa VALUES (3,'Juego de trinos. T1 Ep2', 51, 'ficcion');
INSERT INTO ejb_programa VALUES (4,'Juego de trinos. T1 Ep3', 53, 'ficcion');
INSERT INTO ejb_programa VALUES (5,'Juego de trinos. T1 Ep4', 58, 'ficcion');
INSERT INTO ejb_programa VALUES (6,'Juego de trinos. T1 Ep5', 52, 'ficcion');
INSERT INTO ejb_programa VALUES (7,'Juego de trinos. T1 Ep6', 53, 'ficcion');
INSERT INTO ejb_programa VALUES (8,'Juego de trinos. T1 Ep7', 55, 'ficcion');
INSERT INTO ejb_programa VALUES (9,'Inocente o culpable', 280, 'entretenimiento');
INSERT INTO ejb_programa VALUES (10,'La vida secreta de las plantas', 47, 'documental');
INSERT INTO ejb_programa VALUES (11,'Los misterios del ultimo emperador', 58, 'documental');
INSERT INTO ejb_programa VALUES (12,'El cultivo del champignon', 33, 'documental');
INSERT INTO ejb_programa VALUES (13,'Incredible sushi made easy', 64, 'documental');

INSERT INTO ejb_canal VALUES (1, 'Channel one');
INSERT INTO ejb_canal VALUES (2, 'La de los documentales');
INSERT INTO ejb_canal VALUES (3, 'Canal gastro');
INSERT INTO ejb_canal VALUES (4, 'Todo series');
INSERT INTO ejb_canal VALUES (6, 'Antena Sexta');

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
INSERT INTO ejb_programacion VALUES (1,1,1,TO_DATE('18-12-2017 23:00:00'));
INSERT INTO ejb_programacion VALUES (2,1,6,TO_DATE('21-12-2017 16:15:00'));
INSERT INTO ejb_programacion VALUES (3,9,6,TO_DATE('21-12-2017 19:10:00'));

INSERT INTO ejb_programacion VALUES (4,10,2,TO_DATE('18-12-2017 16:10:00'));
INSERT INTO ejb_programacion VALUES (5,11,2,TO_DATE('25-12-2017 15:35:00'));
INSERT INTO ejb_programacion VALUES (6,12,2,TO_DATE('27-12-2017 14:00:00'));
INSERT INTO ejb_programacion VALUES (7,13,2,TO_DATE('28-12-2017 19:30:00'));

INSERT INTO ejb_programacion VALUES (8,12,1,TO_DATE('28-12-2017 08:30:00'));
INSERT INTO ejb_programacion VALUES (9,11,1,TO_DATE('28-12-2017 10:30:00'));
INSERT INTO ejb_programacion VALUES (10,13,1,TO_DATE('28-12-2017 12:30:00'));

INSERT INTO ejb_programacion VALUES (11,12,6,TO_DATE('31-12-2017 23:30:00'));

INSERT INTO ejb_programacion VALUES (13,2,4,TO_DATE('21-12-2017 21:30:00'));
INSERT INTO ejb_programacion VALUES (14,3,4,TO_DATE('22-12-2017 21:30:00'));
INSERT INTO ejb_programacion VALUES (15,4,4,TO_DATE('23-12-2017 21:30:00'));
INSERT INTO ejb_programacion VALUES (16,5,4,TO_DATE('24-12-2017 21:30:00'));
INSERT INTO ejb_programacion VALUES (17,6,4,TO_DATE('25-12-2017 21:30:00'));
INSERT INTO ejb_programacion VALUES (18,7,4,TO_DATE('26-12-2017 21:30:00'));

COMMIT;

---1---
SELECT c.idCanal, c.nombre, sum(p.duracion) as "Tiempo total"
from EJB_CANAL c join EJB_PROGRAMACION pm on pm.IDCANAL = c.IDCANAL
join EJB_PROGRAMA p on pm.CODPROGRAMA = p.CODPROGRAMA
where p.TIPO = 'documental' and EXTRACT (MONTH from pm.fec_hora) = 12 and extract (YEAR from pm.fec_hora) = 2017
group by c.idCanal, c.nombre
having count(c.nombre) > 3;

---2---
SELECT c.idCanal, c.nombre
FROM ejb_canal c JOIN ejb_programacion pr ON c.idCanal = pr.idCanal
JOIN ejb_programa pg ON pr.codPrograma = pg.codPrograma
WHERE pg.tipo = 'documental'
GROUP BY TO_CHAR(pr.fec_hora, 'DD-MM-YYYY'), c.nombre, c.idcanal
HAVING COUNT(DISTINCT pg.codPrograma) > 2;

---3---
SELECT c.nombre, p.titulo, p.duracion
from EJB_CANAL c join EJB_PROGRAMACION pm on pm.IDCANAL = c.IDCANAL
join EJB_PROGRAMA p on p.CODPROGRAMA = pm.CODPROGRAMA
where p.DURACION > (SELECT duracion from EJB_PROGRAMA p2 where p2.TITULO = 'Lo que el viento se llevo');

---4---
SELECT p.codprograma, p.TITULO from ejb_programa p 
where p.tipo = 'documental' and p.codPrograma not in
                                                    (SELECT pm2.codPrograma
                                                    from ejb_programacion pm2 join ejb_canal c2 on pm2.IDCANAL = c2.IDCANAL
                                                    where c2.nombre = 'Antena Sexta');
                                                    
---5---
SELECT distinct p.titulo, c.NOMBRE
from EJB_PROGRAMA p join EJB_PROGRAMACION pm on pm.CODPROGRAMA = p.CODPROGRAMA
join EJB_CANAL c on pm.IDCANAL = c.IDCANAL
where p.duracion > (SELECT AVG(p2.duracion) from EJB_PROGRAMA p2 join EJB_PROGRAMACION pm2 on pm2.CODPROGRAMA = p2.CODPROGRAMA
                    join EJB_CANAL c2 on pm2.IDCANAL = c2.IDCANAL
                    where c.idCanal = c2.idCanal);

---6---
SELECT distinct p.titulo, p.duracion, p.tipo
from EJB_PROGRAMA p join EJB_PROGRAMACION pm on pm.CODPROGRAMA = p.CODPROGRAMA
where p.DURACION = (SELECT MAX(p2.duracion)
                    from EJB_PROGRAMA p2 join EJB_PROGRAMACION pm2 on p2.CODPROGRAMA = pm2.CODPROGRAMA
                    where p.tipo = p2.tipo and extract (month from pm.fec_hora) = extract (month from pm2.fec_hora)and EXTRACT(YEAR FROM pm.fec_hora) = EXTRACT(YEAR FROM pm2.fec_hora));

---7---
SELECT p.titulo, NVL(c.nombre, 'NO EMITIDO') as Canal, pm.fec_hora
FROM ejb_programa p LEFT JOIN (ejb_canal c JOIN ejb_programacion pm ON c.idCanal = pm.idCanal)
ON p.codPrograma = pm.codPrograma;

---8---
SELECT pr1.codprograma, pr1.fec_hora, pr2.codprograma, pr2.fec_hora, c.nombre
FROM ejb_programacion pr1 JOIN ejb_canal c ON pr1.idCanal = c.idCanal
JOIN ejb_programacion pr2 ON c.idCanal = pr2.idCanal
JOIN ejb_programa pg ON pr1.codPrograma = pg.codPrograma
WHERE pr1.idEmision != pr2.idEmision
AND pr1.fec_hora <= pr2.fec_hora
AND pr1.fec_hora + pg.duracion/1440 > pr2.fec_hora;