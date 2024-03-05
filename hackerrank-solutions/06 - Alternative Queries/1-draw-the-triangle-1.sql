-- P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
-- Write a query to print the pattern P(20).


DECLARE @var int =20                        
WHILE @var > 0                 
BEGIN                          
PRINT replicate('* ', @var)    
SET @var = @var - 1            
END  