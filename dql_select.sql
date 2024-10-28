-- CONSULTAS --

-- 1. Empleado que ha generado la mayor cantidad de ventas en el último trimestre.
SELECT e.FirstName, e.LastName, SUM(i.Total) AS TotalVentas
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY e.EmployeeId
ORDER BY TotalVentas DESC
LIMIT 1;

-- 2. Cinco artistas con más canciones vendidas en el último año.
SELECT a.Name, COUNT(t.TrackId) AS TotalCancionesVendidas
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY a.ArtistId
ORDER BY TotalCancionesVendidas DESC
LIMIT 5;

-- 3. Total de ventas y la cantidad de canciones vendidas por país.
SELECT c.Country, SUM(il.UnitPrice * il.Quantity) AS TotalVentas, COUNT(t.TrackId) AS TotalCancionesVendidas
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY c.Country;

-- 4. Número total de clientes que realizaron compras por cada género en un mes específico.
SELECT g.Name AS Genero,COUNT(DISTINCT i.CustomerId) AS TotalClientes
FROM Invoice i
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
INNER JOIN Track t ON il.TrackId = t.TrackId
INNER JOIN Genre g ON t.GenreId = g.GenreId
WHERE MONTH(i.InvoiceDate) = 1 
GROUP BY g.Name;

-- 5. Clientes que han comprado todas las canciones de un mismo álbum.
SELECT c.FirstName, c.LastName, a.Title
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album a ON t.AlbumId = a.AlbumId
GROUP BY c.CustomerId, a.AlbumId
HAVING COUNT(DISTINCT t.TrackId) = (SELECT COUNT(*) FROM Track WHERE AlbumId = a.AlbumId);

-- 6. Tres países con mayores ventas durante el último semestre.
SELECT c.Country, SUM(il.UnitPrice * il.Quantity) AS TotalVentas
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.Country
ORDER BY TotalVentas DESC
LIMIT 3;

-- 7. Cinco géneros menos vendidos en el último año.
SELECT g.Name, COUNT(il.TrackId) AS TotalCancionesVendidas
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY g.GenreId
ORDER BY TotalCancionesVendidas ASC
LIMIT 5;

-- 8. Promedio de edad de los empleados al momento de su primera compra.
SELECT AVG(YEAR(CURDATE()) - YEAR(e.HireDate)) AS 'Edad promedio de los empleados al momento de su primera compra'
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE e.HireDate < i.InvoiceDate;

-- 9. Cinco empleados que realizaron más ventas de Rock.
SELECT e.FirstName, e.LastName, SUM(il.UnitPrice * il.Quantity) AS TotalVentas
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY e.EmployeeId
ORDER BY TotalVentas DESC
LIMIT 5;

-- 10. Informe de los clientes con más compras recurrentes.
SELECT c.FirstName, c.LastName, COUNT(i.InvoiceId) AS TotalCompras
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalCompras DESC
LIMIT 5;

-- 11. Precio promedio de venta por género.
SELECT g.Name, AVG(il.UnitPrice) AS PrecioPromedio
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.GenreId;

-- 12. Cinco canciones más largas vendidas en el último año.
SELECT t.Name, t.Milliseconds
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY t.Milliseconds DESC
LIMIT 5;

-- 13. Clientes que compraron más canciones de Jazz.
SELECT c.FirstName, c.LastName, COUNT(t.TrackId) AS TotalCancionesVendidas
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Jazz'
GROUP BY c.CustomerId
ORDER BY TotalCancionesVendidas DESC;

-- 14. Cantidad total de minutos comprados por cada cliente en el último mes.
SELECT c.FirstName, c.LastName, SUM(t.Milliseconds) / 60000 AS TotalMinutosComprados
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.CustomerId;

-- 15. Número de ventas diarias de canciones en cada mes del último trimestre.
SELECT MONTH(i.InvoiceDate) AS 'Mes', DAY(i.InvoiceDate) AS 'Dia', COUNT(il.InvoiceLineId) AS 'Ventas'
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate BETWEEN '2025-10-3' AND '2025-12-22'
GROUP BY MONTH(i.InvoiceDate), DAY(i.InvoiceDate)
ORDER BY MONTH(i.InvoiceDate), DAY(i.InvoiceDate);

-- 16. Total de ventas por cada vendedor en el último semestre.
SELECT e.FirstName, e.LastName, SUM(i.Total) AS TotalVentas
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY e.EmployeeId;

-- 17. Cliente que ha realizado la compra más cara en el último año.
SELECT c.FirstName, c.LastName, MAX(i.Total) AS TotalCompraMasCara
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.CustomerId
ORDER BY TotalCompraMasCara DESC
LIMIT 1;

-- 18. Cinco álbumes con más canciones vendidas durante los últimos tres meses.
SELECT a.Title, COUNT(t.TrackId) AS TotalCancionesVendidas
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.AlbumId
ORDER BY TotalCancionesVendidas DESC
LIMIT 5;

-- 19. Cantidad de canciones vendidas por cada género en el último mes.
SELECT g.Name, COUNT(il.TrackId) AS TotalCancionesVendidas
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY g.GenreId;

-- 20. Clientes que no han comprado nada en el último año.
SELECT c.CustomerId, c.FirstName, c.LastName, c.Email, i.InvoiceDate
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate > DATE_SUB(NOW(), INTERVAL 1 YEAR) OR i.InvoiceDate IS NULL
ORDER BY c.CustomerId;
