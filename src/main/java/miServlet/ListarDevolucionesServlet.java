/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.DevolucionControl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Devolucion;

/**
 *
 * @author FAMILIA
 */
@WebServlet("/ListarDevolucionesServlet")
public class ListarDevolucionesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        DevolucionControl control = new DevolucionControl();
        List<Devolucion> devoluciones = control.listarDevoluciones();
        
        request.setAttribute("devoluciones", devoluciones);
        request.getRequestDispatcher("listaDevoluciones.jsp").forward(request, response);
    }
}