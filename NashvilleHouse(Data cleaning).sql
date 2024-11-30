-- data cleaning on SQL


select *
from ProtfolioProject.dbo.Nashville_Housing

-- Standardize Data Format from datetime to Date

alter table Nashville_Housing
ADD SalesDateCoverted Date;

update Nashville_Housing
Set SalesDateCoverted = CONVERT(date,SaleDate)

select SalesDateCoverted 
from ProtfolioProject.dbo.Nashville_Housing





--populate property address date (dealing with nulls in property address)


select *
from Nashville_Housing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing as a
  join Nashville_Housing as b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  update a
  set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  from Nashville_Housing as a
  join Nashville_Housing as b
     on a.ParcelID=b.ParcelID
     and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

select PropertyAddress
from Nashville_Housing


-- breaking address into individual columns (Address,city,state)



select PropertyAddress
from Nashville_Housing
--where PropertyAddress is null 
--order by ParcelID

select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address ,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as City 
from Nashville_Housing



--edit to data new columns



alter table Nashville_Housing
ADD propertySplitAddress Nvarchar(255);

update Nashville_Housing
Set propertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


alter table Nashville_Housing
ADD propertySplitCity Nvarchar(255);

update Nashville_Housing
Set propertySplitCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))







select
parsename(replace (OwnerAddress,',','.') ,3)
,parsename(replace (OwnerAddress,',','.') ,2)
,parsename(replace (OwnerAddress,',','.') ,1)
from Nashville_Housing



alter table Nashville_Housing
ADD OwnerSplitAddress Nvarchar(255);

update Nashville_Housing
Set OwnerSplitAddress = parsename(replace (OwnerAddress,',','.') ,3)


alter table Nashville_Housing
ADD OwnerSplitCity Nvarchar(255);

update Nashville_Housing
Set OwnerSplitCity = parsename(replace (OwnerAddress,',','.') ,2)

alter table Nashville_Housing
ADD OwnerSplitState Nvarchar(255);

update Nashville_Housing
Set OwnerSplitState = parsename(replace (OwnerAddress,',','.') ,1)




-- change N and Y to Yes and No  'SoldAsVacant' column


select distinct( SoldAsVacant), count(SoldAsVacant)
from Nashville_Housing
group by SoldAsVacant
order by 2 desc

select SoldAsVacant,
case when soldAsVacant = 'Y' then 'Yes'
     when  soldAsVacant = 'N' then 'No'
	 else soldAsVacant
end
from Nashville_Housing

update Nashville_Housing 
set SoldAsVacant =case when soldAsVacant = 'Y' then 'Yes'
     when  soldAsVacant = 'N' then 'No'
	 else soldAsVacant
end


-- remove duplicates 


with RowNumCTE as(
select *,
          ROW_NUMBER() over(
		  partition by parcelID,
		               PropertyAddress,
					   salePrice,
					   SaleDate,
					   LegalReference
					   order by UniqueID) Row_Num
from Nashville_Housing
--order by ParcelID
)
select * 
from RowNumCTE
where Row_Num > 1
--order by PropertyAddress


--delete unused columns

select*
from Nashville_Housing

alter table Nashville_Housing
drop column OwnerAddress, TaxDistrict,propertyAddress

alter table Nashville_Housing
drop column SaleDate
