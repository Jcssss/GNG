-- Justin Siu
-- V00976501
-- Please note that a lot of this data was auto-generated using a python script that I wrote, I've provided the script in the repository ('dummy-data.py').

drop table Campaigns cascade;
create table Campaigns (
    cid serial primary key,
    sdate date,
    edate date,
    budget numeric(10,2)
        check (budget >= 0),
    topic char(20),
    notes text default ''
);

-- If End Date is before Start Date for a campaign, sets the End Date equal to the Start Date
create or replace function campaigns_trig_func() returns trigger as
$campaign_trig$
    begin
        update Campaigns
            set edate = sdate
            where edate < sdate;
        return null;
    end;
$campaign_trig$ language plpgsql;

-- Applies the above trigger to Campaigns
drop trigger CheckCampaignDates on Campaigns;
create trigger CheckCampaignDates
    after insert on Campaigns
    execute procedure campaigns_trig_func();

insert into Campaigns values (1, '2021-03-02', '2021-03-30', 10000, 'BC Wolf Cull');
insert into Campaigns values (2, '2021-01-21', '2021-03-22', 3500, 'BC Pesticide Usage');
insert into Campaigns values (3, '2022-12-20', '2023-02-27', 4500, 'BC Water Pollution');
insert into Campaigns values (4, '2024-08-16', '2024-12-12', 6700, 'Global Warming');
insert into Campaigns values (5, '2023-01-21', '2022-03-24', 8000, 'BC Clearcutting');

drop table Phases cascade;
create table Phases (
    phid serial primary key,
    sdate date,
    edate date,
    city char(20),
    location char(30),
    name char(20),
    budget numeric(10,2)
        check (budget >= 0),
    notes text default ''
);

-- If the End Date is before the Start Date, sets the End Date equal to the start Date
create or replace function phases_trig_func() returns trigger as
$phases_trig$
    begin
        update Phases
            set edate = sdate
            where edate < sdate;
        return null;
    end;
$phases_trig$ language plpgsql;

-- Applies the above trigger to Phases
drop trigger PhaseDatesTrigger on Phases;
create trigger PhaseDatesTrigger
    after insert on Phases
    execute procedure phases_trig_func();

insert into Phases values (1,'2021-03-02','2021-03-03','Victoria','Mayfair Mall','Fundraising Dinner',900);
insert into Phases values (2,'2021-03-03','2021-03-09','Victoria','Mayfair Mall','Spin the Wheel Booth',200);
insert into Phases values (3,'2021-03-09','2021-03-13','Victoria','Inner Harbour','Flyer Distribution',1300);
insert into Phases values (4,'2021-03-17','2021-03-19','Vancouver','University of British Columbia','Trivia Booth',800);
insert into Phases values (5,'2021-03-18','2021-03-24','Victoria','Tilicum Mall','Info Booth',1300);
insert into Phases values (6,'2021-03-28','2021-03-30','Vancouver','Richmond Mall','Bottle Drive',1050);
insert into Phases values (7,'2021-01-21','2021-01-25','Vancouver','Richmond Mall','Info Booth',1400);
insert into Phases values (8,'2021-01-24','2021-01-30','Nanaimo','The Bastion','Spin the Wheel Booth',150);
insert into Phases values (9,'2021-01-29','2021-02-01','Vancouver','Metrotown','Info Booth',850);
insert into Phases values (10,'2021-01-31','2021-02-06','Vancouver','Stanley Park','Info Booth',1300);
insert into Phases values (11,'2021-02-06','2021-02-11','Victoria','University of Victoria','Spin the Wheel Booth',550);
insert into Phases values (12,'2021-02-11','2021-02-16','Victoria','Warf Street','Info Booth',200);
insert into Phases values (13,'2021-02-18','2021-02-23','Victoria','University of Victoria','Flyer Distribution',1150);
insert into Phases values (14,'2021-02-22','2021-02-23','Victoria','Inner Harbour','Flyer Distribution',800);
insert into Phases values (15,'2021-02-22','2021-02-27','Victoria','University of Victoria','Flyer Distribution',550);
insert into Phases values (16,'2021-02-24','2021-03-01','Vancouver','University of British Columbia','Info Booth',100);
insert into Phases values (17,'2021-02-23','2021-03-03','Nanaimo','Harbourfront Walkway','Trivia Booth',550);
insert into Phases values (18,'2021-03-07','2021-03-10','Victoria','Tilicum Mall','Spin the Wheel Booth',500);
insert into Phases values (19,'2021-03-07','2021-03-10','Victoria','Tilicum Mall','Trivia Booth',750);
insert into Phases values (20,'2021-03-17','2021-03-21','Vancouver','Vancouver City Centre','Info Booth',1200);
insert into Phases values (21,'2021-03-21','2021-03-22','Victoria','Royal BC Museum','Flyer Distribution',150);
insert into Phases values (22,'2022-12-20','2022-12-23','Vancouver','Stanley Park','Trivia Booth',1100);
insert into Phases values (23,'2022-12-23','2022-12-27','Vancouver','University of British Columbia','Trivia Booth',150);
insert into Phases values (24,'2022-12-26','2022-12-30','Victoria','Mayfair Mall','Flyer Distribution',200);
insert into Phases values (25,'2022-12-27','2022-12-28','Victoria','Parliament Building','Fundraising Dinner',300);
insert into Phases values (26,'2022-12-31','2023-01-02','Vancouver','Stanley Park','Trivia Booth',600);
insert into Phases values (27,'2023-01-02','2023-01-03','Victoria','Inner Harbour','Flyer Distribution',200);
insert into Phases values (28,'2023-01-07','2023-01-13','Tofino','Chesterman Beach','Spin the Wheel Booth',750);
insert into Phases values (29,'2023-01-15','2023-01-20','Victoria','Warf Street','Trivia Booth',1050);
insert into Phases values (30,'2023-01-23','2023-01-27','Vancouver','Stanley Park','Spin the Wheel Booth',250);
insert into Phases values (31,'2023-01-24','2023-01-28','Victoria','Royal BC Museum','Spin the Wheel Booth',600);
insert into Phases values (32,'2023-02-01','2023-02-06','Vancouver','University of British Columbia','Info Booth',1150);
insert into Phases values (33,'2023-02-06','2023-02-07','Tofino','Chesterman Beach','Fundraising Dinner',1050);
insert into Phases values (34,'2023-02-10','2023-02-14','Nanaimo','Harbourfront Walkway','Spin the Wheel Booth',700);
insert into Phases values (35,'2023-02-14','2023-02-17','Victoria','University of Victoria','Trivia Booth',1350);
insert into Phases values (36,'2023-02-22','2023-02-26','Vancouver','Vancouver Farmers Market','Flyer Distribution',1200);
insert into Phases values (37,'2023-02-26','2023-02-27','Tofino','Tonquin Park','Spin the Wheel Booth',600);
insert into Phases values (38,'2024-08-16','2024-08-20','Vancouver','Metrotown','Spin the Wheel Booth',350);
insert into Phases values (39,'2024-08-24','2024-08-29','Victoria','Uptown','Flyer Distribution',1350);
insert into Phases values (40,'2024-08-29','2024-09-01','Vancouver','University of British Columbia','Spin the Wheel Booth',450);
insert into Phases values (41,'2024-08-30','2024-09-02','Victoria','Parliament Building','Spin the Wheel Booth',1150);
insert into Phases values (42,'2024-08-31','2024-09-04','Victoria','University of Victoria','Spin the Wheel Booth',850);
insert into Phases values (43,'2024-09-02','2024-09-04','Victoria','University of Victoria','Trivia Booth',1250);
insert into Phases values (44,'2024-09-04','2024-09-10','Victoria','Mayfair Mall','Spin the Wheel Booth',800);
insert into Phases values (45,'2024-09-10','2024-09-14','Victoria','University of Victoria','Spin the Wheel Booth',1450);
insert into Phases values (46,'2024-09-12','2024-09-17','Victoria','Inner Harbour','Trivia Booth',1050);
insert into Phases values (47,'2024-09-23','2024-09-25','Tofino','Tonquin Park','Trivia Booth',650);
insert into Phases values (48,'2024-09-25','2024-09-29','Victoria','Butchart Gardens','Trivia Booth',250);
insert into Phases values (49,'2024-10-02','2024-10-06','Nanaimo','Harbourfront Walkway','Trivia Booth',650);
insert into Phases values (50,'2024-10-03','2024-10-08','Victoria','Tilicum Mall','Spin the Wheel Booth',800);
insert into Phases values (51,'2024-10-15','2024-10-19','Vancouver','Granville Island','Bottle Drive',850);
insert into Phases values (52,'2024-10-26','2024-10-31','Victoria','Royal BC Museum','Info Booth',1050);
insert into Phases values (53,'2024-10-31','2024-11-05','Vancouver','Metrotown','Flyer Distribution',200);
insert into Phases values (54,'2024-11-04','2024-11-08','Victoria','Tilicum Mall','Trivia Booth',900);
insert into Phases values (55,'2024-11-07','2024-11-10','Victoria','Parliament Building','Info Booth',1200);
insert into Phases values (56,'2024-11-10','2024-11-15','Victoria','Royal BC Museum','Trivia Booth',250);
insert into Phases values (57,'2024-11-15','2024-11-19','Victoria','Warf Street','Flyer Distribution',1150);
insert into Phases values (58,'2024-11-25','2024-11-29','Victoria','Warf Street','Spin the Wheel Booth',700);
insert into Phases values (59,'2024-12-04','2024-12-10','Victoria','Royal BC Museum','Spin the Wheel Booth',400);
insert into Phases values (60,'2024-12-07','2024-12-12','Victoria','Parliament Building','Flyer Distribution',100);
insert into Phases values (61,'2023-01-21','2023-01-25','Vancouver','Vancouver Farmers Market','Info Booth',100);
insert into Phases values (62,'2023-01-24','2023-01-29','Victoria','Mayfair Mall','Info Booth',500);
insert into Phases values (63,'2023-01-28','2023-01-30','Victoria','Butchart Gardens','Bottle Drive',250);
insert into Phases values (64,'2023-01-28','2023-02-01','Vancouver','Granville Island','Trivia Booth',1200);
insert into Phases values (65,'2023-01-30','2023-02-05','Victoria','Parliament Building','Spin the Wheel Booth',700);
insert into Phases values (66,'2023-02-07','2023-02-12','Vancouver','Metrotown','Flyer Distribution',800);
insert into Phases values (67,'2023-02-16','2023-02-22','Victoria','Royal BC Museum','Spin the Wheel Booth',750);
insert into Phases values (68,'2023-02-22','2023-02-24','Vancouver','Vancouver City Centre','Trivia Booth',750);
insert into Phases values (69,'2023-02-21','2023-02-24','Victoria','Uptown','Trivia Booth',1000);
insert into Phases values (70,'2023-03-01','2023-03-05','Victoria','Mayfair Mall','Spin the Wheel Booth',1400);
insert into Phases values (71,'2023-03-04','2023-03-10','Vancouver','University of British Columbia','Spin the Wheel Booth',350);
insert into Phases values (72,'2023-03-13','2023-03-16','Victoria','Uptown','Trivia Booth',850);
insert into Phases values (73,'2023-03-15','2023-03-21','Victoria','Royal BC Museum','Spin the Wheel Booth',1300);
insert into Phases values (74,'2023-03-23','2023-03-24','Victoria','Uptown','Spin the Wheel Booth',1100);

drop table Members cascade;
create table Members (
    email char(50) primary key
        check (email like '%@%.%'),
    phone char(12)
        check (phone ~ '\d{3}-\d{3}-\d{4}'),
    fname char(20),
    lname char(20),
    sdate date,
    vhours int default 0
        check (vhours >= 0),
    notes text default ''
);

insert into Members values ('greymanlydragon077@hotmail.com','637-949-7158','Amanda','Smith','2020-05-13',9);
insert into Members values ('redprogrammingpiano501@gmail.com','534-696-2968','Sam','Singh','2020-09-13',0);
insert into Members values ('combativeassertivesheep998@gmail.com','637-338-3957','Robin','Lim','2020-06-24',0);
insert into Members values ('programmingganglyeagle557@hotmail.com','637-523-7224','Ally','Stent','2020-07-27',452);
insert into Members values ('manlyprogrammingtent233@gmail.com','250-778-4968','Richard','Walt','2020-04-20',133);
insert into Members values ('combativesillyotter583@uvic.ca','534-042-1247','Danah','Wilson','2020-07-28',15);
insert into Members values ('OTaylor839@gng.ca','778-850-6614','Omar','Taylor','2020-04-23',68);
insert into Members values ('ASingh708@gng.ca','250-119-2194','Amanda','Singh','2020-04-16',3);
insert into Members values ('seductivemanlydragon380@outlook.com','637-727-2674','Maggie','Lim','2020-12-03',70);
insert into Members values ('blueseductivedesk329@shaw.ca','637-331-2146','Omar','Wilson','2020-12-23',279);
insert into Members values ('blueprogrammingeagle654@gmail.com','778-709-1720','Jim','Zhang','2020-03-31',10);
insert into Members values ('AJones119@gng.ca','534-828-1031','Amanda','Jones','2021-01-26',5);
insert into Members values ('oldprogramminglizard201@uvic.ca','637-533-7959','Jim','Lim','2020-08-05',8);
insert into Members values ('sillymadalligator388@shaw.ca','778-964-1279','Omar','Wilson','2020-05-25',18);
insert into Members values ('madgrimduck072@uvic.ca','534-752-6817' ,'Joe','Lim','2023-09-22',9);
insert into Members values ('JWilson126@gng.ca','778-466-6343','Jim','Wilson','2024-07-02',20);
insert into Members values ('spryjollypig342@hotmail.com','534-602-9655','Jasmine','Robson','2024-02-02',0);
insert into Members values ('observantsprydragon009@uvic.ca','778-428-0159','Alfred','McDougal','2022-09-09',191);
insert into Members values ('smallviolentwalrus685@shaw.ca','534-419-1437','Albert','Samuel','2021-10-21',0);
insert into Members values ('agilehandsomeseal902@gmail.com','722-543-0901','Alex','Argon','2019-11-17',0);
insert into Members values ('test@test.com','722-543-0901','Test','Test','2019-11-17',0);

drop table Employees cascade;
create table Employees (
    email char(50) primary key,
    salary numeric(10,2)
        check (salary >= 0),
    job char(30)
);

insert into Employees values ('OTaylor839@gng.ca',20100,'Director');
insert into Employees values ('ASingh708@gng.ca',12400, 'Accountant');
insert into Employees values ('AJones119@gng.ca',12600,'Campaign Manager');
insert into Employees values ('JWilson126@gng.ca',10700,'Public Relations Manager');

drop table Transactions cascade;
create table Transactions (
    tid serial primary key,
    amount int,
    dateof date,
    reason char(30),
    notes text default ''
);

insert into Transactions values (1,-190,'2021-03-02','Maintenance Fees');
insert into Transactions values (2,-210,'2021-03-03','Door Prizes');
insert into Transactions values (3,-290,'2021-03-02','Decorations');
insert into Transactions values (4,-210,'2021-03-05','Booth Rental');
insert into Transactions values (5,-120,'2021-03-06','Door Prizes');
insert into Transactions values (6,-190,'2021-03-06','Maintenance Fees');
insert into Transactions values (7,-200,'2021-03-09','Supplies');
insert into Transactions values (8,-100,'2021-03-12','Door Prizes');
insert into Transactions values (9,-110,'2021-03-17','Maintenance Fees');
insert into Transactions values (10,130,'2021-03-17','Fundraising');
insert into Transactions values (11,-240,'2021-03-22','Decorations');
insert into Transactions values (12,-200,'2021-03-23','Booth Rental');
insert into Transactions values (13,-270,'2021-03-29','Booth Rental');
insert into Transactions values (14,-210,'2021-03-29','Door Prizes');
insert into Transactions values (15,-220,'2021-01-22','Maintenance Fees');
insert into Transactions values (16,-130,'2021-01-25','Maintenance Fees');
insert into Transactions values (17,-100,'2021-01-24','Supplies');
insert into Transactions values (18,-200,'2021-01-24','Booth Rental');
insert into Transactions values (19,-210,'2021-01-30','Supplies');
insert into Transactions values (20,-140,'2021-01-31','Decorations');
insert into Transactions values (21,-260,'2021-01-31','Door Prizes');
insert into Transactions values (22,-140,'2021-02-06','Booth Rental');
insert into Transactions values (23,-150,'2021-02-11','Booth Rental');
insert into Transactions values (24,290,'2021-02-10','Fundraising');
insert into Transactions values (25,-190,'2021-02-15','Booth Rental');
insert into Transactions values (26,-210,'2021-02-22','Maintenance Fees');
insert into Transactions values (27,-220,'2021-02-18','Door Prizes');
insert into Transactions values (28,-230,'2021-02-21','Door Prizes');
insert into Transactions values (29,110,'2021-02-21','Fundraising');
insert into Transactions values (30,-130,'2021-02-23','Supplies');
insert into Transactions values (31,-230,'2021-02-23','Booth Rental');
insert into Transactions values (32,-260,'2021-02-22','Decorations');
insert into Transactions values (33,-120,'2021-02-26','Maintenance Fees');
insert into Transactions values (34,-130,'2021-02-24','Booth Rental');
insert into Transactions values (35,-210,'2021-02-28','Booth Rental');
insert into Transactions values (36,-110,'2021-03-07','Decorations');
insert into Transactions values (37,-270,'2021-03-08','Booth Rental');
insert into Transactions values (38,-290,'2021-03-07','Maintenance Fees');
insert into Transactions values (39,-130,'2021-03-07','Booth Rental');
insert into Transactions values (40,-240,'2021-03-07','Decorations');
insert into Transactions values (41,-250,'2021-03-07','Decorations');
insert into Transactions values (42,-190,'2021-03-17','Door Prizes');
insert into Transactions values (43,-250,'2021-03-20','Booth Rental');
insert into Transactions values (44,-180,'2021-03-22','Door Prizes');
insert into Transactions values (45,-130,'2021-03-22','Maintenance Fees');
insert into Transactions values (46,-130,'2022-12-22','Booth Rental');
insert into Transactions values (47,-130,'2022-12-23','Door Prizes');
insert into Transactions values (48,-240,'2022-12-23','Booth Rental');
insert into Transactions values (49,-210,'2022-12-23','Maintenance Fees');
insert into Transactions values (50,-170,'2022-12-26','Booth Rental');
insert into Transactions values (51,-300,'2022-12-23','Supplies');
insert into Transactions values (52,-200,'2022-12-27','Booth Rental');
insert into Transactions values (53,-270,'2022-12-26','Maintenance Fees');
insert into Transactions values (54,-220,'2022-12-28','Decorations');
insert into Transactions values (55,-230,'2022-12-27','Booth Rental');
insert into Transactions values (56,-300,'2022-12-28','Decorations');
insert into Transactions values (57,-280,'2022-12-28','Door Prizes');
insert into Transactions values (58,-230,'2023-01-02','Supplies');
insert into Transactions values (59,-190,'2023-01-03','Maintenance Fees');
insert into Transactions values (60,-160,'2023-01-03','Supplies');
insert into Transactions values (61,-270,'2023-01-03','Decorations');
insert into Transactions values (62,200,'2023-01-02','Fundraising');
insert into Transactions values (63,-250,'2023-01-13','Booth Rental');
insert into Transactions values (64,-120,'2023-01-13','Booth Rental');
insert into Transactions values (65,-220,'2023-01-13','Decorations');
insert into Transactions values (66,300,'2023-01-09','Fundraising');
insert into Transactions values (67,-270,'2023-01-18','Maintenance Fees');
insert into Transactions values (68,-170,'2023-01-16','Booth Rental');
insert into Transactions values (69,-230,'2023-01-27','Supplies');
insert into Transactions values (70,-260,'2023-01-24','Decorations');
insert into Transactions values (71,-270,'2023-01-28','Door Prizes');
insert into Transactions values (72,110,'2023-01-28','Fundraising');
insert into Transactions values (73,-160,'2023-02-02','Supplies');
insert into Transactions values (74,-150,'2023-02-05','Supplies');
insert into Transactions values (75,-220,'2023-02-07','Decorations');
insert into Transactions values (76,-230,'2023-02-06','Supplies');
insert into Transactions values (77,270,'2023-02-07','Fundraising');
insert into Transactions values (78,-280,'2023-02-10','Maintenance Fees');
insert into Transactions values (79,-150,'2023-02-16','Decorations');
insert into Transactions values (80,-180,'2023-02-17','Supplies');
insert into Transactions values (81,-260,'2023-02-24','Decorations');
insert into Transactions values (82,-260,'2023-02-27','Door Prizes');
insert into Transactions values (83,-140,'2023-02-27','Decorations');
insert into Transactions values (84,-250,'2023-02-26','Supplies');
insert into Transactions values (85,-290,'2024-08-19','Booth Rental');
insert into Transactions values (86,-280,'2024-08-20','Door Prizes');
insert into Transactions values (87,-100,'2024-08-27','Decorations');
insert into Transactions values (88,-120,'2024-08-29','Maintenance Fees');
insert into Transactions values (89,-110,'2024-08-26','Decorations');
insert into Transactions values (90,190,'2024-08-27','Fundraising');
insert into Transactions values (91,-260,'2024-09-01','Maintenance Fees');
insert into Transactions values (92,-160,'2024-08-29','Decorations');
insert into Transactions values (93,-300,'2024-08-31','Maintenance Fees');
insert into Transactions values (94,-110,'2024-08-30','Decorations');
insert into Transactions values (95,-200,'2024-09-04','Door Prizes');
insert into Transactions values (96,-250,'2024-09-02','Door Prizes');
insert into Transactions values (97,-250,'2024-09-04','Maintenance Fees');
insert into Transactions values (98,-270,'2024-09-08','Booth Rental');
insert into Transactions values (99,-270,'2024-09-09','Maintenance Fees');
insert into Transactions values (100,-100,'2024-09-07','Booth Rental');
insert into Transactions values (101,-120,'2024-09-10','Decorations');
insert into Transactions values (102,-240,'2024-09-11','Booth Rental');
insert into Transactions values (103,-280,'2024-09-12','Door Prizes');
insert into Transactions values (104,-100,'2024-09-17','Supplies');
insert into Transactions values (105,-280,'2024-09-23','Decorations');
insert into Transactions values (106,-200,'2024-09-27','Door Prizes');
insert into Transactions values (107,-280,'2024-10-02','Supplies');
insert into Transactions values (108,-140,'2024-10-03','Door Prizes');
insert into Transactions values (109,-160,'2024-10-07','Maintenance Fees');
insert into Transactions values (110,-190,'2024-10-04','Maintenance Fees');
insert into Transactions values (111,-200,'2024-10-15','Maintenance Fees');
insert into Transactions values (112,-260,'2024-10-28','Decorations');
insert into Transactions values (113,-280,'2024-11-04','Maintenance Fees');
insert into Transactions values (114,-100,'2024-11-07','Maintenance Fees');
insert into Transactions values (115,-210,'2024-11-04','Door Prizes');
insert into Transactions values (116,-150,'2024-11-10','Supplies');
insert into Transactions values (117,-180,'2024-11-07','Booth Rental');
insert into Transactions values (118,-130,'2024-11-15','Supplies');
insert into Transactions values (119,-190,'2024-11-13','Decorations');
insert into Transactions values (120,-250,'2024-11-19','Door Prizes');
insert into Transactions values (121,-260,'2024-11-15','Decorations');
insert into Transactions values (122,-190,'2024-11-29','Door Prizes');
insert into Transactions values (123,-250,'2024-11-26','Door Prizes');
insert into Transactions values (124,-110,'2024-11-27','Maintenance Fees');
insert into Transactions values (125,260,'2024-11-25','Fundraising');
insert into Transactions values (126,-130,'2024-12-08','Decorations');
insert into Transactions values (127,-240,'2024-12-09','Supplies');
insert into Transactions values (128,-240,'2023-01-21','Maintenance Fees');
insert into Transactions values (129,-160,'2023-01-23','Door Prizes');
insert into Transactions values (130,-140,'2023-01-21','Booth Rental');
insert into Transactions values (131,-230,'2023-01-25','Decorations');
insert into Transactions values (132,-160,'2023-01-24','Booth Rental');
insert into Transactions values (133,190,'2023-01-28','Fundraising');
insert into Transactions values (134,-270,'2023-01-29','Decorations');
insert into Transactions values (135,-220,'2023-01-30','Maintenance Fees');
insert into Transactions values (136,-160,'2023-01-30','Door Prizes');
insert into Transactions values (137,140,'2023-01-31','Fundraising');
insert into Transactions values (138,-260,'2023-02-04','Decorations');
insert into Transactions values (139,-280,'2023-01-31','Door Prizes');
insert into Transactions values (140,-190,'2023-02-11','Booth Rental');
insert into Transactions values (141,-230,'2023-02-09','Maintenance Fees');
insert into Transactions values (142,-130,'2023-02-07','Maintenance Fees');
insert into Transactions values (143,-130,'2023-02-21','Maintenance Fees');
insert into Transactions values (144,-200,'2023-02-22','Door Prizes');
insert into Transactions values (145,-260,'2023-02-22','Maintenance Fees');
insert into Transactions values (146,-270,'2023-02-23','Door Prizes');
insert into Transactions values (147,-130,'2023-02-23','Decorations');
insert into Transactions values (148,-260,'2023-02-22','Maintenance Fees');
insert into Transactions values (149,-290,'2023-02-23','Decorations');
insert into Transactions values (150,-210,'2023-03-04','Maintenance Fees');
insert into Transactions values (151,-200,'2023-03-02','Maintenance Fees');
insert into Transactions values (152,-120,'2023-03-04','Door Prizes');
insert into Transactions values (153,-180,'2023-03-06','Decorations');
insert into Transactions values (154,-240,'2023-03-05','Booth Rental');
insert into Transactions values (155,-240,'2023-03-08','Door Prizes');
insert into Transactions values (156,-290,'2023-03-14','Door Prizes');
insert into Transactions values (157,-200,'2023-03-13','Supplies');
insert into Transactions values (158,-180,'2023-03-14','Supplies');
insert into Transactions values (159,-110,'2023-03-19','Supplies');
insert into Transactions values (160,-170,'2023-03-19','Booth Rental');
insert into Transactions values (161,-240,'2023-03-24','Decorations');
insert into Transactions values (162,-200,'2023-03-24','Supplies');
insert into Transactions values (163,-190,'2023-03-24','Door Prizes');
insert into Transactions values (164,11350,'2021-03-04','Donation');
insert into Transactions values (165,19500,'2021-03-28','Donation');
insert into Transactions values (166,5700,'2021-03-11','Donation');
insert into Transactions values (167,15950,'2021-02-10','Donation');
insert into Transactions values (168,19450,'2023-02-11','Donation');
insert into Transactions values (169,25000,'2023-01-07','Donation');
insert into Transactions values (170,15050,'2023-02-14','Donation');
insert into Transactions values (171,8250,'2024-09-28','Donation');
insert into Transactions values (172,20250,'2024-10-12','Donation');
insert into Transactions values (173,5900,'2024-11-06','Donation');
insert into Transactions values (174,13950,'2023-03-18','Donation');
insert into Transactions values (175,47400,'2019-10-21','Donation');
insert into Transactions values (176,26500,'2016-10-02','Donation');
insert into Transactions values (177,45900,'2016-03-29','Donation');
insert into Transactions values (178,29300,'2023-05-19','Donation');
insert into Transactions values (179,10500,'2022-01-20','Donation');
insert into Transactions values (180,17000,'2023-06-16','Donation');
insert into Transactions values (181,11700,'2019-11-01','Donation');
insert into Transactions values (182,28400,'2019-04-29','Donation');
insert into Transactions values (183,20400,'2016-02-07','Donation');
insert into Transactions values (184,32900,'2021-03-29','Donation');
insert into Transactions values (185,-6350,'2022-01-23','Maintenance Fees');
insert into Transactions values (186,-8050,'2018-08-09','Venue Rental');
insert into Transactions values (187,-7600,'2016-04-24','Offic Rent');
insert into Transactions values (188,-8600,'2018-05-18','Maintenance Fees');
insert into Transactions values (189,-9600,'2022-03-31','Maintenance Fees');
insert into Transactions values (190,-6100,'2017-08-13','Maintenance Fees');
insert into Transactions values (191,-8650,'2022-09-06','Maintenance Fees');
insert into Transactions values (192,-5350,'2017-01-10','Venue Rental');
insert into Transactions values (193,-8650,'2021-06-01','Venue Rental');
insert into Transactions values (194,-8700,'2022-10-13','Maintenance Fees');

drop table Donors cascade;
create table Donors (
    did serial primary key,
    cfname char(20),
    clname char(20),
    dname char(40),
    email char(30),
    notes text default ''
);

insert into Donors values (1, 'Chloe', 'Tong', 'Iron Jaw Inc.', 'ctong@ironjaw.ca');
insert into Donors values (2, 'Albert', 'Reginald', 'Timeless Bard', 'albertreginald@tbard.ca');
insert into Donors values (3, 'Ivan', 'Shephard', 'Ivan Shephard', 'ivanshep380@gmail.com');
insert into Donors values (4, 'Marvin', 'Stewart', 'MV Stairs', 'marvinst@mvstairs.com');
insert into Donors values (5, 'Tanya', 'Brown', 'Tanya Brown Enterprises', 'info@tbrown.ca');

drop table DonatesCampaign cascade;
create table DonatesCampaign (
    tid int,
    cid int,
    foreign key(tid) 
        references Transactions(tid)
        on update cascade
        on delete set null,
    foreign key(cid) 
        references Campaigns(cid)
        on update cascade
        on delete set null
);

insert into DonatesCampaign values (164,1);
insert into DonatesCampaign values (165,1);
insert into DonatesCampaign values (166,2);
insert into DonatesCampaign values (167,2);
insert into DonatesCampaign values (168,3);
insert into DonatesCampaign values (169,3);
insert into DonatesCampaign values (170,3);
insert into DonatesCampaign values (171,4);
insert into DonatesCampaign values (172,4);
insert into DonatesCampaign values (173,4);
insert into DonatesCampaign values (174,5);

drop table MakesDonation cascade;
create table MakesDonation (
    did int,
    tid int,
    foreign key(did)
        references Donors(did)
        on update cascade
        on delete set null,
    foreign key(tid) 
        references Transactions(tid)
        on update cascade
        on delete set null
);

insert into MakesDonation values (1,164);
insert into MakesDonation values (2,165);
insert into MakesDonation values (3,166);
insert into MakesDonation values (3,167);
insert into MakesDonation values (4,168);
insert into MakesDonation values (4,169);
insert into MakesDonation values (5,170);
insert into MakesDonation values (5,171);
insert into MakesDonation values (5,172);
insert into MakesDonation values (1,173);
insert into MakesDonation values (2,174);
insert into MakesDonation values (1,175);
insert into MakesDonation values (2,176);
insert into MakesDonation values (3,177);
insert into MakesDonation values (4,178);
insert into MakesDonation values (5,179);
insert into MakesDonation values (2,180);
insert into MakesDonation values (3,181);
insert into MakesDonation values (4,182);
insert into MakesDonation values (5,183);
insert into MakesDonation values (3,184);
insert into MakesDonation values (1,185);
insert into MakesDonation values (4,186);
insert into MakesDonation values (5,187);
insert into MakesDonation values (5,188);
insert into MakesDonation values (1,189);
insert into MakesDonation values (2,190);
insert into MakesDonation values (4,191);
insert into MakesDonation values (3,192);
insert into MakesDonation values (3,193);
insert into MakesDonation values (1,194);

drop table HasPhase cascade;
create table HasPhase(
    cid int,
    phid int,
    foreign key(cid) 
        references Campaigns(cid)
        on update cascade
        on delete set null,
    foreign key(phid) 
        references Phases(phid)
        on update cascade
        on delete set null
);

insert into HasPhase values (1,1);
insert into HasPhase values (1,2);
insert into HasPhase values (1,3);
insert into HasPhase values (1,4);
insert into HasPhase values (1,5);
insert into HasPhase values (1,6);
insert into HasPhase values (2,7);
insert into HasPhase values (2,8);
insert into HasPhase values (2,9);
insert into HasPhase values (2,10);
insert into HasPhase values (2,11);
insert into HasPhase values (2,12);
insert into HasPhase values (2,13);
insert into HasPhase values (2,14);
insert into HasPhase values (2,15);
insert into HasPhase values (2,16);
insert into HasPhase values (2,17);
insert into HasPhase values (2,18);
insert into HasPhase values (2,19);
insert into HasPhase values (2,20);
insert into HasPhase values (2,21);
insert into HasPhase values (3,22);
insert into HasPhase values (3,23);
insert into HasPhase values (3,24);
insert into HasPhase values (3,25);
insert into HasPhase values (3,26);
insert into HasPhase values (3,27);
insert into HasPhase values (3,28);
insert into HasPhase values (3,29);
insert into HasPhase values (3,30);
insert into HasPhase values (3,31);
insert into HasPhase values (3,32);
insert into HasPhase values (3,33);
insert into HasPhase values (3,34);
insert into HasPhase values (3,35);
insert into HasPhase values (3,36);
insert into HasPhase values (3,37);
insert into HasPhase values (4,38);
insert into HasPhase values (4,39);
insert into HasPhase values (4,40);
insert into HasPhase values (4,41);
insert into HasPhase values (4,42);
insert into HasPhase values (4,43);
insert into HasPhase values (4,44);
insert into HasPhase values (4,45);
insert into HasPhase values (4,46);
insert into HasPhase values (4,47);
insert into HasPhase values (4,48);
insert into HasPhase values (4,49);
insert into HasPhase values (4,50);
insert into HasPhase values (4,51);
insert into HasPhase values (4,52);
insert into HasPhase values (4,53);
insert into HasPhase values (4,54);
insert into HasPhase values (4,55);
insert into HasPhase values (4,56);
insert into HasPhase values (4,57);
insert into HasPhase values (4,58);
insert into HasPhase values (4,59);
insert into HasPhase values (4,60);
insert into HasPhase values (5,61);
insert into HasPhase values (5,62);
insert into HasPhase values (5,63);
insert into HasPhase values (5,64);
insert into HasPhase values (5,65);
insert into HasPhase values (5,66);
insert into HasPhase values (5,67);
insert into HasPhase values (5,68);
insert into HasPhase values (5,69);
insert into HasPhase values (5,70);
insert into HasPhase values (5,71);
insert into HasPhase values (5,72);
insert into HasPhase values (5,73);
insert into HasPhase values (5,74);

drop table VolunteersPhase cascade;
create table VolunteersPhase (
    email char(50),
    phid int,
    foreign key(email)
        references Members(email)
        on update cascade
        on delete set null,
    foreign key(phid) 
        references Phases(phid)
        on update cascade
        on delete set null
);

-- When a volunteer is assigned to a phase/campaign, increase their volunteer hours
create or replace function update_hours_trig_func() returns trigger as
$update_hours_trig$
    begin
        update Members
            set vhours = vhours + 3
            where email = NEW.email;
        return null;
    end;
$update_hours_trig$ language plpgsql;

-- When a volunteer is updated for a phase/campaign, take hours from the removed volunteer and give the equivalent hours to the new volunteer
create or replace function swap_hours_trig_func() returns trigger as
$swap_hours_trig$
    begin
        update Members
            set vhours = vhours - 3
            where email = OLD.email;
        update Members
            set vhours = vhours + 3
            where email = NEW.email;
        return null;
    end;
$swap_hours_trig$ language plpgsql;

-- When a volunteer is unassigned for a phase/campaign, takes hours from the volunteer
create or replace function remove_hours_trig_func() returns trigger as
$remove_hours_trig$
    begin
        update Members
            set vhours = vhours - 3
            where email = OLD.email;
        return null;
    end;
$remove_hours_trig$ language plpgsql;

-- Applies the triggers to update volunteer hours on insert, update, and deletion
drop trigger GiveVolunteerHours on VolunteersPhase;
create trigger GiveVolunteerHours
    after insert on VolunteersPhase
    for each row
    execute procedure update_hours_trig_func();

drop trigger TakeVolunteerHours on VolunteersPhase;
create trigger TakeVolunteerHours
    after delete on VolunteersPhase
    for each row
    execute procedure remove_hours_trig_func();

drop trigger SwapVolunteerHours on VolunteersPhase;
create trigger SwapVolunteerHours
    after update on VolunteersPhase
    for each row
    execute procedure swap_hours_trig_func();

insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',4);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',7);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',7);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',7);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',7);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',9);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',9);
insert into VolunteersPhase values ('combativeassertivesheep998@gmail.com',12);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',12);
insert into VolunteersPhase values ('blueseductivedesk329@shaw.ca',13);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',13);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',13);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',15);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',15);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',15);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',16);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',20);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',20);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',21);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',22);
insert into VolunteersPhase values ('sillymadalligator388@shaw.ca',22);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',22);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',22);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',24);
insert into VolunteersPhase values ('sillymadalligator388@shaw.ca',24);
insert into VolunteersPhase values ('programmingganglyeagle557@hotmail.com',25);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',28);
insert into VolunteersPhase values ('sillymadalligator388@shaw.ca',29);
insert into VolunteersPhase values ('blueseductivedesk329@shaw.ca',29);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',29);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',29);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',29);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',29);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',29);
insert into VolunteersPhase values ('combativeassertivesheep998@gmail.com',30);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',32);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',33);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',35);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',35);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',40);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',40);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',40);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',42);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',42);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',42);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',42);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',44);
insert into VolunteersPhase values ('programmingganglyeagle557@hotmail.com',44);
insert into VolunteersPhase values ('spryjollypig342@hotmail.com',44);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',44);
insert into VolunteersPhase values ('madgrimduck072@uvic.ca',44);
insert into VolunteersPhase values ('blueseductivedesk329@shaw.ca',46);
insert into VolunteersPhase values ('combativeassertivesheep998@gmail.com',47);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',47);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',47);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',48);
insert into VolunteersPhase values ('madgrimduck072@uvic.ca',48);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',48);
insert into VolunteersPhase values ('combativeassertivesheep998@gmail.com',49);
insert into VolunteersPhase values ('sillymadalligator388@shaw.ca',50);
insert into VolunteersPhase values ('madgrimduck072@uvic.ca',51);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',51);
insert into VolunteersPhase values ('blueseductivedesk329@shaw.ca',51);
insert into VolunteersPhase values ('sillymadalligator388@shaw.ca',51);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',52);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',52);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',52);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',52);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',54);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',55);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',55);
insert into VolunteersPhase values ('oldprogramminglizard201@uvic.ca',55);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',55);
insert into VolunteersPhase values ('combativeassertivesheep998@gmail.com',59);
insert into VolunteersPhase values ('programmingganglyeagle557@hotmail.com',61);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',61);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',61);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',61);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',62);
insert into VolunteersPhase values ('programmingganglyeagle557@hotmail.com',62);
insert into VolunteersPhase values ('greymanlydragon077@hotmail.com',62);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',62);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',63);
insert into VolunteersPhase values ('blueseductivedesk329@shaw.ca',66);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',67);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',67);
insert into VolunteersPhase values ('sillymadalligator388@shaw.ca',67);
insert into VolunteersPhase values ('blueseductivedesk329@shaw.ca',67);
insert into VolunteersPhase values ('combativeassertivesheep998@gmail.com',67);
insert into VolunteersPhase values ('programmingganglyeagle557@hotmail.com',67);
insert into VolunteersPhase values ('manlyprogrammingtent233@gmail.com',68);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',68);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',68);
insert into VolunteersPhase values ('blueprogrammingeagle654@gmail.com',69);
insert into VolunteersPhase values ('redprogrammingpiano501@gmail.com',70);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',70);
insert into VolunteersPhase values ('seductivemanlydragon380@outlook.com',73);
insert into VolunteersPhase values ('combativesillyotter583@uvic.ca',73);

drop table VolunteersCampaign cascade;
create table VolunteersCampaign (
    email char(50),
    cid int,
    job char(30),
    foreign key(email)
        references Members(email)
        on update cascade
        on delete set null,
    foreign key(cid) 
        references Campaigns(cid)
        on update cascade
        on delete set null
);

-- Applies the triggers to update volunteer hours on insert, update, and deletion
drop trigger GiveVolunteerHours on VolunteersCampaign;
create trigger GiveVolunteerHours
    after insert on VolunteersCampaign
    for each row
    execute procedure update_hours_trig_func();

drop trigger TakeVolunteerHours on VolunteersCampaign;
create trigger TakeVolunteerHours
    after delete on VolunteersCampaign
    for each row
    execute procedure remove_hours_trig_func();

drop trigger SwapVolunteerHours on VolunteersCampaign;
create trigger SwapVolunteerHours
    after update on VolunteersCampaign
    for each row
    execute procedure swap_hours_trig_func();

insert into VolunteersCampaign values ('combativesillyotter583@uvic.ca', 1, 'Advertising');
insert into VolunteersCampaign values ('combativeassertivesheep998@gmail.com', 1, 'Volunteer Organizer');
insert into VolunteersCampaign values ('oldprogramminglizard201@uvic.ca', 1, 'Supplies Purchasing');
insert into VolunteersCampaign values ('sillymadalligator388@shaw.ca', 2, 'Advertising');
insert into VolunteersCampaign values ('oldprogramminglizard201@uvic.ca', 2, 'Supplies Purchasing');
insert into VolunteersCampaign values ('manlyprogrammingtent233@gmail.com', 3, 'Volunteer Organizer');
insert into VolunteersCampaign values ('seductivemanlydragon380@outlook.com', 3, 'Supplies Purchasing');
insert into VolunteersCampaign values ('blueprogrammingeagle654@gmail.com', 3, 'Advertising');
insert into VolunteersCampaign values ('greymanlydragon077@hotmail.com', 3, 'Volunteer Organizer');
insert into VolunteersCampaign values ('blueprogrammingeagle654@gmail.com', 4, 'Supplies Purchasing');
insert into VolunteersCampaign values ('combativesillyotter583@uvic.ca', 5, 'Supplies Purchasing');
insert into VolunteersCampaign values ('redprogrammingpiano501@gmail.com', 5, 'Advertising');

drop table LeadsPhase cascade;
create table LeadsPhase (
    email char(50),
    phid int,
    foreign key(email)
        references Members(email)
        on update cascade
        on delete set null,
    foreign key(phid) 
        references Phases(phid)
        on update cascade
        on delete set null
);

-- When a volunteer is assigned to lead a phase, delete the old leader
create or replace function replace_phase_leader_trig_func() returns trigger as
$replace_leader_trig$
    begin
        delete from LeadsPhase
            where phid = NEW.phid;
        return NEW;
    end;
$replace_leader_trig$ language plpgsql;

-- Applies the above trigger to delete the old leader
drop trigger ReplaceLeader on LeadsPhase;
create trigger ReplaceLeader
    before insert on LeadsPhase
    for each row
    execute procedure replace_phase_leader_trig_func();

-- Applies the triggers to update volunteer hours on insert, update, and deletion
drop trigger GiveVolunteerHours on LeadsPhase;
create trigger GiveVolunteerHours
    after insert on LeadsPhase
    for each row
    execute procedure update_hours_trig_func();

drop trigger TakeVolunteerHours on LeadsPhase;
create trigger TakeVolunteerHours
    after delete on LeadsPhase
    for each row
    execute procedure remove_hours_trig_func();

drop trigger SwapVolunteerHours on LeadsPhase;
create trigger SwapVolunteerHours
    after update on LeadsPhase
    for each row
    execute procedure swap_hours_trig_func();

insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',1);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',2);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',3);
insert into LeadsPhase values ('manlyprogrammingtent233@gmail.com',4);
insert into LeadsPhase values ('manlyprogrammingtent233@gmail.com',5);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',6);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',7);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',8);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',9);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',10);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',11);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',12);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',13);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',14);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',15);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',16);
insert into LeadsPhase values ('combativesillyotter583@uvic.ca',17);
insert into LeadsPhase values ('seductivemanlydragon380@outlook.com',18);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',19);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',20);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',21);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',22);
insert into LeadsPhase values ('seductivemanlydragon380@outlook.com',23);
insert into LeadsPhase values ('seductivemanlydragon380@outlook.com',24);
insert into LeadsPhase values ('AJones119@gng.ca',25);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',26);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',27);
insert into LeadsPhase values ('blueprogrammingeagle654@gmail.com',28);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',29);
insert into LeadsPhase values ('combativesillyotter583@uvic.ca',30);
insert into LeadsPhase values ('blueseductivedesk329@shaw.ca',31);
insert into LeadsPhase values ('blueseductivedesk329@shaw.ca',32);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',33);
insert into LeadsPhase values ('blueseductivedesk329@shaw.ca',34);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',35);
insert into LeadsPhase values ('AJones119@gng.ca', 36);
insert into LeadsPhase values ('sillymadalligator388@shaw.ca',37);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',38);
insert into LeadsPhase values ('oldprogramminglizard201@uvic.ca',39);
insert into LeadsPhase values ('sillymadalligator388@shaw.ca',40);
insert into LeadsPhase values ('oldprogramminglizard201@uvic.ca', 41);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',42);
insert into LeadsPhase values ('sillymadalligator388@shaw.ca', 43);
insert into LeadsPhase values ('manlyprogrammingtent233@gmail.com',44);
insert into LeadsPhase values ('sillymadalligator388@shaw.ca', 45);
insert into LeadsPhase values ('ASingh708@gng.ca',46);
insert into LeadsPhase values ('madgrimduck072@uvic.ca',47);
insert into LeadsPhase values ('oldprogramminglizard201@uvic.ca',48);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',49);
insert into LeadsPhase values ('blueseductivedesk329@shaw.ca',50);
insert into LeadsPhase values ('manlyprogrammingtent233@gmail.com',51);
insert into LeadsPhase values ('spryjollypig342@hotmail.com',52);
insert into LeadsPhase values ('madgrimduck072@uvic.ca', 53);
insert into LeadsPhase values ('blueprogrammingeagle654@gmail.com',54);
insert into LeadsPhase values ('AJones119@gng.ca',55);
insert into LeadsPhase values ('madgrimduck072@uvic.ca', 56);
insert into LeadsPhase values ('ASingh708@gng.ca', 57);
insert into LeadsPhase values ('blueprogrammingeagle654@gmail.com', 58);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',59);
insert into LeadsPhase values ('seductivemanlydragon380@outlook.com',60);
insert into LeadsPhase values ('blueprogrammingeagle654@gmail.com',61);
insert into LeadsPhase values ('combativeassertivesheep998@gmail.com',62);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',63);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',64);
insert into LeadsPhase values ('blueprogrammingeagle654@gmail.com',65);
insert into LeadsPhase values ('redprogrammingpiano501@gmail.com',66);
insert into LeadsPhase values ('greymanlydragon077@hotmail.com',67);
insert into LeadsPhase values ('observantsprydragon009@uvic.ca',68);
insert into LeadsPhase values ('manlyprogrammingtent233@gmail.com',69);
insert into LeadsPhase values ('JWilson126@gng.ca',70);
insert into LeadsPhase values ('blueseductivedesk329@shaw.ca', 71);
insert into LeadsPhase values ('JWilson126@gng.ca', 72);
insert into LeadsPhase values ('manlyprogrammingtent233@gmail.com',73);
insert into LeadsPhase values ('programmingganglyeagle557@hotmail.com',74);

drop table LeadsCampaign cascade;
create table LeadsCampaign (
    email char(50),
    cid int,
    foreign key(email)
        references Members(email)
        on update cascade
        on delete set null,
    foreign key(cid) 
        references Campaigns(cid)
        on update cascade
        on delete set null
);

-- When a volunteer is assigned to a campaign, delete the old leader
create or replace function replace_campaign_leader_trig_func() returns trigger as
$replace_campaign_leader_trig$
    begin
        delete from LeadsCampaign
            where cid = NEW.cid;
        return NEW;
    end;
$replace_campaign_leader_trig$ language plpgsql;

-- Applies the above trigger to delete the old leader
drop trigger ReplaceLeader on LeadsCampaign;
create trigger ReplaceLeader
    before insert on LeadsCampaign
    for each row
    execute procedure replace_campaign_leader_trig_func();

-- Applies the triggers to update volunteer hours on insert, update, and deletion
drop trigger GiveVolunteerHours on LeadsCampaign;
create trigger GiveVolunteerHours
    after insert on LeadsCampaign
    for each row
    execute procedure update_hours_trig_func();

drop trigger TakeVolunteerHours on LeadsCampaign;
create trigger TakeVolunteerHours
    after delete on LeadsCampaign
    for each row
    execute procedure remove_hours_trig_func();

drop trigger SwapVolunteerHours on LeadsCampaign;
create trigger SwapVolunteerHours
    after update on LeadsCampaign
    for each row
    execute procedure swap_hours_trig_func();

insert into LeadsCampaign values ('OTaylor839@gng.ca', 1);
insert into LeadsCampaign values ('AJones119@gng.ca',2);
insert into LeadsCampaign values ('AJones119@gng.ca',3);
insert into LeadsCampaign values ('AJones119@gng.ca',4);
insert into LeadsCampaign values ('AJones119@gng.ca',5);

drop table UsesTransaction cascade;
create table UsesTransaction (
    tid int,
    phid int,
    foreign key(tid)
        references Transactions(tid)
        on update cascade
        on delete set null,
    foreign key(phid)
        references Phases(phid)
        on update cascade
        on delete set null
);

insert into UsesTransaction values (1,1);
insert into UsesTransaction values (2,1);
insert into UsesTransaction values (3,1);
insert into UsesTransaction values (4,2);
insert into UsesTransaction values (5,2);
insert into UsesTransaction values (6,2);
insert into UsesTransaction values (7,3);
insert into UsesTransaction values (8,3);
insert into UsesTransaction values (9,4);
insert into UsesTransaction values (10,4);
insert into UsesTransaction values (11,5);
insert into UsesTransaction values (12,5);
insert into UsesTransaction values (13,6);
insert into UsesTransaction values (14,6);
insert into UsesTransaction values (15,7);
insert into UsesTransaction values (16,7);
insert into UsesTransaction values (17,7);
insert into UsesTransaction values (18,8);
insert into UsesTransaction values (19,9);
insert into UsesTransaction values (20,9);
insert into UsesTransaction values (21,9);
insert into UsesTransaction values (22,10);
insert into UsesTransaction values (23,11);
insert into UsesTransaction values (24,11);
insert into UsesTransaction values (25,12);
insert into UsesTransaction values (26,13);
insert into UsesTransaction values (27,13);
insert into UsesTransaction values (28,13);
insert into UsesTransaction values (29,13);
insert into UsesTransaction values (30,14);
insert into UsesTransaction values (31,14);
insert into UsesTransaction values (32,14);
insert into UsesTransaction values (33,15);
insert into UsesTransaction values (34,16);
insert into UsesTransaction values (35,17);
insert into UsesTransaction values (36,18);
insert into UsesTransaction values (37,18);
insert into UsesTransaction values (38,18);
insert into UsesTransaction values (39,19);
insert into UsesTransaction values (40,19);
insert into UsesTransaction values (41,19);
insert into UsesTransaction values (42,20);
insert into UsesTransaction values (43,20);
insert into UsesTransaction values (44,21);
insert into UsesTransaction values (45,21);
insert into UsesTransaction values (46,22);
insert into UsesTransaction values (47,22);
insert into UsesTransaction values (48,22);
insert into UsesTransaction values (49,23);
insert into UsesTransaction values (50,23);
insert into UsesTransaction values (51,23);
insert into UsesTransaction values (52,24);
insert into UsesTransaction values (53,24);
insert into UsesTransaction values (54,24);
insert into UsesTransaction values (55,25);
insert into UsesTransaction values (56,25);
insert into UsesTransaction values (57,25);
insert into UsesTransaction values (58,26);
insert into UsesTransaction values (59,27);
insert into UsesTransaction values (60,27);
insert into UsesTransaction values (61,27);
insert into UsesTransaction values (62,27);
insert into UsesTransaction values (63,28);
insert into UsesTransaction values (64,28);
insert into UsesTransaction values (65,28);
insert into UsesTransaction values (66,28);
insert into UsesTransaction values (67,29);
insert into UsesTransaction values (68,29);
insert into UsesTransaction values (69,30);
insert into UsesTransaction values (70,31);
insert into UsesTransaction values (71,31);
insert into UsesTransaction values (72,31);
insert into UsesTransaction values (73,32);
insert into UsesTransaction values (74,32);
insert into UsesTransaction values (75,33);
insert into UsesTransaction values (76,33);
insert into UsesTransaction values (77,33);
insert into UsesTransaction values (78,34);
insert into UsesTransaction values (79,35);
insert into UsesTransaction values (80,35);
insert into UsesTransaction values (81,36);
insert into UsesTransaction values (82,37);
insert into UsesTransaction values (83,37);
insert into UsesTransaction values (84,37);
insert into UsesTransaction values (85,38);
insert into UsesTransaction values (86,38);
insert into UsesTransaction values (87,39);
insert into UsesTransaction values (88,39);
insert into UsesTransaction values (89,39);
insert into UsesTransaction values (90,39);
insert into UsesTransaction values (91,40);
insert into UsesTransaction values (92,40);
insert into UsesTransaction values (93,40);
insert into UsesTransaction values (94,41);
insert into UsesTransaction values (95,42);
insert into UsesTransaction values (96,42);
insert into UsesTransaction values (97,43);
insert into UsesTransaction values (98,44);
insert into UsesTransaction values (99,44);
insert into UsesTransaction values (100,44);
insert into UsesTransaction values (101,45);
insert into UsesTransaction values (102,45);
insert into UsesTransaction values (103,45);
insert into UsesTransaction values (104,46);
insert into UsesTransaction values (105,47);
insert into UsesTransaction values (106,48);
insert into UsesTransaction values (107,49);
insert into UsesTransaction values (108,50);
insert into UsesTransaction values (109,50);
insert into UsesTransaction values (110,50);
insert into UsesTransaction values (111,51);
insert into UsesTransaction values (112,52);
insert into UsesTransaction values (113,53);
insert into UsesTransaction values (114,54);
insert into UsesTransaction values (115,54);
insert into UsesTransaction values (116,55);
insert into UsesTransaction values (117,55);
insert into UsesTransaction values (118,56);
insert into UsesTransaction values (119,56);
insert into UsesTransaction values (120,57);
insert into UsesTransaction values (121,57);
insert into UsesTransaction values (122,58);
insert into UsesTransaction values (123,58);
insert into UsesTransaction values (124,58);
insert into UsesTransaction values (125,58);
insert into UsesTransaction values (126,59);
insert into UsesTransaction values (127,60);
insert into UsesTransaction values (128,61);
insert into UsesTransaction values (129,61);
insert into UsesTransaction values (130,61);
insert into UsesTransaction values (131,62);
insert into UsesTransaction values (132,62);
insert into UsesTransaction values (133,62);
insert into UsesTransaction values (134,63);
insert into UsesTransaction values (135,63);
insert into UsesTransaction values (136,64);
insert into UsesTransaction values (137,64);
insert into UsesTransaction values (138,65);
insert into UsesTransaction values (139,65);
insert into UsesTransaction values (140,66);
insert into UsesTransaction values (141,66);
insert into UsesTransaction values (142,66);
insert into UsesTransaction values (143,67);
insert into UsesTransaction values (144,67);
insert into UsesTransaction values (145,67);
insert into UsesTransaction values (146,68);
insert into UsesTransaction values (147,68);
insert into UsesTransaction values (148,68);
insert into UsesTransaction values (149,69);
insert into UsesTransaction values (150,70);
insert into UsesTransaction values (151,70);
insert into UsesTransaction values (152,70);
insert into UsesTransaction values (153,71);
insert into UsesTransaction values (154,71);
insert into UsesTransaction values (155,71);
insert into UsesTransaction values (156,72);
insert into UsesTransaction values (157,72);
insert into UsesTransaction values (158,72);
insert into UsesTransaction values (159,73);
insert into UsesTransaction values (160,73);
insert into UsesTransaction values (161,74);
insert into UsesTransaction values (162,74);
insert into UsesTransaction values (163,74);
