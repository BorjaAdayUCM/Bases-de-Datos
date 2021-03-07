set linesize 300;
SET SERVEROUTPUT ON;
alter session set nls_date_format='DD/MM/YYYY HH24:MI';

DROP TABLE VENTA CASCADE CONSTRAINTS;
DROP TABLE PASE CASCADE CONSTRAINTS;
DROP TABLE SALA CASCADE CONSTRAINTS;
DROP TABLE CINE CASCADE CONSTRAINTS;

CREATE TABLE CINE (
  IdCine VARCHAR2(5) PRIMARY KEY,
  Direccion VARCHAR2(40)
);

CREATE TABLE SALA (
  IdCine VARCHAR2(5) REFERENCES CINE,
  NumSala NUMBER(3),
  Aforo NUMBER(4),
  CONSTRAINT PK_SALA PRIMARY KEY (IdCine, NumSala)
);

CREATE TABLE PASE (
  IdCine VARCHAR2(5),
  NumSala NUMBER(3),
  HoraIni DATE,
  Titulo VARCHAR2(40),
  EntradasVendidas NUMBER(4) DEFAULT 0 NOT NULL,
  CONSTRAINT FK_PASE_SALA FOREIGN KEY (IdCine, NumSala) REFERENCES SALA,
  CONSTRAINT PK_PASE PRIMARY KEY (IdCine, NumSala, HoraIni)
);

CREATE TABLE VENTA(
  IdVenta VARCHAR2(5) PRIMARY KEY,
  IdCine VARCHAR2(5),
  NumSala NUMBER(3),
  HoraIni DATE,
  NumEntradas NUMBER(4),
  CONSTRAINT FK_VENTA_PASE FOREIGN KEY (IdCine, NumSala, HoraIni) REFERENCES PASE,
  CONSTRAINT CK_VENTA CHECK (NumEntradas > 0)
);

INSERT INTO CINE VALUES ('37','Conde de Peñalver, 44');
INSERT INTO CINE VALUES ('44','Princesa, 25');

INSERT INTO SALA VALUES ('37',1, 250);
INSERT INTO SALA VALUES ('37',2, 350);
INSERT INTO SALA VALUES ('37',3, 185);
INSERT INTO SALA VALUES ('44',1, 125);
INSERT INTO SALA VALUES ('44',2, 97);

INSERT INTO PASE VALUES ('37', 1, TO_CHAR('15-01-2018 15:30'), 'Lo que el viento se llevo', 1);
INSERT INTO PASE VALUES ('37', 1, TO_CHAR('15-01-2018 22:30'), 'La reina de Africa', 1);
INSERT INTO PASE VALUES ('37',2, TO_CHAR('15-01-2018 16:00'), 'George de la jungla', 1);
INSERT INTO PASE VALUES ('37',3, TO_CHAR('15-01-2018 22:00'), 'Miguel Strogoff', 1);
INSERT INTO PASE VALUES ('44',1, TO_CHAR('15-01-2018 15:00'), 'La guerra de las galaxias', 84);
INSERT INTO PASE VALUES ('44',1, TO_CHAR('15-01-2018 18:00'), 'El imperio contraataca', 60);
INSERT INTO PASE VALUES ('44',1, TO_CHAR('15-01-2018 21:00'), 'El retorno del Jedi', 88);
INSERT INTO PASE VALUES ('44',2, TO_CHAR('15-01-2018 18:00'), 'La casa de la pradera: la pelicula', 25);

COMMIT;

---1a---
CREATE OR REPLACE PROCEDURE PasesSala(idCineIn CINE.IDCINE%TYPE, numSalaIn sala.numSala%type) is
    cursor cr_cursor is
        SELECT p.titulo, p.HoraIni, s.Aforo - p.EntradasVendidas as Entradas
        from pase p join sala s on s.numSala = p.numSala
        where s.idCine = idCineIn and s.numSala = numSalaIn and p.idCine = IdCineIn;
BEGIN
    FOR r_cursor in cr_cursor loop
       DBMS_OUTPUT.PUT_LINE('Titulo: ' || r_cursor.titulo || ', Hora: ' || r_cursor.HoraIni || ', Entradas disponibles: ' || r_cursor.Entradas);
    END LOOP;
END;
/

BEGIN
    PasesSala(37,1);
END;
/
        
CREATE OR REPLACE PROCEDURE Cartelera(idCineIn CINE.IDCINE%TYPE) is
    cursor cr_cursorcine is
        SELECT c.direccion
        from cine c
        where c.idCine = idCineIN;
    cursor cr_cursorsala is
        SELECT s.numSala
        from cine c join sala s on c.IDCINE = s.IDCINE
        where c.idCine = idCineIN;
BEGIN
    FOR r_cursorcine in cr_cursorcine loop
       DBMS_OUTPUT.PUT_LINE('Cine: ' || r_cursorcine.direccion);
       FOR r_cursorsala in cr_cursorsala loop
            DBMS_OUTPUT.PUT_LINE('Sala: ' || r_cursorsala.numSala);
            PasesSala(IdCineIn, r_cursorsala.numSala);
       END LOOP;
    END LOOP;
END;
/

begin
    cartelera(44);
end;
/


---2---
CREATE OR REPLACE TRIGGER ActualizaEntradasVendidas
AFTER INSERT or DELETE or UPDATE
ON venta
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE pase p SET p.EntradasVendidas = p.entradasVendidas + :new.numEntradas where p.IDCINE = :new.idCine and p.NUMSALA = :new.numSala and p.HORAINI = :new.HoraIni;
    ELSIF DELETING THEN
        UPDATE pase p SET p.EntradasVendidas = p.entradasVendidas - :old.numEntradas where p.IDCINE = :old.idCine and p.NUMSALA = :old.numSala and p.HORAINI = :old.HoraIni;
    ELSIF UPDATING THEN
        UPDATE pase p SET p.EntradasVendidas = p.entradasVendidas - :old.numEntradas + :new.numEntradas where p.IDCINE = :old.idCine and p.NUMSALA = :old.numSala and p.HORAINI = :old.HoraIni;
    END IF;
END;
/
  
insert into venta values('1', '37', 1, TO_DATE('15-01-2018 15:30'), 4);

update venta set VENTA.NUMENTRADAS = 2 where venta.IDVENTA = 1;

delete venta;

SELECT pa.idCine, count(*)
from cine c
left outer join pase pa on pa.IDCINE = c.IDCINE
where pa.entradasvendidas > 0
group by pa.idCine;

CREATE OR REPLACE PROCEDURE CINESALA(codCineIn CINE.IDCINE%type) is
    cursor cr_cursor is
        SELECT distinct pa.horaIni, pa.numSala, pa.Titulo, s.aforo - pa.EntradasVendidas as rest
        from pase pa
        join sala s on pa.IDCINE = s.IDCINE and s.NUMSALA = pa.numSala
        where pa.IDCINE = codCineIn
        order by pa.numSala;
    NumSalas integer := 0;
    AforoTotal integer := 0;
BEGIN
    SELECT count(s.numSala) into NumSalas from cine c join sala s on c.IDCINE = s.IDCINE where c.IDCINE = codCineIn group by c.IDCINE;
    SELECT sum(s.aforo) into aforoTotal from cine c join sala s on c.IDCINE = s.IDCINE where c.IDCINE = codCineIn group by c.IDCINE;
    DBMS_OUTPUT.PUT_LINE('Codigo de Cine: ' || codCineIn || ' Numero de salas: ' || NumSalas || ' Aforo Total: ' || AforoTotal);
    FOR r_cursor in cr_cursor loop
         DBMS_OUTPUT.PUT_LINE('Hora: ' || r_cursor.horaIni || ' Numero de sala: ' || r_cursor.numSala || ' Titulo: ' || r_cursor.titulo || ' Entradas disponibles: ' || r_cursor.rest);
    end loop;
END;
/
        
begin
    cinesala('37');
end;
/

create or replace TRIGGER creditosAprobados
AFTER INSERT OR DELETE OR UPDATE OF Nota ON Matricula
FOR EACH ROW
DECLARE
NumCred Asignatura.NumCreditos%TYPE; -- Num creditos a sumar/restar
BEGIN
IF INSERTING THEN
    SELECT asignatura.numCreditos into numCred from asignatura where asignatura.codigo = :new.codigoAsignatura;
    if (:new.nota >= 5) then
        UPDATE ALUMNO SET alumno.creditosaprobados = alumno.creditosaprobados + numCred where alumno.DniAlumno = :new.DniAlumno;
    end if;
ELSIF DELETING then
    SELECT asignatura.numCreditos into numCred from asignatura where asignatura.codigo = :new.codigoAsignatura;
    if (:old.nota >= 5) then
        UPDATE ALUMNO SET alumno.creditosaprobados = alumno.creditosaprobados - numCred where alumno.DniAlumno = :old.DniAlumno;
    end if;
ELSIF UPDATING THEN
    SELECT asignatura.numCreditos into numCred from asignatura where asignatura.codigo = :new.codigoAsignatura;
    if (:old.nota < 5 and :new.nota >= 5) then
        UPDATE ALUMNO SET alumno.creditosaprobados = alumno.creditosaprobados + numCred where alumno.DniAlumno = :new.DniAlumno;
    elsif (:old.nota >= 5 and :new.nota < 5) then
         UPDATE ALUMNO SET alumno.creditosaprobados = alumno.creditosaprobados - numCred where alumno.DniAlumno = :new.DniAlumno;
    end if;
END IF;
END;
/
