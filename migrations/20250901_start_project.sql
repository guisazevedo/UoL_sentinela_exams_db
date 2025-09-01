-- -- Create table patient
-- CREATE TABLE IF NOT EXISTS patients (
--     patient_id CHAR(64) PRIMARY KEY, -- UUID
--     patient_number VARCHAR(100),
--     created_at TIMESTAMP NOT NULL
-- );
--
-- -- Create table hospital
-- CREATE TABLE IF NOT EXISTS hospitals (
--     id_hospital CHAR(64) PRIMARY KEY, -- UUID
--     name VARCHAR(255) NOT NULL,
--     created_at TIMESTAMP NOT NULL,
--     updated_at TIMESTAMP NOT NULL
-- );
--
-- -- Create table professional
-- CREATE TABLE IF NOT EXISTS professionals (
--     id_professional CHAR(64) PRIMARY KEY, -- UUID
--     name VARCHAR(255) NOT NULL,
--     id_hospital CHAR(64),
--     FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
--     last_modified TIMESTAMP NOT NULL
-- );

-- prep ENUM for exam's type
CREATE TYPE exam_type AS ENUM ('xray', 'ecg');

-- Create table exam
CREATE TABLE IF NOT EXISTS exams (
    id_exam CHAR(64) PRIMARY KEY, -- UUID
    id_hospital CHAR(64) NOT NULL,
    patient_number VARCHAR(100) NOT NULL,
    exam_date TIMESTAMP NOT NULL,
    type exam_type NOT NULL,
    link_original_data VARCHAR NOT NULL,
--     FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
--     FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create table exam_diagnosis
CREATE TABLE IF NOT EXISTS exam_diagnoses (
    id_exam_diagnosis CHAR(64) PRIMARY KEY, -- UUID
    id_exam CHAR(64),
    id_professional CHAR(64),
    id_hospital CHAR(64),
    link_diagnosis_data VARCHAR,
    FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
--     FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
--     FOREIGN KEY (id_professional) REFERENCES professionals(id_professional),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create table results
CREATE TABLE IF NOT EXISTS exam_results (
    id_exam_result CHAR(64) PRIMARY KEY, -- UUID
    id_exam_diagnosis CHAR(64),
    result_type VARCHAR(255) NOT NULL,
    result_value FLOAT NOT NULL,
    FOREIGN KEY (id_exam_diagnosis) REFERENCES exam_diagnoses(id_exam_diagnosis),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Check results
ALTER TABLE exam_results
    ADD CONSTRAINT result_value_range CHECK (result_value >= 0 AND result_value <= 1);

-- prep ENUM for review
CREATE TYPE review_type AS ENUM (0, .333, .666, 1);

-- Create table medical_reviews
CREATE TABLE IF NOT EXISTS medical_reviews_log (
    id_medical_review CHAR(64) PRIMARY KEY, -- UUID
    id_professional CHAR(64),
    id_exam_result CHAR(64),
    professional_review review_type NOT NULL DEFAULT 0,
--     FOREIGN KEY (id_professional) REFERENCES professionals(id_professional),
    FOREIGN KEY (id_exam_result) REFERENCES exam_results(id_exam_result),
    created_at TIMESTAMP NOT NULL
);

-- prep ENUM for exam's type
CREATE TYPE action_type AS ENUM ('created', 'viewed', 'edited', 'report_done');

-- Create table logs for exam processing
CREATE TABLE IF NOT EXISTS exam_processing_log (
    id_log CHAR(64) PRIMARY KEY,
    id_exam CHAR(64),
    id_professional CHAR(64),
    action action_type NOT NULL,
    FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
--     FOREIGN KEY (id_professional) REFERENCES professionals(id_professional),
    created_at TIMESTAMP NOT NULL
);