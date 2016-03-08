USE SAINI_ATINDERPAL_TEST;

/* Creating Tables */

CREATE TABLE Country(
	Country_ID varchar(20) NOT NULL PRIMARY KEY,
	Country_Name varchar (30) NOT NULL
);

CREATE TABLE State(
	State_ID varchar(20) NOT NULL PRIMARY KEY,
	State_Name varchar (30) NOT NULL,
);

CREATE TABLE City(
	City_ID varchar(20) NOT NULL PRIMARY KEY,
	City_Name varchar (30) NOT NULL,
);

CREATE TABLE Architect(
	Arch_ID varchar(20) NOT NULL PRIMARY KEY,
	Arch_FName varchar(20) NOT NULL,
	Arch_LName varchar(20) NOT NULL,
	Arch_Bdate DATE,
	Arch_Add varchar(40),
	City_ID varchar(20) REFERENCES City(City_ID),
	State_ID varchar(20) REFERENCES State(State_ID),
	Country_ID varchar(20) REFERENCES Country(Country_ID)
);

CREATE TABLE ArchitectureStyle(
	Architectural_Style_Code varchar(20) NOT NULL PRIMARY KEY,
	Architectural_Style_Type varchar(40) NOT NULL,
	Architectural_Style_Desc varchar(100) NOT NULL
);

CREATE TABLE Zone(
	Zone_Code int NOT NULL CONSTRAINT CHK_Zone_Code_Range1To4
	CHECK (Zone_Code BETWEEN 1 AND 4) PRIMARY KEY,
	Zone_Type varchar(40) NOT NULL,
	Zone_Desc varchar(100) NOT NULL
);

CREATE TABLE Condition(
	Condition_Code int NOT NULL PRIMARY KEY,
	Condition_Type varchar(40) NOT NULL,
	Condition_Desc varchar(100) NOT NULL
);

CREATE TABLE BuildingOwner(
	Owner_ID varchar(20) NOT NULL PRIMARY KEY,
	Owner_FName varchar(20) NOT NULL,
	Owner_LName varchar(20) NOT NULL,
	Owner_FullName AS Owner_FName + ' ' + Owner_LName ,
	Owner_Address varchar(40),
	Owner_Contact int,
	City_ID varchar(20) REFERENCES City(City_ID),
	State_ID varchar(20) REFERENCES State(State_ID),
	Country_ID varchar(20) REFERENCES Country(Country_ID),
);

CREATE TABLE Building(
	Building_ID varchar(20) NOT NULL PRIMARY KEY,
	Building_Name varchar (30),
	Arch_ID varchar(20) NOT NULL REFERENCES Architect(Arch_ID),
	Architectural_Style_ID varchar(20) NOT NULL REFERENCES ArchitectureStyle(Architectural_Style_Code),
	Building_Address varchar(40) NOT NULL,
	Const_Date DATE,
	Zone_Code int NOT NULL REFERENCES Zone(Zone_Code),
	Condition_Code int NOT NULL REFERENCES Condition(Condition_Code),
	City_ID varchar(20) REFERENCES City(City_ID),
	State_ID varchar(20) REFERENCES State(State_ID),
	Country_ID varchar(20) REFERENCES Country(Country_ID),
);

CREATE TABLE BuildingOwnerHistory(
	Building_ID varchar(20) NOT NULL REFERENCES Building(Building_ID),
	Owner_ID varchar(20) NOT NULL REFERENCES BuildingOwner(Owner_ID),
	CONSTRAINT PKBuildingOwnerHistory PRIMARY KEY CLUSTERED
	(Building_ID, Owner_ID),
	Owner_Start_Date DATE NOT NULL,
	Owner_End_Date DATE,
	Owner_Status varchar(20),
	Owner_Sale_Price int,
	Owner_Purchase_Price int,
);

/* Creating Views */

CREATE VIEW Building_Ownership_Status AS
	SELECT
		b.Building_Name as 'Building Name',
		o.Owner_FName as 'Owner First Name',
		h.Owner_Start_Date as 'Date of Ownership',
		h.Owner_End_Date as 'Date of Sale',
		h.Owner_Sale_Price as 'Selling Price',
		H.Owner_Status AS 'Owner Status'
	FROM Building b, BuildingOwnerHistory h, BuildingOwner o
	WHERE b.Building_ID = h.Building_ID AND
		  o.Owner_ID = h.Owner_ID;


CREATE VIEW Fit_Commercial_Buildings AS
	SELECT	
		b.Building_Name as 'Building Name',
		z.Zone_Type as 'Zone Type',
		c.Condition_Type as 'Building Condition'
	FROM Building b, Zone z, Condition c
	WHERE b.Zone_Code = z.Zone_Code AND
		  b.Condition_Code = c.Condition_Code;


/* Inserting Data into Tables */

INSERT INTO Country VALUES ('country_1', 'USA');
INSERT INTO Country VALUES ('country_2', 'India');
INSERT INTO Country VALUES ('country_3', 'Canada');
INSERT INTO Country VALUES ('country_4', 'UK');
INSERT INTO Country VALUES ('country_5', 'Australia');
INSERT INTO Country VALUES ('country_6', 'UAE');
INSERT INTO Country VALUES ('country_7', 'China');
INSERT INTO Country VALUES ('country_8', 'France');
INSERT INTO Country VALUES ('country_9', 'South Africa');
INSERT INTO Country VALUES ('country_10', 'Germany');

INSERT INTO State VALUES ('state_1', 'Washington');
INSERT INTO State VALUES ('state_2', 'California');
INSERT INTO State VALUES ('state_3', 'Texas');
INSERT INTO State VALUES ('state_4', 'New York');
INSERT INTO State VALUES ('state_5', 'Oregon');
INSERT INTO State VALUES ('state_6', 'Maharashtra');
INSERT INTO State VALUES ('state_7', 'Gujarat');
INSERT INTO State VALUES ('state_8', 'British Columbia');
INSERT INTO State VALUES ('state_9', 'New South Wales');
INSERT INTO State VALUES ('state_10', 'Illinois');

INSERT INTO City VALUES ('city_1', 'Seattle');
INSERT INTO City VALUES ('city_2', 'San Francisco');
INSERT INTO City VALUES ('city_3', 'Chicago');
INSERT INTO City VALUES ('city_4', 'Austin');
INSERT INTO City VALUES ('city_5', 'Bellevue');
INSERT INTO City VALUES ('city_6', 'Mumbai');
INSERT INTO City VALUES ('city_7', 'Pune');
INSERT INTO City VALUES ('city_8', 'New York City');
INSERT INTO City VALUES ('city_9', 'Sydney');
INSERT INTO City VALUES ('city_10', 'Vancouver');

INSERT INTO Architect VALUES ('a1', 'Jr. George', 'Washington', '19850205', 'Downtown', 'city_1', 'state_1', 'country_1');
INSERT INTO Architect VALUES ('a2', 'Fazlur', 'Khan', '19850205', 'Downtown', 'city_3', 'state_10', 'country_1');
INSERT INTO Architect VALUES ('a3', 'Salman', 'Khan', '18570107', 'Uptown', 'city_2', 'state_5', 'country_1');
INSERT INTO Architect VALUES ('a4', 'SR', 'Khan', '19050706', 'South Downtown', 'city_3', 'state_3', 'country_1');
INSERT INTO Architect VALUES ('a5', 'Atnerio', 'Khan', '19250502', 'North Downtown', 'city_6', 'state_6', 'country_2');
INSERT INTO Architect VALUES ('b1', 'Graham', 'Bell', '19800505', 'East Downtown', 'city_1', 'state_1', 'country_1');
INSERT INTO Architect VALUES ('b2', 'Rocky', 'S', '19810105', 'West Downtown', 'city_6', 'state_6', 'country_2');
INSERT INTO Architect VALUES ('b3', 'Brothe', 'R', '19501002', 'South Downtown', 'city_6', 'state_6', 'country_2');
INSERT INTO Architect VALUES ('c1', 'Super', 'T', '19100101', 'North Downtown', 'city_6', 'state_6', 'country_2');
INSERT INTO Architect VALUES ('d1', 'Bat', 'Z', '19150202', 'Downtown', 'city_1', 'state_1', 'country_1');

INSERT INTO ArchitectureStyle VALUES ('a_1', 'Archaic', 'Very old architecture style');
INSERT INTO ArchitectureStyle VALUES ('a_2', 'UnArchaic', 'Not very old architecture style');
INSERT INTO ArchitectureStyle VALUES ('c_1', 'Cointemporary', 'Contemporary architecture style');
INSERT INTO ArchitectureStyle VALUES ('m_1', 'Modern', 'Modern architecture style');
INSERT INTO ArchitectureStyle VALUES ('x_1', 'New Age', 'The X age architecture style');

INSERT INTO Zone VALUES ('1', 'Residential', 'This is a residential Zone');
INSERT INTO Zone VALUES ('2', 'Commercial', 'This is a commercial Zone');
INSERT INTO Zone VALUES ('3', 'Industrial', 'This is an industrial Zone');
INSERT INTO Zone VALUES ('4', 'Special', 'This is a special Zone');

INSERT INTO Condition VALUES ('1', 'New', 'Building Condition is New');
INSERT INTO Condition VALUES ('2', 'Old', 'Building Condition is Old');
INSERT INTO Condition VALUES ('3', 'Old Unused', 'Building Condition is Old Unused');
INSERT INTO Condition VALUES ('4', 'Demolished', 'Building Condition is Demolished');
INSERT INTO Condition VALUES ('5', 'Restoration', 'Building Condition is being Restored');
INSERT INTO Condition VALUES ('6', 'Abandoned', 'Building Condition is Abandoned');
INSERT INTO Condition VALUES ('7', 'New Unused', 'Building Condition is New Unused');
INSERT INTO Condition VALUES ('8', 'Under Construction', 'Building is Under Construction');

INSERT INTO BuildingOwner VALUES ('a1', 'Atinderpal', 'Saini', 'University', '1234567890', 'city_1', 'state_1', 'country_1');
INSERT INTO BuildingOwner VALUES ('a2', 'Monish', 'P', 'University District', '2132456789', 'city_1', 'state_1', 'country_1');
INSERT INTO BuildingOwner VALUES ('a3', 'Atnerio', 'S', 'Downtown', '1231231233', 'city_1', 'state_1', 'country_1');
INSERT INTO BuildingOwner VALUES ('b1', 'Rahul', 'Roy', 'Northgate', '123132131', 'city_1', 'state_1', 'country_1');
INSERT INTO BuildingOwner VALUES ('b2', 'Aditya', 'P', 'Downtown', '1325465123', 'city_3', 'state_10', 'country_1');
INSERT INTO BuildingOwner VALUES ('b3', 'Bheem', 'C', 'SFO City Area', '456456456', 'city_2', 'state_2', 'country_1');
INSERT INTO BuildingOwner VALUES ('c1', 'Atinder', 'Z', 'North east', '789456132', 'city_6', 'state_6', 'country_2');
INSERT INTO BuildingOwner VALUES ('c2', 'Yukti', 'D', 'University Arena', '111111111', 'city_6', 'state_6', 'country_2');
INSERT INTO BuildingOwner VALUES ('d1', 'Kshitij', 'D', 'University District', '222222222', 'city_7', 'state_6', 'country_2');
INSERT INTO BuildingOwner VALUES ('d2', 'Atneriolinzo', 'Saini', 'University District', '333333333', 'city_6', 'state_6', 'country_2');

INSERT INTO Building VALUES ('bld_1', 'Paccar Hall', 'a1', 'a_1', 'University of Washington campus', '19850205', '1', '6', 'city_1', 'state_1', 'country_1');
INSERT INTO Building VALUES ('bld_2', 'Sieg Hall', 'a2', 'a_1', 'University of Washington campus', '20050205', '1', '8', 'city_1', 'state_1', 'country_1');
INSERT INTO Building VALUES ('bld_3', 'Ode Hall', 'a3', 'a_1', 'University of Washington campus', '18870107', '1', '1', 'city_1', 'state_1', 'country_1');
INSERT INTO Building VALUES ('bld_4', 'MG Hall', 'a1', 'c_1', 'University of Mumbai campus', '20050205', '1', '1', 'city_6', 'state_6', 'country_2');
INSERT INTO Building VALUES ('bld_5', 'WG Hall', 'a1', 'c_1', 'University of Washington campus', '20050205', '1', '1', 'city_1', 'state_1', 'country_1');
INSERT INTO Building VALUES ('bld_6', 'AS Hall', 'b1', 'c_1', 'University of SF campus', '20000505', '1', '2', 'city_2', 'state_2', 'country_1');
INSERT INTO Building VALUES ('bld_7', 'SAS Hall', 'b2', 'x_1', 'University of Mumbai campus', '20010505', '1', '7', 'city_6', 'state_6', 'country_2');
INSERT INTO Building VALUES ('bld_8', 'S Chowk', 'c1', 'a_1', 'University of Washington campus', '19400101', '1', '2', 'city_1', 'state_1', 'country_1');
INSERT INTO Building VALUES ('bld_9', 'London Tower', 'd1', 'x_1', 'University of SF campus', '19450202', '1', '1', 'city_2', 'state_2', 'country_1');
INSERT INTO Building VALUES ('bld_10', 'Golden Gate Tower', 'c1', 'c_1', 'University of SF campus', '19600101', '1', '3', 'city_2', 'state_2', 'country_1');

INSERT INTO BuildingOwnerHistory VALUES ('bld_1', 'a1', '19850205', '', 'Current Owner', '', '100000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_2', 'a2', '20050205', '20050305', 'Old Owner', '650000', '500000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_2', 'a1', '20050305', '20050405', 'Old Owner', '700000', '650000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_2', 'a3', '20050405', '', 'Current Owner', '', '700000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_3', 'b1', '18870107', '', 'Current Owner', '', '1000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_4', 'b2', '20050205', '', 'Current Owner', '', '100000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_5', 'b3', '20050205', '', 'Current Owner', '', '180000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_6', 'a1', '20000505', '20001005', 'Old Owner', '10000', '10000000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_6', 'a1', '20001005', '20020106', 'Old Owner', '10000000', '100000000' );
INSERT INTO BuildingOwnerHistory VALUES ('bld_6', 'a1', '20020707', '', 'Current Owner', '', '100000000' );


/* Exploring the views */

SELECT * FROM Building_Ownership_Status;

SELECT * FROM Fit_Commercial_Buildings;