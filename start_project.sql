-- Create table patient
CREATE TABLE IF NOT EXISTS patients (
    patient_number SERIAL,
    id_patient CHAR(64) PRIMARY KEY,
    last_modified TIMESTAMP NOT NULL
);

-- Create table hospital
CREATE TABLE IF NOT EXISTS hospitals (
    hospital_number SERIAL,
    id_hospital CHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    last_modified TIMESTAMP NOT NULL
);

-- Create table professional
CREATE TABLE IF NOT EXISTS professionals (
    professional_number SERIAL,
    id_professional CHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    id_hospital CHAR(64),
    FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
    last_modified TIMESTAMP NOT NULL
);

-- prep ENUM for exam's type
CREATE TYPE exam_type AS ENUM ('xray', 'ecg');

-- Create table exam
CREATE TABLE IF NOT EXISTS exams (
    exam_number SERIAL,
    id_exam CHAR(64) PRIMARY KEY,
    id_hospital CHAR(64),
    id_patient CHAR(64),
    exam_date TIMESTAMP NOT NULL,
    type exam_type NOT NULL,
    link_original_data VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
    FOREIGN KEY (id_patient) REFERENCES patients(id_patient),
    last_modified TIMESTAMP NOT NULL
);

-- Create table exam_diagnosis
CREATE TABLE IF NOT EXISTS exam_diagnoses (
    exam_diagnosis_number SERIAL,
    id_exam_diagnosis CHAR(64) PRIMARY KEY,
    id_exam CHAR(64),
    id_professional CHAR(64),
    id_hospital CHAR(64),
    exam_diagnosis_date TIMESTAMP NOT NULL,
    link_diagnosis_data VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
    FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
    FOREIGN KEY (id_professional) REFERENCES professionals(id_professional),
    last_modified TIMESTAMP NOT NULL
);

-- Create table results
CREATE TABLE IF NOT EXISTS results (
    id_result CHAR(64) PRIMARY KEY,
    id_exam_diagnosis CHAR(64),
    result_type VARCHAR(255) NOT NULL,
    result_value FLOAT NOT NULL,
    result_date TIMESTAMP NOT NULL,
    link_result_data VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_exam_diagnosis) REFERENCES exam_diagnoses(id_exam_diagnosis),
    last_modified TIMESTAMP NOT NULL
);

-- prep ENUM for review
CREATE TYPE review_type AS ENUM (0, .33, .66, 1);

-- Create table medical_reviews
CREATE TABLE IF NOT EXISTS medical_reviews (
    id_medical_review CHAR(64) PRIMARY KEY,
    id_exam_diagnosis CHAR(64),
    id_professional CHAR(64),
    id_result CHAR(64),
    review review_type NOT NULL DEFAULT 0,
    review_date TIMESTAMP NOT NULL,
    FOREIGN KEY (id_exam_diagnosis) REFERENCES exam_diagnoses(id_exam_diagnosis),
    FOREIGN KEY (id_professional) REFERENCES professionals(id_professional),
    FOREIGN KEY (id_result) REFERENCES results(id_result),
    last_modified TIMESTAMP NOT NULL
);

-- Check results
ALTER TABLE results
ADD CONSTRAINT result_value_range CHECK (result_value >= 0 AND result_value <= 1);


-- prep ENUM for exam's type
CREATE TYPE action_type AS ENUM ('viewed', 'edited', 'report_done');

-- Create table logs for exam processing
CREATE TABLE IF NOT EXISTS exam_processing_logs (
    log_number SERIAL,
    id_log CHAR(64) PRIMARY KEY,
    id_exam CHAR(64),
    id_professional CHAR(64),
    action action_type NOT NULL,
    FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
    FOREIGN KEY (id_professional) REFERENCES professionals(id_professional),
    last_modified TIMESTAMP NOT NULL
);


-- QUESTIONS:
-- keep all FK?