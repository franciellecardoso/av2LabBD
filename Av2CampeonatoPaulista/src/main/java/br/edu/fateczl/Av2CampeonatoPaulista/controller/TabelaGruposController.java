package br.edu.fateczl.Av2CampeonatoPaulista.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.edu.fateczl.Av2CampeonatoPaulista.model.Time;
import br.edu.fateczl.Av2CampeonatoPaulista.persistence.TimeDao;

@Controller
public class TabelaGruposController {

	@Autowired
	TimeDao tDao;

	@RequestMapping(name = "tabela_grupos", value = "/tabela_grupos", method = RequestMethod.GET)
	public ModelAndView init() {
		return new ModelAndView("tabela_grupos");
	}

	@RequestMapping(name = "tabela_grupos", value = "/tabela_grupos", method = RequestMethod.POST)
	public ModelAndView op(@RequestParam Map<String, String> allRequestParam, ModelMap model) {
		List<Time> listaTimes = new ArrayList<Time>();
		String grupo = "";
		String erro = "";
		System.out.println(allRequestParam);
		for (String key : allRequestParam.keySet()) {
			if (key.equals("button")) {
				grupo = allRequestParam.get(key);
			}
		}
		try {
			listaTimes = tDao.listaTabelaGrupos(grupo);
		} catch (ClassNotFoundException | SQLException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("listaTabelaGrupos", listaTimes);
			model.addAttribute("erro", erro);
		}
		return new ModelAndView("tabela_grupos");
	}
}
