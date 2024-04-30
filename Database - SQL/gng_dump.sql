--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Ubuntu 10.23-0ubuntu0.18.04.2+esm1)
-- Dumped by pg_dump version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: campaigns_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.campaigns_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        update Campaigns
            set edate = sdate
            where edate < sdate;
        return null;
    end;
$$;


ALTER FUNCTION public.campaigns_trig_func() OWNER TO c370_s132;

--
-- Name: phases_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.phases_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        update Phases
            set edate = sdate
            where edate < sdate;
        return null;
    end;
$$;


ALTER FUNCTION public.phases_trig_func() OWNER TO c370_s132;

--
-- Name: remove_hours_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.remove_hours_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        update Members
            set vhours = vhours - 3
            where email = OLD.email;
        return null;
    end;
$$;


ALTER FUNCTION public.remove_hours_trig_func() OWNER TO c370_s132;

--
-- Name: replace_campaign_leader_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.replace_campaign_leader_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        delete from LeadsCampaign
            where cid = NEW.cid;
        return NEW;
    end;
$$;


ALTER FUNCTION public.replace_campaign_leader_trig_func() OWNER TO c370_s132;

--
-- Name: replace_phase_leader_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.replace_phase_leader_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        delete from LeadsPhase
            where phid = NEW.phid;
        return NEW;
    end;
$$;


ALTER FUNCTION public.replace_phase_leader_trig_func() OWNER TO c370_s132;

--
-- Name: swap_hours_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.swap_hours_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        update Members
            set vhours = vhours - 3
            where email = OLD.email;
        update Members
            set vhours = vhours + 3
            where email = NEW.email;
        return null;
    end;
$$;


ALTER FUNCTION public.swap_hours_trig_func() OWNER TO c370_s132;

--
-- Name: update_hours_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.update_hours_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        update Members
            set vhours = vhours + 3
            where email = NEW.email;
        return null;
    end;
$$;


ALTER FUNCTION public.update_hours_trig_func() OWNER TO c370_s132;

--
-- Name: vol_phase_trig_func(); Type: FUNCTION; Schema: public; Owner: c370_s132
--

CREATE FUNCTION public.vol_phase_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        update Members
            set vhours = vhours + 3
            where email = NEW.email;
        return null;
    end;
$$;


ALTER FUNCTION public.vol_phase_trig_func() OWNER TO c370_s132;

SET default_tablespace = '';

--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.campaigns (
    cid integer NOT NULL,
    sdate date,
    edate date,
    budget numeric(10,2),
    topic character(20),
    notes text DEFAULT ''::text,
    CONSTRAINT campaigns_budget_check CHECK ((budget >= (0)::numeric))
);


ALTER TABLE public.campaigns OWNER TO c370_s132;

--
-- Name: campaigns_cid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s132
--

CREATE SEQUENCE public.campaigns_cid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campaigns_cid_seq OWNER TO c370_s132;

--
-- Name: campaigns_cid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s132
--

ALTER SEQUENCE public.campaigns_cid_seq OWNED BY public.campaigns.cid;


--
-- Name: donates_campaign; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.donates_campaign AS
SELECT
    NULL::integer AS did,
    NULL::integer AS cid,
    NULL::character(40) AS dname,
    NULL::character(30) AS email,
    NULL::bigint AS total;


ALTER TABLE public.donates_campaign OWNER TO c370_s132;

--
-- Name: donatescampaign; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.donatescampaign (
    tid integer,
    cid integer
);


ALTER TABLE public.donatescampaign OWNER TO c370_s132;

--
-- Name: donors; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.donors (
    did integer NOT NULL,
    cfname character(20),
    clname character(20),
    dname character(40),
    email character(30),
    notes text DEFAULT ''::text
);


ALTER TABLE public.donors OWNER TO c370_s132;

--
-- Name: donors_did_seq; Type: SEQUENCE; Schema: public; Owner: c370_s132
--

CREATE SEQUENCE public.donors_did_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donors_did_seq OWNER TO c370_s132;

--
-- Name: donors_did_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s132
--

ALTER SEQUENCE public.donors_did_seq OWNED BY public.donors.did;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.employees (
    email character(50) NOT NULL,
    salary numeric(10,2),
    job character(30),
    CONSTRAINT employees_salary_check CHECK ((salary >= (0)::numeric))
);


ALTER TABLE public.employees OWNER TO c370_s132;

--
-- Name: hasphase; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.hasphase (
    cid integer,
    phid integer
);


ALTER TABLE public.hasphase OWNER TO c370_s132;

--
-- Name: leadscampaign; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.leadscampaign (
    email character(50),
    cid integer
);


ALTER TABLE public.leadscampaign OWNER TO c370_s132;

--
-- Name: leadsphase; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.leadsphase (
    email character(50),
    phid integer
);


ALTER TABLE public.leadsphase OWNER TO c370_s132;

--
-- Name: makesdonation; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.makesdonation (
    did integer,
    tid integer
);


ALTER TABLE public.makesdonation OWNER TO c370_s132;

--
-- Name: members; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.members (
    email character(50) NOT NULL,
    phone character(12),
    fname character(20),
    lname character(20),
    sdate date,
    vhours integer DEFAULT 0,
    notes text DEFAULT ''::text,
    CONSTRAINT members_email_check CHECK ((email ~~ '%@%.%'::text)),
    CONSTRAINT members_phone_check CHECK ((phone ~ '\d{3}-\d{3}-\d{4}'::text)),
    CONSTRAINT members_vhours_check CHECK ((vhours >= 0))
);


ALTER TABLE public.members OWNER TO c370_s132;

--
-- Name: phases; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.phases (
    phid integer NOT NULL,
    sdate date,
    edate date,
    city character(20),
    location character(30),
    name character(20),
    budget numeric(10,2),
    notes text DEFAULT ''::text,
    CONSTRAINT phases_budget_check CHECK ((budget >= (0)::numeric))
);


ALTER TABLE public.phases OWNER TO c370_s132;

--
-- Name: volunteerscampaign; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.volunteerscampaign (
    email character(50),
    cid integer,
    job character(30)
);


ALTER TABLE public.volunteerscampaign OWNER TO c370_s132;

--
-- Name: volunteersphase; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.volunteersphase (
    email character(50),
    phid integer
);


ALTER TABLE public.volunteersphase OWNER TO c370_s132;

--
-- Name: mem_history; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.mem_history AS
 SELECT temp.email,
    temp.phid,
    temp.cid,
    temp.sdate,
    temp.edate,
    temp.event
   FROM ( SELECT m.email,
            ph.phid,
            hasphase.cid,
            ph.sdate,
            ph.edate,
            'Phase Volunteer'::text AS event
           FROM (((public.members m
             JOIN public.volunteersphase vph USING (email))
             JOIN public.hasphase USING (phid))
             JOIN public.phases ph ON ((ph.phid = vph.phid)))
        UNION
         SELECT m.email,
            ph.phid,
            hasphase.cid,
            ph.sdate,
            ph.edate,
            'Phase Leader'::text AS event
           FROM (((public.members m
             JOIN public.leadsphase lph USING (email))
             JOIN public.hasphase USING (phid))
             JOIN public.phases ph ON ((ph.phid = lph.phid)))
        UNION
         SELECT m.email,
            '-1'::integer AS phid,
            c.cid,
            c.sdate,
            c.edate,
            'Campaign Volunteer'::text AS event
           FROM ((public.members m
             JOIN public.volunteerscampaign vc USING (email))
             JOIN public.campaigns c ON ((c.cid = vc.cid)))
        UNION
         SELECT m.email,
            '-1'::integer AS phid,
            c.cid,
            c.sdate,
            c.edate,
            'Campaign Leader'::text AS event
           FROM ((public.members m
             JOIN public.leadscampaign lc USING (email))
             JOIN public.campaigns c ON ((c.cid = lc.cid)))
        UNION
         SELECT members.email,
            '-1'::integer AS phid,
            '-1'::integer AS cid,
            members.sdate,
            NULL::date AS edate,
            'Member Joined'::text AS event
           FROM public.members) temp
  ORDER BY temp.sdate;


ALTER TABLE public.mem_history OWNER TO c370_s132;

--
-- Name: phases_phid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s132
--

CREATE SEQUENCE public.phases_phid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phases_phid_seq OWNER TO c370_s132;

--
-- Name: phases_phid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s132
--

ALTER SEQUENCE public.phases_phid_seq OWNED BY public.phases.phid;


--
-- Name: query_1; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_1 AS
 SELECT DISTINCT ph.phid,
    ph.name,
    ph.budget,
    c.topic
   FROM (public.phases ph
     CROSS JOIN public.campaigns c)
  WHERE ((((ph.edate >= c.sdate) AND (ph.sdate <= c.sdate)) OR ((c.edate >= ph.sdate) AND (c.sdate <= ph.sdate))) AND (NOT (EXISTS ( SELECT hasphase.cid,
            hasphase.phid
           FROM public.hasphase
          WHERE ((hasphase.phid = ph.phid) AND (hasphase.cid = c.cid))))));


ALTER TABLE public.query_1 OWNER TO c370_s132;

--
-- Name: query_10; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_10 AS
 SELECT DISTINCT members.fname,
    members.lname,
    ph1.phid
   FROM ((((public.members
     JOIN public.leadsphase l1 USING (email))
     JOIN public.leadsphase l2 ON (((l2.email = l1.email) AND (l2.phid <> l1.phid))))
     JOIN public.phases ph1 ON ((l1.phid = ph1.phid)))
     JOIN public.phases ph2 ON ((l2.phid = ph2.phid)))
  WHERE (((ph1.edate >= ph2.sdate) AND (ph1.sdate <= ph2.sdate)) OR ((ph2.edate >= ph1.sdate) AND (ph2.sdate <= ph1.sdate) AND (ph1.phid <> ph2.phid)))
  ORDER BY members.lname;


ALTER TABLE public.query_10 OWNER TO c370_s132;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.transactions (
    tid integer NOT NULL,
    amount integer,
    dateof date,
    reason character(30),
    notes text DEFAULT ''::text
);


ALTER TABLE public.transactions OWNER TO c370_s132;

--
-- Name: usestransaction; Type: TABLE; Schema: public; Owner: c370_s132
--

CREATE TABLE public.usestransaction (
    tid integer,
    phid integer
);


ALTER TABLE public.usestransaction OWNER TO c370_s132;

--
-- Name: query_11; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_11 AS
 SELECT DISTINCT donorsummary.dname
   FROM ( SELECT donors.did,
            donors.dname,
            donatescampaign.cid,
            doorprizecount.ndp
           FROM (((public.donors
             JOIN public.makesdonation USING (did))
             JOIN public.donatescampaign USING (tid))
             JOIN ( SELECT hasphase.cid,
                    count(*) AS ndp
                   FROM ((public.hasphase
                     JOIN public.usestransaction USING (phid))
                     JOIN public.transactions USING (tid))
                  WHERE (transactions.reason = 'Door Prizes'::bpchar)
                  GROUP BY hasphase.cid) doorprizecount USING (cid))) donorsummary
  WHERE ((60000 < ( SELECT sum(transactions.amount) AS sum
           FROM (public.transactions
             JOIN public.makesdonation USING (tid))
          WHERE (makesdonation.did = donorsummary.did))) AND (donorsummary.ndp >= 5));


ALTER TABLE public.query_11 OWNER TO c370_s132;

--
-- Name: query_2; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_2 AS
 SELECT DISTINCT campaigns.topic,
    campaigns.budget,
    campaigncost.totalcost
   FROM (( SELECT (sum(transactions.amount) * '-1'::integer) AS totalcost,
            hasphase.cid
           FROM ((public.transactions
             JOIN public.usestransaction USING (tid))
             JOIN public.hasphase USING (phid))
          WHERE (transactions.amount < 0)
          GROUP BY hasphase.cid) campaigncost
     JOIN public.campaigns USING (cid))
  WHERE (campaigns.budget < (campaigncost.totalcost)::numeric);


ALTER TABLE public.query_2 OWNER TO c370_s132;

--
-- Name: query_3; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_3 AS
 SELECT DISTINCT ph.phid,
    ph.sdate,
    ph.edate,
    members.fname,
    members.lname
   FROM ((public.members
     JOIN public.volunteersphase USING (email))
     JOIN public.phases ph ON ((ph.phid = volunteersphase.phid)))
  WHERE (members.fname IN ( SELECT members_1.fname
           FROM (public.employees
             JOIN public.members members_1 USING (email))))
  ORDER BY ph.phid;


ALTER TABLE public.query_3 OWNER TO c370_s132;

--
-- Name: query_4; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_4 AS
 SELECT round(avg(members.vhours), 2) AS avghours
   FROM public.members
  WHERE (members.email IN ( SELECT DISTINCT leadsphase.email
           FROM ((public.campaigns
             JOIN public.hasphase USING (cid))
             JOIN public.leadsphase USING (phid))
          WHERE (campaigns.cid IN ( SELECT DISTINCT hasphase_1.cid
                   FROM (public.phases
                     JOIN public.hasphase hasphase_1 USING (phid))
                  WHERE ((phases.edate - phases.sdate) >= ALL ( SELECT (phases_1.edate - phases_1.sdate)
                           FROM public.phases phases_1))))));


ALTER TABLE public.query_4 OWNER TO c370_s132;

--
-- Name: query_5; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_5 AS
SELECT
    NULL::character(50) AS email,
    NULL::character(20) AS fname,
    NULL::character(20) AS lname,
    NULL::numeric AS avgc;


ALTER TABLE public.query_5 OWNER TO c370_s132;

--
-- Name: query_6; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_6 AS
SELECT
    NULL::integer AS phid,
    NULL::character(20) AS city,
    NULL::character(30) AS location,
    NULL::integer AS duration;


ALTER TABLE public.query_6 OWNER TO c370_s132;

--
-- Name: query_7; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_7 AS
 SELECT campaigncount.email,
    members.vhours,
    campaigncount.ccount
   FROM (( SELECT counts.email,
            count(DISTINCT counts.cid) AS ccount
           FROM ( SELECT volunteersphase.email,
                    hasphase.cid
                   FROM (public.hasphase
                     JOIN public.volunteersphase USING (phid))
                UNION
                 SELECT leadsphase.email,
                    hasphase.cid
                   FROM (public.leadsphase
                     JOIN public.hasphase USING (phid))
                UNION
                 SELECT volunteerscampaign.email,
                    volunteerscampaign.cid
                   FROM public.volunteerscampaign
                UNION
                 SELECT leadscampaign.email,
                    leadscampaign.cid
                   FROM public.leadscampaign) counts
          GROUP BY counts.email) campaigncount
     JOIN public.members USING (email))
  WHERE (campaigncount.ccount > 3);


ALTER TABLE public.query_7 OWNER TO c370_s132;

--
-- Name: query_8; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_8 AS
 SELECT m1.email,
    m1.sdate
   FROM public.members m1
  WHERE (EXISTS ( SELECT leadsphase.phid,
            members.email,
            members.phone,
            members.fname,
            members.lname,
            members.sdate,
            members.vhours,
            members.notes,
            hasphase.cid,
            campaigns.cid,
            campaigns.sdate,
            campaigns.edate,
            campaigns.budget,
            campaigns.topic,
            campaigns.notes
           FROM (((public.members
             JOIN public.leadsphase USING (email))
             JOIN public.hasphase USING (phid))
             JOIN public.campaigns ON ((campaigns.cid = hasphase.cid)))
          WHERE ((m1.email = members.email) AND (members.phone ~ '^778-\d{3}-\d{4}'::text) AND (campaigns.topic = 'BC Clearcutting'::bpchar))));


ALTER TABLE public.query_8 OWNER TO c370_s132;

--
-- Name: query_9; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.query_9 AS
 SELECT main_data.phid,
    main_data.city,
    main_data.location,
    main_data.budget
   FROM ( SELECT phases.phid,
            phases.city,
            phases.location,
            phases.budget
           FROM public.phases
          WHERE (phases.budget > ( SELECT avg(phases_1.budget) AS avg
                   FROM public.phases phases_1
                  WHERE (phases_1.name = 'Info Booth'::bpchar)))
        EXCEPT
         SELECT phases.phid,
            phases.city,
            phases.location,
            phases.budget
           FROM public.phases
          WHERE (phases.city = 'Victoria'::bpchar)) main_data
  ORDER BY main_data.phid;


ALTER TABLE public.query_9 OWNER TO c370_s132;

--
-- Name: regional_data; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.regional_data AS
 SELECT reg_temp.phid,
    reg_temp.cid,
    reg_temp.email,
    reg_temp.sdate,
    reg_temp.edate,
    reg_temp.city,
    reg_temp.location
   FROM ( SELECT ph.phid,
            ph.sdate,
            ph.edate,
            ph.city,
            ph.location,
            ph.name,
            ph.budget,
            ph.notes,
            hasphase.cid,
            volunteersphase.email
           FROM ((public.phases ph
             JOIN public.hasphase USING (phid))
             JOIN public.volunteersphase USING (phid))
        UNION
         SELECT ph.phid,
            ph.sdate,
            ph.edate,
            ph.city,
            ph.location,
            ph.name,
            ph.budget,
            ph.notes,
            hasphase.cid,
            leadsphase.email
           FROM ((public.phases ph
             JOIN public.hasphase USING (phid))
             JOIN public.leadsphase USING (phid))) reg_temp
  ORDER BY reg_temp.city, reg_temp.sdate;


ALTER TABLE public.regional_data OWNER TO c370_s132;

--
-- Name: regional_summary; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.regional_summary AS
 SELECT regional_data.city,
    count(DISTINCT regional_data.location) AS locations,
    count(DISTINCT regional_data.phid) AS phases,
    count(DISTINCT regional_data.cid) AS campaigns,
    count(DISTINCT regional_data.email) AS volunteers
   FROM public.regional_data
  GROUP BY regional_data.city;


ALTER TABLE public.regional_summary OWNER TO c370_s132;

--
-- Name: total_donated; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.total_donated AS
 SELECT donors.did,
    donors.dname,
    sum(t.amount) AS sum
   FROM (((public.donors
     JOIN public.makesdonation USING (did))
     JOIN public.transactions t USING (notes, tid))
     LEFT JOIN public.donatescampaign dc ON ((dc.tid = t.tid)))
  GROUP BY donors.did, donors.dname;


ALTER TABLE public.total_donated OWNER TO c370_s132;

--
-- Name: transact_info; Type: VIEW; Schema: public; Owner: c370_s132
--

CREATE VIEW public.transact_info AS
 SELECT t.tid,
    ut.phid,
    dc.cid AS cid1,
    hph.cid AS cid2,
    t.amount,
    t.dateof
   FROM (((public.transactions t
     LEFT JOIN public.usestransaction ut ON ((t.tid = ut.tid)))
     LEFT JOIN public.hasphase hph ON ((ut.phid = hph.phid)))
     LEFT JOIN public.donatescampaign dc ON ((t.tid = dc.tid)));


ALTER TABLE public.transact_info OWNER TO c370_s132;

--
-- Name: transactions_tid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s132
--

CREATE SEQUENCE public.transactions_tid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_tid_seq OWNER TO c370_s132;

--
-- Name: transactions_tid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s132
--

ALTER SEQUENCE public.transactions_tid_seq OWNED BY public.transactions.tid;


--
-- Name: campaigns cid; Type: DEFAULT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN cid SET DEFAULT nextval('public.campaigns_cid_seq'::regclass);


--
-- Name: donors did; Type: DEFAULT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.donors ALTER COLUMN did SET DEFAULT nextval('public.donors_did_seq'::regclass);


--
-- Name: phases phid; Type: DEFAULT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.phases ALTER COLUMN phid SET DEFAULT nextval('public.phases_phid_seq'::regclass);


--
-- Name: transactions tid; Type: DEFAULT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.transactions ALTER COLUMN tid SET DEFAULT nextval('public.transactions_tid_seq'::regclass);


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.campaigns (cid, sdate, edate, budget, topic, notes) FROM stdin;
1	2021-03-02	2021-03-30	10000.00	BC Wolf Cull        	
2	2021-01-21	2021-03-22	3500.00	BC Pesticide Usage  	
3	2022-12-20	2023-02-27	4500.00	BC Water Pollution  	
4	2024-08-16	2024-12-12	6700.00	Global Warming      	
5	2023-01-21	2023-01-21	8000.00	BC Clearcutting     	
\.


--
-- Data for Name: donatescampaign; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.donatescampaign (tid, cid) FROM stdin;
164	1
165	1
166	2
167	2
168	3
169	3
170	3
171	4
172	4
173	4
174	5
\.


--
-- Data for Name: donors; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.donors (did, cfname, clname, dname, email, notes) FROM stdin;
1	Chloe               	Tong                	Iron Jaw Inc.                           	ctong@ironjaw.ca              	
2	Albert              	Reginald            	Timeless Bard                           	albertreginald@tbard.ca       	
3	Ivan                	Shephard            	Ivan Shephard                           	ivanshep380@gmail.com         	
4	Marvin              	Stewart             	MV Stairs                               	marvinst@mvstairs.com         	
5	Tanya               	Brown               	Tanya Brown Enterprises                 	info@tbrown.ca                	
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.employees (email, salary, job) FROM stdin;
OTaylor839@gng.ca                                 	20100.00	Director                      
ASingh708@gng.ca                                  	12400.00	Accountant                    
AJones119@gng.ca                                  	12600.00	Campaign Manager              
JWilson126@gng.ca                                 	10700.00	Public Relations Manager      
\.


--
-- Data for Name: hasphase; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.hasphase (cid, phid) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
2	7
2	8
2	9
2	10
2	11
2	12
2	13
2	14
2	15
2	16
2	17
2	18
2	19
2	20
2	21
3	22
3	23
3	24
3	25
3	26
3	27
3	28
3	29
3	30
3	31
3	32
3	33
3	34
3	35
3	36
3	37
4	38
4	39
4	40
4	41
4	42
4	43
4	44
4	45
4	46
4	47
4	48
4	49
4	50
4	51
4	52
4	53
4	54
4	55
4	56
4	57
4	58
4	59
4	60
5	61
5	62
5	63
5	64
5	65
5	66
5	67
5	68
5	69
5	70
5	71
5	72
5	73
5	74
\.


--
-- Data for Name: leadscampaign; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.leadscampaign (email, cid) FROM stdin;
OTaylor839@gng.ca                                 	1
AJones119@gng.ca                                  	2
AJones119@gng.ca                                  	3
AJones119@gng.ca                                  	4
AJones119@gng.ca                                  	5
\.


--
-- Data for Name: leadsphase; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.leadsphase (email, phid) FROM stdin;
redprogrammingpiano501@gmail.com                  	1
combativeassertivesheep998@gmail.com              	2
greymanlydragon077@hotmail.com                    	3
manlyprogrammingtent233@gmail.com                 	4
manlyprogrammingtent233@gmail.com                 	5
combativeassertivesheep998@gmail.com              	6
programmingganglyeagle557@hotmail.com             	7
greymanlydragon077@hotmail.com                    	8
greymanlydragon077@hotmail.com                    	9
programmingganglyeagle557@hotmail.com             	10
greymanlydragon077@hotmail.com                    	11
programmingganglyeagle557@hotmail.com             	12
programmingganglyeagle557@hotmail.com             	13
combativeassertivesheep998@gmail.com              	14
combativeassertivesheep998@gmail.com              	15
redprogrammingpiano501@gmail.com                  	16
combativesillyotter583@uvic.ca                    	17
seductivemanlydragon380@outlook.com               	18
combativeassertivesheep998@gmail.com              	19
greymanlydragon077@hotmail.com                    	20
redprogrammingpiano501@gmail.com                  	21
greymanlydragon077@hotmail.com                    	22
seductivemanlydragon380@outlook.com               	23
seductivemanlydragon380@outlook.com               	24
AJones119@gng.ca                                  	25
greymanlydragon077@hotmail.com                    	26
redprogrammingpiano501@gmail.com                  	27
blueprogrammingeagle654@gmail.com                 	28
programmingganglyeagle557@hotmail.com             	29
combativesillyotter583@uvic.ca                    	30
blueseductivedesk329@shaw.ca                      	31
blueseductivedesk329@shaw.ca                      	32
programmingganglyeagle557@hotmail.com             	33
blueseductivedesk329@shaw.ca                      	34
combativeassertivesheep998@gmail.com              	35
AJones119@gng.ca                                  	36
sillymadalligator388@shaw.ca                      	37
greymanlydragon077@hotmail.com                    	38
oldprogramminglizard201@uvic.ca                   	39
sillymadalligator388@shaw.ca                      	40
oldprogramminglizard201@uvic.ca                   	41
redprogrammingpiano501@gmail.com                  	42
sillymadalligator388@shaw.ca                      	43
manlyprogrammingtent233@gmail.com                 	44
sillymadalligator388@shaw.ca                      	45
ASingh708@gng.ca                                  	46
madgrimduck072@uvic.ca                            	47
oldprogramminglizard201@uvic.ca                   	48
programmingganglyeagle557@hotmail.com             	49
blueseductivedesk329@shaw.ca                      	50
manlyprogrammingtent233@gmail.com                 	51
spryjollypig342@hotmail.com                       	52
madgrimduck072@uvic.ca                            	53
blueprogrammingeagle654@gmail.com                 	54
AJones119@gng.ca                                  	55
madgrimduck072@uvic.ca                            	56
ASingh708@gng.ca                                  	57
blueprogrammingeagle654@gmail.com                 	58
redprogrammingpiano501@gmail.com                  	59
seductivemanlydragon380@outlook.com               	60
blueprogrammingeagle654@gmail.com                 	61
combativeassertivesheep998@gmail.com              	62
redprogrammingpiano501@gmail.com                  	63
programmingganglyeagle557@hotmail.com             	64
blueprogrammingeagle654@gmail.com                 	65
redprogrammingpiano501@gmail.com                  	66
greymanlydragon077@hotmail.com                    	67
observantsprydragon009@uvic.ca                    	68
manlyprogrammingtent233@gmail.com                 	69
JWilson126@gng.ca                                 	70
blueseductivedesk329@shaw.ca                      	71
JWilson126@gng.ca                                 	72
manlyprogrammingtent233@gmail.com                 	73
programmingganglyeagle557@hotmail.com             	74
\.


--
-- Data for Name: makesdonation; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.makesdonation (did, tid) FROM stdin;
1	164
2	165
3	166
3	167
4	168
4	169
5	170
5	171
5	172
1	173
2	174
1	175
2	176
3	177
4	178
5	179
2	180
3	181
4	182
5	183
3	184
1	185
4	186
5	187
5	188
1	189
2	190
4	191
3	192
3	193
1	194
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.members (email, phone, fname, lname, sdate, vhours, notes) FROM stdin;
smallviolentwalrus685@shaw.ca                     	534-419-1437	Albert              	Samuel              	2021-10-21	0	
agilehandsomeseal902@gmail.com                    	722-543-0901	Alex                	Argon               	2019-11-17	0	
test@test.com                                     	722-543-0901	Test                	Test                	2019-11-17	0	
combativesillyotter583@uvic.ca                    	534-042-1247	Danah               	Wilson              	2020-07-28	57	
sillymadalligator388@shaw.ca                      	778-964-1279	Omar                	Wilson              	2020-05-25	51	
oldprogramminglizard201@uvic.ca                   	637-533-7959	Jim                 	Lim                 	2020-08-05	56	
spryjollypig342@hotmail.com                       	534-602-9655	Jasmine             	Robson              	2024-02-02	6	
madgrimduck072@uvic.ca                            	534-752-6817	Joe                 	Lim                 	2023-09-22	27	
ASingh708@gng.ca                                  	250-119-2194	Amanda              	Singh               	2020-04-16	9	
seductivemanlydragon380@outlook.com               	637-727-2674	Maggie              	Lim                 	2020-12-03	118	
combativeassertivesheep998@gmail.com              	637-338-3957	Robin               	Lim                 	2020-06-24	42	
blueprogrammingeagle654@gmail.com                 	778-709-1720	Jim                 	Zhang               	2020-03-31	61	
redprogrammingpiano501@gmail.com                  	534-696-2968	Sam                 	Singh               	2020-09-13	60	
greymanlydragon077@hotmail.com                    	637-949-7158	Amanda              	Smith               	2020-05-13	69	
observantsprydragon009@uvic.ca                    	778-428-0159	Alfred              	McDougal            	2022-09-09	194	
blueseductivedesk329@shaw.ca                      	637-331-2146	Omar                	Wilson              	2020-12-23	312	
JWilson126@gng.ca                                 	778-466-6343	Jim                 	Wilson              	2024-07-02	26	
manlyprogrammingtent233@gmail.com                 	250-778-4968	Richard             	Walt                	2020-04-20	178	
programmingganglyeagle557@hotmail.com             	637-523-7224	Ally                	Stent               	2020-07-27	494	
OTaylor839@gng.ca                                 	778-850-6614	Omar                	Taylor              	2020-04-23	71	
AJones119@gng.ca                                  	534-828-1031	Amanda              	Jones               	2021-01-26	26	
\.


--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.phases (phid, sdate, edate, city, location, name, budget, notes) FROM stdin;
1	2021-03-02	2021-03-03	Victoria            	Mayfair Mall                  	Fundraising Dinner  	900.00	
2	2021-03-03	2021-03-09	Victoria            	Mayfair Mall                  	Spin the Wheel Booth	200.00	
3	2021-03-09	2021-03-13	Victoria            	Inner Harbour                 	Flyer Distribution  	1300.00	
4	2021-03-17	2021-03-19	Vancouver           	University of British Columbia	Trivia Booth        	800.00	
5	2021-03-18	2021-03-24	Victoria            	Tilicum Mall                  	Info Booth          	1300.00	
6	2021-03-28	2021-03-30	Vancouver           	Richmond Mall                 	Bottle Drive        	1050.00	
7	2021-01-21	2021-01-25	Vancouver           	Richmond Mall                 	Info Booth          	1400.00	
8	2021-01-24	2021-01-30	Nanaimo             	The Bastion                   	Spin the Wheel Booth	150.00	
9	2021-01-29	2021-02-01	Vancouver           	Metrotown                     	Info Booth          	850.00	
10	2021-01-31	2021-02-06	Vancouver           	Stanley Park                  	Info Booth          	1300.00	
11	2021-02-06	2021-02-11	Victoria            	University of Victoria        	Spin the Wheel Booth	550.00	
12	2021-02-11	2021-02-16	Victoria            	Warf Street                   	Info Booth          	200.00	
13	2021-02-18	2021-02-23	Victoria            	University of Victoria        	Flyer Distribution  	1150.00	
14	2021-02-22	2021-02-23	Victoria            	Inner Harbour                 	Flyer Distribution  	800.00	
15	2021-02-22	2021-02-27	Victoria            	University of Victoria        	Flyer Distribution  	550.00	
16	2021-02-24	2021-03-01	Vancouver           	University of British Columbia	Info Booth          	100.00	
17	2021-02-23	2021-03-03	Nanaimo             	Harbourfront Walkway          	Trivia Booth        	550.00	
18	2021-03-07	2021-03-10	Victoria            	Tilicum Mall                  	Spin the Wheel Booth	500.00	
19	2021-03-07	2021-03-10	Victoria            	Tilicum Mall                  	Trivia Booth        	750.00	
20	2021-03-17	2021-03-21	Vancouver           	Vancouver City Centre         	Info Booth          	1200.00	
21	2021-03-21	2021-03-22	Victoria            	Royal BC Museum               	Flyer Distribution  	150.00	
22	2022-12-20	2022-12-23	Vancouver           	Stanley Park                  	Trivia Booth        	1100.00	
23	2022-12-23	2022-12-27	Vancouver           	University of British Columbia	Trivia Booth        	150.00	
24	2022-12-26	2022-12-30	Victoria            	Mayfair Mall                  	Flyer Distribution  	200.00	
25	2022-12-27	2022-12-28	Victoria            	Parliament Building           	Fundraising Dinner  	300.00	
26	2022-12-31	2023-01-02	Vancouver           	Stanley Park                  	Trivia Booth        	600.00	
27	2023-01-02	2023-01-03	Victoria            	Inner Harbour                 	Flyer Distribution  	200.00	
28	2023-01-07	2023-01-13	Tofino              	Chesterman Beach              	Spin the Wheel Booth	750.00	
29	2023-01-15	2023-01-20	Victoria            	Warf Street                   	Trivia Booth        	1050.00	
30	2023-01-23	2023-01-27	Vancouver           	Stanley Park                  	Spin the Wheel Booth	250.00	
31	2023-01-24	2023-01-28	Victoria            	Royal BC Museum               	Spin the Wheel Booth	600.00	
32	2023-02-01	2023-02-06	Vancouver           	University of British Columbia	Info Booth          	1150.00	
33	2023-02-06	2023-02-07	Tofino              	Chesterman Beach              	Fundraising Dinner  	1050.00	
34	2023-02-10	2023-02-14	Nanaimo             	Harbourfront Walkway          	Spin the Wheel Booth	700.00	
35	2023-02-14	2023-02-17	Victoria            	University of Victoria        	Trivia Booth        	1350.00	
36	2023-02-22	2023-02-26	Vancouver           	Vancouver Farmers Market      	Flyer Distribution  	1200.00	
37	2023-02-26	2023-02-27	Tofino              	Tonquin Park                  	Spin the Wheel Booth	600.00	
38	2024-08-16	2024-08-20	Vancouver           	Metrotown                     	Spin the Wheel Booth	350.00	
39	2024-08-24	2024-08-29	Victoria            	Uptown                        	Flyer Distribution  	1350.00	
40	2024-08-29	2024-09-01	Vancouver           	University of British Columbia	Spin the Wheel Booth	450.00	
41	2024-08-30	2024-09-02	Victoria            	Parliament Building           	Spin the Wheel Booth	1150.00	
42	2024-08-31	2024-09-04	Victoria            	University of Victoria        	Spin the Wheel Booth	850.00	
43	2024-09-02	2024-09-04	Victoria            	University of Victoria        	Trivia Booth        	1250.00	
44	2024-09-04	2024-09-10	Victoria            	Mayfair Mall                  	Spin the Wheel Booth	800.00	
45	2024-09-10	2024-09-14	Victoria            	University of Victoria        	Spin the Wheel Booth	1450.00	
46	2024-09-12	2024-09-17	Victoria            	Inner Harbour                 	Trivia Booth        	1050.00	
47	2024-09-23	2024-09-25	Tofino              	Tonquin Park                  	Trivia Booth        	650.00	
48	2024-09-25	2024-09-29	Victoria            	Butchart Gardens              	Trivia Booth        	250.00	
49	2024-10-02	2024-10-06	Nanaimo             	Harbourfront Walkway          	Trivia Booth        	650.00	
50	2024-10-03	2024-10-08	Victoria            	Tilicum Mall                  	Spin the Wheel Booth	800.00	
51	2024-10-15	2024-10-19	Vancouver           	Granville Island              	Bottle Drive        	850.00	
52	2024-10-26	2024-10-31	Victoria            	Royal BC Museum               	Info Booth          	1050.00	
53	2024-10-31	2024-11-05	Vancouver           	Metrotown                     	Flyer Distribution  	200.00	
54	2024-11-04	2024-11-08	Victoria            	Tilicum Mall                  	Trivia Booth        	900.00	
55	2024-11-07	2024-11-10	Victoria            	Parliament Building           	Info Booth          	1200.00	
56	2024-11-10	2024-11-15	Victoria            	Royal BC Museum               	Trivia Booth        	250.00	
57	2024-11-15	2024-11-19	Victoria            	Warf Street                   	Flyer Distribution  	1150.00	
58	2024-11-25	2024-11-29	Victoria            	Warf Street                   	Spin the Wheel Booth	700.00	
59	2024-12-04	2024-12-10	Victoria            	Royal BC Museum               	Spin the Wheel Booth	400.00	
60	2024-12-07	2024-12-12	Victoria            	Parliament Building           	Flyer Distribution  	100.00	
61	2023-01-21	2023-01-25	Vancouver           	Vancouver Farmers Market      	Info Booth          	100.00	
62	2023-01-24	2023-01-29	Victoria            	Mayfair Mall                  	Info Booth          	500.00	
63	2023-01-28	2023-01-30	Victoria            	Butchart Gardens              	Bottle Drive        	250.00	
64	2023-01-28	2023-02-01	Vancouver           	Granville Island              	Trivia Booth        	1200.00	
65	2023-01-30	2023-02-05	Victoria            	Parliament Building           	Spin the Wheel Booth	700.00	
66	2023-02-07	2023-02-12	Vancouver           	Metrotown                     	Flyer Distribution  	800.00	
67	2023-02-16	2023-02-22	Victoria            	Royal BC Museum               	Spin the Wheel Booth	750.00	
68	2023-02-22	2023-02-24	Vancouver           	Vancouver City Centre         	Trivia Booth        	750.00	
69	2023-02-21	2023-02-24	Victoria            	Uptown                        	Trivia Booth        	1000.00	
70	2023-03-01	2023-03-05	Victoria            	Mayfair Mall                  	Spin the Wheel Booth	1400.00	
71	2023-03-04	2023-03-10	Vancouver           	University of British Columbia	Spin the Wheel Booth	350.00	
72	2023-03-13	2023-03-16	Victoria            	Uptown                        	Trivia Booth        	850.00	
73	2023-03-15	2023-03-21	Victoria            	Royal BC Museum               	Spin the Wheel Booth	1300.00	
74	2023-03-23	2023-03-24	Victoria            	Uptown                        	Spin the Wheel Booth	1100.00	
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.transactions (tid, amount, dateof, reason, notes) FROM stdin;
1	-190	2021-03-02	Maintenance Fees              	
2	-210	2021-03-03	Door Prizes                   	
3	-290	2021-03-02	Decorations                   	
4	-210	2021-03-05	Booth Rental                  	
5	-120	2021-03-06	Door Prizes                   	
6	-190	2021-03-06	Maintenance Fees              	
7	-200	2021-03-09	Supplies                      	
8	-100	2021-03-12	Door Prizes                   	
9	-110	2021-03-17	Maintenance Fees              	
10	130	2021-03-17	Fundraising                   	
11	-240	2021-03-22	Decorations                   	
12	-200	2021-03-23	Booth Rental                  	
13	-270	2021-03-29	Booth Rental                  	
14	-210	2021-03-29	Door Prizes                   	
15	-220	2021-01-22	Maintenance Fees              	
16	-130	2021-01-25	Maintenance Fees              	
17	-100	2021-01-24	Supplies                      	
18	-200	2021-01-24	Booth Rental                  	
19	-210	2021-01-30	Supplies                      	
20	-140	2021-01-31	Decorations                   	
21	-260	2021-01-31	Door Prizes                   	
22	-140	2021-02-06	Booth Rental                  	
23	-150	2021-02-11	Booth Rental                  	
24	290	2021-02-10	Fundraising                   	
25	-190	2021-02-15	Booth Rental                  	
26	-210	2021-02-22	Maintenance Fees              	
27	-220	2021-02-18	Door Prizes                   	
28	-230	2021-02-21	Door Prizes                   	
29	110	2021-02-21	Fundraising                   	
30	-130	2021-02-23	Supplies                      	
31	-230	2021-02-23	Booth Rental                  	
32	-260	2021-02-22	Decorations                   	
33	-120	2021-02-26	Maintenance Fees              	
34	-130	2021-02-24	Booth Rental                  	
35	-210	2021-02-28	Booth Rental                  	
36	-110	2021-03-07	Decorations                   	
37	-270	2021-03-08	Booth Rental                  	
38	-290	2021-03-07	Maintenance Fees              	
39	-130	2021-03-07	Booth Rental                  	
40	-240	2021-03-07	Decorations                   	
41	-250	2021-03-07	Decorations                   	
42	-190	2021-03-17	Door Prizes                   	
43	-250	2021-03-20	Booth Rental                  	
44	-180	2021-03-22	Door Prizes                   	
45	-130	2021-03-22	Maintenance Fees              	
46	-130	2022-12-22	Booth Rental                  	
47	-130	2022-12-23	Door Prizes                   	
48	-240	2022-12-23	Booth Rental                  	
49	-210	2022-12-23	Maintenance Fees              	
50	-170	2022-12-26	Booth Rental                  	
51	-300	2022-12-23	Supplies                      	
52	-200	2022-12-27	Booth Rental                  	
53	-270	2022-12-26	Maintenance Fees              	
54	-220	2022-12-28	Decorations                   	
55	-230	2022-12-27	Booth Rental                  	
56	-300	2022-12-28	Decorations                   	
57	-280	2022-12-28	Door Prizes                   	
58	-230	2023-01-02	Supplies                      	
59	-190	2023-01-03	Maintenance Fees              	
60	-160	2023-01-03	Supplies                      	
61	-270	2023-01-03	Decorations                   	
62	200	2023-01-02	Fundraising                   	
63	-250	2023-01-13	Booth Rental                  	
64	-120	2023-01-13	Booth Rental                  	
65	-220	2023-01-13	Decorations                   	
66	300	2023-01-09	Fundraising                   	
67	-270	2023-01-18	Maintenance Fees              	
68	-170	2023-01-16	Booth Rental                  	
69	-230	2023-01-27	Supplies                      	
70	-260	2023-01-24	Decorations                   	
71	-270	2023-01-28	Door Prizes                   	
72	110	2023-01-28	Fundraising                   	
73	-160	2023-02-02	Supplies                      	
74	-150	2023-02-05	Supplies                      	
75	-220	2023-02-07	Decorations                   	
76	-230	2023-02-06	Supplies                      	
77	270	2023-02-07	Fundraising                   	
78	-280	2023-02-10	Maintenance Fees              	
79	-150	2023-02-16	Decorations                   	
80	-180	2023-02-17	Supplies                      	
81	-260	2023-02-24	Decorations                   	
82	-260	2023-02-27	Door Prizes                   	
83	-140	2023-02-27	Decorations                   	
84	-250	2023-02-26	Supplies                      	
85	-290	2024-08-19	Booth Rental                  	
86	-280	2024-08-20	Door Prizes                   	
87	-100	2024-08-27	Decorations                   	
88	-120	2024-08-29	Maintenance Fees              	
89	-110	2024-08-26	Decorations                   	
90	190	2024-08-27	Fundraising                   	
91	-260	2024-09-01	Maintenance Fees              	
92	-160	2024-08-29	Decorations                   	
93	-300	2024-08-31	Maintenance Fees              	
94	-110	2024-08-30	Decorations                   	
95	-200	2024-09-04	Door Prizes                   	
96	-250	2024-09-02	Door Prizes                   	
97	-250	2024-09-04	Maintenance Fees              	
98	-270	2024-09-08	Booth Rental                  	
99	-270	2024-09-09	Maintenance Fees              	
100	-100	2024-09-07	Booth Rental                  	
101	-120	2024-09-10	Decorations                   	
102	-240	2024-09-11	Booth Rental                  	
103	-280	2024-09-12	Door Prizes                   	
104	-100	2024-09-17	Supplies                      	
105	-280	2024-09-23	Decorations                   	
106	-200	2024-09-27	Door Prizes                   	
107	-280	2024-10-02	Supplies                      	
108	-140	2024-10-03	Door Prizes                   	
109	-160	2024-10-07	Maintenance Fees              	
110	-190	2024-10-04	Maintenance Fees              	
111	-200	2024-10-15	Maintenance Fees              	
112	-260	2024-10-28	Decorations                   	
113	-280	2024-11-04	Maintenance Fees              	
114	-100	2024-11-07	Maintenance Fees              	
115	-210	2024-11-04	Door Prizes                   	
116	-150	2024-11-10	Supplies                      	
117	-180	2024-11-07	Booth Rental                  	
118	-130	2024-11-15	Supplies                      	
119	-190	2024-11-13	Decorations                   	
120	-250	2024-11-19	Door Prizes                   	
121	-260	2024-11-15	Decorations                   	
122	-190	2024-11-29	Door Prizes                   	
123	-250	2024-11-26	Door Prizes                   	
124	-110	2024-11-27	Maintenance Fees              	
125	260	2024-11-25	Fundraising                   	
126	-130	2024-12-08	Decorations                   	
127	-240	2024-12-09	Supplies                      	
128	-240	2023-01-21	Maintenance Fees              	
129	-160	2023-01-23	Door Prizes                   	
130	-140	2023-01-21	Booth Rental                  	
131	-230	2023-01-25	Decorations                   	
132	-160	2023-01-24	Booth Rental                  	
133	190	2023-01-28	Fundraising                   	
134	-270	2023-01-29	Decorations                   	
135	-220	2023-01-30	Maintenance Fees              	
136	-160	2023-01-30	Door Prizes                   	
137	140	2023-01-31	Fundraising                   	
138	-260	2023-02-04	Decorations                   	
139	-280	2023-01-31	Door Prizes                   	
140	-190	2023-02-11	Booth Rental                  	
141	-230	2023-02-09	Maintenance Fees              	
142	-130	2023-02-07	Maintenance Fees              	
143	-130	2023-02-21	Maintenance Fees              	
144	-200	2023-02-22	Door Prizes                   	
145	-260	2023-02-22	Maintenance Fees              	
146	-270	2023-02-23	Door Prizes                   	
147	-130	2023-02-23	Decorations                   	
148	-260	2023-02-22	Maintenance Fees              	
149	-290	2023-02-23	Decorations                   	
150	-210	2023-03-04	Maintenance Fees              	
151	-200	2023-03-02	Maintenance Fees              	
152	-120	2023-03-04	Door Prizes                   	
153	-180	2023-03-06	Decorations                   	
154	-240	2023-03-05	Booth Rental                  	
155	-240	2023-03-08	Door Prizes                   	
156	-290	2023-03-14	Door Prizes                   	
157	-200	2023-03-13	Supplies                      	
158	-180	2023-03-14	Supplies                      	
159	-110	2023-03-19	Supplies                      	
160	-170	2023-03-19	Booth Rental                  	
161	-240	2023-03-24	Decorations                   	
162	-200	2023-03-24	Supplies                      	
163	-190	2023-03-24	Door Prizes                   	
164	11350	2021-03-04	Donation                      	
165	19500	2021-03-28	Donation                      	
166	5700	2021-03-11	Donation                      	
167	15950	2021-02-10	Donation                      	
168	19450	2023-02-11	Donation                      	
169	25000	2023-01-07	Donation                      	
170	15050	2023-02-14	Donation                      	
171	8250	2024-09-28	Donation                      	
172	20250	2024-10-12	Donation                      	
173	5900	2024-11-06	Donation                      	
174	13950	2023-03-18	Donation                      	
175	47400	2019-10-21	Donation                      	
176	26500	2016-10-02	Donation                      	
177	45900	2016-03-29	Donation                      	
178	29300	2023-05-19	Donation                      	
179	10500	2022-01-20	Donation                      	
180	17000	2023-06-16	Donation                      	
181	11700	2019-11-01	Donation                      	
182	28400	2019-04-29	Donation                      	
183	20400	2016-02-07	Donation                      	
184	32900	2021-03-29	Donation                      	
185	-6350	2022-01-23	Maintenance Fees              	
186	-8050	2018-08-09	Venue Rental                  	
187	-7600	2016-04-24	Offic Rent                    	
188	-8600	2018-05-18	Maintenance Fees              	
189	-9600	2022-03-31	Maintenance Fees              	
190	-6100	2017-08-13	Maintenance Fees              	
191	-8650	2022-09-06	Maintenance Fees              	
192	-5350	2017-01-10	Venue Rental                  	
193	-8650	2021-06-01	Venue Rental                  	
194	-8700	2022-10-13	Maintenance Fees              	
\.


--
-- Data for Name: usestransaction; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.usestransaction (tid, phid) FROM stdin;
1	1
2	1
3	1
4	2
5	2
6	2
7	3
8	3
9	4
10	4
11	5
12	5
13	6
14	6
15	7
16	7
17	7
18	8
19	9
20	9
21	9
22	10
23	11
24	11
25	12
26	13
27	13
28	13
29	13
30	14
31	14
32	14
33	15
34	16
35	17
36	18
37	18
38	18
39	19
40	19
41	19
42	20
43	20
44	21
45	21
46	22
47	22
48	22
49	23
50	23
51	23
52	24
53	24
54	24
55	25
56	25
57	25
58	26
59	27
60	27
61	27
62	27
63	28
64	28
65	28
66	28
67	29
68	29
69	30
70	31
71	31
72	31
73	32
74	32
75	33
76	33
77	33
78	34
79	35
80	35
81	36
82	37
83	37
84	37
85	38
86	38
87	39
88	39
89	39
90	39
91	40
92	40
93	40
94	41
95	42
96	42
97	43
98	44
99	44
100	44
101	45
102	45
103	45
104	46
105	47
106	48
107	49
108	50
109	50
110	50
111	51
112	52
113	53
114	54
115	54
116	55
117	55
118	56
119	56
120	57
121	57
122	58
123	58
124	58
125	58
126	59
127	60
128	61
129	61
130	61
131	62
132	62
133	62
134	63
135	63
136	64
137	64
138	65
139	65
140	66
141	66
142	66
143	67
144	67
145	67
146	68
147	68
148	68
149	69
150	70
151	70
152	70
153	71
154	71
155	71
156	72
157	72
158	72
159	73
160	73
161	74
162	74
163	74
\.


--
-- Data for Name: volunteerscampaign; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.volunteerscampaign (email, cid, job) FROM stdin;
combativesillyotter583@uvic.ca                    	1	Advertising                   
combativeassertivesheep998@gmail.com              	1	Volunteer Organizer           
oldprogramminglizard201@uvic.ca                   	1	Supplies Purchasing           
sillymadalligator388@shaw.ca                      	2	Advertising                   
oldprogramminglizard201@uvic.ca                   	2	Supplies Purchasing           
manlyprogrammingtent233@gmail.com                 	3	Volunteer Organizer           
seductivemanlydragon380@outlook.com               	3	Supplies Purchasing           
blueprogrammingeagle654@gmail.com                 	3	Advertising                   
greymanlydragon077@hotmail.com                    	3	Volunteer Organizer           
blueprogrammingeagle654@gmail.com                 	4	Supplies Purchasing           
combativesillyotter583@uvic.ca                    	5	Supplies Purchasing           
redprogrammingpiano501@gmail.com                  	5	Advertising                   
\.


--
-- Data for Name: volunteersphase; Type: TABLE DATA; Schema: public; Owner: c370_s132
--

COPY public.volunteersphase (email, phid) FROM stdin;
oldprogramminglizard201@uvic.ca                   	4
greymanlydragon077@hotmail.com                    	7
oldprogramminglizard201@uvic.ca                   	7
blueprogrammingeagle654@gmail.com                 	7
redprogrammingpiano501@gmail.com                  	7
manlyprogrammingtent233@gmail.com                 	9
redprogrammingpiano501@gmail.com                  	9
combativeassertivesheep998@gmail.com              	12
oldprogramminglizard201@uvic.ca                   	12
blueseductivedesk329@shaw.ca                      	13
seductivemanlydragon380@outlook.com               	13
redprogrammingpiano501@gmail.com                  	13
seductivemanlydragon380@outlook.com               	15
redprogrammingpiano501@gmail.com                  	15
oldprogramminglizard201@uvic.ca                   	15
seductivemanlydragon380@outlook.com               	16
oldprogramminglizard201@uvic.ca                   	20
redprogrammingpiano501@gmail.com                  	20
combativesillyotter583@uvic.ca                    	21
manlyprogrammingtent233@gmail.com                 	22
sillymadalligator388@shaw.ca                      	22
combativesillyotter583@uvic.ca                    	22
seductivemanlydragon380@outlook.com               	22
oldprogramminglizard201@uvic.ca                   	24
sillymadalligator388@shaw.ca                      	24
programmingganglyeagle557@hotmail.com             	25
combativesillyotter583@uvic.ca                    	28
sillymadalligator388@shaw.ca                      	29
blueseductivedesk329@shaw.ca                      	29
manlyprogrammingtent233@gmail.com                 	29
seductivemanlydragon380@outlook.com               	29
oldprogramminglizard201@uvic.ca                   	29
greymanlydragon077@hotmail.com                    	29
combativesillyotter583@uvic.ca                    	29
combativeassertivesheep998@gmail.com              	30
greymanlydragon077@hotmail.com                    	32
blueprogrammingeagle654@gmail.com                 	33
manlyprogrammingtent233@gmail.com                 	35
redprogrammingpiano501@gmail.com                  	35
redprogrammingpiano501@gmail.com                  	40
blueprogrammingeagle654@gmail.com                 	40
oldprogramminglizard201@uvic.ca                   	40
greymanlydragon077@hotmail.com                    	42
blueprogrammingeagle654@gmail.com                 	42
seductivemanlydragon380@outlook.com               	42
oldprogramminglizard201@uvic.ca                   	42
greymanlydragon077@hotmail.com                    	44
programmingganglyeagle557@hotmail.com             	44
spryjollypig342@hotmail.com                       	44
oldprogramminglizard201@uvic.ca                   	44
madgrimduck072@uvic.ca                            	44
blueseductivedesk329@shaw.ca                      	46
combativeassertivesheep998@gmail.com              	47
combativesillyotter583@uvic.ca                    	47
manlyprogrammingtent233@gmail.com                 	47
greymanlydragon077@hotmail.com                    	48
madgrimduck072@uvic.ca                            	48
combativesillyotter583@uvic.ca                    	48
combativeassertivesheep998@gmail.com              	49
sillymadalligator388@shaw.ca                      	50
madgrimduck072@uvic.ca                            	51
blueprogrammingeagle654@gmail.com                 	51
blueseductivedesk329@shaw.ca                      	51
sillymadalligator388@shaw.ca                      	51
blueprogrammingeagle654@gmail.com                 	52
manlyprogrammingtent233@gmail.com                 	52
combativesillyotter583@uvic.ca                    	52
greymanlydragon077@hotmail.com                    	52
manlyprogrammingtent233@gmail.com                 	54
greymanlydragon077@hotmail.com                    	55
redprogrammingpiano501@gmail.com                  	55
oldprogramminglizard201@uvic.ca                   	55
seductivemanlydragon380@outlook.com               	55
combativeassertivesheep998@gmail.com              	59
programmingganglyeagle557@hotmail.com             	61
seductivemanlydragon380@outlook.com               	61
redprogrammingpiano501@gmail.com                  	61
greymanlydragon077@hotmail.com                    	61
blueprogrammingeagle654@gmail.com                 	62
programmingganglyeagle557@hotmail.com             	62
greymanlydragon077@hotmail.com                    	62
combativesillyotter583@uvic.ca                    	62
blueprogrammingeagle654@gmail.com                 	63
blueseductivedesk329@shaw.ca                      	66
redprogrammingpiano501@gmail.com                  	67
seductivemanlydragon380@outlook.com               	67
sillymadalligator388@shaw.ca                      	67
blueseductivedesk329@shaw.ca                      	67
combativeassertivesheep998@gmail.com              	67
programmingganglyeagle557@hotmail.com             	67
manlyprogrammingtent233@gmail.com                 	68
seductivemanlydragon380@outlook.com               	68
blueprogrammingeagle654@gmail.com                 	68
blueprogrammingeagle654@gmail.com                 	69
redprogrammingpiano501@gmail.com                  	70
combativesillyotter583@uvic.ca                    	70
seductivemanlydragon380@outlook.com               	73
combativesillyotter583@uvic.ca                    	73
\.


--
-- Name: campaigns_cid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s132
--

SELECT pg_catalog.setval('public.campaigns_cid_seq', 1, false);


--
-- Name: donors_did_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s132
--

SELECT pg_catalog.setval('public.donors_did_seq', 1, false);


--
-- Name: phases_phid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s132
--

SELECT pg_catalog.setval('public.phases_phid_seq', 1, false);


--
-- Name: transactions_tid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s132
--

SELECT pg_catalog.setval('public.transactions_tid_seq', 1, false);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (cid);


--
-- Name: donors donors_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.donors
    ADD CONSTRAINT donors_pkey PRIMARY KEY (did);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (email);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (email);


--
-- Name: phases phases_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (phid);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (tid);


--
-- Name: query_5 _RETURN; Type: RULE; Schema: public; Owner: c370_s132
--

CREATE OR REPLACE VIEW public.query_5 AS
 SELECT DISTINCT avgcost.email,
    avgcost.fname,
    avgcost.lname,
    avgcost.avgc
   FROM ( SELECT members.email,
            members.fname,
            members.lname,
            round(avg(costperphase.totalcost), 2) AS avgc
           FROM ((public.members
             JOIN public.leadsphase USING (email))
             JOIN ( SELECT (sum(transactions.amount) * '-1'::integer) AS totalcost,
                    usestransaction.phid
                   FROM (public.transactions
                     JOIN public.usestransaction USING (tid))
                  WHERE (transactions.amount < 0)
                  GROUP BY usestransaction.phid) costperphase USING (phid))
          GROUP BY members.email) avgcost
  WHERE (avgcost.avgc = ( SELECT min(avgcost_1.avgc) AS min
           FROM ( SELECT members.fname,
                    members.lname,
                    round(avg(costperphase.totalcost), 2) AS avgc
                   FROM ((public.members
                     JOIN public.leadsphase USING (email))
                     JOIN ( SELECT (sum(transactions.amount) * '-1'::integer) AS totalcost,
                            usestransaction.phid
                           FROM (public.transactions
                             JOIN public.usestransaction USING (tid))
                          WHERE (transactions.amount < 0)
                          GROUP BY usestransaction.phid) costperphase USING (phid))
                  GROUP BY members.email) avgcost_1));


--
-- Name: query_6 _RETURN; Type: RULE; Schema: public; Owner: c370_s132
--

CREATE OR REPLACE VIEW public.query_6 AS
 SELECT main_query.phid,
    main_query.city,
    main_query.location,
    main_query.duration
   FROM ( SELECT numvolunteers.phid,
            numvolunteers.city,
            numvolunteers.location,
            (numvolunteers.edate - numvolunteers.sdate) AS duration
           FROM ( SELECT phases.phid,
                    phases.city,
                    phases.location,
                    phases.sdate,
                    phases.edate,
                    count(volunteersphase.phid) AS num
                   FROM (public.phases
                     LEFT JOIN public.volunteersphase ON ((phases.phid = volunteersphase.phid)))
                  GROUP BY phases.phid) numvolunteers
          WHERE (numvolunteers.num >= 6)
        UNION
         SELECT phases.phid,
            phases.city,
            phases.location,
            (phases.edate - phases.sdate) AS duration
           FROM (public.phases
             JOIN public.leadsphase USING (phid))
          WHERE (leadsphase.email = 'redprogrammingpiano501@gmail.com'::bpchar)) main_query
  ORDER BY main_query.phid;


--
-- Name: donates_campaign _RETURN; Type: RULE; Schema: public; Owner: c370_s132
--

CREATE OR REPLACE VIEW public.donates_campaign AS
 SELECT donors.did,
    donatescampaign.cid,
    donors.dname,
    donors.email,
    sum(transactions.amount) AS total
   FROM ((((public.donors
     JOIN public.makesdonation USING (did))
     JOIN public.donatescampaign USING (tid))
     JOIN public.campaigns USING (notes, cid))
     JOIN public.transactions USING (notes, tid))
  GROUP BY donors.did, donatescampaign.cid;


--
-- Name: campaigns checkcampaigndates; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER checkcampaigndates AFTER INSERT ON public.campaigns FOR EACH STATEMENT EXECUTE PROCEDURE public.campaigns_trig_func();


--
-- Name: leadscampaign givevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER givevolunteerhours AFTER INSERT ON public.leadscampaign FOR EACH ROW EXECUTE PROCEDURE public.update_hours_trig_func();


--
-- Name: leadsphase givevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER givevolunteerhours AFTER INSERT ON public.leadsphase FOR EACH ROW EXECUTE PROCEDURE public.update_hours_trig_func();


--
-- Name: volunteerscampaign givevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER givevolunteerhours AFTER INSERT ON public.volunteerscampaign FOR EACH ROW EXECUTE PROCEDURE public.update_hours_trig_func();


--
-- Name: volunteersphase givevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER givevolunteerhours AFTER INSERT ON public.volunteersphase FOR EACH ROW EXECUTE PROCEDURE public.update_hours_trig_func();


--
-- Name: phases phasedatestrigger; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER phasedatestrigger AFTER INSERT ON public.phases FOR EACH STATEMENT EXECUTE PROCEDURE public.phases_trig_func();


--
-- Name: leadscampaign replaceleader; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER replaceleader BEFORE INSERT ON public.leadscampaign FOR EACH ROW EXECUTE PROCEDURE public.replace_campaign_leader_trig_func();


--
-- Name: leadsphase replaceleader; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER replaceleader BEFORE INSERT ON public.leadsphase FOR EACH ROW EXECUTE PROCEDURE public.replace_phase_leader_trig_func();


--
-- Name: leadscampaign swapvolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER swapvolunteerhours AFTER UPDATE ON public.leadscampaign FOR EACH ROW EXECUTE PROCEDURE public.swap_hours_trig_func();


--
-- Name: leadsphase swapvolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER swapvolunteerhours AFTER UPDATE ON public.leadsphase FOR EACH ROW EXECUTE PROCEDURE public.swap_hours_trig_func();


--
-- Name: volunteerscampaign swapvolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER swapvolunteerhours AFTER UPDATE ON public.volunteerscampaign FOR EACH ROW EXECUTE PROCEDURE public.swap_hours_trig_func();


--
-- Name: volunteersphase swapvolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER swapvolunteerhours AFTER UPDATE ON public.volunteersphase FOR EACH ROW EXECUTE PROCEDURE public.swap_hours_trig_func();


--
-- Name: leadscampaign takevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER takevolunteerhours AFTER DELETE ON public.leadscampaign FOR EACH ROW EXECUTE PROCEDURE public.remove_hours_trig_func();


--
-- Name: leadsphase takevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER takevolunteerhours AFTER DELETE ON public.leadsphase FOR EACH ROW EXECUTE PROCEDURE public.remove_hours_trig_func();


--
-- Name: volunteerscampaign takevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER takevolunteerhours AFTER DELETE ON public.volunteerscampaign FOR EACH ROW EXECUTE PROCEDURE public.remove_hours_trig_func();


--
-- Name: volunteersphase takevolunteerhours; Type: TRIGGER; Schema: public; Owner: c370_s132
--

CREATE TRIGGER takevolunteerhours AFTER DELETE ON public.volunteersphase FOR EACH ROW EXECUTE PROCEDURE public.remove_hours_trig_func();


--
-- Name: donatescampaign donatescampaign_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.donatescampaign
    ADD CONSTRAINT donatescampaign_cid_fkey FOREIGN KEY (cid) REFERENCES public.campaigns(cid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: donatescampaign donatescampaign_tid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.donatescampaign
    ADD CONSTRAINT donatescampaign_tid_fkey FOREIGN KEY (tid) REFERENCES public.transactions(tid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hasphase hasphase_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.hasphase
    ADD CONSTRAINT hasphase_cid_fkey FOREIGN KEY (cid) REFERENCES public.campaigns(cid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hasphase hasphase_phid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.hasphase
    ADD CONSTRAINT hasphase_phid_fkey FOREIGN KEY (phid) REFERENCES public.phases(phid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: leadscampaign leadscampaign_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.leadscampaign
    ADD CONSTRAINT leadscampaign_cid_fkey FOREIGN KEY (cid) REFERENCES public.campaigns(cid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: leadscampaign leadscampaign_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.leadscampaign
    ADD CONSTRAINT leadscampaign_email_fkey FOREIGN KEY (email) REFERENCES public.members(email) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: leadsphase leadsphase_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.leadsphase
    ADD CONSTRAINT leadsphase_email_fkey FOREIGN KEY (email) REFERENCES public.members(email) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: leadsphase leadsphase_phid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.leadsphase
    ADD CONSTRAINT leadsphase_phid_fkey FOREIGN KEY (phid) REFERENCES public.phases(phid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: makesdonation makesdonation_did_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.makesdonation
    ADD CONSTRAINT makesdonation_did_fkey FOREIGN KEY (did) REFERENCES public.donors(did) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: makesdonation makesdonation_tid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.makesdonation
    ADD CONSTRAINT makesdonation_tid_fkey FOREIGN KEY (tid) REFERENCES public.transactions(tid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: usestransaction usestransaction_phid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.usestransaction
    ADD CONSTRAINT usestransaction_phid_fkey FOREIGN KEY (phid) REFERENCES public.phases(phid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: usestransaction usestransaction_tid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.usestransaction
    ADD CONSTRAINT usestransaction_tid_fkey FOREIGN KEY (tid) REFERENCES public.transactions(tid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: volunteerscampaign volunteerscampaign_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.volunteerscampaign
    ADD CONSTRAINT volunteerscampaign_cid_fkey FOREIGN KEY (cid) REFERENCES public.campaigns(cid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: volunteerscampaign volunteerscampaign_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.volunteerscampaign
    ADD CONSTRAINT volunteerscampaign_email_fkey FOREIGN KEY (email) REFERENCES public.members(email) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: volunteersphase volunteersphase_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.volunteersphase
    ADD CONSTRAINT volunteersphase_email_fkey FOREIGN KEY (email) REFERENCES public.members(email) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: volunteersphase volunteersphase_phid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s132
--

ALTER TABLE ONLY public.volunteersphase
    ADD CONSTRAINT volunteersphase_phid_fkey FOREIGN KEY (phid) REFERENCES public.phases(phid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

