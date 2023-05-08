package br.edu.fateczl.Av2CampeonatoPaulista.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.fateczl.Av2CampeonatoPaulista.model.Grupo;

public interface IGrupoDao {
	public String geraGrupos() throws SQLException, ClassNotFoundException;

	public List<Grupo> listarGrupos() throws SQLException, ClassNotFoundException;

	public List<Grupo> listarGrupo(String letra) throws SQLException, ClassNotFoundException;
}
