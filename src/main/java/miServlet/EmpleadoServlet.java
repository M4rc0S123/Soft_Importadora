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
import model.Empleado;
import model.Rol;
import controller.EmpleadoControl;
import javax.servlet.RequestDispatcher;
import java.util.List;

/**
 *
 * @author FAMILIA
 */
@WebServlet("/empleado")
public class EmpleadoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        EmpleadoControl control = new EmpleadoControl();
        
        if("add".equals(action)) {
            // Procesar agregar empleado
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String correo = request.getParameter("correo");
            String contrasena = request.getParameter("contrasena");
            
            int idRol = Integer.parseInt(request.getParameter("rol"));
            Rol rol = new Rol(idRol, ""); // Solo necesitamos el ID para insertar
            
            Empleado emp = new Empleado();
            emp.setNombre(nombre);
            emp.setApellido(apellido);
            emp.setCorreo(correo);
            emp.setContrasena(contrasena);
            emp.setEstado(true); // Por defecto activo
            emp.setRol(rol);
            
            control.insertEmpleado(emp);
            
            response.sendRedirect("empleado");
            return;
        }
        else if("edit".equals(action)) {
            // Mostrar formulario de edición
            int id = Integer.parseInt(request.getParameter("id"));
            Empleado emp = control.obtenerEmpleadoPorId(id);
            request.setAttribute("empleado", emp);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ModificarEmpleado.jsp");
            dispatcher.forward(request, response);
            return;
        }
        else if("update".equals(action)) {
            // Procesar actualización
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String correo = request.getParameter("correo");
            boolean estado = Boolean.parseBoolean(request.getParameter("estado"));
            int idRol = Integer.parseInt(request.getParameter("rol"));
            
            Rol rol = new Rol(idRol, "");
            Empleado emp = new Empleado(id, nombre, apellido, correo, estado, rol);
            
            control.actualizarEmpleado(emp);
            
            response.sendRedirect("empleado");
            return;
        }
        else if("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean eliminado = control.eliminarEmpleado(id);
        
        if(eliminado) {
            request.setAttribute("mensaje", "Empleado eliminado correctamente");
        } else {
            request.setAttribute("error", "No se pudo eliminar el empleado");
        }
        
        // Redirigir a la lista actualizada
        response.sendRedirect("empleado");
        return;
    }
        
        // Listar empleados (para GET o cuando no hay acción específica)
        List<Empleado> lista = control.listarEmpleados();
        request.setAttribute("empleados", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Empleado.jsp");
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

