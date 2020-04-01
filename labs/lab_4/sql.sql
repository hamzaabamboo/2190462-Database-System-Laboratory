use LAB7;

CREATE TABLE IF NOT EXISTS `faculty_insurance` (
`ref_id` char(16) NOT NULL primary key,
`ins_plan` varchar(50) NOT NULL,
`credit_limit` decimal(10,2) DEFAULT NULL,
`duedate` date DEFAULT NULL,
`s_timestamp` datetime DEFAULT NULL,
`status` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET= utf8mb4;

INSERT INTO faculty_insurance (ref_id, ins_plan, credit_limit, duedate, s_timestamp,status)
SELECT pid,'initial value by system',40000,DATE_ADD(SYSDATE(), INTERVAL 4
YEAR),SYSDATE(),'A' from Professor;

INSERT into faculty_insurance (ref_id,ins_plan, credit_limit,duedate,s_timestamp,status)
SELECT student_id,'initial value by system',20000,DATE_ADD(SYSDATE(), INTERVAL 4
YEAR),SYSDATE(),'A' from Student;

CREATE TRIGGER new_student_added
AFTER INSERT ON Student
FOR EACH ROW
insert into faculty_insurance (ref_id,ins_plan, credit_limit,duedate,s_timestamp,status)
values (new.student_id,"Group Insurance for Student",100000,DATE_ADD(SYSDATE(),
INTERVAL 4
YEAR),SYSDATE(),'A');

insert into Student (student_id,name,year,email)
values ('5971452321','Somechai Rakchad', '1','Somechai@yahoo.com');

DELIMITER $$
CREATE FUNCTION CONCATSTUDENT(student_ID varchar(15), lname varchar(30))
RETURNS
varchar(50)
DETERMINISTIC
BEGIN
DECLARE fullname varchar(50);
SET fullname = CONCAT(CONCAT(student_ID,' '),lname);
RETURN fullname;
END$$
DELIMITER ;

SELECT CONCATSTUDENT('5971463821','Honda Fukumika') as
CONCAT_ID_NAME_RESULT;

SELECT CONCATSTUDENT(student_id,name) as CONCAT_ID_NAME_RESULT
,email From Student;

alter table Student add column student_status char(1);

CREATE TABLE IF NOT EXISTS system_log (
`id` int UNSIGNED AUTO_INCREMENT PRIMARY KEY,
`user_log` varchar(50) default NULL,
`remark` varchar(100) default NULL,
`timestamp` datetime default NULL);

DROP PROCEDURE IF EXISTS Proc_flag_student;
DELIMITER $$
CREATE PROCEDURE Proc_flag_student()
DETERMINISTIC
BEGIN
if(select student_id from Takes where grade='F')>0 THEN
CREATE TEMPORARY TABLE IF NOT EXISTS TMP_STUDENT(SID varchar(16));
Truncate table TMP_STUDENT;
insert into TMP_STUDENT (SID) select DISTINCT student_id from Takes where grade='F';
update faculty_insurance set status='N' where ref_id in (select SID from TMP_STUDENT);
update Student set student_status='P' where student_id in (select SID from TMP_STUDENT);
INSERT INTO system_log (user_log, remark,timestamp)
select SID, 'get F', SYSDATE() from TMP_STUDENT;
select * from Student where student_id in (select SID from TMP_STUDENT);
ELSE
select ' F grade is empty';
END IF;
END$$
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
update Takes set grade='F' where student_id=55748896 and cid=201002;

Call Proc_flag_student();

CREATE TRIGGER new_professor_added
AFTER INSERT ON Professor
FOR EACH ROW
insert into faculty_insurance (ref_id,ins_plan, credit_limit,duedate,s_timestamp,status)
values (new.pid,"Group Insurance for Instructor",3 * new.salary,DATE_ADD(SYSDATE(),
INTERVAL 4
YEAR),SYSDATE(),'A');

INSERT INTO Professor (pid, pname, salary) VALUES ('1238212', 'Elon Musk', 800);

SELECT * FROM faculty_insurance;

DROP FUNCTION fn_currency;
DELIMITER $$
CREATE FUNCTION fn_currency(input_number DECIMAL(65), exchange_rate DECIMAL(65), currency_name VARCHAR(20))
RETURNS
VARCHAR(99)
DETERMINISTIC
BEGIN
DECLARE res varchar(50);
SET res = CONCAT(input_number / exchange_rate,' ',currency_name);
RETURN res;
END$$
DELIMITER ;

SELECT *, fn_currency(salary,35,"USD") from Professor;

DROP PROCEDURE IF EXISTS Proc_cal_professor_upvel;

DELIMITER $$
CREATE PROCEDURE Proc_cal_professor_upvel()
DETERMINISTIC
BEGIN
IF (SELECT count(*) FROM Professor WHERE salary < 30000) > 0 THEN
# Create new temp table storing ID, old salary and old credit_limit
CREATE TEMPORARY TABLE IF NOT EXISTS TEMP_PROF_OLD ( PID varchar(16), salary INT, credit_limit decimal(10,2));
TRUNCATE TABLE TEMP_PROF_OLD;

INSERT INTO TEMP_PROF_OLD (PID,salary, credit_limit)
SELECT pid,salary, faculty_insurance.credit_limit
FROM Professor
INNER JOIN faculty_insurance ON ref_id = pid
WHERE salary < 30000;
# Update professors incresing salary by 10%
UPDATE Professor SET salary = salary * 1.1
WHERE pid IN (SELECT PID FROM TEMP_PROF_OLD);
# Update insurance credit_limit by 400% of new salary
UPDATE faculty_insurance
INNER JOIN Professor ON ref_id = pid
SET credit_limit = 4 * salary
WHERE ref_id IN (SELECT PID FROM TEMP_PROF_OLD);
# Insert all the values into system log
INSERT INTO system_log (user_log, remark, timestamp)
SELECT o.PID, CONCAT(
    'old salary: ', o.salary,
    ' new salary: ', p.salary,
    ' old credit limit:', o.credit_limit,
    ' new credit limit: ', f.credit_limit
    ),  SYSDATE()
FROM TEMP_PROF_OLD o
INNER JOIN Professor p ON p.pid = o.PID
INNER JOIN faculty_insurance f on p.pid = f.ref_id;
# Select values to show
SELECT o.PID, p.pname, 
    o.salary as old_salary,
    p.salary as new_salary,
    o.credit_limit as old_credit_limit,
    f.credit_limit as new_credit_limit,
    SYSDATE()
FROM TEMP_PROF_OLD o
INNER JOIN Professor p ON p.pid = o.PID
INNER JOIN faculty_insurance f on p.pid = f.ref_id;

ELSE

SELECT 'Professor < 30000 is empty';

END IF;
END$$

CALL Proc_cal_professor_upvel();
