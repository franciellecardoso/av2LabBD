package br.edu.fateczl.Av2CampeonatoPaulista.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.fateczl.Av2CampeonatoPaulista.model.Jogo;

public interface IJogoDao {
	public List<Jogo> listaDatas() throws SQLException, ClassNotFoundException;

	public List<Jogo> listaJogos(String data) throws SQLException, ClassNotFoundException;

	public void atualizaJogos(Jogo jogo) throws SQLException, ClassNotFoundException;

	public void atualizaJogosAleatorio() throws SQLException, ClassNotFoundException;

	public List<Jogo> listaQuartas() throws SQLException, ClassNotFoundException;
}
