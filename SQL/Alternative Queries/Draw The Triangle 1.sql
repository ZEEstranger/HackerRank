DECLARE @A INT = 20
WHILE (@A > 0)
BEGIN
    PRINT REPLICATE ('* ', @A)
    SET @A = @A - 1
END