-- 1. BASIC COUNTS COMPARISON
SELECT 
    'RawLittleLemon' AS SourceTable,
    COUNT(DISTINCT OrderID) AS OrderCount,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    COUNT(DISTINCT CONCAT(City, PostalCode, CountryCode)) AS LocationCount,
    COUNT(DISTINCT CuisineName) AS UniqueCuisines,
    COUNT(DISTINCT CountryCode) AS CountryCount
FROM RawLittleLemon

UNION ALL

SELECT 
    'Normalized Tables' AS SourceTable,
    (SELECT COUNT(*) FROM Orders) AS OrderCount,
    (SELECT COUNT(*) FROM Customers) AS CustomerCount,
    (SELECT COUNT(*) FROM Locations) AS LocationCount,
    (SELECT COUNT(DISTINCT CuisineName) FROM MenuItems) AS UniqueCuisines,
    (SELECT COUNT(*) FROM Countries) AS CountryCount;