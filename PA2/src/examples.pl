% id, title, cost, duration

series([
[1,'HIMYM',40,30],
[2,'Heroes',20,30],
[3,'The Walking Dead',20,30],
[4,'Orange is the new Black',20,30],
[5,'Sherlock Holmes',40,30],
[6,'Flash',40,30],
[7,'Green Arrow',30,30],
[8,'Telenovela',10,30],
[9,'Green Lantern',70,30],
[10,'Superman',25,30],
[11,'Batman',30,30],
[12,'Porto',10,30],
[13,'Pokemon',15,30],
[14,'House MD',5,30],
[15,'Avatar',10,30],
[16,'Simpsons',50,30],
[17,'American Dad',40,30],
[18,'Family Guy',40,30],
[19,'Yu gi Oh',30,30],
[20,'Benfica',30,30],
[21,'Sporting',30,30],
[22,'Cricket',20,30],
[23,'Baseball',40,30]
]).

% id, day, 
slots([
[1,1,600,_],
[2,2,2040,_],			
[3,5,6960,_],
[4,5,6990,_]
]).

% IDserie, IDslot, score

votacao([
[1,1,20],
[1,2,20],
[1,3,50],
[1,4,60],
[2,1,20],
[2,2,20],
[2,3,50],
[2,4,60],
[3,1,20],
[3,2,20],
[3,3,50],
[3,4,60],
[4,1,20],
[4,2,20],
[4,3,50],
[4,4,60],
[5,1,20],
[5,2,20],
[5,3,50],
[5,4,60],
[6,1,20],
[6,2,20],
[6,3,50],
[6,4,60],
[7,1,20],
[7,2,20],
[7,3,50],
[7,4,60],
[8,1,20],
[8,2,20],
[8,3,50],
[8,4,60],
[9,1,20],
[9,2,20],
[9,3,50],
[9,4,60],
[10,1,20],
[10,2,20],
[10,3,50],
[10,4,60],
[11,1,20],
[11,2,20],
[11,3,50],
[11,4,60],
[12,1,20],
[12,2,20],
[12,3,50],
[12,4,60],
[13,1,20],
[13,2,20],
[13,3,50],
[13,4,60],
[14,1,20],
[14,2,20],
[14,3,50],
[14,4,60],
[15,1,20],
[15,2,20],
[15,3,50],
[15,4,60],
[16,1,20],
[16,2,20],
[16,3,50],
[16,4,60],
[17,1,20],
[17,2,20],
[17,3,50],
[17,4,60],
[18,1,20],
[18,2,20],
[18,3,50],
[18,4,60],
[19,1,20],
[19,2,20],
[19,3,50],
[19,4,60],
[20,1,20],
[20,2,20],
[20,3,50],
[20,4,60],
[21,1,20],
[21,2,20],
[21,3,50],
[21,4,60],
[22,1,20],
[22,2,20],
[22,3,50],
[22,4,60],
[23,1,20],
[23,2,20],
[23,3,50],
[23,4,60]
]).

% IDserie1, IDserie2

rest_series([
[2,4]
]).


% id, (before or after) , time
rest_series_hours([
[1,2,400]
]).



switchDay(1,'Domingo').
switchDay(2,'Segunda-Feira').
switchDay(3,'Terca-Feira').
switchDay(4,'Quarta-Feira').
switchDay(5,'Quinta-Feira').
switchDay(6,'Sexta-Feira').
switchDay(7,'Sabado').

