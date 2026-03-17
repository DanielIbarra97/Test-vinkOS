Web Visit ETL Pipeline (VinkOS Technical Assessment)
This project implements a robust ETL pipeline to ingest web visit logs into a PostgreSQL Data Warehouse using Pentaho Data Integration (PDI).

Technical Features
Idempotency Control: Managed via PROCESO_VISITAS.KJB to prevent duplicate file processing.

Data Quality Gates: Strict validation for email syntax and date patterns (dd/MM/yyyy HH:mm).

Error Handling: Automated redirection of invalid records to a dedicated errores_validacion table.

Schema Hardening: Database optimized with VARCHAR(100) for email fields to prevent overflows.

Project Structure
/ETL: Includes PROCESO_VISITAS.KJB (Job) and transformation_vinkOS.ktr (Transformation).

/Database: schema_vinkOS.sql containing table definitions and analytical views.

/Docs: vinkOS_doc.pdf with full execution evidence and metrics.

Execution Metrics
Total Records: 2,004.

Success Rate: 99.85% (2,001 records).
