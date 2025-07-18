<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.SeguimientoPlazo" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seguimiento de Importación</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }

        h1 {
            color: #003366;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        th {
            background-color: #003366;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        a {
            color: #007bff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .volver {
            margin-top: 20px;
            display: inline-block;
            background-color: #28a745;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
        }

        .volver:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<%
    List<SeguimientoPlazo> lista = (List<SeguimientoPlazo>) request.getAttribute("lista");
    Integer idImportacion = (Integer) request.getAttribute("idImportacion");

    if (lista == null || idImportacion == null) {
%>
    <p><strong>Error:</strong> No se pudo obtener los datos del seguimiento.</p>
<%
    } else {
%>

<h1>Seguimiento de Importación: <%= idImportacion %></h1>

<%
    if (lista.isEmpty()) {
%>
    <p>No hay registros de seguimiento para esta importación.</p>
<%
    } else {
%>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Tipo de Seguimiento</th>
        <th>Fecha Programada</th>
        <th>Fecha Real</th>
        <th>Responsable</th>
        <th>Observaciones</th>
        <th>Estado</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (SeguimientoPlazo s : lista) {
    %>
    <tr>
        <td><%= s.getIdSeguimiento() %></td>
        <td><%= s.getTipoNombre() %></td>
        <td><%= s.getFechaProgramada() %></td>
        <td><%= s.getFechaReal() != null ? s.getFechaReal() : "-" %></td>
        <td><%= s.getResponsable() %></td>
        <td><%= s.getObservaciones() %></td>
        <td><%= s.getEstado() != null ? s.getEstado() : "-" %></td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

<%
    }
%>

<a href="buscarImportacion.jsp" class="volver">← Volver a Importaciones</a>

<%
    }
%>

</body>
</html>
