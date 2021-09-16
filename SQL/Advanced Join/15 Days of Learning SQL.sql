WITH DAY_CHECK AS (
    SELECT
        DAY(SUBMISSION_DATE) AS S_DAY
    FROM
        SUBMISSIONS
    GROUP BY
      DAY(SUBMISSION_DATE)  
),

GROUP_HACKERS AS(
    SELECT
        SUBMISSION_DATE AS S_DATE,
        HACKER_ID AS H_ID,
        COUNT(SCORE) AS C_SCORE,
        ROW_NUMBER() OVER(PARTITION BY SUBMISSION_DATE ORDER BY COUNT(SCORE) DESC, HACKER_ID ASC) AS RN
    FROM
        SUBMISSIONS
    GROUP BY
        SUBMISSION_DATE,
        HACKER_ID
),

LIST_HACKERS AS(
    SELECT
        S_DATE,
        H_ID,
        ROW_NUMBER() OVER(
            PARTITION BY H_ID
            ORDER BY S_DATE
        ) AS RN
    FROM
        GROUP_HACKERS
),

SORT_LIST_HACKERS AS(
    SELECT 
        H_ID,
        MAX(RN) AS MAX_DAY
    FROM
        LIST_HACKERS
    WHERE
        DAY(S_DATE) = RN
    GROUP BY
        H_ID
),

LIST_DAYS AS(
    SELECT
        MAX_DAY,
        COUNT(MAX_DAY) AS COUNT_DAYS
    FROM
        SORT_LIST_HACKERS 
    GROUP BY
        MAX_DAY
),

FULL_LIST_DAYS AS(
    SELECT
        DC.S_DAY AS S_DAY,
        LD.COUNT_DAYS AS COUNT_DAYS,
        SUM(LD.COUNT_DAYS) OVER(ORDER BY S_DAY DESC) AS SUM_DAYS
    FROM
        DAY_CHECK AS DC
    LEFT JOIN
        LIST_DAYS AS LD
        ON
            DC.S_DAY = LD.MAX_DAY
),

LIST_INTENSIVE_HACKERS AS(
    SELECT
        S_DATE,
        H_ID
    FROM
        GROUP_HACKERS
    WHERE
        RN = 1
)

SELECT 
    LIH.S_DATE,
    FLD.SUM_DAYS,
    LIH.H_ID,
    HAC.NAME
FROM
    LIST_INTENSIVE_HACKERS AS LIH
JOIN
    HACKERS AS HAC
    ON
        HAC.HACKER_ID = LIH.H_ID
JOIN
    FULL_LIST_DAYS AS FLD
    ON
        DAY(LIH.S_DATE) = FLD.S_DAY
ORDER BY
    LIH.S_DATE