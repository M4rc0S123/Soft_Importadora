<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Importacion" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reporte de Importaciones</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                display: flex;
                background-color: #f4f4f4;
            }

            .sidebar {
                width: 220px;
                background-color: #003366;
                color: white;
                height: 100vh;
                display: flex;
                flex-direction: column;
                padding-top: 0;
            }

            .sidebar h2 {
                text-align: center;
                margin-bottom: 30px;
            }

            .sidebar a {
                padding: 12px 20px;
                text-decoration: none;
                color: white;
                display: block;
                transition: background 0.3s;
            }

            .sidebar a:hover {
                background-color: #0059b3;
            }

            .main-content {
                padding: 20px;
                flex-grow: 1;
            }

            .header-importacion {
                margin-bottom: 20px;
            }

            .controls {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-top: 10px;
            }

            .search-container {
                display: flex;
                align-items: center;
            }

            .search-input {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px 0 0 5px;
            }

            .search-button {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 0 5px 5px 0;
                cursor: pointer;
                margin-left: -5px;
            }

            .new-importacion-button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
            }

            .importacion-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                border-radius: 5px;
                overflow: hidden;
            }

            .importacion-table th, .importacion-table td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            .importacion-table th {
                background-color: #f2f2f2;
                font-weight: bold;
            }

            .importacion-table tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .importacion-table .actions {
                display: flex;
                gap: 10px;
                justify-content: center;
                align-items: center;
            }

            .importacion-table .action-icon {
                cursor: pointer;
                font-size: 16px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="sidebar">
            <h2>Menú</h2>
            <a href="DashboardServlet">Principal</a>
            <a href="rol">Roles</a>
            <a href="Empleado.jsp">Empleados</a>
            <a href="LisProvee.jsp">Proveedores</a>
            <a href="producto">Productos</a>
            <a href="buscarImportacion.jsp">Importaciones</a>
            <a href="AlmacenServlet">Almacenes</a>
            <a href="ListarDevolucionesServlet">Devoluciones</a>
        </div>
        <div class="main-content">
            <div class="container mt-5">
                <h2 class="mb-4 text-primary">Reporte de Importaciones por Fecha</h2>

                <!-- Formulario -->

                <form action="BuscarImporta" method="get" class="row g-3 mt-4">
                    <input type="hidden" name="opc" value="1"> <!-- Opcional si tu servlet lo usa -->
                    <div class="col-auto">
                        <label for="fecha" class="form-label">Seleccione una fecha:</label>
                        <input type="date" class="form-control" name="fecha" id="fecha" required>
                    </div>
                    <div class="col-auto align-self-end">
                        <button type="submit" class="btn btn-primary">Buscar Importaciones</button>
                    </div>
                </form>

                <div class="mt-3">
                    <a href="nuevaImportacion.jsp" class="btn btn-success">Nueva Importación</a>
                    <a href="LisProvee.jsp" class="btn btn-secondary ms-2">← Regresar</a>
                </div>


                <hr class="my-4">

                <!-- Resultados -->
                <%
                    List<Importacion> lista = (List<Importacion>) request.getAttribute("listaImportaciones");
                    if (lista != null) {
                        if (lista.isEmpty()) {
                %>
                <div class="alert alert-warning">No se encontraron importaciones para la fecha seleccionada.</div>
                <%
                } else {
                %>
                <table class="table table-bordered table-hover table-striped mt-4">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Código</th>
                            <th>Fecha Emisión</th>
                            <th>Estimada Arribo</th>
                            <th>Real Arribo</th>
                            <th>Estado</th>
                            <th>ID Proveedor</th>
                            <th>Responsable</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Importacion imp : lista) {
                        %>
                        <tr>
                            <td><%= imp.getId_importacion()%></td>
                            <td><%= imp.getCodigo_importacion()%></td>
                            <td><%= imp.getFecha_emision()%></td>
                            <td><%= imp.getFecha_estimada_arribo()%></td>
                            <td><%= imp.getFecha_real_arribo()%></td>
                            <td><%= imp.getEstado()%></td>
                            <td><%= imp.getId_proveedor()%></td>
                            <td><%= imp.getResponsable()%></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
