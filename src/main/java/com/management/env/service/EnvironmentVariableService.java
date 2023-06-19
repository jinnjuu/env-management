package com.management.env.service;

import com.management.env.domain.EnvironmentRevision;
import com.management.env.domain.EnvironmentForm;
import com.management.env.domain.EnvironmentVariable;
import com.management.env.repository.EnvironmentVariableRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.history.Revisions;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class EnvironmentVariableService {

    private final EnvironmentVariableRepository environmentVariableRepository;

    @Autowired
    public EnvironmentVariableService(EnvironmentVariableRepository environmentVariableRepository) {
        this.environmentVariableRepository = environmentVariableRepository;
    }

    public EnvironmentVariable findEnvironmentVariable(Long id) {
        return environmentVariableRepository.findById(id).orElse(null);
    }

    public List<EnvironmentVariable> findEnvironmentVariables() {
        return environmentVariableRepository.findAllByOrderByIdDesc();
    }

    public boolean checkDuplicateEnvironmentVariableName(String name) {
        return environmentVariableRepository.findByName(name) != null;
    }

    public void createEnvironmentVariable(EnvironmentForm form) {
        EnvironmentVariable environmentVariable = new EnvironmentVariable();
        environmentVariable.setName(form.getName());
        environmentVariable.setData(form.getData());
        environmentVariable.setDescription(form.getDescription());
        environmentVariableRepository.save(environmentVariable);
    }

    public void updateEnvironmentVariable(Long id, EnvironmentForm form) {
        Optional<EnvironmentVariable> environmentVariable = environmentVariableRepository.findById(id);
        if (environmentVariable.isPresent()) {
            environmentVariable.get().setName(form.getName());
            environmentVariable.get().setData(form.getData());
            environmentVariable.get().setDescription(form.getDescription());
            environmentVariableRepository.save(environmentVariable.get());
        }
    }

    public void deleteEnvironmentVariable(Long id) {
        environmentVariableRepository.deleteById(id);
    }

    public List<EnvironmentRevision> getEnvironmentVariableHistory(Long id) {
        Revisions<Integer, EnvironmentVariable> revisions = environmentVariableRepository.findRevisions(id);
        List<EnvironmentRevision> envRevisions = new ArrayList<>();

        revisions.getContent().forEach(rev ->
                envRevisions.add(
                        new EnvironmentRevision(
                                rev.getEntity().getName(),
                                rev.getEntity().getData(),
                                rev.getEntity().getDescription(),
                                rev.getEntity().getUpdatedAt(),
                                rev.getMetadata().getRevisionType()
                        )
                )
        );
        Collections.reverse(envRevisions);
        return envRevisions;
    }

}
