package com.sparepartmanagementsystem;
import com.sparepartmanagementsystem.core.*;
import com.sparepartmanagementsystem.inventory.*;
import com.sparepartmanagementsystem.procurement.*;
import com.sparepartmanagementsystem.admin.*;
import com.sparepartmanagementsystem.customer.*;


import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

public class ServletInitializer extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(SparePartSystemApplication.class);
	}

}


