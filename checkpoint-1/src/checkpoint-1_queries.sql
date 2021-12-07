/* For own interest
Query to get the number of active police units*/
SELECT COUNT(DISTINCT(id)) FROM data_policeunit WHERE active = True;

/* For 1)
Query to get the number of active LEOs per active police unit*/
SELECT dpu.id as police_unit_id,
       COUNT(DISTINCT(doi.id)) as unit_size,
       ROUND(AVG(doi.current_salary),2) as avg_salary,
       ROUND(AVG(units_served_on),2) as avg_prior_units_served_on,
       AVG(DATE_PART('year', NOW()) - DATE_PART('year', doi.appointed_date)) as avg_years_service,
       AVG(DATE_PART('year', NOW()) - doi.birth_year) as avg_approx_age,
    /*COUNT(DISTINCT(doi.race)) as diff_races_in_unit,*/
       ROUND(q3.unit_male_percent,3) as unit_male_percent,
       ROUND(1 - q3.unit_male_percent,3) as unit_female_percent,
       ROUND(q4.unit_asian_pacific_percent,3) as unit_asian_pacific_percent,
       ROUND(q4.unit_black_percent,3) as unit_black_percent,
       ROUND(q4.unit_hispanic_percent,3) unit_hispanic_percent,
       ROUND(q4.unit_native_american_percent,3) as unit_native_american_percent,
       ROUND(q4.unit_white_percent,3) as unit_white_percent,
       q5.UnitEntropy as UnitRaceEntropy

FROM data_policeunit dpu
         LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
         LEFT JOIN (
    SELECT doi.id as officer_id, doh.unit_id as current_unit, q1.units_served_on
    FROM data_officer doi
             LEFT JOIN data_officerhistory doh ON doi.id = doh.officer_id
             LEFT JOIN
         (SELECT doi.id as officer_id, doi.last_unit_id, COUNT(doh.unit_id) as units_served_On
          FROM data_officerhistory doh
                   LEFT JOIN data_officer doi ON doh.officer_id = doi.id
          WHERE doi.active = 'Yes'
          GROUP BY doi.id, doi.last_unit_id) q1 ON doi.id = q1.officer_id
    WHERE doh.end_date IS NULL AND doi.active = 'Yes') q2 ON dpu.id = q2.current_unit
         LEFT JOIN (
    SELECT dpu.id as PoliceUnitId,
           m.unit_males::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_male_percent
    FROM data_policeunit dpu
             LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_males
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.gender = 'M'
        GROUP BY dpu.id
    ) m ON dpu.id = m.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_females
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.gender = 'F'
        GROUP BY dpu.id
    ) f ON dpu.id = f.PoliceUnitId
    WHERE dpu.active = True AND doi.active = 'Yes'
    GROUP BY dpu.id, m.unit_males, f.unit_females
)q3 ON dpu.id = q3.policeunitid
         LEFT JOIN (
    SELECT dpu.id as PoliceUnitId,
           w.unit_whites::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_white_percent,
           na.unit_native_americans::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_native_american_percent,
           b.unit_blacks::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_black_percent,
           ap.unit_asian_pacific::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_asian_pacific_percent,
           h.unit_hispanics::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_hispanic_percent
    FROM data_policeunit dpu
             LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_whites
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'White'
        GROUP BY dpu.id
    ) w ON dpu.id = w.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_native_americans
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Native American/Alaskan Native'
        GROUP BY dpu.id
    ) na ON dpu.id = na.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_blacks
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Black'
        GROUP BY dpu.id
    ) b ON dpu.id = b.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_asian_pacific
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Asian/Pacific'
        GROUP BY dpu.id
    ) ap ON dpu.id = ap.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_hispanics
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Hispanic'
        GROUP BY dpu.id
    ) h ON dpu.id = h.PoliceUnitId
    WHERE dpu.active = True AND doi.active = 'Yes'
    GROUP BY dpu.id, w.unit_whites, na.unit_native_americans, b.unit_blacks, ap.unit_asian_pacific, h.unit_hispanics
) q4 ON dpu.id = q4.policeunitid
LEFT JOIN (
    SELECT e1.PoliceUnitId,
       COALESCE((-1) * e1.unit_white_percent*log(e1.unit_white_percent),0) +
       COALESCE((-1) * e1.unit_native_american_percent*log(e1.unit_native_american_percent),0) +
       COALESCE((-1) * e1.unit_hispanic_percent*log(e1.unit_hispanic_percent),0) +
       COALESCE((-1) * e1.unit_black_percent*log(e1.unit_black_percent),0) +
       COALESCE((-1) * e1.unit_asian_pacific_percent*log(e1.unit_asian_pacific_percent),0) as UnitEntropy
    FROM
(SELECT dpu.id as PoliceUnitId,
           w.unit_whites::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_white_percent,
           na.unit_native_americans::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_native_american_percent,
           b.unit_blacks::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_black_percent,
           ap.unit_asian_pacific::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_asian_pacific_percent,
           h.unit_hispanics::decimal /COUNT(DISTINCT(doi.id))::decimal as unit_hispanic_percent
       FROM data_policeunit dpu
             LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_whites
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'White'
        GROUP BY dpu.id
    ) w ON dpu.id = w.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_native_americans
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Native American/Alaskan Native'
        GROUP BY dpu.id
    ) na ON dpu.id = na.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_blacks
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Black'
        GROUP BY dpu.id
    ) b ON dpu.id = b.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_asian_pacific
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Asian/Pacific'
        GROUP BY dpu.id
    ) ap ON dpu.id = ap.PoliceUnitId
             LEFT JOIN (
        SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as unit_hispanics
        FROM data_policeunit dpu
                 LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
        WHERE dpu.active = True AND doi.active = 'Yes' and doi.race = 'Hispanic'
        GROUP BY dpu.id
    ) h ON dpu.id = h.PoliceUnitId
    WHERE dpu.active = True AND doi.active = 'Yes'
    GROUP BY dpu.id, w.unit_whites, na.unit_native_americans, b.unit_blacks, ap.unit_asian_pacific, h.unit_hispanics) e1
    ) q5 ON dpu.id = q5.PoliceUnitId
WHERE dpu.active = True
  AND doi.active = 'Yes'
GROUP BY dpu.id,
         q3.unit_male_percent,
         q4.unit_asian_pacific_percent,
         q4.unit_black_percent,
         q4.unit_hispanic_percent,
         q4.unit_native_american_percent,
         q4.unit_white_percent,
         q5.UnitEntropy;

/* For 1)
Query to get the average number of LEOs per active police unit*/
SELECT dpu.id as PoliceUnitId, COUNT(DISTINCT(doi.id)) as OfficersInUnit
FROM data_policeunit dpu
LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
WHERE dpu.active = True AND doi.active = 'Yes'
GROUP BY dpu.id;

/* For 2)
Query to get a table with background data about each active police unit*/
SELECT ROUND(COUNT(DISTINCT(doi.id))::decimal/COUNT(DISTINCT(dpu.id))::decimal,2) as LeosPerUnit
FROM data_policeunit dpu
LEFT JOIN data_officer doi ON dpu.id = doi.last_unit_id
WHERE dpu.active = True AND doi.active = 'Yes';


/*Query to get the average number of allegations, disciplines, and trr's per unit*/
SELECT dpu.id as police_unit,
       COUNT(DISTINCT(doi.id)) as officers_in_unit,
       SUM(DISTINCT(doi.allegation_count)) as allegations,
       SUM(DISTINCT(doi.allegation_count))::decimal/COUNT(DISTINCT(doi.id))::decimal as allegations_per_officer,
       SUM(DISTINCT(doi.discipline_count)) as disciplines,
       SUM(DISTINCT(doi.discipline_count))::decimal/COUNT(DISTINCT(doi.id))::decimal as disciplines_per_officer,
       SUM(DISTINCT(doi.trr_count)) as trrs,
       SUM(DISTINCT(doi.trr_count))::decimal/COUNT(DISTINCT(doi.id))::decimal as  trrs_per_officer
FROM data_policeunit dpu
LEFT JOIN data_officer doi on dpu.id = doi.last_unit_id
WHERE dpu.active = True AND doi.active = 'Yes'
GROUP BY dpu.id;

SELECT da.crid as allegation_id,
       COUNT(DISTINCT(doaa.unit_id)) as units_identified,
       COUNT(DISTINCT(doaa.officer_id)) as officers_identified
FROM data_allegation da
LEFT JOIN data_officerassignmentattendance doaa on da.beat_id = doaa.beat_id
WHERE incident_date > doaa.start_timestamp AND da.incident_date < doaa.end_timestamp
AND da.is_officer_complaint = false
AND doaa.present_for_duty = true
GROUP BY da.crid



/* allegations per units - based on unit officers were in at the time of allegation*/
SELECT doh.unit_id as unit, COUNT(DISTINCT(da.crid)) as allegations
FROM data_allegation da LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
LEFT JOIN data_officerhistory doh ON doa.officer_id = doh.officer_id
WHERE da.is_officer_complaint = false
AND doh.effective_date < da.incident_date AND (doh.end_date IS NULL OR doh.end_date > da.incident_date)
GROUP BY doh.unit_id

/* disciplines per units - based on unit officers were in at the time of allegation*/
SELECT doh.unit_id as unit, COUNT(DISTINCT(da.crid)) as disciplines
FROM data_allegation da LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
LEFT JOIN data_officerhistory doh ON doa.officer_id = doh.officer_id
WHERE da.is_officer_complaint = false AND doa.disciplined = true
AND doh.effective_date < da.incident_date AND (doh.end_date IS NULL OR doh.end_date > da.incident_date)
GROUP BY doh.unit_id

SELECT * FROM trr_trr LIMIT 5






/*Query to give the number of different units indicated on allegations, allowing us
  to back into number of co-accused members of the same unit*/
SELECT da.crid as allegation_id,
       da.incident_date as incident_date,
       da.coaccused_count as coaccused_count,
       COUNT(DISTINCT(doh.unit_id)) as units_indicated_on_allegation
FROM data_allegation da
LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
LEFT JOIN data_officerhistory doh ON doa.id = doh.officer_id
WHERE doh.effective_date < da.incident_date
AND (doh.end_date IS NULL OR da.incident_date < doh.end_date)
GROUP BY da.crid, da.incident_date, da.coaccused_count;



SELECT distinct(race) FROM data_officer;
