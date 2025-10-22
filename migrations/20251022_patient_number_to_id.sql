-- Migration to change patient_number to patient_id in the patients table
ALTER TABLE exams
    RENAME COLUMN patient_number TO patient_id;
