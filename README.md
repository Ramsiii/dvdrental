For this project, I used PostgreSQL, pgAdmin4, and Cursor IDE.
For the presentation, I used WGU's "Labs on Demand Assessment Environment" for the final project submission.
Due to the outdated version of PostgreSQL running on this virtual machine (V 13.3) I had to adapt some SQL queries. e.g. DROP TRIGGER IF EXISTS + CREATE TRIGGER in lieu of CREATE OR REPLACE (V 14+).

The DVD database contains data from 2005 and 2006, spanning three quarters: 2005-Q2, 2005-Q3, and 2006-Q1.

The task from WGU: "Summarize one real-world written business report that can be created from the DVD Dataset."

The hypothetical scenario:

"Which 100 titles should we digitize first?"

The year is 2006. I aim to acquire a currently-operating DVD Rental business to launch an online movie platform with a subscription service. I will utilize its rental data to choose which 100 movies to start with. The decision is based on a snapshot of the current total rentals for each film in the top 100 by dense rank.

The more specific question answered is:

Which are the 100 most popular titles across the entire dataset spanning 2005-2006?
Clients will pay for tiers of “movies per week,” and the movies will be automatically downloaded to their home PCs by a specific date. Because of limited bandwidth, I aim to start by digitizing the first 100 most popular movies and add new releases over time. My project aims to answer the question “Which are the 100 most popular titles over time?” with the aim to answer the main question: “Which 100 titles should we digitize first?”



