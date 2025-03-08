package com.solomyuri.directory_sharing.service;

import java.util.List;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface SharingService {

    List<String> getFiles();

    Resource download(String filename);
    
    void upload(MultipartFile filel);

}
