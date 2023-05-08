<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<title>Times</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
		<br />
	</div>
	<form action="times" method="post">
		<div id="centro" align="center">
			<h1 class=texto>Campeonato Paulista</h1>
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th scope="col"></th>
						<th scope="col">Time</th>
						<th scope="col">Cidade</th>
						<th scope="col">Est�dio</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row">1</th>
						<td>Corinthians</td>
						<td>S�o Paulo</td>
						<td>Neo Qu�mica Arena</td>
					</tr>
					<tr>
						<th scope="row">2</th>
						<td>Palmeiras</td>
						<td>S�o Paulo</td>
						<td>Allianz Parque</td>
					</tr>
					<tr>
						<th scope="row">3</th>
						<td>Santos</td>
						<td>Santos</td>
						<td>Vila Belmiro</td>
					</tr>
					<tr>
						<th scope="row">4</th>
						<td>S�o Paulo</td>
						<td>S�o Paulo</td>
						<td>Morumbi</td>
					</tr>
					<tr>
						<th scope="row">5</th>
						<td>Ponte Preta</td>
						<td>Campinas</td>
						<td>Mois�s Lucarelli</td>
					</tr>
					<tr>
						<th scope="row">6</th>
						<td>Guarani</td>
						<td>Campinas</td>
						<td>Brinco de Ouro</td>
					</tr>
					<tr>
						<th scope="row">7</th>
						<td>S�o Bento</td>
						<td>Sorocaba</td>
						<td>Walter Ribeiro</td>
					</tr>
					<tr>
						<th scope="row">8</th>
						<td>Novorizontino</td>
						<td>Novo Horizonte</td>
						<td>Jorge Ismael de Biasi</td>
					</tr>
					<tr>
						<th scope="row">9</th>
						<td>Ponte Preta</td>
						<td>Campinas</td>
						<td>Mois�s Lucarelli</td>
					</tr>
					<tr>
						<th scope="row">10</th>
						<td>Mirassol</td>
						<td>Mirassol</td>
						<td>Jos� Maria de Campos Maia</td>
					</tr>
					<tr>
						<th scope="row">11</th>
						<td>Ferrovi�ria</td>
						<td>Araraquara</td>
						<td>Fonte Luminosa</td>
					</tr>
					<tr>
						<th scope="row">12</th>
						<td>Red Bull Bragantino</td>
						<td>Bragan�a Paulista</td>
						<td>Nabi Abi Chedid</td>
					</tr>
					<tr>
						<th scope="row">13</th>
						<td>S�o Caetano</td>
						<td>S�o Caetano do Sul</td>
						<td>Anacletto Campanella</td>
					</tr>
					<tr>
						<th scope="row">14</th>
						<td>Botafogo-SP</td>
						<td>Ribeir�o Preto</td>
						<td>Santa Cruz</td>
					</tr>
					<tr>
						<th scope="row">15</th>
						<td>Ituano</td>
						<td>Itu</td>
						<td>Novelli J�nior</td>
					</tr>
					<tr>
						<th scope="row">16</th>
						<td>Inter de Limeira</td>
						<td>Limeira</td>
						<td>Limeir�o</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</body>
</html>