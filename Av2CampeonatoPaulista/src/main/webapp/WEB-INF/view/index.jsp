<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<title>Campeonato Paulista</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
	</div>
	<div id="centro" align="center">
		<h1 class=texto>Campeonato Paulista</h1>
		<div align="center">
			<p>Este site � a sua fonte de todas as �ltimas not�cias e
				informa��es sobre o torneio de futebol Campeonato Paulista.</p>

			<p>Volte sempre para atualiza��es sobre resultados, classifica��o
				e muito mais.</p>
		</div>
	</div>
</body>
</html>