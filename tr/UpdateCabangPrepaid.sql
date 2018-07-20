-- Update cabang prepaid dari data cabang

--UPDATE PP_Prepaid
--set BranchCodePrepaid = s.[KODE REP]
SELECT p.PrepaidNumber, p.BranchCodePrepaid,s.[KODE REP]
from PP_Prepaid p
inner join (
select *
from DataCabang20170829 
where [NO PREPAID] not in (
							SELECT c.[NO PREPAID]
							from DataCabang20170829 c
							inner join vPP_BranchRepAll v
							on c.[KODE REP] = v.BRANCH_CODE_REP
							inner join vPP_BranchRepAll vv
							on c.CABANG = vv.BRANCH_CODE_REP
							where vv.BRANCH_CODE <> v.BRANCH_CODE
							or c.[NO PREPAID] = 16000266
)
) s
on p.PrepaidNumber = s.[NO PREPAID]


-- Update cabang prepaid dari data cabang yg beda cabang utama (kec :16000142 , 16000266 , 17000271)

--UPDATE PP_Prepaid
--set BranchCodePrepaid = vv.BRANCH_CODE_REP 
SELECT c.[NO PREPAID],
		c.CABANG,
		vv.BRANCH_CODE_REP 
from DataCabang20170829 c
inner join vPP_BranchRepAll v
on c.[KODE REP] = v.BRANCH_CODE_REP
inner join vPP_BranchRepAll vv
on c.CABANG = vv.BRANCH_CODE_REP
where vv.BRANCH_CODE <> v.BRANCH_CODE
and c.[NO PREPAID] not in (16000142,17000271)


--SELECT c.[NO PREPAID],
--		c.CABANG,
--		vv.BRANCH_CODE as 'Cbg Utama -> Cabang',
--		c.[KODE REP] ,
--		v.BRANCH_CODE as 'Cbg Utama -> Rep'
--from DataCabang20170829 c
--inner join vPP_BranchRepAll v
--on c.[KODE REP] = v.BRANCH_CODE_REP
--inner join vPP_BranchRepAll vv
--on c.CABANG = vv.BRANCH_CODE_REP
--where vv.BRANCH_CODE <> v.BRANCH_CODE
--or c.[NO PREPAID] = 16000266

