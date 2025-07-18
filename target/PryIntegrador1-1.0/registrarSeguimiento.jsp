<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.SeguimientoControl" %>
<%
String idImportacionStr = request.getParameter("idImportacion");
String tipoParam = request.getParameter("tipo");
int idImportacion = 0;
int tipo = 0;

if (idImportacionStr != null && !idImportacionStr.isEmpty()) {
    idImportacion = Integer.parseInt(idImportacionStr);
}

if (tipoParam != null && !tipoParam.isEmpty()) {
    tipo = Integer.parseInt(tipoParam);
}

// Validar etapa anterior si se está registrando una etapa específica
boolean etapaAnteriorValida = true;
String errorEtapa = null;

if (tipo > 1) { // No validar para la primera etapa
    SeguimientoControl control = new SeguimientoControl();
    etapaAnteriorValida = control.verificarEtapaAnteriorCompletada(tipo, idImportacion);
    
    if (!etapaAnteriorValida) {
        errorEtapa = "No puedes registrar la etapa " + tipo + " hasta completar la etapa " + (tipo-1);
    }
}

String nombreTipo = "";
switch(tipo) {
    case 1: nombreTipo = "Proveedor"; break;
    case 2: nombreTipo = "Embarque"; break;
    case 3: nombreTipo = "Puerto Destino"; break;
    case 4: nombreTipo = "Agente Aduanal"; break;
    case 5: nombreTipo = "Aduana"; break;
    case 6: nombreTipo = "Transporte"; break;
    case 7: nombreTipo = "Almacén"; break;
    default: nombreTipo = "Documentación";
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrar Seguimiento</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            background-color: #f2f2f2;
        }
        form {
            background-color: white;
            padding: 25px;
            border-radius: 10px;
            width: 500px;
            margin: auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        label {
            font-weight: bold;
        }
        button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        a {
            display: inline-block;
            margin-top: 15px;
            color: #007bff;
            text-decoration: none;
        }
        .tipo-seleccionado {
            background-color: #e8f5e9;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border-left: 4px solid #28a745;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info-message {
            font-size: 14px;
            color: #666;
            margin-top: -10px;
            margin-bottom: 15px;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <form action="SeguimientoServlet" method="post" <%= !etapaAnteriorValida ? "onsubmit=\"alert('No se puede registrar esta etapa porque la anterior no está completada.'); return false;\"" : "" %>>
        <h2><i class="fas fa-calendar-check"></i> Registrar Seguimiento</h2>
        
        <% if (errorEtapa != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> <%= errorEtapa %>
            </div>
        <% } %>
        
        <input type="hidden" name="accion" value="registrar">
        <input type="hidden" name="idImportacion" value="<%= idImportacion %>">
        
        <% if (tipoParam != null && !tipoParam.isEmpty()) { %>
            <div class="tipo-seleccionado">
                <strong><i class="fas fa-tag"></i> Tipo de Seguimiento seleccionado:</strong> <%= nombreTipo %>
                <input type="hidden" name="idTipo" value="<%= tipo %>">
                <% if (tipo > 1 && !etapaAnteriorValida) { %>
                    <p class="info-message">
                        <i class="fas fa-info-circle"></i> Debes completar la etapa anterior antes de registrar esta etapa.
                    </p>
                <% } %>
            </div>
        <% } else { %>
            <label><i class="fas fa-tags"></i> Tipo de Seguimiento:</label>
            <select name="idTipo" required>
                <option value="">-- Seleccione un tipo --</option>
                <option value="1">Proveedor</option>
                <option value="2">Embarque</option>
                <option value="3">Puerto Destino</option>
                <option value="4">Agente Aduanal</option>
                <option value="5">Aduana</option>
                <option value="6">Transporte</option>
                <option value="7">Almacén</option>
            </select>
        <% } %>

        <label><i class="far fa-calendar-alt"></i> Fecha Programada:</label>
        <input type="date" name="fechaProgramada" required>
        
        <label><i class="fas fa-calendar-day"></i> Fecha Real:</label>
        <input type="date" name="fechaReal">
        
        <label><i class="fas fa-user-tie"></i> Responsable (ID):</label>
        <input type="number" name="responsable" required min="1">
        
        <label><i class="fas fa-comment-alt"></i> Observaciones:</label>
        <textarea name="observaciones" rows="4" placeholder="Ingrese observaciones relevantes..."></textarea>
        
        <label><i class="fas fa-info-circle"></i> Estado:</label>
        <select name="estado" required>
            <option value="Pendiente" selected>Pendiente</option>
            <option value="En Proceso">En Proceso</option>
            <option value="Completado">Completado</option>
            <option value="Retrasado">Retrasado</option>
            <option value="Fallido">Fallido</option>
        </select>
        
        <div style="display: flex; justify-content: space-between; margin-top: 20px;">
            <button type="submit" <%= !etapaAnteriorValida && tipoParam != null ? "disabled" : "" %>>
                <i class="fas fa-save"></i> Guardar Seguimiento
            </button>
            <a href="SeguimientoServlet?accion=ver&idImportacion=<%= idImportacion %>" style="margin-top: 0;">
                <i class="fas fa-arrow-left"></i> Volver al Seguimiento
            </a>
        </div>
    </form>
    
    <script>
        // Validación básica del formulario
        document.querySelector('form').addEventListener('submit', function(e) {
            let fechaProgramada = document.querySelector('input[name="fechaProgramada"]').value;
            let fechaReal = document.querySelector('input[name="fechaReal"]').value;
            
            if (fechaReal && new Date(fechaReal) < new Date(fechaProgramada)) {
                if (!confirm('La fecha real es anterior a la fecha programada. ¿Desea continuar?')) {
                    e.preventDefault();
                }
            }
        });
        
        // Establecer fecha mínima para fecha real
        document.querySelector('input[name="fechaProgramada"]').addEventListener('change', function() {
            let fechaRealInput = document.querySelector('input[name="fechaReal"]');
            fechaRealInput.min = this.value;
        });
    </script>
</body>
</html>