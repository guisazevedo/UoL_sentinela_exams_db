-- prep ENUM for exam's type
CREATE TYPE exam_type AS ENUM ('xray', 'ecg');

-- Create table exam: this is the original exam data received from hospitals
CREATE TABLE IF NOT EXISTS exams (
    id_exam UUID PRIMARY KEY,
    id_hospital CHAR(64) NOT NULL,
    patient_number VARCHAR(100) NOT NULL,
    type exam_type NOT NULL,
    link_original_data VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create index exams table
CREATE INDEX idx_exams_id_exam ON exams (id_exam);
CREATE INDEX idx_exams_id_hospital ON exams (id_hospital);
CREATE INDEX idx_exams_id_hospital_type ON exams (id_hospital, type);
CREATE INDEX idx_exams_id_hospital_patient_number ON exams (id_hospital, patient_number);
CREATE INDEX idx_exams_created_at ON exams (created_at);

-- Create table exam_diagnosis: this is the diagnosis made by our machine learning models
CREATE TABLE IF NOT EXISTS exam_diagnoses (
    id_exam_diagnosis UUID PRIMARY KEY,
    id_exam UUID NOT NULL ,
    id_hospital CHAR(64) NOT NULL,
    link_diagnosis_data VARCHAR,
    has_report BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_exam) REFERENCES exams(id_exam),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create index for exam_diagnosis table
CREATE INDEX idx_exam_diagnoses_exam_id ON exam_diagnoses (id_exam);
CREATE INDEX idx_exam_diagnoses_id_hospital ON exam_diagnoses (id_hospital);
CREATE INDEX idx_exam_diagnoses_has_report ON exam_diagnoses (has_report);
CREATE INDEX idx_exam_diagnoses_id_hospital_has_report ON exam_diagnoses (id_hospital, has_report);
CREATE INDEX idx_exam_diagnoses_created_at ON exam_diagnoses (created_at);


-- Create table results: these are the results for each pathology analyzed by our models
CREATE TABLE IF NOT EXISTS exam_results (
    id_exam_result UUID PRIMARY KEY,
    id_exam_diagnosis UUID NOT NULL ,
    result_type VARCHAR(255) NOT NULL,
    result_value FLOAT NOT NULL,
    FOREIGN KEY (id_exam_diagnosis) REFERENCES exam_diagnoses(id_exam_diagnosis),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create index table results
CREATE INDEX idx_exam_results_id_exam_result ON exam_results (id_exam_result);
CREATE INDEX idx_exam_results_id_exam_diagnosis ON exam_results (id_exam_diagnosis);
CREATE INDEX idx_exam_results_result_type ON exam_results (result_type);
CREATE INDEX idx_exam_results_id_exam_diagnosis_result_type ON exam_results (id_exam_diagnosis, result_type);
CREATE INDEX idx_exam_results_created_at ON exam_results (created_at);

-- Check results
ALTER TABLE exam_results
    ADD CONSTRAINT result_value_range CHECK (result_value >= 0 AND result_value <= 1);

-- prep ENUM for review
CREATE TYPE review_type AS ENUM ('0', '.333', '.666', '1');

-- Create table medical_reviews: this is the review made by medical professionals, whether they agree or not with the diagnosis made by our models
CREATE TABLE IF NOT EXISTS medical_reviews_log (
    id_medical_review UUID PRIMARY KEY,
    id_professional UUID NOT NULL,
    id_exam_result UUID NOT NULL,
    professional_review review_type NOT NULL DEFAULT '0',
    FOREIGN KEY (id_exam_result) REFERENCES exam_results(id_exam_result),
    created_at TIMESTAMP NOT NULL
);

-- Create index for medical_reviews table
CREATE INDEX idx_medical_reviews_id_professional ON medical_reviews_log (id_professional);
CREATE INDEX idx_medical_reviews_id_exam_result ON medical_reviews_log (id_exam_result);
CREATE INDEX idx_medical_reviews_professional_review ON medical_reviews_log (professional_review);
CREATE INDEX idx_medical_reviews_id_professional_id_exam_result ON medical_reviews_log (id_professional, id_exam_result);
CREATE INDEX idx_medical_reviews_created_at ON medical_reviews_log (created_at);