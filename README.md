# Enterprise Sales Data Warehouse Pipeline

## Overview
This repository contains the data engineering pipeline for our Enterprise Sales Data Warehouse. The architecture follows a robust Medallion pattern (Bronze, Silver, Gold), extracting raw data from internal CRM and ERP systems and transforming it into a business-ready Star Schema using **PostgreSQL**. 

The final Gold layer is optimized for seamless consumption by Microsoft Power BI for reporting, Google BigQuery for ad-hoc SQL analysis, and downstream Machine Learning models.

## Prerequisites
*   **PostgreSQL:** The core relational database engine for all data warehouse layers.
*   **SQL Client (pgAdmin):** For executing database commands and scripts.
*   **Git:** For version control and documentation of the data model.
*   Access to the source CRM and ERP file directories (CSV drop locations accessible by the Postgres server).
*   Access to the target Data Warehouse environment.

---

## Step-by-Step Execution Process

### Step 1: Data Ingestion (Source to Bronze)
The first phase involves extracting raw data directly from the source systems without applying any transformations.
1.  **Extract:** Source systems (CRM and ERP) export transactional and master data as CSV files into designated secure folders.
2.  **Load:** Execute PostgreSQL `COPY` commands (or `\copy` via psql) to run a full batch load (truncate and insert) directly into the **Bronze Layer** raw tables.
3.  **Validate:** The pipeline performs automated SQL-based schema validation and data completeness checks to ensure the raw load matches the expected source format.

```mermaid
graph LR
    subgraph Source Systems
        A[CRM System <br/> CSV File] -->|Extract| C(PostgreSQL COPY Command)
        B[ERP System <br/> CSV File] -->|Extract| C
    end

    subgraph Data Engineering
        C -->|Execute & Validate| D{SQL Completeness & <br/> Schema Check}
    end

    subgraph PostgreSQL Data Warehouse
        D -->|Full Load / Batch| E[(Bronze Layer <br/> Raw Tables)]
    end

    style A fill:#7AA116,stroke:#232F3E,color:#fff
    style B fill:#7AA116,stroke:#232F3E,color:#fff
    style C fill:#1ba1e2,stroke:#006EAF,color:#fff
    style E fill:#a0522d,stroke:#6D1F00,color:#fff
```

### Step 2: Data Transformation (Bronze to Silver)
The Silver layer acts as the enterprise source of truth, standardizing data across disparate systems using SQL.
1.  **Cleanse:** Filter out malformed records and handle null values using SQL `WHERE` and `COALESCE` clauses.
2.  **Standardize & Normalize:** Align data types, standardize date formats, and resolve schema discrepancies between the CRM and ERP systems.
3.  **Enrich:** Generate derived columns necessary for downstream processing.
4.  **Load:** Insert the cleaned data into the **Silver Layer** tables 
```mermaid
graph LR
    subgraph Bronze Layer
        A[(crm_sales_details)] --> D(SQL Quality Checks)
        B[(crm_cust_info)] --> D
        C[(erp_cust_az12)] --> D
    end

    subgraph Data Engineering
        D --> E(Write SQL Transformations)
        E --> F(Insert into Silver)
    end

    subgraph Silver Layer
        F -->|Cleaned & Standardized| G[(Silver Tables)]
    end

    style A fill:#a0522d,stroke:#6D1F00,color:#fff
    style B fill:#a0522d,stroke:#6D1F00,color:#fff
    style C fill:#a0522d,stroke:#6D1F00,color:#fff
    style E fill:#1ba1e2,stroke:#006EAF,color:#fff
    style G fill:#647687,stroke:#314354,color:#fff
```

### Step 3: Business Modeling (Silver to Gold)
The Gold layer introduces business logic and structures the data for analytical consumption. 
1.  **Integrate:** Write SQL transformations to join the standardized Silver tables.
2.  **Apply Logic:** Calculate core business metrics (e.g., computing `sales_amount` as `quantity * price`).
3.  **Model:** Restructure the data into a Star Schema consisting of:
    *   `gold.fact_sales` (Transactional metrics)
    *   `gold.dim_customers` (Customer attributes)
    *   `gold.dim_products` (Product hierarchy)
4.  **Deploy:** Instantiate these models as PostgreSQL `VIEW`s within the Data Warehouse schema.

```mermaid
graph TD
    subgraph Silver Layer
        A[(Cleaned Silver Data)]
    end

    subgraph Modeling Pipeline
        A --> B(Build Business Model in SQL)
        B --> C(Define Fact & Dimensions)
        C --> D(Rename & Calculate Logic <br/> e.g., sales = qty * price)
    end

    subgraph Gold Layer - Star Schema
        D --> E[(gold.dim_customers)]
        D --> F[(gold.fact_sales)]
        D --> G[(gold.dim_products)]
    end

    subgraph Consumers
        E -.-> H[[Power BI / BI & Reporting]]
        F -.-> H
        G -.-> H
        F -.-> I[[BigQuery / Ad-Hoc SQL]]
        F -.-> J[[Machine Learning Models]]
    end

    style A fill:#647687,stroke:#314354,color:#fff
    style D fill:#1ba1e2,stroke:#006EAF,color:#fff
    style E fill:#f0a30a,stroke:#BD7000,color:#000
    style F fill:#e3c800,stroke:#B09500,color:#000
    style G fill:#f0a30a,stroke:#BD7000,color:#000
```

### Step 4: Data Consumption
Once the Gold views are materialized, the data is ready for the business:
*   **BI and Reporting:** Connect Microsoft Power BI directly to the PostgreSQL Gold views to refresh automated dashboards.
*   **Ad-Hoc Querying:** Analysts can query the Star Schema using standard SQL via any PostgreSQL client.
*   **Advanced Analytics:** Data scientists can pull clean, historical feature sets for machine learning models.

---

