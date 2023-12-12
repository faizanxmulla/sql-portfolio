SELECT unique_id, name
FROM Employees e LEFT JOIN EmployeeUNI eu ON e.id = eu.id


# can be used w/o --> IFNULL(unique_id, null)