/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.ImportaControl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Importacion;

/**
 *
 * @author FAMILIA
 */
@WebServlet("/ListarImportaciones1")
public class ImportacionesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ImportaControl control = new ImportaControl();
        List<Importacion> importaciones = control.obtenerTodasLasImportaciones();
        request.setAttribute("importacion", importaciones);
        request.getRequestDispatcher("buscarImportacion1.jsp").forward(request, response);
    }
}
