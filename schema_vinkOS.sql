-- =============================================
-- 1. DATABASE & CONFIGURATION
-- =============================================
CREATE TABLE IF NOT EXISTS config_proceso (
    clave VARCHAR(50) PRIMARY KEY,
    valor VARCHAR(255),
    descripcion TEXT
);

INSERT INTO config_proceso (clave, valor, descripcion) VALUES  
('email_notificacion', 'admin_datos@empresa.com', 'Recipient for error alerts'),
('sftp_host', '8.8.8.8', 'Source server IP'),
('ruta_backup', '/home/etl/visitas/bckp', 'Local path for ZIP backup');

-- =============================================
-- 2. OPERATIONAL AUDIT (REPORTING)
-- =============================================
CREATE TABLE IF NOT EXISTS control_cargas (
    id_carga SERIAL PRIMARY KEY,
    nombre_archivo VARCHAR(255) UNIQUE,
    registros_totales INT,
    registros_validos INT,
    registros_invalidos INT,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    estado VARCHAR(50) 
);

-- =============================================
-- 3. CORE DATA WAREHOUSE (GOLD & SILVER)
-- =============================================

-- Table: visitante (Aggregated metrics)
CREATE TABLE IF NOT EXISTS visitante (
    id_visitante SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE, 
    fecha_primera_visita TIMESTAMP,
    fecha_ultima_visita INT, -- YYYYMMDD format
    visitas_totales BIGINT DEFAULT 0,
    visitas_anio_actual BIGINT DEFAULT 0,
    visitas_mes_actual BIGINT DEFAULT 0,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: estadistica (Detailed visit facts)
CREATE TABLE IF NOT EXISTS estadistica (
    id_estadistica SERIAL PRIMARY KEY,
    email VARCHAR(100),
    campo_variable BOOLEAN, -- Handled as boolean via ETL metadata
    badmail VARCHAR(10),
    baja VARCHAR(10),
    fecha_envio VARCHAR(20), -- Synchronized name (snake_case)
    fecha_open TEXT,
    opens BIGINT DEFAULT 0,
    opens_virales BIGINT DEFAULT 0,
    fecha_click TEXT,
    clicks BIGINT DEFAULT 0,
    clicks_virales BIGINT DEFAULT 0,
    links TEXT,
    ips TEXT,
    navegadores TEXT,
    plataformas TEXT,
    origen_archivo VARCHAR(255),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 4. ERROR MANAGEMENT
-- =============================================
CREATE TABLE IF NOT EXISTS errores_validacion (
    id_error SERIAL PRIMARY KEY,
    email VARCHAR(100),
    fecha_envio VARCHAR(20),
    desc_error TEXT,    
    campo_error TEXT,   
    codigo_error TEXT,
    origen_archivo VARCHAR(255),
    fecha_error TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 5. ANALYTICAL VIEWS
-- =============================================
CREATE OR REPLACE VIEW v_reporte_mensual_etl AS
SELECT 
    TO_CHAR(fecha_inicio, 'YYYY-MM') AS mes,
    COUNT(id_carga) AS total_archivos,
    SUM(registros_totales) AS total_registros_leidos,
    SUM(registros_validos) AS total_exitosos,
    SUM(registros_invalidos) AS total_errores
FROM control_cargas
GROUP BY 1;