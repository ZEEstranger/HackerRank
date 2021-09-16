SELECT 
    DISTINCT A.N, 
    CASE
        WHEN B.N IS NULL THEN 'Leaf'
        WHEN A.P IS NULL THEN 'Root'
        ELSE 'Inner'
    END AS TES
FROM BST AS A
LEFT JOIN BST AS B ON 
    B.P = A.N