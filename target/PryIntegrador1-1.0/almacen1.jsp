<%@page import="controller.AlmacenController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Almacen"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Almacen</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            * {
                box-sizing: border-box;
            }

            .search-filter-row {
                display: flex;
                align-items: center; /* Alinea verticalmente los elementos al centro */
                margin-bottom: 30px;
                flex-wrap: wrap; /* Permite que los elementos se envuelvan en pantallas pequeñas */
                gap: 10px; /* Espacio entre elementos */
            }

            /* Ajustes para el input y el botón */
            .search-input-group {
                display: flex; /* Usa flexbox para el input y el botón */
                flex-grow: 0; /* Evita que el grupo de input crezca demasiado */
            }
            .search-input-group .form-control {
                width: 250px; /* Puedes ajustar este ancho fijo para la barra de búsqueda */
            }
            .search-input-group .btn {
                white-space: nowrap; /* Evita que el texto del botón se rompa */
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

            .table-responsive {
                border: 1px solid #dee2e6; /* Borde general para enmarcar la tabla */
                border-radius: 8px; /* Bordes redondeados para la tabla */
                overflow-x: auto; /* Permite desplazamiento horizontal en pantallas pequeñas */
                margin-top: 20px; /* Espacio superior */
                box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Sombra suave para el enmarcado */
            }

            .table-header span {
                /* flex: 1;  <-- Asegúrate de que esta línea esté comentada o eliminada */
                /* text-align: center; <-- Comentamos o eliminamos esta línea general */
                padding: 0 10px; /* Mantenemos el padding horizontal para separación */
            }

            .table-header span:nth-child(1) { /* NOMBRE DEL PRODUCTO */
                flex: 4;
                text-align: center; /* ¡CAMBIO CLAVE: Alinear al centro! */
            }
            .table-header span:nth-child(2) { /* CÓDIGO */
                flex: 2;
                text-align: center; /* ¡CAMBIO CLAVE: Alinear al centro! */
            }
            .table-header span:nth-child(3) { /* CANTIDAD */
                flex: 1.5;
                text-align: center; /* ¡CAMBIO CLAVE: Alinear al centro! */
            }
            .table-header span:nth-child(4) { /* PRECIO */
                flex: 2;
                text-align: center; /* ¡CAMBIO CLAVE: Alinear al centro! */
            }

            .table-row span {
                /* flex: 1;  <-- Asegúrate de que esta línea esté comentada o eliminada */
                text-align: center; /* Si quieres que los datos de las filas también estén centrados */
                padding: 0 10px;
            }

            .table-row span:nth-child(1) { /* Dato de NOMBRE DEL PRODUCTO */
                flex: 4;
                text-align: left; /* Mantener la alineación a la izquierda para el nombre del producto en las filas */
            }
            .table-row span:nth-child(2) { /* Dato de CÓDIGO */
                flex: 2;
                text-align: center;
            }
            .table-row span:nth-child(3) { /* Dato de CANTIDAD */
                flex: 1.5;
                text-align: center;
            }
            .table-row span:nth-child(4) { /* Dato de PRECIO */
                flex: 2;
                text-align: right; /* Mantener la alineación a la derecha para el precio en las filas */
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2>Menú</h2>
            <a href="DashboardServlet1">Principal</a>
            <a href="LisProvee1.jsp">Proveedores</a>
            <a href="producto1">Productos</a>
            <a href="buscarImportacion1.jsp">Importaciones</a>
            <a href="AlmacenServlet1">Almacenes</a>
            
        </div>    
        <div class="main-content">
            <h2>ALMACEN</h2>

            <div class="search-filter-row">
                <form action="AlmacenServlet1" method="GET" class="search-input-group">
                    <input type="hidden" name="action" value="buscar">
                    <input type="text" name="search" class="form-control" placeholder="Buscar almacén...">
                    <button type="submit" class="btn btn-primary d-flex align-items-center ms-2">
                        BUSCAR <i class="fas fa-search ms-2"></i>
                    </button>
                </form>

                <div class="ms-auto">
                    <a href="AlmacenServlet1?action=nuevo" class="btn btn-success">
    <i class="fas fa-plus"></i> Nuevo Almacén
</a>
                </div>
            </div>
            
             <% 
    List<Almacen> almacenes = (List<Almacen>) request.getAttribute("almacenes");
    System.out.println("DEBUG - Almacenes en JSP: " + almacenes);
    
    if (almacenes == null) { 
        AlmacenController control= new AlmacenController();
        almacenes=control.listarAlmacenes();
        System.out.println("DEBUG - El atributo 'almacenes' es null");
    %>
    <div class="alert alert-warning">No se encontraron importaciones almacenadas.</div>
            <%
                } else {
            %>

            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>ID Importación</th>
                            <th>Fecha Recepción</th>
                            <th>Recibido Por</th>
                            <th>Estado</th>
                           
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (Almacen almacen : almacenes) {
                    %>
   
        <tr>
            
            <tr>
                <td><%= almacen.getIdAlmacen() %></td>
                <td><%= almacen.getIdImportacion() %></td>
                <td><%= almacen.getFechaRecepcion() %></td>
                <td><%= almacen.getRecibidoPor() %></td>
                <td>
                    <span class="badge bg-<%= 
                        almacen.getEstado().equals("completo") ? "success" : 
                        almacen.getEstado().equals("parcial") ? "warning" : "danger" 
                    %>">
                        <%= almacen.getEstado().toUpperCase() %>
                    </span>
                </td>
                
            </tr>
    <%   }
       } %>
</tbody>
                </table>
            </div>

            <!-- Mantén tu paginación -->
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
