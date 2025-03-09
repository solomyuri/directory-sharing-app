package com.solomyuri.directory_sharing.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.solomyuri.directory_sharing.service.SharingService;

@Controller
public class SharingController {

    private final SharingService sharingService;

    public SharingController(SharingService sharingService) {
	this.sharingService = sharingService;
    }

    @GetMapping("/")
    public String listFiles(Model model) {
	model.addAttribute("files", sharingService.getFiles());
	return "index";
    }

    @GetMapping("/download/{filename}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String filename) {
	return ResponseEntity.ok()
	        .header(HttpHeaders.CONTENT_DISPOSITION, produceContentFilename(filename))
	        .body(sharingService.download(filename));
    }

    @PostMapping("/upload")
    public String uploadFile(@RequestParam MultipartFile file) throws IOException {
	sharingService.upload(file);
	return "redirect:/";
    }
    
    private String produceContentFilename(String filename) {
	return ContentDisposition.attachment()
	        .filename(filename, StandardCharsets.UTF_8)
	        .toString();
    }
}
