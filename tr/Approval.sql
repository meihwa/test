SELECT t.NoDataApprovalTransaction, t.ApprovalNo, t.BranchCode, mt.NoDataEmployee as asli,e1.Name, l.NoDataEmployee as list, e2.Name
from APS_ApprovalTransaction t
--inner join APS_ApprovalTypeVersion v
--on t.NoDataApprovalTypeVersion = v.NoDataApprovalTypeVersion
inner JOIN APS_ApprovalGroup g
on g.NoDataApprovalTypeVersion = t.NoDataApprovalTypeVersion
INNER JOIN APS_MasterGroupDtl mt
ON g.NoDataApprovalGroupHdr = mt.NoDataApprovalGroup
AND mt.BranchCode = t.BranchCode
inner join APS_ApprovalList l
on l.NoDataApprovalTransaction = t.NoDataApprovalTransaction
and l.ApprovalLevel = 1
inner join APS_Employee e1
on e1.NoDataEmployee = mt.NoDataEmployee
inner join APS_Employee e2
on e2.NoDataEmployee = l.NoDataEmployee
where convert(varchar,t.SubmitDate,112) > '20170904' 
and t.ApprovalNo LIKE '%ptk%'
and t.Status in ('S')
and g.NoDataApprovalGroupHdr =2006
and mt.IsActive = 1
and l.NoDataEmployee <> mt.NoDataEmployee
order by t.BranchCode

select SubmitBy,convert(varchar,SubmitBy,112)
from APS_ApprovalTransaction
where NoDataApprovalTransaction = 2728


SELECT *
from APS_Employee
where NoDataEmployee = 3568
or nik = '20030191' 

SELECT *
from APS_ApprovalTransaction
where ApprovalNo = 'SPP/PTKAO/202/17003'

SELECT *
from APS_MasterGroupDTL


