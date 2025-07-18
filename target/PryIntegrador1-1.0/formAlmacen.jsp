<%@page import="java.util.List"%>
<%@page import="model.Importacion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nuevo Almacén</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4">Registrar Nuevo Almacén</h2>
            
            <form action="AlmacenServlet" method="POST">
                <input type="hidden" name="action" value="registrar">
                
                <div class="mb-3">
    <label for="id_importacion" class="form-label">Seleccione Importación</label>
    <select class="form-select" id="id_importacion" name="id_importacion" required>
        <option value="">-- Seleccione una importación disponible --</option>
        <%
            List<Importacion> importaciones = (List<Importacion>) request.getAttribute("importaciones");
            if (importaciones != null && !importaciones.isEmpty()) {
                for (Importacion imp : importaciones) {
        %>
        <option value="<%= imp.getId_importacion() %>">
            <%= imp.getCodigo_importacion() %> 
        </option>
        <%
                }
            } else {
        %>
        <option value="" disabled>No hay importaciones disponibles para almacenar</option>
        <%
            }
        %>
    </select>
</div>
                
                <div class="mb-3">
                    <label for="fecha_recepcion" class="form-label">Fecha de Recepción</label>
                    <input type="date" class="form-control" id="fecha_recepcion" name="fecha_recepcion" required>
                </div>
                
                <div class="mb-3">
                    <label for="recibido_por" class="form-label">Recibido Por (ID Empleado)</label>
                    <input type="number" class="form-control" id="recibido_por" name="recibido_por" required>
                </div>
                
                <div class="mb-3">
                    <label for="observaciones" class="form-label">Observaciones</label>
                    <textarea class="form-control" id="observaciones" name="observaciones" rows="3"></textarea>
                </div>
                
                <div class="mb-3">
                    <label for="estado" class="form-label">Estado</label>
                    <select class="form-select" id="estado" name="estado" required>
                        <option value="completo">Completo</option>
                        <option value="parcial">Parcial</option>
                        <option value="faltantes">Faltantes</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary">Registrar</button>
                <a href="AlmacenServlet?action=listar" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>