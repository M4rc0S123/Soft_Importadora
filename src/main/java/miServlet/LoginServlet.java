package miServlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import controller.LoginController;
import model.Empleado;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String op = request.getParameter("op");
        if ("login".equals(op)) {
            String usuario = request.getParameter("usuario");
            String clave = request.getParameter("clave");
            
            LoginController controller = new LoginController();
            Empleado emp = controller.validarUsuario(usuario, clave);
            
            if (emp != null && emp.isEstado()) {
                HttpSession session = request.getSession();
                session.setAttribute("empleado", emp);
                
                // Redirección por rol
                switch(emp.getRol().getId_rol()) {
                    case 1: // Admin
                        response.sendRedirect(request.getContextPath() +"/DashboardServlet");
                        break;
                    case 3: // Almacenero
                        response.sendRedirect(request.getContextPath() +"/DashboardServlet1");
                        break;
                    default:
                        request.setAttribute("error", "Rol no válido");
                        request.getRequestDispatcher("Login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Credenciales incorrectas");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }
        } else if ("logout".equals(op)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("Login.jsp");
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