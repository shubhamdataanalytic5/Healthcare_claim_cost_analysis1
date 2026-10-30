1) /*which member groups have higher healthcare costs? */

SELECT * FROM members;
SELECT * FROM claims;

SELECT m.age_band , m.payer_type ,
COUNT(c.claim_id) AS total_claims,
SUM(c.paid_amount) AS total_paid,
AVG(c.paid_amount) AS total_average
FROM members m 

JOIN claims c ON 
m.member_id = c.member_id

GROUP BY 
m.age_band , m.payer_type
ORDER BY 
total_paid DESC;

/*Business purpose:

Understand cost distribution across age groups and payer types*/



2) /*6: What is the pharmacy expenditure?*/

SELECT * FROM pharmacy_claims;

SELECT therapeutic_class,

COUNT(rx_claim_id) AS Total_claims,
SUM(plan_paid) AS total_paid,
AVG(plan_paid) AS total_average,
SUM(gross_amount_due) AS member_gross_Due

FROM pharmacy_claims

GROUP BY therapeutic_class
ORDER BY total_paid DESC;

/*Business purpose:

Identify therapeutic classes contributing the most to pharmacy expenditure.*/


3) /* Which members have low medication adherence? */


SELECT * FROM adherence;

SELECT 
therapeutic_class,
COUNT(*) AS medical_records,
AVG(pdc) AS avg_PDC,

SUM(
	CASE WHEN pdc < 0.80 THEN 1
	ELSE 0 END
	) AS LOW_ADHERANCE
FROM adherence
GROUP BY therapeutic_class
ORDER BY avg_PDC ASC;

/*Business purpose:

Identify therapeutic classes where adherence may be a concern.

Important: These records are member-therapeutic-class combinations, not necessarily unique members. Do not label the count as unique low-adherence members without deduplicating appropriately.*/









