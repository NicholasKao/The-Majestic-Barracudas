# -*- coding: utf-8 -*-
"""CP4.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1dQtjzi0tWkK7VuvBMdbFew5b0XAOO1ej
"""

# install java
!apt-get install openjdk-8-jdk-headless -qq > /dev/null

# install spark (change the version number if needed)
!wget -q https://archive.apache.org/dist/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz

# unzip the spark file to the current folder
!tar xf spark-3.2.0-bin-hadoop3.2.tgz

# set your spark folder to your system path environment. 
import os
os.environ["JAVA_HOME"] = "/usr/lib/jvm/java-8-openjdk-amd64"
os.environ["SPARK_HOME"] = "/content/spark-3.2.0-bin-hadoop3.2"

# install findspark using pip
!pip install -q findspark

# install pyspark
!pip3 install pyspark==3.2.0

# install graphframes
!pip3 install graphframes

!wget -q https://repos.spark-packages.org/graphframes/graphframes/0.8.2-spark3.2-s_2.12/graphframes-0.8.2-spark3.2-s_2.12.jar

!mv  graphframes-0.8.2-spark3.2-s_2.12.jar $SPARK_HOME/jars/

#import the packages
from pyspark import *
from pyspark.sql import *
from graphframes import *
import findspark
import pandas as pd
import numpy as np
import psycopg2

findspark.init()

# Start a Spark session
spark = SparkSession.builder.master("local[*]").getOrCreate()

conn = psycopg2.connect(
    host="codd01.research.northwestern.edu",
    database="postgres",
    user="cpdbstudent",
    password="DataSci4AI")
cursor = conn.cursor()

q1 = """SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name = 'data_officerassignmentattendance'"""
cursor.execute(q1)
columns = cursor.fetchall()
columns = [x[0] for x in columns]
columns.extend(['partner_officer_id','had_allegation','allegation_id','partner_had_allegation',
                'partner_allegation_id'])
q2 = """SELECT q1.*,
       q2.officer_id as partner_officer_id,
       CASE WHEN q3.allegation_id IS NOT NULL THEN 1 ELSE 0 END AS had_allegation,
       q3.allegation_id as allegation_id,
       CASE WHEN q4.allegation_id IS NOT NULL THEN 1 ELSE 0 END AS partner_had_allegation,
       q4.allegation_id as partner_allegation_id
FROM data_officerassignmentattendance q1
LEFT JOIN data_officerassignmentattendance q2 ON q1.beat_id = q2.beat_id and q1.start_timestamp = q2.start_timestamp and q1.end_timestamp = q2.end_timestamp
LEFT JOIN (
SELECT * FROM data_allegation da
LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
WHERE is_officer_complaint is False
AND officer_id IS NOT NULL
AND incident_date >= '2010-01-01'
AND incident_date < '2016-01-01'
    ) q3 ON q1.officer_id = q3.officer_id AND (date(q1.start_timestamp) = date(q3.incident_date) OR date(q1.end_timestamp) = date(q3.incident_date))
LEFT JOIN (
SELECT * FROM data_allegation da
LEFT JOIN data_officerallegation doa ON da.crid = doa.allegation_id
WHERE is_officer_complaint is False
AND officer_id IS NOT NULL
AND incident_date >= '2010-01-01'
AND incident_date < '2016-01-01'
    ) q4 ON q2.officer_id = q4.officer_id AND (date(q2.start_timestamp) = date(q4.incident_date) OR date(q2.end_timestamp) = date(q4.incident_date))
WHERE q1.officer_id <> q2.officer_id
AND q1.start_timestamp >= '2010-01-01'
AND q1.end_timestamp < '2016-01-01'
AND q1.present_for_duty = True
AND q2.officer_id IS NOT NULL
AND q3.allegation_id IS NULL
AND q4.allegation_id IS NOT NULL"""
cursor.execute(q2)
partner_allegations = pd.DataFrame(data = cursor.fetchall(), columns=columns)

df1 = spark.createDataFrame(partner_allegations[['officer_id','partner_officer_id']])

officers = df1.select("officer_id").distinct()
partners = df1.select("partner_officer_id").distinct()
partners = partners.withColumnRenamed("partner_officer_id", "officer_id")

nodes = officers.union(partners).distinct()
nodes = nodes.withColumnRenamed("officer_id","id")

edges = df1.select(['officer_id','partner_officer_id'])
edges = edges.withColumnRenamed("officer_id", "dst")
edges = edges.withColumnRenamed("partner_officer_id", "src")

g1 = GraphFrame(nodes, edges)

g1.inDegrees.agg({'inDegree':'mean'}).show()

g1.inDegrees.sort(['inDegree'],ascending=[0]).show()

pr_g1 = g1.pageRank(resetProbability=0.15, tol=0.01)
#look at the pagerank score for every vertex
pr_g1.vertices.orderBy('pagerank', ascending=False).show()

columns = ['crid','incident_date','coaccused_count','officer_id','officer_unit','coaccused_id',
           'coaccused_unit','same_unit']
q1 = """SELECT q1.*,
       doi.last_unit_id as officer_unit,
       q2.officer_id as coaccused_id,
       doi2.last_unit_id as coaccused_unit,
       CASE WHEN doi.last_unit_id = doi2.last_unit_id THEN 'Yes' ELSE 'No' END as same_unit
FROM
(SELECT da.crid, da.incident_date, da.coaccused_count, doa.officer_id FROM data_allegation da
LEFT JOIN data_officerallegation doa on da.crid = doa.allegation_id
WHERE incident_date >= '2010-01-01' AND incident_date < '2016-01-01'
AND is_officer_complaint = False
AND coaccused_count >= 2) q1
LEFT JOIN (
SELECT da.crid, da.incident_date, da.coaccused_count, doa.officer_id FROM data_allegation da
LEFT JOIN data_officerallegation doa on da.crid = doa.allegation_id
WHERE incident_date >= '2010-01-01' AND incident_date < '2016-01-01'
AND is_officer_complaint = False
AND coaccused_count >= 2) q2 ON q1.crid = q2.crid
LEFT JOIN data_officer doi ON q1.officer_id = doi.id
LEFT JOIN data_officer doi2 ON q2.officer_id = doi2.id
WHERE q1.officer_id <> q2.officer_id"""
cursor.execute(q1)
coaccusals = pd.DataFrame(data = cursor.fetchall(), columns=columns)

df2 = spark.createDataFrame(coaccusals)

same_units = spark.createDataFrame(coaccusals[coaccusals['same_unit'] == 'Yes'])
diff_units = spark.createDataFrame(coaccusals[coaccusals['same_unit'] == 'No'])

edges3 = same_units.select(['officer_id','coaccused_id'])
edges3 = edges3.withColumnRenamed('officer_id','src')
edges3 = edges3.withColumnRenamed('coaccused_id','dst')

edges4 = diff_units.select(['officer_id','coaccused_id'])
edges4 = edges4.withColumnRenamed('officer_id','src')
edges4 = edges4.withColumnRenamed('coaccused_id','dst')

officers3 = same_units.select(["officer_id","officer_unit"]).distinct()
coaccused3 = same_units.select(["coaccused_id","coaccused_unit"]).distinct()
coaccused3 = coaccused3.withColumnRenamed("coaccused_id", "officer_id")
coaccused3 = coaccused3.withColumnRenamed("coaccused_unit", "officer_unit")

nodes3 = officers3.union(coaccused).distinct()
nodes3 = nodes3.withColumnRenamed("officer_id","id")

officers4 = diff_units.select(["officer_id","officer_unit"]).distinct()
coaccused4 = diff_units.select(["coaccused_id","coaccused_unit"]).distinct()
coaccused4 = coaccused4.withColumnRenamed("coaccused_id", "officer_id")
coaccused4 = coaccused4.withColumnRenamed("coaccused_unit", "officer_unit")

nodes4 = officers4.union(coaccused).distinct()
nodes4 = nodes4.withColumnRenamed("officer_id","id")

g_same_unit = GraphFrame(nodes3, edges3)
g_diff_unit = GraphFrame(nodes4, edges4)

triangles_same_unit = g_same_unit.triangleCount()

triangles_same_unit.agg({'count':'mean'}).show()

triangles_diff_unit = g_diff_unit.triangleCount()

triangles_diff_unit.agg({'count':'mean'}).show()

# NetworkX to visualize the graph
import networkx as nx

def plot_graph(gx):
    g = nx.DiGraph(directed = True)
    
    g = nx.from_pandas_edgelist(gx.edges.toPandas(),'src','dst')
    g.add_nodes_from(gx.vertices.toPandas()['id'])

    nx.draw(g, with_labels=True, arrows = True, node_color='grey')

plot_graph(g_same_unit)

plot_graph(g_diff_unit)
