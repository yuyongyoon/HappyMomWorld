package com.reserve.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;

@Configuration
public class TilesConfig {
	@Bean
	public TilesConfigurer tilesConfigurer() {
		TilesConfigurer tilesConfigurer = new TilesConfigurer();
		tilesConfigurer.setDefinitions(new String[] {"/WEB-INF/tiles/config.xml"});
		tilesConfigurer.setCheckRefresh(true);
		return tilesConfigurer;
	}

	@Bean
	public TilesViewResolver tilesViewResolver() {
		TilesViewResolver viewResolver = new TilesViewResolver();
		viewResolver.setViewClass(TilesView.class);
		viewResolver.setOrder(1);
		return viewResolver;
	}
}