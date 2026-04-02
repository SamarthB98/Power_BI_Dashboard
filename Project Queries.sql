create database bank_ana;
use  bank_ana;
show tables ;

##First Query##
###Loan Default Trend by Age Group~~~
select * from client_info;

SELECT Age,
       COUNT(*) AS total_loans,
       SUM(CASE WHEN `Total Rec Late fee` > 0 THEN 1 ELSE 0 END) AS late_repayments,
       ROUND(100.0 * SUM(CASE WHEN `Total Rec Late fee` > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_repay_percent
FROM client_info
GROUP BY Age
ORDER BY late_repay_percent DESC;

##Second_Query##

###Total_Payment_vs_Principal_Recovered###

SELECT `Bank Name`,
       ROUND(SUM(`Total Pymnt`), 2) AS total_payment,
       ROUND(SUM(`Total Rec Prncp`), 2) AS total_principal,
       ROUND(100.0 * SUM(`Total Rec Prncp`) / SUM(`Total Pymnt`), 2) AS prncp_to_payment_percent
FROM client_info
GROUP BY `Bank Name`
ORDER BY prncp_to_payment_percent DESC;


##Third_Query##
###Region_Wise_Recovery_Efficiency###

SELECT City,
       ROUND(SUM(Recoveries), 2) AS total_recoveries,
       ROUND(SUM(`Total Rec Prncp`), 2) AS total_principal,
       ROUND(100.0 * SUM(Recoveries) / SUM(`Total Rec Prncp`), 2) AS recovery_efficiency_percent
FROM client_info
GROUP BY City
ORDER BY recovery_efficiency_percent DESC;

##Fourth_Query##
###Union_of_Clients_with_High_Payments###

SELECT `Client id`, `Client Name`, `Total Pymnt`, 'High Payment' AS category
FROM client_info
WHERE `Total Pymnt` > 10000

UNION

SELECT `Client id`, `Client Name`, `Recoveries`, 'High Recovery Fee' AS category
FROM client_info
WHERE `Recoveries` > 100;

##Fifth_Query##
##Top_Performing_Branches_by_Recovery_Rate##

SELECT `Branch Name`,
       round(SUM(Recoveries),2) AS total_recoveries,
       COUNT(*) AS loan_count
FROM client_info
GROUP BY `Branch Name`
HAVING Round(SUM(Recoveries),2) > (
    SELECT AVG(Recoveries) FROM client_info
)
ORDER BY total_recoveries DESC;

##Sixth_query##
##Insert_a_New_Loan_Record##

INSERT INTO client_info (`Account ID`,`Client id`, `Client Name`, Age, `Bank Name`, `Int Rate`, `Total Rec Prncp`, `Total Pymnt`)
VALUES (98697428,9999, 'Test Client', '26-35', 'XYZ Bank', 0.14, 5000, 6000);

SELECT *
FROM client_info
WHERE `Client id` = 9999;

##Seventh_Query##
###Average Interest Rate by Age Group###

SELECT Age,
       ROUND(AVG(`Int Rate`) * 100, 2) AS avg_interest_rate_percent
FROM client_info
GROUP BY Age
ORDER BY avg_interest_rate_percent DESC;

##Eighth_query##
###High_Risk_Grade_Flagging###

SELECT `Client id`, `Client Name`, Grrade,
       CASE 
           WHEN Grrade IN ('D', 'E', 'F', 'G') THEN 'High Risk'
           ELSE 'Low/Medium Risk'
       END AS risk_category
FROM client_info;


##Ninth_Query##
##Count_of_Loans_per_Purpose_Category##
SELECT `Purpose Category`, 
       COUNT(*) AS total_loans
FROM client_info
GROUP BY `Purpose Category`
ORDER BY total_loans DESC;




