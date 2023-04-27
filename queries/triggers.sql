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
-- TO BE ADDED
-- Trigger after insert on employee
-- TO BE ADDED