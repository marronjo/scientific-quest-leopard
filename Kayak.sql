CREATE DATABASE kayak;
SHOW DATABASES;
USE kayak;

CREATE TABLE members(
	memberId INT NOT NULL UNIQUE,
    memberName VARCHAR(100) NOT NULL,
    memberSid INT NOT NULL,
    memberIce INT NOT NULL,
    memberEmail VARCHAR(100) NOT NULL,
    PRIMARY KEY (memberId)
);

CREATE TABLE committee(
	memberId INT NOT NULL,
    memberName VARCHAR(100) NOT NULL,
    memberRole VARCHAR(100) NOT NULL,
    memberPermissions VARCHAR(100),
    memberVetting VARCHAR(100) NOT NULL,
    FOREIGN KEY(memberId) REFERENCES members(memberId),
    PRIMARY KEY (memberId)
);

CREATE TABLE qualifications(
	memberId INT NOT NULL,
    memberName VARCHAR(100) NOT NULL,
    qualLevel INT NOT NULL,
    qualName VARCHAR(100) NOT NULL,
    accredBody VARCHAR(100) NOT NULL,
    expiryDate DATE NOT NULL,
    FOREIGN KEY(memberId) REFERENCES members(memberId),
    PRIMARY KEY (memberId)
);

CREATE TABLE equipment(
	itemId INT NOT NULL,
    typeEquip VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    inspectDate DATE NOT NULL,
    testedBy INT NOT NULL,
    cost INT NOT NULL,
    FOREIGN KEY(testedBy) REFERENCES members(memberId),
    PRIMARY KEY (itemId)
);

CREATE TABLE locations(
	locationName VARCHAR(100) NOT NULL UNIQUE,
    capacity INT NOT NULL,
    cost INT NOT NULL,
    contactName VARCHAR(100) NOT NULL,
    contactPhone INT NOT NULL,
    PRIMARY KEY (locationName)
);

CREATE TABLE training(
	instructorMemId INT NOT NULL,
    trainingDate DATE NOT NULL,
    numParticipants INT NOT NULL,
    numInstructors INT NOT NULL,
    trainingTime INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    FOREIGN KEY(location) REFERENCES locations(locationName),
    FOREIGN KEY(instructorMemId) REFERENCES members(memberId),
    PRIMARY KEY (instructorMemId)
);

INSERT INTO 
	members(memberId, memberName, memberSid, memberIce, memberEmail)
VALUES 
(2, "Alice", 146372, 08712344, "al@tcd.ie"),
(56, "Alex", 65312, 079437845, "alex@tcd.ie"),
(74, "Martha", 957332, 01432684, "mar@tcd.ie"),
(125, "Robert", 957230, 0349874324, "rob@tcd.ie"),
(67, "Sophia", 578212, 0347624321, "soph@tcd.ie"),
(92, "Alannah", 123435, 04938562, "alan@tcd.ie"),
(6, "Bob", 1234124, 06685438, "bob@tcd.ie"),
(8, "Jeff", 18674932, 076758934, "jeff@tcd.ie"),
(13, "John", 1843671, 09865743, "john@tcd.ie"),
(5, "Cara", 15376283, 0675849372, "cara@tcd.ie")
;

INSERT INTO committee VALUES
(2, "Alice", "Outings", "Email", "VALID"),
(6, "Bob", "Equipment", "Discord", "VALID"),
(8, "Jeff", "Secretary", "Email", "VALID"),
(13, "John", "Captain", "Facebook", "VALID"),
(5, "Cara", "Training and Development", "Messenger", "VALID");

INSERT INTO qualifications VALUES
(92, "Alannah", 3, "Kayaking Instructor", "Canoeing Ireland", "2023-01-11"),
(5, "Cara", 2, "Kayaking Instructor", "Canoeing Ireland", "2021-05-15"),
(6, "Bob", 4, "Kayaking Skills Award", "Canoeing Ireland", "2023-02-05"),
(125, "Robert", 2, "Water Safety Award", "Sailing Ireland", "2022-12-20"),
(8, "Jeff", 4, "Kayaking Skills Award", "Canoeing Ireland", "2023-01-21");

INSERT INTO equipment VALUES
(8, "LiquidLogic Paddles", 5, "2021-05-01", 6, 50),
(11, "Aquamarina Paddles", 2, "2021-08-07", 13, 35),
(4, "NRS Throwbag", 8, "2021-08-10", 6, 20),
(35, "Peak Spraydeck", 15, "2021-11-15", 8, 45),
(76, "Palm Cag", 12, "2021-06-02", 13, 70);

INSERT INTO locations VALUES
("Grand Canal Dock", 25, 0, "David", 083456789),
("Trinity Swimming Pool", 15, 0, "TCD Sport", 081984367),
("Lucan Weir", 12, 50, "", 0),
("Duff Falls", 40, 300, "Mark", 0896746),
("Rossnowlagh Beach", 35, 200, "Janet", 0809865);

SELECT * FROM kayak.committee;
SELECT * FROM kayak.members;
SELECT * FROM kayak.qualifications;
SELECT * FROM kayak.equipment;
SELECT * FROM kayak.locations;
SELECT * FROM kayak.training;

ALTER TABLE members
DROP memberEmail;
ALTER TABLE members
ADD memberPhone INT;

ALTER TABLE committee
DROP memberVetting;
ALTER TABLE committee
ADD studentNum INT;

ALTER TABLE qualifications
DROP expiryDate;
ALTER TABLE qualifications
ADD costOfQual INT;

ALTER TABLE equipment
DROP cost;
ALTER TABLE equipment
ADD brandNewCost INT;

ALTER TABLE locations
DROP capacity;
ALTER TABLE locations
ADD skillLevelRequired INT;

ALTER TABLE training
DROP trainingTime;
ALTER TABLE training
ADD typeOfTraining VARCHAR(100);

CREATE VIEW trainingOfficer AS
SELECT 
qualifications.memberName, 
qualifications.qualName, 
qualifications.qualLevel 
FROM qualifications;

SELECT * FROM trainingOfficer;

CREATE VIEW equipmentOfficer AS
SELECT
equipment.typeEquip,
equipment.quantity,
equipment.cost
FROM equipment;

SELECT * FROM equipmentOfficer;


SELECT * FROM members
WHERE memberSid < 1000000;

SELECT members.memberName, members.memberSid, committee.memberRole, committee.memberPermissions
FROM members INNER JOIN committee
ON members.memberId=committee.memberId;

delimiter $$
CREATE TRIGGER invalidTrainingTime
AFTER INSERT ON kayak.training
FOR EACH ROW
BEGIN
	IF NEW.trainingTime > 2400 OR NEW.trainingTime < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: INVALID TRAINING TIME!';
    END IF;
END; $$

CREATE ROLE manageGear;
GRANT SELECT ON equipmentOfficer to manageGear;

CREATE ROLE 'captain';
GRANT SELECT ON members. * to 'captain';

CREATE ROLE 'equip';
GRANT SELECT ON equipment. * to 'equip'

CREATE USER 'BOB' IDENTIFIED BY 'verySecurePassword';
GRANT 'equip' TO 'BOB';

CREATE USER 'JOHN' IDENTIFIED BY 'anotherVerySecurePassword';
GRANT 'captain' TO 'JOHN';