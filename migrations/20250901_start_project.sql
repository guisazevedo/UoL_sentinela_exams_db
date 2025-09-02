-- prep ENUM for exam's type
CREATE TYPE exam_type AS ENUM ('xray', 'ecg');

-- Create table exam: this is the original exam data received from hospitals
CREATE TABLE IF NOT EXISTS exams (
    id_exam UUID PRIMARY KEY,
    id_hospital CHAR(64) NOT NULL,
    patient_number VARCHAR(100) NOT NULL,
    exam_date TIMESTAMP NOT NULL,
    type exam_type NOT NULL,
    link_original_data VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create table exam_diagnosis: this is the diagnosis made by our machine learning models
CREATE TABLE IF NOT EXISTS exam_diagnoses (
    id_exam_diagnosis UUID PRIMARY KEY,
    id_exam CHAR(64),
    id_professional CHAR(64),
    id_hospital CHAR(64),
    link_diagnosis_data VARCHAR,
    has_report BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create table results: these are the results for each pathology analyzed by our models
CREATE TABLE IF NOT EXISTS exam_results (
    id_exam_result UUID PRIMARY KEY,
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

-- Create table medical_reviews: this is the review made by medical professionals, whether they agree or not with the diagnosis made by our models
CREATE TABLE IF NOT EXISTS medical_reviews_log (
    id_medical_review UUID PRIMARY KEY,
    id_professional CHAR(64),
    id_exam_result CHAR(64),
    professional_review review_type NOT NULL DEFAULT 0,
    FOREIGN KEY (id_exam_result) REFERENCES exam_results(id_exam_result),
    created_at TIMESTAMP NOT NULL
);

-- -- prep ENUM for exam's type
-- CREATE TYPE action_type AS ENUM ('result_created', 'result_edited', 'report_created');
--
-- -- Create table logs for exam processing
-- CREATE TABLE IF NOT EXISTS exam_processing_log (
--     id_log UUID PRIMARY KEY,
--     id_exam CHAR(64),
--     id_professional CHAR(64),
--     action action_type NOT NULL,
--     FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
--     created_at TIMESTAMP NOT NULL
-- );