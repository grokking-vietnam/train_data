## Statiscial reports

These contains reports that give insight into the company's operations.
It will most likely be generated from the transaction data.

### Revenue/Profit

Show daily/monthly/quarterly/yearly revenue we earned.

- Smallest time unit: day
- Filter by: start, end, category

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
Reveneue == Sum(price_micros of all order_items in date range)

Profit == Sum(% we earned * price_micros of all order_items in date range)

NOTE: the % we earned should vary (and intentionally not documented).
To reflect real price change, it should increase overtime,
with a small dip after the revenue increases
```
