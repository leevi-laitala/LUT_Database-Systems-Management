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

-- Trigger after inserting a new project
-- TO BE ADDED

-- Trigger before updating the employee contract type
CREATE OR REPLACE FUNCTION function_contract()
RETURNS TRIGGER
AS $$
BEGIN 
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
-- TO BE ADDED