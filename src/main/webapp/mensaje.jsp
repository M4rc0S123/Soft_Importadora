<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Mensaje de la Aplicación</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; color: #333; }
        .container { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); max-width: 600px; margin: 50px auto; text-align: center; }
        .success { color: #28a745; font-weight: bold; font-size: 1.2em; }
        .error { color: #dc3545; font-weight: bold; font-size: 1.2em; }
        h1 { color: #0056b3; }
        a { display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; transition: background-color 0.3s ease; }
        a:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Resultado de la Operación</h1>
        <%
            String mensaje = (String) request.getAttribute("msg"); // Usamos "msg" ya que es el atributo que envías
            String tipoMensaje = (String) request.getAttribute("tipoMensaje"); // Para estilos

            if (mensaje != null) {
                if ("success".equals(tipoMensaje)) {
                    out.println("<p class='success'>" + mensaje + "</p>");
                } else if ("error".equals(tipoMensaje)) {
                    out.println("<p class='error'>" + mensaje + "</p>");
                } else {
                    out.println("<p>" + mensaje + "</p>"); // Mensaje sin tipo definido
                }
            } else {
                out.println("<p>No se recibió ningún mensaje.</p>");
            }
        %>
        <br>
        <a href="javascript:history.back()">Volver a la página anterior</a>
        </div>
</body>
</html>