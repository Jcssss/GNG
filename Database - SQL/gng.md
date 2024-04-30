We convert our ER Diagram's Entity Sets into the following Relations:
1. Campaigns(<u>cid</u>, sdate, edate, budget, topic)
2. Phases(<u>phid</u>, sdate, edate, city, location, name, budget)
3. Members(<u>email</u>, phone, fname, lname, sdate, vhours)
4. Employees(<u>email</u>, salary, job)
5. Transactions(<u>tid</u>, amount, dateof, reason)
6. Donors(<u>did</u>, cfname, clname, dname, email)

Please note of the following explanations for isa handling:
1. We chose to implement the isa relationship between Volunteers and Members using Nulls. However, since we chose to implement an E/R approach for Employees (explained in the next point), we don't actually need to use Nulls. Since entries in the Members relation cannot be Employees, they are either volunteers or supporters where supporters have 0 volunteer hours and will not be associated to any campaign phases via relationships. Thus, we can represent the non-volunteers by using 0s in the vhours attribute instead of nulls.
2. We chose to implement the isa relationship between Employees and Members using an E/R approach. Since there are very few employees, it didn't make sense to use the null approach, as we would have a significant number of nulls in the salary and roles attributes. Then between the E/R and Object Oriented approach we chose the E/R approach since it is more optimal for queries such as "Find all members that have led a campaign.". On top of this, it makes sense that some Employees could be volunteers OR could have been volunteers before becoming employed. As a result, it's helpful to maintain the employees volunteer hours and publicity campaigns within the database, something that is easier to implement with the E/R approach.
3. We chose to implement the isa relationship between Donations and Transactions using none of the E/R, Object Oriented, or Null approaches. Instead, Donations are a special case of transactions where the "reason" attribute has the value "Donation".

Next, we convert the ER Diagram's Relationship Sets into Relations. Note that most of the relationships were renamed for clarity. All renamings are noted below:
1. DonatesCampaign(<u>tid</u>, <u>cid</u>)
2. MakesDonation(<u>did</u>, <u>tid</u>)
3. HasPhase(<u>cid</u>, <u>phid</u>) \
   [***Note***: Originally the 'Has' relationship]
4. VolunteersPhase(<u>email</u>, <u>phid</u>) \
   [***Note***: Originally the 'Volunteers' relationship]
6. VolunteersCampaign(<u>cid</u>, <u>email</u>, job) \
   [***Note***: Originally the 'Assists' relationship]
8. LeadsPhase(<u>phid</u>, <u>email</u>) \
   [***Note***: Originally the 'Leads' relationship]
10. LeadsCampaign(<u>cid</u>, <u>email</u>) \
    [***Note***: Originally the 'Organizes' relationship]
11. UsesTransaction(<u>tid</u>, <u>phid</u>) \
    [***Note***: Originally the 'Involves' relationship]