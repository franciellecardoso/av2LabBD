package br.edu.fateczl.Av2CampeonatoPaulista.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.edu.fateczl.Av2CampeonatoPaulista.model.Grupo;
import br.edu.fateczl.Av2CampeonatoPaulista.model.Times;

@Repository
public class GrupoDao implements IGrupoDao {

	@Autowired
	GenericDao gDao;

	@Override
	public String geraGrupos() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();

		String sql = "{CALL sp_gerador_grupos}";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();

		String saida = "Grupos gerados com sucesso!";

		cs.close();
		c.close();
		return saida;
	}

	@Override
	public List<Grupo> listarGrupos() throws SQLException, ClassNotFoundException {
		List<Grupo> grupos = new ArrayList<Grupo>();

		Connection c = gDao.getConnection();
		String sql = "SELECT g.nome, t.nome AS time\r\n" + "FROM grupos g, times t, grupos_times gt\r\n"
				+ "WHERE gt.codigoTime = t.codigo\r\n" + "      AND gt.codigoGrupo = g.codigo \r\n"
				+ "ORDER BY nome, codigoTime ";

		PreparedStatement ps = c.prepareStatement(sql.toString());

		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Times t = new Times();
			t.setNome(rs.getString("nome"));

			Grupo g = new Grupo();
			g.setGrupo(rs.getString("nome"));
			g.setTime(t);
			grupos.add(g);
		}
		rs.close();
		ps.close();
		c.close();
		return grupos;
	}

	@Override
	public List<Grupo> listarGrupo(String letra) throws SQLException, ClassNotFoundException {
		List<Grupo> grupos = new ArrayList<Grupo>();

		Connection c = gDao.getConnection();
		String sql = "SELECT g.nome, t.nome AS time\r\n" + "FROM grupos g, times t, grupos_times gt\r\n"
				+ "WHERE gt.codigoTime = t.codigo\r\n" + "      AND gt.codigoGrupo = g.codigo\r\n"
				+ "ORDER BY nome, codigoTime ";

		PreparedStatement ps = c.prepareStatement(sql.toString());
		ps.setString(1, letra);

		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Times t = new Times();
			t.setNome(rs.getString("nome"));

			Grupo g = new Grupo();
			g.setGrupo(rs.getString("nome"));
			g.setTime(t);
			grupos.add(g);
		}
		rs.close();
		ps.close();
		c.close();
		return grupos;
	}
}
