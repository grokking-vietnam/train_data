## Statiscial reports

These contains reports that give insight into the company's operations.
It will most likely be generated from the transaction data.

### Revenue/Profit/Volumes

Show daily/monthly/quarterly/yearly revenue we earned.

- Smallest time unit: day
- Filter by: start, end, category

For example:

| day            | category     | revenue (USD) |
|----------------|--------------|---------------|
| Aug 09-08-2016 | men-clothing | 537           |
| Aug 10-08-2016 | men-clothing | 235           |
| Aug 11-08-2016 | men-clothing | 492           |
| Aug 12-08-2016 | men-clothing | 651           |
| Aug 13-08-2016 | men-clothing | 763           |
| Aug 14-08-2016 | men-clothing | 528           |
| Aug 15-08-2016 | men-clothing | 259           |
| Aug 16-08-2016 | men-clothing | 631           |

```
REVENUE
== Sum(% we earned * price_micros of all order_items in date range)

Note: the % we earned should vary (and intentionally not documented).
To reflect real price change, it should increase overtime,
with a small dip after the revenue increases

------------------------------------------------------------------------------
------------------------------------------------------------------------------

PROFIT
== Sum(item revenue, minus delivery cost)

------------------------------------------------------------------------------
------------------------------------------------------------------------------

VOLUME
== Count(order_items in date range)

```

<hr>

### Top X items in Revenue/Profit/Volume

Show the top X items, with respect to their daily/monthly/quarterly/yearly amount

- Filter by: start, end, category, time unit

| items          | rank |
|----------------|------|
| macbook air    | 1    |
| apple ipad 2   | 2    |
| men's polo 123 | 3    |

```
Need to aggregate the amount according to time unit, then sort
```
