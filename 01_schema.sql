CREATE DATABASE IF NOT EXISTS littlelemon;
USE littlelemon;

-- Customers
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID VARCHAR(50) PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Countries
CREATE TABLE IF NOT EXISTS Countries (
    CountryCode VARCHAR(10) PRIMARY KEY,
    CountryName VARCHAR(100),
    Continent VARCHAR(50)
);

-- Locations
CREATE TABLE IF NOT EXISTS Locations (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    City VARCHAR(100),
    PostalCode VARCHAR(20),
    CountryCode VARCHAR(10),
    FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode),
    UNIQUE(City, PostalCode, CountryCode)
);

-- MenuItems
CREATE TABLE IF NOT EXISTS MenuItems (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    CuisineName VARCHAR(50),
    CourseName VARCHAR(50),
    StarterName VARCHAR(50),
    DesertName VARCHAR(50),
    Drink VARCHAR(50),
    Sides VARCHAR(50),
    BaseCost DECIMAL(10,2)
);

-- Orders
CREATE TABLE IF NOT EXISTS Orders (
    OrderID VARCHAR(50) PRIMARY KEY,
    OrderDate DATETIME,
    DeliveryDate DATETIME,
    CustomerID VARCHAR(50),
    LocationID INT,
    MenuItemID INT,
    Quantity INT,
    AppliedDiscount DECIMAL(5,2),
    DeliveryCost DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);

-- NEW: Bookings table
CREATE TABLE IF NOT EXISTS Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID VARCHAR(50) NOT NULL,
    BookingDate DATE NOT NULL,
    TableNumber INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- INDEXES FOR PERFORMANCE
CREATE INDEX idx_orders_date ON Orders(OrderDate);
CREATE INDEX idx_orders_customer ON Orders(CustomerID);
CREATE INDEX idx_orders_location ON Orders(LocationID);
CREATE INDEX idx_orders_menuitem ON Orders(MenuItemID);
CREATE INDEX idx_customers_name ON Customers(CustomerName);
CREATE INDEX idx_locations_city ON Locations(City);
CREATE INDEX idx_locations_country ON Locations(CountryCode);
CREATE INDEX idx_bookings_date ON Bookings(BookingDate);
CREATE INDEX idx_bookings_customer ON Bookings(CustomerID);
CREATE INDEX idx_bookings_table ON Bookings(TableNumber);

-- ENSURE DATA INTEGRITY
ALTER TABLE Orders 
ADD CONSTRAINT chk_dates CHECK (DeliveryDate >= OrderDate),
ADD CONSTRAINT chk_quantity CHECK (Quantity > 0),
ADD CONSTRAINT chk_discount CHECK (AppliedDiscount BETWEEN 0 AND 100);

-- TEMPORARY TABLE TO LOAD RAW DATA (if needed)
CREATE TABLE IF NOT EXISTS TempRawData AS SELECT * FROM RawLittleLemon WHERE 1=0;
