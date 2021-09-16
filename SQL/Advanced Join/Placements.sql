SELECT
    STU.NAME
FROM
    STUDENTS AS STU
JOIN
    FRIENDS AS FRI
    ON
        STU.ID = FRI.ID
JOIN
    PACKAGES AS PS
    ON
        STU.ID = PS.ID
JOIN
    PACKAGES AS PF
    ON
        FRI.FRIEND_ID = PF.ID
WHERE
    PS.SALARY < PF.SALARY
ORDER BY
    PF.SALARY