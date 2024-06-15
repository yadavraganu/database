/*
-- For each region find house which has won maximum no of battles. display region, house and no of wins
CREATE TABLE KING (
    K_NO INT PRIMARY KEY,
    KING VARCHAR(50),
    HOUSE VARCHAR(50)
);

CREATE TABLE BATTLE (
    BATTLE_NUMBER INT PRIMARY KEY,
    NAME VARCHAR(100),
    ATTACKER_KING INT,
    DEFENDER_KING INT,
    ATTACKER_OUTCOME INT,
    REGION VARCHAR(50),
    FOREIGN KEY (ATTACKER_KING) REFERENCES KING(K_NO),
    FOREIGN KEY (DEFENDER_KING) REFERENCES KING(K_NO)
);

INSERT INTO KING (K_NO, KING, HOUSE) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

INSERT INTO BATTLE (BATTLE_NUMBER, NAME, ATTACKER_KING, DEFENDER_KING, ATTACKER_OUTCOME, REGION) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');
*/
WITH WINNERS AS (SELECT *, RANK() OVER (PARTITION BY REGION ORDER BY BATTLE_WON DESC) AS RANK
                 FROM(SELECT REGION, HOUSE, COUNT(*) AS BATTLE_WON
                      FROM(SELECT CASE WHEN ATTACKER_OUTCOME=1 THEN ATTACKER_KING ELSE DEFENDER_KING END AS WINNER_KING, REGION
                           FROM DBO.BATTLE)B
                          LEFT OUTER JOIN DBO.KING K ON B.WINNER_KING=K.K_NO
                      GROUP BY REGION, HOUSE)R )
SELECT REGION, HOUSE,BATTLE_WON FROM WINNERS W WHERE RANK=1;