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

import br.edu.fateczl.Av2CampeonatoPaulista.model.Jogo;
import br.edu.fateczl.Av2CampeonatoPaulista.persistence.JogoDao;

@Controller
public class ResultadosController {

	@Autowired
	JogoDao jDao;

	@RequestMapping(name = "resultados", value = "/resultados", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		List<Jogo> listaDatas = new ArrayList<Jogo>();
		String erro = "";

		try {
			listaDatas = jDao.listaDatas();
		} catch (ClassNotFoundException | SQLException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("listaDatas", listaDatas);
			model.addAttribute("erro", erro);
		}
		return new ModelAndView("resultados");
	}

	@RequestMapping(name = "resultados", value = "/resultados", method = RequestMethod.POST)
	public ModelAndView op(@RequestParam Map<String, String> allRequestParam, ModelMap model) {
		List<Jogo> listaJogos = new ArrayList<Jogo>();
		String erro = "";
		String timeA = "";
		String timeB = "";
		int golsTimeA = -1;
		int golsTimeB = -1;
		String data = "";

		boolean inserir = false;

		for (String key : allRequestParam.keySet()) {
			if (key.equals("buttonData")) {
				data = allRequestParam.get(key);
			}
			if (key.equals("buttonJogos")) {
				inserir = true;
			}
		}
		if (allRequestParam.containsKey("buttonJogos")) {
		}
		try {

			if (inserir == true) {
				jDao.atualizaJogosAleatorio();
				model.addAttribute("mensagem", "Times aleatórios inseridos com sucesso");
			}

			listaJogos = jDao.listaJogos(data);
		} catch (ClassNotFoundException | SQLException e) {
			erro = e.getMessage();
		} finally {
			init(model);
			model.addAttribute("listaJogos", listaJogos);
			model.addAttribute("erro", erro);
		}
		return new ModelAndView("resultados");

	}
}
