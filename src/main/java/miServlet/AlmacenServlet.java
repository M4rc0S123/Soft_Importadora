package miServlet;

import controller.AlmacenController;
import controller.ImportaControl;
import model.Almacen;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Importacion;

@WebServlet("/AlmacenServlet")
public class AlmacenServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Iniciando AlmacenServlet...");
        AlmacenController controller = new AlmacenController();
        String action = request.getParameter("action") != null ? request.getParameter("action") : "listar";
        System.out.println("Acción recibida: " + action);
        try {
            switch (action) {
                case "listar":
    System.out.println("Procesando acción 'listar'...");
    List<Almacen> almacenes = controller.listarAlmacenes();
    
    // Debug 1: Verifica la lista obtenida
    System.out.println("[DEBUG] Almacenes obtenidos del controlador: " + almacenes);
    if(almacenes != null) {
        System.out.println("[DEBUG] Cantidad: " + almacenes.size());
    }

    // Asegúrate de establecer el atributo
    request.setAttribute("almacenes", almacenes);
    
    // Debug 2: Verifica el atributo ANTES del forward
    System.out.println("[DEBUG] Atributo 'almacenes' en request: " + 
        request.getAttribute("almacenes"));

    // Hacer el forward
    RequestDispatcher rd = request.getRequestDispatcher("almacen.jsp");
    rd.forward(request, response);
    System.out.println("[DEBUG] Forward completado");
    return;
                    
                case "registrar":
                    if (request.getMethod().equals("POST")) {
                        Almacen nuevoAlmacen = new Almacen();
                        nuevoAlmacen.setIdImportacion(Integer.parseInt(request.getParameter("id_importacion")));
                        nuevoAlmacen.setFechaRecepcion(java.sql.Date.valueOf(request.getParameter("fecha_recepcion")));
                        nuevoAlmacen.setRecibidoPor(Integer.parseInt(request.getParameter("recibido_por")));
                        nuevoAlmacen.setObservaciones(request.getParameter("observaciones"));
                        nuevoAlmacen.setEstado(request.getParameter("estado"));
                        
                        if (controller.registrarAlmacen(nuevoAlmacen)) {
                            request.setAttribute("mensaje", "Almacén registrado con éxito");
                        } else {
                            request.setAttribute("error", "Error al registrar almacén");
                        }
                        response.sendRedirect("AlmacenServlet?action=listar");
                    }
                    break;
                    
                case "buscar":
                    int id = Integer.parseInt(request.getParameter("id"));
                    Almacen almacen = controller.buscarAlmacenPorId(id);
                    request.setAttribute("almacen", almacen);
                    request.getRequestDispatcher("editarAlmacen.jsp").forward(request, response);
                    break;
                    
                // En tu AlmacenServlet.java
case "nuevo":
    AlmacenController almacenController = new AlmacenController();
    List<Importacion> importaciones = almacenController.listarImportacionesParaAlmacen();
    request.setAttribute("importaciones", importaciones);
    request.getRequestDispatcher("formAlmacen.jsp").forward(request, response);
    break;
                    
                default:
                    response.sendRedirect("AlmacenServlet?action=listar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
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
