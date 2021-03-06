set termout on
set feedback on
prompt Building sample university database.  Please wait ...
set termout off
set feedback off

CREATE TABLE Department(
	DepartmentID INT,
	DepartmentName VARCHAR(30) NOT NULL,
	PRIMARY KEY ( DepartmentID)
);
INSERT INTO Department VALUES ( 1, 'Computer Science');
INSERT INTO Department VALUES ( 2, 'Dirty Word');
INSERT INTO Department VALUES ( 3, 'Magic Power');
INSERT INTO Department VALUES ( 4, 'Game Of Thrones');
INSERT INTO Department VALUES ( 5, 'The Big Bang Theory');

CREATE TABLE UserRecord(
	UserID INT,
	Login_Username VARCHAR(30) NOT NULL,
	Password VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	DOB date NOT NULL,
	DepartmentID INT,
	PRIMARY KEY ( UserID),
	FOREIGN KEY ( DepartmentID) REFERENCES Department( DepartmentID)
);
INSERT INTO UserRecord VALUES ( 1, 't_g270', 'password', 'Tianyi', 'Gao', 't_g270@txstate.edu', '23-Sep-1989', 1);
INSERT INTO UserRecord VALUES ( 2, 'h_p123', 'magic', 'Harry', 'Potter', 'h_p123@wizarding.edu', '31-Jul-1980', 3);
INSERT INTO UserRecord VALUES ( 3, 'j_b1', 'IAmTheKing', 'Joffrey', 'Baratheon', 'j_b1@gmail.com', '26-Dec-2001', 4);
INSERT INTO UserRecord VALUES ( 4, 't_l23', 'morewine', 'Tyrion', 'Lannister', 't_l23@lannisport.com', '5-Mar-1966', 4);
INSERT INTO UserRecord VALUES ( 5, 'd_t3', 'Dracarys', 'Daenerys', 'Targaryen', 'd_t3@westeros.com', '6-Jun-1982', 4);
INSERT INTO UserRecord VALUES ( 6, 's_c20', 'Bazinga', 'Sheldon', 'Cooper', 's_c20@caltech.edu', '26-Feb-1980', 5);

CREATE TABLE SurveyCreator(
	UserID INT,
	PRIMARY KEY ( UserID),
	FOREIGN KEY ( UserID) REFERENCES UserRecord( UserID)
);
INSERT INTO SurveyCreator VALUES (3);
INSERT INTO SurveyCreator VALUES (5);
INSERT INTO SurveyCreator VALUES (6);

CREATE TABLE Respondent(
	UserID INT,
	PRIMARY KEY ( UserID),
	FOREIGN KEY ( UserID) REFERENCES UserRecord( UserID)
);
INSERT INTO Respondent VALUES (2);
INSERT INTO Respondent VALUES (3);
INSERT INTO Respondent VALUES (4);
INSERT INTO Respondent VALUES (5);
INSERT INTO Respondent VALUES (6);

CREATE TABLE Admin(
	UserID INT,
	PRIMARY KEY ( UserID),
	FOREIGN KEY ( UserID) REFERENCES UserRecord( UserID)
);
INSERT INTO Admin VALUES (1);

CREATE TABLE Survey(
	SurveyName VARCHAR(100) NOT NULL,
	SurveyID INT,
	SurveyCreator INT NOT NULL,
	Note VARCHAR(1000),
	Anonymous INT NOT NULL, -- 0 = FALSE, 1 = TRUE
	Mandatory INT NOT NULL, -- 0 = FALSE, 1 = TRUE
	PRIMARY KEY ( SurveyID),
	FOREIGN KEY ( SurveyCreator) REFERENCES SurveyCreator( UserID),
	CHECK ( Anonymous = 1 OR Anonymous = 0),
	CHECK ( Mandatory = 1 OR Mandatory = 0)
);
INSERT INTO Survey VALUES ( 'Do you love your King?', 1, 3, 'Anyone who disagree with me will be sentenced to death!', 0, 1);
INSERT INTO Survey VALUES ( 'Advises to your queen', 2, 5, 'How to defeat the army outside Meereen and go back to Westeros?', 1, 0);
INSERT INTO Survey VALUES ( 'Survey for CS5332', 3, 6, 'The feedback to CS5332', 1, 1);

CREATE TABLE Question(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	Content VARCHAR(1000),
	PRIMARY KEY ( SurveyID, Question#),
	FOREIGN KEY ( SurveyID) REFERENCES Survey( SurveyID)
);
INSERT INTO Question VALUES ( 1, 1, 'Joffrey Baratheon is the only true king of Westeros.');
INSERT INTO Question VALUES ( 1, 2, 'Who do you think is the worst traitor?');
INSERT INTO Question VALUES ( 1, 3, 'What do you want to say to Your Grace?');
INSERT INTO Question VALUES ( 2, 1, 'The dragons should be free immediately, even though they might attack our men.');
INSERT INTO Question VALUES ( 2, 2, 'What is the most important thing to get my throne back?');
INSERT INTO Question VALUES ( 2, 3, 'We should fight against the white walkers before taking kingslanding.');
INSERT INTO Question VALUES ( 2, 4, 'Hizdahr, Daenerys'' hasband, tried to poison the queen by spiced locusts.');
INSERT INTO Question VALUES ( 2, 5, 'Please write your advise if you have one.');
INSERT INTO Question VALUES ( 3, 1, 'What did you learn from this course?');

CREATE TABLE SingleChoiceQustion(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	PRIMARY KEY ( SurveyID, Question#),
	FOREIGN KEY ( SurveyID, Question#) REFERENCES Question( SurveyID, Question#)
);
INSERT INTO SingleChoiceQustion VALUES ( 1, 2);
INSERT INTO SingleChoiceQustion VALUES ( 2, 2);

CREATE TABLE TrueFalseQuestion(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	PRIMARY KEY ( SurveyID, Question#),
	FOREIGN KEY ( SurveyID, Question#) REFERENCES Question( SurveyID, Question#)
);
INSERT INTO TrueFalseQuestion VALUES ( 1, 1);
INSERT INTO TrueFalseQuestion VALUES ( 2, 1);
INSERT INTO TrueFalseQuestion VALUES ( 2, 3);
INSERT INTO TrueFalseQuestion VALUES ( 2, 4);

CREATE TABLE FreeTextQuestion(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	PRIMARY KEY ( SurveyID, Question#),
	FOREIGN KEY ( SurveyID, Question#) REFERENCES Question( SurveyID, Question#)
);
INSERT INTO FreeTextQuestion VALUES ( 1, 3);
INSERT INTO FreeTextQuestion VALUES ( 2, 5);
INSERT INTO FreeTextQuestion VALUES ( 3, 1);

CREATE TABLE Choice(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	Choice# INT NOT NULL,
	Content VARCHAR(100) NOT NULL,
	PRIMARY KEY ( SurveyID, Question#, Choice#),
	FOREIGN KEY ( SurveyID, Question#) REFERENCES SingleChoiceQustion( SurveyID, Question#),
	UNIQUE ( SurveyID, Question#, Content)
);
INSERT INTO Choice VALUES ( 1, 2, 1, 'Stannis Baratheon');
INSERT INTO Choice VALUES ( 1, 2, 2, 'Renly Baratheon');
INSERT INTO Choice VALUES ( 1, 2, 3, 'Tyrion Lannister');
INSERT INTO Choice VALUES ( 1, 2, 4, 'George RR Martin');
INSERT INTO Choice VALUES ( 2, 2, 1, 'The supports from the lords');
INSERT INTO Choice VALUES ( 2, 2, 2, 'Powerful army');
INSERT INTO Choice VALUES ( 2, 2, 3, 'Dragons');
INSERT INTO Choice VALUES ( 2, 2, 4, 'Spies, such as Varys');
INSERT INTO Choice VALUES ( 2, 2, 5, 'Do not matter. ask George Martin go back to work!');

CREATE TABLE ResponseSingleChoice(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	RespondentID INT NOT NULL,
	Choice# INT,
	PRIMARY KEY ( SurveyID, Question#, RespondentID),
	FOREIGN KEY ( RespondentID) REFERENCES Respondent( UserID),
	FOREIGN KEY ( SurveyID, Question#, Choice#) REFERENCES Choice( SurveyID, Question#, Choice#)
);
INSERT INTO ResponseSingleChoice VALUES ( 1, 2, 4, 1);
INSERT INTO ResponseSingleChoice VALUES ( 1, 2, 5, 3);
INSERT INTO ResponseSingleChoice VALUES ( 1, 2, 6, 4);
INSERT INTO ResponseSingleChoice VALUES ( 2, 2, 3, 3);
INSERT INTO ResponseSingleChoice VALUES ( 2, 2, 4, 1);
INSERT INTO ResponseSingleChoice VALUES ( 2, 2, 6, 5);

CREATE TABLE TrueFalseChoice(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	RespondentID INT NOT NULL,
	Choice INT, -- 0 = FALSE, 1 = TRUE
	PRIMARY KEY ( SurveyID, Question#, RespondentID),
	FOREIGN KEY ( SurveyID, Question#) REFERENCES TrueFalseQuestion( SurveyID, Question#),
	FOREIGN KEY ( RespondentID) REFERENCES Respondent( UserID),
	CHECK ( Choice = 1 OR Choice = 0)
);
INSERT INTO TrueFalseChoice VALUES ( 1, 1, 4, 0);
INSERT INTO TrueFalseChoice VALUES ( 1, 1, 5, 0);
INSERT INTO TrueFalseChoice VALUES ( 1, 1, 6, 0);
INSERT INTO TrueFalseChoice VALUES ( 2, 1, 3, 1);
INSERT INTO TrueFalseChoice VALUES ( 2, 1, 4, 1);
INSERT INTO TrueFalseChoice VALUES ( 2, 1, 6, 0);
INSERT INTO TrueFalseChoice VALUES ( 2, 3, 3, 1);
INSERT INTO TrueFalseChoice VALUES ( 2, 3, 4, 0);
INSERT INTO TrueFalseChoice VALUES ( 2, 3, 6, 1);
INSERT INTO TrueFalseChoice VALUES ( 2, 4, 3, 1);
INSERT INTO TrueFalseChoice VALUES ( 2, 4, 4, 0);
INSERT INTO TrueFalseChoice VALUES ( 2, 4, 6, 1);

CREATE TABLE FreeText(
	SurveyID INT NOT NULL,
	Question# INT NOT NULL,
	RespondentID INT NOT NULL,
	Answer VARCHAR(3000),
	PRIMARY KEY ( SurveyID, Question#, RespondentID),
	FOREIGN KEY ( SurveyID, Question#) REFERENCES FreeTextQuestion( SurveyID, Question#),
	FOREIGN KEY ( RespondentID) REFERENCES Respondent( UserID)
);
INSERT INTO FreeText VALUES ( 1, 3, 4, 'You have the wits of a goose');
INSERT INTO FreeText VALUES ( 1, 3, 5, 'Get out of my throne!');
INSERT INTO FreeText VALUES ( 1, 3, 6, 'Everyone is celebrating when you are dead, except your mom.');
INSERT INTO FreeText VALUES ( 2, 5, 3, 'Traitor!');
INSERT INTO FreeText VALUES ( 2, 5, 4, 'Give me dozens of the Unsullied, and I will return the Casterly Rock.');
INSERT INTO FreeText VALUES ( 2, 5, 6, 'Your dragons are not real because of Violation of the laws of physics.');

CREATE TABLE CourseSurvey(
	SurveyID INT,
	CRN INT NOT NULL UNIQUE,
	PRIMARY KEY ( SurveyID),
	FOREIGN KEY ( SurveyID) REFERENCES Survey( SurveyID)
	--FOREIGN KEY ( CRN) REFERENCES Course( CRN)
	--The CRN should also be set as a foreign key, but I skip it because of no Course entity.
);
INSERT INTO CourseSurvey VALUES ( 3, 12700);



set termout on
set feedback on
prompt The creations are done.

--SQL query
SELECT COUNT(*) AS Vote_To_Free_The_Dragons
FROM TrueFalseChoice join Question on ( TrueFalseChoice.SurveyID = Question.SurveyID AND TrueFalseChoice.Question# = Question.Question#)
WHERE TrueFalseChoice.SurveyID = 2 AND TrueFalseChoice.Question# = 1 AND Choice = 1;

set termout off
set feedback off