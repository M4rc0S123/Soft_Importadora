<%@page import="controller.ProductoControl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.DetalleImporta, model.Producto, model.Proveedor" %>
<jsp:useBean id="productoControl" class="controller.ProductoControl" scope="page"/>
<jsp:useBean id="proveedorControl" class="controller.ProveeControl" scope="page"/>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Agregar Importación</title>
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

            /* Estilos del Formulario */
            .form-container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08); /* Sombra más pronunciada */
                max-width: 600px; /* Ancho máximo para el formulario */
                margin: 0 auto; /* Centrar el formulario */
            }

            .form-group {
                margin-bottom: 20px; /* Espacio entre grupos de formulario */
            }

            .form-group label {
                display: block; /* Etiqueta en su propia línea */
                margin-bottom: 8px;
                font-weight: 600; /* Texto de etiqueta más negrita */
                color: #34495e;
            }

            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group select {
                width: 100%; /* Ocupar todo el ancho disponible */
                padding: 12px;
                border: 1px solid #ced4da; /* Borde suave */
                border-radius: 6px; /* Bordes ligeramente redondeados */
                font-size: 1em;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .form-group input[type="text"]:focus,
            .form-group input[type="number"]:focus,
            .form-group select:focus {
                border-color: #3498db; /* Borde azul al enfocar */
                box-shadow: 0 0 0 0.2rem rgba(52,152,219,0.25); /* Sombra de enfoque */
                outline: none; /* Quitar el outline por defecto del navegador */
            }

            /* Estilo del botón de submit */
            input[type="submit"] {
                background-color: #28a745; /* Verde Bootstrap */
                color: white;
                padding: 12px 25px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 1.1em;
                font-weight: 600;
                transition: background-color 0.3s ease, transform 0.2s ease;
                margin-top: 15px; /* Espacio superior */
                width: 100%; /* Ocupar todo el ancho */
            }

            input[type="submit"]:hover {
                background-color: #218838; /* Verde más oscuro al pasar el mouse */
                transform: translateY(-2px); /* Pequeño efecto al pasar el mouse */
            }

            input[type="submit"]:active {
                transform: translateY(0); /* Vuelve a la posición original al hacer click */
            }

            /* Estilos para mensajes de error */
            .error-message {
                color: #dc3545; /* Rojo de error */
                background-color: #f8d7da; /* Fondo suave para el error */
                border: 1px solid #f5c6cb;
                border-radius: 5px;
                padding: 10px 15px;
                margin-top: 20px;
                text-align: center;
                font-weight: bold;
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
            <h2 class="page-header">Registrar Nueva Importación</h2>
            <div class="form-container">
                <form action="ImportaTempoServlet?opc=1">
                    <input type="hidden" name="opc" value="1">
                    <label>Producto:</label>
                    <select name="id_producto" required>
                        <%
                            ProductoControl com = new ProductoControl();
                            List<Producto> list = com.listarProducto();
                            for (Producto p : list) {
                        %>
                        <option value="<%= p.getId_producto()%>"><%= p.getNombre_producto()%></option>
                        <%
                            }
                        %>
                    </select><br>

                    <label>Cantidad:</label>
                    <input type="number" name="cantidad" required><br>

                    <label>Precio Unitario:</label>
                    <input type="number" step="0.01" name="precio_unitario" required><br>

                    <input type="submit" value="Añadir Detalle">
                </form>

                <!-- MOSTRAR DETALLES TEMPORALES -->
                <%
                    List<DetalleImporta> listaTemp = (List<DetalleImporta>) session.getAttribute("listaTemp");
                    if (listaTemp != null && !listaTemp.isEmpty()) {
                %>
                <h3>Detalles Agregados:</h3>
                <table border="1">
                    <tr>
                        <th>ID Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Unitario</th>
                        <th>Subtotal</th>
                    </tr>
                    <% for (DetalleImporta d : listaTemp) {%>
                    <tr>
                        <td><%= d.getId_producto()%></td>
                        <td><%= d.getCantidad()%></td>
                        <td><%= d.getPrecio_unitario()%></td>
                        <td><%= d.getSubtotal()%></td>
                    </tr>
                    <% } %>
                </table>
                <br> <form action="ImportaTempoServlet" method="post" style="display: inline-block;">
                    <input type="hidden" name="opc" value="3">
                    <input type="submit" value="Limpiar Detalles" style="background-color: #dc3545; color: white; padding: 10px 15px; border: none; border-radius: 6px; cursor: pointer; font-size: 1em;">
                </form>
                <%
                    }
                %>

                <!-- FORMULARIO FINAL PARA REGISTRAR TODO -->
                <h2>Procesar Importación</h2>
                <form action="ImportaTempoServlet?opc=2" method="post">
                    <label>Código Importación:</label>
                    <input type="text" name="codigo_importacion" required><br>

                    <label>Fecha Emisión:</label>
                    <input type="date" name="fecha_emision" required><br>

                    <label>Fecha Estimada Arribo:</label>
                    <input type="date" name="fecha_estimada_arribo" required><br>

                    <label>Estado:</label>
                    <input type="text" name="estado" value="Pendiente" readonly><br>

                    <label>Proveedor:</label>
                    <select name="id_proveedor">
                        <%
                            // Aquí es donde obtienes la lista de proveedores
                            // proveedorControl ya fue declarado con <jsp:useBean> arriba
                            List<Proveedor> listaProveedores = proveedorControl.LisProvee();
                            for (Proveedor prov : listaProveedores) {
                        %>
                        <option value="<%= prov.getId_proveedor()%>"><%= prov.getNombre_empresa()%></option>
                        <%
                            }
                        %>
                    </select><br>

                    <label>Responsable:</label>
                    <input type="number" name="responsable" required><br>

                    <input type="submit" value="Procesar Importación">
                </form>
            </div>
        </div>
    </body>
</html>