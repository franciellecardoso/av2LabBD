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

import br.edu.fateczl.Av2CampeonatoPaulista.model.Jogo;

@Repository
public class JogoDao implements IJogoDao {

	@Autowired
	GenericDao gDao;

	@Override
	public List<Jogo> listaDatas() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		List<Jogo> lista = new ArrayList<Jogo>();
		String sql = "SELECT CONVERT(VARCHAR, dia, 103) AS dia FROM datas_jogos";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Jogo j = new Jogo();
			j.setData(rs.getString("dia"));

			lista.add(j);
		}
		rs.close();
		ps.close();
		c.close();

		return lista;
	}

	@Override
	public List<Jogo> listaJogos(String data) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		List<Jogo> lista = new ArrayList<Jogo>();
		String sql = "SELECT * FROM fn_jogos(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, data);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Jogo j = new Jogo();
			j.setTimeA(rs.getString("timeA"));
			j.setTimeB(rs.getString("timeB"));
			j.setGolsTimeA(rs.getInt("golsTimeA"));
			j.setGolsTimeB(rs.getInt("golsTimeB"));
			j.setData(data);

			lista.add(j);
		}
		rs.close();
		ps.close();
		c.close();

		return lista;
	}

	@Override
	public void atualizaJogos(Jogo jogo) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_marca_gols (?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setInt(1, jogo.getGolsTimeA());
		cs.setInt(1, jogo.getGolsTimeB());
		cs.setString(1, jogo.getTimeA());
		cs.setString(1, jogo.getTimeB());

		cs.close();
		c.close();

	}

	@Override
	public void atualizaJogosAleatorio() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_marcar_aleatorios}";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();

		cs.close();
		c.close();
	}

	@Override
	public List<Jogo> listaQuartas() throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		List<Jogo> lista = new ArrayList<Jogo>();
		String sql = "SELECT * FROM fn_quartas()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Jogo j = new Jogo();
			j.setTimeA(rs.getString("timeA"));
			j.setTimeB(rs.getString("timeB"));

			lista.add(j);
		}
		rs.close();
		ps.close();
		c.close();

		return lista;
	}
}
