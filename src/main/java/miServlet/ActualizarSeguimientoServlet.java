/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.SeguimientoControl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.SeguimientoPlazo;

/**
 *
 * @author FAMILIA
 */

@WebServlet("/ActualizarSeguimientoServlet")
public class ActualizarSeguimientoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener parámetros del formulario
            int idSeguimiento = Integer.parseInt(request.getParameter("seguimientoId"));
            String estado = request.getParameter("estado");
            String fechaReal = request.getParameter("fechaReal");
            String observaciones = request.getParameter("observaciones");
            int idImportacion = Integer.parseInt(request.getParameter("idImportacion"));
            
            // Actualizar en la base de datos
            SeguimientoControl control = new SeguimientoControl();
            boolean actualizado = control.actualizarSeguimiento(idSeguimiento, estado, fechaReal, observaciones);
            
            if (actualizado) {
                response.sendRedirect("SeguimientoServlet?accion=ver&idImportacion=" + idImportacion);
            } else {
                response.sendRedirect("SeguimientoServlet?accion=ver&idImportacion=" + idImportacion + "&error=Error+al+actualizar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}