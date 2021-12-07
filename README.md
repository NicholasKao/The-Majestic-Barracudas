# The-Majestic-Barracudas
Updated Project Proposal

I would like to investigate the role that co-workers play in allegations. I would like to look into both the role of the unit to which an officer is assigned as well as officers “partners” on given “beats”. Do we find that different characteristics about units result in higher or lower rates of allegations for officers of that unit? What role does the composition of police units play? By investigating key features of the police unit and tying them out with the allegation data, we can look for patterns that may emerge. Ideally, we will uncover characteristics about lower offending units and identify potential changes to be made to the compositions of police units. For example, do units with more ethnic diversity have lower rates of allegations? Do units with LEO’s that have been in the same unit for a long time see lower rates? Additionally, I would like to investigate the effect that “partners”, or officers assigned to the same beat/shift have on an officer’s rate of complaints. Do we find that certain officers are commonly paired with officers that are receiving complaints (“enablers”)? By answering questions like these, we may be better able to construct a police unit in a manner that is correlated with lower rates of allegations as well as assign partners in a better way.

Relational Analytics
•	How large is each police unit? The average police units?
•	Many background questions such as, for each unit, the average:
o	Age, years on force, % male vs. female, number of different races, etc.
•	Number of complaints filed against members of each different unit, aggregating to average number of complaints per LEO in each unit
•	How many shifts/beats do certain partners work together?
•	How often is one partner indicated on an allegation but not the other?
o	I am interested in this specifically to see if there is a pattern of certain officers being around behavior resulting in allegations but not being listed on the allegations. Are these officers “enabling” their partners to act out but not participating themselves?

Data Exploration
•	Scatterplot with key characteristics of units vs. number of complaints against the unit
•	Scatterplot with key characteristics of units vs. number of TRRs

Interactive Visualization
•	Dot plots of changes in unit compositions between years compared to changes in allegation rates per year. Specifically, changes in gender and racial entropy vs. allegation rates per officer for each unit. Adjusting a sliding bar allows users to select the year they want to see compared to the prior year.
•	Dot plots of changes in unit compositions between years compared to changes in trr rates per year. Specifically, changes in gender and racial entropy vs. trr rates per officer for each unit. Adjusting a sliding bar allows users to select the year they want to see compared to the prior year.
•	Note: time and bandwidth permitting, I will try to turn the dot plots into connected dot plots for the final submission of my project.

Graph Analytics
•	Are there officers that are frequently working with (on the same shift/beat as) officers that are receiving complaints? By using graph analytics I can connect nodes (officers) that work together and identify when there are complaints against one but not the other. This can help us to potentially identify “enabler”, a term that I will use to refer to officers that are not showing up on allegations but are working with officers that do.
•	As recommended in the last feedback; using triangle counting to create graphs of co-accusals (inter-unit and intra-unit) and determine which one is more clustered. If the inter-unit is more clustered, the unit may play a significant role. If the intra-unit is more clustered, the effect of the unit may not be that significant.

NLP Models
•	Sentiment analysis on the available free-form text of a complaint then related to the demographics of the officers’ specific units. Do we see a more negative sentiment between complaints against an officer of a unit that is more homogenous? 


