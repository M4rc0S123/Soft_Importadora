<%@page import="java.util.List"%>
<%@page import="model.Empleado"%>  <!-- Importar para acceder al rol -->
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Proveedor"%>
<%@page import="controller.ProveeControl"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Proveedores</title>
        <link href="css/adminlte.min.css" rel="stylesheet" type="text/css"/>
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

            .main-content-shifted {
                margin-left: 240px;
                padding: 20px;
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

            .card {
                background: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .container {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                padding: 20px;
                justify-content: space-evenly;
            }
            .card1 {
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                width: 300px;
                text-align: center;
            }

            .card h3 {
                margin-top: 0;
            }
            .status {
                font-weight: bold;
            }
            .alerta {
                color: #d9534f;
            }

            .estado-pendiente {
                color: #f0ad4e;
            }
            .estado-transito {
                color: #5bc0de;
            }
            .estado-recibido {
                color: #5cb85c;
            }

            footer {
                margin-top: 40px;
                text-align: center;
                font-size: 14px;
                color: #888;
            }
        </style>
    </head>
    <body>
       
            <div class="sidebar">
                <h2>Menú</h2>
                <a href="DashboardServlet1">Principal</a>
                <a href="LisProvee1.jsp">Proveedores</a>
                <a href="producto1">Productos</a>
                <a href="buscarImportacion.jsp">Importaciones</a>
                <a href="AlmacenServlet1">Almacenes</a>
             
            </div>
     

        <div class="main-content-shifted">
            <%
                ProveeControl obj = new ProveeControl();
                List<Proveedor> lista = obj.LisProvee();
            %>
            <h2 class="text-cyan">Lista de Proveedores</h2>

        

            <!-- Tabla de proveedores (visible para todos) -->
            <table class="table table-hover">
                <thead>
                    <tr class="text-white bg-black">
                        <th>Codigo</th>
                        <th>Nombre Empresa</th>
                        <th>Contacto</th>
                        <th>Correo</th>
                        <th>Telefono</th>
                        <th>Direccion</th>
                        <th>Pais Origen</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Proveedor x : lista) { %>
                        <tr>
                            <td><%= x.getId_proveedor() %></td>
                            <td><%= x.getNombre_empresa() %></td>
                            <td><%= x.getContacto() %></td>
                            <td><%= x.getCorreo() %></td>
                            <td><%= x.getTelefono() %></td>
                            <td><%= x.getDireccion() %></td>
                            <td><%= x.getPais_origen() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </body>
</html>