Google Colaboratory Link: https://colab.research.google.com/drive/1dQtjzi0tWkK7VuvBMdbFew5b0XAOO1ej?usp=sharing

How to Run
•	Recommended: run in Google Colaboratory on Google Chrome, as there are dependencies required via installation that do not work on Mac OS (specifically apt-get, wget commands)
•	Simply run all cells in order
•	I also included the .py and .ipynb files in the src folder


Questions and How to View
•	Are there officers that are frequently working with (on the same shift/beat as) officers that are receiving complaints? By using graph analytics I can connect nodes (officers) that work together and identify when there are complaints against one but not the other. This can help us to potentially identify “enabler”, a term that I will use to refer to officers that are not showing up on allegations but are working with officers that do.
•	You can view the “answers” to this question by investigating the number of “indegrees” in the first graph as well as looking at the PageRank of the first graph, since that also ranks based on number of indegrees and importance of incoming connections.

•	As recommended in the last feedback; using triangle counting to create graphs of co-accusals (inter-unit and intra-unit) and determine which one is more clustered.
•	You can view the “answers” to this question by looking at the average triangle counts between the graph for inter-unit coaccusals and intra-unit coaccusals. These values are printed out in the cells.


