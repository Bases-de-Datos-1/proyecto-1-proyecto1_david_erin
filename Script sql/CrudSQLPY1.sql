use SistemaHoteleria

-- CRUD PARA CADA TABLA 

-- TABLA TIPOHOTEL
GO
CREATE PROCEDURE InsertarTipoHotel
    @Nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO TipoHotel (Nombre)
    VALUES (@Nombre);
END;

GO

CREATE PROCEDURE EliminarTipoHotel
    @TipoHotelID INT
AS
BEGIN
    DELETE FROM TipoHotel
    WHERE TipoHotelID = @TipoHotelID;
END;

GO

CREATE PROCEDURE ActualizarTipoHotel
    @TipoHotelID INT,
    @Nombre VARCHAR(100)
AS
BEGIN
    UPDATE TipoHotel
    SET Nombre = @Nombre
    WHERE TipoHotelID = @TipoHotelID;
END;

GO

CREATE PROCEDURE ConsultarTipoHotel
    @Nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT TipoHotelID, Nombre
    FROM TipoHotel
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarTipoHotelSinNombre
AS
BEGIN
    SELECT TipoHotelID, Nombre
    FROM TipoHotel
END;

GO


-- Tabla EmpresaHotel

CREATE PROCEDURE InsertarEmpresaHotel
    @CedulaJuridica VARCHAR(20),
    @Nombre VARCHAR(100),
    @TipoHotelID INT,
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @Barrio VARCHAR(50),
    @SeñasExactas TEXT,
    @ReferenciaGPS VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @URLSitioWeb TEXT = NULL
AS
BEGIN
    INSERT INTO EmpresaHotel (
        CedulaJuridica, Nombre, TipoHotelID, Provincia, Canton, Distrito, Barrio, 
        SeñasExactas, ReferenciaGPS, CorreoElectronico, URLSitioWeb
    )
    VALUES (
        @CedulaJuridica, @Nombre, @TipoHotelID, @Provincia, @Canton, @Distrito, @Barrio, 
        @SeñasExactas, @ReferenciaGPS, @CorreoElectronico, @URLSitioWeb
    );
END;

GO

CREATE PROCEDURE ConsultarEmpresaHotel
    @CedulaJuridica varchar(20) = NULL
AS
BEGIN
    SELECT CedulaJuridica, Nombre, TipoHotelID, Provincia, Canton, Distrito, Barrio, 
           SeñasExactas, ReferenciaGPS, CorreoElectronico, URLSitioWeb
    FROM EmpresaHotel
    WHERE (@CedulaJuridica IS NULL OR CedulaJuridica = @CedulaJuridica)

END;

GO

CREATE PROCEDURE ConsultarEmpresaHotelSinCedula
AS
BEGIN
    SELECT CedulaJuridica, Nombre, TipoHotelID, Provincia, Canton, Distrito, Barrio, 
           SeñasExactas, ReferenciaGPS, CorreoElectronico, URLSitioWeb
    FROM EmpresaHotel
 
END;

GO

CREATE PROCEDURE ActualizarEmpresaHotel
    @CedulaJuridica VARCHAR(20),
    @Nombre VARCHAR(100),
    @TipoHotelID INT,
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @Barrio VARCHAR(50),
    @SeñasExactas TEXT,
    @ReferenciaGPS VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @URLSitioWeb TEXT = NULL
AS
BEGIN
    UPDATE EmpresaHotel
    SET Nombre = @Nombre, 
        TipoHotelID = @TipoHotelID,
        Provincia = @Provincia,
        Canton = @Canton,
        Distrito = @Distrito,
        Barrio = @Barrio,
        SeñasExactas = @SeñasExactas,
        ReferenciaGPS = @ReferenciaGPS,
        CorreoElectronico = @CorreoElectronico,
        URLSitioWeb = @URLSitioWeb
    WHERE CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE EliminarEmpresaHotel
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    DELETE FROM EmpresaHotel
    WHERE CedulaJuridica = @CedulaJuridica;
END;

GO

-- TABLA SERVICIOS

CREATE PROCEDURE InsertarServicio
    @Nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Servicios (Nombre)
    VALUES (@Nombre);
END;

GO

CREATE PROCEDURE ConsultarServicios
    @Nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT ServicioID, Nombre
    FROM Servicios
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarServiciosSinNombre
AS
BEGIN
    SELECT ServicioID, Nombre
    FROM Servicios
END;

GO

CREATE PROCEDURE ActualizarServicio
    @ServicioID INT,
    @Nombre VARCHAR(100)
AS
BEGIN
    UPDATE Servicios
    SET Nombre = @Nombre
    WHERE ServicioID = @ServicioID;
END;

GO

CREATE PROCEDURE EliminarServicio
    @ServicioID INT
AS
BEGIN
    DELETE FROM Servicios
    WHERE ServicioID = @ServicioID;
END;

-- TABLA EMPRESA CON SERVICIOS

GO

CREATE PROCEDURE InsertarHotelServicio
    @CedulaJuridica VARCHAR(20),
    @ServicioID INT
AS
BEGIN
    INSERT INTO HotelServicios (CedulaJuridica, ServicioID)
    VALUES (@CedulaJuridica, @ServicioID);
END;

GO 

CREATE PROCEDURE ConsultarHotelServicios
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    SELECT HS.CedulaJuridica, S.Nombre AS NombreServicio
    FROM HotelServicios HS
    JOIN Servicios S ON HS.ServicioID = S.ServicioID
    WHERE HS.CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE ConsultarHotelServiciosGen
AS
BEGIN
    SELECT HS.CedulaJuridica, S.Nombre AS NombreServicio
    FROM HotelServicios HS
    JOIN Servicios S ON HS.ServicioID = S.ServicioID
END;

GO

CREATE PROCEDURE EliminarHotelServicio
    @CedulaJuridica VARCHAR(20),
    @ServicioID INT
AS
BEGIN
    DELETE FROM HotelServicios
    WHERE CedulaJuridica = @CedulaJuridica AND ServicioID = @ServicioID;
END;

GO

-- Tabla TelefonosEmpresa
CREATE PROCEDURE InsertarTelefonoEmpresa
    @Numero VARCHAR(20),
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    INSERT INTO TelefonosEmpresa (Numero, CedulaJuridica)
    VALUES (@Numero, @CedulaJuridica);
END;

GO

CREATE PROCEDURE ConsultarTelefonosPorEmpresa
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    SELECT TelefonoID, Numero
    FROM TelefonosEmpresa
    WHERE CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE ActualizarTelefonoEmpresa
    @TelefonoID INT,
    @Numero VARCHAR(20)
AS
BEGIN
    UPDATE TelefonosEmpresa
    SET Numero = @Numero
    WHERE TelefonoID = @TelefonoID;
END;

GO

CREATE PROCEDURE EliminarTelefonoEmpresa
    @TelefonoID INT
AS
BEGIN
    DELETE FROM TelefonosEmpresa
    WHERE TelefonoID = @TelefonoID;
END;

GO
-- Tabla RedSocial
CREATE PROCEDURE InsertarRedSocial
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO RedSocial (Nombre)
    VALUES (@Nombre);
END;

GO

CREATE PROCEDURE ConsultarRedesSociales
    @Nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT RedSocialID, Nombre
    FROM RedSocial
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarRedesSocialesSinNombre
AS
BEGIN
    SELECT RedSocialID, Nombre
    FROM RedSocial
END;

GO

CREATE PROCEDURE ActualizarRedSocial
    @RedSocialID INT,
    @Nombre VARCHAR(50)
AS
BEGIN
    UPDATE RedSocial
    SET Nombre = @Nombre
    WHERE RedSocialID = @RedSocialID;
END;

GO

CREATE PROCEDURE EliminarRedSocial
    @RedSocialID INT
AS
BEGIN
    DELETE FROM RedSocial
    WHERE RedSocialID = @RedSocialID;
END;

GO

-- Tabla RedSocialHotel

CREATE PROCEDURE InsertarRedSocialHotel
    @NombreUsuario VARCHAR(150),
    @RedSocialID INT,
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    INSERT INTO RedSocialHotel (NombreUsuario, RedSocialID, CedulaJuridica)
    VALUES (@NombreUsuario, @RedSocialID, @CedulaJuridica);
END;

GO

CREATE PROCEDURE ConsultarRedesSocialesPorHotel
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    SELECT RSH.NombreUsuario, RS.Nombre AS RedSocial
    FROM RedSocialHotel RSH
    JOIN RedSocial RS ON RSH.RedSocialID = RS.RedSocialID
    WHERE RSH.CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE ActualizarRedSocialHotel
    @NombreUsuario VARCHAR(150),
    @RedSocialID INT,
    @CedulaJuridica VARCHAR(20),
    @NuevoNombreUsuario VARCHAR(150)
AS
BEGIN
    UPDATE RedSocialHotel
    SET NombreUsuario = @NuevoNombreUsuario
    WHERE NombreUsuario = @NombreUsuario
      AND RedSocialID = @RedSocialID
      AND CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE EliminarRedSocialHotel
    @NombreUsuario VARCHAR(150),
    @RedSocialID INT,
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    DELETE FROM RedSocialHotel
    WHERE NombreUsuario = @NombreUsuario
      AND RedSocialID = @RedSocialID
      AND CedulaJuridica = @CedulaJuridica;
END;

GO

-- Tabla TipoDeCama

CREATE PROCEDURE InsertarTipoCama
    @Nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO TipoCama (Nombre)
    VALUES (@Nombre);
END;

GO

CREATE PROCEDURE ConsultarTipoCama
    @Nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT TipoCamaID, Nombre
    FROM TipoCama
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarTipoCamaSinNombre
AS
BEGIN
    SELECT TipoCamaID, Nombre
    FROM TipoCama
END;

GO

CREATE PROCEDURE ActualizarTipoCama
    @TipoCamaID INT,
    @Nombre VARCHAR(100)
AS
BEGIN
    UPDATE TipoCama
    SET Nombre = @Nombre
    WHERE TipoCamaID = @TipoCamaID;
END;

GO

CREATE PROCEDURE EliminarTipoCama
    @TipoCamaID INT
AS
BEGIN
    DELETE FROM TipoCama
    WHERE TipoCamaID = @TipoCamaID;
END;

GO

-- Tabla TipoHabitacion

CREATE PROCEDURE InsertarTipoHabitacion
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(MAX),
    @Precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO TipoHabitacion (Nombre, Descripcion, Precio)
    VALUES (@Nombre, @Descripcion, @Precio);
END;

GO

CREATE PROCEDURE ConsultarTipoHabitacion
    @Nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT TipoHabitacionID, Nombre, Descripcion, Precio
    FROM TipoHabitacion
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarTipoHabitacionSinNombre
AS
BEGIN
    SELECT TipoHabitacionID, Nombre, Descripcion, Precio
    FROM TipoHabitacion
END;

GO

CREATE PROCEDURE ActualizarTipoHabitacion
    @TipoHabitacionID INT,
    @Nombre VARCHAR(50),
    @Descripcion TEXT,
    @Precio DECIMAL(10,2)
AS
BEGIN
    UPDATE TipoHabitacion
    SET Nombre = @Nombre, Descripcion = @Descripcion, Precio = @Precio
    WHERE TipoHabitacionID = @TipoHabitacionID;
END;

GO

CREATE PROCEDURE EliminarTipoHabitacion
    @TipoHabitacionID INT
AS
BEGIN
    DELETE FROM TipoHabitacion
    WHERE TipoHabitacionID = @TipoHabitacionID;
END;

GO


-- Tabla TipoHabitacionCama
CREATE PROCEDURE InsertarTipoHabitacionCama
    @TipoHabitacionID INT,
    @TipoCamaID INT,
    @Cantidad INT
AS
BEGIN
    INSERT INTO TipoHabitacionCama (TipoHabitacionID, TipoCamaID, Cantidad)
    VALUES (@TipoHabitacionID, @TipoCamaID, @Cantidad);
END;

GO

CREATE PROCEDURE ConsultarTipoHabitacionCama
    @TipoHabitacionID INT
AS
BEGIN
    SELECT THC.TipoHabitacionID, THC.TipoCamaID, TC.Nombre AS NombreCama, THC.Cantidad
    FROM TipoHabitacionCama THC
    JOIN TipoCama TC ON THC.TipoCamaID = TC.TipoCamaID
    WHERE THC.TipoHabitacionID = @TipoHabitacionID;
END;

GO

CREATE PROCEDURE ConsultarTipoHabitacionCamaGen
AS
BEGIN
    SELECT TH.Nombre AS NombreTipoHabitacion, TC.Nombre AS NombreCama, THC.Cantidad AS CantidadCamas
    FROM TipoHabitacionCama THC
	JOIN TipoHabitacion TH ON THC.TipoHabitacionID = TH.TipoHabitacionID
    JOIN TipoCama TC ON THC.TipoCamaID = TC.TipoCamaID
    
END;

GO

CREATE PROCEDURE ActualizarTipoHabitacionCama
    @TipoHabitacionID INT,
    @TipoCamaID INT,
    @Cantidad INT
AS
BEGIN
    UPDATE TipoHabitacionCama
    SET Cantidad = @Cantidad
    WHERE TipoHabitacionID = @TipoHabitacionID AND TipoCamaID = @TipoCamaID;
END;

GO

CREATE PROCEDURE EliminarTipoHabitacionCama
    @TipoHabitacionID INT,
    @TipoCamaID INT
AS
BEGIN
    DELETE FROM TipoHabitacionCama
    WHERE TipoHabitacionID = @TipoHabitacionID AND TipoCamaID = @TipoCamaID;
END;

GO

-- Tabla FotosHabitacion

CREATE PROCEDURE InsertarFotoHabitacion
    @Fotos IMAGE,
    @TipoHabitacionID INT
AS
BEGIN
    INSERT INTO FotosHabitacion (Fotos, TipoHabitacionID)
    VALUES (@Fotos, @TipoHabitacionID);
END;

GO

CREATE PROCEDURE ConsultarFotosHabitacion
    @TipoHabitacionID INT
AS
BEGIN
    SELECT FotoID, Fotos
    FROM FotosHabitacion
    WHERE TipoHabitacionID = @TipoHabitacionID;
END;

GO

CREATE PROCEDURE ActualizarFotoHabitacion
    @FotoID INT,
    @Fotos IMAGE
AS
BEGIN
    UPDATE FotosHabitacion
    SET Fotos = @Fotos
    WHERE FotoID = @FotoID;
END;

GO

CREATE PROCEDURE EliminarFotoHabitacion
    @FotoID INT
AS
BEGIN
    DELETE FROM FotosHabitacion
    WHERE FotoID = @FotoID;
END;

GO

-- Tabla Comodidades

CREATE PROCEDURE InsertarComodidad
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Comodidades (Nombre)
    VALUES (@Nombre);
END;

GO

CREATE PROCEDURE ConsultarComodidades
    @Nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT ComodidadID, Nombre
    FROM Comodidades
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarComodidadesSinNombre
AS
BEGIN
    SELECT ComodidadID, Nombre
    FROM Comodidades
END;

GO

CREATE PROCEDURE ActualizarComodidad
    @ComodidadID INT,
    @Nombre VARCHAR(50)
AS
BEGIN
    UPDATE Comodidades
    SET Nombre = @Nombre
    WHERE ComodidadID = @ComodidadID;
END;

GO

CREATE PROCEDURE EliminarComodidad
    @ComodidadID INT
AS
BEGIN
    DELETE FROM Comodidades
    WHERE ComodidadID = @ComodidadID;
END;

GO

-- Tabla TipoHabitacionComodidad

CREATE PROCEDURE InsertarTipoHabitacionComodidad
    @TipoHabitacionID INT,
    @ComodidadID INT
AS
BEGIN
    INSERT INTO TipoHabitacionComodidad (TipoHabitacionID, ComodidadID)
    VALUES (@TipoHabitacionID, @ComodidadID);
END;

GO

CREATE PROCEDURE ConsultarTipoHabitacionComodidades
    @TipoHabitacionID INT
AS
BEGIN
    SELECT THC.TipoHabitacionID, THC.ComodidadID, C.Nombre AS NombreComodidad
    FROM TipoHabitacionComodidad THC
    JOIN Comodidades C ON THC.ComodidadID = C.ComodidadID
    WHERE THC.TipoHabitacionID = @TipoHabitacionID;
END;

GO

CREATE PROCEDURE ConsultarTipoHabitacionComodidadesGen
AS
BEGIN
    SELECT TH.Nombre AS NombreTipoHabitacion, C.Nombre AS NombreComodidad
    FROM TipoHabitacionComodidad THC
	Join TipoHabitacion TH ON THC.TipoHabitacionID = TH.TipoHabitacionID
    JOIN Comodidades C ON THC.ComodidadID = C.ComodidadID
END;

GO

CREATE PROCEDURE EliminarTipoHabitacionComodidad
    @TipoHabitacionID INT,
    @ComodidadID INT
AS
BEGIN
    DELETE FROM TipoHabitacionComodidad
    WHERE TipoHabitacionID = @TipoHabitacionID AND ComodidadID = @ComodidadID;
END;

GO

-- Tabla Habitaciones

CREATE PROCEDURE InsertarHabitacion
    @Numero VARCHAR(20),
    @CedulaJuridica VARCHAR(20),
    @TipoHabitacionID INT
AS
BEGIN
    INSERT INTO Habitaciones (Numero, CedulaJuridica, TipoHabitacionID)
    VALUES (@Numero, @CedulaJuridica, @TipoHabitacionID);
END;

GO

CREATE PROCEDURE ConsultarHabitaciones
    @CedulaJuridica VARCHAR(20) = NULL,
    @TipoHabitacionID INT = NULL
AS
BEGIN
    SELECT H.HabitacionID, H.Numero, H.CedulaJuridica, TH.Nombre AS TipoHabitacion
    FROM Habitaciones H
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    WHERE (@CedulaJuridica IS NULL OR H.CedulaJuridica = @CedulaJuridica)
      AND (@TipoHabitacionID IS NULL OR H.TipoHabitacionID = @TipoHabitacionID);
END;

GO

CREATE PROCEDURE ConsultarHabitacionesGen
AS
BEGIN
    SELECT H.HabitacionID, H.Numero, H.CedulaJuridica AS CedHotel, TH.Nombre AS TipoHabitacion
    FROM Habitaciones H
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
END;

GO

CREATE PROCEDURE ActualizarHabitacion
    @HabitacionID INT,
    @Numero VARCHAR(20),
    @TipoHabitacionID INT
AS
BEGIN
    UPDATE Habitaciones
    SET Numero = @Numero,
        TipoHabitacionID = @TipoHabitacionID
    WHERE HabitacionID = @HabitacionID;
END;

GO

CREATE PROCEDURE EliminarHabitacion
    @HabitacionID INT
AS
BEGIN
    DELETE FROM Habitaciones
    WHERE HabitacionID = @HabitacionID;
END;

GO


-- TABLA PAIS RESIDENCIA

CREATE PROCEDURE InsertarPaisResidencia
    @NombrePais VARCHAR(50)
AS
BEGIN
    INSERT INTO PaisResidencia (NombrePais)
    VALUES (@NombrePais);
END;

GO

CREATE PROCEDURE ConsultarPaisResidencia
    @NombrePais VARCHAR(50) = NULL
AS
BEGIN
    SELECT PaisResidenciaID, NombrePais
    FROM PaisResidencia
    WHERE @NombrePais IS NULL OR NombrePais LIKE '%' + @NombrePais + '%';
END;

GO

CREATE PROCEDURE ConsultarPaisResidenciaSinNombre
AS
BEGIN
    SELECT PaisResidenciaID, NombrePais
    FROM PaisResidencia
END;

GO

CREATE PROCEDURE ActualizarPaisResidencia
    @PaisResidenciaID INT,
    @NombrePais VARCHAR(50)
AS
BEGIN
    UPDATE PaisResidencia
    SET NombrePais = @NombrePais
    WHERE PaisResidenciaID = @PaisResidenciaID;
END;

GO

CREATE PROCEDURE EliminarPaisResidencia
    @PaisResidenciaID INT
AS
BEGIN
    DELETE FROM PaisResidencia
    WHERE PaisResidenciaID = @PaisResidenciaID;
END;

GO



-- TABLA CLIENTE

CREATE PROCEDURE InsertarCliente
    @CedulaID VARCHAR(20),
    @Nombre VARCHAR(100),
    @PrimerApellido VARCHAR(100),
    @SegundoApellido VARCHAR(100),
    @FechaNacimiento DATE,
    @TipoIdentificacion VARCHAR(50),
    @PaisResidenciaID INT,
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @CorreoElectronico VARCHAR(50)
AS
BEGIN
	DECLARE @EsCostaRica BIT;
    
    SELECT @EsCostaRica = CASE 
                             WHEN NombrePais = 'Costa Rica' THEN 1
                             ELSE 0
                          END
    FROM PaisResidencia
    WHERE PaisResidenciaID = @PaisResidenciaID;


    INSERT INTO Cliente (
        CedulaID, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento,
        TipoIdentificacion, PaisResidenciaID, Provincia, Canton, Distrito,
        CorreoElectronico, EsCostaRica
    )
    VALUES (
        @CedulaID, @Nombre, @PrimerApellido, @SegundoApellido, @FechaNacimiento,
        @TipoIdentificacion, @PaisResidenciaID, @Provincia, @Canton, @Distrito,
        @CorreoElectronico, @EsCostaRica
    );
END;

GO

CREATE PROCEDURE ConsultarCliente
    @CedulaID INT = NULL
AS
BEGIN
    SELECT C.CedulaID, C.Nombre, C.PrimerApellido, C.SegundoApellido, C.FechaNacimiento,
           C.TipoIdentificacion, C.PaisResidenciaID, P.NombrePais, C.Provincia,
           C.Canton, C.Distrito, C.CorreoElectronico, C.EsCostaRica
    FROM Cliente C
	JOIN PaisResidencia P on P.PaisResidenciaID = C.PaisResidenciaID
    WHERE @CedulaID IS NULL OR C.CedulaID = @CedulaID;
END;

GO

CREATE PROCEDURE ConsultarClientesGen
AS
BEGIN
    SELECT C.CedulaID, C.Nombre, C.PrimerApellido, C.SegundoApellido, C.FechaNacimiento,
           C.TipoIdentificacion, C.PaisResidenciaID, P.NombrePais, C.Provincia,
           C.Canton, C.Distrito, C.CorreoElectronico, C.EsCostaRica
    FROM Cliente C
	JOIN PaisResidencia P on P.PaisResidenciaID = C.PaisResidenciaID
END;

GO

CREATE PROCEDURE ActualizarCliente
    @CedulaID VARCHAR(20),
    @Nombre VARCHAR(100),
    @PrimerApellido VARCHAR(100),
    @SegundoApellido VARCHAR(100),
    @FechaNacimiento DATE,
    @TipoIdentificacion VARCHAR(50),
    @PaisResidenciaID INT,
    @Provincia VARCHAR(50) = NULL,
    @Canton VARCHAR(50) = NULL,
    @Distrito VARCHAR(50) = NULL,
    @CorreoElectronico VARCHAR(50),
    @EsCostaRica BIT
AS
BEGIN
    UPDATE Cliente
    SET Nombre = @Nombre, PrimerApellido = @PrimerApellido, SegundoApellido = @SegundoApellido,
        FechaNacimiento = @FechaNacimiento, TipoIdentificacion = @TipoIdentificacion,
        PaisResidenciaID = @PaisResidenciaID, Provincia = @Provincia, Canton = @Canton,
        Distrito = @Distrito, CorreoElectronico = @CorreoElectronico, EsCostaRica = @EsCostaRica
    WHERE CedulaID = @CedulaID;
END;

GO

CREATE PROCEDURE EliminarCliente
    @CedulaID VARCHAR(20)
AS
BEGIN
    DELETE FROM Cliente
    WHERE CedulaID = @CedulaID;
END;

GO

-- TABLA TELEFONOSCLIENTE

CREATE PROCEDURE InsertarTelefonoCliente
    @CedulaID VARCHAR(20),
    @Numero VARCHAR(20),
    @CodigoPais VARCHAR(5)
AS
BEGIN
    INSERT INTO TelefonosCliente (CedulaID, Numero, CodigoPais)
    VALUES (@CedulaID, @Numero, @CodigoPais);
END;

GO

CREATE PROCEDURE ConsultarTelefonosCliente
    @CedulaID VARCHAR(20)
AS
BEGIN
    SELECT TelefonoCID, Numero, CodigoPais
    FROM TelefonosCliente
    WHERE CedulaID = @CedulaID;
END;

GO

CREATE PROCEDURE ActualizarTelefonoCliente
    @TelefonoCID INT,
    @Numero VARCHAR(20),
    @CodigoPais VARCHAR(5)
AS
BEGIN
    UPDATE TelefonosCliente
    SET Numero = @Numero, CodigoPais = @CodigoPais
    WHERE TelefonoCID = @TelefonoCID;
END;

GO

CREATE PROCEDURE EliminarTelefonoCliente
    @TelefonoCID INT
AS
BEGIN
    DELETE FROM TelefonosCliente
    WHERE TelefonoCID = @TelefonoCID;
END;

GO

-- Tabla Reservacion

CREATE PROCEDURE InsertarReservacion
    @CedulaID VARCHAR(20),
    @HabitacionID INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME,
    @CantidadPersonas INT,
    @PoseeVehiculo BIT
AS
BEGIN
    INSERT INTO Reservacion (CedulaID, HabitacionID, FechaIngreso, FechaSalida, CantidadPersonas, PoseeVehiculo)
    VALUES (@CedulaID, @HabitacionID, @FechaIngreso, @FechaSalida, @CantidadPersonas, @PoseeVehiculo);
END;

GO

CREATE PROCEDURE ConsultarReservaciones
    @ReservacionID int = NULL
AS
BEGIN
    SELECT R.ReservacionID, R.CedulaID, R.HabitacionID, R.FechaIngreso, R.FechaSalida, R.CantidadPersonas, R.PoseeVehiculo
    FROM Reservacion R
END;

GO

CREATE PROCEDURE ConsultarReservacionesEsp
    @ReservacionID int = NULL
AS
BEGIN
    SELECT R.ReservacionID, R.CedulaID, R.HabitacionID, R.FechaIngreso, R.FechaSalida, R.CantidadPersonas, R.PoseeVehiculo
    FROM Reservacion R
	WHERE R.ReservacionID = @ReservacionID
END;

GO

CREATE PROCEDURE ActualizarReservacion
    @ReservacionID INT,
    @HabitacionID INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME,
    @CantidadPersonas INT,
    @PoseeVehiculo BIT
AS
BEGIN
    UPDATE Reservacion
    SET HabitacionID = @HabitacionID, FechaIngreso = @FechaIngreso, FechaSalida = @FechaSalida,
        CantidadPersonas = @CantidadPersonas, PoseeVehiculo = @PoseeVehiculo
    WHERE ReservacionID = @ReservacionID;
END;

GO

CREATE PROCEDURE EliminarReservacion
    @ReservacionID INT
AS
BEGIN
    DELETE FROM Reservacion
    WHERE ReservacionID = @ReservacionID;
END;

GO


-- Tabla Metodo Pago

CREATE PROCEDURE InsertarMetodoPago
    @NombreMetodo VARCHAR(50),
    @DetallesAdicionales VARCHAR(255) = NULL
AS
BEGIN
    INSERT INTO MetodoPago (NombreMetodo, DetallesAdicionales)
    VALUES (@NombreMetodo, @DetallesAdicionales);
END;

GO

CREATE PROCEDURE ConsultarMetodoPago
    @NombreMetodo VARCHAR(50) = NULL
AS
BEGIN
    SELECT MetodoPagoID, NombreMetodo, DetallesAdicionales
    FROM MetodoPago
    WHERE @NombreMetodo IS NULL OR NombreMetodo LIKE '%' + @NombreMetodo + '%';
END;

GO

CREATE PROCEDURE ConsultarMetodoPagoSinNombre
AS
BEGIN
    SELECT MetodoPagoID, NombreMetodo, DetallesAdicionales
    FROM MetodoPago
END;

GO

CREATE PROCEDURE ActualizarMetodoPago
    @MetodoPagoID INT,
    @NombreMetodo VARCHAR(50),
    @DetallesAdicionales VARCHAR(255)
AS
BEGIN
    UPDATE MetodoPago
    SET NombreMetodo = @NombreMetodo, DetallesAdicionales = @DetallesAdicionales
    WHERE MetodoPagoID = @MetodoPagoID;
END;

GO

CREATE PROCEDURE EliminarMetodoPago
    @MetodoPagoID INT
AS
BEGIN
    DELETE FROM MetodoPago
    WHERE MetodoPagoID = @MetodoPagoID;
END;

GO


-- Tabla Facturacion

CREATE PROCEDURE InsertarFacturacion
    @ReservacionID INT,
    @MetodoPagoID INT,
    @ImporteTotal DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Facturacion (ReservacionID, MetodoPagoID, FechaEmision, ImporteTotal)
    VALUES (@ReservacionID, @MetodoPagoID, GETDATE(), @ImporteTotal);
END;

GO

CREATE PROCEDURE ConsultarFacturacion
    @ReservacionID INT = NULL
AS
BEGIN
    SELECT F.FacturacionID, F.ReservacionID, R.FechaIngreso, R.FechaSalida, F.MetodoPagoID, MP.NombreMetodo, F.FechaEmision, F.ImporteTotal
    FROM Facturacion F
    JOIN Reservacion R ON F.ReservacionID = R.ReservacionID
    JOIN MetodoPago MP ON F.MetodoPagoID = MP.MetodoPagoID
    WHERE @ReservacionID IS NULL OR F.ReservacionID = @ReservacionID;
END;

GO

CREATE PROCEDURE ActualizarFacturacion
    @FacturacionID INT,
    @MetodoPagoID INT,
    @ImporteTotal DECIMAL(10,2)
AS
BEGIN
    UPDATE Facturacion
    SET MetodoPagoID = @MetodoPagoID, ImporteTotal = @ImporteTotal
    WHERE FacturacionID = @FacturacionID;
END;

GO

CREATE PROCEDURE EliminarFacturacion
    @FacturacionID INT
AS
BEGIN
    DELETE FROM Facturacion
    WHERE FacturacionID = @FacturacionID;
END;

GO

-- TABLA EmpresaActividad

CREATE PROCEDURE InsertarEmpresaActividad
    @CedulaJuridica VARCHAR(20),
    @Nombre VARCHAR(50),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(20),
    @NombreContacto VARCHAR(100),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @SeñasExactas TEXT
AS
BEGIN
    INSERT INTO EmpresaActividad (
        CedulaJuridica, Nombre, CorreoElectronico, Telefono, NombreContacto,
        Provincia, Canton, Distrito, SeñasExactas
    )
    VALUES (
        @CedulaJuridica, @Nombre, @CorreoElectronico, @Telefono, @NombreContacto,
        @Provincia, @Canton, @Distrito, @SeñasExactas
    );
END;

GO

CREATE PROCEDURE ConsultarEmpresaActividad
    @Nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT *
    FROM EmpresaActividad
    WHERE @Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%';
END;

GO

CREATE PROCEDURE ConsultarEmpresaActividadGen
AS
BEGIN
    SELECT *
    FROM EmpresaActividad
END;

GO

CREATE PROCEDURE ActualizarEmpresaActividad
    @CedulaJuridica VARCHAR(20),
    @Nombre VARCHAR(50),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(20),
    @NombreContacto VARCHAR(100),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @SeñasExactas TEXT
AS
BEGIN
    UPDATE EmpresaActividad
    SET Nombre = @Nombre,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        NombreContacto = @NombreContacto,
        Provincia = @Provincia,
        Canton = @Canton,
        Distrito = @Distrito,
        SeñasExactas = @SeñasExactas
    WHERE CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE EliminarEmpresaActividad
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    DELETE FROM EmpresaActividad
    WHERE CedulaJuridica = @CedulaJuridica;
END;

GO

-- TABLA TipoActividad

CREATE PROCEDURE InsertarTipoActividad
    @Descripcion TEXT
AS
BEGIN
    INSERT INTO TipoActividad (Descripcion)
    VALUES (@Descripcion);
END;

GO

CREATE PROCEDURE ConsultarTiposActividad
AS
BEGIN
    SELECT * FROM TipoActividad;
END;

GO

CREATE PROCEDURE ActualizarTipoActividad
    @TipoActividadID INT,
    @Descripcion TEXT
AS
BEGIN
    UPDATE TipoActividad
    SET Descripcion = @Descripcion
    WHERE TipoActividadID = @TipoActividadID;
END;

GO

CREATE PROCEDURE EliminarTipoActividad
    @TipoActividadID INT
AS
BEGIN
    DELETE FROM TipoActividad
    WHERE TipoActividadID = @TipoActividadID;
END;

GO

-- TABLA EmpresaActividadTipo

CREATE PROCEDURE InsertarEmpresaActividadTipo
    @CedulaJuridica VARCHAR(20),
    @TipoActividadID INT,
    @Precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO EmpresaActividadTipo (CedulaJuridica, TipoActividadID, Precio)
    VALUES (@CedulaJuridica, @TipoActividadID, @Precio);
END;

GO

CREATE PROCEDURE ConsultarEmpresaActividadTipo
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    SELECT EAT.CedulaJuridica, EAT.TipoActividadID, TA.Descripcion, EAT.Precio
    FROM EmpresaActividadTipo EAT
    JOIN TipoActividad TA ON EAT.TipoActividadID = TA.TipoActividadID
    WHERE EAT.CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE ActualizarEmpresaActividadTipo
    @CedulaJuridica VARCHAR(20),
    @TipoActividadID INT,
    @Precio DECIMAL(10,2)
AS
BEGIN
    UPDATE EmpresaActividadTipo
    SET Precio = @Precio
    WHERE CedulaJuridica = @CedulaJuridica AND TipoActividadID = @TipoActividadID;
END;

GO

CREATE PROCEDURE EliminarEmpresaActividadTipo
    @CedulaJuridica VARCHAR(20),
    @TipoActividadID INT
AS
BEGIN
    DELETE FROM EmpresaActividadTipo
    WHERE CedulaJuridica = @CedulaJuridica AND TipoActividadID = @TipoActividadID;
END;

GO

-- TABLA ServicioActividad

CREATE PROCEDURE InsertarServicioActividad
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO ServicioActividad (Nombre)
    VALUES (@Nombre);
END;

GO

CREATE PROCEDURE ConsultarServiciosActividad
AS
BEGIN
    SELECT * FROM ServicioActividad;
END;

GO

CREATE PROCEDURE EliminarServicioActividad
    @ServicioActividadID INT
AS
BEGIN
    DELETE FROM ServicioActividad
    WHERE ServicioActividadID = @ServicioActividadID;
END;

GO

-- TABLA EmpresaActividadServicios

CREATE PROCEDURE InsertarEmpresaActividadServicio
    @CedulaJuridica VARCHAR(20),
    @ServicioActividadID INT
AS
BEGIN
    INSERT INTO EmpresaActividadServicio (CedulaJuridica, ServicioActividadID)
    VALUES (@CedulaJuridica, @ServicioActividadID);
END;

GO

CREATE PROCEDURE ConsultarEmpresaActividadServicio
    @CedulaJuridica VARCHAR(20)
AS
BEGIN
    SELECT EAS.CedulaJuridica, EAS.ServicioActividadID, SA.Nombre AS NombreServicio
    FROM EmpresaActividadServicio EAS
    JOIN ServicioActividad SA ON EAS.ServicioActividadID = SA.ServicioActividadID
    WHERE EAS.CedulaJuridica = @CedulaJuridica;
END;

GO

CREATE PROCEDURE EliminarEmpresaActividadServicio
    @CedulaJuridica VARCHAR(20),
    @ServicioActividadID INT
AS
BEGIN
    DELETE FROM EmpresaActividadServicio
    WHERE CedulaJuridica = @CedulaJuridica AND ServicioActividadID = @ServicioActividadID;
END;