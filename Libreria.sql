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
insert into LB_Pedido values ('0000007P','0000002', TO_DATE('04/12/2011'),null);

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
insert into LB_Libros_Pedido values ('8233771378567','0000007P', 1); 

commit;

---1---
SELECT LB_Libro.ISBN, LB_Libro.Titulo, LB_Autor.Nombre, LB_Libro.Anio 
FROM LB_Libro 
JOIN LB_Autor_libro 
ON LB_Libro.ISBN = LB_Autor_Libro.ISBN
JOIN LB_Autor 
ON LB_Autor_Libro.Autor = LB_Autor.idAutor
ORDER BY LB_Libro.Anio;

---2---
SELECT *
FROM LB_Libro
WHERE ANIO > 2000;

---3---
SELECT DISTINCT LB_Cliente.idCliente, LB_Cliente.nombre
FROM LB_Pedido
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente;

---4---
SELECT DISTINCT LB_Cliente.idCliente, LB_Cliente.nombre
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
WHERE LB_Libros_Pedido.ISBN = 4554672899910;

---5---
SELECT LB_Cliente.idCliente, LB_Cliente.Nombre, LB_Libro.Titulo
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
WHERE LB_Cliente.Nombre like '%San%';


---6---
SELECT DISTINCT LB_Cliente.idCliente, LB_Cliente.nombre
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
WHERE LB_Libro.PrecioVenta > 10;

---7---
SELECT DISTINCT LB_Cliente.idCliente, LB_Cliente.nombre, LB_Pedido.FechaPedido
FROM LB_Pedido
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
WHERE LB_Pedido.FECHAEXPED > SYSDATE;

---8---
SELECT DISTINCT LB_Cliente.idCliente, LB_Cliente.nombre 
FROM LB_Cliente
WHERE LB_Cliente.idCliente NOT IN
           (SELECT DISTINCT LB_Cliente.idCliente
            FROM LB_Libros_Pedido
            JOIN LB_Pedido
            ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
            JOIN LB_CLIENTE
            ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
            JOIN LB_Libro
            ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
            WHERE LB_Libro.PrecioVenta > 10);

---9---
SELECT DISTINCT LB_Libro.Titulo, LB_Libro.ANIO, LB_Libro.PRECIOVENTA
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
WHERE LB_Libro.PrecioVenta > 30 or LB_Libro.anio < 2000;

---10---
SELECT DISTINCT LB_Cliente.nombre
FROM LB_Pedido
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
GROUP BY (LB_Cliente.nombre, LB_Pedido.FechaPedido)
HAVING COUNT (LB_Cliente.nombre) >= 2;

---11---
SELECT DISTINCT LB_Libro.Titulo, sum(LB_Libros_Pedido.Cantidad) as "Total Vendido"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
GROUP BY LB_Libro.Titulo, LB_Libro.ISBN;

---12---
SELECT LB_Cliente.Nombre, sum(LB_Libro.PrecioVenta * LB_Libros_Pedido.Cantidad) as "Total Gastado"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_CLIENTE
ON LB_CLIENTE.idCliente = LB_Pedido.idCliente
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
GROUP BY (LB_Cliente.Nombre, LB_Cliente.idCliente);

---13---
SELECT sum(LB_Libro.PrecioVenta * LB_Libros_Pedido.Cantidad) as "Total Vendido", sum(LB_Libro.PrecioCompra * LB_Libros_Pedido.Cantidad) as "Total Gastado", sum(LB_Libro.PrecioVenta * LB_Libros_Pedido.Cantidad) - sum(LB_Libro.PrecioCompra * LB_Libros_Pedido.Cantidad) as "Beneficio"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro 
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN;

---14--- Lista de importe total de pedidos por fecha, que se hayan realizado después del 01/12/2011 y no hayan sido expedidos.
SELECT LB_Pedido.FechaPedido, sum(LB_Libro.PrecioVenta * LB_Libros_Pedido.Cantidad) as "Importe Total"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
where LB_PEDIDO.FECHAPEDIDO > TO_DATE('01/12/2011') and (LB_PEDIDO.FECHAEXPED > SYSDATE or LB_PEDIDO.FECHAEXPED is null)
GROUP BY (LB_Pedido.FechaPedido);

---15---
SELECT LB_Pedido.idPedido, sum (LB_Libro.PrecioVenta * LB_Libros_Pedido.CANTIDAD) as "Importe del Pedido"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
GROUP BY (LB_Pedido.IDPEDIDO)
HAVING (SUM(LB_Libros_Pedido.Cantidad * LB_Libro.PrecioVenta) > 100);

---16---
SELECT LB_Pedido.idPedido, sum (LB_Libro.PrecioVenta * LB_Libros_Pedido.CANTIDAD) as "Importe del Pedido"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
GROUP BY (LB_Libros_Pedido.idPedido)
HAVING COUNT (LB_Libro.TITULO ) > 1;

---17---
SELECT LB_Pedido.idPedido, sum (LB_Libro.PrecioVenta * LB_Libros_Pedido.CANTIDAD) as "Importe del Pedido", sum(LB_LIBROS_PEDIDO.CANTIDAD) as "Número de ejemplares"
FROM LB_Libros_Pedido
JOIN LB_Pedido
ON LB_Pedido.IDPEDIDO = LB_Libros_Pedido.IDPEDIDO
JOIN LB_Libro
ON LB_Libros_Pedido.ISBN = LB_Libro.ISBN
GROUP BY (LB_Pedido.idPedido)
having (sum(LB_LIBROS_PEDIDO.CANTIDAD) > 4);

---18---
SELECT Titulo, PrecioVenta
FROM LB_libro
WHERE PrecioVenta = (select MAX(PrecioVenta) from LB_Libro);

---19---
SELECT LB_Libro.ISBN, LB_Libro.Titulo
FROM LB_Libro
WHERE LB_Libro.ISBN NOT IN
                          (SELECT LB_Libro.ISBN
                           FROM LB_LIBRO
                           JOIN LB_LIBROS_PEDIDO
                           ON LB_Libro.ISBN = LB_LIBROS_PEDIDO.ISBN
                           where LB_Libro.PrecioVenta - LB_Libro.PrecioCompra > 5);

---20--- FACIL
SELECT LB_CLIENTE.IDCLIENTE, LB_CLIENTE.NOMBRE
FROM LB_CLIENTE
JOIN LB_PEDIDO
ON LB_PEDIDO.IDCLIENTE = LB_CLIENTE.IDCLIENTE
JOIN LB_LIBROS_PEDIDO
ON LB_PEDIDO.IDPEDIDO = LB_LIBROS_PEDIDO.IDPEDIDO
WHERE LB_LIBROS_PEDIDO.CANTIDAD > 1;

---20--- DIFICIL
SELECT DISTINCT LB_Cliente.idCliente, LB_CLIENTE.NOMBRE
FROM LB_CLIENTE
JOIN LB_PEDIDO
ON LB_PEDIDO.IDCLIENTE = LB_CLIENTE.IDCLIENTE
JOIN LB_LIBROS_PEDIDO
ON LB_PEDIDO.IDPEDIDO = LB_LIBROS_PEDIDO.IDPEDIDO
GROUP BY (LB_CLIENTE.IDCLIENTE, LB_Cliente.Nombre, LB_Libros_Pedido.ISBN)
HAVING (SUM(LB_Libros_Pedido.Cantidad)) > 1;

---21---
SELECT LB_Cliente.idCliente, LB_Cliente.Nombre, LB_Pedido.idPedido, LB_Libro.ISBN, LB_Libro.Titulo
FROM LB_CLIENTE
LEFT OUTER JOIN 
                (LB_PEDIDO JOIN LB_LIBROS_PEDIDO
                ON LB_PEDIDO.IDPEDIDO = LB_LIBROS_PEDIDO.IDPEDIDO
                JOIN LB_Libro
                ON LB_Libro.ISBN = LB_LIBROS_PEDIDO.ISBN)
ON LB_CLIENTE.IDCLIENTE = LB_Pedido.idCliente
ORDER BY LB_Cliente.idCliente;





