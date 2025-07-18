/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Rol;
import controller.RolControl;
import javax.servlet.RequestDispatcher;
import java.util.List;

/**
 *
 * @author FAMILIA
 */
@WebServlet("/rol")
public class RolServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        RolControl control = new RolControl();
        
        if("add".equals(action)) {
            // Procesar agregar empleado
            String nombre = request.getParameter("nombre");
            
            Rol rol = new Rol();
            rol.setNombre_rol(nombre);
            
            control.insertRol(rol);
            
            response.sendRedirect("rol");
            return;
        }
        else if("edit".equals(action)) {
            // Mostrar formulario de edición
            int id = Integer.parseInt(request.getParameter("id"));
            Rol rol = control.obtenerRolPorId(id);
            request.setAttribute("rol", rol);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ModificarRol.jsp");
            dispatcher.forward(request, response);
            return;
        }
        else if("update".equals(action)) {
            // Procesar actualización
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
        
            Rol rol = new Rol(id, nombre);
            
            control.actualizarRol(rol);
            
            response.sendRedirect("rol");
            return;
        }
        else if("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean eliminado = control.eliminarRol(id);
        
        if(eliminado) {
            request.setAttribute("mensaje", "Rol eliminado correctamente");
        } else {
            request.setAttribute("error", "No se pudo eliminar el rol");
        }
        
        // Redirigir a la lista actualizada
        response.sendRedirect("rol");
        return;
    }
        
        List<Rol> lista = control.listarRoles();
        request.setAttribute("roles", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Rol.jsp");
        dispatcher.forward(request, response);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}
