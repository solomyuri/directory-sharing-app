package com.solomyuri.directory_sharing.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class SharingServiceImpl implements SharingService {

    private final String workingDirectory; 
    
    public SharingServiceImpl(@Value("${share.directory}") String directory) {
	this.workingDirectory = directory;
    }
    
    @Override
    public List<String> getFiles() {
	File dir = new File(workingDirectory);

	if (!dir.exists() || !dir.isDirectory())
	    return List.of();
	else
	    return Arrays.stream(dir.listFiles())
	            .filter(File::isFile)
	            .map(File::getName)
	            .toList();
    }

    @Override
    public Resource download(String filename) {
	File file = new File(workingDirectory + File.separator + filename);

	if (file.exists() && file.isFile())
	    return new FileSystemResource(file);
	else
	    return null;
    }

    @Override
    public void upload(MultipartFile file) {
	if (!file.isEmpty()) {
	    try {
		Path path = Paths.get(workingDirectory + File.separator + file.getOriginalFilename());
		Files.write(path, file.getBytes());
	    } catch (IOException ex) {
		System.err.println(ex.getMessage());
	    }
	}
    }

}
