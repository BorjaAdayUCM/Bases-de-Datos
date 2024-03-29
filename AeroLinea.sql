alter session set nls_date_format='DD/MM/YYYY';

drop table vuelo cascade constraints;
drop table avion cascade constraints;
drop table empleado cascade constraints;
drop table certificado cascade constraints;

create table vuelo(
	flno number(4,0) primary key,
	origen varchar2(20),
	destino varchar2(20),
	distancia number(6,0),
	salida date,
	llegada date,
	precio number(7,2));

create table avion(
	aid number(9,0) primary key,
	nombre varchar2(30),
	autonomia number(6,0));

create table empleado(
	eid number(9,0) primary key,
	nombre varchar2(30),
	salario number(10,2));

create table certificado(
	eid number(9,0),
	aid number(9,0),
	primary key(eid,aid),
	foreign key(eid) references empleado,
	foreign key(aid) references avion); 



INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (99.0,'Los Angeles','Washington D.C.',2308.0,to_date('04/12/2005 09:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:40', 'dd/mm/yyyy HH24:MI'),235.98);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (13.0,'Los Angeles','Chicago',1749.0,to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (346.0,'Los Angeles','Dallas',1251.0,to_date('04/12/2005 11:50', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),225-43);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (387.0,'Los Angeles','Boston',2606.0,to_date('04/12/2005 07:03', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 05:03', 'dd/mm/yyyy HH24:MI'),261.56);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (7.0,'Los Angeles','Sydney',7487.0,to_date('04/12/2005 05:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:10', 'dd/mm/yyyy HH24:MI'),278.56);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (2.0,'Los Angeles','Tokyo',5478.0,to_date('04/12/2005 06:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:55', 'dd/mm/yyyy HH24:MI'),780.99);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (33.0,'Los Angeles','Honolulu',2551.0,to_date('04/12/2005 09:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:15', 'dd/mm/yyyy HH24:MI'),375.23);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (34.0,'Los Angeles','Honolulu',2551.0,to_date('04/12/2005 12:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:18', 'dd/mm/yyyy HH24:MI'),425.98);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (76.0,'Chicago','Los Angeles',1749.0,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:03', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (68.0,'Chicago','New York',802.0,to_date('04/12/2005 09:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:02', 'dd/mm/yyyy HH24:MI'),202.45);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (7789.0,'Madison','Detroit',319.0,to_date('04/12/2005 06:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:19', 'dd/mm/yyyy HH24:MI'),120.33);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (701.0,'Detroit','New York',470.0,to_date('04/12/2005 08:55', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:26', 'dd/mm/yyyy HH24:MI'),180.56);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (702.0,'Madison','New York',789.0,to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),202.34);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (4884.0,'Madison','Chicago',84.0,to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:02', 'dd/mm/yyyy HH24:MI'),112.45);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (2223.0,'Madison','Pittsburgh',517.0,to_date('04/12/2005 08:02', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:01', 'dd/mm/yyyy HH24:MI'),189.98);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (5694.0,'Madison','Minneapolis',247.0,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:33', 'dd/mm/yyyy HH24:MI'),120.11);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (304.0,'Minneapolis','New York',991.0,to_date('04/12/2005 10:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 01:39', 'dd/mm/yyyy HH24:MI'),101.56);

INSERT INTO VUELO (FLNO, ORIGEN, DESTINO, DISTANCIA, SALIDA, LLEGADA, PRECIO) VALUES (149.0,'Pittsburgh','New York',303.0,to_date('04/12/2005 09:42', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:09', 'dd/mm/yyyy HH24:MI'),1165.00);

Insert into AVION (AID,NOMBRE,AUTONOMIA) values ('1','Boeing 747-400','8430');
Insert into AVION (AID,NOMBRE,AUTONOMIA) values ('3','Airbus A340-300','7120');
Insert into AVION (AID,NOMBRE,AUTONOMIA) values ('4','British Aerospace Jetstream 41','1502');
Insert into AVION (AID,NOMBRE,AUTONOMIA) values ('5','Embraer ERJ-145','1530');
Insert into AVION (AID,NOMBRE,AUTONOMIA) values ('7','Piper Archer III','520');


Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('567354612','Lisa Walker','256481');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('254099823','Patricia Jones','223000');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('355548984','Angela Martinez','212156');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('310454876','Joseph Thompson','212156');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('269734834','George Wright','289950');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('552455348','Dorthy Lewis','251300');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('486512566','David Anderson','43001');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('573284895','Eric Cooper','114323');
Insert into EMPLEADO (EID,NOMBRE,SALARIO) values ('574489457','Milo Brooks','20');


Insert into CERTIFICADO (EID,AID) values ('269734834','1');
Insert into CERTIFICADO (EID,AID) values ('269734834','3');
Insert into CERTIFICADO (EID,AID) values ('269734834','4');
Insert into CERTIFICADO (EID,AID) values ('269734834','5');
Insert into CERTIFICADO (EID,AID) values ('269734834','7');
Insert into CERTIFICADO (EID,AID) values ('567354612','1');
Insert into CERTIFICADO (EID,AID) values ('567354612','3');
Insert into CERTIFICADO (EID,AID) values ('567354612','4');
Insert into CERTIFICADO (EID,AID) values ('567354612','5');
Insert into CERTIFICADO (EID,AID) values ('567354612','7');
Insert into CERTIFICADO (EID,AID) values ('573284895','3');
Insert into CERTIFICADO (EID,AID) values ('573284895','4');
Insert into CERTIFICADO (EID,AID) values ('573284895','5');
Insert into CERTIFICADO (EID,AID) values ('574489457','7');

commit;

---1---
SELECT DISTINCT EMPLEADO.EID, EMPLEADO.NOMBRE
FROM EMPLEADO
JOIN CERTIFICADO
ON EMPLEADO.EID = CERTIFICADO.EID
JOIN AVION
ON AVION.AID = CERTIFICADO.AID
WHERE Avion.nombre like '%Boeing%';

---2---
SELECT Avion.aid, Avion.nombre
FROM Avion
WHERE Avion.AUTONOMIA > (Select VUELO.DISTANCIA from vuelo where VUELO.ORIGEN = 'Los Angeles' and VUELO.DESTINO = 'Chicago');

---3---
SELECT DISTINCT EMPLEADO.EID, EMPLEADO.NOMBRE
FROM EMPLEADO
JOIN CERTIFICADO
ON EMPLEADO.EID = CERTIFICADO.EID
JOIN AVION
ON AVION.AID = CERTIFICADO.AID
WHERE Avion.autonomia > 3000 AND Empleado.eid NOT IN
                                                    (SELECT DISTINCT EMPLEADO.EID
                                                    FROM EMPLEADO
                                                    JOIN CERTIFICADO
                                                    ON EMPLEADO.EID = CERTIFICADO.EID
                                                    JOIN AVION
                                                    ON AVION.AID = CERTIFICADO.AID
                                                    WHERE Avion.nombre like '%Boeing%');

---4---
SELECT EID, NOMBRE, SALARIO
FROM EMPLEADO
WHERE SALARIO = (SELECT MAX(SALARIO) FROM EMPLEADO);

---5---
select distinct *
from EMPLEADO
where  EMPLEADO.SALARIO = (select max(EMPLEADO.SALARIO) from EMPLEADO where ((EMPLEADO.SALARIO) < (select max(EMPLEADO.SALARIO) from EMPLEADO)));

---6---
select EMPLEADO.EID, EMPLEADO.NOMBRE, count(CERTIFICADO.EID) as "Numero certificaciones"
from EMPLEADO
join CERTIFICADO
on EMPLEADO.EID = CERTIFICADO.EID
group by (EMPLEADO.EID, EMPLEADO.NOMBRE)
having count(CERTIFICADO.EID) =  (SELECT MAX(maximo) from (SELECT CERTIFICADO.eid, count(certificado.aid) as maximo FROM Certificado group by EID));

---7---
select EMPLEADO.EID, EMPLEADO.NOMBRE, count(CERTIFICADO.EID) as "Numero certificaciones"
from EMPLEADO
join CERTIFICADO
on EMPLEADO.EID = CERTIFICADO.EID
group by (EMPLEADO.EID, EMPLEADO.NOMBRE, CERTIFICADO.EID)
having count(CERTIFICADO.EID) >= 3;

---8---
select distinct avion.aid, avion.nombre
from avion
join certificado
on avion.AID = certificado.aid
join empleado
on empleado.eid = certificado.eid
where avion.aid not in
                      (select distinct avion.aid
                      from avion
                      join certificado
                      on avion.AID = certificado.aid
                      join empleado
                      on empleado.eid = certificado.eid
                      where empleado.salario <= 80000);

---9---
select EMPLEADO.EID, EMPLEADO.NOMBRE, max(avion.AUTONOMIA) as "Autonom�a M�xima"
from EMPLEADO
join CERTIFICADO
on EMPLEADO.EID = CERTIFICADO.EID
join avion
on CERTIFICADO.AID = avion.AID
group by (EMPLEADO.EID, EMPLEADO.NOMBRE)
having count(CERTIFICADO.EID) > 3;

---10---
SELECT EMPLEADO.eid, Empleado.nombre, empleado.Salario
from empleado
where empleado.salario < (SELECT MIN(PRECIO) FROM VUELO WHERE  VUELO.ORIGEN = 'Los Angeles' and VUELO.DESTINO = 'Honolulu');

---11---
SELECT AVION.AID, avion.nombre, round(avg(empleado.salario),2) as "Salario Medio"
from EMPLEADO
join CERTIFICADO
on EMPLEADO.EID = CERTIFICADO.EID
join avion
on CERTIFICADO.AID = avion.AID
where avion.autonomia > 1000
group by (avion.aid, avion.nombre);

---12---
SELECT round(MediaEmpleado - MediaPiloto, 2) as Diferencia from
(SELECT AVG( distinct empleado.salario) as MediaPiloto from empleado join certificado on empleado.EID = certificado.EID),
(SELECT AVG(empleado.salario) as MediaEmpleado from empleado);

---13---
SELECT EMPLEADO.EID, empleado.nombre
from empleado
where empleado.salario > (SELECT AVG(distinct empleado.salario) as MediaPiloto from empleado join certificado on empleado.EID = certificado.EID)
and empleado.eid not in
                       (SELECT EMPLEADO.EID
                       from empleado 
                       join certificado 
                       on empleado.EID = certificado.EID);

---14---
SELECT DISTINCT EMPLEADO.EID, empleado.nombre
from empleado
join certificado
on empleado.EID = certificado.EID
where empleado.eid not in
                        (SELECT EMPLEADO.EID
                        from empleado
                        join certificado
                        on empleado.EID = certificado.EID
                        join AVION
                        on AVION.AID = certificado.AID
                        where avion.autonomia <= 1000);