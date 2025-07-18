/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.DevolucionControl;
import model.Devolucion;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author FAMILIA
 */
@WebServlet("/EditarDevolucionServlet")
public class EditarDevolucionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int idDevolucion = Integer.parseInt(request.getParameter("id"));
            
            DevolucionControl control = new DevolucionControl();
            Devolucion devolucion = control.obtenerDevolucionPorId(idDevolucion);
            
            if (devolucion != null) {
                request.setAttribute("devolucion", devolucion);
                request.getRequestDispatcher("editarDevolucion.jsp").forward(request, response);
            } else {
                response.sendRedirect("ListarDevolucionesServlet?error=Devolución no encontrada");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ListarDevolucionesServlet?error=Error al cargar devolución");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int idDevolucion = Integer.parseInt(request.getParameter("idDevolucion"));
            String nuevoEstado = request.getParameter("estado");
            
            DevolucionControl control = new DevolucionControl();
            boolean exito = control.actualizarEstadoDevolucion(idDevolucion, nuevoEstado);
            
            if (exito) {
                response.sendRedirect("ListarDevolucionesServlet?success=Estado actualizado correctamente");
            } else {
                response.sendRedirect("ListarDevolucionesServlet?error=Error al actualizar estado");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ListarDevolucionesServlet?error=Error en el servidor");
        }
    }
}