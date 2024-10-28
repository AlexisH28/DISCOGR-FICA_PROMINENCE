-- TRIGGERS --

-- 1. ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.
DELIMITER $$
CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN
    UPDATE Employee
    SET TotalSales = TotalSales + NEW.Total
    WHERE EmployeeId = NEW.CustomerId
    AND EmployeeType = 'Empleado';
END $$
DELIMITER ;

-- 2. AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
DELIMITER $$
CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaCliente (IdCliente, NombreAnterior, ApellidoAnterior, NombreNuevo, ApellidoNuevo)
    VALUES (OLD.CustomerId, OLD.FirstName, OLD.LastName, NEW.FirstName, NEW.LastName);
END $$
DELIMITER ;

-- 3. RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.
DELIMITER $$
CREATE TRIGGER RegistrarHistorialPrecioCancion
AFTER UPDATE ON Track
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPrecioCancion (IdCancion, PrecioAnterior, PrecioNuevo)
    VALUES (OLD.TrackId, OLD.UnitPrice, NEW.UnitPrice);
END $$
DELIMITER ;

-- 4. NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.
DELIMITER $$
CREATE TRIGGER `notificar_cancelacion_venta` AFTER DELETE ON `Invoice`
FOR EACH ROW
BEGIN
    INSERT INTO `Notificacion` (Tipo, Detalle)
    VALUES ('Cancelación de Venta', CONCAT('La venta con ID ', OLD.InvoiceId, ' ha sido cancelada.'));
END $$
DELIMITER ;

-- 5. RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.
DELIMITER $$
CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE SaldoDeudor DECIMAL(10, 2);
    SELECT SUM(Total) INTO SaldoDeudor FROM Invoice WHERE CustomerId = NEW.CustomerId;
    IF SaldoDeudor < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente tiene saldo deudor.';
    END IF;
END $$
DELIMITER ;


