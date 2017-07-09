DROP TABLE IF EXISTS student, module, registration, modinst;

/*
You need to create a table with these columns: matric_no, first_name, last_name, date_of_birth
-- The primary key is matric_no. Matric numbers are exactly 8 characters.
-- Use up to 50 characters for names.
-- There is a specific data type for dates.
*/

CREATE TABLE student (
  matric_no CHAR(8) PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  date_of_birth DATE
);

/*
Add the following students:

-- Daniel Radcliffe, matric 40001010 DoB 1989-07-23
-- Emma Watson, matric 40001011 DoB 1990-04-15
-- Rupert Grint, matric 40001012 DoB 1988-10-24
*/

INSERT INTO student
     VALUES ('40001010', 'Daniel', 'Radcliffe', '1989-07-23'),
            ('40001011', 'Emma', 'Watson', '1990-04-15'),
            ('40001012', 'Rupert', 'Grint', '1988-10-24');

/*
A module has the following columns

-- module_code (primary key, 8 characters)
-- module_title (up to 50 characters)
-- level (integer)
-- credits (integer default value is 20)
*/

CREATE TABLE module (
  module_code CHAR(8) PRIMARY KEY,
  module_title VARCHAR(50),
  level INTEGER,
  credits INTEGER DEFAULT 20
);

/*
Add the following modules, they are all 20 credits - the first two digits let you know the level:

-- HUF07101, Herbology
-- SLY07102, Defense Against the Dark Arts
-- HUF08102, History of Magic
*/

INSERT INTO module (module_code, module_title, level)
     VALUES ('HUF07101', 'Herbology', 7),
            ('SLY07102', 'Defense Against the Dark Arts', 7),
            ('HUF08102', 'History of Magic', 8);

/*
The registration table has three columns matric_no, module_code, result
- the matric_no and module_code types should match the tables you have just created.
Result should be a number with one decimal place.

Make sure you include a composite primary key and two foreign keys.
*/

CREATE TABLE registration (
  matric_no CHAR(8) NOT NULL,
  module_code CHAR(8) NOT NULL,
  result DECIMAL(8, 1),
  PRIMARY KEY (matric_no, module_code),
  FOREIGN KEY (matric_no) REFERENCES student (matric_no),
  FOREIGN KEY (module_code) REFERENCES module (module_code)
);

/*
Daniel got 90 in Defence Against the Dark Arts, 40 in Herbology and does not yet have a mark for History of Magic
Emma got 99 in Defence Against the Dark Arts, did not take Herbology and has no mark for History of Magic
Ron got 20 in Defence Against the Dark Arts, 20 in Herbology and is not registered for History of Magic
*/

INSERT INTO registration
     VALUES ('40001010','SLY07102',90), ('40001010','HUF07101',40), ('40001010','HUF08102',null);

INSERT INTO registration
     VALUES ('40001011','SLY07102',99), ('40001011','HUF08102',null);

INSERT INTO registration
     VALUES ('40001012','SLY07102',20), ('40001012','HUF07101',20);

/*
Produce the results for SLY07102. For each student show the surname, firstname, result and 'F' 'P' or 'M'

-- F for a mark of 39 or less
-- P for a mark between 40 and 69
-- M for a mark of 70 or more
*/

SELECT last_name, first_name, result,
      CASE
        WHEN result <= 39 THEN 'F'
        WHEN result BETWEEN 40 AND 69 THEN 'P'
        ELSE 'M'
      END AS grade
  FROM module JOIN registration ON module.module_code = registration.module_code
              JOIN student      ON registration.matric_no = student.matric_no
 WHERE module.module_code = 'SLY07102';

/*
Modules are run in sessions that are labelled with the academic year (for example 2016/7) and the trimester (for example TR1).
The table modinst records which module is running.
Create the table modinst - be sure to include the foreign key to the module table.
The primary key should be all three columns.
*/

CREATE TABLE modinst (
  module_code CHAR(8) NOT NULL,
  ayr CHAR(6),
  tri CHAR(3),
  FOREIGN KEY (module_code) REFERENCES module (module_code),
  PRIMARY KEY (module_code, ayr, tri)
);

INSERT INTO modinst
     VALUES ('HUF08102','2015/6','TR1'),
            ('SLY07102','2015/6','TR2'),
            ('HUF07101','2015/6','TR2'),
            ('HUF08102','2016/7','TR1'),
            ('SLY07102','2016/7','TR2'),
            ('HUF07101','2016/7','TR2');

/*
The results table should include the session in which the mark was gained.

All of the marks in the original table were gained in session 2015/6 TR2.
The History of Magic registration is for 2016/7 TR1.

-- Add two columns to the registration table for ayr and tri.
-- Set values for these columns as mentioned
-- Add a new foreign key from results to modinst
*/

ALTER TABLE registration ADD COLUMN ayr CHAR(6);
ALTER TABLE registration ADD COLUMN tri CHAR(3);

UPDATE registration
   SET ayr = '2015/6', tri = 'TR2'
 WHERE module_code IN ('SLY07102', 'HUF07101');

UPDATE registration
   SET ayr = '2016/7', tri = 'TR1'
 WHERE module_code = 'HUF08102';

ALTER TABLE registration
 ADD FOREIGN KEY (module_code, ayr, tri) REFERENCES modinst (module_code, ayr, tri);
