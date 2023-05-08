package br.edu.fateczl.Av2CampeonatoPaulista.model;

public class Times {
	private int codigo;
	private String nome;
	private String cidade;
	private String estadio;
	private String materialEsportivo;

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getCidade() {
		return cidade;
	}

	public void setCidade(String cidade) {
		this.cidade = cidade;
	}

	public String getEstadio() {
		return estadio;
	}

	public void setEstadio(String estadio) {
		this.estadio = estadio;
	}

	public String getMaterialEsportivo() {
		return materialEsportivo;
	}

	public void setMaterialEsportivo(String materialEsportivo) {
		this.materialEsportivo = materialEsportivo;
	}

	@Override
	public String toString() {
		return "Times [codigo=" + codigo + ", nome=" + nome + ", cidade=" + cidade + ", estadio=" + estadio
				+ ", materialEsportivo=" + materialEsportivo + "]";
	}

}
