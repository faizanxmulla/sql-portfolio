SELECT distinct a.number as num1, b.number as num2
FROM   transportation_numbers a JOIN transportation_numbers b ON a.number < b.number
                                                              AND a.number*b.number > 11