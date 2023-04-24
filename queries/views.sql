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

-- View for listing projects and their roles as well as customer
CREATE OR REPLACE VIEW view_project_info AS
SELECT customer.c_name AS Customer_name,
    project.p_id AS Project_ID, 
    project.project_name AS Project_name, 
    project.budget AS Project_budget,
    project.p_start_date AS Project_start_date,
    project.p_end_date AS Project_end_date
FROM project
INNER JOIN customer ON project.c_id = customer.c_id
ORDER BY project.p_id;
SELECT * FROM view_project_info;

-- View for listing an employees contract info and job title
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

-- View for employees basic info
CREATE OR REPLACE VIEW view_emp_info AS
SELECT employee.e_id AS id,
    employee.emp_name AS Employee_name,
    employee.email AS email,
    job_title.title AS title,
    project.project_name AS project,
    department.dep_name AS department_name
FROM employee
INNER JOIN job_title ON employee.j_id = job_title.j_id
INNER JOIN project_role ON employee.e_id = project_role.e_id
INNER JOIN project ON project_role.p_id = project.p_id
INNER JOIN department ON employee.d_id = department.d_id
ORDER BY employee.e_id;
SELECT * FROM view_emp_info; 
    
