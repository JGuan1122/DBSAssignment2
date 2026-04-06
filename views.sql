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

-- Test Report 1: Low Inventory Alert
-- EXPECTED: You should only see products with an inventory of 5 or less.
-- Purpose: This report identifies products that currently have an inventory count of 5 or fewer items, 
-- displaying their ID, name, current stock level, and associated supplier.
-- Business Benefit: The Purchasing Manager will benefit from this report by being proactively alerted to stock shortages. 
-- This allows the business to efficiently reorder items before they completely sell out, preventing lost sales and ensuring customers always find what they need in the showroom.
SELECT * FROM v_LowInventoryAlert;

-- Test Report 2: Product Sales Performance
-- EXPECTED: You should see every product listed alongside the total quantity sold and total revenue.
-- Purpose: This report calculates the total quantity sold and the total revenue generated for every individual product in the database.
-- Business Benefit: This report benefits the business by showing exactly which products are the most popular and bring in the highest revenue. 
-- Management can use this data to make informed decisions to adjust pricing, expand popular product lines, 
-- or discontinue underperforming inventory that is taking up valuable warehouse space.
SELECT * FROM v_ProductSalesPerformance;

-- Test Report 3: Team Schedule and Workload
-- EXPECTED: You should see a list of teams matched with the invoices they worked on and the customer's name.
-- Purpose: This report links each operational team to the specific service invoices they have been assigned to, including the customer's name and the date of service.
-- Business Benefit: The Operations Manager can use this report to evaluate team workload and track which teams serviced which clients. 
-- This ensures that no single team is being consistently over-scheduled or under-utilized, allowing for better daily routing and labor management.
SELECT * FROM v_TeamWorkload;

-- Test Report 4: Employee Skills Roster
-- EXPECTED: You should see a list of all employees, what team they are on, and their specific skills.
-- Purpose: This report lists all employees alongside their designated specialized skills and current team assignments. 
-- Business Benefit: When specialized work (such as "A" License Electrical or heavy plumbing) is required by a customer, 
-- the Operations Manager can quickly query this view to find an employee with the exact required skill set. 
-- This allows the business to dispatch the appropriate team accurately, ensuring high-quality, legally compliant, and safe service delivery.
SELECT * FROM v_EmployeeSkillsRoster;