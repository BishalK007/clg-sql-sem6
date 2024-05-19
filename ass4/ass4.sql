PROMPT "Clear Screen"
cl scr
SET PAGESIZE 50;

SET LINESIZE 200;

DROP TABLE RESERVATION;
DROP TABLE SAILOR;
DROP TABLE BOAT;


CREATE TABLE SAILOR (
  SID varchar2(4) PRIMARY KEY CHECK (sid LIKE 's%'),
  SNAME varchar2(15) NOT NULL CHECK (sname = INITCAP(sname)) ,
  MNAME varchar2(15) ,
  SURNAME varchar2(15) NOT NULL,
  RATING number(2) DEFAULT 0,
  AGE number(3,1) NOT NULL
);

CREATE TABLE BOAT (
  BID number(3) PRIMARY KEY,
  BNAME varchar2(10) NOT NULL CHECK (bname = UPPER(bname)),
  COLOR varchar2(6) CHECK (COLOR IN ('RED','GREEN','BLUE'))
);

CREATE TABLE RESERVATION (
  SID varchar2(4) NOT NULL,
  BID number(3) NOT NULL,
  DAY date NOT NULL CHECK (DAY < TO_DATE('01-JAN-2000','DD-MON-YYYY')),
  CONSTRAINT pk_reservation PRIMARY KEY (SID, BID),
  FOREIGN KEY (SID) REFERENCES SAILOR(SID),
  FOREIGN KEY (BID) REFERENCES BOAT(BID)
);


PROMPT "Insert DATA"
@data.sql

SELECT * FROM SAILOR;
SELECT * FROM BOAT;
SELECT * FROM RESERVATION;

-- 1) Find the names and ages of all sailors."
PROMPT "1) Find the names and ages of all sailors."
SELECT SNAME, MNAME, SURNAME, AGE FROM SAILOR; 

-- 2) Show names under the heading of names_of_sailors and add 2 to age."
PROMPT "2) Show names under the heading of names_of_sailors and add 2 to age."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors, AGE+2 FROM SAILOR; 

-- 3) Select all records from sailors in ascending order by name;"
PROMPT "3) Select all records from sailors in ascending order by name;"
SELECT * FROM SAILOR ORDER BY SNAME || ' ' || MNAME || ' ' || SURNAME ASC;

-- 4) Show all sailors name."
PROMPT "4) Show all sailors name."
SELECT SNAME FROM SAILOR;

-- 5) Select all distinct sailors name."
PROMPT "5) Select all distinct sailors name."
SELECT DISTINCT  SNAME FROM SAILOR;

-- 6) Show all distinct sailors names, ratings who have rating between 5 and 10."
PROMPT "6) Show all distinct sailors names, ratings who have rating between 5 and 10."
SELECT DISTINCT  SNAME FROM SAILOR WHERE rating >= 5 AND rating <= 10;

-- 7) Select all records from sailors in ascending order by rating and descending order by age."
PROMPT "7) Select all records from sailors in ascending order by rating and descending order by age."
SELECT * FROM SAILOR ORDER BY rating ASC, age DESC;

-- 8) Select all records from sailors whose rating>7."
PROMPT "8) Select all records from sailors whose rating>7."
SELECT * FROM SAILOR WHERE rating > 7;

-- 9) Find records for sailor name Horatio and age=35.4."
PROMPT "9) Find records for sailor name Horatio and age=35.4."
SELECT * FROM SAILOR WHERE sname = 'Horatio' AND age = '35.4';

-- 10) Find records for sailor name Horatio or age=35.4."
PROMPT "10) Find records for sailor name Horatio or age=35.4."
SELECT * FROM SAILOR WHERE sname = 'Horatio' OR age = '35.4';

-- 11) Select names of sailors who have reserved boat 104."
PROMPT "11) Select names of sailors who have reserved boat 104."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR s JOIN RESERVATION r ON s.sid = r.sid WHERE r.bid = '104';

-- 12) Find sid of sailors who have reserved red boat"
PROMPT "12) Find sid of sailors who have reserved red boat"
SELECT s.sid FROM SAILOR s JOIN RESERVATION r ON s.sid = r.sid JOIN BOAT b ON b.bid = r.bid WHERE b.color = 'RED';

-- 13) Select records for name beginning with ‘B’."
PROMPT "13) Select records for name beginning with ‘B’."
SELECT * FROM SAILOR WHERE SNAME LIKE 'B%';

-- 14) Select records for name containing ‘B’/’b’."
PROMPT "14) Select records for name containing ‘B’/’b’."
SELECT * FROM SAILOR WHERE SNAME LIKE '%B%' OR SNAME LIKE '%b%';

-- 15) Select names for rating present."
PROMPT "15) Select names for rating present."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR WHERE RATING IS NOT NULL;

-- 16) Select names for rating absent."
PROMPT "16) Select names for rating absent."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR WHERE RATING IS NULL;

-- 17) Find color of boats reserved by Lubber."
PROMPT "17) Find color of boats reserved by Lubber."
SELECT b.COLOR FROM BOAT b NATURAL JOIN reservation r NATURAL JOIN sailor s WHERE s.sname = 'Lubber'; 

-- 18) Find a sailor name that have reserved at least one boat.
PROMPT "18) Find a sailor name that have reserved at least one boat."
SELECT DISTINCT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors 
FROM SAILOR s 
WHERE (SELECT COUNT(day) FROM RESERVATION r WHERE r.sid = s.sid) > 1;

-- 20) Compute the increments of rating of persons who have sailed on diff boats on the same day."
PROMPT "20) Compute the increments of rating of persons who have sailed on diff boats on the same day."
SELECT DISTINCT s.sid, s.sname, s.rating + 1 
FROM SAILOR s
JOIN reservation r2 ON s.sid = r2.sid
JOIN reservation r1 ON r1.day = r2.day AND r1.sid = r2.sid
WHERE r1.bid <> r2.bid;


-- 21) Find name of sailors whose name begins and ends with B and has at least 3 characters"
PROMPT "21) Find name of sailors whose name begins and ends with B and has at least 3 characters"
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR
WHERE (SNAME LIKE 'B%_%B' OR SNAME LIKE 'b%_%b' OR SNAME LIKE 'B%_%b' OR SNAME LIKE 'b%_%B'); 

-- 22) Find names of sailors whose name begins and ends with ‘B’ and has exactly 3 chars."
PROMPT "22) Find names of sailors whose name begins and ends with ‘B’ and has exactly 3 chars."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR
WHERE (SNAME LIKE 'B_B' OR SNAME LIKE 'b_b' OR SNAME LIKE 'B_b' OR SNAME LIKE 'b_B'); 

-- 23) Find names of sailors who have reserved a red boat or a green boat."
PROMPT "23) Find names of sailors who have reserved a red boat or a green boat."
SELECT DISTINCT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR s
JOIN RESERVATION r ON s.sid = r.sid
JOIN BOAT b ON b.bid = r.bid
WHERE b.COLOR IN ('RED', 'GREEN');

-- 24) Find names of sailors who have reserved a red boat but not a green boat."
PROMPT "24) Find names of sailors who have reserved a red boat but not a green boat."
SELECT DISTINCT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors FROM SAILOR s
JOIN RESERVATION r ON s.sid = r.sid
JOIN BOAT b ON b.bid = r.bid
WHERE b.COLOR = 'RED' AND b.COLOR <> 'GREEN';

-- 25) Find names of sailors who have reserved boat 103.
PROMPT "25) Find names of sailors who have reserved boat 103."
SELECT DISTINCT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors 
FROM SAILOR s
JOIN RESERVATION r ON s.sid = r.sid
WHERE r.bid = '103';

-- 26) Find names of sailors who have reserved red boat.
PROMPT "26) Find names of sailors who have reserved red boat."
SELECT DISTINCT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors 
FROM SAILOR s
JOIN RESERVATION r ON s.sid = r.sid
JOIN BOAT b ON b.bid = r.bid
WHERE b.COLOR = 'RED';

-- 28) Find names of sailors who have not reserved red boat.
PROMPT "28) Find names of sailors who have not reserved red boat."
SELECT DISTINCT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors 
FROM SAILOR s
WHERE s.sid NOT IN (
    SELECT r.sid
    FROM RESERVATION r
    JOIN BOAT b ON b.bid = r.bid
    WHERE b.COLOR = 'RED'
);
-- 29) Count distinct sailor name from sailors."
PROMPT "29) Count distinct sailor name from sailors."
SELECT DISTINCT SNAME FROM SAILOR;

-- 30)a) Find all records for the rating>some sailor name where sailor name like ‘Horatio’."
PROMPT "30)a) Find all records for the rating>some sailor name where sailor name like ‘Horatio’."
SELECT * FROM SAILOR WHERE RATING > ANY(
    SELECT RATING FROM SAILOR WHERE SNAME LIKE 'Horatio'
);

--  b) Find all records for the rating>all sailor name where sailor name like ‘Horatio’."
PROMPT " b) Find all records for the rating>all sailor name where sailor name like ‘Horatio’."
SELECT * FROM SAILOR WHERE RATING > ALL(
    SELECT RATING FROM SAILOR WHERE SNAME LIKE 'Horatio'
);

-- 32(a)Find all records for the rating<some sailor name where sailor name like ‘Horatio’."
PROMPT "32(a)Find all records for the rating<some sailor name where sailor name like ‘Horatio’."
SELECT * FROM SAILOR WHERE RATING < ANY(
    SELECT RATING FROM SAILOR WHERE SNAME LIKE 'Horatio'
);

--  (b)Find all records for the rating<all sailor name where sailor name like ‘Horatio’."
PROMPT " (b)Find all records for the rating<all sailor name where sailor name like ‘Horatio’."
SELECT * FROM SAILOR WHERE RATING < ALL(
    SELECT RATING FROM SAILOR WHERE SNAME LIKE 'Horatio'
);

-- 32) Select all records for s_name neither Lubber nor Horatio."
PROMPT "32) Select all records for s_name neither Lubber nor Horatio."
SELECT * FROM SAILOR WHERE SNAME NOT IN ('Lubber', 'Horatio');

-- 33) Find names of sailors whose rating is>10/20/30 using multirow subquery operator."
PROMPT "33) Find names of sailors whose rating is>10/20/30 using multirow subquery operator."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors
FROM SAILOR
WHERE RATING > ANY (
    SELECT 10 FROM DUAL UNION
    SELECT 20 FROM DUAL UNION
    SELECT 30 FROM DUAL
);

-- 34) Find names of sailors whose rating is>10 & 20 & 30 using multirow subquery operator."
PROMPT "34) Find names of sailors whose rating is>10 & 20 & 30 using multirow subquery operator."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS names_of_sailors
FROM SAILOR
WHERE RATING > ALL (
    SELECT 10 FROM DUAL UNION
    SELECT 20 FROM DUAL UNION
    SELECT 30 FROM DUAL
);

-- 35) Find average age of sailors with rating 10.
PROMPT "35) Find average age of sailors with rating 10."
SELECT AVG(AGE) AS average_age
FROM SAILOR
WHERE RATING = 10;

-- 36) Find the name of sailor who are older than oldest sailor of rating=10.
PROMPT "36) Find the name of sailor who are older than oldest sailor of rating=10."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS sailor_name
FROM SAILOR
WHERE AGE > (
    SELECT MAX(AGE)
    FROM SAILOR
    WHERE RATING = 10
);

-- 37) Find the age of youngest sailor for each rating level.
PROMPT "37) Find the age of youngest sailor for each rating level."
SELECT RATING, MIN(AGE) AS youngest_age
FROM SAILOR
GROUP BY RATING;

-- 38) Find the name of each sailor who is eligible to vote for each rating level.
PROMPT "38) Find the name of each sailor who is eligible to vote for each rating level."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS sailor_name, RATING
FROM SAILOR
WHERE AGE >= 18;

-- 39) Find the age of youngest sailor who is eligible to vote for each rating level with at least two such sailors.
PROMPT "39) Find the age of youngest sailor who is eligible to vote for each rating level with at least two such sailors"
SELECT RATING, MIN(AGE) AS youngest_age
FROM SAILOR
WHERE AGE >= 18
GROUP BY RATING
HAVING COUNT(*) >= 2;

-- 40) Find the average age of sailor for each rating level with at least two such sailor.
PROMPT "40) Find the average age of sailor for each rating level with at least two such sailor."
SELECT RATING, AVG(AGE) AS average_age
FROM SAILOR
GROUP BY RATING
HAVING COUNT(*) >= 2;

-- 41) For each red boat count the no of reservations for this boat.
PROMPT "41) For each red boat count the no of reservations for this boat."
SELECT b.BID, COUNT(*) AS reservation_count
FROM BOAT b
JOIN RESERVATION r ON b.BID = r.BID
WHERE b.COLOR = 'RED'
GROUP BY b.BID;

-- 42) Find sailor with highest rating.
PROMPT "42) Find sailor with highest rating."
SELECT SNAME || ' ' || MNAME || ' ' || SURNAME AS sailor_name
FROM SAILOR
WHERE RATING = (
    SELECT MAX(RATING)
    FROM SAILOR
);

-- 44) Find those rating for which the average age of sailors is minimum over all rating."
PROMPT "44) Find those rating for which the average age of sailors is minimum over all rating."
SELECT rating 
FROM SAILOR
GROUP BY RATING
HAVING AVG(age) = (
    SELECT MIN(AVG(AGE)) FROM SAILOR GROUP BY RATING
);

-- 45) Find sailors who have reserved all boats.
PROMPT "45) Find sailors who have reserved all boats."
SELECT DISTINCT sid, COUNT(r.bid) 
FROM SAILOR 
NATURAL JOIN RESERVATION r 
GROUP BY sid 
HAVING count(r.bid) = (
    SELECT COUNT(*) FROM BOAT
);

-- 46) Display s_name with left side padding by at least 3 *."
PROMPT "46) Display s_name with left side padding by at least 3 *."
SELECT LPAD(SNAME, length(SNAME) + 3, '*') AS padded_s_name
FROM SAILOR;

-- 47) Display length of each name."
PROMPT "47) Display length of each name."
SELECT SNAME, length(SNAME) AS LENGTH
FROM SAILOR;

-- 48) Display all sailors names in uppercase."
PROMPT "48) Display all sailors names in uppercase."
SELECT UPPER(SNAME) AS UPPERCASE
FROM SAILOR;

-- 49) Display all sailors’ names in lower case."
PROMPT "49) Display all sailors’ names in lower case."
SELECT LOWER(SNAME) AS LOWERCASE
FROM SAILOR;

-- 50) Display all sailors names in sentence case."
PROMPT "50) Display all sailors names in sentence case."
SELECT INITCAP(SNAME) AS sentence_case
FROM SAILOR;

-- 51) Display 4th to 7th letter of sailors name."
PROMPT "51) Display 4th to 7th letter of sailors name."
SELECT SUBSTR(SNAME, 4, 4) AS substr_4_7
FROM SAILOR;

-- 52) Display 4th and 7th letter of sailors name.
PROMPT "52) Display 4th and 7th letter of sailors name."
SELECT SUBSTR(SNAME, 4, 1) AS letter_4, SUBSTR(SNAME, 7, 1) AS letter_7
FROM SAILOR;

-- 53) Concat s_id, s_name.
PROMPT "53) Concat s_id, s_name."
SELECT CONCAT(SID, ' ', SNAME) AS concatenated_id_name
FROM SAILOR;

-- 54) Display square root of rating.
PROMPT "54) Display square root of rating."
SELECT SQRT(RATING) AS square_root_rating
FROM SAILOR;

-- 55) Display floor values of all ages.
PROMPT "55) Display floor values of all ages."
SELECT FLOOR(AGE) AS floor_age
FROM SAILOR;

-- 56) Display ceiling values of all ages.
PROMPT "56) Display ceiling values of all ages."
SELECT CEILING(AGE) AS ceiling_age
FROM SAILOR;


-- 57) Select all s_name with 1st 2 letters off."
PROMPT "57) Select all s_name with 1st 2 letters off."
SELECT SUBSTR(SNAME, 3) AS trimmed_s_name
FROM SAILOR;

-- 58) List months between today and reservation date."
PROMPT "58) List months between today and reservation date."
SELECT sid, bid, MONTHS_BETWEEN(SYSDATE, day) AS months_between
FROM reservation;

-- 59) Select day between today and reservation date."
PROMPT "59) Select day between today and reservation date."
SELECT sid, bid, SYSDATE - day AS DAYS_BETWEEN
FROM reservation;

-- 60) Shift all reservation day by 2 months."
PROMPT "60) Shift all reservation day by 2 months."
UPDATE RESERVATION 
SET day = ADD_MONTHS(day, 2);


-- 61) Shift all reservation day earlier by 3 months."
PROMPT "61) Shift all reservation day earlier by 3 months."
UPDATE RESERVATION 
SET day = ADD_MONTHS(day, -3);

-- 62) Suppose after sailing they enjoy their next Monday as holiday. Find that day."
PROMPT "62) Suppose after sailing they enjoy their next Monday as holiday. Find that day."
SELECT NEXT_DAY(DAY, 'MONDAY') AS NEXT_MONDAY
FROM RESERVATION;

-- 63) Display 3 * before and after each s_name."
PROMPT "63) Display 3 * before and after each s_name."
SELECT RPAD(LPAD(SNAME, LENGTH(SNAME) + 3, '*' ), LENGTH(SNAME) + 6, '*') FROM SAILOR;
PROMPT OR--
SELECT CONCAT(CONCAT('***', SNAME), '***') FROM SAILOR;

-- 64) Find the date when sailing ends."
PROMPT "64) Find the date when sailing ends."
SELECT MAX(DAY) FROM RESERVATION;

-- 65) Display all reservation day."
PROMPT "65) Display all reservation day."

-- 66)Find the position of ‘Kumar’ in the sailors name."
PROMPT "66)Find the position of ‘Kumar’ in the sailors name."
SELECT INSTR(SNAME || ' ' || MNAME || ' ' || SURNAME, 'Kumar') FROM SAILOR;

-- 67)display all saiors name order by its length."
PROMPT "67)display all saiors name order by its length."
SELECT SNAME FROM SAILOR ORDER BY LENGTH(SNAME) ASC;

-- 68)display sid,sname and availability of middle name which pint as ‘available’ or ‘not available’."
PROMPT "68)display sid,sname and availability of middle name which pint as ‘available’ or ‘not available’."
SELECT SID, SNAME, 
    CASE
        WHEN MNAME IS NOT NULL THEN 'available'
        ELSE 'not available'
    END AS availability_of_middle_name
FROM SAILOR;

-- 69)display all reservation day like ‘22nd March twenty ten’ and 12/09/1998."
PROMPT "69)display all reservation day like ‘22nd March twenty ten’ and 12/09/1998."
SELECT 
    TO_CHAR(day, 'DD') ||
    CASE
        WHEN TO_CHAR(day, 'DD') IN ('01','21', '31') THEN 'st'
        WHEN TO_CHAR(day, 'DD') IN ('02','22') THEN 'nd'
        WHEN TO_CHAR(day, 'DD') IN ('03','23') THEN 'rd'
        ELSE 'th'
    END || ' ' ||
    TRIM(TO_CHAR(day, 'Month')) || ' ' ||
    TRIM(TO_CHAR(day, 'Year'))
    AS formatted_date1,
    TO_CHAR(day, 'DD/MM/YYYY') as  formatted_date2
FROM RESERVATION;


-- 70)find the day of weekdays of reservation date."
PROMPT "70)find the day of weekdays of reservation date."
SELECT day, TO_CHAR(day, 'Day') AS weekday
FROM reservation;

-- 71)find the number of day of weekdays of reservation date."
PROMPT "71)find the number of day of weekdays of reservation date."
SELECT TO_CHAR(day, 'Day') AS weekday, count(*) AS count
FROM reservation
GROUP BY TO_CHAR(day, 'Day');

-- 72) Find the number of days passed upto reservation date of that year."
PROMPT "72) Find the number of days passed upto reservation date of that year."
SELECT
    day,
    TO_CHAR(day, 'DDD') AS days_passed
FROM
    RESERVATION;

-- 73) Display the number of weeks of the year for reservation day."
PROMPT "73) Display the number of weeks of the year for reservation day."
SELECT
    day,
    TO_CHAR(day, 'IW') AS weeks_passed
FROM
    RESERVATION;
