# 🛠️ Alt Mobility - Data Analyst Assignment

## 📋 Project Overview

This project is part of the Data Analyst Intern assignment for **Alt Mobility**, a leading EV leasing and fleet management company. The objective is to analyze customer orders and payments data to uncover insights that can drive better decision-making around sales, operations, and customer retention.

---

## 🗂️ Datasets Used

- **customer_orders.csv**: Contains details about each order, including customer ID, order date, amount, and status.
- **payments.csv**: Contains payment records linked to orders, including method, amount, date, and status.

---

## ✅ Task-Wise Approach

### **1. Order and Sales Analysis**
- Analyzed order fulfillment status (Delivered, Pending, Cancelled).
- Identified revenue trends by month and average order values.
- Extracted top orders and most profitable customers.

### **2. Customer Analysis**
- Segmented customers into spending brackets (Low, Medium, High).
- Identified repeat vs. first-time buyers and measured customer lifetime value.
- Analyzed customer ordering frequency and average time between orders.

### **3. Payment Status Analysis**
- Evaluated distribution of payment statuses (Completed, Failed, Pending).
- Assessed payment delays and high-risk payment methods.
- Estimated lost/unpaid revenue and visualized payment failures over time.

### **4. Order Details Report**
- Built a comprehensive report by joining order and payment data.
- Highlighted mismatches like unpaid or underpaid orders and delayed payments.

### **5. Customer Retention Analysis (Visualization)**
- Used cohort-based retention analysis to track customer repeat behavior month-over-month.
- Visualized key retention metrics using Power BI:
  - Cohort heatmap
  - Retention line trends
  - Year-wise contribution to overall retention

---

## 🛠️ How to Run the Queries

1. Set up a local MySQL environment or use any SQL editor that supports standard SQL (MySQL/PostgreSQL).
2. Create the database and tables using the provided schema:
   ```sql
   CREATE DATABASE alt_mobility;
   USE alt_mobility;
