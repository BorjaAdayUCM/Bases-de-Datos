alter session set nls_date_format='DD/MM/YYYY';

-------------------------------------------------------
-- BD del ejercicio de la Librería AllTheBooks
-------------------------------------------------------

drop table LB_Cliente cascade constraints;
drop table LB_Pedido cascade constraints;
drop table LB_Autor cascade constraints;
drop table LB_Autor_Libro cascade constraints;
drop table LB_Libro cascade constraints;
drop table LB_Libros_Pedido cascade constraints;

create table LB_Cliente
(IdCliente CHAR(10) PRIMARY KEY,
 Nombre VARCHAR(25) NOT NULL,
 Direccion VARCHAR(60) NOT NULL,
 NumTC CHAR(16) NOT NULL);
 
create table LB_Pedido
(IdPedido CHAR(10) PRIMARY KEY,
 IdCliente CHAR(10) NOT NULL REFERENCES LB_Cliente on delete cascade,
 FechaPedido DATE NOT NULL,
 FechaExped DATE);

create table LB_Autor
( idautor NUMBER PRIMARY KEY,
  Nombre VARCHAR(25));

create table LB_Libro
(ISBN CHAR(15) PRIMARY KEY,
Titulo VARCHAR(60) NOT NULL,
Anio CHAR(4) NOT NULL,
PrecioCompra NUMBER(6,2) DEFAULT 0,
PrecioVenta NUMBER(6,2) DEFAULT 0);

create table LB_Autor_Libro
(ISBN CHAR(15),
Autor NUMBER,
CONSTRAINT LB_al_PK PRIMARY KEY (ISBN, Autor),
CONSTRAINT LB_libroA_FK FOREIGN KEY (ISBN) REFERENCES LB_Libro on delete cascade,
CONSTRAINT LB_autor_FK FOREIGN KEY (Autor) REFERENCES LB_Autor);


create table LB_Libros_Pedido(
ISBN CHAR(15),
IdPedido CHAR(10),
Cantidad NUMBER(3) CHECK (cantidad >0),
CONSTRAINT LB_lp_PK PRIMARY KEY (ISBN, idPedido),
CONSTRAINT LB_libro_FK FOREIGN KEY (ISBN) REFERENCES LB_Libro on delete cascade,
CONSTRAINT LB_pedido_FK FOREIGN KEY (IdPedido) REFERENCES LB_Pedido on delete cascade);

insert into LB_Cliente values ('0000001','Margarita Sanchez', 'Arroyo del Camino 2','1234567890123456');
insert into LB_Cliente values ('0000002','Angel Garcia', 'Puente Viejo 13', '1234567756953456');
insert into LB_Cliente values ('0000003','Pedro Santillana', 'Molino de Abajo 42', '1237596390123456');
insert into LB_Cliente values ('0000004','Rosa Prieto', 'Plaza Mayor 46', '4896357890123456');
insert into LB_Cliente values ('0000005','Ambrosio Perez', 'Corredera de San Antonio 1', '1224569890123456');
insert into LB_Cliente values ('0000006','Lola Arribas', 'Lope de Vega 32', '2444889890123456' );


insert into LB_Pedido values ('0000001P','0000001', TO_DATE('01/12/2011'),TO_DATE('03/12/2011'));
insert into LB_Pedido values ('0000002P','0000001', TO_DATE('01/12/2011'),null);
insert into LB_Pedido values ('0000003P','0000002', TO_DATE('02/12/2011'),TO_DATE('03/12/2011'));
insert into LB_Pedido values ('0000004P','0000004', TO_DATE('02/12/2011'),TO_DATE('05/12/2011'));
insert into LB_Pedido values ('0000005P','0000005', TO_DATE('03/12/2011'),TO_DATE('03/12/2011'));
insert into LB_Pedido values ('0000006P','0000003', TO_DATE('04/12/2011'),null);

insert into LB_Autor values (1,'Matilde Asensi');
insert into LB_Autor values (2,'Ildefonso Falcones');
insert into LB_Autor values (3,'Carlos Ruiz Zafon');
insert into LB_Autor values (4,'Miguel de Cervantes');
insert into LB_Autor values (5,'Julia Navarro');
insert into LB_Autor values (6,'Miguel Delibes');
insert into LB_Autor values (7,'Fiodor Dostoievski');

insert into LB_Libro values ('8233771378567', 'Todo bajo el cielo', '2008', 9.45, 13.45);
insert into LB_Libro values ('1235271378662', 'La catedral del mar', '2009', 12.50, 19.25);
insert into LB_Libro values ('4554672899910', 'La sombra del viento', '2002', 19.00, 33.15);
insert into LB_Libro values ('5463467723747', 'Don Quijote de la Mancha', '2000', 49.00, 73.45);
insert into LB_Libro values ('0853477468299', 'La sangre de los inocentes', '2011', 9.45, 13.45);
insert into LB_Libro values ('1243415243666', 'Los santos inocentes', '1997', 10.45, 15.75);
insert into LB_Libro values ('0482174555366', 'Noches Blancas', '1998', 4.00, 9.45);


insert into LB_Autor_Libro values ('8233771378567',1);
insert into LB_Autor_Libro values ('8233771378567',2);
insert into LB_Autor_Libro values ('1235271378662',2);
insert into LB_Autor_Libro values ('4554672899910',3);
insert into LB_Autor_Libro values ('5463467723747',4);
insert into LB_Autor_Libro values ('0853477468299',5);
insert into LB_Autor_Libro values ('1243415243666',6);
insert into LB_Autor_Libro values ('0482174555366',7);

insert into LB_Libros_Pedido values ('8233771378567','0000001P', 1);
insert into LB_Libros_Pedido values ('5463467723747','0000001P', 2);
insert into LB_Libros_Pedido values ('0482174555366','0000002P', 1);
insert into LB_Libros_Pedido values ('4554672899910','0000003P', 1);
insert into LB_Libros_Pedido values ('8233771378567','0000003P', 1);
insert into LB_Libros_Pedido values ('1243415243666','0000003P', 1);
insert into LB_Libros_Pedido values ('8233771378567','0000004P', 1);
insert into LB_Libros_Pedido values ('4554672899910','0000005P', 1);
insert into LB_Libros_Pedido values ('1243415243666','0000005P', 1);
insert into LB_Libros_Pedido values ('5463467723747','0000005P', 3);
insert into LB_Libros_Pedido values ('8233771378567','0000006P', 5); 

commit;

-- -----------------------------------------------------
-- Ejemplo01: Ejemplo minimo de bloque anonimo
-- -----------------------------------------------------
SET SERVEROUTPUT ON;

---a---
DECLARE
    CURSOR cr_pedidos is 
        SELECT nombre, direccion, idPedido
        from LB_PEDIDO JOIN LB_CLIENTE ON LB_Pedido.idCliente = LB_cliente.idCliente
        where LB_Pedido.fechaexped > SYSDATE or LB_Pedido.FECHAEXPED is null
        order by LB_pedido.FECHAPEDIDO asc;
BEGIN
    FOR r_pedidos in cr_pedidos LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || r_pedidos.nombre || ', Dirección: ' || r_pedidos.direccion || ', Pedido: ' || r_pedidos.idPedido);
    END LOOP;
END;
/

---b---
CREATE OR REPLACE PROCEDURE LibrosPedido(idPedidoIn IN CHAR) is
    CURSOR cr_pedidos is 
        SELECT LB_Cliente.nombre, LB_Cliente.direccion, LB_Pedido.idPedido, LB_Libro.ISBN, LB_Libro.titulo, LB_Libros_Pedido.cantidad
        from LB_PEDIDO JOIN LB_CLIENTE ON LB_Pedido.idCliente = LB_cliente.idCliente
        join LB_Libros_pedido on LB_Pedido.idPedido = LB_Libros_Pedido.idPedido
        join LB_Libro on LB_Libros_pedido.ISBN = LB_Libro.ISBN
        where LB_Pedido.idPedido = idPedidoIn;
BEGIN
    FOR r_pedidos in cr_pedidos LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || r_pedidos.nombre || ', Direccion: ' || r_pedidos.direccion || ', Pedido: ' || r_pedidos.idPedido || ', ISBN: ' || r_pedidos.ISBN || ', Titulo: ' || r_pedidos.titulo || ', Autores: ' || AutoresLibro(r_pedidos.ISBN) || ' Cantidad: ' || r_pedidos.cantidad);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE PedidosPendientes is
    CURSOR cr_pedidos is 
        SELECT LB_Pedido.idPedido
        from LB_PEDIDO
        where FECHAEXPED > SYSDATE or FECHAEXPED is null;
BEGIN
    FOR r_pedidos in cr_pedidos LOOP
        LibrosPedido(r_pedidos.idPedido);
    END LOOP;
END;
/

begin
PedidosPendientes();
end;
/

---c---
CREATE OR REPLACE FUNCTION AutoresLibro(ISBNIN IN CHAR)
RETURN VARCHAR2 IS
    autores VARCHAR2(100);
    CURSOR cr_autores is 
        SELECT LB_AUTOR.nombre
        from LB_LIBRO
        join LB_AUTOR_LIBRO
        on LB_LIBRO.ISBN = LB_AUTOR_LIBRO.ISBN
        join LB_AUTOR
        on LB_Autor.idAutor = LB_Autor_Libro.Autor
        where LB_Libro.ISBN = ISBNIN;
BEGIN
    FOR r_autores in cr_autores LOOP
       autores := autores || r_autores.nombre || ', ';
    END LOOP;
    RETURN autores;
END;
/

begin
pedidosPendientes();
end;
/

        
    


