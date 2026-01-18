-- =====================================================
-- 1. GetMaxQuantity
-- =====================================================
DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER //

CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS MaxQuantity FROM Orders;
END //

DELIMITER ;

-- =====================================================
-- 2. AddBooking 
-- =====================================================
DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //

CREATE PROCEDURE AddBooking(
    IN p_BookingID INT,
    IN p_CustomerID INT,
    IN p_BookingDate DATE,
    IN p_TableNumber INT
)
BEGIN
    INSERT INTO Bookings
    (BookingID, CustomerID, BookingDate, TableNumber)
    VALUES
    (p_BookingID, p_CustomerID, p_BookingDate, p_TableNumber);
END //

DELIMITER ;

-- =====================================================
-- 3. UpdateBooking
-- =====================================================
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //

CREATE PROCEDURE UpdateBooking(
    IN p_BookingID INT,
    IN p_NewDate DATE
)
BEGIN
    UPDATE Bookings
    SET BookingDate = p_NewDate
    WHERE BookingID = p_BookingID;
END //

DELIMITER ;

-- =====================================================
-- 4. CancelBooking
-- =====================================================
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN p_BookingID INT
)
BEGIN
    DELETE FROM Bookings WHERE BookingID = p_BookingID;
END //

DELIMITER ;

-- =====================================================
-- 5. ManageBooking
-- =====================================================
DROP PROCEDURE IF EXISTS ManageBooking;
DELIMITER //

CREATE PROCEDURE ManageBooking(
    IN p_BookingDate DATE,
    IN p_TableNumber INT
)
BEGIN
    DECLARE cnt INT;

    SELECT COUNT(*) INTO cnt
    FROM Bookings
    WHERE BookingDate = p_BookingDate
      AND TableNumber = p_TableNumber;

    IF cnt > 0 THEN
        SELECT 'Table already booked' AS Status;
    ELSE
        INSERT INTO Bookings (BookingDate, TableNumber)
        VALUES (p_BookingDate, p_TableNumber);
        SELECT 'Booking added' AS Status;
    END IF;
END //

DELIMITER ;

-- =====================================================
-- 6. AddBookingWithChecks 
-- =====================================================
DROP PROCEDURE IF EXISTS AddBookingWithChecks;
DELIMITER //

CREATE PROCEDURE AddBookingWithChecks(
    IN p_OrderID VARCHAR(50),
    IN p_OrderDate DATETIME,
    IN p_DeliveryDate DATETIME,
    IN p_CustomerID VARCHAR(50),
    IN p_LocationID INT,
    IN p_MenuItemID INT,
    IN p_Quantity INT,
    IN p_Discount DECIMAL(5,2),
    IN p_DeliveryCost DECIMAL(10,2)
)
BEGIN
    DECLARE customer_exists INT DEFAULT 0;
    DECLARE location_exists INT DEFAULT 0;
    DECLARE menuitem_exists INT DEFAULT 0;
    DECLARE order_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO order_exists FROM Orders WHERE OrderID = p_OrderID;
    IF order_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'OrderID already exists';
    END IF;

    SELECT COUNT(*) INTO customer_exists FROM Customers WHERE CustomerID = p_CustomerID;
    IF customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CustomerID does not exist';
    END IF;

    SELECT COUNT(*) INTO location_exists FROM Locations WHERE LocationID = p_LocationID;
    IF location_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LocationID does not exist';
    END IF;

    SELECT COUNT(*) INTO menuitem_exists FROM MenuItems WHERE MenuItemID = p_MenuItemID;
    IF menuitem_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'MenuItemID does not exist';
    END IF;

    IF p_DeliveryDate < p_OrderDate THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DeliveryDate cannot be before OrderDate';
    END IF;

    INSERT INTO Orders
    VALUES (
        p_OrderID, p_OrderDate, p_DeliveryDate, p_CustomerID,
        p_LocationID, p_MenuItemID, p_Quantity, p_Discount, p_DeliveryCost
    );

    SELECT 'Booking added successfully' AS Status, p_OrderID AS OrderID;
END //

DELIMITER ;
