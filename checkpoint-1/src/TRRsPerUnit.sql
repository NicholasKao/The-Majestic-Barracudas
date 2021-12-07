/*
 Query to get the number of trrs per year per unit
 */
SELECT q1.year::int, q1.unit_id, q1.description as description, sum(trr_count) as trr_count
FROM
(SELECT date_part('year', trr.trr_datetime) as Year, doh.unit_id, dpu.description, COUNT(trr.id) as trr_count
FROM trr_trr trr
LEFT JOIN data_officerhistory doh on trr.officer_id = doh.officer_id
LEFT JOIN data_policeunit dpu ON doh.unit_id = dpu.id
WHERE doh.effective_date < trr.trr_datetime
  AND (doh.end_date IS NULL or doh.end_date > trr.trr_datetime)
  AND date_part('year', trr.trr_datetime) >= 2010 and date_part('year', trr.trr_datetime) <= 2015
  AND dpu.description LIKE '%District 0%'
GROUP BY date_part('year', trr_datetime), doh.unit_id, dpu.description) q1
GROUP BY year, q1.unit_id, q1.description
ORDER BY q1.unit_id, year

