create table SeatRow(
	sRow char(2) not null, ## Row throws errors, so using sRow

	primary key(sRow),

	check(sRow!='I')
);

create table SeatNum(
	sNum int not null, ## to keep consistency, added on a s

	primary key(sNum)
);

create table Seat(
	SeatsRow char(2) not null,
	SeatsNumber int not null,
	Section text not null,
	Side text not null,
	PricingTier text not null,
	Wheelchair bool,

	foreign key(SeatsRow) references SeatRow(sRow),
	foreign key(SeatsNumber) references SeatNum(sNum),

	check(Section='Balcony' or Section='Main Floor'),
	check(Side='Right' or Side='Middle' or Side='Left'),
	check(PricingTier='Upper Balcony' or PricingTier='Side' or PricingTier='Orchestra')
);

create table Customer(
	CustomerID int not null,
	FirstName text,
	LastName text,
	PaymentMethod text,

	primary key(CustomerID),
	
	check(PaymentMethod='Cash' or PaymentMethod='Credit Card')
);

create table Ticket(
	TicketNumber int not null auto_increment,
	CustomersID int not null,
	SeatsRow char(2) not null,
	SeatsNumber int not null,
	ShowTime timestamp,
	
    foreign key(CustomersID) references Customer(CustomerID),
    foreign key(SeatsNumber) references SeatNum(sNum),
    foreign key(SeatsRow) references SeatRow(sRow),
    primary key(TicketNumber)
);

DELIMITER $$
create trigger seatnum_before_delete
before delete
on SeatNum
for each row
begin
	delete from ticket where SeatsNum=OLD.sNum;
    delete from seat where SeatsNumber=OLD.sNum;
end;$$
DELIMITER ;

DELIMITER $$
create trigger seatrow_before_delete
before delete
on SeatRow
for each row
begin
	delete from Ticket where SeatsRow=OLD.sRow;
    delete from Seat where SeatsRow=OLD.sRow;
end;$$
DELIMITER ;

DELIMITER $$
create trigger customer_before_delete
before delete
on Customer
for each row
begin
	delete from Ticket where CustomersID=OLD.CustomerID;
end;$$
DELIMITER ;

DELIMITER $$
create trigger customer_after_update
after update
on Customer
for each row
begin
	if NEW.CustomerID != OLD.CustomerID then
		update Ticket set CustomersID=NEW.CustomerID where CustomersID=OLD.CustomerID;
    end if;
end;$$
DELIMITER ;

create table Ticket_Backup(
	TicketNumber int not null auto_increment,
	CustomersID int not null,
	SeatsRow char(2) not null,
	SeatsNumber int not null,
	ShowTime timestamp,
	
    foreign key(CustomersID) references Customer(CustomerID),
    foreign key(SeatsNumber) references SeatNum(sNum),
    foreign key(SeatsRow) references SeatRow(sRow),
    primary key(TicketNumber)
);

DELIMITER $$
create trigger ticket_after_insert
after insert
on Ticket
for each row
begin
	insert into Ticket_Backup values (NEW.TicketNumber, NEW.CustomersID, NEW.SeatsRow, NEW.SeatsNumber, NEW.ShowTime);
end;$$
DELIMITER ;