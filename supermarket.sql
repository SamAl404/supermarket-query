
CREATE DATABASE db_supermercado;
GO

USE db_supermercado;
GO


CREATE TABLE [Empleados](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Cedula] NVARCHAR(30) UNIQUE NOT NULL,
	[Carne] NVARCHAR(30) UNIQUE NOT NULL,
	[Nombre] NVARCHAR(30) NOT NULL,
	[Apellido] NVARCHAR(30) NOT NULL


);

CREATE TABLE [Clientes](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Cedula] NVARCHAR(30) UNIQUE NOT NULL,
	[Nombre] NVARCHAR(30) NOT NULL,
	[Apellido] NVARCHAR(30) NOT NULL,
	[Telefono] NVARCHAR(30) NOT NULL



);

CREATE TABLE [MetodosPagos](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[TipoPago] NVARCHAR(30) UNIQUE NOT NULL,
	[Estado] BIT NOT NULL,
		
);

CREATE TABLE [Proveedores](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Nit] INT UNIQUE NOT NULL,
	[Nombre] NVARCHAR(30) NOT NULL,
	[Telefono] NVARCHAR(30) NOT NULL
);

CREATE TABLE [Productos](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Nombre] NVARCHAR(50) NOT NULL,
	[ValorUnitario] DECIMAL(10,2) NOT NULL,
	[CantidadProductos] INT NOT NULL,

	[IdProveedor] INT NOT NULL,

	FOREIGN KEY([IdProveedor]) REFERENCES Proveedores([Id])

);

CREATE TABLE [Facturas](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Codigo] NVARCHAR(50) UNIQUE NOT NULL,
	[Fecha] SMALLDATETIME NOT NULL,

	[IdEmpleado] INT  NOT NULL,
	[IdCliente] INT  NOT NULL,
	[IdMetodoPago] INT  NOT NULL,

	FOREIGN KEY([IdEmpleado]) REFERENCES Empleados([Id]),
	FOREIGN KEY([IdCliente]) REFERENCES Clientes([Id]),
	FOREIGN KEY([IdMetodoPago]) REFERENCES MetodosPagos([Id]),

	

);

CREATE TABLE [DetallesFacturas](

	[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Cantidad] INT NOT NULL,
	
	[IdProducto] INT  NOT NULL,
	[IdFactura] INT  NOT NULL,

	FOREIGN KEY([IdProducto]) REFERENCES Productos([Id]),
	FOREIGN KEY([IdFactura]) REFERENCES Facturas([Id]),

	--[ValorBruto] AS ([Cantidad] * (SELECT [ValorUnitario] FROM [Productos] WHERE [Productos].[Id] = [DetallesFacturas].[IdProducto])) PERSISTED

);

INSERT INTO [Empleados]([Cedula],[Carne],[Nombre],[Apellido]) VALUES 

('111', 'A001', 'Juan', 'Rodriguez'),
('222', 'A002', 'Carlos', 'Espitia'),
('333', 'A003', 'Luis', 'Dias');


INSERT INTO [Clientes]([Cedula],[Nombre],[Apellido],[Telefono])VALUES

('444', 'Alan', 'Velasquez', '3115264895'),
('555', 'Daniel', 'Correa', '3102478456'),
('666', 'David', 'Villa', '3123547895'),
('777', 'Santiago', 'Aristizabal', '3045123636');


INSERT INTO [MetodosPagos]([TipoPago],[Estado])VALUES

('Efectivo', 1),
('Nequi', 0),
('Debito', 1),
('Credito', 1);


INSERT INTO [Proveedores]([Nit],[Nombre],[Telefono])VALUES

('987', 'Nestle', '11111'),
('654', 'P&G', '22222'),
('321', 'Unilever', '33333'),
('951', 'Pepsico', '44444');


INSERT INTO [Productos]([Nombre], [CantidadProductos], [ValorUnitario], [IdProveedor])VALUES

--NESTLE
('Nescafe', 1000, 8500., 1),
('Purina', 500, 6000, 1),
('Nestea', 100, 2000, 1),

--P&G
('Gillette', 550, 40000, 2),
('Lacoste', 300, 500000, 2),
('Pringles', 350, 5000, 2),

--Unilever
('Dove', 250, 12000, 3),
('Magnum', 300, 5000, 3),
('Axe', 350, 20000, 3),

--Pepsico
('Avena Quaker', 50, 2000, 4),
('Pepsi', 2000, 7000, 4),
('Gatorade', 2000, 6000, 4);



SELECT * FROM [DetallesFacturas];

INSERT INTO [Facturas]([Codigo], [Fecha], [IdEmpleado], [IdCliente], [IdMetodoPago]) VALUES

('A001', GETDATE(), 1, 1 , 1),
('A002', GETDATE(), 2, 1 , 3),
('B003', GETDATE(), 3, 2 , 4),
('A004', GETDATE(), 3, 2 , 1),
('A005', GETDATE(), 1, 4 , 3),
('A006', GETDATE(), 3, 4 , 3),
('A007', GETDATE(), 2, 2 , 1),
('A008', GETDATE(), 1, 4 , 4),
('A009', GETDATE(), 1, 2 , 4),
('A010', GETDATE(), 2, 4 , 1);

INSERT INTO [DetallesFacturas]([Cantidad], [IdProducto], [IdFactura])VALUES
( 20, 1, 1),
( 30, 3, 1),
( 11, 4, 1),
( 55, 8, 1),
( 16, 12, 2),
( 84, 11, 2),
( 65, 3, 2),
( 63, 2, 3),
( 2, 4, 3),
( 65, 6, 4),
( 48, 5, 4),
( 94, 4, 5),
( 46, 5, 5),
( 5, 7, 6),
( 1, 8, 6),
( 23, 9, 6),
( 56, 10, 7),
( 7, 11, 7),
( 8, 11, 7),
( 10, 2, 8),
( 12, 3, 8),
( 32,  4, 8),
( 34,  5,  9),
( 5, 6,  9),
( 6, 8, 9),
( 5, 7, 9);





-- PUNTO 9:
-- Creación de registros en la tabla Empleados:
INSERT INTO Empleados (Cedula, Carne, Nombre, Apellido) VALUES
('1045879653', 'EMP-001', 'María', 'Gómez'),
('1098765432', 'EMP-002', 'Juan', 'Pérez');
GO

-- Consultas de registros en la tabla Empleados:
SELECT * FROM Empleados;
GO

SELECT Id, Cedula, Nombre, Apellido
FROM Empleados
WHERE Cedula = '1098765432';
GO

-- Actualización de registros en la tabla Empleados:
UPDATE Empleados
SET Apellido = 'Ramírez'
WHERE Id = 1;
GO

UPDATE Empleados
SET Nombre = 'María Fernanda'
WHERE Carne = 'EMP-001';
GO

-- Borrado de registros en la tabla Empleados:
DELETE FROM Empleados
WHERE Id = 5;
GO

DELETE FROM Empleados
WHERE Cedula = '1045879653';
GO





-- PUNTO 10:
-- 1. INNER JOIN: sólo facturas con cliente asociado
SELECT f.Codigo, f.Fecha, c.Nombre + ' ' + c.Apellido AS Cliente
FROM Facturas f
INNER JOIN Clientes c
ON f.IdCliente = c.Id;
GO
-- 2. LEFT JOIN: todas las facturas y, cuando exista, datos de cliente
SELECT f.Codigo, f.Fecha, c.Nombre + ' ' + c.Apellido AS Cliente
FROM Facturas f
LEFT JOIN Clientes c
ON f.IdCliente = c.Id;
GO
-- 3. RIGHT JOIN: todos los clientes y sus facturas, si las hay
SELECT f.Codigo, f.Fecha, c.Nombre + ' ' + c.Apellido AS Cliente
FROM Facturas f
RIGHT JOIN Clientes c
ON f.IdCliente = c.Id;
GO
-- 4. FULL OUTER JOIN: unión de LEFT y RIGHT, facturas y clientes sin
correspondencia también aparecen
SELECT f.Codigo, f.Fecha, c.Nombre + ' ' + c.Apellido AS Cliente
FROM Facturas f
FULL OUTER JOIN Clientes c
ON f.IdCliente = c.Id;
GO





-- PUNTO 11:
-- Selección básica de todas las columnas de la tabla Productos:
SELECT *
FROM Productos;
GO

-- Obtener los distintos proveedores que aparecen en Productos (DISTINCT):
SELECT DISTINCT IdProveedor
FROM Productos;
GO

-- Productos con stock menor a 300 unidades (WHERE):
SELECT Nombre, CantidadProductos
FROM Productos
WHERE CantidadProductos < 300;
GO

-- Clientes cuyo apellido sea 'Villa' y teléfono comience con '312' (AND y LIKE):
SELECT Nombre, Apellido, Telefono
FROM Clientes
WHERE Apellido = 'Villa'
AND Telefono LIKE '312%';
GO

-- Facturas cuyo Id sea entre 3 y 6 (WHERE, BETWEEN y AND):
SELECT Codigo, Id
FROM Facturas
WHERE Id BETWEEN 3 AND 6;
GO

-- Clientes ordenados de forma descendente por apellido (ORDER BY, DESC):
SELECT Nombre, Apellido
FROM Clientes
ORDER BY Apellido DESC;
GO

-- Obtener las 3 facturas más recientes por fecha (TOP, ORDER BY, DESC):
SELECT TOP 3 Codigo, Fecha
FROM Facturas
ORDER BY Fecha DESC;
GO

-- Métodos de pago con más de 2 facturas (GROUP BY, HAVING):
SELECT mp.TipoPago, COUNT(*) AS CantidadFacturas
FROM Facturas f
JOIN MetodosPagos mp
ON f.IdMetodoPago = mp.Id
GROUP BY mp.TipoPago
HAVING COUNT(*) > 2;
GO





-- PUNTO 12:
ALTER TABLE DetallesFacturas
ADD CONSTRAINT FK_DetallesFacturas_Productos
FOREIGN KEY (IdProducto) REFERENCES Productos(Id)
ON DELETE CASCADE
ON UPDATE CASCADE;
GO





-- PUNTO 14:
-- Listar todas las cédulas de empleados y clientes (UNION / sin duplicados)
--Listar todas las cédulas de empleados y clientes (UNION ALL / con duplicados):
SELECT Cedula
FROM Empleados
UNION
SELECT Cedula
FROM Clientes;
GO

SELECT Cedula
FROM Empleados
UNION ALL
SELECT Cedula
FROM Clientes;
GO

-- Cédulas que son a la vez empleados y clientes (INTERSECT):
SELECT Cedula
FROM Empleados
INTERSECT
SELECT Cedula
FROM Clientes;
GO

-- Cédulas de empleados que no son clientes y Cédulas de clientes que no son empleados (EXCEPT):
SELECT Cedula
FROM Empleados
EXCEPT
SELECT Cedula
FROM Clientes;
GO

SELECT Cedula
FROM Clientes
EXCEPT
SELECT Cedula
FROM Empleados;
GO