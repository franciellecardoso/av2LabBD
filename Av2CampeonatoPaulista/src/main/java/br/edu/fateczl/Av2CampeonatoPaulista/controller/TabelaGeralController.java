package br.edu.fateczl.Av2CampeonatoPaulista.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import br.edu.fateczl.Av2CampeonatoPaulista.model.Time;
import br.edu.fateczl.Av2CampeonatoPaulista.persistence.TimeDao;

@Controller
public class TabelaGeralController {

	@Autowired
	TimeDao tDao;

	@RequestMapping(name = "tabela_geral", value = "/tabela_geral", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		List<Time> listaTimes = new ArrayList<Time>();
		String erro = "";

		try {
			listaTimes = tDao.listaTabelaGeral();
		} catch (ClassNotFoundException | SQLException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("listaTabelaGeral", listaTimes);
			model.addAttribute("erro", erro);
		}
		return new ModelAndView("tabela_geral");
	}
}
