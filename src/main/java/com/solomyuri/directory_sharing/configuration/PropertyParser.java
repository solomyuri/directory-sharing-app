package com.solomyuri.directory_sharing.configuration;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;


public class PropertyParser {
    
    public void parseArguments(String[] args) throws ParseException {
	Options options = new Options();
	options.addOption("p", "port", true, "Port to run the server on (default: 8080)");
	options.addOption("d", "directory", true, "Directory to share (default: current directory)");

	CommandLineParser parser = new DefaultParser();
	CommandLine cmd= parser.parse(options, args, true);

	String port = cmd.getOptionValue("p", "8080");
	String directory = cmd.getOptionValue("d", System.getProperty("user.dir"));

	System.setProperty("server.port", port);
	System.setProperty("share.directory", directory);
    }

}
