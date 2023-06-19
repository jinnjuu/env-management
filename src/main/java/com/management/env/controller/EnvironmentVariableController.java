package com.management.env.controller;

import com.management.env.domain.EnvironmentForm;
import com.management.env.domain.EnvironmentVariable;
import com.management.env.service.EnvironmentVariableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("environment-variables")
public class EnvironmentVariableController {

    private final EnvironmentVariableService environmentVariableService;

    @Autowired
    public EnvironmentVariableController(EnvironmentVariableService environmentVariableService) {
        this.environmentVariableService = environmentVariableService;
    }

    @GetMapping()
    public String listEnvironmentVariables(Model model) {
        model.addAttribute("environmentVariables", environmentVariableService.findEnvironmentVariables());
        return "list";
    }

    @GetMapping("/create")
    public String addEnvironmentVariable() {
        return "create";
    }

    @PostMapping("/create")
    public String addEnvironmentVariable(@ModelAttribute EnvironmentForm form, Model model) {
        if(environmentVariableService.checkDuplicateEnvironmentVariableName(form.getName())) {
            model.addAttribute("type", "DuplicateName");
            return "common/alert";
        }
        environmentVariableService.createEnvironmentVariable(form);
        return "redirect:/environment-variables";
    }

    @GetMapping("{id}")
    public String getEnvironmentVariable(@PathVariable("id") Long id, Model model) {
        EnvironmentVariable environmentVariable = environmentVariableService.findEnvironmentVariable(id);
        if(environmentVariable == null) {
            model.addAttribute("type", "NotFound");
            return "common/alert";
        }
        model.addAttribute("environmentVariable", environmentVariable);
        return "detail";
    }

    @GetMapping("/{id}/history")
    public String getHistory(@PathVariable("id") Long id, Model model) {
        EnvironmentVariable environmentVariable = environmentVariableService.findEnvironmentVariable(id);
        if(environmentVariable == null) {
            model.addAttribute("type", "NotFound");
            return "common/alert";
        }
        model.addAttribute("revisions", environmentVariableService.getEnvironmentVariableHistory(id));
        return "history";
    }

    @GetMapping("{id}/update")
    public String updateEnvironmentVariable(@PathVariable("id") Long id, Model model) {
        EnvironmentVariable environmentVariable = environmentVariableService.findEnvironmentVariable(id);
        if(environmentVariable == null) {
            model.addAttribute("type", "NotFound");
            return "common/alert";
        }
        model.addAttribute("environmentVariable", environmentVariableService.findEnvironmentVariable(id));
        return "update";
    }

    @PostMapping("{id}/update")
    public String updateEnvironmentVariable(@PathVariable("id") Long id, @ModelAttribute EnvironmentForm form, Model model) {
        EnvironmentVariable environmentVariable = environmentVariableService.findEnvironmentVariable(id);
        if(environmentVariable == null) {
            model.addAttribute("type", "NotFound");
            return "common/alert";
        }
        environmentVariableService.updateEnvironmentVariable(id, form);
        return "redirect:/environment-variables/{id}";
    }

    @PostMapping("{id}/delete")
    public String deleteEnvironmentVariable(@PathVariable("id") Long id, Model model) {
        EnvironmentVariable environmentVariable = environmentVariableService.findEnvironmentVariable(id);
        if(environmentVariable == null) {
            model.addAttribute("type", "NotFound");
            return "common/alert";
        }
        environmentVariableService.deleteEnvironmentVariable(id);
        return "redirect:/environment-variables";
    }

}
