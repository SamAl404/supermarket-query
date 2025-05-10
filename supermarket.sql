
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


SELECT 
	f.[Id],
	f.[Codigo],
	f.[Fecha],
	f.[IdEmpleado],
	f.[IdCliente],
	f.[IdMetodoPago],

	(SELECT SUM(df.[Cantidad] * p.[ValorUnitario])
	FROM [DetallesFacturas] df
	JOIN [Productos] p on df.[IdProducto] = p.[Id]
	WHERE df.IdFactura = f.[Id]) 
	AS Total

FROM [Facturas] f;


SELECT * FROM [Productos];

SELECT pr.[Id], pr.[Nombre], p.[Nombre]
FROM [Proveedores] pr 
JOIN [Productos] p 
ON pr.[Id] = p.[IdProveedor];

SELECT 

	f.[Id],
	f.[Codigo],
	f.[Fecha],

	(SELECT SUM(df.[Cantidad] * p.[ValorUnitario])
	 FROM [DetallesFacturas] df
	 INNER JOIN [Productos] p ON p.[Id] = df.[IdProducto]
	 WHERE f.[Id] = df.[IdFactura]) AS Total

FROM [Facturas] f;



SELECT

	df.[Id],
	df.[Cantidad],
	(df.[Cantidad] * p.[ValorUnitario]) AS [ValorBruto]
	
FROM [DetallesFacturas] df
INNER JOIN [Productos] p ON p.[Id] = df.[IdProducto];

--Comentario generico
-- Comentario de prueba


--    APLICACION DE FUNCIONES AGREGADAS

-- Total de productos vendidos por factura
SELECT IdFactura, SUM(Cantidad) AS TotalProductos
FROM DetallesFacturas
GROUP BY IdFactura;

-- Cantidad total de facturas registradas
SELECT COUNT(*) AS TotalFacturas
FROM Facturas;

--Valor mínimo, maximo y promedio por producto
SELECT 
    p.Nombre AS Producto,
    MIN(df.Cantidad * p.ValorUnitario) AS VentaMínima,
    MAX(df.Cantidad * p.ValorUnitario) AS VentaMáxima,
    AVG(df.Cantidad * p.ValorUnitario) AS VentaPromedio,
    COUNT(*) AS VecesVendido
FROM DetallesFacturas df
JOIN Productos p ON df.IdProducto = p.Id
GROUP BY p.Nombre
ORDER BY AVG(df.Cantidad * p.ValorUnitario) DESC;

--Clientes más fieles del año
SELECT TOP 10
    CONCAT(
        UPPER(LEFT(LTRIM(RTRIM(c.Nombre)), 1)),
        LOWER(SUBSTRING(LTRIM(RTRIM(c.Nombre)), 2, LEN(c.Nombre))),
        ' ',
        UPPER(LTRIM(RTRIM(c.Apellido)))
    ) AS ClientesFrecuentes,
    CAST(COUNT(f.Id) AS VARCHAR) + ' compras en ' + CAST(YEAR(GETDATE()) AS VARCHAR) AS HistorialCompras,
    CASE 
        WHEN LEN(c.Telefono) = 10 THEN 
            CONCAT('TEL: ', SUBSTRING(c.Telefono, 1, 3), '-', SUBSTRING(c.Telefono, 4, 3), '-', SUBSTRING(c.Telefono, 7, 4))
        ELSE 'TEL: Inválido'
    END AS TelefonoConFormato,
    SUM(df.Cantidad * p.ValorUnitario) AS TotalEnCompras
FROM Clientes c
JOIN Facturas f ON c.Id = f.IdCliente
JOIN DetallesFacturas df ON f.Id = df.IdFactura
JOIN Productos p ON df.IdProducto = p.Id
WHERE YEAR(f.Fecha) = YEAR(GETDATE())
GROUP BY c.Nombre, c.Apellido, c.Telefono
ORDER BY TotalEnCompras DESC;

--   AUDITORIAS.

--Con triggers

--Facturas
CREATE TABLE AuditoriaFacturas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Accion VARCHAR(20),
    Fecha DATETIME DEFAULT GETDATE(),
    IdFactura INT
);

CREATE TRIGGER AuditoriaInsertFacturas
ON Facturas
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditoriaFacturas (Accion, IdFactura)
    SELECT 'INSERT', Id FROM inserted;
END;


CREATE TRIGGER AuditoriaUpdateFacturas
ON Facturas
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditoriaFacturas (Accion, IdFactura)
    SELECT 'UPDATE', Id FROM inserted;
END;


CREATE TRIGGER AuditoriaDeleteFacturas
ON Facturas
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditoriaFacturas (Accion, IdFactura)
    SELECT 'DELETE', Id FROM deleted;
END;



CREATE TABLE AuditoriaDetallesFacturas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Accion VARCHAR(10),
    Fecha DATETIME DEFAULT GETDATE(),
    IdDetalleFactura INT
);


CREATE TRIGGER AuditoriaInsertDetallesFacturas
ON DetallesFacturas
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditoriaDetallesFacturas (Accion, IdDetalleFactura)
    SELECT Id, 'INSERT' FROM inserted;
END;


CREATE TRIGGER AuditoriaUpdateDetallesFacturas
ON DetallesFacturas
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditoriaDetallesFacturas (Accion, IdDetalleFactura)
    SELECT 'UPDATE', Id FROM inserted;
END;


CREATE TRIGGER AuditoriaDeleteDetallesFacturas
ON DetallesFacturas
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditoriaDetallesFacturas (Accion, IdDetalleFactura)
    SELECT 'DELETE', Id FROM deleted;
END;


--Procedmientos almacenados
