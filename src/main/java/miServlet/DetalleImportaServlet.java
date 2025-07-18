package miServlet; // Asegúrate de que este sea el paquete correcto para tu Servlet

import controller.DetalleImportaControl;
import controller.ImportaControl; // Necesitas este import para el DAO de Importacion
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // Importa esta anotación si aún no la tienes
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DetalleImporta;
import model.Importacion; // Necesitas este import para la clase de modelo Importacion

@WebServlet("/DetalleImportaServlet") // Asegúrate de que esta URL coincida con el enlace
public class DetalleImportaServlet extends HttpServlet {

    // Instancias de tus controladores (DAOs)
    DetalleImportaControl detalleControl = new DetalleImportaControl();
    ImportaControl importaControl = new ImportaControl(); // Instancia del DAO de Importación

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        System.out.println("=== INICIO DE DETALLE IMPORTACION SERVLET ===");
        
        String idImportacionStr = request.getParameter("id_importacion");
        System.out.println("ID Importación recibido: " + idImportacionStr);

        if (idImportacionStr == null || idImportacionStr.trim().isEmpty()) {
            System.out.println("Error: ID de importación no proporcionado");
            request.setAttribute("mensajeError", "El ID de la importación no fue proporcionado.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        int idImportacion;
        try {
            idImportacion = Integer.parseInt(idImportacionStr);
            System.out.println("ID Importación convertido a int: " + idImportacion);
        } catch (NumberFormatException e) {
            System.out.println("Error: ID no es un número válido");
            request.setAttribute("mensajeError", "ID de importación no válido: " + idImportacionStr);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Obtener datos
        System.out.println("Buscando importación en la base de datos...");
        Importacion importacion = importaControl.obtenerImportacionPorId(idImportacion);
        System.out.println("Importación encontrada: " + (importacion != null ? "Sí" : "No"));

        System.out.println("Buscando detalles de importación...");
        List<DetalleImporta> listaDetalles = detalleControl.listaDetallePorImportacion(idImportacion);
        System.out.println("Número de detalles encontrados: " + (listaDetalles != null ? listaDetalles.size() : 0));

        if (importacion == null) {
            System.out.println("Error: Importación no encontrada en BD");
            request.setAttribute("mensajeError", "Importación con ID " + idImportacion + " no encontrada.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("importacion", importacion);
        request.setAttribute("listaDetalles", listaDetalles);
        
        System.out.println("Redirigiendo a detalleImportacion.jsp");
        request.getRequestDispatcher("detalleImportacion.jsp").forward(request, response);
        
    } catch (Exception e) {
        System.out.println("=== ERROR EN EL SERVLET ===");
        e.printStackTrace();
        request.setAttribute("mensajeError", "Error grave: " + e.getMessage());
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    processRequest(request, response); // Llama al mismo método que doPost()
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    processRequest(request, response);
}
}