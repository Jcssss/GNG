-- Gives a table consisting of all transactions and the campaigns and phases that they are associated with
-- Used to assist with Development Phase 3
drop view transact_info cascade;
create view transact_info as
select t.tid, ut.phid, dc.cid as cid1, hph.cid as cid2, amount, dateof
from transactions t
left outer join usestransaction ut
    on t.tid = ut.tid
left outer join hasphase hph
    on ut.phid = hph.phid
left outer join donatescampaign dc
    on t.tid = dc.tid
;

-- Gives a table consisting of the total amount donated by each donor
drop view total_donated cascade;
create view total_donated as
select did, dname, sum(amount) as total
from donors
natural join makesdonation
natural join transactions t
left outer join donatescampaign dc
    on dc.tid = t.tid
group by did, dname;

-- Gives a table with the amount each donor has donated to a campaign
drop view donates_campaign cascade;
create view donates_campaign as
select did, cid, dname, email, sum(amount) as total
from donors
natural join makesdonation
natural join donatescampaign
natural join campaigns
natural join transactions
group by did, cid;

-- Gives a table consisting of all member history including volunteering and leading both phases and campaigns

drop view mem_history cascade;
create view mem_history as
select * 
from ((
    select m.email, ph.phid, cid, ph.sdate, ph.edate, 'Phase Volunteer' as event
    from members m
    natural join volunteersphase vph
    natural join hasphase
    inner join phases ph
        on ph.phid = vph.phid
) union (
    select m.email, ph.phid, cid, ph.sdate, ph.edate, 'Phase Leader' as event
    from members m
    natural join leadsphase lph
    natural join hasphase
    inner join phases ph
        on ph.phid = lph.phid
) union (
    select m.email, -1 as phid, c.cid, c.sdate, c.edate, 'Campaign Volunteer' as event
    from members m
    natural join volunteerscampaign vc
    inner join campaigns c
        on c.cid = vc.cid
) union (
    select m.email, -1 as phid, c.cid, c.sdate, c.edate, 'Campaign Leader' as event
    from members m
    natural join leadscampaign lc
    inner join campaigns c
        on c.cid = lc.cid
) union (
    select email, -1 as phid, -1 as cid, sdate, Null as edate, 'Member Joined' as event
    from members
)) as temp
order by sdate;

-- Gives a table consisting of the geographical data on GNG activities

drop view regional_data cascade;
create view regional_data as
select phid, cid, email, sdate, edate, city, location
from ((
    select *
    from phases ph
    natural join hasphase
    natural join volunteersphase
) union (
    select *
    from phases ph
    natural join hasphase
    natural join leadsphase
)) as reg_temp
order by city, sdate;

drop view regional_summary cascade;
create view regional_summary as
select city, count(distinct location) as locations, count(distinct phid) as phases, 
    count(distinct cid) as campaigns, count(distinct email) as volunteers
from regional_data
group by city;






