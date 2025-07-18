<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Devolucion" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
     <meta charset="UTF-8">
    <title>Lista de Devoluciones</title>
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

            /* Menú lateral */
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

            /* Contenido principal */
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
                justify-content: space-between; /* Mantiene el espacio entre los elementos hijos */
                align-items: flex-start; /* Alinea los elementos verticalmente al inicio */
                margin-top: 10px; /* Un poco de espacio entre el título y los botones */
            }

            .left-controls {
                /* Contenedor para el botón de búsqueda, se alinea a la izquierda */
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

            .right-controls {
                /* Contenedor para el botón de nueva importación, se alinea a la derecha */
            }

            .new-importacion-button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
            }

            /* Estilos para la tabla */
            .importacion-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                border-radius: 5px;
                overflow: hidden; /* Para que el borde redondeado funcione con la tabla */
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
                align-items: center; /* Para alinear verticalmente los iconos */
            }

            .importacion-table .action-icon {
                cursor: pointer;
                font-size: 16px;
                /* Aquí podrías usar iconos de fuentes como Font Awesome */
            }
            .btn_crear {
                display: inline-block;
                background-color: #007bff; /* Azul */
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 25px; /* Esquinas ovaladas */
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                transition: background-color 0.3s ease;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            }

            .btn_crear:hover {
                background-color: #0056b3; /* Azul más oscuro al pasar el mouse */
            }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
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
            <h2>Lista de Devoluciones</h2>
            
            <table class="importacion-table">
                <tr>
                    <th>ID</th>
                    <th>ID Importación</th>
                    <th>Fecha</th>
                    <th>Motivo</th>
                    <th>Responsable</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                <%
                    List<Devolucion> devoluciones = (List<Devolucion>) request.getAttribute("devoluciones");
                    if (devoluciones != null && !devoluciones.isEmpty()) {
                        for (Devolucion dev : devoluciones) {
                %>
                <tr>
                    <td><%= dev.getId_devolucion()%></td>
                    <td><%= dev.getId_importacion()%></td>
                    <td><%= dev.getFecha_devolucion()%></td>
                    <td><%= dev.getMotivo()%></td>
                    <td><%= dev.getResponsable()%></td>
                    <td><%= dev.getEstado()%></td>
                    <td>
                        <a href="EditarDevolucionServlet?id=<%= dev.getId_devolucion()%>"><img src="img/icono_editar.png" alt="Modificar" width="20" height="20"/></a>
                        
                        
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7">No hay devoluciones registradas.</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>