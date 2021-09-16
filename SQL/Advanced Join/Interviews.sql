WITH SUM_SUB AS (
    SELECT
        CHALLENGE_ID AS CHALL_ID,
        SUM(TOTAL_SUBMISSIONS) AS SUM_TOT_SUB,
        SUM(TOTAL_ACCEPTED_SUBMISSIONS) AS SUM_TOT_ACE_SUB
    FROM
        SUBMISSION_STATS
    GROUP BY
        CHALLENGE_ID
),

SUM_VIEWS AS(
    SELECT
        CHALLENGE_ID AS CHALL_ID,
        SUM(TOTAL_VIEWS) AS SUM_TOT_VIE,
        SUM(TOTAL_UNIQUE_VIEWS) AS SUM_TOT_UNI_VIE
    FROM
        VIEW_STATS
    GROUP BY
        CHALLENGE_ID
),

ALL_SUM AS(
    SELECT
        CHALL.COLLEGE_ID AS COL_ID,
        SUM(SUM_SUB.SUM_TOT_SUB) AS STS,
        SUM(SUM_SUB.SUM_TOT_ACE_SUB) AS STAS,
        SUM(SUM_VIEWS.SUM_TOT_VIE) AS STV,
        SUM(SUM_VIEWS.SUM_TOT_UNI_VIE) AS STUV
    FROM
        CHALLENGES AS CHALL
    LEFT JOIN
        SUM_VIEWS
        ON
            CHALL.CHALLENGE_ID = SUM_VIEWS.CHALL_ID
    LEFT JOIN
        SUM_SUB
        ON
            CHALL.CHALLENGE_ID = SUM_SUB.CHALL_ID
    GROUP BY
        CHALL.COLLEGE_ID
),

HACK_T AS(
    SELECT
        CON.HACKER_ID AS H_ID,
        CON.NAME AS H_NAME,
        CON.CONTEST_ID AS CON_ID,
        SUM(ALL_SUM.STS) AS S1,
        SUM(ALL_SUM.STAS) AS S2,
        SUM(ALL_SUM.STV) AS S3,
        SUM(ALL_SUM.STUV) AS S4 
    FROM
        COLLEGES AS COL
    JOIN
        CONTESTS AS CON
        ON
            CON.CONTEST_ID = COL.CONTEST_ID
    JOIN
        ALL_SUM
        ON
            ALL_SUM.COL_ID = COL.COLLEGE_ID
    GROUP BY
        CON.HACKER_ID,
        CON.NAME,
        CON.CONTEST_ID
)

SELECT
    CON_ID,
    H_ID,
    H_NAME,
    S1,
    S2,
    S3,
    S4
FROM
    HACK_T
WHERE
    S1 + S2 + S3 + S4 > 0
ORDER BY
    CON_ID