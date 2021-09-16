WITH TEST_T AS(
    SELECT
        X,
        Y,
        ROW_NUMBER() OVER(ORDER BY X) AS RNX
    FROM
        FUNCTIONS
)

SELECT DISTINCT
    T1.X,
    T1.Y
FROM
TEST_T AS T1
JOIN
    TEST_T AS T2
    ON
        T1.Y = T2.X AND
        T1.RNX <> T2.RNX
WHERE
    T1.X = T2.Y AND
    T1.X <= T1.Y
ORDER BY
    T1.X