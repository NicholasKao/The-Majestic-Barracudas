SELECT q1.*,
       q2.officer_id as partner_officer_id,
       CASE WHEN q3.allegation_id IS NOT NULL THEN 1 ELSE 0 END AS had_allegation,
       q3.allegation_id as allegation_id,
       CASE WHEN q4.allegation_id IS NOT NULL THEN 1 ELSE 0 END AS partner_had_allegation,
       q4.allegation_id as partner_allegation_id
FROM data_officerassignmentattendance q1
LEFT JOIN data_officerassignmentattendance q2 ON q1.beat_id = q2.beat_id and q1.start_timestamp = q2.start_timestamp and q1.end_timestamp = q2.end_timestamp
LEFT JOIN (
SELECT * FROM data_allegation da
LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
WHERE is_officer_complaint is False
AND officer_id IS NOT NULL
AND incident_date >= '2010-01-01'
AND incident_date < '2016-01-01'
    ) q3 ON q1.officer_id = q3.officer_id AND (date(q1.start_timestamp) = date(q3.incident_date) OR date(q1.end_timestamp) = date(q3.incident_date))
LEFT JOIN (
SELECT * FROM data_allegation da
LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
WHERE is_officer_complaint is False
AND officer_id IS NOT NULL
AND incident_date >= '2010-01-01'
AND incident_date < '2016-01-01'
    ) q4 ON q2.officer_id = q4.officer_id AND (date(q2.start_timestamp) = date(q4.incident_date) OR date(q2.end_timestamp) = date(q4.incident_date))
WHERE q1.officer_id <> q2.officer_id
AND q1.start_timestamp >= '2010-01-01'
AND q1.end_timestamp < '2016-01-01'
AND q1.present_for_duty = True
AND q2.officer_id IS NOT NULL
AND q3.allegation_id IS NULL
AND q4.allegation_id IS NOT NULL