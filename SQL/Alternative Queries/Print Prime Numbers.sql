DECLARE @i int=2;
DECLARE @prime int = 0;
DECLARE @result nvarchar(1000) = '';
WHILE (@i<=1000)
begin
    DECLARE @j int = @i-1;
    SET @prime = 1;
    WHILE(@j > 1)
    begin
        IF @i % @j = 0
        begin 
            SET @prime = 0;
        end
        SET @j = @j - 1;
    end
    IF @prime = 1
    begin
        SET @result += CAST(@i as nvarchar(1000)) + '&';
    end
SET @i = @i + 1;
end
SET @result = SUBSTRING(@result, 1, LEN(@result) - 1)
SELECT @result