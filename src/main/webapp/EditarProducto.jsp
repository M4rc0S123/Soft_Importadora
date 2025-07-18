<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Producto" %>
<% Producto producto = (Producto) request.getAttribute("producto"); %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Producto</title>
    <style>
        /* Usa los mismos estilos que en AgregarProducto.jsp */
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { max-width: 500px; margin: 0 auto; padding: 20px; 
                         border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], textarea, select { width: 100%; padding: 8px; 
             border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        input[type="file"] { width: 100%; padding: 8px; }
        .submit-btn { background-color: #4CAF50; color: white; padding: 10px 15px; 
                     border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .submit-btn:hover { background-color: #45a049; }
        .current-image { max-width: 150px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Editar Producto</h2>
        <form action="producto" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= producto.getId_producto() %>">
            
            <div class="form-group">
                <label for="nombre">Nombre del Producto:</label>
                <input type="text" id="nombre" name="nombre" 
                       value="<%= producto.getNombre_producto() %>" required>
            </div>
            
            <div class="form-group">
                <label for="descripcion">Descripción:</label>
                <textarea id="descripcion" name="descripcion" rows="3" required>
                    <%= producto.getDescripcion() %>
                </textarea>
            </div>
            
            <div class="form-group">
                <label for="unidad">Unidad de Medida:</label>
                <input type="text" id="unidad" name="unidad" 
                       value="<%= producto.getUnidad_medida() %>" required>
            </div>
            
            <div class="form-group">
                <label for="categoria">Categoría:</label>
                <input type="text" id="categoria" name="categoria" 
                       value="<%= producto.getCategoria() %>" required>
            </div>
            
            <div class="form-group">
                <label>Imagen Actual:</label>
                <% if (producto.getRuta_imagen() != null && !producto.getRuta_imagen().isEmpty()) { %>
                    <img src="<%= producto.getRuta_imagen() %>" 
                         alt="Imagen actual" class="current-image">
                    <p><%= producto.getRuta_imagen() %></p>
                <% } else { %>
                    <p>No hay imagen actual</p>
                <% } %>
            </div>
            
            <div class="form-group">
                <label for="imagen">Nueva Imagen (dejar en blanco para mantener la actual):</label>
                <input type="file" id="imagen" name="imagen" accept="image/*">
            </div>
            
            <div class="form-group">
                <input type="submit" value="Actualizar Producto" class="submit-btn">
            </div>
        </form>
    </div>
</body>
</html>