package com.management.env.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.data.history.RevisionMetadata;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class EnvironmentRevision {
    private String envName;
    private String envData;
    private String description;
    private LocalDateTime updatedAt;
    private RevisionMetadata.RevisionType revisionType;
}
