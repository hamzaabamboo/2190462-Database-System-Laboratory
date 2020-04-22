select * from INVOICE i
	inner join CUSTOMER c on c.cusID = i.cusID
    inner join EMPLOYEE e on e.empID = i.empID;

select it.invoiceID, count(it.itemNO) from INVOICE_ITEM it
	inner join INVOICE i on i.invoiceID = it.invoiceID
    group by it.invoiceID;
    
select * , it.salePrice / p.cost - 1as discount from INVOICE_ITEM it
	inner join INVOICE i on i.invoiceID = it.invoiceID
    inner join PRODUCT p on p.pID = it.pID;
    
select * from SYSTEM_LOG;
    