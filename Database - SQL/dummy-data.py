import datetime
import random

# Set of Campaign Dates
campaign_dates = [
    ('2021-03-02', '2021-03-30'),
    ('2021-01-21', '2021-03-22'),
    ('2022-12-20', '2023-02-27'),
    ('2024-08-16', '2024-12-12'),
    ('2023-01-21', '2023-03-24'),
]

# Set of cities, locations and their weights
location_weights = [10, 5, 1, 1]
locations = {
    'Victoria': [
        'Butchart Gardens',
        'Uptown',
        'Mayfair Mall',
        'Parliament Building',
        'Royal BC Museum',
        'Tilicum Mall',
        'University of Victoria',
        'Warf Street',
        'Inner Harbour',
    ],
    'Vancouver': [
        'Richmond Mall',
        'Vancouver City Centre',
        'Metrotown',
        'Stanley Park',
        'Vancouver Farmers Market',
        'University of British Columbia',
        'Granville Island',
    ],
    'Nanaimo': [
        'Harbourfront Walkway',
        'The Bastion',
    ],
    'Tofino': [
        'Tonquin Park',
        'Chesterman Beach',
    ]
}

# set of event types, weights, and duration maxes and mins
event_weights = [1, 1, 3, 6, 6, 6]
events = (
    ('Fundraising Dinner', 1, 1),
    ('Bottle Drive', 2, 4),
    ('Flyer Distribution', 1, 5),
    ('Info Booth', 3, 7),
    ('Trivia Booth', 2, 5),
    ('Spin the Wheel Booth', 3, 6),
)

# set of first and last names
fnames = ['Jim', 'Alfred', 'Ronny', 'Sam', 'Tim', 'Joe', 'Howie', 'Omar', 'Maggie', 'Jasmine', 'Ally', 'Maya', 'Robin', 'Danah', 'Amanda', 'Richard', 'Ben', 'Jeremy']
lnames = ['Jones', 'Drake', 'McDougal', 'Robson', 'Johnson', 'Li', 'Ng', 'Stent', 'Smith', 'Zhang', 'Singh', 'Walt', 'Lim', 'Garcia', 'Brown', 'Wilson', 'Taylor', 'Rodriguez']

# set of words used to form emails
emailadj = ['happy', 'spry', 'swift', 'blue', 'grey', 'red', 'silly', 'manly', 'old', 'good', 'brave', 'sad', 'mad', 'jolly', 'seductive', 'gangly', 'smiley', 'combative', 'observant', 'programming', 'exorbant', 'grim', 'faint', 'assertive', 'jumpy', 'ghastly']
emailnoun = ['dragon', 'alligator', 'walrus', 'hippo', 'tiger', 'llama', 'zebra', 'pig', 'sheep', 'cow', 'duck', 'flamingo', 'lizard', 'tent', 'lamp', 'sunglasses', 'drum', 'piano', 'flower', 'exam', 'desk', 'homework', 'bed', 'chair', 'otter', 'hawk', 'eagle']
emailend = ['@hotmail.com', '@gmail.com', '@outlook.com', '@shaw.ca', '@uvic.ca']

# set of area codes for phone numbers
areacode = ['778','250', '534', '637']

# set of member types and weights
membertype = ['Supporter', 'Tier 1', 'Tier 2', 'Employee']
member_weights = [30, 60, 100, 30]

# creates an array by weighting each item by it's cooresponding weight
# these items are then randomly selected from, creating a higher chance
# of selecting items with a higher weight
def use_weights (data, weights):
    results = []
    for i in range(len(weights)):
        for j in range(weights[i]):
            results.append(data[i])

    return results

# converts a date into the format YYYY-MM-DD
def convert_to_string(date):
    return date.strftime("%Y-%m-%d")

def str_to_date(str):
    date_split = str.split('-')
    return datetime.datetime(int(date_split[0]), int(date_split[1]), int(date_split[2]))

# Creates campaign phases
def create_phases ():
    results = []
    phaserelation = []
    location_data = use_weights(list(locations.keys()), location_weights)
    event_data = use_weights(events, event_weights)
    phase_id = 0
    campaign_id = 0

    # For each campaign
    for d in campaign_dates:
        campaign_id += 1
        sdate = str_to_date(d[0])
        ldate = str_to_date(d[1])
        cur_date = sdate

        # Starting from the first day of the campaign, creates phases of 
        # random length and then starting from near the end of that phase
        # creates a new phase until we reach the end date of the campaign
        while (cur_date < ldate):

            # If we are in the middle of the campaign, randomly adds
            # or subtracts some days to simulate gaps and overlapping
            # phases
            if (cur_date != sdate):
                if (random.randint(0, 10) % 2 == 0):
                    cur_date -= datetime.timedelta(days = random.randint(0, 3))
                else:
                    cur_date += datetime.timedelta(days = random.randint(0, 7))
                    cur_date = min(cur_date, ldate)
            
            # randomly selects values for phase attributes
            phase_id += 1
            city_name = location_data[random.randint(0, len(location_data) - 1)]
            loc_options = locations[city_name]

            location = loc_options[random.randint(0, len(loc_options) - 1)]

            cur_event = event_data[random.randint(0, len(event_data) - 1)]
            event_name = cur_event[0]

            duration = random.randint(cur_event[1], cur_event[2])

            start = convert_to_string(cur_date)
            end = min(cur_date + datetime.timedelta(days = duration), ldate)
            results.append((cur_date, end, phase_id))

            end_string = convert_to_string(end)

            budget = random.randint(2, 30) * 50

            # prints out Phase as an sql insert statement
            print('insert into Phases values (', phase_id, ',\'', start, '\',\'', end_string, '\',\'', city_name, '\',\'' , location, '\',\'', event_name, '\',', budget, ');', sep='')
            
            # adds the campaign - phase relationship
            phaserelation.append((campaign_id, phase_id))
            cur_date = end

    # Prints all campaign - phase relationships as sql inserts
    print()
    for item in phaserelation:
        print('insert into HasPhase values (', item[0], ',', item[1], ');', sep='')

    print()

    return results

# Randomly creates a new member with a start date before the given date
def create_new_member(start):
    start -= datetime.timedelta(days = random.randint(14, 365))

    fname = fnames[random.randint(0, len(fnames) - 1)]
    lname = lnames[random.randint(0, len(lnames) - 1)]

    phone = areacode[random.randint(0, len(areacode) - 1)] + '-'
    for i in range(3):
        phone += str(random.randint(0, 9))
    phone += '-'
    for i in range(4):
        phone += str(random.randint(0, 9))
    
    hours = 0
    campaigns = 0

    # Randomly selects a type of member and assigns values for 
    # campaigns and hours accordingly
    member_type = use_weights(membertype, member_weights)
    decider = member_type[random.randint(0, len(member_type) - 1)]
    if (decider == 'Tier 1'):
        campaigns = 3 + random.randint(0, 7)
        hours = random.randint(8, 50 * campaigns)
    elif (decider == 'Tier 2'):
        campaigns = random.randint(1, 2)
        hours = random.randint(3, 10 * campaigns)
    elif (decider == 'Employee'):
        campaigns = random.randint(0, 10)
        hours = random.randint(0, 20 * campaigns)

    # Randomly generates an email for the member
    # If the member is an employee the email ends in @gng.ca
    email = ''
    if decider == 'Employee':
        email = fname[0] + lname
        for i in range(3):
            email += str(random.randint(0, 9))
        email += '@gng.ca'
    else:
        email = emailadj[random.randint(0, len(emailadj) - 1)]
        email += emailadj[random.randint(0, len(emailadj) - 1)]
        email += emailnoun[random.randint(0, len(emailnoun) - 1)]
        for i in range(3):
            email += str(random.randint(0, 9))
        email += emailend[random.randint(0, len(emailend) - 1)]

    return member(fname, lname, phone, email, start, hours, campaigns)

class member:
    def __init__(self, fname, lname, phone, email, sdate, hours, campaigns):
        self.fname = fname
        self.lname = lname
        self.phone = phone
        self.email = email
        self.hours = hours
        self.campaigns = campaigns
        self.sdate = sdate

# Given a set of phases, creates volunteers to volunteer at each phase
def create_members(phases):
    members = []
    volunteer = []
    lead = []

    # For each phase, either assigns pre-existing volunteers or creates
    # new ones if none exist
    for phase in phases:
        allowed = []
        sdate = phase[0]
        ldate = phase[1]
        duration = max((ldate - sdate).days, 0)

        # Only members that started BEFORE the phase start date can 
        # volunteer
        for mem in members:
            if mem.sdate < sdate:
                allowed.append(mem)

        # Creates new employees if their aren't enough eligible 
        # volunteers
        if len(allowed) < 2 * duration:
            for i in range(2 * duration - len(allowed)):
                new_mem = create_new_member(sdate)
                members.append(new_mem)
                allowed.append(new_mem)

        # If there are enough volunteers, may randomly create some new
        # ones anyways
        elif random.randint(0, 10) == 0:
            for i in range(random.randint(1, 3)):
                new_mem = create_new_member(sdate)
                members.append(new_mem)
                allowed.append(new_mem)
        
        # Randomly picks a number of volunteers at the phase
        numvol = random.randint(1 * duration, min(2 * duration, len(allowed) - 1))
        first = True
        for i in range(0, numvol):

            vol = allowed[random.randint(0, len(allowed) - 1)]
            allowed.remove(vol)

            # If the member is an employee, they cannot volunteer
            if ('@gng.ca' in vol.email):
                break
            
            # The first non-employee selected is the assigned
            # 'leader' of the campaign
            if (first):
                lead.append((vol, phase))
                first = False
            else:
                volunteer.append((vol, phase))

    # prints the list of members as sql insert statements
    for mem in members:
        print('insert into Members values (\'', mem.email, '\',\'', mem.phone, '\',\'', mem.fname, '\',\'', mem.lname, '\',\'', convert_to_string(mem.sdate), '\',', mem.hours,',', mem.campaigns, ');', sep='')

    # prints the volunteer-phase relationship as sql insert statements
    print()
    for item in volunteer:
        print('insert into VolunteersPhase values (\'', item[0].email, '\',', item[1][2], ');', sep = '') 

    # prints the volunteer-leads-phase relationship
    print()
    for item in lead:
        print('insert into LeadsPhase values (\'', item[0].email, '\',', item[1][2], ');', sep = '') 

    # prints the employees and assigns them a random salary.
    # Note: Employees also need a role, but I assigned these manually
    print()
    for mem in members:
        if ('@gng.ca' in mem.email):
            salary = random.randint(100, 500) * 100
            print('insert into Employees values (\'', mem.email, '\',', salary, ');', sep='')

pos_trans_reasons = ['Donation', 'Fundraising']
neg_trans_reasons_large = ['Maintenance Fees', 'Offic Rent', 'Venue Rental']
neg_trans_reasons_small = ['Supplies', 'Maintenance Fees', 'Booth Rental', 'Door Prizes', 'Decorations']
donorid = [i for i in range(5)]

# Randomly creates a set of transactions
def create_transactions(phases):
    campaign_donate = []
    phase_trans = []
    company_donate = []
    id = 0

    print()

    # For each phase, creates a set of transactions within those dates
    for phase in phases:
        sdate = phase[0]
        ldate = phase[1]
        duration = max((ldate - sdate).days, 0)

        # Creates 1-3 small transactions simulating spending money during the phases
        for i in range(0, random.randint(1, 3)):
            id += 1
            days = random.randint(0, duration)
            reason = neg_trans_reasons_small[random.randint(0, len(neg_trans_reasons_small) - 1)]
            amount = random.randint(10, 30) * -10
            dateof = convert_to_string(sdate + datetime.timedelta(days = days))

            phase_trans.append((id, phase[2]))
            print('insert into Transactions values (', id, ',', amount, ',\'', dateof, '\',\'', reason, '\');', sep='')

        # Creates 0-5 transactions simulating money made from fundraising
        if random.randint(0, 5) == 5:
            id += 1
            days = random.randint(0, duration)
            reason = 'Fundraising'
            amount = random.randint(10, 30) * 10
            dateof = convert_to_string(sdate + datetime.timedelta(days = days))

            phase_trans.append((id, phase[2]))
            print('insert into Transactions values (', id, ',', amount, ',\'', dateof, '\',\'', reason, '\');', sep='')

    camp_id = 0
    # For each campaign, randomly creates large donations from donors
    for campaign in campaign_dates:
        camp_id += 1
        sdate = str_to_date(campaign[0])
        ldate = str_to_date(campaign[1])
        duration = max((ldate - sdate).days, 0)

        # Creates 1-3 random donations
        for i in range(0, random.randint(1, 3)):
            id += 1
            days = random.randint(0, duration)
            reason = 'Donation'
            amount = random.randint(100, 500) * 50
            dateof = convert_to_string(sdate + datetime.timedelta(days = days))

            campaign_donate.append((1, id, camp_id))
            print('insert into Transactions values (', id, ',', amount, ',\'', dateof, '\',\'', reason, '\');', sep='')

    sdate = str_to_date('2015-07-09')
    ldate = str_to_date('2024-01-10')
    duration = max((ldate - sdate).days, 0)

    # Creates a random set of large donations and costs
    for i in range(0, 10):
        id += 1
        days = random.randint(0, duration)
        reason = 'Donation'
        amount = random.randint(100, 500) * 100
        dateof = convert_to_string(sdate + datetime.timedelta(days = days))

        company_donate.append((1, id))
        print('insert into Transactions values (', id, ',', amount, ',\'', dateof, '\',\'', reason, '\');', sep='')

    for i in range(0, 10):
        id += 1
        days = random.randint(0, duration)
        reason = neg_trans_reasons_large[random.randint(0, len(neg_trans_reasons_large) - 1)]
        amount = random.randint(100, 200) * -50
        dateof = convert_to_string(sdate + datetime.timedelta(days = days))

        company_donate.append((1, id))
        print('insert into Transactions values (', id, ',', amount, ',\'', dateof, '\',\'', reason, '\');', sep='')
    
    print()
    for item in phase_trans:
        print('insert into UsesTransaction values (', item[0], ',', item[1], ');', sep = '')

    print()
    for item in company_donate:
        print('insert into DonatesCompany values (', item[0], ',', item[1], ');', sep = '')

    print()
    for item in campaign_donate:
        print('insert into DonatesCampaign values (', item[0], ',', item[1], ',', item[2], ');', sep = '') 

    return

phases = create_phases()
create_members(phases)
create_transactions(phases)
