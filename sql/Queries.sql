/*What are the top 10 highest-paid claims?*/

SELECT * FROM claims;

SELECT Claim_id,paid_amount
FROM Claims
ORDER BY paid_amount DESC
LIMIT 10

/*Calculate total paid amount by claim type.*/

SELECT claim_type,
COUNT(*) AS total_claims
FROM claims
GROUP BY claim_type
HAVING COUNT(*) > 5000;

/*Create a claim payment category.*/ /*USING CASE*/

SELECT claim_id,paid_amount,
CASE WHEN paid_amount >= 1000 THEN 'High cost'
	 WHEN paid_amount >= 500 THEN 'Mediaum cost'
	 ELSE 'Low cost' END AS payment_category
FROM Claims;

/*INNER JOIN*/

SELECT * FROM claims;
SELECT * FROM members;

SELECT c.claim_id,c.claim_type,c.plan_id,m.age,m.sex,m.state
FROM claims c JOIN members m 
ON c.member_id=m.member_id
WHERE plan_id = 'PLN2798';

/*left join*/

SELECT * FROM claims;
SELECT * FROM providers;

SELECT c.claim_id,c.rendering_npi,c.paid_amount,p.specialty,p.network_status
FROM claims c
LEFT JOIN providers p
ON c.rendering_npi = p.provider_npi;

/*Which members have total medical paid amounts above 5,000?*/ /*CTE's USE*/ 


WITH claim_summary AS(
					SELECT member_id,
					COUNT(*) AS total_claims,
					SUM(paid_amount) AS total_paid
					FROM claims
					GROUP BY member_id
					)
SELECT * 
FROM claim_summary
WHERE total_paid > 5000
ORDER BY total_paid DESC;


/*Calculate total paid amount for each member without collapsing individual claims.*/ /*windows function*/

SELECT claim_id,member_id,paid_amount,
SUM(paid_amount) OVER (PARTITION BY member_id) AS member_paid
FROM claims;


/*Running Total Calculate cumulative paid amount by service date. */

SELECT claim_id,service_date_from,paid_amount,
SUM(paid_amount) OVER(ORDER BY claim_id,service_date_from ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_total
FROM claims;

/*Rank providers by total paid amount.*/ /*using of RANK function to provide a rank based on total paid amount*/

SELECT * FROM providers;

WITH provider_summary AS(
SELECT rendering_npi,
SUM(paid_amount) AS total_paid_amount
FROM claims
GROUP BY rendering_npi )

SELECT *,
RANK () OVER(ORDER BY total_paid_amount DESC ) AS provider_rank
FROM  provider_summary;


/*Find the highest-paid claim for each member.*/ /*Using Row number to Identify which member has highest COST*/

SELECT * FROM Claims;


WITH PR AS(
SELECT claim_id,member_id,paid_amount,
ROW_NUMBER() OVER(PARTITION BY member_id ORDER BY paid_amount DESC) AS rn
FROM claims
)
SELECT *
FROM PR
WHERE rn=1;


/*Compare a claim's paid amount with the previous claim for the same member.*/ /*LAG Funtion*/

SELECT member_id,claim_id,service_date_from,paid_amount,
	LAG(paid_amount) OVER
    (
        PARTITION BY member_id
		ORDER BY service_date_from, claim_id
    ) AS previous_paid_amount
FROM claims;

/*Find the next claim date for a member.*/ /*USING LEAD funtion*/

SELECT member_id,claim_id,service_date_from,
		LEAD(service_date_from) OVER
    	(
        	PARTITION BY member_id
			ORDER BY service_date_from, claim_id
		) AS next_claim_date
FROM claims;


/*Find providers with high paid amounts and high denial rates.*/ /*USING CTE,S CASE*/

SELECT * FROM claims;

WITH PV AS(
SELECT rendering_npi,
COUNT(*) AS total_claims,
SUM(paid_amount) AS total_paid,
SUM(
		CASE WHEN claim_status='Denied' THEN 1 ELSE 0 END
	) AS denied_claim
FROM claims	
GROUP BY rendering_npi
		  )

SELECT rendering_npi,total_claims,total_paid,denied_claim,
(
		100*denied_claim/total_claims
    ) AS deniel_rate
FROM PV
WHERE total_claims >=20
ORDER BY deniel_rate DESC,
total_paid DESC;










     
















