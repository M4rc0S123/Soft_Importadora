package miServlet;

import controller.ProveeControl;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ProveeServlet extends HttpServlet {

    ProveeControl obj = new ProveeControl();
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int op = Integer.parseInt(request.getParameter("opc"));
        if(op==1)addProvee(request, response);
    }
    protected void addProvee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      String nom_empresa = request.getParameter("nom_empresa");
      String contacto = request.getParameter("contacto");
      String correo = request.getParameter("correo");
      String direccion = request.getParameter("direccion");
      String telefono = request.getParameter("telefono");
      String pais_origen = request.getParameter("pais_origen");
      obj.AddProvee(nom_empresa, contacto, correo, telefono, direccion, pais_origen);
      request.setAttribute("dato2", nom_empresa);
      String pag="/LisProvee.jsp";
      request.getRequestDispatcher(pag).forward(request, response);
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
