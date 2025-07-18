<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Importacion, controller.ImportaControl" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Importación</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
                position: fixed;
                display: flex;
                flex-direction: column;
                padding-top: 20px;
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
                margin-left: 220px;
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
    <body>
        <div class="sidebar">
            <h2>Menú</h2>
            <a href="DashboardServlet">Principal</a>
            <a href="rol">Roles</a>
            <a href="empleado">Empleados</a>
            <a href="LisProvee.jsp">Proveedores</a>
            <a href="producto">Productos</a>
            <a href="buscarImportacion.jsp">Importaciones</a>
            <a href="AlmacenServlet">Almacenes</a>
            <a href="ListarDevolucionesServlet">Devoluciones</a>
        </div>
        <div class="main-content">
            <div class="header-importacion">
                <h1>IMPORTACION</h1>
                <div class="controls">
                    <form action="BuscarImporta" class="search-container">
                        <input type="hidden" value="2" name="opc"> 
                        <input name="id" type="text" class="search-input" placeholder="Ingrese código de Importación">
                        <input type="submit" class="search-button" value="Buscar">
                    </form>
                    <button onclick="window.location.href='nuevaImportacion.jsp'" class="new-importacion-button">Nueva Importación</button>
                </div>
            </div>
            
            <%
                // Primero intenta obtener la lista del request (resultado de búsqueda)
                List<Importacion> lista = (List<Importacion>) request.getAttribute("importacion");
                
                // Si no hay lista en el request (primera carga), obtener todas las importaciones
                if (lista == null) {
                    ImportaControl control = new ImportaControl();
                    lista = control.obtenerTodasLasImportaciones();
                }
                
                if (lista.isEmpty()) {
            %>
            <div class="alert alert-warning">No se encontraron importaciones.</div>
            <%
                } else {
            %>
            <table class="importacion-table">
                <thead>
                    <tr>
                        <th>Id importacion</th>
                        <th>Código de Importación</th>
                        <th>Fecha de Emisión</th>
                        <th>Fecha estimada arribo</th>
                        <th>Fecha real arribo</th>
                        <th>Estado</th>
                        <th>Proveedor</th>
                        <th>Responsable</th>
                        <th>Acciones</th>
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
                        <td><%= imp.getFecha_real_arribo()!= null ? imp.getFecha_real_arribo() : "" %></td>
                        <td><%= imp.getEstado()%></td>
                        <td><%= imp.getId_proveedor()%></td>
                        <td><%= imp.getResponsable()%></td>
                        <td class="actions">
                            <a href="DetalleImportaServlet?id_importacion=<%= imp.getId_importacion()%>" class="action-icon" title="Ver Detalle">🔍</a>
                            <span class="action-icon">🗑️</span>
                            <a href="registrarSeguimiento.jsp?idImportacion=<%= imp.getId_importacion()%>" title="Nuevo Seguimiento">📝</a>
                            <a href="SeguimientoServlet?accion=ver&idImportacion=<%= imp.getId_importacion()%>" class="action-icon" title="Ver Seguimiento">📋</a>
                            <a href="devolucion.jsp?idImportacion=<%= imp.getId_importacion()%>" class="action-icon" title="Ir a Devoluciones">↩️</a>
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                }
            %>
        </div>
    </body>
</html>
