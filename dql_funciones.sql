-- FUNCIONES --

-- 1. TotalGastoCliente(ClienteID, Anio): Gasto total de un cliente en un año específico.
DELIMITER //
CREATE FUNCTION TotalGastoCliente(ClienteID INT, Anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE GastoTotal DECIMAL(10,2);
    SELECT SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) INTO GastoTotal
    FROM Invoice
    JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    WHERE Invoice.CustomerId = ClienteID AND YEAR(Invoice.InvoiceDate) = Anio;
    RETURN GastoTotal;
END//
DELIMITER ;

-- 2. PromedioPrecioPorAlbum(AlbumID): Precio promedio de las canciones de un álbum.
DELIMITER //
CREATE FUNCTION PromedioPrecioPorAlbum(AlbumID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE Promedio DECIMAL(10,2);
    SELECT AVG(Track.UnitPrice) INTO Promedio
    FROM Track
    WHERE Track.AlbumId = AlbumID;
    IF Promedio IS NULL THEN
        SET Promedio = 0.00;
    END IF;
    RETURN Promedio;
END//
DELIMITER ;

-- 3. DuracionTotalPorGenero(GeneroID): Duración total de todas las canciones vendidas de un género específico.
DELIMITER //
CREATE FUNCTION DuracionTotalPorGenero(GeneroID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE DuracionTotal INT;
    SELECT SUM(Track.Milliseconds) INTO DuracionTotal
    FROM Track
    JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
    JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    WHERE Track.GenreId = GeneroID;
    RETURN DuracionTotal;
END//
DELIMITER ;

-- 4. DescuentoPorFrecuencia(ClienteID): Descuento a aplicar basado en la frecuencia de compra del cliente.
DELIMITER //
CREATE FUNCTION DescuentoPorFrecuencia(ClienteID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE Frecuencia INT;
    SELECT COUNT(*) INTO Frecuencia
    FROM Invoice
    WHERE Invoice.CustomerId = ClienteID;
    CASE
    WHEN Frecuencia >= 10 THEN RETURN 0.15; -- 15% de descuento
    WHEN Frecuencia >= 5 THEN RETURN 0.10; -- 10% de descuento
    WHEN Frecuencia >= 3 THEN RETURN 0.05; -- 5% de descuento
    ELSE RETURN 0.00; -- Sin descuento
    END CASE;
END//
DELIMITER ;

-- 5. VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
DELIMITER //
CREATE FUNCTION VerificarClienteVIP(ClienteID INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE GastoAnual DECIMAL(10,2);
    SELECT SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) INTO GastoAnual
    FROM Invoice
    JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    WHERE Invoice.CustomerId = ClienteID AND YEAR(Invoice.InvoiceDate) = YEAR(CURRENT_DATE());
    IF GastoAnual > 10 THEN
        RETURN 'VIP';
    ELSE
        RETURN 'No VIP';
    END IF;
END//
DELIMITER ;