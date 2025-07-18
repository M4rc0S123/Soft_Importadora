<%@ page import="java.util.*, model.*" %>
<%
System.out.println("Atributos en la request:");
Enumeration<String> attNames = request.getAttributeNames();
while (attNames.hasMoreElements()) {
    String name = attNames.nextElement();
    System.out.println(name + " = " + request.getAttribute(name));
}
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>
<html>
<head>
    <title>Detalle de Importación</title>
    <style>
        body {
        margin: 0;
        font-family: 'Segoe UI', sans-serif;
        display: flex; /* Permite que sidebar y main-content se coloquen uno al lado del otro */
        background-color: #f4f4f4;
        min-height: 100vh; /* Asegura que el body tenga al menos la altura de la ventana */
    }

    .sidebar {
        width: 220px;
        background-color: #003366;
        color: white;
        /* height: 100vh; -- REMOVIDO: ya no es necesario si flex en body maneja la altura */
        position: sticky; /* Cambiado de fixed a sticky para que el menú se quede si la página es corta */
        top: 0; /* Necesario para position: sticky */
        display: flex;
        flex-direction: column;
        padding-top: 20px;
        z-index: 1000; /* Asegura que esté por encima de otros elementos */
        flex-shrink: 0; /* Evita que el sidebar se encoja */
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
    padding: 20px;
    flex-grow: 1;
    background-color: #ffffff;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
    border-radius: 8px;

    /* Estilos para centrar el contenido y darle espacio */
    max-width: 1000px; /* Limita el ancho máximo para que no se estire demasiado */
    margin: 20px auto 20px 20px; /* Margen: arriba 20px, derecha 'auto', abajo 20px, izquierda 20px */
                                /* 'auto' en el margen derecho ayuda a centrarlo si hay espacio */
}

    /* Estilos específicos para la tabla de información general */
    .info-table {
        border-collapse: collapse;
        width: 100%; /* Ocupa todo el ancho disponible del contenedor */
        margin-bottom: 20px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05); /* Sombra más ligera */
        border-radius: 5px;
        overflow: hidden; /* Para que los bordes redondeados se apliquen al shadow */
    }

    .info-table th, .info-table td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: left; /* Alineado a la izquierda para la información */
    }

    .info-table th {
        background-color: #f2f2f2;
        font-weight: bold;
        width: 30%; /* Da un poco más de espacio a los encabezados */
    }

    /* Estilos para la tabla de detalles de productos (que se desbordaba) */
    .product-detail-table {
        width: 100%; /* Ocupa todo el ancho disponible */
        border-collapse: collapse;
        margin-top: 20px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        border-radius: 5px;
        overflow: hidden;
    }

    .product-detail-table th, .product-detail-table td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }

    .product-detail-table th {
        background-color: #f2f2f2;
        font-weight: bold;
    }

    .product-detail-table tbody tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    /* Contenedor responsive para la tabla de productos (Solución de desbordamiento) */
    .table-responsive {
        overflow-x: auto; /* Agrega scroll horizontal si la tabla es demasiado ancha */
        -webkit-overflow-scrolling: touch; /* Mejora el scroll en dispositivos móviles */
    }

    /* Estilos de botones (btn) */
    .btn {
        padding: 10px 20px;
        margin: 5px;
        background-color: #007bff;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        border: none; /* Asegurar que no tengan borde */
        cursor: pointer;
        transition: background-color 0.3s ease;
        display: inline-block; /* Para que margin y padding funcionen bien */
    }
    .btn:hover {
        background-color: #0056b3;
    }

    /* Clases de Bootstrap básicas para tablas (si usas Bootstrap) */
    .table {
        width: 100%;
        margin-bottom: 1rem;
        color: #212529;
        border-collapse: collapse;
    }
    .table th,
    .table td {
        padding: 0.75rem;
        vertical-align: top;
        border-top: 1px solid #dee2e6;
    }
    .table thead th {
        vertical-align: bottom;
        border-bottom: 2px solid #dee2e6;
    }
    .table tbody + tbody {
        border-top: 2px solid #dee2e6;
    }
    .table-bordered {
        border: 1px solid #dee2e6;
    }
    .table-bordered th,
    .table-bordered td {
        border: 1px solid #dee2e6;
    }
    .table-bordered thead th,
    .table-bordered thead td {
        border-bottom-width: 2px;
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
        <%-- Mostrar mensaje de error si existe --%>
        <c:if test="${not empty mensajeError}">
            <p style="color: red; font-weight: bold;">${mensajeError}</p>
        </c:if>

        <%-- Usar <c:if> para mostrar la información solo si el objeto 'importacion' existe --%>
        <c:if test="${not empty importacion}">
            <h1>Detalle de Importación</h1>
            <h3>Información General</h3>
            <table class="info-table">
                <tr><th>ID Importación</th><td>${importacion.id_importacion}</td></tr>
                <tr><th>Código de Importación</th><td>${importacion.codigo_importacion}</td></tr>
                <tr><th>Fecha de Emisión</th><td>${importacion.fecha_emision}</td></tr>
                <tr><th>Fecha Estimada de Arribo</th><td>${importacion.fecha_estimada_arribo}</td></tr>
                <tr><th>Fecha Real de Arribo</th><td>${importacion.fecha_real_arribo}</td></tr>
                <tr><th>Estado</th><td>${importacion.estado}</td></tr>
                <tr><th>ID Proveedor</th><td>${importacion.id_proveedor}</td></tr>
                <tr><th>Responsable</th><td>${importacion.responsable}</td></tr>
            </table>

            <h2>Detalle de Productos Importados</h2>
            <div class="table-responsive">
                <table class="product-detail-table table table-bordered">
                    <thead>
                        <tr>
                            <th>ID Detalle</th>
                            <%-- <th>ID Importación</th> --%> <%-- Este ya está en la cabecera, es redundante aquí --%>
                            <th>ID Producto</th>
                            <th>Cantidad</th>
                            <th>Precio Unitario</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Iterar sobre la lista de detalles de importación --%>
                        <c:forEach var="detalle" items="${listaDetalles}">
                            <tr>
                                <td>${detalle.id_detalle}</td>
                                <%-- <td>${detalle.id_importacion}</td> --%>
                                <td>${detalle.id_producto}</td>
                                <td>${detalle.cantidad}</td>
                                <td>${detalle.precio_unitario}</td>
                                <td>${detalle.subtotal}</td>
                            </tr>
                        </c:forEach>
                        <%-- Mensaje si no hay detalles --%>
                        <c:if test="${empty listaDetalles}">
                            <tr><td colspan="5">No hay productos asociados a esta importación.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <a href="producto.jsp" class="btn">Ir a Productos</a>
            <a href="buscarImportacion.jsp" class="btn">Volver a Importaciones</a>

        </c:if>
        <%-- Mensaje si no se encontró la importación o no se pasó el ID --%>
        <c:if test="${empty importacion and empty mensajeError}">
            <p>Por favor, seleccione una importación para ver los detalles.</p>
            <a href="buscarImportacion.jsp" class="btn">Ver Importaciones</a>
        </c:if>
    </div>
</body>
</html>
