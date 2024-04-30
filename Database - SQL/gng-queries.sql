-- Justin Siu
-- V00976501

-- 1. Find the ids, phase name, budget of Campaign Phases that occur at the same time as a campaign they are not a part of.

drop view Query_1 cascade;
create view Query_1 as
select distinct phid, name, ph.budget, topic
from phases ph
cross join campaigns c
where ((ph.edate >= c.sdate and ph.sdate <= c.sdate) 
    or (c.edate >= ph.sdate and c.sdate <= ph.sdate))
    and not exists (
        select *
        from hasphase
        where phid = ph.phid
            and cid = c.cid);

-- 2. Find the topics, budget, and total cost of Campaigns that went over budget (excluding money made from Donations and Fundraising)

drop view Query_2 cascade;
create view Query_2 as
select distinct topic, budget, totalcost
from (
    select sum(amount) * -1 as totalcost, cid
    from transactions
    natural join usestransaction
    natural join hasphase
    where transactions.amount < 0
    group by cid
) as campaigncost
natural join campaigns
where budget < totalcost;

-- 3. Find the ids, start dates, and end dates of Campaign Phases who had a volunteer with a first name matching an employees, and also list the first name.

drop view Query_3 cascade;
create view Query_3 as
select distinct ph.phid, ph.sdate, ph.edate, fname, lname
from members
natural join volunteersphase
inner join phases ph
    on ph.phid = volunteersphase.phid
where members.fname in (
    select fname
    from employees
    natural join members
)
order by ph.phid;

-- 4. Find the average volunteer hours for a GNG Member that leads a Campaign Phase for the Campaigns with the longest Campaign Phases

drop view Query_4 cascade;
create view Query_4 as
select round(avg(vhours),2) as avghours
from members
where email in (
    select distinct email
    from campaigns
    natural join hasphase
    natural join leadsphase
    where cid = any(
        select distinct cid
        from phases 
        natural join hasphase
        where edate - sdate >= all(
            select edate - sdate
            from phases
        )
    )
);


-- 5. Find the email and name of the GNG Member who has the lowest average cost per Campaign Phase led, and provide the average cost.

drop view Query_5 cascade;
create view Query_5 as
select distinct email, fname, lname, avgc
from (
    select email, fname, lname, round(avg(totalcost),2) as avgc
    from members
    natural join leadsphase
    natural join (
        select sum(amount) * -1 as totalcost, phid
        from transactions
        natural join usestransaction
        where transactions.amount < 0
        group by phid
    ) as costperphase
    group by members.email
) as avgcost
where avgcost.avgc = (
    select min(avgc)
    from (
        select fname, lname, round(avg(totalcost),2) as avgc
        from members
        natural join leadsphase
        natural join (
            select sum(amount) * -1 as totalcost, phid
            from transactions
            natural join usestransaction
            where transactions.amount < 0
            group by phid
        ) as costperphase
        group by members.email
    ) as avgcost
);

-- drop view costperphase cascade;
-- create view costperphase as
-- select sum(amount) * -1 as totalcost, phid
-- from transactions
-- natural join usestransaction
-- where transactions.amount < 0
-- group by phid;
    
-- drop view avgcost cascade;
-- create view avgcost as
-- select fname, lname, round(avg(totalcost),2) as avgc
-- from members
-- natural join leadsphase
-- natural join costperphase
-- group by members.email;

-- 6. Find the id, city, location, and duration of phases with 6 or more volunteers (excluding the leader) or that were led by 'redprogrammingpiano501@gmail.com'

drop view Query_6 cascade;
create view Query_6 as
select *
from (
    (select phid, city, location, edate - sdate as duration
    from (
        select phases.phid, city, location, sdate, edate, count(volunteersphase.phid) as num
        from phases
        left outer join volunteersphase
            on phases.phid = volunteersphase.phid
        group by phases.phid
    ) as numvolunteers
    where num >= 6)
        union
    (select phases.phid, city, location, edate - sdate as duration
    from phases
    natural join leadsphase
    where leadsphase.email = 'redprogrammingpiano501@gmail.com')
) as main_query
order by phid;

-- 7. Find the email, volunteer hours, and campaign count of the GNG Members who have participated in more than 3 campaigns

drop view Query_7 cascade;
create view Query_7 as
select email, vhours, ccount
from (
    select email, count(distinct cid) as ccount
    from ((
        select email, cid
        from hasphase
        natural join volunteersphase
    ) union (
        select email, cid
        from leadsphase
        natural join hasphase
    ) union (
        select email, cid
        from volunteerscampaign
    ) union (
        select email, cid
        from leadscampaign
    )) as counts
    group by email
) as campaigncount
natural join members
where ccount > 3;

-- 8. Find the emails and start date of members who've led a phase for a campaign about 'BC Clearcutting' and who have a phone number beginning with 778

drop view Query_8 cascade;
create view Query_8 as
select email, sdate
from members m1
where exists(
    select *
    from members
    natural join leadsphase
    natural join hasphase
    inner join campaigns
        on campaigns.cid = hasphase.cid
    where m1.email = email
        and members.phone ~ '^778-\d{3}-\d{4}'
        and campaigns.topic = 'BC Clearcutting'
);

-- 9. Find the ids, cities, and locations of campaign phases not in Victoria, that have a budget larger than the average budget of an 'Info Booth' phase.

drop view Query_9 cascade;
create view Query_9 as
select *
from (
    (
        select phid, city, location, budget
        from phases
        where budget > (
            select avg(budget)
            from phases
            where name = 'Info Booth'
        )
    ) except (
        select phid, city, location, budget
        from phases
        where city = 'Victoria'
    )
) as main_data
order by phid;

-- 10. Find the names of GNG Members that are leading two or more overlapping campaign phases, and provide the ids for the campaign phases

drop view Query_10 cascade;
create view Query_10 as
select distinct fname, lname, ph1.phid
from members
natural join leadsphase l1
inner join leadsphase l2
    on l2.email = l1.email
    and l2.phid != l1.phid
inner join phases ph1
    on l1.phid = ph1.phid
inner join phases ph2
    on l2.phid = ph2.phid
where (ph1.edate >= ph2.sdate and ph1.sdate <= ph2.sdate) 
    or (ph2.edate >= ph1.sdate and ph2.sdate <= ph1.sdate) 
    and ph1.phid <> ph2.phid
order by lname;

-- 11. Find the name of donors who've donated over $50,000 and donated to a Campaign with 5 or more transactions for 'Door Prizes'

drop view Query_11 cascade;
create view Query_11 as
select distinct dname
from (
    select did, dname, cid, ndp
    from donors
    natural join makesdonation
    natural join donatescampaign
    natural join (
        select cid, count(*) as ndp
        from hasphase
        natural join usestransaction
        natural join transactions
        where reason = 'Door Prizes'
        group by cid
    ) as doorprizecount
) as donorsummary
where 60000 < (
    select sum(amount)
    from transactions
    natural join makesdonation
    where did = donorsummary.did
)
    and ndp >= 5;


