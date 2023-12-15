SELECT user_id, CONCAT(UCASE(SUBSTR(name, 1,1)), LCASE(SUBSTR(name, 2, length(name)))) as name
FROM Users 
ORDER BY 1

#  instead of : {UCASE and LCASE} --> could have used {UPPER & LOWER}.
#  instead of : {SUBSTR} --> could have used {SUBSTRING} or {MID} or {LEFT & RIGHT}.
