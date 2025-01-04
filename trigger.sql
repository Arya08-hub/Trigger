CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

INSERT INTO teachers (id, name, subject, experience, salary) VALUES
(1, 'Alice Johnson', 'Mathematics', 12, 75000.00),
(2, 'Raju', 'Physics', 8, 68000.00),
(3, 'Ramu', 'Chemistry', 15, 82000.00),
(4, 'David', 'Biology', 5, 56000.00),
(5, 'Thomas', 'History', 3, 48000.00),
(6, 'Emily', 'English', 10, 61000.00),
(7, 'Lewis', 'Geography', 7, 60000.00),
(8, 'Anu', 'Computer Science', 2, 50000.00);
CREATE TABLE teacher_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT,
    action VARCHAR(50),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW.id, 'INSERT', CURRENT_TIMESTAMP);
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete a teacher with experience greater than 10 years';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', CURRENT_TIMESTAMP);
END$$

DELIMITER ;