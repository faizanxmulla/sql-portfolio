-- P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
-- Write a query to print the pattern P(20).


DECLARE @var int 
SELECT @var=1                       
WHILE @var <= 20                 
BEGIN                          
PRINT replicate('* ', @var)    
SET @var = @var + 1            
END  
