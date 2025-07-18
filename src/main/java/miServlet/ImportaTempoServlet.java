package miServlet;

import controller.ImportaControl;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.DetalleImporta;
import java.util.Date; // Asegúrate de importar java.util.Date


@WebServlet("/ImportaTempoServlet")
public class ImportaTempoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Asegurarse de que los caracteres especiales se decodifiquen correctamente
        request.setCharacterEncoding("UTF-8"); 
        response.setCharacterEncoding("UTF-8");

        String opcStr = request.getParameter("opc");
        int op = -1; // Valor por defecto inválido

        try {
            if (opcStr != null && !opcStr.trim().isEmpty()) {
                op = Integer.parseInt(opcStr);
            } else {
                // Si 'opc' es nulo o vacío, es un error, redirigir
                request.setAttribute("msg", "❌ Operación no especificada (parámetro 'opc' faltante).");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher("mensaje.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("msg", "❌ Valor de operación inválido (parámetro 'opc' no es un número).");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
            return;
        }

        if (op == 1) {
            agregarDetalleTemporal(request, response);
        } else if (op == 2) {
            procesarImportacion(request, response);
        } else if (op == 3) {
            limpiarDetallesTemporales(request, response);
        } else {
            request.setAttribute("msg", "❌ Operación no válida.");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
        }
    }

    protected void agregarDetalleTemporal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idProductoStr = request.getParameter("id_producto");
        String cantidadStr = request.getParameter("cantidad");
        String precioUnitarioStr = request.getParameter("precio_unitario");

        String errorMessage = null;

        int id_producto = 0;
        int cantidad = 0;
        double precio_unitario = 0.0;
        double subtotal = 0.0;

        try {
            if (idProductoStr == null || idProductoStr.trim().isEmpty()) {
                errorMessage = "ID de Producto es obligatorio.";
            } else {
                id_producto = Integer.parseInt(idProductoStr);
            }

            if (cantidadStr == null || cantidadStr.trim().isEmpty()) {
                errorMessage = "Cantidad es obligatoria.";
            } else {
                cantidad = Integer.parseInt(cantidadStr);
            }

            if (precioUnitarioStr == null || precioUnitarioStr.trim().isEmpty()) {
                errorMessage = "Precio Unitario es obligatorio.";
            } else {
                precio_unitario = Double.parseDouble(precioUnitarioStr);
            }

            if (errorMessage != null) { 
                 request.setAttribute("msg", "❌ Error al agregar detalle: " + errorMessage);
                 request.setAttribute("tipoMensaje", "error"); // Para el estilo en mensaje.jsp
                 request.getRequestDispatcher("mensaje.jsp").forward(request, response);
                 return;
            }

            subtotal = cantidad * precio_unitario;

        } catch (NumberFormatException e) {
            e.printStackTrace(); // Imprimir la pila de llamadas para depuración
            request.setAttribute("msg", "❌ Error al agregar detalle: Formato numérico inválido para ID Producto, Cantidad o Precio Unitario.");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        List<DetalleImporta> listaTemp = (List<DetalleImporta>) session.getAttribute("listaTemp");
        if (listaTemp == null) {
            listaTemp = new ArrayList<>();
        }

        DetalleImporta detalle = new DetalleImporta();
        detalle.setId_producto(id_producto);
        detalle.setCantidad(cantidad);
        detalle.setPrecio_unitario(precio_unitario);
        detalle.setSubtotal(subtotal);

        listaTemp.add(detalle);
        session.setAttribute("listaTemp", listaTemp);

        // Redirigir a la misma página para mostrar los detalles actualizados en la tabla
        request.getRequestDispatcher("nuevaImportacion.jsp").forward(request, response);
    }

    protected void procesarImportacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String codigo = request.getParameter("codigo_importacion");
        String fechaEmisionStr = request.getParameter("fecha_emision");
        String fechaEstimadaStr = request.getParameter("fecha_estimada_arribo");
        String estado = request.getParameter("estado");
        String idProveedorStr = request.getParameter("id_proveedor");
        String responsableStr = request.getParameter("responsable");

        Date fecha_emision = null;
        Date fecha_estimada = null; // Usamos java.util.Date aquí
        int id_proveedor = 0;
        int responsable = 0;

        // Definimos el formato de fecha que esperamos del HTML: dd/MM/yyyy
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        String errorMessage = null;

        // Validaciones de campos de cabecera obligatorios (antes de parsear)
        if (codigo == null || codigo.trim().isEmpty()) {
            errorMessage = "Código de Importación es obligatorio.";
        } else if (fechaEmisionStr == null || fechaEmisionStr.trim().isEmpty()) {
            errorMessage = "Fecha de Emisión es obligatoria.";
        } else if (fechaEstimadaStr == null || fechaEstimadaStr.trim().isEmpty()) {
            errorMessage = "Fecha Estimada de Arribo es obligatoria.";
        } else if (estado == null || estado.trim().isEmpty()) {
            errorMessage = "Estado es obligatorio.";
        } else if (idProveedorStr == null || idProveedorStr.trim().isEmpty()) {
            errorMessage = "Proveedor es obligatorio.";
        } else if (responsableStr == null || responsableStr.trim().isEmpty()) {
            errorMessage = "Responsable es obligatorio.";
        }

        if (errorMessage != null) {
            request.setAttribute("msg", "❌ " + errorMessage);
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
            return;
        }

        // Bloque try-catch para parsear fechas y números
        try {
            fecha_emision = sdf.parse(fechaEmisionStr);
            fecha_estimada = sdf.parse(fechaEstimadaStr);
            id_proveedor = Integer.parseInt(idProveedorStr);
            responsable = Integer.parseInt(responsableStr);
        } catch (ParseException e) {
            e.printStackTrace(); // Imprimir la pila de llamadas para depuración
            request.setAttribute("msg", "❌ Formato de fecha inválido. Utilice dd/MM/yyyy.");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
            return;
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Imprimir la pila de llamadas para depuración
            request.setAttribute("msg", "❌ Formato numérico inválido para ID de Proveedor o Responsable.");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        List<DetalleImporta> listaTemp = (List<DetalleImporta>) session.getAttribute("listaTemp");

        if (listaTemp == null || listaTemp.isEmpty()) {
            request.setAttribute("msg", "❌ No hay detalles de importación para registrar.");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
            return;
        }

        ImportaControl importaControl = new ImportaControl();
        int id_generado = importaControl.registrarImportacionConDetalles(
                codigo, fecha_emision, fecha_estimada, estado, id_proveedor, responsable, listaTemp
        );

        if (id_generado > 0) {
            session.removeAttribute("listaTemp"); // Limpiar la lista de detalles temporales de la sesión
            request.setAttribute("msg", "✅ Importación registrada con ID: " + id_generado);
            request.setAttribute("tipoMensaje", "success");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
        } else {
            request.setAttribute("msg", "❌ Error al registrar la importación. Intente de nuevo.");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("mensaje.jsp").forward(request, response);
        }
    }

    protected void limpiarDetallesTemporales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("listaTemp"); // Esto elimina la lista de la sesión

        // Redirige a la misma página para que se actualice y la tabla desaparezca
        request.getRequestDispatcher("nuevaImportacion.jsp").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
