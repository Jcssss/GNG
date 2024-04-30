#!/usr/bin/env python3

# Checklist:
# Ability to view campaign during campaign creation

import psycopg2
import datetime
import re

def main():
    create_main_menu()

# Displays commands for the main menu and reads/validates input command
def create_main_menu():

    # List of commands, their descriptions, and the functions to call
    commands = {
        'q': ('View and execute a list of pre-written queries.', show_queries),
        'c': ('Create a new campaign, phase, member, etc.', create_create_menu),
        'b': ('Browse data on GNG activities.', create_browse_menu),
        'a': ('Assign a member or phase.', create_assign_menu),
        'n': ('Annotate a member, campaign, phase, etc.', annotate),
        'exit': ('Exit application.', exit),
    }
    
    # Get the list of allowed commands
    selection = get_command('Main Menu', commands)

    # Given valid input, call the proper function
    if selection == 'exit':
        print()
        print("Exiting Program...")
        exit(0)
    else:    
        commands[selection][1]()

# Handles the options for assignment of phases and volunteers
def create_assign_menu():
    commands = {
        'm': ('Assign a member to a phase/campaign.', assign_member),
        'p': ('Reassign a phase to a different campaign.', assign_phase),
        'r': ('Return to the main menu', create_main_menu)
    }
    
    # Get the list of allowed commands
    selection = get_command('Assign Menu', commands)

    # Given valid input, call the proper function
    commands[selection][1]()

# Handles the options for browsing campaigns, phases, etc.
def create_browse_menu():
    commands = {
        'c': ('Browse existing campaigns.', lambda: show_campaigns(False)),
        'm': ('Browse existing members.', lambda: show_members(False)),
        'p': ('Browse existing phases.', lambda: show_phases(False)),
        'd': ('Browse existing donors.', lambda: show_donors(False)),
        'g': ('Browse geographical data on GNG activities.', show_regional_data),
        'f': ('Browse data on GNG\'s finances.', show_funds),
        'h': ('Browse membership history.', show_mem_history),
        'r': ('Return to the main menu', create_main_menu)
    }
    
    # Get the list of allowed commands
    selection = get_command('Browsing Menu', commands)

    # Given valid input, call the proper function
    commands[selection][1]()

# Handles the options for creation of campaigns, phases, etc.
def create_create_menu():
    commands = {
        'c': ('Create a new campaign.', create_campaign),
        'p': ('Create a new phase.', lambda: create_phase(0, False)),
        'm': ('Create a new member.', lambda: add_member(False, False)),
        'd': ('Create a new donor.', lambda: add_donor(False)),
        't': ('Create a new transaction.', create_transaction),
        'r': ('Return to the main menu', create_main_menu)
    }
    
    # Get the list of allowed commands
    selection = get_command('Create Menu', commands)

    # Given valid input, call the proper function
    commands[selection][1]()

# Given a set of data, returns an array with the length of the longest string
# in each column. Used for formatting purposes
def get_max_length(arr, col_names):
    
    max_lengths = []
    
    # Iterates through each column and finds the length of the longest string
    for (col_num, name) in enumerate(col_names):
        col_vals = [name] + [row[col_num] for row in arr]
        col_lengths = [len(str(val).strip()) for val in col_vals]
        max_lengths.append(max(col_lengths) + 3)
    
    return max_lengths

# Given a row of data, converts all data into proper string formats
def unpack_row(row):
    result = []
    
    # Iterates though each entry in the row
    # Handles strings based on type
    for val in row:
        if isinstance(val, datetime.date):
            result.append(val.strftime("%Y-%m-%d"))
        else:
            result.append(str(val).strip())
    
    return result

# Given a set of data and the column names, prints the data as a formatted table
def print_table(data, col_names, title='' ):
    
    print()
    
    # Gets the lengths for each column
    col_lengths = get_max_length(data, col_names)
    data = [unpack_row(row) for row in data]
    
    total_lengths = sum(col_lengths) + len(col_lengths) * 3 - 2
    print('-' * (total_lengths + 3))
    
    # Print the Title for the table    
    if not title == '':
        row_format = '| {:^' + str(total_lengths) + '}|'
        print(row_format.format(title.upper())) 
        print('-' * (total_lengths + 3))
 
    # Prints the headers for the row
    row_output = ['| '] + ['{' + str(i) + ':<' + str(lth) + '} | '\
         for (i, lth) in enumerate(col_lengths)]
    row_format = ''.join(row_output)
    print(row_format.format(*col_names))
    
    # Prints a line under the headers
    hline = ['-'] + ['-' * (length + 3) for length in col_lengths]
    print(''.join(hline))

    # Prints each row in the table
    for row in data:
        print(row_format.format(*row))
    
    print('-' * (total_lengths + 3))

# Shows a followup message after performing a function, and retrieves next input
def show_followup(desc, retry_func):
    
    # Requests and validates input. Loops until a valid input is given
    error = ''
    while True:
        print(error)
        command = input('Type \'M\' to return to the main menu, '\
             + '\'E\' to exit the program, or \'R\' to '
             + desc + ': ').strip().lower()
        if command == 'm':
            create_main_menu()
        elif command == 'e':
            print('Exiting the program...')
            exit(0)
        elif command == 'r':
            retry_func()
        else:
            error = 'ERROR: \'' + command + '\' is not a valid option. '\
                + 'Answer must be M, E, or R.'

# Shows the set of possible queries and requests user input
def show_queries():
    
    # The descriptions for each query
    query_desc = [
        'Phases that overlap with a Campaign they are not associated with.',
        'Campaigns that went over budget (excluding money from Donations).',
        'Phases with a volunteer whose first name matches an employees.',
        'Average hours for members leading Phases for Campaigns'\
            + ' with the longest Phases.',
        'Members who have the lowest average cost per Campaign Phase led.',
        'Phases led by \'redprogrammingpiano501@gmail.com\''\
            + ' or with 6+ volunteers.',
        'Members who have participated in more than 3 campaigns.',
        'Members leading a Phase on \'BC Clearcutting\''\
            + ' with a phone number starting with 778.',
        'Phases not in Victoria with a budget exceeding'\
            + ' the average budget for \'Info Booth\'s.',
        'Members who lead two or more overlapping Campaign Phases.',
        'Donors who\'ve donated $50,000+ and to a Campaign with'\
            + ' 5+ \'Door Prize\' transactions.',
    ]

    # The names of the columns for the results of each query
    query_col_names = [
        ['Phase ID', 'Name', 'Budget', 'Overlapping Campaign Topic'],
        ['Campaign Topic', 'Budget', 'Total Cost'],
        ['Phase ID', 'Start Date', 'End Date', 'First Name', 'Last Name'],
        ['Average Hours'],
        ['Member Email', 'First Name', 'Last Name', 'Average Cost per Phase led'],
        ['Phase ID', 'City', 'Location', 'Duration'],
        ['Member Email', 'Total Volunteer Hours', 'Campaign Count'],
        ['Member Email', 'Start Date'],
        ['Phase ID', 'City', 'Location', 'Budget'],
        ['Member First Name', 'Last Name', 'Overlapping Phase ID'],
        ['Donor Name'],
    ]
    
    # Prints the table of possible queries and thei descriptions
    col_names = ['#', 'Description']
    table_contents = [[row[0] + 1, row[1]] for row in enumerate(query_desc)]
    print_table(table_contents, col_names, 'Query List')
    
    # Requests and validates input query number
    query_choice = get_int_input('number of the query you\'d like to perform', 11)
    
    # Gets the column names and formats results
    col_names = query_col_names[query_choice - 1]
    result = execute_sql('select * from query_%s;', [query_choice])

    # Checks if the results are empty (No returned rows)
    if result == []:
        print('No data matches your criteria.')
    else:
        print_table(result, col_names)
        show_followup('perform another query', show_queries)

# Given data, and bar names, prints a bar graph for the data
def print_bar_graph(data, bar_names, isMulti = False):
    total_length = 80

    # Confirms that data actually exists    
    if data == []:
        print('There is no data to display')
        return
 
    # If we're printing multiple charts, gets titles for sub graphs
    titles = []
    if (isMulti):
        titles = [row[0].strip() for row in data]
        bar_names = bar_names[1:]
        temp = [list(row) for row in data]
        data = [row[1:] for row in temp]

    # Filters the data removing negatives and nulls
    filtered_data = []
    for row in data:
        temp = []
        for val in row:
            temp.append(abs(val) if val else 0)
        filtered_data.append(temp)

    # Calculates lengths for rows
    max_val = max([max(row) for row in filtered_data])
    title_length = max([len(name) for name in bar_names]) 

    # Calculates the maximum length of any numeric value
    amount_length = []
    for row in data:
        num_len = [len(str(val)) for val in row]
        amount_length.append(max(num_len))
    amount_length = max(amount_length)
    
    max_bar_length = total_length - title_length - amount_length - 6
    max_bar_length = max(max_bar_length, 1)
    weight = max_val / max_bar_length
    weight = max(weight, 1)
    
    # Calculates the lengths for each bar
    bar_lengths = []
    for row in filtered_data:
        temp = []
        for val in row:
            temp.append(abs(int(val / weight)))
        bar_lengths.append(temp)
    
    # Prints the bar graph
    print() 
    print(' Bar Graph Displaying Data')
    print('-' * total_length)
    for i in range(0, len(bar_lengths)):
        
        # If multiple subgraphs, prints titles
        if isMulti:
            print('\n{0:-^80}'.format(titles[i]))
        
        # Prints the bars for each subgraph
        for j in range(0, len(bar_lengths[0])):
            row_format = '{0:>' + str(title_length) + '} | '\
                + '{1:>' + str(amount_length) + '} | '\
                + chr(0x2588) * bar_lengths[i][j]
            print(row_format.format(bar_names[j], str(data[i][j])))

# Allows the user to browse finance history
def show_funds(is_return=False):
    commands = {
        'c':('Report on the finances associated with a specific campaign.',),
        'p':('Report on the finances associated with a specific phase.',),
        'a':('Report on the overall finances across all of GNG.',),
        'd':('Report on the overall finances between two dates.',),
        'r':('Return to the main menu.',)
    }
    
    # Retrieves and handles command from the user
    command = get_command('Finance View', commands).lower()
    where = ''
    if command == 'r':
        create_main_menu()
        return
    elif command == 'c':
        campaign_id = get_campaign('search for', False)
        where = 'where (cid1 = {0} or cid2 = {0})'.format(campaign_id)    
    elif command == 'p':
        phase_id = get_phase('search for', False)
        where = 'where (phid = {0})'.format(phase_id)
    elif command == 'd':
        [sdate, edate] = get_start_end('to compare to') 
        sdate = sdate.strftime("%Y-%m-%d")
        edate = edate.strftime("%Y-%m-%d")
        where = 'where (dateof > \'{0}\' and dateof < \'{1}\')'.format(sdate, edate)
    else:
        where = 'where true'
    
    # Fetches all transactions
    all_transactions = execute_sql('''
        select tid, dateof, amount 
        from transact_info ''' + where + ';')
    
    # Fetches the maximum amount made
    max_amount = execute_sql('''
        select max(amount) 
        from transact_info '''\
        + where + ' and amount > 0;')
    max_amount = 0 if max_amount == [] else max_amount[0][0]

    # Fetches the highest amount spent
    min_amount = execute_sql('''
        select min(amount) 
        from transact_info '''\
        + where + ' and amount < 0;')
    min_amount = 0 if min_amount == [] else min_amount[0][0]
    
    # Fetches the net cost
    net_total = execute_sql('''
        select sum(amount) 
        from transact_info '''\
        + where + ';')
    net_total = 0 if net_total == [] else net_total[0][0]

    # Fetches the total amount made
    gain_total = execute_sql('''
        select sum(amount) 
        from transact_info '''\
        + where + ' and amount > 0;')
    gain_total = 0 if gain_total == [] else gain_total[0][0]

    # Fetches the total amount spent
    cost_total = execute_sql('''
        select sum(amount) 
        from transact_info '''\
        + where + ' and amount < 0;')
    cost_total = 0 if cost_total == [] else cost_total[0][0]
   
    # Checks if the summary is allowed 
    if is_return:
        col_names = ['ID', 'Date', 'Amount']
        print_table(all_transactions, col_names)
        return
        
    # Asks the user how to display the data
    command = ''
    print('Data has been fetched.')
    while not command in ['s', 'l', 'b']:
        command = input('Enter \'S\' to view summary,'\
            + ' \'L\' to view list of transactions,'\
            + ' or \'B\' to view both: ').strip().lower()
        
        if not command in ['s', 'l', 'b']:
            print('ERROR: Input must be \'S\', \'L\', or \'B\'.')
    
    # Displays a table of all transactions
    if command in ['l', 'b']:
        col_names = ['ID', 'Date', 'Amount']
        print_table(all_transactions, col_names)

    # Displays a bar chart of summary
    if command in ['s', 'b']:
        col_names = ['Max Raised', 'Max Cost', 'Net Cost', 'Total Gains', 'Total Cost']
        data = [max_amount, min_amount, net_total, gain_total, cost_total]
        print_bar_graph([data], col_names)
        print('Note: negative numbers represent loss of funds.') 
    
    show_followup('view more finance data', show_funds)

# Allows the user to browse geographical data on GNG Activities
def show_regional_data():
    commands = {
        'b': ('Show regional data before a certain date.',),
        'f': ('Show regional data after a certain date.',),
        'i': ('Show regional data associated with a specific city.',),
        'c': ('Show regional data associated with a specific campaign.',),
        'a': ('Show all regional data.',),
        'r': ('Return to the main menu.',)
    }

    command = get_command('Geographical Data View', commands)

    # Based on the command, asks for required data and creates the where clause
    compare = ''
    where = ''
    if command == 'r':
        create_main_menu()
        return    
    elif command == 'b':
        compare = get_date_input('date to compare to')
        where = 'edate < %s'

    elif command == 'f':
        compare = get_date_input('date to compare to')
        where = 'sdate > %s'

    elif command == 'i':
        compare = input('Enter the name of the city to search for: ')
        compare = compare.strip().lower()
        where = 'lower(city) = %s'

    elif command == 'c':
        compare = get_campaign('compare to', False)
        where = 'cid = %s'
    
    # Gets all regional data related to the criteria, and gets summary
    all_phases = []
    summary = []
    if not command == 'a':
        all_phases = execute_sql('''
            select *
            from regional_data
            where ''' + where, [compare]) 
        summary = execute_sql('''
            select city, 
                count(distinct location) as locations, 
                count(distinct phid) as phases, 
                count(distinct cid) as campaigns, 
                count(distinct email) as volunteers
            from regional_data
            where ''' + where\
            + ' group by city;', [compare])
    else:
        all_phases = execute_sql('''
            select *
            from regional_data''')
        summary = execute_sql('''
            select city, 
                count(distinct location) as locations, 
                count(distinct phid) as phases, 
                count(distinct cid) as campaigns, 
                count(distinct email) as volunteers
            from regional_data
            group by city;
        ''')
    
    # Asks the user how to display the data
    command = ''
    print('Data has been fetched.')
    while not command in ['s', 'l', 'b']:
        command = input('Enter \'S\' to view summary,'\
            + ' \'L\' to view list of transactions,'\
            + ' or \'B\' to view both: ').strip().lower()
        
        if not command in ['s', 'l', 'b']:
            print('ERROR: Input must be \'S\', \'L\', or \'B\'.')
    
    # Dislays the data based on user request
    if command in ['l', 'b']:
        col_names = ['Phase', 'Campaign', 'Member Email', \
            'Start Date', 'End Date', 'City', 'Location']
        print_table(all_phases, col_names)

    if command in ['s', 'b']:
        bar_names = ['City', 'Locations', 'Phases', 'Campaigns', 'Volunteers']
        print_bar_graph(summary, bar_names, True)
    
    show_followup('view more regional data', show_regional_data)

# Allows the user to browse membership history
def show_mem_history():
    commands = {
        'c':('Report on the member history associated with a specific campaign.',),
        'p':('Report on the member history associated with a specific phase.',),
        'a':('Report on the overall member history across all of GNG.',),
        'd':('Report on the member history that starts and ends between two dates.',),
        'm':('Report on the member history associated with a specific member.',),
        'r':('Return to the main menu.',)
    }

    # Gets and handles a command from the user
    command = get_command('Member History View', commands).lower()
    where = ''
    if command == 'r':
        create_main_menu()
        return
    elif command == 'c':
        campaign_id = get_campaign('search for', False)
        where = 'where (cid = {0})'.format(campaign_id)    
    elif command == 'p':
        phase_id = get_phase('search for', False)
        where = 'where (phid = {0})'.format(phase_id)
    elif command == 'd':
        [sdate, edate] = get_start_end('to compare to')
        sdate = sdate.strftime("%Y-%m-%d") 
        edate = edate.strftime("%Y-%m-%d") 
        where = 'where (sdate > \'{0}\' and \
            (edate is null or edate < \'{1}\'))'.format(sdate, edate)
    elif command == 'm':
        mem_email = get_member('member to search for', False)
        where = 'where email = \'{0}\''.format(mem_email)
    else:
        where = 'where true'
    
    # Gets all history
    all_history = execute_sql('select * from mem_history ' + where + ';')
    
    # Gets the number of phases led
    phase_led = execute_sql('''
        select count(*) 
        from mem_history '''\
         + where + ' and event = \'Phase Leader\';')
    phase_led = 0 if phase_led == [] else phase_led[0][0]

    # Gets the total number of volunteers in phases
    phase_vol = execute_sql('''
        select count(*) 
        from mem_history '''\
         + where + ' and event = \'Phase Volunteer\';')
    phase_vol = 0 if phase_vol == [] else phase_vol[0][0]
            
    # Gets the number of campaigns led
    camp_led = execute_sql('''
        select count(*) 
        from mem_history '''\
         + where + ' and event = \'Campaign Leader\';')
    camp_led = 0 if camp_led == [] else camp_led[0][0]

    # Gets the total number of volunteers in campaigns
    camp_vol = execute_sql('''
        select count(*) 
        from mem_history '''\
         + where + ' and event = \'Campaign Volunteer\';')
    camp_vol = 0 if camp_vol == [] else camp_vol[0][0]

    # Asks the user how to present the data
    command = ''
    print('Data has been fetched.')
    while not command in ['s', 'l', 'b']:
        command = input('Enter \'S\' to view summary,'\
            + ' \'L\' to view list of transactions,'\
            + ' or \'B\' to view both: ').strip().lower()
        
        if not command in ['s', 'l', 'b']:
            print('ERROR: Input must be \'S\', \'L\', or \'B\'.')
    
    # Prints a table with all of the commands
    if command in ['l', 'b']:
        col_names = ['Email', 'Phase ID', 'Campaign ID', 'Start Date', 'End Date', 'Role']
        print_table(all_history, col_names)
        print('Note: a value of -1 means there is no associated phase/campaign.')

    # Prints the summary bar chart
    if command in ['s', 'b']:
        col_names = ['Phases Led', 'Phases Volunteered', \
            'Campaigns Led', 'Campaigns Volunteered']
        data = [phase_led, phase_vol, camp_led, camp_vol]
        print_bar_graph([data], col_names)
    
    show_followup('view more data on member history', show_mem_history)

# Allows the user to add annotations
def annotate():
    commands = {
        'c': ('View/add annotations to a campaign.',),
        'p': ('View/add annotations to a phase.',),
        'm': ('View/add annotations to a member.',),
        'd': ('View/add annotations to a donor.',),
        't': ('View/add annotations to a transaction.',),
        'r': ('Return to the main menu.',)
    }
    
    # Gets and handles the command from the user
    command = get_command('Annotations Editor', commands).lower()
    
    result = ''
    identifier = ''
    if command == 'r':
        create_main_menu()
        return
    elif command == 'c':
        identifier = get_campaign('annotate', False)
        sql = 'select notes from campaigns where cid = %s;'
        result = execute_sql(sql, [identifier])
    
    elif command == 'p':
        identifier = get_phase('annotate', False)
        sql = 'select notes from phases where phid = %s;'
        result = execute_sql(sql, [identifier])
        
    elif command == 'm':
        identifier = get_member('member to annotate', False)
        sql = 'select notes from members where email = %s;'
        result = execute_sql(sql, [identifier])

    elif command == 'd':
        identifier = get_donor('annotate', False)
        sql = 'select notes from donors where did = %s;'
        result = execute_sql(sql, [identifier]) 
    
    elif command == 't':
        identifier = get_transaction('annotate', False)
        sql = 'select notes from transactions where tid = %s;'
        result = execute_sql(sql, [identifier]) 
    
    # Gets the current annotation
    result = '' if result == [] else result[0][0]
    if (result == ''):
        print('There is currently no annotation.')
    else:
        print('The following is the current annotation: \n\''\
             + result + '\'')
    
    # Confirms adding to the annotation
    change = get_yes_no('Would you like to edit the annotation?').lower()
    if (change == 'y'):
        new_annotation = input('Please enter the new annotation: ').strip()
        
        print('\nUpdating annotation...')
        if command == 'c':
            execute_sql('''
                update campaigns 
                set notes = %s 
                where cid = %s;
            ''', [new_annotation, identifier]) 
        
        elif command == 'p':
            execute_sql('''
                update phases 
                set notes = %s 
                where phid = %s;
            ''', [new_annotation, identifier]) 
        elif command == 'm':
            execute_sql('''
                update members 
                set notes = %s 
                where email = %s;
            ''', [new_annotation, identifier]) 
        elif command == 'd':
            execute_sql('''
                update donors 
                set notes = %s 
                where did = %s;
            ''', [new_annotation, identifier]) 
        else:
            execute_sql('''
                update transactions 
                set notes = %s 
                where tid = %s;
            ''', [new_annotation, identifier]) 
        
        print('Annotation successfully updated.')

    show_followup('view/edit another annotation', annotate)

# Adds a donor to the database
def add_donor(is_return=True):

    # Gets the necessary fields
    donor_id = get_next_id('donors', 'did')
    contact_fname = get_string_input('first name of the contact', 20, False)
    contact_lname = get_string_input('last name of the contact', 20, False)
    donor_name = get_string_input('name of the donor', 40, True)
    
    # Asks for and validates the donors email
    contact_email = ''
    while not re.search(r'^.+@.+\..+', contact_email):
        contact_email = get_string_input('donor\'s contact email', 30, True)
        if not re.search(r'^.+@.+\..+', contact_email):
            print('ERROR: all emails must be of the form _______@___.__.')
    
    # Add the campaign to the database
    data = [donor_id, contact_fname, contact_lname, donor_name, contact_email]
    execute_sql('insert into Donors values (%s, %s, %s, %s, %s);', data)
    
    # Print the results and confirm insertion
    print()
    print('Created new campaign with the following fields:')
    col_names = ['ID', 'Contact First Name', 'Contact Last Name',\
         'Donor Name', 'Contact Email']
    print_table([data], col_names)
    
    if is_return:
        return donor_id

    retry = lambda: add_donor(False)
    show_followup('create another donor', retry)                  

# Adds a single campaign to the database and returns its id
def add_campaign():
    
    # Setup all of the fields for a campaign
    campaign_id = get_next_id('campaigns', 'cid')
    topic = get_string_input('environment topic of the campaign', 20, True)
    [sdate, edate] = get_start_end('of the campaign')    
    budget = get_float_input('budget for the campaign', 100, 99999999)
    
    # Add the campaign to the database
    sdate = sdate.strftime("%Y-%m-%d")
    edate = edate.strftime("%Y-%m-%d")
    data = [campaign_id, sdate, edate, budget, topic]
    execute_sql('insert into Campaigns values (%s, %s, %s, %s, %s);', data)
    
    # Print the results and confirm insertion
    print()
    print('Created new campaign with the following fields:')
    col_names = ['ID', 'Start Date', 'End Date', 'Budget', 'Topic']
    print_table([data], col_names)
    
    return campaign_id                  

# Adds a single phase to the database and returns its id
def add_phase():

    # Setup all of the fields for the phase
    phase_id = get_next_id('phases', 'phid')
    [sdate, edate] = get_start_end('of the campaign phase')
    city = get_string_input('city of the phase', 20, True)
    location = get_string_input('location in ' + city + ' of the phase', 30, True)
    phase_name = get_string_input('name of phase', 20, True)
    budget = get_float_input('budget for the phase', 50, 1500)
    
    # Insert the phase into the database
    sdate = sdate.strftime("%Y-%m-%d")
    edate = edate.strftime("%Y-%m-%d")
    data = [phase_id, sdate, edate, city, location, phase_name, budget]
    execute_sql('insert into Phases values (%s, %s, %s, %s, %s, %s, %s);', data)
    
    # Print results and confirm insertion
    print()
    print('Created new phase with the following fields:')
    col_names = ['ID', 'Start Date', 'End Date', 'City', 'Location', 'Name', 'Budget']
    print_table([data], col_names)

    return phase_id

# Adds a single member to the database and returns its id
def add_member(is_employee, is_return=True):
    
    # Setup and validate the member's email
    email = ''
    blocked_characters = [' ', '\\', '|', '<', '>', '/']
    while True:
        if not is_employee:
            email = get_string_input('member\'s email', 50, True)
        else:
            email = get_string_input('employee\'s email', 50, True)

        if True in [char in email for char in blocked_characters]:
            print('ERROR: Emails may not contain \''\
                 + '\', \''.join(blocked_characters) + '\'.')
        elif not is_employee and not re.search(r'^.+@.+\..+', email):
            print('ERROR: Invalid input. Input must be \'B\', \'C\', '\
                + ' or an email of the form _______@___.___.')
        elif is_employee and not re.search(r'^.+@gng.ca', email):
            print('ERROR: Invalid email. Employee emails must end in @gng.ca.')
        else:
            test = execute_sql('select * from members where email = %s;', [email])            
            if not test == []:
                print('ERROR: That email is already being used by another member.')
            else:
                break
    
    # Setup and validate the member's phone
    error = ''
    phone = ''
    result = None
    while not result:
        print(error)
        phone = input('Enter the member\'s phone number (XXX-XXX-XXXX): ')
        result = re.search(r'^(\d{3})-(\d{3})-(\d{4})$', phone)
        error = 'ERROR: Given number is not of the form XXX-XXX-XXXX.'
    
    # Setup the rest of the fields
    fname = get_string_input('member\'s first name', 20, True)
    lname = get_string_input('member\'s last name', 20, True)
    sdate = datetime.datetime.now()
    vhours = 0
    
    # Setup extra fields if the member is an employee
    if is_employee:
        salary = get_float_input('employee\'s salary', 10000, 50000)
        job = get_string_input('employee\'s job title', 50, False)

    # Insert the member into the database
    data = [email, phone, fname, lname, sdate.strftime("%Y-%m-%d"), vhours]
    execute_sql('insert into Members values (%s, %s, %s, %s, %s, %s);', data)
    
    # Print results and confirm insertion
    print()
    print('Created new member with the following fields:')
    col_names = ['Email', 'Phone', 'First Name', 'Last Name', 'Start Date', 'Hours']
    print_table([data], col_names)
    
    # If the member is an employee, inserts them into the employee table
    if is_employee:

        # Inserts the employee into the database
        data = [email, salary, job]
        execute_sql('insert into Employees values (%s, %s, %s);', data)
        
        # Print results and confirm insertion
        print()
        print('Created new employee with the following fields:')
        col_names = ['Email', 'Salary', 'Job Title']
        print_table([data], col_names)
    
    if is_return:
        return email

    retry = lambda: add_member(False, False)
    show_followup('create another member', retry)

# Reassigns a phase to a given campaign
def assign_phase():

    # Gets the id of the phase and campaign
    phase_id = get_phase('assign', False)
    campaign_id = get_campaign('assign the phase to', False)

    confirm = get_yes_no('Reassign the phase with id ' + str(phase_id)\
         + ' to the campaign with id ' + str(campaign_id) + '?')

    # Confirms update and updates
    if confirm == 'y':
        execute_sql('''
            update hasphase 
            set cid = %s 
            where phid = %s;''', [campaign_id, phase_id])
        print('Phase successfully reassigned.')

    show_followup('reassign another phase', assign_phase)

# Reassigns a member to a phase/campaign
def assign_member():

    # Gets the member's email
    mem_email = get_member('member to assign', False)
    
    # Checks whether to assign to a campaign or phase
    command = ''
    while not command in ['p', 'c']:
        command = input('Enter \'P\' to assign to a phase or \'C\''\
            + ' to assign to a campaign: ').strip().lower()
        if not command in ['p', 'c']:
            print('ERROR: Input must be \'P\' or \'C\'')
    
    # Gets the id of the phase or campaign and gets the organizer
    identifier = 0
    lead_email = ''
    if command == 'p':
        identifier = get_phase('assign the member to', False)
        lead_email = execute_sql('''
            select email from leadsphase where phid = %s
        ''', [identifier])
    else:
        identifier = get_campaign('assign the member to', False)
        lead_email = execute_sql('''
            select email from leadscampaign where cid = %s
        ''', [identifier])

    # Informs the user about the organizer status for the phase/campaign
    lead = ''
    if lead_email == []:
        print('There is currently no leader for this phase/campaign.')    
        lead = get_yes_no('Assign \'' + mem_email\
             + '\' as the leader for the phase/campaign?')
    else:
        lead_email = lead_email[0][0].strip()
        print('Member \'' + lead_email + '\' currently leads the phase/campaign.')
        lead = get_yes_no('Assign \'' + mem_email + '\' to replace \'' \
            + lead_email + '\' as the leader?')
    
    # Updates the appropriate table based on responses
    table = ''
    if command == 'p':
        if lead == 'y':
            execute_sql('''
                update leadsphase
                set email = %s
                where phid = %s;''', [mem_email, identifier])
        else:
            execute_sql('''
                insert into volunteerscampaign 
                values (%s, %s);''', [mem_email, identifier])
    else:
        if lead == 'y':
            execute_sql('''
                update leadscampaign
                set email = %s
                where cid = %s;''', [mem_email, identifier])
        else:
            execute_sql('''
                insert into volunteerscampaign 
                values (%s, %s);''', [mem_email, identifier])

    print('The member was successfully added to the phase/campaign.')

    show_followup('assign another member', assign_member)

# Get the id of a transaction
def get_transaction(desc, can_create):
    transaction_id = ''
    while True:

        # Construct the prompt for initial input
        prompt = '\nEnter the id of the transaction you\'d like to ' + desc\
            + ' (Type \'B\' to browse existing transactions'
        if can_create:
            prompt += ', or type \'C\' to create a new transaction to ' + desc
        prompt += '): '

        transaction_id = input(prompt).strip().lower()
        
        # Handles and validates input
        if transaction_id == 'b':
            command = 'y'
            while command == 'y':
                show_funds(True)
                command = get_yes_no('Do you need to perform another search?')
        elif can_create and transaction_id == 'c':
            print('Creating transaction...')
            transaction_id = add_transaction()
            break
        else:
            try:
                transaction_id = int(transaction_id)
            except ValueError:
                print('ERROR: Input must be \'B\', \'C\', or a valid integer.')
                continue
            
            # Confirms that the id exists
            test = execute_sql('''
                select * 
                from transactions 
                where tid = %s;''', [transaction_id])
            if test == []:
                print('ERROR: there are no current transactions with the id \''\
                     + str(transaction_id) + '\'.')
            else:
                break
        
    return transaction_id
 
# Gets a donor id from the user
def get_donor(desc, can_create):
    donor_id = ''
    while True:

        # Construct the prompt for initial input
        prompt = '\nEnter the id of the donor you\'d like to ' + desc\
            + ' (Type \'B\' to browse existing donors'
        if can_create:
            prompt += ', or type \'C\' to create a new donor to ' + desc
        prompt += '): '

        donor_id = input(prompt).lower()
        
        # Handles and validates input
        if donor_id == 'b':
            command = 'y'
            while command == 'y':
                show_donors(True)
                command = get_yes_no('Do you need to perform another search?')
        elif can_create and donor_id == 'c':
            print('Creating donor...')
            donor_id = add_donor()
            break
        else:
            try:
                donor_id = int(donor_id)
            except ValueError:
                print('ERROR: Input must be \'B\', \'C\', or a valid integer.')
                continue
            
            # Confirms that the id exists
            test = execute_sql('''
                select * 
                from donors 
                where did = %s;''', [donor_id])
            if test == []:
                print('ERROR: there are no current donors with the id \''\
                     + str(donor_id) + '\'.')
            else:
                break
        
    return donor_id 

# Gets a campaign id from the user
def get_campaign(desc, can_create):
    campaign_id = ''
    while True:
        
        # Construct the prompt for initial input
        prompt = '\nEnter the id of the campaign you\'d like to ' + desc\
             + ' (Type \'B\' to browse existing campaigns'
        if can_create:
            prompt += ', or type \'C\' to create a new campaign to ' + desc
        prompt += '): '

        campaign_id = input(prompt).lower()

        # Handles and validates input
        if campaign_id == 'b':
            command = 'y'
            while command == 'y':
                show_campaigns(True)
                command = get_yes_no('Do you need to perform another search?')
        elif can_create and campaign_id == 'c':
            print('Creating campaign...')
            campaign_id = add_campaign()
            break
        else:
            try:
                campaign_id = int(campaign_id)
            except ValueError:
                if can_create:
                    print('ERROR: Input must be \'B\', \'C\', or a valid integer id.')
                else:
                    print('ERROR: Input must be \'B\' or a valid integer id.')    
                continue
            
            # Verifies that the id exists
            test = execute_sql('''
                select * from campaigns 
                where cid = %s;''', [campaign_id])
            if test == []:
                print('ERROR: There are no current campaigns with the id \''\
                     + str(campaign_id) + '\'.')
            else:
                break

    return campaign_id

# Gets a phase id from the user
def get_phase(desc, can_create):
    phase_id = ''
    while True:
        
        # Construct the prompt for initial input
        prompt = '\nEnter the id of the phase you\'d like to ' + desc\
             + ' (Type \'B\' to browse existing phases'
        if can_create:
            prompt += ', or type \'C\' to create a new phase to ' + desc
        prompt += '): '

        phase_id = input(prompt).lower()

        # Validates and handles the input
        if phase_id == 'b':
            command = 'y'
            while command == 'y':
                show_phases(True)
                command = get_yes_no('Do you need to perform another search?')
        elif can_create and phase_id == 'c':
            print('Creating phase...')
            phase_id = add_phase()
            break
        else:
            try:
                phase_id = int(phase_id)
            except ValueError:
                if can_create:
                    print('ERROR: Input must be \'B\', \'C\', or a valid integer id.')
                else:
                    print('ERROR: Input must be \'B\' or a valid integer id.')    
                continue
            
            # Verifies that the id exists
            test = execute_sql('select * from phases where phid = %s;', [phase_id])
            if test == []:
                print('ERROR: There are no current phases with the id \''\
                     + str(phase_id) + '\'.')
            else:
                break

    return phase_id

# Retrieves and validates user input for a member's email
def get_member(desc, can_create):
    mem_email = ''
    while True:

        # Creates the prompt for email input
        prompt = '\nEnter the email of the ' + desc\
             + ' (Type \'B\' to browse existing members'
        if can_create:
            prompt += ', or type \'C\' to create a new member to be the '\
                 + desc
        prompt += '): '
        
        mem_email = input(prompt).strip()
        
        # Error checks and handles input
        if mem_email.lower() == 'b':
            command = 'y'
            while command == 'y':
                show_members(True)
                command = get_yes_no('Do you need to perform another search?')
        elif can_create and mem_email.lower() == 'c':
            print('Adding member...')
            is_employee = get_yes_no('Is the member an employee?')
            mem_email = add_member(is_employee.lower() == 'y')
            break
        elif not re.search(r'^.+@.+\..+', mem_email):
            if (can_create):
                print('ERROR: Input must be \'B\', \'C\', or'\
                    + ' an email of the form _____@__.__.')
            else:
                print('ERROR: Input must be \'B\' or an email of the form _____@__.__.')
        else:
            test = execute_sql('select * from members where email = %s;', [mem_email])
            if test == []:
                print('ERROR: There are no current members with the email \''\
                     + mem_email + '\'.')
            else:
                break
    
    return mem_email

# Creates a single transaction
def create_transaction ():

    # Gets the fields for a campaign
    transaction_id = get_next_id('transactions', 'tid')
    amount = get_float_input('amount of the transaction\n'
        + '(positive values represent income, negative values represent cost)\n', \
        -999999, 999999)
    dateof = get_date_input('date of the transaction')
    reason = get_string_input('reason for the transaction', 30, True)    

    # Inserts transaction into table
    col_names = ['ID', 'Amount', 'Date', 'Reason']
    data = [transaction_id, amount, dateof, reason]
    execute_sql('''
        insert into transactions values (%s, %s, %s, %s);
    ''', data)
    
    # Confirm insertion
    print('Inserted transaction with the following fields:')
    print_table([data], col_names)

    # If the transaction isn't a cost, asks if it's a donation
    donation = 'n'
    if (amount > 0):
        is_donation = get_yes_no('Is the transaction a donation?')
    
    # If the transaction is a donation, gets donor and possible campaign
    if is_donation == 'y':
        donor_id = get_donor('assign the donation to', True)    
        
        execute_sql('''
            insert into makesdonation values (%s, %s);
        ''', [donor_id, transaction_id])
        
        print('The transaction has been assigned to the donation.')

        has_campaign = get_yes_no('Was the donation to a campaign?')
        
        # If the donation has a campaign, gets campaign and adds
        if has_campaign == 'y':
            campaign_id = get_campaign('assign the donation to', False)        
            execute_sql('''
                insert into donatescampaign values (%s, %s);
            ''', [transaction_id, campaign_id])

            print('The transaction has been assigned to the campaign.')

    # If the transaction is not a donation, tries to assign to a phase
    has_phase = 'n'
    if is_donation == 'n':
        has_phase = get_yes_no('Is the transaction associated with a phase?')

    if has_phase == 'y':
        phase_id = get_phase('assign the transaction to', False)
        execute_sql('''
            insert into usestransaction values (%s, %s);
        ''', [transaction_id, phase_id])
        
        print('The transaction has been assigned to the phase.')

    show_followup('create another transaction', create_transaction)

# Prints a summary of an exisiting campaign
def print_campaign_summary(campaign_id):
    
    campaign_data = execute_sql('''
        select *
        from campaigns
        where cid = %s
    ''', [campaign_id])

    print('\nCurrent Campaign Data: ', end='')    
    col_names = ['ID', 'Start Date', 'End Date', 'Budget', 'Topic']
    print_table(campaign_data, col_names)

    volunteers = execute_sql('''
        select email, fname, lname, 'Organizer' as job
        from members m
        where exists(
            select * from leadscampaign
            where m.email = email
                and cid = %s
        ) 
        union
        select email, fname, lname, job
        from members m
        natural join volunteerscampaign
        where cid = %s and exists(
            select * from volunteerscampaign
            where m.email = email
                and cid = %s
        );
    ''', [campaign_id] * 3)

    print('\nVolunteers assigned to the campaign: ', end='')
    col_names = ['Email', 'First Name', 'Last Name', 'Role']
    print_table(volunteers, col_names)
    
    phase_data = execute_sql('''
        select phid, name, city, sdate, edate
        from phases ph
        where exists(
            select * from hasphase
            where phid = ph.phid
                and cid = %s
        );
    ''', [campaign_id])

    if not phase_data == []:
        print('\nPhases assigned to the campaign: ', end='')    
        col_names = ['ID', 'Phase Name', 'City', 'Start Date', 'End Date']
        print_table(phase_data, col_names)
    else:
        print('There are currently no phases assigned to the campaign.\n')
        
# Creates a campaign including adding volunteers and phases
def create_campaign():
    campaign_id = add_campaign()
    
    # Assign a member to organize the campaign 
    command = 'n'
    while command == 'n':
        organizer_email = get_member('organizer of the campaign', True) 
        command = get_yes_no('Assign \'' + organizer_email\
             + '\' to organize the campaign?')
        
        if command == 'y':
            execute_sql('''
                insert into LeadsCampaign 
                values (%s, %s);''', [organizer_email, campaign_id])
    
    print_campaign_summary(campaign_id)
  
    # Select volunteers to assist with the campaign
    command = get_yes_no('Assign volunteers to assist in organizing the campaign?')

    while command.lower() == 'y':
        volunteer_email = get_member('campaign volunteer', True)
        job = get_string_input('volunteer\'s role', 30, False)
        execute_sql('''
            insert into VolunteersCampaign 
            values (%s, %s, %s);''', [volunteer_email, campaign_id, job])
        
        print_campaign_summary(campaign_id)
        command = get_yes_no('Assign more volunteers to assist with the campaign?') 

    # Create a phase
    command = get_yes_no('Add a campaign phase to the campaign?')

    while command.lower() == 'y':
        create_phase(campaign_id) 
        
        print_campaign_summary(campaign_id)
        command = get_yes_no('Add another campaign phase to the campaign?')

    show_followup('create another campaign', create_campaign)

# Creates a phase including adding volunteers
def create_phase(campaign_id, is_return=True):
    
    # Gets the id of the campaign the phase will be assigned to
    if not campaign_id:
        campaign_id = get_campaign('assign your phase to', False)
    phase_id = add_phase()
    execute_sql('''
        insert into HasPhase 
        values (%s, %s);''', [campaign_id, phase_id])
        
    # Select a volunteer to lead the phase
    organizer_email = get_member('organizer for this campaign phase', True)
    execute_sql('''
        insert into LeadsPhase 
        values (%s, %s);''', [organizer_email, phase_id])        
    
    print('Organizer succesfully added.\n')

    # Select volunteers to assist with the phase    
    command = get_yes_no('Assign volunteers to assist with the campaign phase?')

    while command.lower() == 'y':
        volunteer_email = get_member('campaign phase volunteer', True)
        execute_sql('''
            insert into VolunteersPhase 
            values (%s, %s);''', [volunteer_email, phase_id])
        
        print('Volunteer successfully added.')
        command = get_yes_no('Assign more volunteers to assist with the campaign phase?') 

    if not is_return:
        retry = lambda: create_phase(0, is_return)
        show_followup('create another phase', retry)
    
# Executes an sql statent with arguments
def execute_sql(command, args=[]):
    res = []
    try:

        # Opens a connection to the server
        dbconn = psycopg2.connect(
        host='studentdb.csc.uvic.ca', 
            user='c370_s132', 
            password='iTASGZSh'
        )

        # Initiates the cursor and performs the query
        cursor = dbconn.cursor()
        cursor.execute(command, args)    

        # If the query is a select, fetches response
        if command.strip().split(' ')[0].lower() == 'select':
            res = cursor.fetchall()
        
        # Otherwise, commits change (insert/delete)
        else:
            dbconn.commit()

    # In the event of an error, outputs error and returns []
    except psycopg2.Error as err:
        print('\nAn error occured while accessing the database:\n' + err.pgerror)
        res = []

    # Closes cursor and connection
    cursor.close()
    dbconn.close()

    return res

# Presents and gets the answer to a Yes/No question
def get_yes_no(prompt):
    command = ''
    while not command in ['y', 'n']:
        command = input(prompt + ' (Y/N): ').strip().lower()
        if not command in ['y', 'n']:
            print('ERROR: Response must be \'Y\' or \'N\'.')
    
    return command

# Allos the user to browse donors
def show_donors(is_return):
    commands = {
        't': ('Search for donors who\'ve donated over specific amount.',),
        'c': ('Search for donors who\'ve donated to a specific campaign.',),
        'n': ('Search for donors by donor name.',),
        'a': ('Show all donors.',),
        'r': ('Return to the main menu',)
    }

    # Gets the command from the user
    selection = get_command('Donors View', commands)
    data = []

    # Handles the command from the user
    if selection == 'r':
        create_main_menu()
        return
    elif selection == 'c':
        campaign_id = get_campaign('search for', False)
        data = execute_sql('''
            select * 
            from donors d
            where exists(
                select * from donates_campaign dc
                where d.did = dc.did and dc.cid = %s
            );
        ''', [campaign_id])
    
    elif selection == 't':
        amount = get_int_input('integer amount to search for', 0)
        data = execute_sql('''
            select * from donors d
            where exists(
                select * from total_donated
                where d.did = did and total >= %s
            );
        ''', [amount])

    elif selection == 'n':
        search_term = '%' + get_string_input('search term', 0, True).lower() + '%'
        data = execute_sql('''
            select * from donors d
            where lower(dname) like %s;
        ''', [search_term])
    else:
        data = execute_sql('''
            select * from donors
        ''')

    # Gets the results from the database
    col_names = ['Donor ID', 'Contact First Name', 'Contact Last Name',\
         'Donor Name', 'Email', 'Notes']
    
    # Checks if the results are empty (No returned rows)
    if data == []:
        print()
        if(selection == 'a'):
            print('There are no campaigns in the database.')
        else:
            print('There are no campaigns matching your criteria')
    else:
        print_table(data, col_names)
    
    # If the function is allowed to repeat
    if not is_return:
        repeat = lambda: show_donors(False)
        show_followup('perform another search', repeat)    
    
    
# Displays a list of campaigns along with several filtering options
def show_campaigns(is_return):
    commands = {
        'l': ('Search for campaigns led by a specific member.', 'organizer to search'),
        'v': ('Search for campaigns with a specific volunteer.', 'volunteer to search'),
        's': ('Search for campaigns with a start date after a given date.',),
        'e': ('Search for campaigns with an end date before a given date.',),
        'a': ('Show all campaigns.',),
        'r': ('Return to the main menu.',)
    }
    
    # Get the list of allowed commands
    selection = get_command('Campaigns View', commands)
    data = []

    # Handles searching base on volunteers
    if selection == 'r':
        create_main_menu()
        return
    elif selection in ['l','v']:
        mem_email = get_member(commands[selection][1], False)
        
        # Searching based on leader
        if selection == 'l':
            data = execute_sql('''
                select * from campaigns c
                where exists (
                    select * from leadscampaign 
                    where c.cid = cid and email = %s);
            ''', [mem_email])
        
        # Searching based on volunteer
        else:
            data = execute_sql('''
                select * from campaigns c
                where exists (
                    select * from volunteerscampaign 
                    where c.cid = cid and email = %s);
            ''', [mem_email])
    
    # All campaigns
    elif selection == 'a':
        data = execute_sql('select * from campaigns;')
    
    # Date comparison
    else:
        comp_date = get_date_input('date you\'d like to compare to')
        if selection == 's':
            data = execute_sql('''
                select * from campaigns 
                where sdate >= %s;''', [comp_date.strftime("%Y-%m-%d")])
        elif selection == 'e':
            data = execute_sql('''
                select * from campaigns 
                where edate <= %s;''', [comp_date.strftime("%Y-%m-%d")])
    
    # Gets the results from the database
    col_names = ['Campaign ID', 'Start Date', 'End Date', 'Budget', 'Topic']
    
    # Checks if the results are empty (No returned rows)
    if data == []:
        print()
        if(selection == 'a'):
            print('There are no campaigns in the database.')
        else:
            print('There are no campaigns matching your criteria')
    else:
        print_table(data, col_names)
    
    # If the function is allowed to repeat
    if not is_return:
        repeat = lambda: show_campaigns(False)
        show_followup('perform another search', repeat)    

# Lists the phases in the database and allows for certain filters
def show_phases(is_return):
    commands = {
        'l': ('Search for phases led by a specific member.', 'organizer'),
        'v': ('Search for phases with a specific volunteer.', 'volunteer'),
        's': ('Search for phases with a start date after a given date',),
        'e': ('Search for phases with an end date before a given date',),
        'a': ('Show all phases',),
        'r': ('Return to the main menu.',)
    }
    
    # Get the list of allowed commands
    selection = get_command('Campaign Phase View', commands)
    data = []
 
    # Handles searching based on a volunteer
    if selection == 'r':
        create_main_menu()
        return
    elif selection in ['l','v']:
        mem_email = get_member(commands[selection][1], False)
        
        # Searching based on leader
        if selection == 'l':
            data = execute_sql('''
                select * from phases ph
                where exists (
                    select * from leadsphase 
                    where ph.phid = phid and email = %s);
            ''', [mem_email])
        
        # Searching based on volunteer
        else:
            data = execute_sql('''
                select * from phases ph
                where exists (
                    select * from volunteersphase 
                    where ph.phid = phid and email = %s);
            ''', [mem_email])
    
    # All dates
    elif selection == 'a':
        data = execute_sql('select * from phases;')
    
    # Filters based on date comparison
    else:
        comp_date = get_date_input('date you\'d like to compare to')
        if selection == 's':
            data = execute_sql('''
                select * from phases 
                where sdate >= %s;''', [comp_date.strftime("%Y-%m-%d")])
        elif selection == 'e':
            data = execute_sql('''
                select * from phases 
                where edate <= %s;''', [comp_date.strftime("%Y-%m-%d")])
    
    # Fetches all entries matching the criteria
    col_names = ['Phase ID', 'Start Date', 'End Date', \
        'City', 'Location', 'Name', 'Budget']
    
    # Checks if the results are empty (No returned rows)
    if data == []:
        print()
        if(selection == 'a'):
            print('There are no phases in the database.')
        else:
            print('There are no phases matching your criteria')
    else:
        print_table(data, col_names)
    
    # If the function can be run again, show prompt to rerun
    if not is_return:
        repeat = lambda: show_phases(False)
        show_followup('perform another search', repeat)    
    
# Allows the user to browse existing members    
def show_members(is_return):
    commands = {
        'f': ('Search for members by first name.', 'fname', 'a first name containing'),
        'l': ('Search for members by last name.', 'lname', 'a last name containing'),
        'e': ('Search for members by email.', 'email', 'an email containing'),
        'a': ('View all members.', '', ''),
        'r': ('Return to the main menu.',)
    }
    
    # Get the list of allowed commands
    selection = get_command('Member\'s View', commands)
    data = []
 
    # Gets and validates the search term
    search_term = ''
    blocked_characters = [' ', '\\', '|', '<', '>', '/']
    if selection == 'r':
        create_main_menu()
        return
    elif selection == 'a':
        data = execute_sql('select * from members')
    else:
        while True:
            search_term = get_string_input('search term', 0, True)
            if True in [char in search_term for char in blocked_characters]:
                print('ERROR: Search terms cannot contain \''\
                     + '\', \''.join(blocked_characters) + '\'.')
                continue
            break
        
        # Performs the query
        query = '''
            select * from members 
            where lower(''' + commands[selection][1] + ') like %s;' 
        data = execute_sql(query, ['%' + search_term.lower() + '%'])
    
    col_names = ['Email', 'Phone', 'First Name', 'Last Name', 'Start Date', 'Hours']
   
    # Checks if the results are empty (No returned rows)
    if data == []:
        print()
        if(selection == 'a'):
            print('There are no members in the database.')
        else:
            print('There are no members with ' + commands[selection][2]\
                 + ' \'' + search_term + '\'.')
    else:
        print_table(data, col_names)
    
    if not is_return:
        repeat = lambda: show_members(False)
        show_followup('perform another search', repeat)    

# Gets a command from a user and validates input
def get_command(title, commands):
     
    # Get the list of allowed commands
    possible_commands = list(commands.keys())
    
    # Print the table of commands and their descriptions
    col_names = ['Command', 'Description']
    table_contents = [[key, commands[key][0]] for key in possible_commands]
    print_table(table_contents, col_names, title)
    
    # Get input command, repeat until a valid command is given
    error = ''
    selection = ''
    while not selection in possible_commands:
        print(error)
        selection = input('Please enter a valid command: ').strip().lower()
        error = 'Sorry, \'' + selection + '\' is not an existing command.'
    
    return selection

# Gets the next id to give a new entity
def get_next_id (table_name, id_name):
    command = 'select max(' + id_name + ') from ' + table_name + ';'
    next_id = int(execute_sql(command)[0][0])
    return next_id + 1

# Gets a whole number from 1 to a specified max
def get_int_input(desc, max_int):
    error = ''
    while True:
        print(error)

        # Verifies that the input is a number
        try:
            if max_int:
                val = int(input('Please enter the ' + desc\
                     + ' (Min: 1, Max: ' + str(max_int) + '): '))
            else:
                val = int(input('Please enter the ' + desc + ' (Minimum: 1): '))
        except ValueError:
            error = 'ERROR: Input is not an integer.'
        else:
            # Verifies that the input is within the given range
            if val < 1 or (max_int and val > max_int):
                if max_int:
                    error = 'ERROR: ' + str(val)\
                         + ' is not between 1 and ' + str(max_int) + '.'
                else:
                    error = 'ERROR: ' + str(val) + ' is not greater than 1.'    
                continue
            else:
                break

    return val

# Gets a floating point value from the user and validates input
def get_float_input(desc, min_val, max_val):
    error = ''
    budget = None

    # Asks until the budget is within the given range
    while not budget or budget < min_val or budget > max_val:
        print(error)
        budget_str = input('Enter the ' + desc\
             + ' (Min: $' + str(min_val)\
             + ', Max: $' + str(max_val) + '): ')
        try:
            budget = float(budget_str.replace(',', '').replace('$',''))
        except ValueError:
            error = 'ERROR: Input is not a number.'\
                + ' Please exclude dollar signs (\'$\') and commas (\',\').'
        else:    
            budget = round(budget, 2)
            error = 'ERROR: $' + str(budget) + ' is not between $'\
                 + str(min_val) + ' and $' + str(max_val) + '.'
    
    return budget

# Gets a string input from the user and validates length
def get_string_input(desc, max_length, is_req):
    error = ''
    given_str = ''

    # Asks user for input until it is a valid length
    while ((error == '') or (is_req and given_str == '') 
        or (max_length and len(given_str) > max_length)):
        print(error)

        # Constructs the prompt for initial input
        prompt = 'Enter the ' + desc
        if max_length:
            prompt += ' (max ' + str(max_length) + ' characters)'
        prompt += ': '

        given_str = input(prompt).strip()

        # Sets the error message
        if is_req and given_str == '':
            error = 'ERROR: This field cannot be left empty.'
        else:
            error = 'ERROR: Input is longer than ' + str(max_length) + ' characters.'
    
    return given_str

# Gets and validates a start and end date
def get_start_end(desc):
    sdate = get_date_input('start date ' + desc) 
    
    error = ''
    edate = None

    # Confirms that the end date occurs after the start date
    while not edate or  edate < sdate:
        edate = get_date_input('end date ' + desc)
        if edate < sdate:
            error = 'ERROR: End date must occur after the given start date.\n'\
                 + 'Given start date: ' + sdate.strftime("%Y-%m-%d") + '\n'\
                 + 'Given end date: ' + edate.strftime("%Y-%m-%d")
            print(error)

    return [sdate, edate]

# Gets and validates a date input
def get_date_input(desc):
    error = ''
    date = None

    # Runs until a valid date is given
    while not date:
        print(error)
        date_str = input('Enter the ' + desc + ' (YYYY-MM-DD): ')
        result = re.search(r'^(\d{1,4})-(\d{1,2})-(\d{1,2})$', date_str)
        if not result:
            error = 'ERROR: Given date is not of the form YYYY-MM-DD.'
        else:
            date_format = '{0:0>4}-{1:0>2}-{2:0>2}'
            reformat = date_format.format(*list(result.groups()))
            try:
                date = datetime.date.fromisoformat(reformat)
            except ValueError:
                error = 'ERROR: Given date is of the form YYYY-MM-DD.'\
                    + ' Unfortunately, the date does not exist.'
                continue

    return date

if __name__ == "__main__": 
    main()
