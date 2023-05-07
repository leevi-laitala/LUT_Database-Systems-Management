-- Trigger before inserting a new skill
CREATE OR REPLACE FUNCTION function_skill()
RETURNS TRIGGER
AS $$
BEGIN
IF EXISTS (SELECT * FROM skills WHERE skill = NEW.skill) THEN
    RAISE EXCEPTION 'The skill % already exists', NEW.skill;
END IF; 
RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_skill
    BEFORE INSERT ON skills FOR EACH ROW
    EXECUTE FUNCTION function_skill();

-- Trigger before updating the employee contract type
CREATE OR REPLACE FUNCTION function_contract()
RETURNS TRIGGER
AS $$ BEGIN 
-- Ensuring that the contract start date is set to current date
NEW.contract_start = CURRENT_DATE; 

-- Ensuring that the end date is either 2yrs after the start in temporary contracts
-- and NULL otherwise
IF NEW.contract_type = 'Temporary' THEN
    NEW.contract_end = NEW.contract_start + INTERVAL '2 years';
ELSE
    NEW.contract_end = NULL;
END IF; 
RETURN NEW;
END; 
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE TRIGGER trigger_contract
    BEFORE UPDATE ON employee FOR EACH ROW
    WHEN (OLD.contract_type IS DISTINCT FROM NEW.contract_type)
    EXECUTE FUNCTION function_contract(); 


-- Trigger after insert on employee
CREATE OR REPLACE FUNCTION function_groups()
RETURNS TRIGGER
AS $$
BEGIN

-- If the new employee is HR secretary then the user group is also set to that
IF NEW.j_id = (SELECT j_id FROM job_title WHERE title = 'HR secretary') THEN
    INSERT INTO employee_user_group (e_id, u_id) VALUES (NEW.e_id, 6);

-- If the new employee is any of the admins (3) then their user group is the administration group
ELSIF NEW.j_id = (SELECT j_id FROM job_title WHERE title ='Database admin') THEN
    INSERT INTO employee_user_group (e_id, u_id) VALUES (NEW.e_id, 3);

ELSIF NEW.j_id = (SELECT j_id FROM job_title WHERE title = 'Data admin') THEN
    INSERT INTO employee_user_group (e_id, u_id) VALUES (NEW.e_id, 3);

ELSIF NEW.j_id = (SELECT j_id FROM job_title WHERE title = 'System admin') THEN
    INSERT INTO employee_user_group (e_id, u_id) VALUES (NEW.e_id, 3);

-- All the other employers get the employee user group 
ELSE
    INSERT INTO employee_user_group (e_id, u_id) VALUES (NEW.e_id, 9);
END IF;

RETURN NEW; 
END; 
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE TRIGGER trigger_groups
    AFTER INSERT ON employee FOR EACH ROW
    EXECUTE FUNCTION function_groups(); 

-- DROP FUNCTION projectWorkers CASCADE;

CREATE FUNCTION projectWorkers() RETURNS TRIGGER AS
$$
DECLARE
    customer_l_id INT;
    customer_c_id INT;
    customer_country VARCHAR;

    employee_hq INT;
    employee_dep INT;
BEGIN
    SELECT c_id INTO customer_c_id FROM Project WHERE c_id = NEW.c_id;
    SELECT l_id INTO customer_l_id FROM Customer WHERE c_id = customer_c_id;
    SELECT country INTO customer_country FROM Geo_location WHERE l_id = customer_l_id;

    WITH countries AS 
    (
        SELECT headquarters.h_id, 
            headquarters.hq_name, 
            headquarters.l_id, 
            geo_location.l_id, 
            geo_location.street, 
            geo_location.city, 
            geo_location.country, 
            geo_location.zip_code 
        FROM Headquarters 
        JOIN Geo_location ON headquarters.l_id = geo_location.l_id
    )

    SELECT h_id INTO employee_hq FROM Countries WHERE countries.country = customer_country;
    SELECT d_id INTO employee_dep FROM Department WHERE hid = employee_hq;
    
    INSERT INTO Project_role (e_id, p_id, prole_start_date)
    (
        SELECT e_id, NEW.p_id, NEW.p_start_date FROM employee 
            WHERE d_id = employee_dep AND 
            e_id NOT IN (
                SELECT e_id FROM Project_role 
            )
            LIMIT 3
    );
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_fetchThreeWorkersForProject
    AFTER INSERT ON Project 
    FOR EACH ROW
        EXECUTE PROCEDURE projectWorkers();

