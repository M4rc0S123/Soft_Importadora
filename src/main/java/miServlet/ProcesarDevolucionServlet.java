/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.DevolucionControl;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.io.PrintWriter;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Devolucion;

@WebServlet("/ProcesarDevolucionServlet")
public class ProcesarDevolucionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            int idImportacion = Integer.parseInt(request.getParameter("idImportacion"));
            
            // Verificar si ya existe una devolución para esta importación
            DevolucionControl control = new DevolucionControl();
            if (control.existeDevolucionActivaParaImportacion(idImportacion)) {
            response.sendRedirect("registrarDevolucion.jsp?idImportacion=" + idImportacion + 
            "&error=Ya existe una devolución activa para esta importación");
            return;
            }
            
            String fechaDevolucionStr = request.getParameter("fechaDevolucion");
            String motivo = request.getParameter("motivo");
            String responsable = request.getParameter("responsable");
            String estado = request.getParameter("estado");
            
            // Convertir fecha
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date fechaDevolucionUtil = sdf.parse(fechaDevolucionStr);
            java.sql.Date fechaDevolucion = new java.sql.Date(fechaDevolucionUtil.getTime());
            
            // Crear objeto Devolucion
            Devolucion devolucion = new Devolucion();
            devolucion.setId_importacion(idImportacion);
            devolucion.setFecha_devolucion(fechaDevolucion);
            devolucion.setMotivo(motivo);
            devolucion.setResponsable(responsable);
            devolucion.setEstado(estado);
            
            // Guardar en la base de datos
           
            boolean exito = control.registrarDevolucion(devolucion);
            
            // Redireccionar según el resultado
            if (exito) {
                response.sendRedirect("buscarImportacion.jsp");
            } else {
                response.sendRedirect("error.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}