package com.reserve.app.config;

import java.time.format.DateTimeFormatter;
import java.util.TimeZone;

import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;

@Configuration
public class DateFormatConfig {

	private static final String dateFormat = "yyyy-MM-dd";
	private static final String datetimeFormat = "yyyy-MM-dd HH:mm:ss";

	@Bean
	public Jackson2ObjectMapperBuilderCustomizer jackson2ObjectMapperBuilderCustomizer() {
		return jacksonObjectMapperBuilder -> {
			jacksonObjectMapperBuilder.timeZone(TimeZone.getTimeZone("Asia/Seoul"));
			jacksonObjectMapperBuilder.simpleDateFormat(datetimeFormat);
			jacksonObjectMapperBuilder.serializers(new LocalDateSerializer(DateTimeFormatter.ofPattern(dateFormat)));
			jacksonObjectMapperBuilder.serializers(new LocalDateTimeSerializer(DateTimeFormatter.ofPattern(datetimeFormat)));
		};
	}
}