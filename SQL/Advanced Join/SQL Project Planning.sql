WITH FIL AS(
    SELECT
        START_DATE S_D
        , END_DATE E_D
    FROM
        PROJECTS
    WHERE
        START_DATE NOT IN (
            SELECT
                END_DATE
            FROM
                PROJECTS
        )
),

STR (START_DATE, END_DATE, N, RK) AS(
    SELECT
        S_D
        , E_D
        , 0 N
        , RANK() OVER(
            ORDER BY S_D) RK
    FROM 
        FIL
    UNION ALL
    SELECT
        P.START_DATE
        , P.END_DATE
        , STR.N + 1
        , STR.RK
    FROM 
        PROJECTS P
    INNER JOIN
        STR
        ON
            STR.END_DATE = P.START_DATE
),

MAX_IN_RANK AS(
    SELECT
        MAX(N) MAX_RK
        , RK
    FROM
        STR
    GROUP BY
        RK
),

FINAL_CUT(SD, ED, MR, RRR) AS(
    SELECT
        FIL.S_D AS SD
        , S2.END_DATE AS ED
        , MIR.MAX_RK AS MR
        , ROW_NUMBER() OVER(
            ORDER BY
                MIR.MAX_RK,
                FIL.S_D) AS RRR
    FROM
        FIL
    INNER JOIN
        STR S1
        ON
            S1.START_DATE = FIL.S_D
    JOIN
        MAX_IN_RANK MIR
        ON
            S1.RK = MIR.RK
    JOIN
        STR S2
        ON
            S2.N = MIR.MAX_RK AND
            S1.RK = S2.RK
)

SELECT
    SD
    , ED
FROM
    FINAL_CUT
ORDER BY
    RRR
