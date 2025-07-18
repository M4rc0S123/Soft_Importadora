<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agregar Producto</title>
    <style>
           * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: 'Segoe UI', sans-serif;
        display: flex;
        background-color: #f4f4f4;
        /* Remover el 'display: flex' de aquí si el body solo contiene el sidebar y un contenedor principal */
        /* Lo movemos a un nuevo contenedor si queremos controlar mejor la alineación del contenido principal */
    }

    /* Menú lateral */
    .sidebar {
        width: 220px;
        background-color: #003366;
        color: white;
        height: 100vh;
        position: fixed; /* Mantiene el menú en su lugar mientras se hace scroll */
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

    /* Nuevo contenedor para el contenido principal */
    .content-wrapper { /* Agrega esta nueva clase a un div que envuelva tu main-content */
        margin-left: 220px; /* Desplaza el contenido para que no quede debajo del sidebar fijo */
        flex-grow: 1; /* Permite que este contenedor ocupe el espacio restante */
        display: flex; /* Habilitamos flexbox para centrar el contenido horizontalmente */
        justify-content: center; /* Centra horizontalmente el contenido dentro de content-wrapper */
        align-items: flex-start; /* Alinea el contenido al inicio verticalmente (arriba) */
        padding: 20px; /* Espacio alrededor del contenido */
    }

    /* Contenido principal específico de cada página (ej. el formulario de agregar producto) */
    .main-content { /* Si ya tenías esta clase para el header-importacion o similar */
        /* Ya no necesita margin-left, el content-wrapper lo maneja */
        /* padding: 20px; /* Esto se moverá al content-wrapper */
        /* flex-grow: 1; /* Esto se moverá al content-wrapper */
    }

    .form-container {
        max-width: 500px;
        /* margin: 0 auto; */ /* Ya no es necesario si el padre es flex con justify-content: center */
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
        background-color: #f9f9f9;
        width: 100%; /* Asegura que tome el ancho máximo de su contenedor flex antes de aplicar max-width */
    }

    /* ************************************************************ */
    /* El resto de tus estilos de formulario y tabla pueden quedarse */
    /* ************************************************************ */

    /* Estilos para el formulario */
    .form-group {
        margin-bottom: 15px;
    }
    label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    input[type="text"], textarea, select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }
    input[type="file"] {
        width: 100%;
        padding: 8px;
    }
    .submit-btn {
        background-color: #4CAF50;
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
    }
    .submit-btn:hover {
        background-color: #45a049;
    }

    /* Estilos para los botones de Cancelar */
    /* Asegúrate de tener los estilos para .btn y .btn-danger si no estás usando Bootstrap */
    .btn {
        padding: 10px 15px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        text-decoration: none; /* Si es un ancla */
        display: inline-block; /* Si es un botón o ancla para que ocupe el espacio correcto */
        text-align: center;
    }

    .btn-danger {
        background-color: #dc3545; /* Rojo */
        color: white;
        border: 1px solid #dc3545;
    }

    .btn-danger:hover {
        background-color: #c82333; /* Rojo más oscuro al pasar el mouse */
        border-color: #bd2130;
    }

    /* Si usas los estilos del botón "Crear Producto" para el de "Cancelar" también puedes unificarlo */
    .btn_crear_form { /* Nuevo estilo para botones dentro del formulario */
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
        margin-right: 10px; /* Para separar los botones */
    }
    .btn_crear_form:hover {
        background-color: #0056b3;
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
    <div class="content-wrapper">
    <div class="form-container">
        <h2>Agregar Nuevo Producto</h2>
        <form action="producto" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">
            
            <div class="form-group">
                <label for="nombre">Nombre del Producto:</label>
                <input type="text" id="nombre" name="nombre" required>
            </div>
            
            <div class="form-group">
                <label for="descripcion">Descripción:</label>
                <textarea id="descripcion" name="descripcion" rows="3" required></textarea>
            </div>
            
            <div class="form-group">
                <label for="unidad">Unidad de Medida:</label>
                <input type="text" id="unidad" name="unidad" required>
            </div>
            
            <div class="form-group">
                <label for="categoria">Categoría:</label>
                <input type="text" id="categoria" name="categoria" required>
            </div>
            
            <div class="form-group">
                <label for="imagen">Imagen del Producto:</label>
                <input type="file" id="imagen" name="imagen" accept="image/*">
            </div>
            
            <div class="form-group">
                <input type="submit" value="Guardar Producto" class="submit-btn">
                <button type="button" class="btn btn-danger" 
                            onclick="window.location.href='producto'">Cancelar</button>
            </div>
        </form>
    </div>
        </div>
</body>
</html>