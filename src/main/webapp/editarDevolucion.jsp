<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Devolucion" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Devolución</title>
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

        .sidebar {
            width: 220px;
            background-color: #003366;
            color: white;
            height: 100vh;
            position: fixed;
            display: flex;
            flex-direction: column;
            padding-top: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .main-content {
            margin-left: 220px;
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .form-card {
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            width: 100%;
            max-width: 600px;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 1rem;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: bold;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
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
        <h1>Editar Estado de Devolución</h1>
        
        <%-- Mostrar mensajes de error --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert-message alert-error">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <div class="form-card">
            <%
                Devolucion devolucion = (Devolucion) request.getAttribute("devolucion");
                if (devolucion != null) {
            %>
            <form action="EditarDevolucionServlet" method="post">
                <input type="hidden" name="idDevolucion" value="<%= devolucion.getId_devolucion() %>">
                
                <div class="form-group">
                    <label>ID Devolución:</label>
                    <input type="text" class="form-control" value="<%= devolucion.getId_devolucion() %>" readonly>
                </div>
                
                <div class="form-group">
                    <label>ID Importación:</label>
                    <input type="text" class="form-control" value="<%= devolucion.getId_importacion() %>" readonly>
                </div>
                
                <div class="form-group">
                    <label>Fecha Devolución:</label>
                    <input type="text" class="form-control" value="<%= devolucion.getFecha_devolucion() %>" readonly>
                </div>
                
                <div class="form-group">
                    <label>Motivo:</label>
                    <input type="text" class="form-control" value="<%= devolucion.getMotivo() %>" readonly>
                </div>
                
                <div class="form-group">
                    <label>Responsable:</label>
                    <input type="text" class="form-control" value="<%= devolucion.getResponsable() %>" readonly>
                </div>
                
                <div class="form-group">
                    <label for="estado">Nuevo Estado:</label>
                    <select id="estado" name="estado" class="form-control" required>
                        <option value="pendiente_envio" <%= "pendiente_envio".equals(devolucion.getEstado()) ? "selected" : "" %>>Pendiente de envío</option>
                        <option value="enviado" <%= "enviado".equals(devolucion.getEstado()) ? "selected" : "" %>>Enviado</option>
                        <option value="confirmado" <%= "confirmado".equals(devolucion.getEstado()) ? "selected" : "" %>>Confirmado</option>
                        <option value="cancelado" <%= "cancelado".equals(devolucion.getEstado()) ? "selected" : "" %>>Cancelado</option>
                    </select>
                </div>
                
                <div style="display: flex; justify-content: space-between; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">Actualizar Estado</button>
                    <a href="ListarDevolucionesServlet" class="btn btn-secondary">Cancelar</a>
                </div>
            </form>
            <% } else { %>
                <p>No se encontró la devolución solicitada.</p>
                <a href="ListarDevolucionesServlet" class="btn btn-secondary">Volver</a>
            <% } %>
        </div>
    </div>
</body>
</html>