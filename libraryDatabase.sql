--Dropping the tables first 
DROP TABLE PhoneNumbers CASCADE CONSTRAINTS;
DROP TABLE StandardPatron CASCADE CONSTRAINTS;
DROP TABLE PremimumPatron CASCADE CONSTRAINTS;
DROP TABLE Associate_ CASCADE CONSTRAINTS;
DROP TABLE Transactions CASCADE CONSTRAINTS;
DROP TABLE Patrons CASCADE CONSTRAINTS;
DROP TABLE BookCopies CASCADE CONSTRAINTS;
DROP TABLE Publishers CASCADE CONSTRAINTS;
DROP TABLE Write_ CASCADE CONSTRAINTS;
DROP TABLE Authors CASCADE CONSTRAINTS;
DROP TABLE Books CASCADE CONSTRAINTS;


--This to create Patrons Table
CREATE TABLE Patrons(
    PatronId INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Street VARCHAR(100),
    City VARCHAR(30),
    --I changed the name here to State_ since state is key words in Oracle
    State_ VARCHAR(30), 
    ZipCode CHAR (10),
    EmailAddress VARCHAR(100),
    MemberShip_Type VARCHAR(30) CHECK (MemberShip_Type IN ('Standard' , 'Premium')),
    PRIMARY KEY (PatronId)
);

--changed the design from option 3 to option 1 for a better design implementation. 
CREATE TABLE StandardPatron(
    PatronId INT NOT NULL PRIMARY KEY,
    Borrowing_Limit INT Default 5 check (Borrowing_Limit = 5),
    Loan_Period INT Default 14 check (Loan_Period = 14), 
    FOREIGN KEY (PatronId) REFERENCES Patrons(PatronId) ON DELETE cascade
);

CREATE TABLE PremimumPatron(
    PatronId INT NOT NULL PRIMARY KEY,
    Increased_Borrowing_Limit INT Default 10 check (Increased_Borrowing_Limit = 10),
    Extended_Loan_Period INT Default 30 check (Extended_Loan_Period = 30),
    FOREIGN KEY (PatronId) REFERENCES Patrons(PatronId) ON DELETE cascade
);

--This is to create PhoneNumbers Table, PhoneNumbers is a multivalued attribute in Patrons,so we have to create it 
-- in seperate table with a primary key of combination
CREATE TABLE PhoneNumbers(
    PhoneNumber VARCHAR(10),
    PatronId INT NOT NULL,
    PRIMARY KEY (PhoneNumber,PatronId),
    FOREIGN KEY (PatronId) REFERENCES Patrons(PatronId) ON DELETE cascade
);

--This is to Create Transactions Table
CREATE TABLE Transactions(
    --I used different name from p1-2 because TransactionID seems to be a reserved word
    Transaction_ID INT NOT NULL, 
    DueDate DATE NOT NULL,
    CheckOutDateTime TIMESTAMP NOT NULL,
    ReturnDate DATE,
    PatronId INT NOT NULL,
    PRIMARY KEY (Transaction_ID),
    FOREIGN key (PatronId) REFERENCES Patrons(PatronId) ON DELETE cascade
);

--This is to Create Books table
CREATE TABLE Books(
    ISBN VARCHAR(20),
    BookEdition INT,
    Category VARCHAR(50),
    -- changed the name from p1-2 since Title seems to be a reserved word
    BookTitle VARCHAR(255) NOT NULL, 
    --to ensure that rice is not negative
    Price DECIMAL(10,2) CHECK(Price > 0), 
    PRIMARY KEY (ISBN)
);

--This is to Create Authors Table
CREATE TABLE Authors(
    AuthorId INT NOT NULL,
    -- changed the name from p1-2 since Title seems to be a reserved word
    AuthorName VARCHAR(30) NOT NULL, 
    DOB DATE,
    Nationality VARCHAR(50),
    PRIMARY KEY (AuthorId)
);

--create table for publishers (multivalued attribute in Authors)
CREATE TABLE Publishers(
    publisherName VARCHAR(50),
    AuthorId INT NOT NULL,
    PRIMARY KEY (publisherName,AuthorId),
    FOREIGN KEY (AuthorId) REFERENCES Authors (AuthorId) ON DELETE cascade
);

--create Write_ table since the relation between Authors and Books is M:N we needed another table
--I added _to the name since Write seems to be resrved word
CREATE TABLE Write_(
    ISBN VARCHAR(20),
    AuthorId INT,
    PRIMARY KEY (ISBN, AuthorId),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN) ON DELETE cascade,
    FOREIGN KEY (AuthorId) REFERENCES Authors(AuthorId) ON DELETE cascade
);


--This is to create BookCopies Table
CREATE TABLE BookCopies(
    ISBN VARCHAR(20),
    CopyNumber INT,
    CopyStatus VARCHAR(20) CHECK (CopyStatus IN ('Available', 'Checked out', 'Damaged')),
    PRIMARY KEY (CopyNumber,ISBN),
    FOREIGN KEY (ISBN) REFERENCES Books (ISBN) ON DELETE cascade
);


--Since the association/relation between bookCopies and Transactions is M:N we neededd a new table for a relationship
--I added _to the name since Associate seems to be resrved word
CREATE TABLE Associate_(
    Transaction_ID INT,
    CopyNumber INT,
    ISBN VARCHAR(20),
    PRIMARY KEY (Transaction_ID,CopyNumber,ISBN),
    FOREIGN KEY (Transaction_ID) REFERENCES Transactions(Transaction_ID) ON DELETE cascade,
    FOREIGN KEY (CopyNumber,ISBN) REFERENCES BookCopies(CopyNumber,ISBN) ON DELETE cascade
); 

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--------------------------------------Insert some values to each table------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- Insert values to Books Table
INSERT INTO Books (ISBN,BookEdition,Category,BookTitle,Price) 
VALUES ('979-8302689320',3,'Science Fiction','Tachyon 3: The Planet: Hard Science Fiction',17.99);

INSERT INTO Books (ISBN,BookEdition,Category,BookTitle,Price)
VALUES ('979-8337701660', 1, 'Graphic Novel', 'Into the Change', 13.99);

INSERT INTO Books (ISBN,BookEdition,Category,BookTitle,Price)
VALUES ('979-8601223492', 4, 'Graphic Novel', 'Zodiac Academy 4: Shadow Princess', 58.38);

INSERT INTO Books (ISBN,BookEdition,Category,BookTitle,Price)
VALUES ('978-0241250945', 1, 'Graphic Novel', 'Turn The Ship Around!', 13.67);

INSERT INTO Books (ISBN,BookEdition,Category,BookTitle,Price)
VALUES ('978-0316066419', 1, 'Science Fiction','Winters Bones', 16.73);

INSERT INTO Books (ISBN,BookEdition,Category,BookTitle,Price)
VALUES ('978-1101910092', 1, 'Science Fiction','The Big Book of Science Fiction',21.90);
                

--Insert values to Authors Table
-- author of Tachyon 3: The Planet: Hard Science Fiction
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality) 
VALUES (1, 'Brandon Q. Morris',TO_DATE('1966-08-26', 'YYYY-MM-DD') ,'German'); 

-- author of Into the Change
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality)
VALUES (2, 'Ward Cornell ',TO_DATE('1924-05-04', 'YYYY-MM-DD') ,'Canadian'); 

-- author of The Big Book of Science Fiction
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality)
VALUES (3, 'Jeff VanderMeer',TO_DATE('1968-07-07', 'YYYY-MM-DD') ,'American'); 

--  author of The Big Book of Science Fiction
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality) 
VALUES (4, 'ANN VanderMeer',TO_DATE('1957-03-06', 'YYYY-MM-DD') ,'American'); 

-- author of Winters Bones
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality) 
VALUES (5, 'Daniel Woodrell',TO_DATE('1953-03-04', 'YYYY-MM-DD') ,'American'); 

-- author of Turn The Ship Around!
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality) 
VALUES (6, 'David Marquet',TO_DATE('1953-02-04', 'YYYY-MM-DD') ,'American'); 

-- author of Zodiac Academy 4: Shadow Princess
INSERT INTO Authors (AuthorId,AuthorName,DOB,Nationality) 
VALUES (7, 'Caroline Peckham',TO_DATE('1983-06-14', 'YYYY-MM-DD') ,'English'); 


-- Insert values to Write_ table
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('979-8302689320' , 1);
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('979-8337701660' , 2);
-- multiple authors for same book "The Big Book of Science Fiction"
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('978-1101910092' , 3); 
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('978-1101910092' , 4);
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('978-0316066419' , 5);
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('978-0241250945' , 6);
INSERT INTO Write_ (ISBN, AuthorId) VALUES ('979-8601223492' , 7);

-- Insert values to Publishers table
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('Computer Bild',1);
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('Heise-Verlag',1);
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('Heise-Verlag',2);
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('The Atlantic',3);
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('Publishers Weekly',3);
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('The Washington Post',4);
INSERT INTO Publishers (publisherName,AuthorId) VALUES ('Book World',4);


-- Insert Values to BookCopies
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8302689320',1,'Available');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8302689320',2,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8337701660',1,'Available');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8337701660',2,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8337701660',3,'Available');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('978-1101910092',1,'Available');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('978-1101910092',2,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('978-1101910092',3,'Damaged');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('978-0316066419',1,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('978-0316066419',2,'Available');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('978-0241250945',1,'Checked out');
-- This book will be checked out 6 times
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8601223492',1,'Checked out'); 
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8601223492',2,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8601223492',3,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8601223492',4,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8601223492',5,'Checked out');
INSERT INTO BookCopies (ISBN,CopyNumber,CopyStatus) VALUES ('979-8601223492',6,'Checked out');


--Insert values to Patrons
INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (100,'Nermeen', 'Rizk', 'well stone', 'aldie', 'VA', '20105', 'nrizk2@gmu.edu', 'Standard');

INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (101,'Merna', 'Rizk', 'well stone', 'aldie', 'VA', '20105', 'mrizk2@gmu.edu', 'Premium');

INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (102,'Karaas', 'Adel', 'Amnesty Place', 'Fairfax', 'VA', '22030', 'karaas@gmu.edu', 'Premium');

INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (103,'Chris', 'Rizk', 'Ames Street', 'Fairfax', 'VA', '22030', 'chris@gmu.edu', 'Standard');

INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (104,'Adel', 'Nageh', 'pinebrook Street', 'Fairfax', 'VA', '22030', 'adel@gmu.edu', 'Premium');

INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (105,'Maria', 'John', 'Castle street', 'Sterling', 'VA', '20115', 'maria@gmu.edu', 'Premium');

INSERT INTO Patrons (PatronId,FirstName,LastName,Street,City,State_,ZipCode,EmailAddress,MemberShip_Type)
VALUES (106,'John', 'Smith', 'Hospital road', 'Fairfax', 'VA', '22030', 'john@gmu.edu', 'Standard');



--Insert Values to StandardPatron
-- Nermeen
INSERT INTO StandardPatron (PatronId,Borrowing_Limit,Loan_Period) VALUES(100,5,14); 
-- Chris
INSERT INTO StandardPatron (PatronId,Borrowing_Limit,Loan_Period) VALUES(103,5,14); 
-- John
INSERT INTO StandardPatron (PatronId,Borrowing_Limit,Loan_Period) VALUES(106,5,14); 


--Insert Values to PremimumPatron
-- Merna
INSERT INTO PremimumPatron (PatronId,Increased_Borrowing_Limit,Extended_Loan_Period) VALUES(101,10,30);
-- Karaas
INSERT INTO PremimumPatron (PatronId,Increased_Borrowing_Limit,Extended_Loan_Period) VALUES(102,10,30); 
-- Adel
INSERT INTO PremimumPatron (PatronId,Increased_Borrowing_Limit,Extended_Loan_Period) VALUES(104,10,30); 
-- Maria
INSERT INTO PremimumPatron (PatronId,Increased_Borrowing_Limit,Extended_Loan_Period) VALUES(105,10,30); 



-- Insert Values to Transactions
INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (1,TO_DATE('2025-03-12', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-02 14:30:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-13', 'YYYY-MM-DD'),100);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (2,TO_DATE('2025-03-18', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-11 16:50:00', 'YYYY-MM-DD HH24:MI:SS') ,NULL,101);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (3,TO_DATE('2025-03-21', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-20 14:30:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-25', 'YYYY-MM-DD'),100);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (4,TO_DATE('2025-03-18', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-10 08:30:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-15', 'YYYY-MM-DD'),103);

--Starting here will be transcations for the same book more than 5 times
INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (5,TO_DATE('2025-03-06', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-01 10:15:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-02', 'YYYY-MM-DD'),103);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (6,TO_DATE('2025-03-08', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-03 12:20:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-05', 'YYYY-MM-DD'),102);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (7,TO_DATE('2025-03-10', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-06 13:19:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-07', 'YYYY-MM-DD'),101);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (8,TO_DATE('2025-03-13', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-10', 'YYYY-MM-DD'),100);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (9,TO_DATE('2025-03-14', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-11 09:25:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-13', 'YYYY-MM-DD'),103);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (10,TO_DATE('2025-03-15', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-14 11:00:00', 'YYYY-MM-DD HH24:MI:SS') ,NULL,100);
-- not same book added for last query so patron 100 (Nermeen) should checked all science fiction books
INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (11,TO_DATE('2025-02-21', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-01-20 14:30:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-01-25', 'YYYY-MM-DD'),100);

--Patron 102 will check all science fiction books
INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (12,TO_DATE('2025-03-28', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-13 12:20:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-15', 'YYYY-MM-DD'),102);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (13,TO_DATE('2025-03-28', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-13 12:20:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-15', 'YYYY-MM-DD'),102);

INSERT INTO Transactions (Transaction_ID,DueDate,CheckOutDateTime,ReturnDate,PatronId)
VALUES (14,TO_DATE('2025-03-28', 'YYYY-MM-DD'),TO_TIMESTAMP('2025-03-03 12:20:00', 'YYYY-MM-DD HH24:MI:SS') ,TO_DATE('2025-03-15', 'YYYY-MM-DD'),102);



-- Insert Values to Associate_
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (1,2,'979-8302689320');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (2,2,'979-8337701660');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (3,2,'978-1101910092');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (4,1,'978-0241250945');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (5,1,'979-8601223492');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (6,2,'979-8601223492');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (7,3,'979-8601223492');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (8,4,'979-8601223492');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (9,5,'979-8601223492');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (10,6,'979-8601223492');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (11,1,'978-0316066419');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (12,2,'979-8302689320');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (13,2,'978-1101910092');
INSERT INTO Associate_ (Transaction_ID,CopyNumber,ISBN) VALUES (14,1,'978-0316066419');



--Insert values to PhoneNumbers
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('1234523765',100);
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('6547893210',101);
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('6547432210',102);
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('7689054678',103);
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('7689054328',104);
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('5714538765',105);
INSERT INTO PhoneNumbers (PhoneNumber,PatronId) VALUES ('7017651234',106);

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--------------------------------------SQL queries on the database-----------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- 1. Find the ISBN and copy number of all available book copies.
SELECT ISBN, CopyNumber 
FROM BOOKCOPIES where CopyStatus = 'Available';

-- 2. Find the first names of standard patrons residing in Fairfax (ZIP code = ‘22030’).
SELECT FirstName
from PATRONS WHERE (MemberShip_Type = 'Standard' AND ZIPCODE = '22030' AND city = 'Fairfax');

-- 3. Find the Patron IDs and email of premium patrons who haven’t made any transactions yet.
SELECT PatronId, EmailAddress 
FROM PATRONS WHERE MEMBERSHIP_TYPE = 'Premium' AND
PATRONID NOT IN (SELECT PATRONID FROM TRANSACTIONS);

-- 4. Find the names of the authors who write books in either the Science Fiction or Graphic Novel category.
SELECT AuthorName from AUTHORS A, Books B, WRITE_  W WHERE 
(A.AUTHORID = W.AUTHORID
AND B.ISBN = W.ISBN
AND (B.CATEGORY = 'Graphic Novel' OR B.CATEGORY = 'Science Fiction'));

-- 5. Count the number of copies available for each book.
SELECT ISBN, COUNT(*)  
FROM BOOKCopies 
WHERE COPYSTATUS = 'Available' GROUP BY ISBN;

-- 6. Find the Patron IDs of patrons who have borrowed books that are overdue
SELECT Distinct PatronId 
FROM TRANSACTIONS T 
WHERE (T.RETURNDATE IS NULL AND SYSDATE > T.DueDate) 
OR (T.ReturnDate > T.DueDate);

-- 7. Find the ISBNs and titles of books that have been checked out more than 5 times
SELECT Books.ISBN,Books.BookTitle FROM BOOKS
JOIN ASSOCIATE_ ON (Books.ISBN = ASSOCIATE_.ISBN)
Group BY (Books.ISBN,Books.BookTitle)
HAVING COUNT(ASSOCIATE_.TRANSACTION_ID) >5;


-- 8. Find the Patron IDs of the patrons who have checked out every book in the Science Fiction category.
SELECT DISTINCT T1.PATRONID FROM TRANSACTIONS T1
WHERE NOT EXISTS(
    SELECT B1.ISBN FROM BOOKS B1 WHERE B1.CATEGORY = 'Science Fiction'
    AND NOT EXISTS (
        SELECT * FROM ASSOCIATE_ A1 
        JOIN TRANSACTIONS T2
        on
        T2.TRANSACTION_ID = A1.TRANSACTION_ID
        AND
        T2.PATRONID = T1.PATRONID
        and
        A1.ISBN = B1.ISBN
    )
);





