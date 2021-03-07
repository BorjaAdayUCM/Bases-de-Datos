set linesize 300;
SET SERVEROUTPUT ON;
alter session set nls_date_format='DD/MM/YYYY';

DROP TABLE VENTA CASCADE CONSTRAINTS;
DROP TABLE OFERTA CASCADE CONSTRAINTS;
DROP TABLE DPTO CASCADE CONSTRAINTS;
DROP TABLE TIENDA CASCADE CONSTRAINTS;

CREATE TABLE TIENDA (
  IdTienda VARCHAR2(5) PRIMARY KEY,
  Direccion VARCHAR2(40)
);

CREATE TABLE DPTO (
  IdTienda VARCHAR2(5) REFERENCES TIENDA,
  NumDpto NUMBER(3),
  Descr VARCHAR2(40),
  CONSTRAINT PK_DPTO PRIMARY KEY (IdTienda, NumDpto)
);

CREATE TABLE OFERTA (
  IdOferta VARCHAR2(5) PRIMARY KEY,
  IdTienda VARCHAR2(5),
  NumDpto NUMBER(3),
  FechaIni DATE,
  FechaFin DATE,
  Producto VARCHAR2(40),
  UnidadesOfertadas NUMBER(4) NOT NULL,
  UnidadesVendidas NUMBER(4) DEFAULT 0 NOT NULL,
  CONSTRAINT FK_OFERTA_DPTO FOREIGN KEY (IdTienda, NumDpto) REFERENCES DPTO,
  CONSTRAINT CHK_OFERTA CHECK (UnidadesOfertadas > 0)
);

CREATE TABLE VENTA(
  IdVenta VARCHAR2(5) PRIMARY KEY,
  IdOferta VARCHAR2(5) REFERENCES OFERTA,
  FechaVenta DATE,
  Cliente VARCHAR2(40),
  NumUnidades NUMBER(4),
  CONSTRAINT CHK_VENTA CHECK (NumUnidades > 0)
);

INSERT INTO TIENDA VALUES ('37','Conde de Peñalver, 44');
INSERT INTO TIENDA VALUES ('44','Princesa, 25');

INSERT INTO DPTO VALUES ('37',1, 'Papeleria');
INSERT INTO DPTO VALUES ('37',2, 'Informatica');
INSERT INTO DPTO VALUES ('37',3, 'Imagen y sonido');
INSERT INTO DPTO VALUES ('44',1, 'Informatica');
INSERT INTO DPTO VALUES ('44',2, 'Libreria');

INSERT INTO OFERTA VALUES ('o01', '37', 1, TO_CHAR('01-02-2018'), TO_CHAR('01-02-2018'), 'Destructora de papel SuperDestroyer 60', 50, 0);
INSERT INTO OFERTA VALUES ('o02', '37', 2, TO_CHAR('15-03-2018'), TO_CHAR('15-04-2018'), 'Ordenador Victor i7 16Gb 1Tb HD', 15, 0);
INSERT INTO OFERTA VALUES ('o03', '37', 2, TO_CHAR('15-03-2018'), TO_CHAR('15-04-2018'), 'Monitor 27in 4K', 15, 0);
INSERT INTO OFERTA VALUES ('o04', '37', 3, TO_CHAR('01-02-2018'), TO_CHAR('15-05-2018'), 'Barra de sonido Megatron', 20, 0);
INSERT INTO OFERTA VALUES ('o05', '44', 1, TO_CHAR('01-02-2018'), TO_CHAR('15-04-2018'), 'Ordenador Compaq i5 8Gb 1Tb HD', 84, 0);
INSERT INTO OFERTA VALUES ('o06', '44', 1, TO_CHAR('01-02-2018'), TO_CHAR('15-02-2018'), 'Impresora Saikushi 3000', 20, 0);
INSERT INTO OFERTA VALUES ('o07', '44', 2, TO_CHAR('01-02-2018'), TO_CHAR('15-02-2018'), 'Tetralogia El anillo', 25, 0);

---1a---
CREATE OR REPLACE PROCEDURE OfertasFecha(idTiendaIn tienda.idtienda%type, numDptoIn dpto.numDpto%type, FechaFinOfertaIn VENTA.FECHAVENTA%type) is
    cursor cr_cursor is
        SELECT o.idOferta, o.producto, o.FechaFin, o.UnidadesOfertadas - o.UnidadesVendidas as Disponibles
        from oferta o
        where o.idTienda = idTiendaIn and o.numDpto = numDptoIn and o.FechaFin > FechaFinOfertaIn and o.FECHAINI < FechaFinOfertaIn
        order by o.FECHAINI;
    numOfertas INTEGER := 0;
BEGIN
    FOR r_cursor in cr_cursor loop
        numOfertas := numOfertas + 1;
        DBMS_OUTPUT.PUT_LINE('idOferta: ' || r_cursor.idOferta || ' Producto: ' || r_cursor.producto || ' Fecha Fin: ' || r_cursor.FechaFin || ' Disponibles: ' || r_cursor.Disponibles);
    END LOOP;
    IF (numOfertas = 0)
    THEN DBMS_OUTPUT.PUT_LINE('No hay ofertas.');
    END IF;
END;
/

begin
    OfertasFecha('37', 3, TO_date('30-03-2018'));
end;
/

---1b---
CREATE OR REPLACE PROCEDURE OfertasTienda(idTiendaIn tienda.idtienda%type, FechaFinOfertaIn VENTA.FECHAVENTA%type) is
    cursor cr_cursor is
        SELECT dpto.numdpto
        from dpto
        where dpto.idTienda = idTiendaIn;
    direccion TIENDA.DIRECCION%type;
BEGIN
    SELECT tienda.direccion into direccion from tienda where tienda.idTienda = idTiendaIn;
    DBMS_OUTPUT.PUT_LINE(direccion);
    FOR r_cursor in cr_cursor loop
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || r_cursor.numDpto);
        OfertasFecha(idTiendaIn, r_cursor.numDpto, FechaFinOfertaIn);
    END LOOP;
END;
/

begin
    OfertasTienda('37', TO_date('30-03-2018'));
end;
/


---2---
CREATE OR REPLACE TRIGGER ActualizaUnidadesVendidas
After insert or update or delete
on venta
for each row
begin
    if INSERTING then
        update oferta o set o.unidadesvendidas = o.unidadesvendidas + :new.numunidades where o.idoferta = :new.idOferta;
    elsif DELETING then
         update oferta o set o.unidadesvendidas = o.unidadesvendidas - :old.numunidades where o.idoferta = :old.idOferta;
    elsif updating then
         update oferta o set o.unidadesvendidas = o.unidadesvendidas - :old.numunidades where o.idoferta = :old.idOferta;
         update oferta o set o.unidadesvendidas = o.unidadesvendidas + :new.numunidades where o.idoferta = :new.idOferta;
    end if;
end;
/

INSERT INTO VENTA VALUES ('V01','o02', TO_CHAR('15-04-2018'),'Andres Garcia', 2);
INSERT INTO VENTA VALUES ('V02','o02', TO_CHAR('15-03-2018'),'Alvaro Armengol', 3);
INSERT INTO VENTA VALUES ('V03','o06', TO_CHAR('15-01-2018'),'Renato Matina', 5);

UPDATE VENTA SET IdOferta = 'o03', NumUnidades = 2 WHERE IdVenta = 'V02';  

DELETE FROM VENTA WHERE IdVenta = 'V03';
    

        
        
        
        