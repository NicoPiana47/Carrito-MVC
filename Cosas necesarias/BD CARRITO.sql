create database DBCARRITO
GO

USE DBCARRITO
GO

CREATE TABLE CATEGORIA
(
IdCategoria int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
go

CREATE TABLE MARCA
(
IdMarca int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegsitro datetime default getdate()
)
go

CREATE TABLE PRODUCTO
(
IdProducto int primary key identity,
Nombre varchar(500),
Descripcion varchar(500),
IdMarca int references Marca(IdMarca),
IdCategoria int references Categoria(IdCategoria),
Precio decimal(10,2) default 0,
Stock int,
RutaImagen varchar(100),
NombreImagen varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
go

CREATE TABLE CLIENTE
(
IdCliente int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Reestablecer bit default 0,
FechaRegistro datetime default getdate()
)
go

CREATE TABLE CARRITO
(
IdCarrito int primary key identity,
IdCliente int references CLIENTE(IdCliente),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int
)
go

CREATE TABLE VENTA
(
IdVenta int primary key identity,
IdCliente int references CLIENTE(IdCliente),
TotalProducto int,
MontoTotal Decimal(10,2),
Contacto varchar(50),
IdDistrito varchar(10),
Telefono varchar(50),
Direccion varchar(500),
IdTransaccion varchar(50),
FechaVenta datetime default getdate()
)
go

CREATE TABLE DETALLE_VENTA
(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int,
Total decimal(10,2)
)
go

CREATE TABLE USUARIO
(
IdUsuario int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Reestablecer bit default 1,
Activo bit default 1,
FechaRegistro datetime default getdate()
)
go


CREATE TABLE DEPARTAMENTO
(
IdDepartamento varchar(2) NOT NULL,
Descripcion varchar(45) NOT NULL
)
go

CREATE TABLE PROVINCIA
(
IdProvincia varchar(4) NOT NULL,
Descripcion varchar(45) NOT NULL,
IdDepartamento varchar(2) NOT NULL
)
go

CREATE TABLE DISTRITO
(
IdDistrito varchar(6) NOT NULL,
Descripcion varchar(45) NOT NULL,
IdProvincia varchar(4) NOT NULL,
IdDepartamento varchar(2) NOT NULL
)
go


insert into USUARIO(Nombres,Apellidos,Correo,Clave) values ('test nombre','test apellido','test@example.com','ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')
insert into USUARIO(Nombres,Apellidos,Correo,Clave) values ('test nombre','test apellido2','user2@example.com','adf13qqf63316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')
go

 insert into CATEGORIA(Descripcion) values 
 ('Tecnologia'),
 ('Muebles'),
 ('Dormitorio'),
  ('Deportes')


go

  insert into MARCA(Descripcion) values
('SONYTE'),
('HPTE'),
('LGTE'),
('HYUNDAITE'),
('CANONTE'),
('ROBERTA ALLENTE')


go


insert into DEPARTAMENTO(IdDepartamento,Descripcion)
values 
('01','Arequipa'),
('02','Ica'),
('03','Lima')


go

insert into PROVINCIA(IdProvincia,Descripcion,IdDepartamento)
values
('0101','Arequipa','01'),
('0102','Camaná','01'),

--ICA - PROVINCIAS
('0201', 'Ica ', '02'),
('0202', 'Chincha ', '02'),

--LIMA - PROVINCIAS
('0301', 'Lima ', '03'),
('0302', 'Barranca ', '03')


go

insert into DISTRITO(IdDistrito,Descripcion,IdProvincia,IdDepartamento) values 
('010101','Nieva','0101','01'),
('010102', 'El Cenepa', '0101', '01'),

('010201', 'Camaná', '0102', '01'),
('010202', 'José María Quimper', '0102', '01'),

--ICA - DISTRITO
('020101', 'Ica', '0201', '02'),
('020102', 'La Tinguiña', '0201', '02'),
('020201', 'Chincha Alta', '0202', '02'),
('020202', 'Alto Laran', '0202', '02'),


--LIMA - DISTRITO
('030101', 'Lima', '0301', '03'),
('030102', 'Ancón', '0301', '03'),
('030201', 'Barranca', '0302', '03'),
('030202', 'Paramonga', '0302', '03')
GO


---PROC ALM. USUARIOS
CREATE PROC sp_RegistrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo=@Correo)
	begin
		insert into USUARIO(Nombres,Apellidos,Correo,Clave,Activo) values
		(@Nombres,@Apellidos,@Correo,@Clave,@Activo)

		SET @Resultado=SCOPE_IDENTITY()
	end
	else
		set @Mensaje='El correo del usuario ya existe'
end
GO

CREATE PROC sp_EditarUsuario(
@IdUsuario int,
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo=@Correo and IdUsuario != @IdUsuario)
	begin
		
		update top(1) USUARIO SET
		Nombres=@Nombres,
		Apellidos=@Apellidos,
		Correo=@Correo,
		Activo=@Activo
		where IdUsuario=@IdUsuario

		SET @Resultado=1
	end
	else
		set @Mensaje='El correo del usuario ya existe'
end
GO

---PROC ALM. CATEGORIAS
CREATE PROC sp_RegistrarCategoria(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
	begin
		insert into CATEGORIA(Descripcion,Activo) values
		(@Descripcion,@Activo)

		SET @Resultado=SCOPE_IDENTITY()
	end
	else
		set @Mensaje='La categoría ya existe'
end
GO

CREATE PROC sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	begin
		update top(1) CATEGORIA SET
		Descripcion=@Descripcion, 
		Activo=@Activo 
		WHERE IdCategoria=@IdCategoria

		SET @Resultado=1
	end
	else
		set @Mensaje='La categoría ya existe'
end
GO


CREATE PROC sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM PRODUCTO p
	inner join CATEGORIA c on c.IdCategoria=p.IdCategoria
	where p.IdCategoria=@IdCategoria)
	begin
		delete top(1) from CATEGORIA where IdCategoria=@IdCategoria
		SET @Resultado=1
	end
	else
		set @Mensaje='La categoría se encuentra relacionada a un producto'
end
GO

---PROC ALM. MARCAS
CREATE PROC sp_RegistrarMarca(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion)
	begin
		insert into MARCA(Descripcion,Activo) values
		(@Descripcion,@Activo)

		SET @Resultado=SCOPE_IDENTITY()
	end
	else
		set @Mensaje='La marca ya existe'
end
GO

CREATE PROC sp_EditarMarca(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion and IdMarca != @IdMarca)
	begin
		update top(1) MARCA SET
		Descripcion=@Descripcion, 
		Activo=@Activo 
		WHERE IdMarca=@IdMarca

		SET @Resultado=1
	end
	else
		set @Mensaje='La marca ya existe'
end
GO


CREATE PROC sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM PRODUCTO p
	inner join MARCA m on m.IdMarca=p.IdMarca
	where p.IdMarca=@IdMarca)
	begin
		delete top(1) from MARCA where IdMarca=@IdMarca
		SET @Resultado=1
	end
	else
		set @Mensaje='La marca se encuentra relacionada a un producto'
end
GO

---PROC ALM. PRODUCTOS
CREATE PROC sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre=@Nombre)
	begin
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo) values
		(@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@Activo)

		SET @Resultado=SCOPE_IDENTITY()
	end
	else
		set @Mensaje='El producto ya existe'
end
GO

CREATE PROC sp_EditarProducto(
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre=@Nombre and IdProducto!=@IdProducto)
	begin
		update top(1) PRODUCTO SET
		Nombre=@Nombre,
		Descripcion=@Descripcion,
		IdMarca=@IdMarca,
		IdCategoria=@IdCategoria,
		Precio=@Precio,
		Stock=@Stock,
		Activo=@Activo
		WHERE IdProducto=@IdProducto

		SET @Resultado=1
	end
	else
		set @Mensaje='El producto ya existe'
end
GO


CREATE PROC sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado=0

	IF NOT EXISTS (SELECT * FROM DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto=dv.IdProducto
	where p.IdProducto=@IdProducto)
	begin
		delete top(1) from PRODUCTO where IdProducto=@IdProducto
		SET @Resultado=1
	end
	else
		set @Mensaje='El producto se encuentra relacionado a una venta'
end
GO



CREATE PROC sp_ReporteDashboard
as
begin

select
(select count(*) from CLIENTE) [TotalCliente],
(select ISNULL(SUM(cantidad),0) from DETALLE_VENTA) [TotalVenta],
(select COUNT(*) from PRODUCTO) [TotalProducto]

end

exec sp_ReporteDashboard


create proc sp_ReporteVentas
(
@fechainicio varchar(10),
@fechafin varchar(10),
@idtransaccion varchar(50)
)
as
begin


set dateformat dmy;

select CONVERT(char(10), v.FechaVenta, 103)[FechaVenta], CONCAT(c.Nombres,' ',c.Apellidos)[Cliente],
p.Nombre[Producto],p.Precio, dv.Cantidad, dv.Total, v.IdTransaccion
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto=dv.IdVenta
inner join VENTA v on v.IdVenta=dv.IdVenta
inner join CLIENTE c on c.IdCliente=v.IdCliente
where CONVERT(date, v.FechaVenta) between @fechainicio and @fechafin
and v.IdTransaccion = IIF(@idtransaccion ='',v.IdTransaccion,@idtransaccion)

end

select * from USUARIO
