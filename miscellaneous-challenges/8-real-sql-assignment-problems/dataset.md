## Database Setup and Sample Data


Table Name | Description |
|--|--|
| 1. **Users** | Contains details about users including their names, status, and timestamps. |
| 2. **Batches** | Holds information about different batches including their names, status, and timestamps. |
| 3. **Student Batch Maps** | Maps students to batches indicating their status and timestamps. |
| 4. **Instructor Batch Maps** | Maps instructors to batches indicating their status and timestamps. |
| 5. **Sessions** | Records details of sessions conducted, including the instructor, batch, and timings. |
| 6. **Attendances** | Tracks student attendance and ratings for each session. |
| 7. **Tests** | Contains information about tests, including the batch, subject, and date. |
| 8. **Test Scores** | Records the marks obtained by students in different tests. |

---

### 1. Users Table

```sql
CREATE SEQUENCE users_id_seq;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL ('users_id_seq'),
  name VARCHAR(50) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO users (id, name, active, created_at, updated_at) VALUES 
(1, 'Rohit', true, CURRENT_DATE-5, CURRENT_DATE-4),
(2, 'James', true, CURRENT_DATE-5, CURRENT_DATE-4),
(3, 'David', true, CURRENT_DATE-5, CURRENT_DATE-4),
(4, 'Steven', true, CURRENT_DATE-5, CURRENT_DATE-4),
(5, 'Ali', true, CURRENT_DATE-5, CURRENT_DATE-4),
(6, 'Rahul', true, CURRENT_DATE-5, CURRENT_DATE-4),
(7, 'Jacob', true, CURRENT_DATE-5, CURRENT_DATE-4),
(8, 'Maryam', true, CURRENT_DATE-5, CURRENT_DATE-4),
(9, 'Shwetha', false, CURRENT_DATE-5, CURRENT_DATE-4),
(10, 'Sarah', true, CURRENT_DATE-5, CURRENT_DATE-4),
(11, 'Alex', true, CURRENT_DATE-5, CURRENT_DATE-4),
(12, 'Charles', false, CURRENT_DATE-5, CURRENT_DATE-4),
(13, 'Perry', true, CURRENT_DATE-5, CURRENT_DATE-4),
(14, 'Emma', true, CURRENT_DATE-5, CURRENT_DATE-4),
(15, 'Sophia', true, CURRENT_DATE-5, CURRENT_DATE-4),
(16, 'Lucas', true, CURRENT_DATE-5, CURRENT_DATE-4),
(17, 'Benjamin', true, CURRENT_DATE-5, CURRENT_DATE-4),
(18, 'Hazel', false, CURRENT_DATE-5, CURRENT_DATE-4);
```

---

### 2. Batches Table

```sql
CREATE SEQUENCE batch_id_seq;
CREATE TABLE batches (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('batch_id_seq'),
  name VARCHAR(100) UNIQUE NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO batches (id, name, active, created_at, updated_at) VALUES 
(1, 'Statistics', true, CURRENT_DATE-10, CURRENT_DATE-6),
(2, 'Mathematics', true, CURRENT_DATE-10, CURRENT_DATE-6),
(3, 'Physics', false, CURRENT_DATE-10, CURRENT_DATE-6);
```

---

### 3. Student Batch Maps Table

```sql
CREATE SEQUENCE student_batch_maps_id_seq;
CREATE TABLE student_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('student_batch_maps_id_seq'),
  user_id INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  deactivated_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO student_batch_maps (id, user_id, batch_id, active, deactivated_at, created_at, updated_at) VALUES 
(1, 1, 1, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(2, 2, 1, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(3, 3, 1, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(4, 4, 1, false, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(5, 5, 2, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(6, 6, 2, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(7, 7, 2, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(8, 8, 2, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(9, 9, 2, false, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(10, 10, 3, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(11, 11, 3, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(12, 12, 3, false, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(13, 13, 3, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(14, 14, 3, true, CURRENT_TIMESTAMP, CURRENT_DATE-5, CURRENT_DATE-4),
(15, 4, 2, true, CURRENT_TIMESTAMP, CURRENT_DATE-4, CURRENT_DATE-3),
(16, 9, 3, false, CURRENT_TIMESTAMP, CURRENT_DATE-3, CURRENT_DATE-2),
(17, 9, 1, true, CURRENT_TIMESTAMP, CURRENT_DATE-2, CURRENT_DATE-1),
(18, 12, 1, true, CURRENT_TIMESTAMP, CURRENT_DATE-4, CURRENT_DATE-3);
```

---

### 4. Instructor Batch Maps Table

```sql
CREATE SEQUENCE instructor_batch_maps_id_seq;
CREATE TABLE instructor_batch_maps (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('instructor_batch_maps_id_seq'),
  user_id INTEGER REFERENCES users(id),
  batch_id INTEGER REFERENCES batches(id),
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO instructor_batch_maps (id, user_id, batch_id, active, created_at, updated_at) VALUES 
(1, 15, 1, true, CURRENT_DATE-5, CURRENT_DATE-4),
(2, 16, 2, true, CURRENT_DATE-5, CURRENT_DATE-4),
(3, 17, 3, true, CURRENT_DATE-5, CURRENT_DATE-4),
(4, 18, 2, true, CURRENT_DATE-5, CURRENT_DATE-4);
```

---

### 5. Sessions Table

```sql
CREATE SEQUENCE sessions_id_seq;
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('sessions_id_seq'),
  conducted_by INTEGER NOT NULL REFERENCES users(id),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO sessions (id, conducted_by, batch_id, start_time, end_time, created_at, updated_at) VALUES 
(1, 15, 1, (CURRENT_TIMESTAMP - INTERVAL '240 MINUTE'), (CURRENT_TIMESTAMP - INTERVAL '180 MINUTE'), CURRENT_DATE, CURRENT_DATE),
(2, 16, 2, (CURRENT_TIMESTAMP - INTERVAL '240 MINUTE'), (CURRENT_TIMESTAMP - INTERVAL '180 MINUTE'), CURRENT_DATE, CURRENT_DATE),
(3, 17, 3, (CURRENT_TIMESTAMP - INTERVAL '240 MINUTE'), (CURRENT_TIMESTAMP - INTERVAL '180 MINUTE'), CURRENT_DATE, CURRENT_DATE),
(4, 15, 1, (CURRENT_TIMESTAMP - INTERVAL '180 MINUTE'), (CURRENT_TIMESTAMP - INTERVAL '120 MINUTE'), CURRENT_DATE, CURRENT_DATE),
(5, 16, 2, (CURRENT_TIMESTAMP - INTERVAL '180 MINUTE'), (CURRENT_TIMESTAMP - INTERVAL '120 MINUTE'), CURRENT_DATE, CURRENT_DATE),
(6, 18, 2, (CURRENT_TIMESTAMP - INTERVAL '120 MINUTE'), (CURRENT_TIMESTAMP - INTERVAL '60 MINUTE'), CURRENT_DATE, CURRENT_DATE);
```

---

### 6. Attendances Table

```sql
CREATE TABLE attendances (
  student_id INTEGER NOT NULL REFERENCES users(id),
  session_id INTEGER NOT NULL REFERENCES sessions(id),
  rating DOUBLE PRECISION NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, session_id)
);
```

```sql
INSERT INTO attendances (student_id, session_id, rating, created_at, updated_at) VALUES 
(1, 1, 8.5, CURRENT_DATE, CURRENT_DATE),
(2, 1, 7.5, CURRENT_DATE, CURRENT_DATE),
(3, 1, 6.0, CURRENT_DATE, CURRENT_DATE),
(5, 2, 8.5, CURRENT_DATE, CURRENT_DATE),
(6, 2, 7.5, CURRENT_DATE, CURRENT_DATE),
(7, 2, 6.0, CURRENT_DATE, CURRENT_DATE),
(8, 2, 6.0, CURRENT_DATE, CURRENT_DATE),
(10, 3, 9.5, CURRENT

_DATE, CURRENT_DATE),
(11, 3, 6.0, CURRENT_DATE, CURRENT_DATE),
(13, 3, 6.5, CURRENT_DATE, CURRENT_DATE),
(14, 3, 7.5, CURRENT_DATE, CURRENT_DATE),
(1, 4, 8.5, CURRENT_DATE, CURRENT_DATE),
(2, 4, 7.5, CURRENT_DATE, CURRENT_DATE),
(3, 4, 6.0, CURRENT_DATE, CURRENT_DATE),
(5, 5, 8.5, CURRENT_DATE, CURRENT_DATE),
(6, 5, 7.5, CURRENT_DATE, CURRENT_DATE),
(7, 5, 6.0, CURRENT_DATE, CURRENT_DATE),
(8, 5, 6.0, CURRENT_DATE, CURRENT_DATE),
(5, 6, 8.5, CURRENT_DATE, CURRENT_DATE),
(6, 6, 7.5, CURRENT_DATE, CURRENT_DATE),
(7, 6, 6.0, CURRENT_DATE, CURRENT_DATE);
```

### 7. Tests Table

```sql
CREATE SEQUENCE tests_id_seq;
CREATE TABLE tests (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT NEXTVAL('tests_id_seq'),
  batch_id INTEGER NOT NULL REFERENCES batches(id),
  subject VARCHAR(50) NOT NULL,
  total_marks DOUBLE PRECISION NOT NULL,
  test_date TIMESTAMP NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
INSERT INTO tests (id, batch_id, subject, total_marks, test_date, active, created_at, updated_at) VALUES 
(1, 1, 'Maths', 100.00, CURRENT_DATE-10, true, CURRENT_DATE, CURRENT_DATE),
(2, 1, 'Statistics', 100.00, CURRENT_DATE-5, true, CURRENT_DATE, CURRENT_DATE),
(3, 2, 'Physics', 100.00, CURRENT_DATE-7, true, CURRENT_DATE, CURRENT_DATE),
(4, 3, 'Chemistry', 100.00, CURRENT_DATE-8, true, CURRENT_DATE, CURRENT_DATE);
```

---

### 8. Test Scores Table

```sql
CREATE TABLE test_scores (
  student_id INTEGER NOT NULL REFERENCES users(id),
  test_id INTEGER NOT NULL REFERENCES tests(id),
  marks_obtained DOUBLE PRECISION NOT NULL,
  PRIMARY KEY (student_id, test_id)
);
```

```sql
INSERT INTO test_scores (student_id, test_id, marks_obtained) VALUES 
(1, 1, 60.00),
(2, 1, 70.00),
(3, 1, 80.00),
(4, 1, 90.00),
(1, 2, 60.00),
(2, 2, 70.00),
(3, 2, 80.00),
(4, 2, 90.00),
(5, 3, 75.00),
(6, 3, 65.00),
(7, 3, 70.00),
(8, 3, 80.00),
(9, 4, 75.00),
(10, 4, 65.00),
(11, 4, 70.00),
(12, 4, 80.00);
```

