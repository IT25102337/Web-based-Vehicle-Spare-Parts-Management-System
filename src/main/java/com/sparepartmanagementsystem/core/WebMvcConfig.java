package com.sparepartmanagementsystem.core;
import com.sparepartmanagementsystem.core.*;
import com.sparepartmanagementsystem.inventory.*;
import com.sparepartmanagementsystem.procurement.*;
import com.sparepartmanagementsystem.admin.*;
import com.sparepartmanagementsystem.customer.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * =========================================================================
 * TEAM MEMBER 3: WEB MVC CONFIGURATION FOR ROLE PRIVACY
 * =========================================================================
 * Registers the UserSecurityInterceptor to enforce privacy across the
 * Customer, Inventory Admin, and Spare Part Manager portals.
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private UserSecurityInterceptor userSecurityInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(userSecurityInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/",
                        "/login",
                        "/logout",
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/webjars/**",
                        "/favicon.ico",
                        "/error"
                );
    }

    @Override
    public void addResourceHandlers(org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/", "/images/");
    }
}


