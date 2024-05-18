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
-- 22) Find names of sailors whose name begins and ends with ‘B’ and has exactly 3 chars."
PROMPT "22) Find names of sailors whose name begins and ends with ‘B’ and has exactly 3 chars."
-- 23) Find names of sailors who have reserved a red boat or a green boat."
PROMPT "23) Find names of sailors who have reserved a red boat or a green boat."
-- 24) Find names of sailors who have reserved a red boat but not a green boat."
PROMPT "24) Find names of sailors who have reserved a red boat but not a green boat."
-- 25) Find names of sailors who have reserved boat 103."
PROMPT "25) Find names of sailors who have reserved boat 103."
-- 26) Find names of sailors who have reserved red boat."
PROMPT "26) Find names of sailors who have reserved red boat."
-- 28) Find names of sailors who have not reserved red boat."
PROMPT "28) Find names of sailors who have not reserved red boat."
-- 29) Count distinct sailor name from sailors."
PROMPT "29) Count distinct sailor name from sailors."
-- 30)a) Find all records for the rating>some sailor name where sailor name like ‘Horatio’."
PROMPT "30)a) Find all records for the rating>some sailor name where sailor name like ‘Horatio’."
--  b) Find all records for the rating>all sailor name where sailor name like ‘Horatio’."
PROMPT " b) Find all records for the rating>all sailor name where sailor name like ‘Horatio’."
-- 32(a)Find all records for the rating<some sailor name where sailor name like ‘Horatio’."
PROMPT "32(a)Find all records for the rating<some sailor name where sailor name like ‘Horatio’."
--  (b)Find all records for the rating<all sailor name where sailor name like ‘Horatio’."
PROMPT " (b)Find all records for the rating<all sailor name where sailor name like ‘Horatio’."
-- 32) Select all records for s_name neither Lubber nor Horatio."
PROMPT "32) Select all records for s_name neither Lubber nor Horatio."
-- 33) Find names of sailors whose rating is>10/20/30 using multirow subquery operator."
PROMPT "33) Find names of sailors whose rating is>10/20/30 using multirow subquery operator."
-- 34) Find names of sailors whose rating is>10 & 20 & 30 using multirow subquery operator."
PROMPT "34) Find names of sailors whose rating is>10 & 20 & 30 using multirow subquery operator."
-- 35) Find average age of sailors with rating 10."
PROMPT "35) Find average age of sailors with rating 10."
-- 36) Find the name of sailor who are older than oldest sailor of rating=10."
PROMPT "36) Find the name of sailor who are older than oldest sailor of rating=10."
-- 37) Find the age of youngest sailor for each rating level."
PROMPT "37) Find the age of youngest sailor for each rating level."
-- 38) Find the name of each sailor who is eligible to vote for each rating level."
PROMPT "38) Find the name of each sailor who is eligible to vote for each rating level."
-- 39) Find the age of youngest sailor who is eligible to vote for each rating level with at least two such sailors"
PROMPT "39) Find the age of youngest sailor who is eligible to vote for each rating level with at least two such sailors"
-- 40) Find the average age of sailor for each rating level with at least two such sailor."
PROMPT "40) Find the average age of sailor for each rating level with at least two such sailor."
-- 41) For each red boat count the no of reservations for this boat."
PROMPT "41) For each red boat count the no of reservations for this boat."
-- 42) Find sailor with highest rating."
PROMPT "42) Find sailor with highest rating."
-- 44) Find those rating for which the average age of sailors is minimum over all rating."
PROMPT "44) Find those rating for which the average age of sailors is minimum over all rating."
-- 45) Find sailors who have reserved all boats."
PROMPT "45) Find sailors who have reserved all boats."
-- 46) Display s_name with left side padding by at least 3 *."
PROMPT "46) Display s_name with left side padding by at least 3 *."
-- 47) Display length of each name."
PROMPT "47) Display length of each name."
-- 48) Display all sailors names in uppercase."
PROMPT "48) Display all sailors names in uppercase."
-- 49) Display all sailors’ names in lower case."
PROMPT "49) Display all sailors’ names in lower case."
-- 50) Display all sailors names in sentence case."
PROMPT "50) Display all sailors names in sentence case."
-- 51) Display 4th to 7th letter of sailors name."
PROMPT "51) Display 4th to 7th letter of sailors name."
-- 52) Display 4th and 7th letter of sailors name."
PROMPT "52) Display 4th and 7th letter of sailors name."
-- 53) Concat s_id, s_name."
PROMPT "53) Concat s_id, s_name."
-- 54) Display square root of rating."
PROMPT "54) Display square root of rating."
-- 55) Display floor values of all ages."
PROMPT "55) Display floor values of all ages."
-- 56) Display ceiling values of all ages."
PROMPT "56) Display ceiling values of all ages."
-- 57) Select all s_name with 1st 2 letters off."
PROMPT "57) Select all s_name with 1st 2 letters off."
-- 58) List months between today and reservation date."
PROMPT "58) List months between today and reservation date."
-- 59) Select day between today and reservation date."
PROMPT "59) Select day between today and reservation date."
-- 60) Shift all reservation day by 2 months."
PROMPT "60) Shift all reservation day by 2 months."
-- 61) Shift all reservation day earlier by 3 months."
PROMPT "61) Shift all reservation day earlier by 3 months."
-- 62) Suppose after sailing they enjoy their next Monday as holiday. Find that day."
PROMPT "62) Suppose after sailing they enjoy their next Monday as holiday. Find that day."
-- 63) Display 3 * before and after each s_name."
PROMPT "63) Display 3 * before and after each s_name."
-- 64) Find the date when sailing ends."
PROMPT "64) Find the date when sailing ends."
-- 65) Display all reservation day."
PROMPT "65) Display all reservation day."
-- 66)Find the position of ‘Kumar’ in the sailors name."
PROMPT "66)Find the position of ‘Kumar’ in the sailors name."
-- 67)display all saiors name order by its length."
PROMPT "67)display all saiors name order by its length."
-- 68)display sid,sname and availability of middle name which pint as ‘available’ or ‘not available’."
PROMPT "68)display sid,sname and availability of middle name which pint as ‘available’ or ‘not available’."
-- 69)display all reservation day like ‘22nd March twenty ten’ and 12/09/1998."
PROMPT "69)display all reservation day like ‘22nd March twenty ten’ and 12/09/1998."
-- 70)find the day of weekdays of reservation date."
PROMPT "70)find the day of weekdays of reservation date."
-- 71)find the number of day of weekdays of reservation date."
PROMPT "71)find the number of day of weekdays of reservation date."
-- 72) Find the number of days passed upto reservation date of that year."
PROMPT "72) Find the number of days passed upto reservation date of that year."
-- 73) Display the number of weeks of the year for reservation day."
PROMPT "73) Display the number of weeks of the year for reservation day."