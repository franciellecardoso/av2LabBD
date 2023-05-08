package br.edu.fateczl.Av2CampeonatoPaulista.model;

public class Grupo {
	private String grupo;
	private Times time;

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public Times getTime() {
		return time;
	}

	public void setTime(Times time) {
		this.time = time;
	}

	@Override
	public String toString() {
		return "Grupo [grupo=" + grupo + ", time=" + time + "]";
	}

}
