-- Map an adult with a child if there is no child to keep the adult alone
/*
CREATE TABLE FAMILY
(
PERSON VARCHAR(5),
TYPE VARCHAR(10),
AGE INT
);

INSERT INTO FAMILY VALUES
('A1','Adult',54),
('A2','Adult',53),
('A3','Adult',52),
('A4','Adult',58),
('A5','Adult',54),
('C1','Child',20),
('C2','Child',19),
('C3','Child',22),
('C4','Child',15);

*/

WITH ADULT AS (SELECT *,SUBSTRING(PERSON,2,1) AS KEY_COL FROM DBO.FAMILY WHERE TYPE = 'Adult'),
CHILD AS (SELECT * ,SUBSTRING(PERSON,2,1) AS KEY_COL FROM DBO.FAMILY WHERE TYPE = 'Child')
SELECT A.PERSON AS ADULT ,C.PERSON AS CHILD FROM ADULT A LEFT JOIN CHILD C ON A.KEY_COL=C.KEY_COL;
