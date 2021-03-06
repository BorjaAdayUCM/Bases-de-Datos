--Borja Aday Guadalupe Luis
--Eduardo Bryan de Renovales Alvarado

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
SELECT ejb_canal.nombre, sum(ejb_programa.duracion) as "Tiempo Total"
from ejb_canal
join ejb_programacion 
on ejb_canal.idcanal = ejb_programacion.idcanal
join ejb_programa
on ejb_programa.codPrograma = ejb_programacion.codPrograma
where ejb_programa.tipo = 'documental' 
and extract (month from ejb_programacion.fec_hora) = 12 
and extract (year from ejb_programacion.fec_hora) = 2017
group by ejb_canal.nombre
having count (ejb_programa.codPrograma) > 3;

---2---
SELECT ejb_canal.nombre
from ejb_canal
join ejb_programacion 
on ejb_canal.idcanal = ejb_programacion.idcanal
join ejb_programa
on ejb_programa.codPrograma = ejb_programacion.codPrograma
where ejb_programa.tipo = 'documental'
group by ejb_canal.nombre
having count (distinct ejb_programa.codPrograma) > 2;

---3---
SELECT ejb_canal.nombre,ejb_programa.titulo,ejb_programa.duracion
from ejb_canal
join ejb_programacion 
on ejb_canal.idcanal = ejb_programacion.idcanal
join ejb_programa
on ejb_programa.codPrograma = ejb_programacion.codPrograma
where ejb_programa.duracion >(select ejb_programa.duracion from ejb_programa where ejb_programa.titulo = 'Lo que el viento se llevo');

---4---
SELECT ejb_programa.titulo from ejb_programa
where ejb_programa.tipo = 'documental' 
minus
SELECT ejb_programa.titulo
from ejb_canal
join ejb_programacion 
on ejb_canal.idcanal = ejb_programacion.idcanal
join ejb_programa
on ejb_programa.codPrograma = ejb_programacion.codPrograma
where ejb_programa.tipo = 'documental'and ejb_canal.nombre = 'Antena Sexta';

---5---

select P1.TITULO, C1.NOMBRE, P1.DURACION
from EJB_CANAL C1
join EJB_PROGRAMACION PR1
on C1.IDCANAL = PR1.IDCANAL
join EJB_PROGRAMA P1
on PR1.CODPROGRAMA = P1.CODPROGRAMA
where P1.DURACION > (
select avg(P2.DURACION) 
from EJB_CANAL C2
join EJB_PROGRAMACION PR2
on C2.IDCANAL = PR2.IDCANAL
join EJB_PROGRAMA P2
on PR2.CODPROGRAMA = P2.CODPROGRAMA
where  C2.IDCANAL = C1.IDCANAL);


---6---

SELECT ejb_programa1.titulo, ejb_canal1.nombre
from ejb_canal ejb_canal1
join ejb_programacion ejb_programacion1
on ejb_canal1.idcanal = ejb_programacion1.idcanal
join ejb_programa ejb_programa1
on ejb_programa1.codPrograma = ejb_programacion1.codPrograma
group by ejb_programa1.titulo, ejb_canal1.nombre
having max(
SELECT ejb_programa1.duracion

;

---7---
Select ejb_programa.titulo,ejb_programacion.fec_hora, nvl(ejb_canal.nombre, 'No emitido')
from ejb_canal
join ejb_programacion 
on ejb_canal.idcanal = ejb_programacion.idcanal
right outer join ejb_programa
on ejb_programa.codPrograma = ejb_programacion.codPrograma;

---8---



