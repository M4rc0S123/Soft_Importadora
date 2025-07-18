<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.SeguimientoPlazo, model.Importacion, java.util.List" %>
<%
// Obtener los parámetros primero
List<SeguimientoPlazo> seguimientos = (List<SeguimientoPlazo>) request.getAttribute("seguimientos");
Importacion importacion = (Importacion) request.getAttribute("importacion");
%>

<%!
// Función para obtener seguimiento por tipo con mensajes de depuración

private SeguimientoPlazo getSeguimientoPorTipo(int tipo, List<SeguimientoPlazo> seguimientos) {
    if (seguimientos == null) return null;
    for (SeguimientoPlazo sp : seguimientos) {
        if (sp.getIdTipoSeguimiento() == tipo) {
            return sp;
        }
    }
    return null;
}    
// Función helper para verificar si la etapa anterior está completada
private boolean isEtapaAnteriorCompletada(int tipoActual, List<SeguimientoPlazo> seguimientos) {
    if (tipoActual == 1) return true; // La primera etapa siempre está disponible
    
    for (SeguimientoPlazo sp : seguimientos) {
        if (sp.getIdTipoSeguimiento() == tipoActual - 1) {
            return "Completado".equalsIgnoreCase(sp.getEstado());
        }
    }
    return false; // Si no existe la etapa anterior, no permitir
}


%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seguimiento de Importación</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* [Todos los estilos anteriores se mantienen igual] */
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

        .timeline-container {
            display: flex;
            flex-direction: column;
            margin-top: 30px;
        }

        .timeline-step {
            display: flex;
            margin-bottom: 30px;
            position: relative;
        }

        .step-icon {
            font-size: 30px;
            margin-right: 20px;
            color: #ccc;
            min-width: 40px;
            text-align: center;
            z-index: 1;
        }

        .step-content {
            flex: 1;
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .step-title {
            font-weight: bold;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
        }

        .step-details {
            font-size: 14px;
            color: #555;
        }

        .step-details p {
            margin: 5px 0;
        }

        .step-status {
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        /* Colores para los estados */
        /* Pendiente - Plomo */
        .pending {
            color: #9E9E9E;
        }
        .pending-bg {
            background-color: #FAFAFA;
            border-left: 3px solid #9E9E9E;
        }
        .status-pending {
            background-color: #9E9E9E;
            color: white;
        }

        /* En Proceso - Amarillo */
        .en-proceso {
            color: #FFC107;
        }
        .en-proceso-bg {
            background-color: #FFF8E1;
            border-left: 3px solid #FFC107;
        }
        .status-en-proceso {
            background-color: #FFC107;
            color: black;
        }

        /* Completado - Verde */
        .completado {
            color: #4CAF50;
        }
        .completado-bg {
            background-color: #E8F5E9;
            border-left: 3px solid #4CAF50;
        }
        .status-completado {
            background-color: #4CAF50;
            color: white;
        }

        /* Retrasado - Naranja */
        .retrasado {
            color: #FF9800;
        }
        .retrasado-bg {
            background-color: #FFF3E0;
            border-left: 3px solid #FF9800;
        }
        .status-retrasado {
            background-color: #FF9800;
            color: white;
        }

        /* Fallido - Rojo */
        .fallido {
            color: #F44336;
        }
        .fallido-bg {
            background-color: #FFEBEE;
            border-left: 3px solid #F44336;
        }
        .status-fallido {
            background-color: #F44336;
            color: white;
        }

        .timeline-step:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 20px;
            top: 50px;
            bottom: -30px;
            width: 2px;
            background: #ddd;
            z-index: 0;
        }

        .estado-pendiente { color: #f0ad4e; }
        .estado-transito { color: #5bc0de; }
        .estado-recibido { color: #5cb85c; }
        .estado-retrasado { color: #d9534f; }

        .import-info {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .info-item {
            flex: 1;
            min-width: 200px;
            margin: 5px;
            padding: 10px;
            background: white;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .info-item h4 {
            margin-top: 0;
            color: #003366;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-warning {
            background-color: #ffc107;
            color: black;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
            }
            .timeline-step {
                flex-direction: column;
            }
            .step-icon {
                margin-right: 0;
                margin-bottom: 10px;
            }  
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
            margin-top: 10px;
        }

        .step-title {
            cursor: pointer;
            transition: all 0.3s;
        }

        .step-title:hover {
            color: #007bff;
        }

        .timeline-step {
            transition: all 0.3s;
        }

        .timeline-step:hover {
            transform: translateX(5px);
        }

        
        /* Nuevos estilos para el modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: black;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-group select, .form-group input, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .form-actions {
            text-align: right;
            margin-top: 20px;
        }
        
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .edit-btn {
            margin-top: 10px;
            padding: 5px 10px;
            font-size: 12px;
        }
        /* Agregar esto en la sección de estilos CSS */
.btn-excel {
    background-color: #1d6f42;
    color: white;
    transition: all 0.3s;
}

.btn-excel:hover {
    background-color: #165732;
    color: white;
}

.btn-pdf {
    background-color: #d33;
    color: white;
    transition: all 0.3s;
}

.btn-pdf:hover {
    background-color: #a52a2a;
    color: white;
}

/* Ajustar el espaciado entre botones si es necesario */
.action-buttons {
    display: flex;
    gap: 10px;
    margin-top: 20px;
    flex-wrap: wrap; /* Para que los botones se ajusten en pantallas pequeñas */
}
.btn.disabled {
            opacity: 0.6;
            cursor: not-allowed;
            pointer-events: none;
            background-color: #cccccc !important;
            color: #666666 !important;
        }

        .info-message {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <!-- [Menú lateral se mantiene igual] -->
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
        <!-- [Contenido principal anterior se mantiene igual hasta la sección de timeline] -->
        <h1>Seguimiento de la Importación</h1>

        <% if (importacion != null) { %>
            <div class="card">
                <div class="import-info">
                    <div class="info-item">
                        <h4>Información Básica</h4>
                        <p><strong>Código:</strong> <%= importacion.getCodigo_importacion() %></p>
                        <p><strong>Estado:</strong> <span class="estado-<%= importacion.getEstado().toLowerCase() %>"><%= importacion.getEstado() %></span></p>
                    </div>
                    <div class="info-item">
                        <h4>Fechas Clave</h4>
                        <p><strong>Emisión:</strong> <%= importacion.getFecha_emision() %></p>
                        <p><strong>Estimada arribo:</strong> <%= importacion.getFecha_estimada_arribo() %></p>
                        <% if (importacion.getFecha_real_arribo() != null) { %>
                            <p><strong>Real arribo:</strong> <%= importacion.getFecha_real_arribo() %></p>
                        <% } %>
                    </div>
                    <div class="info-item">
                        <h4>Responsables</h4>
                        <p><strong>Proveedor:</strong> <%= importacion.getId_proveedor() %></p>
                        <p><strong>Responsable:</strong> <%= importacion.getResponsable() %></p>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <a href="registrarSeguimiento.jsp?idImportacion=<%= importacion.getId_importacion() %>" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Nuevo Seguimiento
                    </a>
                    <a href="DetalleImportaServlet?id_importacion=<%= importacion.getId_importacion() %>" class="btn btn-success">
                        <i class="fas fa-boxes"></i> Ver Detalles
                    </a>
                    
    
    <a href="${pageContext.request.contextPath}/GenerarReporteServlet?tipo=pdf&id=<%= importacion.getId_importacion() %>" 
       class="btn btn-pdf" style="background-color: #d33; color: white;">
        <i class="fas fa-file-pdf"></i> Exportar PDF
    </a>
                    <a href="buscarImportacion.jsp" class="btn btn-warning">
                        <i class="fas fa-arrow-left"></i> Volver
                    </a>
                </div>
            </div>
        <% } %>

        <div class="card">
            <h2>Progreso de la Importación</h2>
            <div class="timeline-container">
                <% 
                Object[][] etapas = {
                    {1, "Proveedor", "fa-truck"},
                    {2, "Embarque", "fa-shipping-fast"},
                    {3, "Puerto Destino", "fa-ship"},
                    {4, "Agente Aduanal", "fa-user-tie"},
                    {5, "Aduana", "fa-clipboard-check"},
                    {6, "Transporte", "fa-truck-moving"},
                    {7, "Almacén", "fa-box-open"}
                };
                
                boolean etapaAnteriorCompletada = true; // La primera etapa siempre está disponible
                
                for (Object[] etapa : etapas) {
                    int stepNumber = (Integer)etapa[0];
                    String nombreEtapa = (String)etapa[1];
                    String icono = (String)etapa[2];
                    SeguimientoPlazo seguimiento = getSeguimientoPorTipo(stepNumber, seguimientos);
                    String estado = seguimiento != null ? seguimiento.getEstado().toLowerCase().replace(" ", "-") : "pending";
                    String estadoClass = "pending";
                    
                    if (estado.equals("pendiente")) {
                        estadoClass = "pending";
                    } else if (estado.equals("en-proceso")) {
                        estadoClass = "en-proceso";
                    } else if (estado.equals("completado")) {
                        estadoClass = "completado";
                    } else if (estado.equals("retrasado")) {
                        estadoClass = "retrasado";
                    } else if (estado.equals("fallido")) {
                        estadoClass = "fallido";
                    }
                    
                    // Verificar si la etapa actual está habilitada (etapa anterior completada)
                    boolean etapaHabilitada = etapaAnteriorCompletada;
                    
                    // Actualizar para la siguiente iteración
                    if (seguimiento != null && "Completado".equalsIgnoreCase(seguimiento.getEstado())) {
                        etapaAnteriorCompletada = true;
                    } else {
                     etapaAnteriorCompletada = false;
                    }
                %>
                
                <div class="timeline-step <%= estadoClass %>-bg" id="etapa-<%= stepNumber %>">
                    <div class="step-icon <%= estadoClass %>" onclick="toggleDetalle(<%= stepNumber %>)">
                        <i class="fas <%= icono %>"></i>
                    </div>
                    <div class="step-content">
                        <div class="step-title" onclick="toggleDetalle(<%= stepNumber %>)" style="cursor: pointer;">
                            <span><%= nombreEtapa %></span>
                            <% if (seguimiento != null) { %>
                                <span class="step-status status-<%= estadoClass %>">
                                    <%= seguimiento.getEstado() %>
                                </span>
                            <% } else { %>
                                <span class="step-status status-pending">Pendiente</span>
                            <% } %>
                        </div>
                        
                        <div class="step-details" id="detalle-<%= stepNumber %>" style="display: none;">
                            <% if (seguimiento != null) { %>
                                <p><strong>Tipo:</strong> <%= seguimiento.getTipoNombre() %></p>
                                <p><strong>Fecha Programada:</strong> <%= seguimiento.getFechaProgramada() %></p>
                                <p><strong>Fecha Real:</strong> 
                                    <%= (seguimiento.getFechaReal() != null && !seguimiento.getFechaReal().isEmpty()) ? 
                                        seguimiento.getFechaReal() : "Pendiente" %>
                                </p>
                                <p><strong>Responsable:</strong> <%= seguimiento.getResponsable() %></p>
                                <% if (seguimiento.getObservaciones() != null && !seguimiento.getObservaciones().isEmpty()) { %>
                                    <p><strong>Observaciones:</strong> <%= seguimiento.getObservaciones() %></p>
                                <% } %>
                                
                                <button class="btn btn-primary edit-btn" 
                                onclick="openEditModal(<%= seguimiento.getIdSeguimiento() %>, '<%= seguimiento.getEstado() %>', '<%= seguimiento.getFechaReal() != null ? seguimiento.getFechaReal() : "" %>', '<%= seguimiento.getObservaciones() != null ? seguimiento.getObservaciones().replace("'", "\\'") : "" %>', event)">
                                <i class="fas fa-edit"></i> Editar
                                </button>
                            <% } else { %>
                                <p>No se ha registrado información para esta etapa.</p>
                                <a href="registrarSeguimiento.jsp?idImportacion=<%= importacion.getId_importacion() %>&tipo=<%= stepNumber %>" 
                                   class="btn btn-primary btn-sm <%= !etapaHabilitada ? "disabled" : "" %>"
                                   <%= !etapaHabilitada ? "onclick=\"alert('Debes completar la etapa anterior antes de registrar esta.'); return false;\"" : "" %>>
                                    <i class="fas fa-plus"></i> Registrar Seguimiento
                                </a>
                                <% if (!etapaHabilitada) { %>
                                    <p class="info-message">
                                        <i class="fas fa-info-circle"></i> Completa la etapa <%= stepNumber-1 %> para habilitar esta.
                                    </p>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
            
    <!-- Modal para editar el estado -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3>Editar Estado de la Etapa</h3>
            <form id="editForm" action="ActualizarSeguimientoServlet" method="POST">
                <input type="hidden" id="seguimientoId" name="seguimientoId">
                <input type="hidden" name="idImportacion" value="<%= importacion.getId_importacion() %>">
                
                <div class="form-group">
                    <label for="estado">Estado:</label>
                    <select id="estado" name="estado" class="form-control" required>
                        <option value="Pendiente">Pendiente</option>
                        <option value="En Proceso">En Proceso</option>
                        <option value="Completado">Completado</option>
                        <option value="Retrasado">Retrasado</option>
                        <option value="Fallido">Fallido</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="fechaReal">Fecha Real:</label>
                    <input type="date" id="fechaReal" name="fechaReal" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="observaciones">Observaciones:</label>
                    <textarea id="observaciones" name="observaciones" rows="3" class="form-control"></textarea>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Función para mostrar/ocultar los detalles de cada etapa
        function toggleDetalle(stepNumber) {
            var detalle = document.getElementById('detalle-' + stepNumber);
            detalle.style.display = detalle.style.display === 'none' ? 'block' : 'none';
        }
        
        // Funciones para el modal de edición - SIN VALIDACIÓN DE ETAPAS SIGUIENTES
        function openEditModal(id, estado, fechaReal, observaciones, event) {
            event.stopPropagation();
            event.preventDefault();
            
            document.getElementById('seguimientoId').value = id;
            document.getElementById('estado').value = estado;
            document.getElementById('fechaReal').value = fechaReal;
            document.getElementById('observaciones').value = observaciones ? observaciones : '';
            
            document.getElementById('editModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        // Cerrar modal al hacer clic fuera del contenido
        window.onclick = function(event) {
            var modal = document.getElementById('editModal');
            if (event.target == modal) {
                closeModal();
            }
        }
        
        // Mostrar automáticamente el primer paso con información
        window.onload = function() {
            document.querySelectorAll('.step-details').forEach(function(item) {
                item.style.display = 'none';
            });
            
            <% if (seguimientos != null && !seguimientos.isEmpty()) { %>
                <% 
                boolean found = false;
                for (Object[] etapa : etapas) { 
                    if (getSeguimientoPorTipo((Integer)etapa[0], seguimientos) != null && !found) { 
                        found = true;
                %>
                    document.getElementById('detalle-<%= etapa[0] %>').style.display = 'block';
                <% 
                    } 
                } 
                %>
            <% } %>
        };
    </script>
</body>
</html>