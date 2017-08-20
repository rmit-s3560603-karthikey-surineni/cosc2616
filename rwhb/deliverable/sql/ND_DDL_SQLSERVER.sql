-- -----------------------------------------------------
-- Schema ND_DATA_LAKE
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS ND_DATA_LAKE DEFAULT CHARACTER SET utf8 ;
USE [ND_DATA_LAKE] ;

-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_PATIENTS_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_PATIENTS_DIM (
  [patient_code] VARCHAR(45) NOT NULL,
  [timestamp] DATETIME2(0) NULL,
  PRIMARY KEY ([patient_code]))
;


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_PHARMACY_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_PHARMACY_DIM (
  [code] INT NOT NULL,
  [name] VARCHAR(45) NULL,
  [type] VARCHAR(45) NULL,
  [employee_name] VARCHAR(45) NULL,
  [postcode] VARCHAR(45) NULL,
  [suburb_name] VARCHAR(45) NULL,
  [timestamp] VARCHAR(45) NULL,
  PRIMARY KEY ([code]))
;


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_AUS_STATE_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_AUS_STATE_DIM (
  [code] VARCHAR(10) NOT NULL,
  [name] VARCHAR(45) NULL,
  [timestamp] DATETIME2(0) NULL,
  PRIMARY KEY ([code]));


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_SUBURB_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_SUBURB_DIM (
  [postcode] VARCHAR(4) NOT NULL,
  [suburb_name] VARCHAR(45) NULL,
  [lat] DECIMAL(10,2) NULL,
  [lon] DECIMAL(10,2) NULL,
  [state_code] VARCHAR(45) NULL,
  [timestamp] VARCHAR(45) NULL,
  [ND_PHARMACY_DIM_code] INT NOT NULL,
  [ND_STATE_DIM_code] VARCHAR(10) NOT NULL,
  PRIMARY KEY ([postcode], [ND_PHARMACY_DIM_code], [ND_STATE_DIM_code])
 ,
  CONSTRAINT [fk_ND_SUBURB_DIM_ND_PHARMACY_DIM1]
    FOREIGN KEY ([ND_PHARMACY_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_PHARMACY_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_SUBURB_DIM_ND_STATE_DIM1]
    FOREIGN KEY ([ND_STATE_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_AUS_STATE_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_ND_SUBURB_DIM_ND_PHARMACY_DIM1_idx] ON ND_DATA_LAKE.ND_SUBURB_DIM ([ND_PHARMACY_DIM_code] ASC);
CREATE INDEX [fk_ND_SUBURB_DIM_ND_STATE_DIM1_idx] ON ND_DATA_LAKE.ND_SUBURB_DIM ([ND_STATE_DIM_code] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_PRODUCT_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_PRODUCT_DIM (
  [code] INT NOT NULL,
  [name] VARCHAR(45) NULL,
  [SKU] VARCHAR(45) NULL,
  [category_name] VARCHAR(45) NULL,
  [sub_cat_name] VARCHAR(45) NULL,
  [description] VARCHAR(45) NULL,
  [UOM] VARCHAR(45) NULL,
  [brand] VARCHAR(45) NULL,
  [supplier_code] VARCHAR(50) NULL,
  [timestamp] VARCHAR(45) NULL,
  PRIMARY KEY ([code]))
;


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_DOCTOR_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_DOCTOR_DIM (
  [code] VARCHAR(10) NOT NULL,
  [postcode] VARCHAR(45) NULL,
  [state] VARCHAR(45) NULL,
  [timestamp] DATETIME2(0) NULL,
  PRIMARY KEY ([code]));


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_PRESCRIPTION_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_PRESCRIPTION_DIM (
  [code] INT NOT NULL,
  [description] VARCHAR(255) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_PATIENTS_DIM_patient_code] VARCHAR(45) NOT NULL,
  [ND_DOCTOR_DIM_code] VARCHAR(10) NOT NULL,
  PRIMARY KEY ([code], [ND_PATIENTS_DIM_patient_code], [ND_DOCTOR_DIM_code])
 ,
  CONSTRAINT [fk_ND_PRESCRIPTION_DIM_ND_PATIENTS_DIM1]
    FOREIGN KEY ([ND_PATIENTS_DIM_patient_code])
    REFERENCES ND_DATA_LAKE.ND_PATIENTS_DIM ([patient_code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_PRESCRIPTION_DIM_ND_DOCTOR_DIM1]
    FOREIGN KEY ([ND_DOCTOR_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_DOCTOR_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_ND_PRESCRIPTION_DIM_ND_PATIENTS_DIM1_idx] ON ND_DATA_LAKE.ND_PRESCRIPTION_DIM ([ND_PATIENTS_DIM_patient_code] ASC);
CREATE INDEX [fk_ND_PRESCRIPTION_DIM_ND_DOCTOR_DIM1_idx] ON ND_DATA_LAKE.ND_PRESCRIPTION_DIM ([ND_DOCTOR_DIM_code] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_TIME_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_TIME_DIM (
  [key] VARCHAR(50) NOT NULL,
  [day_of_year] INT NULL,
  [quater_no] INT NULL,
  [month_no] INT NULL,
  [month_name] VARCHAR(50) NULL,
  [month_day_no] INT NULL,
  [week_no] INT NULL,
  [day_of_week] VARCHAR(50) NULL,
  [year] VARCHAR(4) NULL,
  [calendar_date] DATETIME2(0) NULL,
  [timestamp] DATETIME2(0) NULL,
  PRIMARY KEY ([key]))
;


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_DISPENSARY_FACT`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_DISPENSARY_FACT (
  [invoice_no] VARCHAR(45) NOT NULL,
  [sales_price] VARCHAR(45) NULL,
  [prescription_code] VARCHAR(45) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_PRESCRIPTION_DIM_code] INT NOT NULL,
  [ND_TIME_DIM_key] VARCHAR(50) NOT NULL,
  [ND_PHARMACY_DIM_code] INT NOT NULL,
  PRIMARY KEY ([ND_PRESCRIPTION_DIM_code], [ND_TIME_DIM_key], [ND_PHARMACY_DIM_code])
 ,
  CONSTRAINT [fk_ND_POS_DIM_ND_PRESCRIPTION_DIM]
    FOREIGN KEY ([ND_PRESCRIPTION_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_PRESCRIPTION_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_POS_FACT_ND_TIME_DIM1]
    FOREIGN KEY ([ND_TIME_DIM_key])
    REFERENCES ND_DATA_LAKE.ND_TIME_DIM ([key])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_POS_FACT_ND_PHARMACY_DIM1]
    FOREIGN KEY ([ND_PHARMACY_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_PHARMACY_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_ND_POS_DIM_ND_PRESCRIPTION_DIM_idx] ON ND_DATA_LAKE.ND_DISPENSARY_FACT ([ND_PRESCRIPTION_DIM_code] ASC);
CREATE INDEX [fk_ND_POS_FACT_ND_TIME_DIM1_idx] ON ND_DATA_LAKE.ND_DISPENSARY_FACT ([ND_TIME_DIM_key] ASC);
CREATE INDEX [fk_ND_POS_FACT_ND_PHARMACY_DIM1_idx] ON ND_DATA_LAKE.ND_DISPENSARY_FACT ([ND_PHARMACY_DIM_code] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_POS_FACT`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_POS_FACT (
  [bill_code] VARCHAR(10) NOT NULL,
  [sales_price] VARCHAR(45) NULL,
  [timpestamp] VARCHAR(45) NULL,
  PRIMARY KEY ([bill_code]))
;


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_CLAIM_FACT`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_CLAIM_FACT (
  [code] VARCHAR(10) NOT NULL,
  [timestamp] VARCHAR(45) NULL,
  PRIMARY KEY ([code]))
;


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_ABS_HEALTH_FACT`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_ABS_HEALTH_FACT (
  [code] VARCHAR(10) NOT NULL,
  [timestamp] DATETIME2(0) NULL,
  PRIMARY KEY ([code]));


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_PRESCRIPTION_LINES`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_PRESCRIPTION_LINES (
  [code] VARCHAR(10) NOT NULL,
  [product_code] VARCHAR(45) NULL,
  [unit] INT NULL,
  [sales_price] VARCHAR(45) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_PRESCRIPTION_DIM_code] INT NOT NULL,
  [ND_PRODUCT_DIM_code] INT NOT NULL,
  PRIMARY KEY ([code], [ND_PRESCRIPTION_DIM_code], [ND_PRODUCT_DIM_code])
 ,
  CONSTRAINT [fk_ND_PRESCRIPTION_LINES_ND_PRESCRIPTION_DIM1]
    FOREIGN KEY ([ND_PRESCRIPTION_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_PRESCRIPTION_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_PRESCRIPTION_LINES_ND_PRODUCT_DIM1]
    FOREIGN KEY ([ND_PRODUCT_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_PRODUCT_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX [fk_ND_PRESCRIPTION_LINES_ND_PRESCRIPTION_DIM1_idx] ON ND_DATA_LAKE.ND_PRESCRIPTION_LINES ([ND_PRESCRIPTION_DIM_code] ASC);
CREATE INDEX [fk_ND_PRESCRIPTION_LINES_ND_PRODUCT_DIM1_idx] ON ND_DATA_LAKE.ND_PRESCRIPTION_LINES ([ND_PRODUCT_DIM_code] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_BOM_WEATHER_STATION_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_BOM_WEATHER_STATION_DIM (
  [code] VARCHAR(10) NOT NULL,
  [name] VARCHAR(45) NULL,
  [region_name] VARCHAR(45) NULL,
  [lat] DECIMAL(10,2) NULL,
  [lon] DECIMAL(10,2) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_SUBURB_DIM_postcode] VARCHAR(4) NOT NULL,
  PRIMARY KEY ([code])
 ,
  CONSTRAINT [fk_ND_WEATHER_STATION_DIM_ND_SUBURB_DIM1]
    FOREIGN KEY ([ND_SUBURB_DIM_postcode])
    REFERENCES ND_DATA_LAKE.ND_SUBURB_DIM ([postcode])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX [fk_ND_WEATHER_STATION_DIM_ND_SUBURB_DIM1_idx] ON ND_DATA_LAKE.ND_BOM_WEATHER_STATION_DIM ([ND_SUBURB_DIM_postcode] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_GCCSA_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_GCCSA_DIM (
  [code] VARCHAR(10) NOT NULL,
  [name] VARCHAR(100) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_AUS_STATE_DIM_code] VARCHAR(10) NOT NULL,
  PRIMARY KEY ([code], [ND_AUS_STATE_DIM_code])
 ,
  CONSTRAINT [fk_ND_GCCSA_DIM_ND_AUS_STATE_DIM1]
    FOREIGN KEY ([ND_AUS_STATE_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_AUS_STATE_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX [fk_ND_GCCSA_DIM_ND_AUS_STATE_DIM1_idx] ON ND_DATA_LAKE.ND_GCCSA_DIM ([ND_AUS_STATE_DIM_code] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_SA4_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_SA4_DIM (
  [code_2016] VARCHAR(10) NOT NULL,
  [code_2011] VARCHAR(45) NULL,
  [name_2016] VARCHAR(100) NULL,
  [name_2011] VARCHAR(100) NULL,
  [area_albers_sqkm] DECIMAL(10,2) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_STATE_DIM_code] VARCHAR(10) NOT NULL,
  [ND_GCCSA_DIM_code] VARCHAR(10) NOT NULL,
  PRIMARY KEY ([code_2016], [ND_STATE_DIM_code])
 ,
  CONSTRAINT [fk_ND_SA4_ND_STATE_DIM1]
    FOREIGN KEY ([ND_STATE_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_AUS_STATE_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_SA4_DIM_ND_GCCSA_DIM1]
    FOREIGN KEY ([ND_GCCSA_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_GCCSA_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX [fk_ND_SA4_ND_STATE_DIM1_idx] ON ND_DATA_LAKE.ND_SA4_DIM ([ND_STATE_DIM_code] ASC);
CREATE INDEX [fk_ND_SA4_DIM_ND_GCCSA_DIM1_idx] ON ND_DATA_LAKE.ND_SA4_DIM ([ND_GCCSA_DIM_code] ASC);


-- -----------------------------------------------------
-- Table `ND_DATA_LAKE`.`ND_SA3_DIM`
-- -----------------------------------------------------
CREATE TABLE ND_DATA_LAKE.ND_SA3_DIM (
  [code_2016] VARCHAR(10) NOT NULL,
  [code_2011] VARCHAR(45) NULL,
  [name_2016] VARCHAR(100) NULL,
  [name_2011] VARCHAR(100) NULL,
  [area_albers_sqkm] DECIMAL(10,2) NULL,
  [timestamp] DATETIME2(0) NULL,
  [ND_STATE_DIM_code] VARCHAR(10) NOT NULL,
  [ND_SA4_DIM_code_2016] VARCHAR(10) NOT NULL,
  [ND_GCCSA_DIM_code] VARCHAR(10) NOT NULL,
  [ND_GCCSA_DIM_ND_AUS_STATE_DIM_code] VARCHAR(10) NOT NULL,
  PRIMARY KEY ([code_2016], [ND_STATE_DIM_code])
 ,
  CONSTRAINT [fk_ND_SA4_ND_STATE_DIM10]
    FOREIGN KEY ([ND_STATE_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_AUS_STATE_DIM ([code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_SA3_ND_SA41]
    FOREIGN KEY ([ND_SA4_DIM_code_2016])
    REFERENCES ND_DATA_LAKE.ND_SA4_DIM ([code_2016])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_ND_SA3_ND_GCCSA_DIM1]
    FOREIGN KEY ([ND_GCCSA_DIM_code] , [ND_GCCSA_DIM_ND_AUS_STATE_DIM_code])
    REFERENCES ND_DATA_LAKE.ND_GCCSA_DIM ([code] , [ND_AUS_STATE_DIM_code])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX [fk_ND_SA4_ND_STATE_DIM1_idx] ON ND_DATA_LAKE.ND_SA3_DIM ([ND_STATE_DIM_code] ASC);
CREATE INDEX [fk_ND_SA3_ND_SA41_idx] ON ND_DATA_LAKE.ND_SA3_DIM ([ND_SA4_DIM_code_2016] ASC);
CREATE INDEX [fk_ND_SA3_ND_GCCSA_DIM1_idx] ON ND_DATA_LAKE.ND_SA3_DIM ([ND_GCCSA_DIM_code] ASC, [ND_GCCSA_DIM_ND_AUS_STATE_DIM_code] ASC);
