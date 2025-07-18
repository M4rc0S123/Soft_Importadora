/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.ImportaControl;
import controller.SeguimientoControl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Importacion;
import model.SeguimientoPlazo;

@WebServlet("/SeguimientoServlet")
public class SeguimientoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        String idImportacionStr = request.getParameter("idImportacion");
        
        System.out.println("[DEBUG] Acción: " + accion + ", ID Importación: " + idImportacionStr);
        
        if (accion != null && idImportacionStr != null && accion.equals("ver")) {
            try {
                int idImportacion = Integer.parseInt(idImportacionStr);
                
                ImportaControl importaControl = new ImportaControl();
                Importacion importacion = importaControl.obtenerImportacionPorId(idImportacion);
                
                SeguimientoControl seguimientoControl = new SeguimientoControl();
                List<SeguimientoPlazo> seguimientos = seguimientoControl.obtenerSeguimientosPorImportacion(idImportacion);
                
                // Verificar y actualizar el estado si es necesario
            if (importacion != null && seguimientos != null && !seguimientos.isEmpty()) {
                String estadoActual = importacion.getEstado();
                String nuevoEstado = importaControl.determinarEstado(seguimientos);
                
                if (!estadoActual.equals(nuevoEstado)) {
                    importaControl.actualizarEstado(idImportacion, nuevoEstado);
                    importacion.setEstado(nuevoEstado); // Actualizar el objeto para la vista
                }
            }


                // Depuración
                System.out.println("[DEBUG] Importación obtenida: " + (importacion != null));
                System.out.println("[DEBUG] Número de seguimientos: " + (seguimientos != null ? seguimientos.size() : 0));
                
                request.setAttribute("importacion", importacion);
                request.setAttribute("seguimientos", seguimientos);
                
                request.getRequestDispatcher("estadoimpor.jsp").forward(request, response);
                
            } catch (NumberFormatException e) {
                System.out.println("[ERROR] ID de importación inválido: " + idImportacionStr);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de importación inválido");
            }
        } else {
            System.out.println("[ERROR] Parámetros faltantes");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros faltantes");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("[DEBUG] Entrando a doPost()");
        
        String accion = request.getParameter("accion");
        String idImportacionStr = request.getParameter("idImportacion");
        
        if (accion == null || idImportacionStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros faltantes");
            return;
        }
        
        if ("registrar".equals(accion)) {
            try {
                int idImportacion = Integer.parseInt(idImportacionStr);
                int idTipo = Integer.parseInt(request.getParameter("idTipo"));
                String fechaProgramada = request.getParameter("fechaProgramada");
                String fechaReal = request.getParameter("fechaReal");
                int responsable = Integer.parseInt(request.getParameter("responsable"));
                String observaciones = request.getParameter("observaciones");
                String estado = request.getParameter("estado");
                
                System.out.println("[DEBUG] Parámetros recibidos:");
                System.out.println("idImportacion: " + idImportacion);
                System.out.println("idTipo: " + idTipo);
                System.out.println("fechaProgramada: " + fechaProgramada);
                System.out.println("fechaReal: " + fechaReal);
                System.out.println("responsable: " + responsable);
                System.out.println("observaciones: " + observaciones);
                System.out.println("estado: " + estado);
                
                SeguimientoPlazo seguimiento = new SeguimientoPlazo();
                seguimiento.setIdImportacion(idImportacion);
                seguimiento.setIdTipoSeguimiento(idTipo);
                seguimiento.setFechaProgramada(fechaProgramada);
                seguimiento.setFechaReal(fechaReal == null || fechaReal.isEmpty() ? null : fechaReal);
                seguimiento.setResponsable(responsable);
                seguimiento.setObservaciones(observaciones == null || observaciones.isEmpty() ? null : observaciones);
                seguimiento.setEstado(estado);
                
                SeguimientoControl control = new SeguimientoControl();
                boolean registrado = control.registrarSeguimiento(seguimiento);
                
                String contextPath = request.getContextPath();
                if (registrado) {
                    System.out.println("[DEBUG] Registro exitoso, redirigiendo...");
                    response.sendRedirect(contextPath + "/SeguimientoServlet?accion=ver&idImportacion=" + idImportacion + "&mensaje=Registro+exitoso");
                } else {
                    System.out.println("[DEBUG] Error en registro, redirigiendo...");
                    response.sendRedirect(contextPath + "/registrarSeguimiento.jsp?idImportacion=" + idImportacion + "&error=Error+al+registrar");
                }
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
                String contextPath = request.getContextPath();
                response.sendRedirect(contextPath + "/registrarSeguimiento.jsp?error=Datos+inválidos&idImportacion=" + idImportacionStr);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
        }
    }
}