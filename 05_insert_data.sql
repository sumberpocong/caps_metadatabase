-- Start with safety settings
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Step 1: Clear existing data using DELETE (or TRUNCATE)
DELETE FROM Orders;
DELETE FROM MenuItems;
DELETE FROM Locations;
DELETE FROM Countries;
DELETE FROM Customers;

-- Step 2: Reset auto-increment counters
ALTER TABLE MenuItems AUTO_INCREMENT = 1;
ALTER TABLE Locations AUTO_INCREMENT = 1;

-- Step 3: Insert into Countries table
INSERT INTO Countries (CountryCode, CountryName, Continent)
SELECT DISTINCT 
    CountryCode,
    Country,
    CASE 
        WHEN Country IN ('United States', 'USA', 'US', 'Canada', 'Mexico') THEN 'North America'
        WHEN Country IN ('United Kingdom', 'UK', 'England', 'Scotland', 'Wales', 'France', 'Germany', 'Italy', 'Spain', 'Portugal', 'Netherlands') THEN 'Europe'
        WHEN Country IN ('China', 'Japan', 'India', 'South Korea', 'Thailand', 'Vietnam') THEN 'Asia'
        WHEN Country IN ('Australia', 'New Zealand') THEN 'Oceania'
        WHEN Country IN ('Brazil', 'Argentina', 'Chile') THEN 'South America'
        WHEN Country IN ('South Africa', 'Egypt', 'Nigeria') THEN 'Africa'
        ELSE 'Unknown'
    END AS Continent
FROM RawLittleLemon
WHERE CountryCode IS NOT NULL AND Country IS NOT NULL;

-- Step 4: Insert into Customers table
INSERT INTO Customers (CustomerID, CustomerName)
SELECT DISTINCT CustomerID, CustomerName
FROM RawLittleLemon
WHERE CustomerID IS NOT NULL AND CustomerName IS NOT NULL;

-- Step 5: Insert into Locations table
INSERT INTO Locations (City, PostalCode, CountryCode)
SELECT DISTINCT 
    r.City,
    r.PostalCode,
    r.CountryCode
FROM RawLittleLemon r
WHERE r.City IS NOT NULL AND r.PostalCode IS NOT NULL AND r.CountryCode IS NOT NULL;

-- Step 6: Insert into MenuItems table
INSERT INTO MenuItems (CuisineName, CourseName, StarterName, DesertName, Drink, Sides, BaseCost)
SELECT DISTINCT 
    CuisineName,
    CourseName,
    StarterName,
    DesertName,
    Drink,
    Sides,
    Cost
FROM RawLittleLemon
WHERE CuisineName IS NOT NULL AND CourseName IS NOT NULL AND Cost IS NOT NULL;

-- Step 7: Insert into Orders table
INSERT INTO Orders (OrderID, OrderDate, DeliveryDate, CustomerID, LocationID, MenuItemID, Quantity, AppliedDiscount, DeliveryCost)
SELECT 
    r.OrderID,
    r.OrderDate,
    r.DeliveryDate,
    r.CustomerID,
    l.LocationID,
    m.MenuItemID,
    COALESCE(r.Quantity, 1) AS Quantity,
    COALESCE(r.Discount, 0) AS AppliedDiscount,
    COALESCE(r.DeliveryCost, 0) AS DeliveryCost
FROM RawLittleLemon r
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
INNER JOIN Locations l ON r.City = l.City 
    AND r.PostalCode = l.PostalCode 
    AND r.CountryCode = l.CountryCode
INNER JOIN MenuItems m ON r.CuisineName = m.CuisineName 
    AND r.CourseName = m.CourseName 
    AND r.StarterName = m.StarterName 
    AND r.DesertName = m.DesertName 
    AND r.Drink = m.Drink 
    AND r.Sides = m.Sides 
    AND ABS(r.Cost - m.BaseCost) < 0.01;

-- Restore safety settings
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

-- Verification
SELECT 'Data insertion completed!' AS Status;