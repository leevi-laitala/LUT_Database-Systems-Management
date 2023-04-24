-- View for listing employees and their skills
CREATE OR REPLACE VIEW view_emp_skill AS
SELECT employee.e_id AS Employee_ID, 
    employee.emp_name AS Employee_name, 
    employee_skills.s_id AS Employee_Skill_ID, 
    skills.skill AS Employee_Skill
FROM employee
INNER JOIN employee_skills ON employee.e_id = employee_skills.e_id
INNER JOIN skills ON employee_skills.s_id = skills.s_id;
SELECT * FROM view_emp_skill;

-- View for listing projects and their roles
CREATE OR REPLACE VIEW view_project_role AS
SELECT project.p_id AS Project_ID, 
    project.project_name AS Project_name, 
    project_role.prole_start_date AS Project_start_date
FROM project
INNER JOIN project_role ON project.p_id = project_role.p_id
ORDER BY project.p_id;
SELECT * FROM view_project_role;

-- View for listing an employees contract info, its job title
CREATE OR REPLACE VIEW view_job_info AS
SELECT employee.emp_name, 
    employee.contract_start AS Employee_contract_start,
    employee.contract_end AS Employee_contract_end,
    job_title.title AS job_title
FROM employee
INNER JOIN job_title ON employee.j_id = job_title.j_id
ORDER BY employee.emp_name;
SELECT * FROM view_job_info;

-- View for listing headquarters and their geolocation
CREATE OR REPLACE VIEW view_hq_location AS
SELECT geo_location.l_id,
    headquarters.hq_name AS headquarters_name,
    geo_location.street,
    geo_location.city,
    geo_location.country
FROM headquarters
INNER JOIN geo_location ON headquarters.l_id = geo_location.l_id;
SELECT * FROM view_hq_location;

-- View for listing employee and their user group
CREATE OR REPLACE VIEW view_emp_usergroup AS 
SELECT employee.emp_name AS employee_name,
    employee.salary,
    user_group.group_title,
    user_group.group_rights
FROM employee
INNER JOIN employee_user_group ON employee.e_id = employee_user_group.e_id
INNER JOIN user_group ON employee_user_group.u_id = user_group.u_id
ORDER BY employee.emp_name;
SELECT * FROM view_emp_usergroup;
