# Music Store Database Analysis

SQL analysis of a 7-table relational music database using joins, CTEs, and window functions (DENSE_RANK, PARTITION BY) — found Queen as the best-selling artist, R Madhav as the top customer ($144.54), and Rock as the dominant genre in 22 of 23 countries analyzed.

## Dataset

A relational music store database (Chinook-style schema) with tables including:
- `employee` — employee details and job levels
- `customer` — customer details
- `invoice` / `invoice_line` — purchase records and line items
- `track` — song-level details (name, length, genre, album)
- `album`, `artist`, `genre`, `media_type`, `playlist`, `playlist_track` — supporting catalog tables

## Tools Used

- PostgreSQL

## Analysis Breakdown

**Easy**
- Most senior employee by job level
- Countries with the most invoices
- Top 3 invoice values
- City and customer with the highest total spend

**Moderate**
- Customers who listen to Rock music, ordered alphabetically by email
- Top 10 rock bands by track count
- Tracks longer than the average song length

**Advanced**
- Customer who spent the most on the best-selling artist (using CTEs)
- Most popular music genre for each country (window functions: DENSE_RANK, PARTITION BY)
- Top-spending customer for each country, including ties

## Key Findings

- **Queen** was the best-selling artist store-wide
- **R Madhav** was the top overall customer by total spend (**$144.54**)
- The **USA** generated the most invoices (**131**)
- **Rock** was the most popular genre in **22 of 23** countries analyzed, with Argentina being the sole exception (Alternative & Punk)

## Author

Sommya Loharuka

## Acknowledgement

The dataset and question set for this project were inspired by a publicly available SQL practice tutorial. All queries were written, reviewed, and tested independently to deepen my understanding of joins, CTEs, and window functions.
