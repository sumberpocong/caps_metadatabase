-- Create a view for daily sales report
CREATE VIEW DailySalesReport AS
SELECT 
    DATE(o.OrderDate) AS SaleDate,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.Quantity) AS TotalItemsSold,
    SUM(os.TotalSales) AS DailyRevenue,
    AVG(os.TotalSales) AS AverageOrderValue,
    SUM(o.DeliveryCost) AS TotalDeliveryCost,
    SUM(os.NetCost) AS TotalNetCost
FROM Orders o
JOIN OrderSales os ON o.OrderID = os.OrderID
GROUP BY DATE(o.OrderDate);

-- Create a view for customer purchase history
CREATE VIEW CustomerPurchaseHistory AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.Quantity) AS TotalItemsPurchased,
    SUM(os.TotalSales) AS LifetimeValue,
    MAX(o.OrderDate) AS LastOrderDate,
    DATEDIFF(NOW(), MAX(o.OrderDate)) AS DaysSinceLastOrder
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderSales os ON o.OrderID = os.OrderID
GROUP BY c.CustomerID, c.CustomerName;

-- Find popular menu items
SELECT 
    m.CuisineName,
    m.CourseName,
    COUNT(o.OrderID) AS TimesOrdered,
    SUM(o.Quantity) AS TotalQuantity,
    ROUND(AVG(m.BaseCost), 2) AS AvgBaseCost
FROM MenuItems m
JOIN Orders o ON m.MenuItemID = o.MenuItemID
GROUP BY m.CuisineName, m.CourseName
ORDER BY TimesOrdered DESC;

-- Monthly sales trend
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    COUNT(*) AS OrderCount,
    SUM(TotalSales) AS MonthlyRevenue
FROM OrderSales
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year DESC, Month DESC;

-- Top customers by spending
SELECT 
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount,
    SUM(os.TotalSales) AS TotalSpent,
    ROUND(AVG(os.TotalSales), 2) AS AvgOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderSales os ON o.OrderID = os.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;