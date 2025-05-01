# 🛠️ Alt Mobility - Data Analyst Assignment

## 📋 Project Overview

This project was completed as part of the **Data Analyst Intern assignment** for Alt Mobility, a leading EV leasing and fleet management company. The objective was to analyze customer orders and payments data to uncover insights that support better decision-making across sales, operations, and customer retention.

---

## 🗂️ Datasets Used

| File | Description |
|------|-------------|
| `customer_order.csv` | Contains order-level details including customer ID, order date, amount, and status |
| `payments.csv`        | Contains payment transactions linked to orders with details on method, amount, date, and status |

---

## ✅ Task-Wise Approach

### 1. 📦 Order and Sales Analysis
- Analyzed order fulfillment status (Delivered, Pending, Shipped)
- Identified monthly revenue trends and average order values
- Highlighted top customers by total spend

### 2. 👥 Customer Analysis
- Segmented customers into:
  - One-Time Buyers
  - Returning Buyers
  - Loyal Buyers
- Measured customer lifetime value and order frequency

### 3. 💳 Payment Status Analysis
- Evaluated payment outcomes: Completed, Failed, and Pending
- Calculated payment completion rate (~73%)
- Estimated unpaid revenue (₹1.27M+) and high-risk payment methods

### 4. 📊 Order Details Report
- Joined orders and payments to provide a complete customer-level view
- Flagged unpaid or underpaid orders and delayed payments

### 5. 🔁 Customer Retention Analysis (Visualization)
- Conducted cohort-based retention analysis
- Visualized in Power BI:
  - Cohort heatmap
  - Retention trends by month
  - Retention breakdown by year
  - Summary KPIs (e.g., 288K total customers, 15K active)

---

## 🧠 Key Insights

Refer to [`Summary_of_Findings.pdf`] for:
- Data-backed insights on order fulfillment, payments, and customer behavior
- Retention drop-offs and key metrics by cohort
- Actionable business recommendations

---

## 🛠️ How to Run the Queries

You can use any SQL environment that supports standard SQL (e.g., MySQL, PostgreSQL):

1. Create the database:
   ```sql
   CREATE DATABASE alt_mobility;
   USE alt_mobility;
