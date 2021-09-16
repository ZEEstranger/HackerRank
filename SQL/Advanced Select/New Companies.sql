WITH
    TEST_LEA AS(
        SELECT 
            COMPANY_CODE,
            COUNT(DISTINCT LEAD_MANAGER_CODE) AS LMC
        FROM
            LEAD_MANAGER
        GROUP BY
            COMPANY_CODE
    ),
    TEST_SEN AS(
        SELECT
            COMPANY_CODE,
            COUNT(DISTINCT SENIOR_MANAGER_CODE) AS SMC
        FROM
            SENIOR_MANAGER
        GROUP BY
            COMPANY_CODE
    ),
    TEST_MAN AS(
        SELECT
            COMPANY_CODE,
            COUNT(DISTINCT MANAGER_CODE) AS MC
        FROM
            MANAGER
        GROUP BY
            COMPANY_CODE
    ),
    TEST_EMP AS(
        SELECT
            COMPANY_CODE,
            COUNT(DISTINCT EMPLOYEE_CODE) AS EC
        FROM 
            EMPLOYEE
        GROUP BY
            COMPANY_CODE
    )
SELECT
    A.COMPANY_CODE,
    A.FOUNDER,
    B.LMC,
    C.SMC,
    D.MC,
    E.EC
FROM
    COMPANY AS A
JOIN
    TEST_LEA AS B
    ON
        A.COMPANY_CODE = B.COMPANY_CODE
JOIN
    TEST_SEN AS C
    ON
        A.COMPANY_CODE = C.COMPANY_CODE
JOIN
    TEST_MAN AS D
    ON
        A.COMPANY_CODE = D.COMPANY_CODE
JOIN
    TEST_EMP AS E
    ON
        A.COMPANY_CODE = E.COMPANY_CODE
ORDER BY
    COMPANY_CODE