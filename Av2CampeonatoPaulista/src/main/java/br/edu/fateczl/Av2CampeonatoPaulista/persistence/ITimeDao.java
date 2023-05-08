package br.edu.fateczl.Av2CampeonatoPaulista.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.fateczl.Av2CampeonatoPaulista.model.Time;

public interface ITimeDao {
	public List<Time> listaTabelaGeral() throws SQLException, ClassNotFoundException;

	public List<Time> listaTabelaGrupos(String grupo) throws SQLException, ClassNotFoundException;
}
