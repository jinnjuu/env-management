package com.management.env.repository;

import com.management.env.domain.EnvironmentVariable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.history.RevisionRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EnvironmentVariableRepository extends
        JpaRepository<EnvironmentVariable, Long>,
        RevisionRepository<EnvironmentVariable, Long, Integer> {

    List<EnvironmentVariable> findAllByOrderByIdDesc();

    EnvironmentVariable findByName(String name);
}
