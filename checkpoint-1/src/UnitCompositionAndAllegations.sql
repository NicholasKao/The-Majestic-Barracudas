
/*
 Query to get the number of allegations per year per unit
 */
SELECT q1.year::int, q1.unit_id, sum(allegation_count) as allegation_count
FROM
(SELECT date_part('year', incident_date) as Year, doh.unit_id, COUNT(da.crid) as allegation_count
FROM data_allegation da
LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
LEFT JOIN data_officerhistory doh on doa.officer_id = doh.officer_id
AND da.is_officer_complaint = false
WHERE doh.effective_date < incident_date
  AND (doh.end_date IS NULL or doh.end_date > incident_date)
GROUP BY date_part('year', incident_date), doa.officer_id, unit_id) q1
GROUP BY year, q1.unit_id
ORDER BY q1.unit_id, year;

/*
 Query to get the number of officers per unit per year
 Query on accounts for officers that were in the unit the entire year so should be treated as an approximation
 */
SELECT 2010 as year, dpu.id as unit_id, COUNT(doh.officer_id) as officer_count FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
WHERE date_part('year', doh.effective_date) < 2010
  AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
AND active = true
GROUP BY dpu.id
UNION
SELECT 2011 as year, dpu.id as unit_id, COUNT(doh.officer_id) as officer_count FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
WHERE date_part('year', doh.effective_date) < 2011
  AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
AND active = true
GROUP BY dpu.id
UNION
SELECT 2012 as year, dpu.id as unit_id, COUNT(doh.officer_id) as officer_count FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
WHERE date_part('year', doh.effective_date) < 2012
  AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
AND active = true
GROUP BY dpu.id
UNION
SELECT 2013 as year, dpu.id as unit_id, COUNT(doh.officer_id) as officer_count FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
WHERE date_part('year', doh.effective_date) < 2013
  AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
AND active = true
GROUP BY dpu.id
UNION
SELECT 2014 as year, dpu.id as unit_id, COUNT(doh.officer_id) as officer_count FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
WHERE date_part('year', doh.effective_date) < 2014
  AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
AND active = true
GROUP BY dpu.id
UNION
SELECT 2015 as year, dpu.id as unit_id, COUNT(doh.officer_id) as officer_count FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
WHERE date_part('year', doh.effective_date) < 2015
  AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
AND active = true
GROUP BY dpu.id;


/*
 Query to get average service time in CPD and average time in specific unit
 */
SELECT 2010 as year,
       dpu.id as unit_id,
       dpu.description,
       AVG(2010 - date_part('year', d.appointed_date)::int) as serivce_years,
       AVG(2010 - date_part('year', doh.effective_date)::int) as years_in_unit
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2010
AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description, dpu.id
UNION ALL
SELECT 2011 as year,
       dpu.id as unit_id,
       dpu.description,
       AVG(2011 - date_part('year', d.appointed_date)::int) as serivce_years,
       AVG(2011 - date_part('year', doh.effective_date)::int) as years_in_unit
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2011
AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description, dpu.id
UNION ALL
SELECT 2012 as year,
       dpu.id as unit_id,
       dpu.description,
       AVG(2012 - date_part('year', d.appointed_date)::int) as serivce_years,
       AVG(2012 - date_part('year', doh.effective_date)::int) as years_in_unit
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2012
AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description, dpu.id
UNION ALL
SELECT 2013 as year,
       dpu.id as unit_id,
       dpu.description,
       AVG(2013 - date_part('year', d.appointed_date)::int) as serivce_years,
       AVG(2013 - date_part('year', doh.effective_date)::int) as years_in_unit
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2013
AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description, dpu.id
UNION ALL
SELECT 2014 as year,
       dpu.id as unit_id,
       dpu.description,
       AVG(2014 - date_part('year', d.appointed_date)::int) as serivce_years,
       AVG(2014 - date_part('year', doh.effective_date)::int) as years_in_unit
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2014
AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description, dpu.id
UNION ALL
SELECT 2015 as year,
       dpu.id as unit_id,
       dpu.description,
       AVG(2015 - date_part('year', d.appointed_date)::int) as serivce_years,
       AVG(2015 - date_part('year', doh.effective_date)::int) as years_in_unit
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2015
AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description, dpu.id


/*
 Query to get the entropy of genders within each unit (Districts) by year (2010-2015)
 */
SELECT q1.*, m.unit_males, f.unit_females,
       -((m.unit_males::float/q1.officer_count::float))*log(m.unit_males::float/q1.officer_count::float)-
       ((f.unit_females::float/q1.officer_count::float))*log(f.unit_females::float/q1.officer_count::float)
        as unit_gender_entropy
FROM
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2011
AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_males
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2011
AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'M'
GROUP BY year, dpu.id, dpu.description) m ON q1.year = m.year AND q1.unit_id = m.unit_id
LEFT JOIN (
SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_females
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2011
AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'F'
GROUP BY year, dpu.id, dpu.description) f ON m.year = f.year AND m.unit_id = f.unit_id
UNION ALL
SELECT q1.*, m.unit_males, f.unit_females,
       -((m.unit_males::float/q1.officer_count::float))*log(m.unit_males::float/q1.officer_count::float)-
       ((f.unit_females::float/q1.officer_count::float))*log(f.unit_females::float/q1.officer_count::float)
        as unit_gender_entropy
FROM
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2012
AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_males
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2012
AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'M'
GROUP BY year, dpu.id, dpu.description) m ON q1.year = m.year AND q1.unit_id = m.unit_id
LEFT JOIN (
SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_females
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2012
AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'F'
GROUP BY year, dpu.id, dpu.description) f ON m.year = f.year AND m.unit_id = f.unit_id
UNION ALL
SELECT q1.*, m.unit_males, f.unit_females,
       -((m.unit_males::float/q1.officer_count::float))*log(m.unit_males::float/q1.officer_count::float)-
       ((f.unit_females::float/q1.officer_count::float))*log(f.unit_females::float/q1.officer_count::float)
        as unit_gender_entropy
FROM
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2013
AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_males
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2013
AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'M'
GROUP BY year, dpu.id, dpu.description) m ON q1.year = m.year AND q1.unit_id = m.unit_id
LEFT JOIN (
SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_females
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2013
AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'F'
GROUP BY year, dpu.id, dpu.description) f ON m.year = f.year AND m.unit_id = f.unit_id
UNION ALL
SELECT q1.*, m.unit_males, f.unit_females,
       -((m.unit_males::float/q1.officer_count::float))*log(m.unit_males::float/q1.officer_count::float)-
       ((f.unit_females::float/q1.officer_count::float))*log(f.unit_females::float/q1.officer_count::float)
           as unit_gender_entropy
FROM
    (SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
        LEFT JOIN
    (SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_males
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.gender = 'M'
     GROUP BY year, dpu.id, dpu.description) m ON q1.year = m.year AND q1.unit_id = m.unit_id
        LEFT JOIN (
        SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_females
        FROM data_policeunit dpu
                 LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
                 LEFT JOIN data_officer d ON doh.officer_id = d.id
        WHERE date_part('year', doh.effective_date) < 2010
          AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
          AND dpu.description LIKE '%District 0%'
          AND dpu.active = true
          AND d.gender = 'F'
        GROUP BY year, dpu.id, dpu.description) f ON m.year = f.year AND m.unit_id = f.unit_id
UNION ALL
SELECT q1.*, m.unit_males, f.unit_females,
       -((m.unit_males::float/q1.officer_count::float))*log(m.unit_males::float/q1.officer_count::float)-
       ((f.unit_females::float/q1.officer_count::float))*log(f.unit_females::float/q1.officer_count::float)
        as unit_gender_entropy
FROM
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2014
AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_males
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2014
AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'M'
GROUP BY year, dpu.id, dpu.description) m ON q1.year = m.year AND q1.unit_id = m.unit_id
LEFT JOIN (
SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_females
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2014
AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'F'
GROUP BY year, dpu.id, dpu.description) f ON m.year = f.year AND m.unit_id = f.unit_id
UNION ALL
SELECT q1.*, m.unit_males, f.unit_females,
       -((m.unit_males::float/q1.officer_count::float))*log(m.unit_males::float/q1.officer_count::float)-
       ((f.unit_females::float/q1.officer_count::float))*log(f.unit_females::float/q1.officer_count::float)
        as unit_gender_entropy
FROM
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2015
AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_males
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2015
AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'M'
GROUP BY year, dpu.id, dpu.description) m ON q1.year = m.year AND q1.unit_id = m.unit_id
LEFT JOIN (
SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(d.id) as unit_females
FROM data_policeunit dpu
LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
LEFT JOIN data_officer d ON doh.officer_id = d.id
WHERE date_part('year', doh.effective_date) < 2015
AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
AND dpu.description LIKE '%District 0%'
AND dpu.active = true
AND d.gender = 'F'
GROUP BY year, dpu.id, dpu.description) f ON m.year = f.year AND m.unit_id = f.unit_id;



/*
 Query to get the entropy of races within each unit (Districts) by year (2010-2015)
 */
SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)

        as race_entropy
FROM
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'White'
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id
LEFT JOIN
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Black'
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id
LEFT JOIN
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Asian/Pacific'
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id
LEFT JOIN
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Native American/Alaskan Native'
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id
LEFT JOIN
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2010
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Hispanic'
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id

UNION ALL

SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)

        as race_entropy
FROM
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2011
       AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2011
       AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'White'
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id
LEFT JOIN
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2011
       AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Black'
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id
LEFT JOIN
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2011
       AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Asian/Pacific'
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id
LEFT JOIN
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2011
       AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Native American/Alaskan Native'
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id
LEFT JOIN
(SELECT 2011 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2011
       AND (date_part('year', doh.end_date) > 2011 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Hispanic'
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id

UNION ALL

SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)

        as race_entropy
FROM
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2012
       AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2012
       AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'White'
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id
LEFT JOIN
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2012
       AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Black'
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id
LEFT JOIN
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2012
       AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Asian/Pacific'
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id
LEFT JOIN
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2012
       AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Native American/Alaskan Native'
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id
LEFT JOIN
(SELECT 2012 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2012
       AND (date_part('year', doh.end_date) > 2012 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Hispanic'
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id

UNION ALL

SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)

        as race_entropy
FROM
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2013
       AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2013
       AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'White'
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id
LEFT JOIN
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2013
       AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Black'
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id
LEFT JOIN
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2013
       AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Asian/Pacific'
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id
LEFT JOIN
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2013
       AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Native American/Alaskan Native'
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id
LEFT JOIN
(SELECT 2013 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2013
       AND (date_part('year', doh.end_date) > 2013 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Hispanic'
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id

UNION ALL

SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)

        as race_entropy
FROM
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2014
       AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2014
       AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'White'
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id
LEFT JOIN
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2014
       AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Black'
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id
LEFT JOIN
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2014
       AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Asian/Pacific'
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id
LEFT JOIN
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2014
       AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Native American/Alaskan Native'
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id
LEFT JOIN
(SELECT 2014 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2014
       AND (date_part('year', doh.end_date) > 2014 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Hispanic'
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id

UNION ALL

SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)

        as race_entropy
FROM
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2015
       AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
     GROUP BY year, dpu.id, dpu.description) q1
LEFT JOIN
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2015
       AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'White'
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id
LEFT JOIN
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2015
       AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Black'
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id
LEFT JOIN
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2015
       AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Asian/Pacific'
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id
LEFT JOIN
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2015
       AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Native American/Alaskan Native'
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id
LEFT JOIN
(SELECT 2015 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count
     FROM data_policeunit dpu
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id
              LEFT JOIN data_officer d ON doh.officer_id = d.id
     WHERE date_part('year', doh.effective_date) < 2015
       AND (date_part('year', doh.end_date) > 2015 OR doh.end_date IS NULL)
       AND dpu.description LIKE '%District 0%'
       AND dpu.active = true
       AND d.race = 'Hispanic'
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id





SELECT q1.*, w.white_count, b.black_count, ap.asian_pacific_count, na.native_count, h.hispanic_count,\
       COALESCE(-1*(((w.white_count::float/q1.officer_count::float))*log(w.white_count::float/q1.officer_count::float)),0) +\
       COALESCE(-1*(((b.black_count::float/q1.officer_count::float))*log(b.black_count::float/q1.officer_count::float)),0) +\
       COALESCE(-1*(((h.hispanic_count::float/q1.officer_count::float))*log(h.hispanic_count::float/q1.officer_count::float)),0) +\
       COALESCE(-1*\(((ap.asian_pacific_count::float/q1.officer_count::float))*log(ap.asian_pacific_count::float/q1.officer_count::float)),0) +\
       COALESCE(-1*(((na.native_count::float/q1.officer_count::float))*log(na.native_count::float/q1.officer_count::float)),0)\
        as race_entropy\
FROM\
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as officer_count\
     FROM data_policeunit dpu\
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id\
              LEFT JOIN data_officer d ON doh.officer_id = d.id\
     WHERE date_part('year', doh.effective_date) < 2010\
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)\
       AND dpu.description LIKE '%District 0%'\
       AND dpu.active = true\
     GROUP BY year, dpu.id, dpu.description) q1\
LEFT JOIN\
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as white_count\
     FROM data_policeunit dpu\
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id\
              LEFT JOIN data_officer d ON doh.officer_id = d.id\
     WHERE date_part('year', doh.effective_date) < 2010\
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)\
       AND dpu.description LIKE '%District 0%'\
       AND dpu.active = true\
       AND d.race = 'White'\
     GROUP BY year, dpu.id, dpu.description) w ON q1.year = w.year AND q1.unit_id = w.unit_id\
LEFT JOIN\
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as black_count\
     FROM data_policeunit dpu\
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id\
              LEFT JOIN data_officer d ON doh.officer_id = d.id\
     WHERE date_part('year', doh.effective_date) < 2010\
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)\
       AND dpu.description LIKE '%District 0%'\
       AND dpu.active = true\
       AND d.race = 'Black'\
     GROUP BY year, dpu.id, dpu.description) b ON q1.year = b.year AND q1.unit_id = b.unit_id\
LEFT JOIN\
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as asian_pacific_count\
     FROM data_policeunit dpu\
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id\
              LEFT JOIN data_officer d ON doh.officer_id = d.id\
     WHERE date_part('year', doh.effective_date) < 2010\
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)\
       AND dpu.description LIKE '%District 0%'\
       AND dpu.active = true\
       AND d.race = 'Asian/Pacific'\
     GROUP BY year, dpu.id, dpu.description) ap ON q1.year = ap.year AND q1.unit_id = ap.unit_id\
LEFT JOIN\
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as native_count\
     FROM data_policeunit dpu\
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id\
              LEFT JOIN data_officer d ON doh.officer_id = d.id\
     WHERE date_part('year', doh.effective_date) < 2010\
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)\
       AND dpu.description LIKE '%District 0%'\
       AND dpu.active = true\
       AND d.race = 'Native American/Alaskan Native'\
     GROUP BY year, dpu.id, dpu.description) na ON q1.year = na.year AND q1.unit_id = na.unit_id\
LEFT JOIN\
(SELECT 2010 as year, dpu.id as unit_id, dpu.description, COUNT(doh.officer_id) as hispanic_count\
     FROM data_policeunit dpu\
              LEFT JOIN data_officerhistory doh on dpu.id = doh.unit_id\
              LEFT JOIN data_officer d ON doh.officer_id = d.id\
     WHERE date_part('year', doh.effective_date) < 2010\
       AND (date_part('year', doh.end_date) > 2010 OR doh.end_date IS NULL)\
       AND dpu.description LIKE '%District 0%'\
       AND dpu.active = true\
       AND d.race = 'Hispanic'\
     GROUP BY year, dpu.id, dpu.description) h ON q1.year = h.year AND q1.unit_id = h.unit_id