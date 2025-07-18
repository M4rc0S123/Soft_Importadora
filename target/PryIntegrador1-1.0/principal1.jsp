<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Dashboard - Sistema de Control de Plazos</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    /* Estilo para el botón de cerrar sesión */
    .btn {
      display: inline-block;
      font-weight: 400;
      text-align: center;
      white-space: nowrap;
      vertical-align: middle;
      user-select: none;
      border: 1px solid transparent;
      padding: 0.375rem 0.75rem;
      font-size: 1rem;
      line-height: 1.5;
      border-radius: 0.25rem;
      transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, 
                 border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
      text-decoration: none;
    }
    
    .btn-danger {
      color: #fff;
      background-color: #dc3545;
      border-color: #dc3545;
    }
    
    .btn-danger:hover {
      color: #fff;
      background-color: #c82333;
      border-color: #bd2130;
    }
    
    .logout-container {
      position: absolute;
      top: 20px;
      right: 20px;
      z-index: 1000;
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

    /* Estilo para el botón de cerrar sesión */
    .logout-btn {
      padding: 12px 20px;
      text-decoration: none;
      color: white;
      display: block;
      transition: background 0.3s;
      background-color: #d9534f;
      border: none;
      width: 100%;
      text-align: left;
      cursor: pointer;
      font-family: 'Segoe UI', sans-serif;
      font-size: 1em;
    }

    .logout-btn:hover {
      background-color: #c9302c;
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

    .estado-pendiente { color: #f0ad4e; }
    .estado-transito { color: #5bc0de; }
    .estado-recibido { color: #5cb85c; }

    footer {
      margin-top: 40px;
      text-align: center;
      font-size: 14px;
      color: #888;
    }
  </style>
</head>
<body>

  <!-- Menú lateral -->
  <div class="sidebar">
    <h2>Menú</h2>
    <a href="DashboardServlet1">Principal</a>
    <a href="LisProvee1.jsp">Proveedores</a>
    <a href="producto1">Productos</a>
    <a href="buscarImportacion1.jsp">Importaciones</a>
    <a href="AlmacenServlet1">Almacenes</a>
    
    <!-- Botón para cerrar sesión -->
    
  </div>

  <!-- Contenido principal -->
  <div class="main-content" id="principal1">
    <h1>Dashboard - Sistema de Control de Plazos</h1>

    <div class="container">
      <!-- Estado de Importaciones -->
      <div class="card1">
        <h3>Importaciones Activas</h3>
        <p class="status estado-pendiente">Pendientes: <strong>${totalPendientes}</strong></p>
        <p class="status estado-transito">En tránsito: <strong>${totalEnTransito}</strong></p>
        <p class="status estado-recibido">Recibidas: <strong>${totalRecibidas}</strong></p>
      </div>

      <!-- Alertas recientes -->
      <div class="card1">
    <h3>Alertas Recientes</h3>
    <c:choose>
        <c:when test="${not empty alertas}">
            <c:forEach items="${alertas}" var="alerta">
                <p class="${fn:contains(alerta, '❌') || fn:contains(alerta, '📌') || fn:contains(alerta, '⏰') ? 'alerta' : ''}">
                    ${alerta}
                </p>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p>No hay alertas recientes</p>
        </c:otherwise>
    </c:choose>
</div>

      <!-- Seguimientos -->
      <div class="card1">
        <h3>Seguimiento de Plazos</h3>
        <p>En Proceso: <strong>${contadorEnProceso}</strong> </p>
        <p>Completos: <strong>${contadorCompletos}</strong></p>
        <p class="alerta">Retrasados: <strong>${contadorRetrasados}</strong></p>
      </div>

      <!-- Devoluciones -->
      <div class="card1">
        <h3>Devoluciones</h3>
        <p>Pendientes de envío: <strong>${devolucionesPendientes}</strong></p>
        <p>Enviadas: <strong>${devolucionesEnviadas}</strong></p>
        <p>Confirmadas: <strong>${devolucionesConfirmadas}</strong></p>
      </div>
    </div>

    <!-- Tabla de Importaciones -->
    <div class="card" id="tabla-importaciones">
  <h3>Importaciones recientes</h3>
  <table style="width: 100%; border-collapse: collapse;">
    <thead style="background-color: #003366; color: white;">
      <tr>
        <th style="padding: 10px; border: 1px solid #ccc;">Proveedor</th>
        <th style="padding: 10px; border: 1px solid #ccc;">Productos</th>
        <th style="padding: 10px; border: 1px solid #ccc;">Estado</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${not empty importacionesRecientes}">
          <c:forEach items="${importacionesRecientes}" var="imp">
            <tr>
              <td style="padding: 10px; border: 1px solid #ccc;">
                ${imp.proveedor != null ? imp.proveedor : 'N/A'}
              </td>
              <td style="padding: 10px; border: 1px solid #ccc;">
                ${imp.productos != null ? imp.productos : 'Ningún producto'}
              </td>
              <td style="padding: 10px; border: 1px solid #ccc;" 
                  class="estado-${fn:toLowerCase(imp.estado)}">
                ${imp.estado != null ? imp.estado : 'Desconocido'}
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr>
            <td colspan="3" style="padding: 10px; text-align: center;">
              No hay importaciones recientes
            </td>
          </tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
    

    <footer>
      &copy; 2025 Sistema de Gestión Logística - Importadora SAC
    </footer>
  </div>
</body>
<div style="position: absolute; top: 20px; right: 20px;">
        <a href="Login.jsp" class="btn btn-danger">Cerrar Sesión</a>
    </div>
</html>