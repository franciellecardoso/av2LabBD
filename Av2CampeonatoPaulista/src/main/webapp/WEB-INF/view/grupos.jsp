<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<title>Gerar Grupos</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
		<br />
	</div>
	<div id="centro" align="center">
		<h1 class=texto>Campeonato Paulista</h1>
		<h3 class=tarefa>Gerador de grupos</h3>
		<form action="grupos" method="post">
			<input type="submit" id=gerar_grupo name=gerar_grupo
				value="Gerar Grupos">
		</form>
	</div>
	<div align="center">
		<c:if test="${not empty erro}">
			<h4>
				<c:out value="${erro}"></c:out>
			</h4>
		</c:if>
	</div>
	<br />
	<div align="center">
		<c:if test="${not empty grupos }">
			<table class=table_home>
				<thead>
					<tr>
						<th>Grupos</th>
						<th>Nome</th>
						<th>Cidade</th>
						<th>Estadio</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${grupos}" var="g">
						<tr>
							<td align="center"><c:out value="${g.grupo }"></c:out></td>
							<td align="center"><c:out value="${g.time.nome }  "></c:out></td>
							<td align="center"><c:out value="${g.time.cidade }  "></c:out></td>
							<td align="center"><c:out value="${g.time.estadio }  "></c:out></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	<div align="center">
		<c:if test="${not empty saida}">
			<h4>
				<c:out value="${saida}"></c:out>
			</h4>
		</c:if>
	</div>
</body>
</html>