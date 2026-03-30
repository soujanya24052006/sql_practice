-- Bookstore Database

 
DROP TABLE titleauthors CASCADE CONSTRAINTS;
DROP TABLE titles CASCADE CONSTRAINTS;
DROP TABLE authors CASCADE CONSTRAINTS;
DROP TABLE subjects CASCADE CONSTRAINTS;
DROP TABLE publishers CASCADE CONSTRAINTS;

 

CREATE TABLE publishers (
    pubid NUMBER(3) PRIMARY KEY,
    pname VARCHAR2(30),
    email VARCHAR2(50) UNIQUE,
    phone VARCHAR2(30)
);

CREATE TABLE subjects (
    subid VARCHAR2(5) PRIMARY KEY,
    sname VARCHAR2(30)
);

CREATE TABLE authors (
    auid NUMBER(5) PRIMARY KEY,
    aname VARCHAR2(30),
    email VARCHAR2(50) UNIQUE,
    phone VARCHAR2(30)
);

CREATE TABLE titles (
    titleid NUMBER(5) PRIMARY KEY,
    title VARCHAR2(50),
    pubid NUMBER(3) REFERENCES publishers(pubid),
    subid VARCHAR2(5) REFERENCES subjects(subid),
    pubdate DATE,
    cover CHAR(1) CHECK (cover IN ('P','H')),
    price NUMBER(6)
);

CREATE TABLE titleauthors (
    titleid NUMBER(5) REFERENCES titles(titleid),
    auid NUMBER(5) REFERENCES authors(auid),
    importance NUMBER(2),
    PRIMARY KEY (titleid, auid)
);

 

INSERT INTO subjects VALUES ('ORA','Oracle Database');
INSERT INTO subjects VALUES ('JAVA','Java Language');
INSERT INTO subjects VALUES ('JEE','Java Enterprise Edition');
INSERT INTO subjects VALUES ('VB','VB.NET');
INSERT INTO subjects VALUES ('ASP','ASP.NET');

INSERT INTO publishers VALUES (1,'WILLEY','WDT@VSNL.NET','91-23260877');
INSERT INTO publishers VALUES (2,'WROX','INFO@WROX.COM',NULL);
INSERT INTO publishers VALUES (3,'TATA MCGRAW-HILL','FEEDBACK@TATAMCGRAWHILL.COM','91-33333322');
INSERT INTO publishers VALUES (4,'TECHMEDIA','BOOKS@TECHMEDIA.COM','91-33257660');

INSERT INTO authors VALUES (101,'Herbert Schildt','HERBERT@YAHOO.COM',NULL);
INSERT INTO authors VALUES (102,'James Goodwill','GOODWILL@HOTMAIL.COM',NULL);
INSERT INTO authors VALUES (103,'David Hunter','HUNTER@HOTMAIL.COM',NULL);
INSERT INTO authors VALUES (104,'Stephen Walther','WALTHER@GMAIL.COM',NULL);
INSERT INTO authors VALUES (105,'Kevin Loney','LONEY@ORACLE.COM',NULL);
INSERT INTO authors VALUES (106,'Ed Romans','ROMANS@THESERVERSIDE.COM',NULL);

INSERT INTO titles VALUES (1001,'ASP.NET Unleashed',4,'ASP',DATE '2017-02-12','P',540);
INSERT INTO titles VALUES (1002,'Oracle 10g Complete Ref',3,'ORA',DATE '2017-01-10','P',575);
INSERT INTO titles VALUES (1003,'Mastering EJB',1,'JEE',DATE '2016-12-30','H',475);
INSERT INTO titles VALUES (1004,'Java Complete Ref',3,'JAVA',DATE '2016-04-03','P',499);
INSERT INTO titles VALUES (1005,'Pro VB.NET',2,'VB',NULL,'P',450);
INSERT INTO titles VALUES (1006,'Advanced ASP.NET',4,'ASP',DATE '2020-11-30','P',520);
INSERT INTO titles VALUES (1009,'Java Performance',3,'JAVA',SYSDATE,'H',900);

INSERT INTO titleauthors VALUES (1001,101,1);
INSERT INTO titleauthors VALUES (1002,105,1);
INSERT INTO titleauthors VALUES (1002,106,1);
INSERT INTO titleauthors VALUES (1004,101,1);
INSERT INTO titleauthors VALUES (1005,103,1);
INSERT INTO titleauthors VALUES (1005,102,2);
INSERT INTO titleauthors VALUES (1006,101,1);
INSERT INTO titleauthors VALUES (1009,102,1);

 

/* 1. Authors who have not published any book */
SELECT aname
FROM authors
WHERE auid NOT IN (SELECT auid FROM titleauthors);

/* 2. Books priced above average price of WILLEY publications */
SELECT title
FROM titles
WHERE price > (
    SELECT AVG(price)
    FROM titles
    WHERE pubid = (
        SELECT pubid FROM publishers WHERE pname = 'WILLEY'
    )
);

/* 3. Second highest priced book */
SELECT title, price
FROM titles
WHERE price = (
    SELECT MAX(price)
    FROM titles
    WHERE price < (SELECT MAX(price) FROM titles)
);

/* 4. Publishers who published ORACLE books but not JAVA books */
SELECT pname
FROM publishers
WHERE pubid IN (SELECT pubid FROM titles WHERE subid = 'ORA')
AND pubid NOT IN (SELECT pubid FROM titles WHERE subid = 'JAVA');

/* 5. Author of the costliest book */
SELECT aname
FROM authors
WHERE auid IN (
    SELECT auid
    FROM titleauthors
    WHERE titleid = (
        SELECT titleid FROM titles WHERE price = (SELECT MAX(price) FROM titles)
    )
);

/* 6. Titles written by authors who wrote more than 2 books */
SELECT title
FROM titles
WHERE titleid IN (
    SELECT titleid
    FROM titleauthors
    WHERE auid IN (
        SELECT auid
        FROM titleauthors
        GROUP BY auid
        HAVING COUNT(*) > 2
    )
);

/* 7. Subjects with average price less than JAVA subjects */
SELECT subid
FROM titles
GROUP BY subid
HAVING AVG(price) < ALL (
    SELECT AVG(price)
    FROM titles
    WHERE subid = 'JAVA'
    GROUP BY subid
);

/* 8. Authors who wrote books priced above 500 */
SELECT aname
FROM authors
WHERE auid IN (
    SELECT auid
    FROM titleauthors
    WHERE titleid IN (
        SELECT titleid FROM titles WHERE price > 500
    )
);