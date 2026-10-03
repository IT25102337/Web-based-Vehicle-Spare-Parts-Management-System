package com.sparepartmanagementsystem;

import com.sparepartmanagementsystem.reportmanager.ReportManagerController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.ui.ConcurrentModel;

import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class SparePartSystemApplicationTests {

	@LocalServerPort
	private int port;

	@Autowired
	private TestRestTemplate restTemplate;

	@Autowired(required = false)
	private MockMvc mockMvc;


	@Autowired(required = false)
	private ReportManagerController reportManagerController;

	@Autowired(required = false)
	private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

	@Autowired(required = false)
	private com.sparepartmanagementsystem.admin.AdminService adminService;

	@Autowired(required = false)
	private com.sparepartmanagementsystem.customer.CustomerService customerService;

	@Test
	void contextLoads() throws Exception {
		if (reportManagerController != null) {
			reportManagerController.viewDashboard(new ConcurrentModel());
			reportManagerController.viewTemplates(new ConcurrentModel());
		}
		if (mockMvc != null) {
			mockMvc.perform(get("/reports/templates").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/reportmanager/templates").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/report/templates").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/reports/report-templates").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/report-templates").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().is3xxRedirection());
			mockMvc.perform(get("/templates").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().is3xxRedirection());
			mockMvc.perform(get("/reports/templates/generate/6?format=pdf").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/reports/templates/generate/7?format=pdf").sessionAttr("userRole", "REPORT_MANAGER"))
					.andExpect(result -> {
						int status = result.getResponse().getStatus();
						org.junit.jupiter.api.Assertions.assertTrue(status == 200 || status == 302);
					});
		}
	}

	@Test
	void testAdminAccessOperationalPortals() throws Exception {
		if (mockMvc != null) {
			// Admin accessing Sales Management
			mockMvc.perform(get("/sales").sessionAttr("userRole", "ADMIN").sessionAttr("username", "admin"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/sales").sessionAttr("userRole", "SYSADMIN").sessionAttr("username", "admin"))
					.andExpect(status().isOk());

			// Admin accessing Supplier Portal
			mockMvc.perform(get("/supplier").sessionAttr("userRole", "ADMIN").sessionAttr("username", "admin"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/supplier").sessionAttr("userRole", "SYSADMIN").sessionAttr("username", "admin"))
					.andExpect(status().isOk());

			// Admin accessing Customer Store
			mockMvc.perform(get("/customer").sessionAttr("userRole", "ADMIN").sessionAttr("username", "admin"))
					.andExpect(status().isOk());
			mockMvc.perform(get("/customer").sessionAttr("userRole", "SYSADMIN").sessionAttr("username", "admin"))
					.andExpect(status().isOk());
		}
	}

	@Test
	void testJspRenderingTemplates() {
		// Log in via RestTemplate
		org.springframework.util.LinkedMultiValueMap<String, String> form = new org.springframework.util.LinkedMultiValueMap<>();
		form.add("username", "reportmanager");
		form.add("password", "report123");
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		ResponseEntity<String> loginRes = restTemplate.postForEntity("http://localhost:" + port + "/login", new HttpEntity<>(form, headers), String.class);

		String cookie = loginRes.getHeaders().getFirst(HttpHeaders.SET_COOKIE);
		if (cookie != null) {
			HttpHeaders reqHeaders = new HttpHeaders();
			reqHeaders.add(HttpHeaders.COOKIE, cookie);
			reqHeaders.setAccept(java.util.Collections.singletonList(MediaType.TEXT_HTML));
			ResponseEntity<String> res = restTemplate.exchange("http://localhost:" + port + "/reports/templates", HttpMethod.GET, new HttpEntity<>(reqHeaders), String.class);
			org.junit.jupiter.api.Assertions.assertEquals(HttpStatus.OK, res.getStatusCode());
			org.junit.jupiter.api.Assertions.assertTrue(res.getBody() != null && res.getBody().contains("Template Engine"));
		}
	}

	@Test
	void testJspRenderingAudits() {
		// Log in via RestTemplate
		org.springframework.util.LinkedMultiValueMap<String, String> form = new org.springframework.util.LinkedMultiValueMap<>();
		form.add("username", "reportmanager");
		form.add("password", "report123");
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		ResponseEntity<String> loginRes = restTemplate.postForEntity("http://localhost:" + port + "/login", new HttpEntity<>(form, headers), String.class);

		String cookie = loginRes.getHeaders().getFirst(HttpHeaders.SET_COOKIE);
		if (cookie != null) {
			HttpHeaders reqHeaders = new HttpHeaders();
			reqHeaders.add(HttpHeaders.COOKIE, cookie);
			reqHeaders.setAccept(java.util.Collections.singletonList(MediaType.TEXT_HTML));
			ResponseEntity<String> res = restTemplate.exchange("http://localhost:" + port + "/reports/audits", HttpMethod.GET, new HttpEntity<>(reqHeaders), String.class);
			org.junit.jupiter.api.Assertions.assertEquals(HttpStatus.OK, res.getStatusCode());
			org.junit.jupiter.api.Assertions.assertTrue(res.getBody() != null && res.getBody().contains("btn-action-approve"));
			org.junit.jupiter.api.Assertions.assertTrue(res.getBody() != null && res.getBody().contains("btn-action-reject"));
		}
	}
}


