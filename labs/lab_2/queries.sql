#4.1
SELECT DISTINCT title, semester FROM Section LEFT JOIN Course ON Section.cid = Course.cid WHERE semester = "2" AND YEAR = "2015";
#4.2
SELECT DISTINCT pname FROM Teaches LEFT JOIN Professor ON Teaches.pid = Professor.pid WHERE semester = "Summer" AND YEAR = "2015";
#4.3
SELECT pname, salary FROM Professor WHERE salary = (SELECT max(salary) from Professor);
#4.4
SELECT title, building, room, timeslot_id FROM Section LEFT JOIN Course ON Section.cid = Course.cid WHERE semester = "1" AND YEAR = "2015";
#4.5
SELECT * FROM Student WHERE year = "2";

#5
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Teaches t WHERE EXISTS (
	SELECT pid, cid, sect_id, semester, year 
	FROM (
		SELECT Teaches.pid, Teaches.cid, Teaches.semester, Teaches.year, Teaches.sect_id FROM Teaches 
		LEFT JOIN Takes ON 
			Teaches.cid = Takes.cid AND 
			Teaches.semester = Takes.semester AND
			Teaches.year = Takes.year AND
			Teaches.sect_id = Takes.sect_id
		GROUP BY Teaches.pid, Teaches.cid, Teaches.semester, Teaches.year, Teaches.sect_id
		HAVING count(Takes.student_id) = 0) AS NoStudent
	WHERE (pid,cid,sect_id,semester) = (t.pid, t.cid, t.sect_id, t.semester)
);
SET SQL_SAFE_UPDATES = 1;

SELECT Teaches.pid, Teaches.cid, Teaches.semester, Teaches.year, Teaches.sect_id FROM Teaches 
	LEFT JOIN Takes ON 
		Teaches.cid = Takes.cid AND 
		Teaches.semester = Takes.semester AND
		Teaches.year = Takes.year AND
		Teaches.sect_id = Takes.sect_id
	GROUP BY Teaches.pid, Teaches.cid, Teaches.semester, Teaches.year, Teaches.sect_id
	HAVING count(Takes.student_id) = 0;
    
DELETE FROM Teaches WHERE (pid, cid, sect_id, semester, year) IN (("003", "201001", "2", "summer", "2015"), ('005','301001','1','2','2015'));

# Just In Case
INSERT INTO Teaches (pid, cid, sect_id, semester, year) VALUES ("003", "201001", "2", "summer", "2015"), ('005','301001','1','2','2015');
    





