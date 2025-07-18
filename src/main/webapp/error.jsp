<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .error-container { border: 1px solid #ff0000; padding: 20px; background-color: #ffeeee; }
        .error-message { color: #ff0000; font-weight: bold; }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Ha ocurrido un error</h1>
        <p class="error-message">${mensajeError}</p>
        <p>Detalles técnicos:</p>
        <pre>${pageContext.exception}</pre>
        <a href="principal.jsp">Volver a la página principal</a>
    </div>
</body>
</html>