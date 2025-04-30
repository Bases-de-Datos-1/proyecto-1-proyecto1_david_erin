create database SistemaHoteleria

use SistemaHoteleria


create table TipoHotel
(
	TipoHotelID int identity (1,1) primary key,
	Nombre varchar(100) not null,
)

create table EmpresaHotel
( 
	CedulaJuridica varchar(20) primary key,
	Nombre varchar(100) not null,
	TipoHotelID int not null,
	Provincia varchar(50) not null,
	Canton varchar(50) not null,
	Distrito varchar(50) not null,
	Barrio varchar(50) not null,
	SeñasExactas text not null, 
	ReferenciaGPS varchar(100) not null,
	CorreoElectronico varchar(100) unique not null,
	URLSitioWeb text null,

	constraint FK_EmpresaHotel_TipoHotel foreign key (TipoHotelID) references TipoHotel (TipoHotelID) ON DELETE CASCADE
)


create table Servicios 
(
	ServicioID int identity (1,1) primary key,
	Nombre varchar(100) not null,
)

create table HotelServicios
(
	CedulaJuridica varchar(20) not null,
	ServicioID int not null,
	constraint FK_HotelServicios_EmpresaHotel foreign key (CedulaJuridica) references EmpresaHotel (CedulaJuridica) ON DELETE CASCADE,
	constraint FK_HotelServicios_Servicios foreign key (ServicioID) references Servicios (ServicioID) ON DELETE CASCADE,
)

create table TelefonosEmpresa 
(
	TelefonoID int identity (1,1) primary key,
	Numero varchar(20) not null,
	CedulaJuridica varchar(20) not null,
	constraint FK_TelefonosEmpresa_EmpresaHotel foreign key (CedulaJuridica) references EmpresaHotel (CedulaJuridica) ON DELETE CASCADE,
)

create table RedSocial 
(
	RedSocialID int identity (1,1) primary key,
	Nombre varchar(50) not null
)

create table RedSocialHotel
(
	NombreUsuario varchar(150) not null,
	RedSocialID int not null,
	CedulaJuridica varchar(20) not null,
	constraint FK_RedSocialHotel_EmpresaHotel foreign key (CedulaJuridica) references EmpresaHotel (CedulaJuridica) ON DELETE CASCADE,
	constraint FK_RedSocialHotel_RedSocil foreign key (RedSocialID) references RedSocial (RedSocialID) ON DELETE CASCADE,
)

create table TipoCama
(
	TipoCamaID int identity (1,1) primary key,
	Nombre varchar (100) not null,
)


create table TipoHabitacion
(
	TipoHabitacionID int identity (1,1) primary key,
	Nombre varchar(50) not null,
	Descripcion text not null,
	Precio decimal (10,2) not null check (Precio > 0.00),
)

create table TipoHabitacionCama (
    TipoHabitacionID int not null,
    TipoCamaID int not null,
    Cantidad int not null check (Cantidad > 0),
    CONSTRAINT FK_TipoHabitacionCama_TipoHabitacion FOREIGN KEY (TipoHabitacionID) REFERENCES TipoHabitacion (TipoHabitacionID) ON DELETE CASCADE,
    CONSTRAINT FK_TipoHabitacionCama_TipoCama FOREIGN KEY (TipoCamaID) REFERENCES TipoCama (TipoCamaID) ON DELETE CASCADE
);


create table FotosHabitacion
(
	FotoID int identity (1,1) primary key,
	Fotos image not null,
	TipoHabitacionID int not null,
	constraint FK_FotosHabitacion_TipoHabitacion foreign key (TipoHabitacionID) references TipoHabitacion(TipoHabitacionID) ON DELETE CASCADE,
)

create table Comodidades
(
	ComodidadID int identity (1,1) primary key,
	Nombre varchar(50) not null
)

create table TipoHabitacionComodidad
(
	TipoHabitacionID int not null,
	ComodidadID int not null,
	constraint Fk_TipoHabitacionComodidad_TipoHabitacion foreign key (TipoHabitacionID) references TipoHabitacion (TipoHabitacionID) ON DELETE CASCADE,
	constraint FK_TipoHabitacionComodidad_Comodidades foreign key (ComodidadID) references Comodidades (ComodidadID) ON DELETE CASCADE
)

create table Habitaciones 
(
	HabitacionID int identity (1,1) primary key,
	Numero int not null check(Numero > 0),
	CedulaJuridica varchar(20) not null,
	TipoHabitacionID int not null,
	constraint FK_Habitaciones_EmpresaHotel foreign key (CedulaJuridica) references EmpresaHotel (CedulaJuridica) ON DELETE CASCADE,
	constraint FK_Habitaciones_TipoHabitacion foreign key (TipoHabitacionID) references TipoHabitacion (TipoHabitacionID) ON DELETE CASCADE,
)


CREATE TABLE PaisResidencia (
    PaisResidenciaID int identity(1,1) primary key,
    NombrePais varchar(50) not null
)


CREATE TABLE Cliente (
    CedulaID varchar(20) primary key,
    Nombre varchar(100) not null,
    PrimerApellido varchar(100) not null,
    SegundoApellido varchar(100) not null,
    FechaNacimiento Date not null,
    TipoIdentificacion varchar(50) not null,
    PaisResidenciaID int not null,
    Provincia varchar(50) not null,
    Canton varchar(50) not null,
    Distrito varchar(50) not null,
    CorreoElectronico varchar(50) unique not null,
	EsCostaRica bit not null default 0,

	CONSTRAINT CHK_Direccion_CostaRica CHECK (
		(EsCostaRica = 1 AND Provincia IS NOT NULL AND Canton IS NOT NULL AND Distrito IS NOT NULL) OR
		(EsCostaRica = 0 AND Provincia IS NULL AND Canton IS NULL AND Distrito IS NULL)
	), 
  
    constraint FK_Cliente_PaisResidencia foreign key (PaisResidenciaID) references PaisResidencia(PaisResidenciaID),

)

create table TelefonosCliente
(
	TelefonoCID int identity (1,1) primary key,
	CedulaID varchar(20) not null,
	Numero varchar(20) not null,
	CodigoPais varchar(5) not null,
	constraint CHK_ID check (TelefonoCID >= 1 and TelefonoCID <=3),
	constraint FK_TelefonosCliente_ClienteID foreign key (CedulaID) references Cliente (CedulaID) ON DELETE CASCADE
)

create table Reservacion 
(
	ReservacionID int identity (1, 1) primary key,
	CedulaID varchar(20) not null,
	HabitacionID int not null,
	FechaIngreso Datetime not null,
	CantidadPersonas int not null,
	PoseeVehiculo bit not null,
	FechaSalida Datetime not null check(cast(FechaSalida as TIME) <= '12:00:00')
	constraint FK_Reservacion_Cliente foreign key (CedulaID) references Cliente (CedulaID),
	constraint FK_Reservacion_Habitaciones foreign key (HabitacionID) references Habitaciones(HabitacionID)
)

create table MetodoPago (
    MetodoPagoID int identity(1,1) primary key,
    NombreMetodo varchar(50) not null, 
    DetallesAdicionales varchar(255) null 
);

create table Facturacion (
    FacturacionID int identity(1,1) primary key,
    ReservacionID int not null,
    MetodoPagoID int not null,
    FechaEmision datetime default GetDate(),
    ImporteTotal decimal(10,2) not null check (ImporteTotal >= 0.00),
    constraint FK_Facturacion_Reservacion foreign key (ReservacionID) references Reservacion(ReservacionID) on delete cascade,
    constraint FK_Facturacion_MetodoPago foreign key (MetodoPagoID) references MetodoPago(MetodoPagoID)
);

create table EmpresaActividad
(
	CedulaJuridica varchar(20) primary key,
	Nombre varchar(50) not null, 
	CorreoElectronico varchar(100) unique not null,
	Telefono varchar(20) not null,
	NombreContacto varchar(100) not null,
	Provincia varchar(50) not null,
	Canton varchar(50) not null,
	Distrito varchar(50) not null,
	SeñasExactas text not null,
)

create table TipoActividad
(
	TipoActividadID int identity (1,1) primary key,
	Descripcion text not null,
)

create table EmpresaActividadTipo
(
	CedulaJuridica varchar(20) not null,
	TipoActividadID int not null,
	constraint FK_EmpresaActividadTipo_EmpresaActividad foreign key (CedulaJuridica) references EmpresaActividad (CedulaJuridica) ON DELETE CASCADE,
	constraint FK_EmpresaActividadTipo_TipoActividad foreign key (TipoActividadID) references TipoActividad (TipoActividadID) ON DELETE CASCADE
)

create table ServicioActividad
(
	ServicioActividadID int identity(1,1) primary key,
	Nombre varchar(50) not null
)

create table EmpresaActividadServicio
(
	CedulaJuridica varchar(20) not null, ------
	ServicioActividadID int not null,
	constraint FK_EmpresaActividadServicio_EmpresaActividad foreign key (CedulaJuridica) references EmpresaActividad (CedulaJuridica) ON DELETE CASCADE,
	constraint FK_EmpresaActividadServicio_ServicioActividad foreign key (ServicioActividadID) references ServicioActividad (ServicioActividadID) ON DELETE CASCADE
)

Alter table TipoCama add Capacidad int not null
Alter table TipoActividad add Nombre varchar(50) not null
Alter table TipoHabitacion alter column Descripcion varchar(MAX)
Alter table EmpresaActividad add Precio decimal (10,2) not null check(Precio >= 0.00)