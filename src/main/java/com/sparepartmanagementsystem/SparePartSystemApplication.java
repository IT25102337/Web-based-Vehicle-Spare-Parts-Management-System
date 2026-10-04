package com.sparepartmanagementsystem;
import com.sparepartmanagementsystem.core.*;
import com.sparepartmanagementsystem.inventory.*;
import com.sparepartmanagementsystem.procurement.*;
import com.sparepartmanagementsystem.admin.*;
import com.sparepartmanagementsystem.customer.*;


import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.jdbc.core.JdbcTemplate;

@SpringBootApplication
public class SparePartSystemApplication {

	public static void main(String[] args) {
		SpringApplication.run(SparePartSystemApplication.class, args);
	}

	@Bean
	CommandLineRunner initDatabase(JdbcTemplate jdbcTemplate) {
		return args -> {
			// User Accounts Table: users
			try {
				String createUserTableSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users') " +
						"BEGIN " +
						"CREATE TABLE users (" +
						"user_id INT IDENTITY(1,1) PRIMARY KEY, " +
						"username VARCHAR(100) UNIQUE, " +
						"password VARCHAR(255), " +
						"full_name VARCHAR(150), " +
						"email VARCHAR(150), " +
						"role VARCHAR(50), " +
						"created_at VARCHAR(50)" +
						"); " +
						"INSERT INTO users (username, password, full_name, email, role, created_at) VALUES ('customer', 'user123', 'Sample Customer', 'customer@parttrack.com', 'CUSTOMER', CONVERT(VARCHAR, GETDATE(), 120));" +
						"INSERT INTO users (username, password, full_name, email, role, created_at) VALUES ('inventory', 'admin123', 'Inventory Manager', 'inventory@parttrack.com', 'INVENTORY', CONVERT(VARCHAR, GETDATE(), 120));" +
						"INSERT INTO users (username, password, full_name, email, role, created_at) VALUES ('admin', 'admin123', 'System Administrator', 'admin@parttrack.com', 'ADMIN', CONVERT(VARCHAR, GETDATE(), 120));" +
						"INSERT INTO users (username, password, full_name, email, role, created_at) VALUES ('spareparts', 'spare123', 'Spare Part Manager', 'spareparts@parttrack.com', 'SPAREPARTS', CONVERT(VARCHAR, GETDATE(), 120));" +
						"END";
				jdbcTemplate.execute(createUserTableSql);
			} catch (Exception ex) {
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS users (" +
							"user_id INT AUTO_INCREMENT PRIMARY KEY, " +
							"username VARCHAR(100) UNIQUE, " +
							"password VARCHAR(255), " +
							"full_name VARCHAR(150), " +
							"email VARCHAR(150), " +
							"role VARCHAR(50), " +
							"created_at VARCHAR(50));");
					try {
						jdbcTemplate.execute("INSERT INTO users (username, password, full_name, email, role, created_at) VALUES ('customer', 'user123', 'Sample Customer', 'customer@parttrack.com', 'CUSTOMER', '2026-09-30')");
					} catch (Exception ignored) {}
				} catch (Exception ignored) {}
			}

			String createTableSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'inventory') " +
					"BEGIN " +
					"CREATE TABLE inventory (" +
					"part_id VARCHAR(50) PRIMARY KEY, " +
					"part_name VARCHAR(100), " +
					"quantity INT, " +
					"reorder_level INT, " +
					"unit_price DECIMAL(10, 2), " +
					"storage_location VARCHAR(100)" +
					"); " +
					"END";

			try {
				jdbcTemplate.execute(createTableSql);
			} catch (Exception e) {
				// Generic fallback for H2
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS inventory (" +
							"part_id VARCHAR(50) PRIMARY KEY, " +
							"part_name VARCHAR(100), " +
							"quantity INT, " +
							"reorder_level INT, " +
							"unit_price DECIMAL(10, 2), " +
							"storage_location VARCHAR(100)" +
							");");
				} catch (Exception ignored) {}
			}

			// Add storage_location column to existing tables if missing
			try {
				jdbcTemplate.execute("ALTER TABLE inventory ADD storage_location VARCHAR(100) DEFAULT 'Rack A-01'");
			} catch (Exception ignored) {}

			// Friend's Module Table: supplier_products
			try {
				String createSupplierTableSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'supplier_products') " +
						"BEGIN " +
						"CREATE TABLE supplier_products (" +
						"batch_id INT IDENTITY(1,1) PRIMARY KEY, " +
						"part_id VARCHAR(50), " +
						"part_name VARCHAR(100), " +
						"supplier_name VARCHAR(100), " +
						"received_qty INT, " +
						"available_qty INT, " +
						"supplier_price DECIMAL(10, 2), " +
						"quality_status VARCHAR(20), " +
						"quality_notes VARCHAR(255), " +
						"arrival_date VARCHAR(50)" +
						"); " +
						"END";
				jdbcTemplate.execute(createSupplierTableSql);
			} catch (Exception ex) {
				// Generic fallback for H2
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS supplier_products (" +
							"batch_id INT AUTO_INCREMENT PRIMARY KEY, " +
							"part_id VARCHAR(50), " +
							"part_name VARCHAR(100), " +
							"supplier_name VARCHAR(100), " +
							"received_qty INT, " +
							"available_qty INT, " +
							"supplier_price DECIMAL(10, 2), " +
							"quality_status VARCHAR(20), " +
							"quality_notes VARCHAR(255), " +
							"arrival_date VARCHAR(50)" +
							");");
				} catch (Exception ignored) {}
			}

			// Inter-Departmental Reorder Requests Table: restock_requests
			try {
				String createRequestTableSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'restock_requests') " +
						"BEGIN " +
						"CREATE TABLE restock_requests (" +
						"request_id INT IDENTITY(1,1) PRIMARY KEY, " +
						"part_id VARCHAR(50), " +
						"part_name VARCHAR(100), " +
						"current_quantity INT, " +
						"requested_quantity INT, " +
						"request_message VARCHAR(255), " +
						"request_date VARCHAR(50), " +
						"status VARCHAR(50)" +
						"); " +
						"END " +
						"ELSE BEGIN " +
						"ALTER TABLE restock_requests ALTER COLUMN status VARCHAR(50); " +
						"END";
				jdbcTemplate.execute(createRequestTableSql);
			} catch (Exception ex) {
				// Generic fallback for H2
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS restock_requests (" +
							"request_id INT AUTO_INCREMENT PRIMARY KEY, " +
							"part_id VARCHAR(50), " +
							"part_name VARCHAR(100), " +
							"current_quantity INT, " +
							"requested_quantity INT, " +
							"request_message VARCHAR(255), " +
							"request_date VARCHAR(50), " +
							"status VARCHAR(50)" +
							");");
				} catch (Exception ignored) {}
			}

			// Admin Module: report_template
			try {
				String createTemplateSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'report_template') " +
						"BEGIN " +
						"CREATE TABLE report_template (" +
						"id INT IDENTITY(1,1) PRIMARY KEY, " +
						"template_name VARCHAR(100) UNIQUE, " +
						"template_filters VARCHAR(100), " +
						"created_at VARCHAR(50)" +
						"); " +
						"INSERT INTO report_template (template_name, template_filters, created_at) VALUES ('Sales Performance', 'Sales', CONVERT(VARCHAR, GETDATE(), 120));" +
						"INSERT INTO report_template (template_name, template_filters, created_at) VALUES ('Inventory Stock Audit', 'Inventory', CONVERT(VARCHAR, GETDATE(), 120));" +
						"INSERT INTO report_template (template_name, template_filters, created_at) VALUES ('Supplier Quality Overview', 'Suppliers', CONVERT(VARCHAR, GETDATE(), 120));" +
						"END";
				jdbcTemplate.execute(createTemplateSql);
			} catch (Exception ex) {
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS report_template (" +
							"id INT AUTO_INCREMENT PRIMARY KEY, " +
							"template_name VARCHAR(100) UNIQUE, " +
							"template_filters VARCHAR(100), " +
							"created_at VARCHAR(50));");
					try {
						jdbcTemplate.execute("INSERT INTO report_template (template_name, template_filters, created_at) VALUES ('Sales Performance', 'Sales', '2026-09-30')");
						jdbcTemplate.execute("INSERT INTO report_template (template_name, template_filters, created_at) VALUES ('Inventory Stock Audit', 'Inventory', '2026-09-30')");
					} catch (Exception ignored) {}
				} catch (Exception ignored) {}
			}

			// Admin Module: report_schedule
			try {
				String createScheduleSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'report_schedule') " +
						"BEGIN " +
						"CREATE TABLE report_schedule (" +
						"id INT IDENTITY(1,1) PRIMARY KEY, " +
						"template_id INT, " +
						"frequency VARCHAR(50), " +
						"delivery_email VARCHAR(100)" +
						"); " +
						"INSERT INTO report_schedule (template_id, frequency, delivery_email) VALUES (2, 'Weekly', 'admin@parttrack.com');" +
						"END";
				jdbcTemplate.execute(createScheduleSql);
			} catch (Exception ex) {
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS report_schedule (" +
							"id INT AUTO_INCREMENT PRIMARY KEY, " +
							"template_id INT, " +
							"frequency VARCHAR(50), " +
							"delivery_email VARCHAR(100));");
				} catch (Exception ignored) {}
			}

			// Admin Module: inventory_reports (submitted by Inventory Manager for Admin Analysis)
			try {
				String createReportsSql = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'inventory_reports') " +
						"BEGIN " +
						"CREATE TABLE inventory_reports (" +
						"report_id INT IDENTITY(1,1) PRIMARY KEY, " +
						"report_title VARCHAR(150), " +
						"report_type VARCHAR(100), " +
						"from_date VARCHAR(50), " +
						"to_date VARCHAR(50), " +
						"generated_by VARCHAR(100), " +
						"generated_date VARCHAR(50), " +
						"report_content NVARCHAR(MAX), " +
						"status VARCHAR(50), " +
						"notes VARCHAR(255)" +
						"); " +
						"END";
				jdbcTemplate.execute(createReportsSql);
			} catch (Exception ex) {
				try {
					jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS inventory_reports (" +
							"report_id INT AUTO_INCREMENT PRIMARY KEY, " +
							"report_title VARCHAR(150), " +
							"report_type VARCHAR(100), " +
							"from_date VARCHAR(50), " +
							"to_date VARCHAR(50), " +
							"generated_by VARCHAR(100), " +
							"generated_date VARCHAR(50), " +
							"report_content TEXT, " +
							"status VARCHAR(50), " +
							"notes VARCHAR(255));");
				} catch (Exception ignored) {}
			}
		};
	}
}

