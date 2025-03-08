package com.solomyuri.directory_sharing;

import org.apache.commons.cli.ParseException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.solomyuri.directory_sharing.configuration.PropertyParser;

@SpringBootApplication
public class DirectorySharingApplication {

    public static void main(String[] args) {
	PropertyParser parser = new PropertyParser();
	
	try {
            parser.parseArguments(args);
        } catch (ParseException e) {
            System.err.println("Error parsing arguments: " + e.getMessage());
            return;
        }
	SpringApplication.run(DirectorySharingApplication.class, args);
    }

}
