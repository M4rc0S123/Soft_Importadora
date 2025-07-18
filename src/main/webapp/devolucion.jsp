<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.Importacion, controller.ImportaControl, controller.DevolucionControl" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registrar Devolución</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
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
                color: #ffffff; /* Asegurar color blanco */
                font-size: 1.8rem;
            }

            .sidebar a {
                padding: 12px 20px;
                text-decoration: none;
                color: white;
                display: block;
                transition: background 0.3s;
            }

            .sidebar a:last-child {
                border-bottom: none; /* No hay separador en el último ítem */
            }

            .sidebar a:hover, .sidebar a.active { /* 'active' para el ítem actual */
                background-color: #0059b3; /* Azul más claro al pasar el ratón */
                color: #ffffff;
            }

            /* Contenido principal */
            .main-content {
                margin-left: 220px;
                padding: 20px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            h1 { /* Estilo para el título principal de la página */
                color: #2c3e50; /* Un tono oscuro para el título */
                text-align: center;
                margin-bottom: 30px;
                font-size: 2.2rem;
                width: 100%; /* Asegura que ocupe todo el ancho disponible */
            }

            .form-card {
                background-color: #fff;
                padding: 30px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Sombra más pronunciada */
                border-radius: 8px;
                width: 100%;
                max-width: 600px; /* Ancho máximo para el formulario */
                margin-bottom: 30px; /* Espacio debajo de la tarjeta del formulario */
            }

            .form-group {
                margin-bottom: 20px; /* Espacio entre cada campo del formulario */
            }

            .form-group label {
                display: block; /* La etiqueta ocupa su propia línea */
                margin-bottom: 8px; /* Espacio entre la etiqueta y el input */
                font-weight: 600; /* Texto de etiqueta más negrita */
                color: #333; /* Color oscuro para las etiquetas */
            }

            .form-control {
                width: 100%;
                padding: 12px;
                border: 1px solid #ced4da;
                border-radius: 5px;
                font-size: 1rem;
                box-shadow: inset 0 1px 2px rgba(0,0,0,0.075);
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }

            .form-control:focus {
                border-color: #80bdff; /* Borde azul al enfocar */
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); /* Sombra azul al enfocar */
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1rem;
                font-weight: bold;
                transition: background-color 0.2s ease-in-out, transform 0.1s ease-in-out;
            }

            .btn-primary {
                background-color: #007bff; /* Azul primario */
                color: white;
                width: 100%; /* Ocupar todo el ancho disponible */
                margin-top: 10px; /* Espacio superior */
            }

            .btn-primary:hover {
                background-color: #0056b3; /* Azul más oscuro al pasar el ratón */
                transform: translateY(-1px); /* Efecto de "levantar" */
            }

            .btn-regresar { /* Botón de regresar, separado */
                display: flex; /* Usar flex para centrar contenido */
                align-items: center;
                justify-content: center;
                width: 250px; /* Un poco más ancho */
                background-color: #28a745; /* Verde */
                color: white;
                padding: 12px 25px; /* Más padding */
                text-align: center;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
                margin: 30px auto 0; /* Centrar y margen superior */
                box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Sombra para el botón */
            }

            .btn-regresar:hover {
                background-color: #218838; /* Verde más oscuro al pasar el ratón */
                transform: translateY(-1px);
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

            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
            }

            input[type="text"],
            input[type="date"],
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            button {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                font-weight: bold;
                cursor: pointer;
            }

            button:hover {
                background-color: #0056b3;
            }
            
            .button-container {
                display: flex;
                justify-content: space-between; /* Adjust as needed for spacing */
                align-items: center; /* Align items vertically in the middle */
                width: 100%; /* Ensure it takes full width of form-card */
                margin-top: 20px; /* Add some space above the buttons */
            }

            /* Adjust button widths within the container if necessary */
            .button-container .btn-primary {
                width: 48%; /* Example: make them take roughly half the width with some gap */
                margin-top: 0; /* Reset margin-top from original .btn-primary */
            }

            .button-container .btn-regresar {
                width: 48%; /* Example: make them take roughly half the width with some gap */
                margin: 0; /* Reset margins from original .btn-regresar */
            }
            .alert-message {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
                text-align: center;
            }
            
            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
        </style>
    </head>
    <body>
        <%
            // Obtener el ID de importación del parámetro
            String idImportacionParam = request.getParameter("idImportacion");
            Importacion importacion = null;
            
            boolean existeDevolucionActiva = false;
            String errorMessage = request.getParameter("error");
            String successMessage = request.getParameter("success");
            
            if (idImportacionParam != null && !idImportacionParam.isEmpty()) {
                ImportaControl importControl = new ImportaControl();
                importacion = importControl.obtenerImportacionPorId(Integer.parseInt(idImportacionParam));
                
                DevolucionControl devControl = new DevolucionControl();
                existeDevolucionActiva = devControl.existeDevolucionActivaParaImportacion(Integer.parseInt(idImportacionParam));
            }
        %>

        <div class="sidebar">
            <h2>Menú</h2>
            <a href="DashboardServlet">Principal</a>
            <a href="#">Roles</a>
            <a href="empleado">Empleados</a>
            <a href="LisProvee.jsp">Proveedores</a>
            <a href="producto">Productos</a>
            <a href="buscarImportacion.jsp">Importaciones</a>
            <a href="AlmacenServlet">Almacenes</a>
            <a href="ListarDevolucionesServlet">Devoluciones</a>
        </div>
        

        <div class="main-content">  
            <%-- Mostrar mensaje de error si existe --%>
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert-message alert-error">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="alert-message alert-success">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (existeDevolucionActiva) { %>
                <div class="alert-message alert-error">
                    Ya existe una devolución activa para esta importación. 
                    Solo se permite una devolución activa por importación.
                </div>
            <% } %>
            <h1>Registrar Nueva Devolución</h1>
            <div class="form-card">

                <form action="ProcesarDevolucionServlet" method="post" <%= existeDevolucionActiva ? "onsubmit='return false;'" : "" %>>
                    <!-- Campos ocultos para datos de importación -->
                    <input type="hidden" name="idImportacion" value="<%= (importacion != null) ? importacion.getId_importacion() : "" %>">
                    
                    <div class="form-group">
                        <label for="codigoImportacion">Código Importación:</label>
                        <input type="text" id="codigoImportacion" name="codigoImportacion" 
                               value="<%= (importacion != null) ? importacion.getCodigo_importacion() : "" %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="fechaEmision">Fecha Emisión:</label>
                        <input type="text" id="fechaEmision" name="fechaEmision" 
                               value="<%= (importacion != null) ? importacion.getFecha_emision() : "" %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="fechaDevolucion">Fecha Devolución:</label>
                        <input type="date" id="fechaDevolucion" name="fechaDevolucion" required
                               <%= existeDevolucionActiva ? "disabled" : "" %>>
                    </div>

                    <div class="form-group">
                        <label for="motivo">Motivo:</label>
                        <input type="text" id="motivo" name="motivo" required
                               <%= existeDevolucionActiva ? "disabled" : "" %>>
                    </div>

                    <div class="form-group">
                        <label for="responsable">Responsable:</label>
                        <input type="text" id="responsable" name="responsable" required>
                    </div>

                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" required
                                <%= existeDevolucionActiva ? "disabled" : "" %>>
                            <option value="pendiente_envio">Pendiente de envío</option>
                            <option value="enviado">Enviado</option>
                            <option value="confirmado">Confirmado</option>
                            <option value="cancelado">Cancelado</option>
                        </select>
                    </div>
                    
                    <div class="button-container">
                        <button type="submit" class="btn-primary" <%= existeDevolucionActiva ? "disabled" : "" %>>Registrar Devolución</button>
                        <a href="buscarImportacion.jsp" class="btn-regresar">⬅ Regresar a Importaciones</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>

