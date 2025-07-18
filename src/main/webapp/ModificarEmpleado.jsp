<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Empleado" %>
<%@ page import="model.Rol" %>
<%@ page import="java.util.List" %>
<%@ page import="controller.EmpleadoControl" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modificar Empleado</title>
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
        /* Estilos similares a los de AgregarEmpleado.jsp */
        .form-container {
            max-width: 500px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"],
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn-submit {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-submit:hover {
            background-color: #45a049;
        }
        .btn-cancel { /* Nuevo estilo para el botón Cancelar */
            background-color: #dc3545; /* Rojo */
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-cancel:hover {
            background-color: #c82333;
        }
        .radio-group {
            display: flex;
            gap: 15px;
        }
        .radio-option {
            display: flex;
            align-items: center;
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
    
    <div class="form-container">
        <h1>Modificar Empleado</h1>
        <form action="empleado" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${empleado.id_empleado}">
            
            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" value="${empleado.nombre}" required>
            </div>
            
            <div class="form-group">
                <label for="apellido">Apellido:</label>
                <input type="text" id="apellido" name="apellido" value="${empleado.apellido}" required>
            </div>
            
            <div class="form-group">
                <label for="correo">Correo:</label>
                <input type="email" id="correo" name="correo" value="${empleado.correo}" required>
            </div>
            
            <div class="form-group">
                <label>Estado:</label>
                <div class="radio-group">
                    <div class="radio-option">
                        <input type="radio" id="activo" name="estado" value="true" ${empleado.estado ? 'checked' : ''}>
                        <label for="activo">Activo</label>
                    </div>
                    <div class="radio-option">
                        <input type="radio" id="inactivo" name="estado" value="false" ${!empleado.estado ? 'checked' : ''}>
                        <label for="inactivo">Inactivo</label>
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="rol">Rol:</label>
                <select id="rol" name="rol" required>
                    <%
                    EmpleadoControl control = new EmpleadoControl();
                    List<Rol> roles = control.listarRoles(); // Necesitarás implementar este método
                    Empleado emp = (Empleado) request.getAttribute("empleado");
                    
                    for (Rol rol : roles) {
                        String selected = (emp != null && emp.getRol().getId_rol() == rol.getId_rol()) ? "selected" : "";
                    %>
                        <option value="<%= rol.getId_rol() %>" <%= selected %>><%= rol.getNombre_rol() %></option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-group">
                <input type="submit" value="Guardar Cambios" class="btn-submit">
                <button type="button" class="btn-cancel" onclick="window.location.href='empleado'">Cancelar</button>
            </div>
        </form>
    </div>
</body>
</html>