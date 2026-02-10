USE Northwinds2024Student

/* Exercise 1 Proposition : 
        This query can be used to see which employee has processed the most/least returns
        in the month of June, or to see what customer has requested the most/least in returns
*/
SELECT OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
WHERE OrderDate >= '20210601'
    AND OrderDate < '20210701';

/* Exercise 2 Proposition : 
        This query can be used to determine which month has the most returns on the last day 
        of the month by seeing which month has the most appearances
*/
SELECT OrderId, OrderDate, CustomerId, EmployeeId
FROM Sales.[Order]
WHERE OrderDate = DATEADD(day, -1, EOMONTH(OrderDate));

/* Exercise 3 Proposition : 
        This query gives us the employees that have 2 or more 'e's in their last name,
        along with their employee IDs
*/
SELECT EmployeeId, EmployeeFirstName, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE '%e%e%';

/* Exercise 4 Proposition : 
        This query is used to provide orders with a total value of over 10,000 sorted from
        greatest to least by computing the quantity of an item by its value and summing all
        the items in the order
*/
SELECT OrderId, SUM(Quantity*unitprice) AS totalvalue
FROM Sales.OrderDetail
GROUP BY orderid
HAVING SUM(Quantity*unitprice) > 10000
ORDER BY totalvalue DESC;

/* Exercise 5 Proposition : 
        This query is used to identify the employees with last names that start with 
        a lower case letter
*/
SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]%';

SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName COLLATE Latin1_General_BIN LIKE N'[a-z]%';

/* Exercise 6 Propositions : 
        The first query returns total quantity of orders each employee handled before May '22
        The second query returns the total number of orders an employee handled if they 
        did not handle any orders every since May '22. 
*/
-- Query 1
SELECT EmployeeId, COUNT(*) AS numorders
FROM Sales.[Order]
WHERE OrderDate < '20220501'
GROUP BY EmployeeId;

-- Query 2
SELECT EmployeeId, COUNT(*) AS numorders
FROM Sales.[Order]
GROUP BY EmployeeId
HAVING MAX(OrderDate) < '20220501';

/* Exercise 7 Proposition : 
        This query returns a sorted list of the 3 Ship Countries with the highest
        average freight for orders in 2021
*/
SELECT TOP (3) ShipToCountry, AVG(freight) AS avgfreight
FROM Sales.[Order]
WHERE orderdate >= '20210101' AND orderdate < '20220101'
GROUP BY ShipToCountry
ORDER BY avgfreight DESC;

/* Exercise 8 Proposition : 
        This query assigns row numbers to orders a customer has made
        based on the order of the order dates
*/
SELECT CustomerId, OrderDate, OrderId,
  ROW_NUMBER() OVER(PARTITION BY CustomerId ORDER BY OrderDate, OrderId) AS rownum
FROM Sales.[Order]
ORDER BY CustomerId, rownum;

/* Exercise 9 Proposition : 
        This query determines employee gender by mapping titles of courtesy
        to gender categories, and unclassified titles get returned as Unknown
*/
SELECT EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeTitleOfCourtesy,
  CASE EmployeeTitleOfCourtesy
    WHEN 'Ms.'  THEN 'Female'
    WHEN 'Mrs.' THEN 'Female'
    WHEN 'Mr.'  THEN 'Male'
    ELSE             'Unknown'
  END AS gender
FROM HumanResources.Employee;

SELECT EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeTitleOfCourtesy,
  CASE 
    WHEN EmployeeTitleOfCourtesy IN('Ms.', 'Mrs.') THEN 'Female'
    WHEN EmployeeTitleOfCourtesy = 'Mr.'           THEN 'Male'
    ELSE                                        'Unknown'
  END AS gender
FROM HumanResources.Employee;

/* Exercise 10 Proposition : 
        This query returns the customer IDs and their respective regions,
        and customers with no data on their region are at the bottom of the
        table with "NULL" as their region
*/
SELECT CustomerId, CustomerRegion
FROM Sales.Customer
ORDER BY
  CASE WHEN CustomerRegion IS NULL THEN 1 ELSE 0 END, CustomerRegion;


/*  FOOTNOTES

    The first article discussing "Aggregate function, Group-by, Order-by Queries":
        https://medium.com/@aineshshrivastava/aggregate-function-group-by-order-by-queries-62bdb6b70e9e

    The second article discussing "Collation in SQL":
        https://medium.com/gitconnected/collation-in-sql-9fc26d5ad81b
*/