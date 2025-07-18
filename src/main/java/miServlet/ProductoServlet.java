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
import model.Producto;
import controller.ProductoControl;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.servlet.RequestDispatcher;
import java.util.List;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

/**
 *
 * @author FAMILIA
 */
@WebServlet("/producto")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class ProductoServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "img";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "add":
                    agregarProducto(request, response);
                    break;
                case "edit":
                    cargarProductoParaEdicion(request, response);
                    break;
                case "update":
                    actualizarProducto(request, response);
                    break;
                case "delete":
                    eliminarProducto(request, response);
                    break;
                default:
                    listarProductos(request, response);
            }
        } else {
            listarProductos(request, response);
        }
    }

    private void agregarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String unidad = request.getParameter("unidad");
        String categoria = request.getParameter("categoria");

        // Procesar la imagen
        Part filePart = request.getPart("imagen");
        String fileName = null;
        String rutaImagen = null;

        if (filePart != null && filePart.getSize() > 0) {
            // Obtener el nombre del archivo
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Obtener la ruta de la aplicación
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

            // Crear el directorio si no existe
            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Guardar el archivo
            String filePath = uploadFilePath + File.separator + fileName;
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }

            // Ruta relativa para guardar en la base de datos
            rutaImagen = UPLOAD_DIR + "/" + fileName;
        }

        // Insertar en la base de datos
        ProductoControl control = new ProductoControl();
        control.AddProducto(nombre, descripcion, unidad, categoria, rutaImagen);

        // Redirigir a la lista de productos
        response.sendRedirect("producto");
    }

    private void listarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductoControl control = new ProductoControl();
        List<Producto> lista = control.listarProducto();
        request.setAttribute("productos", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("producto.jsp");
        dispatcher.forward(request, response);
    }

    // Agrega este método al ProductoServlet
    private void cargarProductoParaEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProductoControl control = new ProductoControl();
        Producto producto = control.obtenerProductoPorId(id);

        request.setAttribute("producto", producto);
        RequestDispatcher dispatcher = request.getRequestDispatcher("EditarProducto.jsp");
        dispatcher.forward(request, response);
    }

    private void actualizarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener ID y validar
            int id = Integer.parseInt(request.getParameter("id"));

            // Obtener datos del formulario
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String unidad = request.getParameter("unidad");
            String categoria = request.getParameter("categoria");

            // Obtener producto actual
            ProductoControl control = new ProductoControl();
            Producto productoActual = control.obtenerProductoPorId(id);

            if (productoActual == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Producto no encontrado");
                return;
            }

            // Manejo de la imagen
            String rutaImagen = productoActual.getRuta_imagen();
            Part filePart = request.getPart("imagen");

            if (filePart != null && filePart.getSize() > 0) {
                // Eliminar imagen anterior si existe
                if (rutaImagen != null && !rutaImagen.isEmpty()) {
                    String appPath = request.getServletContext().getRealPath("");
                    new File(appPath + rutaImagen).delete();
                }

                // Guardar nueva imagen
                String fileName = "prod_" + id + "_" + System.currentTimeMillis()
                        + filePart.getSubmittedFileName().substring(
                                filePart.getSubmittedFileName().lastIndexOf("."));

                String uploadPath = request.getServletContext().getRealPath("")
                        + File.separator + UPLOAD_DIR;

                Files.createDirectories(Paths.get(uploadPath));
                String filePath = uploadPath + File.separator + fileName;

                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath),
                            StandardCopyOption.REPLACE_EXISTING);
                }

                rutaImagen = UPLOAD_DIR + "/" + fileName;
            }

            // Actualizar en BD
            control.actualizarProducto(id, nombre, descripcion, unidad, categoria, rutaImagen);

            // Redirigir con mensaje de éxito
            request.getSession().setAttribute("mensaje", "Producto actualizado correctamente");
            response.sendRedirect("producto");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al actualizar producto");
            response.sendRedirect("producto");
        }
    }

    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductoControl control = new ProductoControl();

            // Opcional: Eliminar la imagen asociada si existe
            Producto producto = control.obtenerProductoPorId(id);
            if (producto != null && producto.getRuta_imagen() != null && !producto.getRuta_imagen().isEmpty()) {
                String appPath = request.getServletContext().getRealPath("");
                new File(appPath + producto.getRuta_imagen()).delete();
            }

            boolean eliminado = control.eliminarProducto(id);

            if (eliminado) {
                request.getSession().setAttribute("mensaje", "Producto eliminado correctamente");
            } else {
                request.getSession().setAttribute("error", "No se pudo eliminar el producto");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID inválido");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al eliminar producto");
        }

        response.sendRedirect("producto");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Eliminar todo el código de procesamiento anterior y dejar solo:
        processRequest(request, response);
    }
}