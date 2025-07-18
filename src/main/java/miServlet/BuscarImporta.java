/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package miServlet;

import controller.ImportaControl;
import model.Importacion;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class BuscarImporta extends HttpServlet {
    
     ImportaControl control = new ImportaControl();

       protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int op = Integer.parseInt(request.getParameter("opc"));

        if (op == 1) {
            buscarPorFecha(request, response);
        } else if (op == 2) {
            buscarPorId(request, response);
        }
    }

    protected void buscarPorFecha(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fechaStr = request.getParameter("fecha");

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date fechaUtil = sdf.parse(fechaStr); 
            
            java.sql.Date fechaSQL = new java.sql.Date(fechaUtil.getTime());

            List<Importacion> lista = control.obtenerImportacionesPorFecha(fechaSQL);

            request.setAttribute("listaImportaciones", lista);
            request.getRequestDispatcher("buscarImportaciones.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al buscar importaciones por fecha.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    protected void buscarPorId(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);

            Importacion imp = control.obtenerImportacionPorId(id);

            if (imp != null) {
                List <Importacion> list=new ArrayList <>();
                list.add(imp);
                request.setAttribute("importacion", list);
                
                request.getRequestDispatcher("buscarImportacion.jsp").forward(request, response);
            } else {
                request.setAttribute("mensaje", "No se encontró una importación con el ID proporcionado.");
                request.getRequestDispatcher("buscarImportacionesId.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al buscar importación por ID.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
