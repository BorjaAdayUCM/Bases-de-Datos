DROP TABLE TRAYECTOS;
DROP TABLE CONTRATOS;

CREATE TABLE Contratos(
Referencia VARCHAR(10) PRIMARY KEY,
Empresa VARCHAR(100),
Fecha DATE,
NumTrayectos NUMBER(2,0)
);

CREATE TABLE Trayectos(
Referencia VARCHAR(10) REFERENCES Contratos ON DELETE CASCADE,
Origen VARCHAR(50),
Destino VARCHAR(50),
Vehiculo VARCHAR(20),
PRIMARY KEY (Referencia, Origen, Destino)
);

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

INSERT INTO CONTRATOS VALUES ('1', 'Monstruos S.A.', TO_DATE('27-01-1971'), 0);
INSERT INTO CONTRATOS VALUES ('2', 'Respira S.A', TO_DATE('03-02-2009'), 0);
INSERT INTO CONTRATOS VALUES ('3', 'Hola S.A.', TO_DATE('07-03-1998'), 0);
INSERT INTO CONTRATOS VALUES ('4', 'Camina S.A.', TO_DATE('28-04-2005'), 0);

INSERT INTO Trayectos VALUES ('1', 'Casa Borja', 'Casa Bryan', 'Land Rover');
INSERT INTO Trayectos VALUES ('1', 'Cas Borja', 'Casa Bryan', 'Land Rover');
INSERT INTO Trayectos VALUES ('2', 'Casa Bryan', 'Casa Borja', 'Land Rover');
INSERT INTO Trayectos VALUES ('3', 'Casa Borja', 'Casa Andrea', 'Toyota');
INSERT INTO Trayectos VALUES ('4', 'Casa Andrea', 'Casa Borja', 'Toyota');

DELETE CONTRATOS;
DELETE TRAYECTOS;

COMMIT;


---a--- PUTA MIERDA PUTA MIEEEEEEEEEEEEEEEEEERDAAAAAAAAAAAAAAAAAAAAAAA
CREATE OR REPLACE PROCEDURE ActNumTrayectos(ReferenciaIn IN CONTRATOS.REFERENCIA%TYPE) is
    CURSOR cr_NumTrayectos is 
        SELECT c.NUMTRAYECTOS, count(c.referencia) as contador from Contratos c where c.REFERENCIA =  ReferenciaIN
            FOR UPDATE OF c.Numtrayectos;
    NoTrayectos EXCEPTION;
    NumTrayectos CONTRATOS.NUMTRAYECTOS%TYPE;
BEGIN
    FOR r_NumTrayectos in cr_NumTrayectos LOOP
        NumTrayectos := r_numTrayectos.contador;
        IF NumTrayectos = 0
        then raise NoTrayectos;
        end if;
        UPDATE contratos c SET c.NUMTRAYECTOS = (SELECT count(t.referencia) from TRAYECTOS t where t.REFERENCIA =  ReferenciaIN)
        WHERE CURRENT OF cr_NumTrayectos;
        DBMS_OUTPUT.PUT_LINE('Contrato: ' || ReferenciaIN || ', Trayectos: ');
    END LOOP;
    COMMIT;
    EXCEPTION
        WHEN NoTrayectos then
            DBMS_OUTPUT.PUT_LINE('No hay trayectos ligados a este contrato.');
END;
/

begin
    ActNumTrayectos('1');
end;
/

select * from contratos;


---b---
CREATE OR REPLACE TRIGGER ActNumTrayectos
AFTER INSERT or DELETE
ON TRAYECTOS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
    UPDATE Contratos c SET c.numtrayectos = c.numtrayectos + 1 where c.REFERENCIA = :new.referencia;
    ELSIF DELETING THEN
    UPDATE Contratos c SET c.numtrayectos = c.numtrayectos - 1 where c.REFERENCIA = :old.referencia;
    END IF;
END;
/

select * from contratos;










