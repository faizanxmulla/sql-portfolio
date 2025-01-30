SELECT DISTINCT a.number num_1,
                b.number num_2,
                c.number num_3
FROM   transportation_numbers a JOIN transportation_numbers b ON a.number <> b.number
                                JOIN transportation_numbers c ON b.number <> c.number
                                                              AND a.number <> c.number
WHERE  a.number+b.number+c.number = 8