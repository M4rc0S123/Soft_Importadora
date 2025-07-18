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
import model.Importacion;
import model.SeguimientoPlazo;
import controller.ImportaControl;
import controller.SeguimientoControl;
import java.io.IOException;
import java.util.List;

@WebServlet("/GenerarReporteServlet")
public class GenerarReporteServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tipo = request.getParameter("tipo");
        int idImportacion = Integer.parseInt(request.getParameter("id"));
        
        // Usamos los controladores existentes
        ImportaControl importacionCtrl = new ImportaControl();
        SeguimientoControl seguimientoCtrl = new SeguimientoControl();
        
        // Obtener datos usando los métodos existentes en tus controladores
        Importacion importacion = importacionCtrl.obtenerImportacionPorId(idImportacion);
        List<SeguimientoPlazo> seguimientos = seguimientoCtrl.obtenerSeguimientosPorImportacion(idImportacion);
        
        // Depuración
        System.out.println("[DEBUG] Importación obtenida: " + (importacion != null ? importacion.getCodigo_importacion() : "null"));
        System.out.println("[DEBUG] Total seguimientos: " + (seguimientos != null ? seguimientos.size() : "0"));
        
        request.setAttribute("seguimientos", seguimientos);
        request.setAttribute("importacion", importacion);
        
        // Redirección según tipo de reporte
        String destino;
        if ("excel".equals(tipo)) {
            destino = "reporteExcel.jsp";
        } else if ("pdf".equals(tipo)) {
            destino = "reportePdf.jsp";
        } else {
            request.setAttribute("error", "Tipo de reporte no válido");
            destino = "error.jsp";
        }
        
        request.getRequestDispatcher(destino).forward(request, response);
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