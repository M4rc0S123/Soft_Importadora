
package miServlet;

import controller.ImportaControl;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Importacion;

public class Importa extends HttpServlet {

     ImportaControl control = new ImportaControl();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int op = Integer.parseInt(request.getParameter("opc"));
        if (op == 1) {
            guardarImportacion(request, response);
        }
    }

    protected void guardarImportacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String codigo = request.getParameter("codigo");
            String fechaEmisionStr = request.getParameter("fecha_emision");
            String fechaEstimadaStr = request.getParameter("fecha_estimada_arribo");
            String fechaRealStr = request.getParameter("fecha_real_arribo");
            String estado = request.getParameter("estado");
            int proveedorId = Integer.parseInt(request.getParameter("id_proveedor"));
            int responsable = Integer.parseInt(request.getParameter("responsable"));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaEmision = sdf.parse(fechaEmisionStr);
            Date fechaEstimada = sdf.parse(fechaEstimadaStr);
            Date fechaReal = sdf.parse(fechaRealStr);

            Importacion imp = new Importacion();
            imp.setCodigo_importacion(codigo);
            imp.setFecha_emision(fechaEmision);
            imp.setFecha_estimada_arribo(fechaEstimada);
            imp.setFecha_real_arribo(fechaReal);
            imp.setEstado(estado);
            imp.setId_proveedor(proveedorId);
            imp.setResponsable(responsable);

           

            response.sendRedirect("mensaje.jsp?msg=Importación registrada con éxito");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al registrar la importación.");
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
