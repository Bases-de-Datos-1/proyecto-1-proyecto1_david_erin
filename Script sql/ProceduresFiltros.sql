use SistemaHoteleria

GO
CREATE PROCEDURE BuscarReservacion
    @ReservacionID INT
AS
BEGIN
    SELECT R.ReservacionID, H.Numero AS NumeroHabitacion, 
           DATEDIFF(day, R.FechaIngreso, R.FechaSalida) AS Noches,
           F.ImporteTotal
    FROM Reservacion R
    JOIN Habitaciones H ON R.HabitacionID = H.HabitacionID
    JOIN Facturacion F ON R.ReservacionID = F.ReservacionID
    WHERE R.ReservacionID = @ReservacionID;
END;

GO

CREATE PROCEDURE VerFacturacion
    @ModoConsulta VARCHAR(10), -- Puede ser 'DIA', 'MES', 'AÑO' o 'RANGO'
    @FechaInicio DATETIME = NULL,
    @FechaFin DATETIME = NULL
AS
BEGIN
    IF @ModoConsulta = 'DIA'
    BEGIN
        SELECT CAST(F.FechaEmision AS DATE) AS Dia, 
               SUM(F.ImporteTotal) AS TotalFacturado
        FROM Facturacion F
        GROUP BY CAST(F.FechaEmision AS DATE)
        ORDER BY Dia;
    END

    ELSE IF @ModoConsulta = 'MES'
    BEGIN
        SELECT FORMAT(F.FechaEmision, 'yyyy-MM') AS Mes, 
               SUM(F.ImporteTotal) AS TotalFacturado
        FROM Facturacion F
        GROUP BY FORMAT(F.FechaEmision, 'yyyy-MM')
        ORDER BY Mes;
    END

    ELSE IF @ModoConsulta = 'AÑO'
    BEGIN
        SELECT YEAR(F.FechaEmision) AS Año, 
               SUM(F.ImporteTotal) AS TotalFacturado
        FROM Facturacion F
        GROUP BY YEAR(F.FechaEmision)
        ORDER BY Año;
    END

    ELSE IF @ModoConsulta = 'RANGO' AND @FechaInicio IS NOT NULL AND @FechaFin IS NOT NULL
    BEGIN
        SELECT CAST(F.FechaEmision AS DATE) AS Dia, 
               SUM(F.ImporteTotal) AS TotalFacturado
        FROM Facturacion F
        WHERE F.FechaEmision BETWEEN @FechaInicio AND @FechaFin
        GROUP BY CAST(F.FechaEmision AS DATE)
        ORDER BY Dia;
    END
END;

GO

CREATE PROCEDURE FacturacionPorTipoHabitacion
AS
BEGIN
    SELECT TH.Nombre AS TipoHabitacion, 
           SUM(F.ImporteTotal) AS TotalFacturado
    FROM Facturacion F
    JOIN Reservacion R ON F.ReservacionID = R.ReservacionID
    JOIN Habitaciones H ON R.HabitacionID = H.HabitacionID
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    GROUP BY TH.Nombre
    ORDER BY TotalFacturado DESC;
END;

GO

CREATE PROCEDURE FacturacionPorHabitacion
    @HabitacionID INT
AS
BEGIN
    SELECT H.Numero AS NumeroHabitacion, 
           SUM(F.ImporteTotal) AS TotalFacturado
    FROM Facturacion F
    JOIN Reservacion R ON F.ReservacionID = R.ReservacionID
    JOIN Habitaciones H ON R.HabitacionID = H.HabitacionID
    WHERE H.HabitacionID = @HabitacionID
    GROUP BY H.Numero
    ORDER BY TotalFacturado DESC;
END;

GO

CREATE PROCEDURE BuscarHotelesDisponibles
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME,
    @CantidadPersonas INT
AS
BEGIN
    SELECT DISTINCT EH.Nombre AS Hotel, 
           EH.Provincia, EH.Canton, EH.Distrito, 
           SUM(THC.Cantidad * TC.Capacidad) AS CapacidadTotal
    FROM EmpresaHotel EH
    JOIN Habitaciones H ON EH.CedulaJuridica = H.CedulaJuridica
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    JOIN TipoHabitacionCama THC ON TH.TipoHabitacionID = THC.TipoHabitacionID
    JOIN TipoCama TC ON THC.TipoCamaID = TC.TipoCamaID
    WHERE EH.Provincia = @Provincia
      AND EH.Canton = @Canton
      AND EH.Distrito = @Distrito
      AND H.HabitacionID NOT IN (
          SELECT R.HabitacionID
          FROM Reservacion R
          WHERE @FechaSalida > R.FechaIngreso 
            AND @FechaIngreso < R.FechaSalida
      )
    GROUP BY EH.Nombre, EH.Provincia, EH.Canton, EH.Distrito
    HAVING SUM(THC.Cantidad * TC.Capacidad) >= @CantidadPersonas
END;

GO

CREATE PROCEDURE BuscarTiposHabitacionPorHotel
    @CedulaJuridica VARCHAR(20),
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME,
    @CantidadPersonas INT
AS
BEGIN
    SELECT TH.Nombre AS TipoHabitacion, 
           TH.Descripcion, 
           SUM(THC.Cantidad * TC.Capacidad) AS CapacidadTotal, 
           TH.Precio,
           STRING_AGG(CONCAT(TC.Nombre, ' x', THC.Cantidad), ', ') AS ConfiguracionCamas
    FROM Habitaciones H
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    JOIN TipoHabitacionCama THC ON TH.TipoHabitacionID = THC.TipoHabitacionID
    JOIN TipoCama TC ON THC.TipoCamaID = TC.TipoCamaID
    WHERE H.CedulaJuridica = @CedulaJuridica
      AND H.HabitacionID NOT IN (
          SELECT R.HabitacionID
          FROM Reservacion R
          WHERE @FechaSalida > R.FechaIngreso
            AND @FechaIngreso < R.FechaSalida
      )
    GROUP BY TH.Nombre, TH.Descripcion, TH.Precio
    HAVING SUM(THC.Cantidad * TC.Capacidad) >= @CantidadPersonas
    ORDER BY TH.Precio;
END;

GO

CREATE PROCEDURE BuscarHotelesPorPrecio
    @Provincia VARCHAR(50),
    @PrecioMin DECIMAL(10,2),
    @PrecioMax DECIMAL(10,2)
AS
BEGIN
    SELECT EH.Nombre AS Hotel, TH.Nombre AS TipoHabitacion, TH.Precio
    FROM EmpresaHotel EH
    JOIN Habitaciones H ON EH.CedulaJuridica = H.CedulaJuridica
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    WHERE EH.Provincia = @Provincia
      AND TH.Precio BETWEEN @PrecioMin AND @PrecioMax
    ORDER BY TH.Precio;
END;

GO

CREATE PROCEDURE BuscarHotelesPorServicios
    @Provincia VARCHAR(50),
    @Servicios VARCHAR(255)
AS
BEGIN
    SELECT EH.Nombre AS Hotel, TH.Nombre AS TipoHabitacion, S.Nombre AS Servicio
    FROM EmpresaHotel EH
    JOIN Habitaciones H ON EH.CedulaJuridica = H.CedulaJuridica
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    JOIN HotelServicios HS ON EH.CedulaJuridica = HS.CedulaJuridica
    JOIN Servicios S ON HS.ServicioID = S.ServicioID
    WHERE EH.Provincia = @Provincia
      AND S.Nombre IN (SELECT value FROM STRING_SPLIT(@Servicios, ','))
    ORDER BY TH.Precio;
END;

GO

CREATE PROCEDURE BuscarHotelesPorComodidades
    @Provincia VARCHAR(50),
    @Comodidades VARCHAR(255)
AS
BEGIN
    SELECT EH.Nombre AS Hotel, TH.Nombre AS TipoHabitacion, C.Nombre AS Comodidad
    FROM EmpresaHotel EH
    JOIN Habitaciones H ON EH.CedulaJuridica = H.CedulaJuridica
    JOIN TipoHabitacion TH ON H.TipoHabitacionID = TH.TipoHabitacionID
    JOIN TipoHabitacionComodidad THC ON TH.TipoHabitacionID = THC.TipoHabitacionID
    JOIN Comodidades C ON THC.ComodidadID = C.ComodidadID
    WHERE EH.Provincia = @Provincia
      AND C.Nombre IN (SELECT value FROM STRING_SPLIT(@Comodidades, ','))
    ORDER BY TH.Precio;
END;

GO

CREATE PROCEDURE BuscarEmpresasPorUbicacion
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50)
AS
BEGIN
    SELECT EA.Nombre AS NombreEmpresa, EA.Provincia, EA.Canton, EA.Distrito, EA.SeñasExactas
    FROM EmpresaActividad EA
    WHERE EA.Provincia = @Provincia
      AND EA.Canton = @Canton
      AND EA.Distrito = @Distrito
    ORDER BY EA.Nombre;
END;

GO

CREATE PROCEDURE BuscarEmpresasPorTiposActividad
    @Provincia VARCHAR(50),
    @TiposActividad VARCHAR(255)
AS
BEGIN
    SELECT EA.Nombre AS NombreEmpresa, TA.Descripcion AS TipoActividad
    FROM EmpresaActividad EA
    JOIN EmpresaActividadTipo EAT ON EA.CedulaJuridica = EAT.CedulaJuridica
    JOIN TipoActividad TA ON EAT.TipoActividadID = TA.TipoActividadID
    WHERE EA.Provincia = @Provincia
      AND TA.Nombre IN (SELECT value FROM STRING_SPLIT(@TiposActividad, ','))
    ORDER BY EA.Nombre;
END

GO

CREATE PROCEDURE BuscarEmpresasPorPreciosActividad
    @Provincia VARCHAR(50),
    @PrecioMin DECIMAL(10,2),
    @PrecioMax DECIMAL(10,2)
AS
BEGIN
    SELECT EA.Nombre AS NombreEmpresa, EA.Precio
    FROM EmpresaActividad EA
    WHERE EA.Provincia = @Provincia
      AND EA.Precio BETWEEN @PrecioMin AND @PrecioMax
    ORDER BY EA.Precio;
END;

