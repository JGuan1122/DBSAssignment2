-- ==========================================
-- 0. CLEAN UP EXISTING TABLES (To prevent "already exists" errors)
-- ==========================================
-- DROP TABLE Sales CASCADE CONSTRAINTS;
-- DROP TABLE ProductInvoice CASCADE CONSTRAINTS;
-- DROP TABLE Product CASCADE CONSTRAINTS;
-- DROP TABLE Supplier CASCADE CONSTRAINTS;
-- DROP TABLE ProdClassification CASCADE CONSTRAINTS;
-- DROP TABLE Equipments CASCADE CONSTRAINTS;
-- DROP TABLE Services CASCADE CONSTRAINTS;
-- DROP TABLE ServiceMethod CASCADE CONSTRAINTS;
-- DROP TABLE Skills CASCADE CONSTRAINTS;
-- DROP TABLE Employees CASCADE CONSTRAINTS;
-- DROP TABLE ServiceInvoice CASCADE CONSTRAINTS;
-- DROP TABLE Team CASCADE CONSTRAINTS;
-- DROP TABLE Customer CASCADE CONSTRAINTS;

-- ==========================================
-- 1. CREATE TABLES (DDL)
-- ==========================================

-- CUSTOMER & INVOICING TABLES
CREATE TABLE Customer (
    CustNo INT PRIMARY KEY,
    CustName VARCHAR2(100),
    Address VARCHAR2(150),
    City VARCHAR2(50),
    PostalCode VARCHAR2(20)
);

CREATE TABLE Team (
    TeamNo INT PRIMARY KEY,
    TeamDesc VARCHAR2(100)
);

CREATE TABLE ServiceInvoice (
    InvoiceNo INT PRIMARY KEY,
    CustNo INT,
    InvoiceDate DATE,
    TeamNo INT,
    Subtotal DECIMAL(10,2),
    GST DECIMAL(10,2),
    PST DECIMAL(10,2),
    TotalDue DECIMAL(10,2),
    FOREIGN KEY (CustNo) REFERENCES Customer(CustNo),
    FOREIGN KEY (TeamNo) REFERENCES Team(TeamNo)
);

-- SERVICES & TEAMS TABLES
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    TeamNo INT,
    Name VARCHAR2(100),
    Position VARCHAR2(50),
    HomePhone VARCHAR2(20),
    StartDate DATE,
    OHIP VARCHAR2(20),
    FOREIGN KEY (TeamNo) REFERENCES Team(TeamNo)
);

CREATE TABLE Skills (
    EmpID INT,
    Skill VARCHAR2(50),
    PRIMARY KEY (EmpID, Skill),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

CREATE TABLE ServiceMethod (
    ServiceCode VARCHAR2(10) PRIMARY KEY,
    ServiceDesc VARCHAR2(100),
    HourlyCharge DECIMAL(10,2)
);

CREATE TABLE Services (
    InvoiceNo INT,
    ServiceCode VARCHAR2(10),
    WorkDuration DECIMAL(5,2),
    TotalCharge DECIMAL(10,2),
    PRIMARY KEY (InvoiceNo, ServiceCode),
    FOREIGN KEY (InvoiceNo) REFERENCES ServiceInvoice(InvoiceNo),
    FOREIGN KEY (ServiceCode) REFERENCES ServiceMethod(ServiceCode)
);

CREATE TABLE Equipments (
    InvoiceNo INT,
    EquipUsed VARCHAR2(100),
    PRIMARY KEY (InvoiceNo, EquipUsed),
    FOREIGN KEY (InvoiceNo) REFERENCES ServiceInvoice(InvoiceNo)
);

-- PRODUCTS & INVENTORY TABLES
CREATE TABLE ProdClassification (
    ProductClass VARCHAR2(10) PRIMARY KEY,
    Classification VARCHAR2(100)
);

CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR2(100)
);

CREATE TABLE Product (
    ProdID INT PRIMARY KEY,
    ProductClass VARCHAR2(10),
    ProductName VARCHAR2(100),
    Cost DECIMAL(10,2),
    Markup VARCHAR2(10), 
    Charge DECIMAL(10,2),
    Inventory INT,
    Aisle INT,
    SupplierID INT,
    FOREIGN KEY (ProductClass) REFERENCES ProdClassification(ProductClass),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE ProductInvoice (
    InvoiceID INT PRIMARY KEY,
    InvoiceDate DATE,
    CustNo INT,
    EmpID INT,
    FOREIGN KEY (CustNo) REFERENCES Customer(CustNo),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

CREATE TABLE Sales (
    InvoiceID INT,
    ProdID INT,
    Qty INT,
    PRIMARY KEY (InvoiceID, ProdID),
    FOREIGN KEY (InvoiceID) REFERENCES ProductInvoice(InvoiceID),
    FOREIGN KEY (ProdID) REFERENCES Product(ProdID)
);

-- ==========================================
-- 2. INSERT SAMPLE DATA (DML)
-- ==========================================

-- Insert Customers
INSERT INTO Customer (CustNo, CustName, Address, City, PostalCode) VALUES (56, 'John Adams', '234 Bloor W', 'Toronto', 'M2S 4S3');
INSERT INTO Customer (CustNo, CustName, Address, City, PostalCode) VALUES (34, 'Ashley Riley', '156 Avindale Cresc', 'Toronto', 'M4T 4R7');
INSERT INTO Customer (CustNo, CustName, Address, City, PostalCode) VALUES (7, 'Walk-in Customer', NULL, NULL, NULL);

-- Insert Teams
INSERT INTO Team (TeamNo, TeamDesc) VALUES (1, 'General Contracting');
INSERT INTO Team (TeamNo, TeamDesc) VALUES (2, 'Pruning and Planting');
INSERT INTO Team (TeamNo, TeamDesc) VALUES (3, 'General Maintenance');

-- Insert Employees
INSERT INTO Employees (EmpID, TeamNo, Name, Position, HomePhone, StartDate, OHIP) VALUES (120, 1, 'Cindy Lee', 'Supervisor', '905-338-1234', TO_DATE('1998-01-01', 'YYYY-MM-DD'), '219032002');
INSERT INTO Employees (EmpID, TeamNo, Name, Position, HomePhone, StartDate, OHIP) VALUES (121, 2, 'Paula Corelli', 'Lawn Care', '416-458-4562', TO_DATE('1998-06-30', 'YYYY-MM-DD'), '325443001');
INSERT INTO Employees (EmpID, TeamNo, Name, Position, HomePhone, StartDate, OHIP) VALUES (144, NULL, 'Paul Smith', 'Sales Assistant', NULL, NULL, NULL);
INSERT INTO Employees (EmpID, TeamNo, Name, Position, HomePhone, StartDate, OHIP) VALUES (145, NULL, 'Maria Wong', 'Sales Assistant', NULL, NULL, NULL);

-- Insert Service Methods
INSERT INTO ServiceMethod (ServiceCode, ServiceDesc, HourlyCharge) VALUES ('LC', 'Lawn Cutting', 25.00);
INSERT INTO ServiceMethod (ServiceCode, ServiceDesc, HourlyCharge) VALUES ('LW', 'Lawn Weeding', 35.00);
INSERT INTO ServiceMethod (ServiceCode, ServiceDesc, HourlyCharge) VALUES ('TG', 'Tree Pruning', 45.00);
INSERT INTO ServiceMethod (ServiceCode, ServiceDesc, HourlyCharge) VALUES ('GP', 'Garden Planting', 30.00);

-- Insert Service Invoices
INSERT INTO ServiceInvoice (InvoiceNo, CustNo, InvoiceDate, TeamNo, Subtotal, GST, PST, TotalDue) VALUES (1355, 56, TO_DATE('2002-07-05', 'YYYY-MM-DD'), 2, 85.25, 5.97, 6.82, 98.04);
INSERT INTO ServiceInvoice (InvoiceNo, CustNo, InvoiceDate, TeamNo, Subtotal, GST, PST, TotalDue) VALUES (1412, 34, TO_DATE('2002-07-19', 'YYYY-MM-DD'), 3, 60.00, 4.20, 4.80, 69.00);

-- Insert Services Rendered
INSERT INTO Services (InvoiceNo, ServiceCode, WorkDuration, TotalCharge) VALUES (1355, 'LC', 0.75, 18.75);
INSERT INTO Services (InvoiceNo, ServiceCode, WorkDuration, TotalCharge) VALUES (1355, 'LW', 1.15, 40.25);
INSERT INTO Services (InvoiceNo, ServiceCode, WorkDuration, TotalCharge) VALUES (1412, 'LC', 0.75, 18.75);
INSERT INTO Services (InvoiceNo, ServiceCode, WorkDuration, TotalCharge) VALUES (1412, 'GP', 0.25, 7.50);

-- Insert Equipment Used
INSERT INTO Equipments (InvoiceNo, EquipUsed) VALUES (1355, '20 hp John Deer tractor/ mower');
INSERT INTO Equipments (InvoiceNo, EquipUsed) VALUES (1355, '10" tree pruning shears');
INSERT INTO Equipments (InvoiceNo, EquipUsed) VALUES (1412, 'Haggmann garden-tiller');

-- Insert Product Classifications & Suppliers
INSERT INTO ProdClassification (ProductClass, Classification) VALUES ('GT', 'Garden Tools');
INSERT INTO ProdClassification (ProductClass, Classification) VALUES ('SB', 'Shrubs');
INSERT INTO ProdClassification (ProductClass, Classification) VALUES ('FT', 'Fertilizers');
INSERT INTO ProdClassification (ProductClass, Classification) VALUES ('SP', 'Sprinklers');

INSERT INTO Supplier (SupplierID, SupplierName) VALUES (1, 'Sheffield-Gander inc.');
INSERT INTO Supplier (SupplierID, SupplierName) VALUES (2, 'Husky Inc.');
INSERT INTO Supplier (SupplierID, SupplierName) VALUES (3, 'Northwood Farms inc.');

-- Insert Products
INSERT INTO Product (ProdID, ProductClass, ProductName, Cost, Markup, Charge, Inventory, Aisle, SupplierID) VALUES (10, 'GT', '6 foot garden rake', 9.23, '30%', 12.00, 5, 1, 1);
INSERT INTO Product (ProdID, ProductClass, ProductName, Cost, Markup, Charge, Inventory, Aisle, SupplierID) VALUES (40, 'GT', 'Flat-nosed Shovel', 6.15, '30%', 8.00, 2, 1, 2);
INSERT INTO Product (ProdID, ProductClass, ProductName, Cost, Markup, Charge, Inventory, Aisle, SupplierID) VALUES (100, 'SB', 'Golden cedar sapling', 23.33, '50%', 35.00, 23, 5, 3);
INSERT INTO Product (ProdID, ProductClass, ProductName, Cost, Markup, Charge, Inventory, Aisle, SupplierID) VALUES (140, 'FT', 'General grade lawn fertilizer', 8.00, '25%', 10.00, 12, 6, NULL);

-- Insert Product Invoices & Sales
INSERT INTO ProductInvoice (InvoiceID, InvoiceDate, CustNo, EmpID) VALUES (1356, TO_DATE('2002-07-05', 'YYYY-MM-DD'), 56, 144);
INSERT INTO ProductInvoice (InvoiceID, InvoiceDate, CustNo, EmpID) VALUES (1367, TO_DATE('2002-07-06', 'YYYY-MM-DD'), 7, 145);

INSERT INTO Sales (InvoiceID, ProdID, Qty) VALUES (1356, 10, 1);
INSERT INTO Sales (InvoiceID, ProdID, Qty) VALUES (1356, 40, 1);
INSERT INTO Sales (InvoiceID, ProdID, Qty) VALUES (1367, 100, 5);
INSERT INTO Sales (InvoiceID, ProdID, Qty) VALUES (1367, 140, 2);

-- ==========================================
-- 3. BUSINESS REPORTS (VIEWS)
-- ==========================================

CREATE OR REPLACE VIEW v_LowInventoryAlert AS
SELECT 
    p.ProdID, 
    p.ProductName, 
    p.Inventory, 
    s.SupplierName
FROM Product p
LEFT JOIN Supplier s ON p.SupplierID = s.SupplierID
WHERE p.Inventory <= 5;


CREATE OR REPLACE VIEW v_ProductSalesPerformance AS
SELECT 
    p.ProdID, 
    p.ProductName, 
    SUM(s.Qty) AS TotalItemsSold, 
    SUM(s.Qty * p.Charge) AS TotalRevenueGenerated
FROM Product p
JOIN Sales s ON p.ProdID = s.ProdID
GROUP BY p.ProdID, p.ProductName;


CREATE OR REPLACE VIEW v_TeamWorkload AS
SELECT 
    t.TeamNo, 
    t.TeamDesc, 
    si.InvoiceNo, 
    si.InvoiceDate, 
    c.CustName
FROM Team t
JOIN ServiceInvoice si ON t.TeamNo = si.TeamNo
JOIN Customer c ON si.CustNo = c.CustNo
ORDER BY si.InvoiceDate DESC;


CREATE OR REPLACE VIEW v_EmployeeSkillsRoster AS
SELECT 
    e.EmpID, 
    e.Name, 
    e.Position, 
    t.TeamDesc, 
    s.Skill
FROM Employees e
JOIN Team t ON e.TeamNo = t.TeamNo
JOIN Skills s ON e.EmpID = s.EmpID
ORDER BY t.TeamNo, e.Name;