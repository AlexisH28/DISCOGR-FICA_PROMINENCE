-- EVENTOS --

-- 1. ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
DELIMITER $$
CREATE EVENT ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO ReporteVentas (Mes, TotalVentas)
    SELECT DATE_FORMAT(InvoiceDate, '%Y-%m'), SUM(Total)
    FROM Invoice
    GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m');
END $$
DELIMITER ;
-- 2. ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.
DELIMITER $$
CREATE EVENT ActualizarSaldosCliente
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    UPDATE Customer
    SET Saldo = (SELECT SUM(Total) FROM Invoice WHERE CustomerId = Customer.CustomerId);
END $$
DELIMITER ;

-- 3. AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
DELIMITER $$
CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    INSERT INTO Alerta (Mensaje)
    SELECT CONCAT('El álbum ', Album.Title, ' no ha registrado ventas en el último año.')
    FROM Album
    LEFT JOIN InvoiceLine ON Album.AlbumId = InvoiceLine.AlbumId
    WHERE InvoiceLine.AlbumId IS NULL;
END $$
DELIMITER ;