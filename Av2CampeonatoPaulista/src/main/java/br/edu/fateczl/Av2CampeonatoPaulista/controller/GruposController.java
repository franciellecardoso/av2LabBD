package br.edu.fateczl.Av2CampeonatoPaulista.controller;

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

import br.edu.fateczl.Av2CampeonatoPaulista.model.Grupo;
import br.edu.fateczl.Av2CampeonatoPaulista.persistence.GrupoDao;

@Controller
public class GruposController {

	@Autowired
	GrupoDao grupoDao;

	@RequestMapping(name = "grupos", value = "/grupos", method = RequestMethod.GET)
	public ModelAndView init() {
		return new ModelAndView("grupos");
	}

	@RequestMapping(name = "grupos", value = "/grupos", method = RequestMethod.POST)
	public ModelAndView op(@RequestParam Map<String, String> allRequestParam, ModelMap model) {
		String saida = "";
		String erro = "";
		List<Grupo> grupos = new ArrayList<Grupo>();

		try {

			saida = grupoDao.geraGrupos();
			grupos = grupoDao.listarGrupos();

		} catch (Exception e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("saida", saida);
			model.addAttribute("erro", erro);
		}
		return new ModelAndView("grupos", model);
	}
}
