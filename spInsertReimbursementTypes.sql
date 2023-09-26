CREATE PROCEDURE spInsertReimbursementTypes
AS
BEGIN
   INSERT INTO ReimbursementTypes([Name],[Description],Code,ModifiedBy,CreatedBy,IsActive,DateCreated,DateModified)
   VALUES
   ('Travel Expenses',
   'This type of reimbursement covers expenses incurred while traveling for business purposes. It can include costs such as airfare, lodging, meals, rental cars, and mileage. Travel expense reimbursement may be based on actual expenses with receipts or per diem rates.',
   'TER', 'system','system',1, GETDATE(),NULL),
    ('Meal Expenses',
   'Employees or stakeholders may be reimbursed for the cost of meals incurred during business trips or meetings with clients. This can be based on actual expenses or per diem rates',
   'MER', 'system','system',1, GETDATE(),NULL),
      ('Mileage',
   'When employees use their personal vehicles for business-related travel, they can be reimbursed for mileage. The reimbursement rate per mile is usually determined by the company or based on government-set mileage rates.',
   'MLR', 'system','system',1, GETDATE(),NULL),
      ('Travel Expenses Reimbursement',
   'This type of reimbursement covers expenses incurred while traveling for business purposes. It can include costs such as airfare, lodging, meals, rental cars, and mileage. Travel expense reimbursement may be based on actual expenses with receipts or per diem rates.',
   'TER', 'system','system',1, GETDATE(),NULL),
      ('Entertainment Expenses',
   'Businesses often reimburse employees for expenses related to entertaining clients or prospects. This can include expenses for meals, tickets to events, or other entertainment costs.',
   'EER', 'system','system',1, GETDATE(),NULL),
         ('Office Supplies and Equipment',
   'Employees who purchase office supplies, equipment, or software for their work may be reimbursed for these expenses. The reimbursement may be based on actual expenses with receipts.',
   'OSR', 'system','system',1, GETDATE(),NULL),
     ('Professional Development and Training',
   'Companies often support employee professional development by reimbursing expenses related to courses, seminars, conferences, or certifications.',
   'PDR', 'system','system',1, GETDATE(),NULL),
     ('Medical Expenses',
   'Some businesses offer health-related expense reimbursement, such as for medical appointments, health club memberships, or wellness programs.',
   'MDR', 'system','system',1, GETDATE(),NULL),
     ('Miscellaneous',
   'This category can cover a wide range of other business-related expenses, from parking fees to tolls, to expenses related to client gifts and marketing materials.',
   'MR', 'system','system',1, GETDATE(),NULL),
     ('Other Reimbursement',
   'Any',
   'OR', 'system','system',1, GETDATE(),NULL)
END;

