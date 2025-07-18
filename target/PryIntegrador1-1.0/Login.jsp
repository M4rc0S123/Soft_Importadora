<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <style>
        body {
            background-color: #f0f2f5;
            font-family: Arial, sans-serif;
        }
        .login-box {
            width: 350px;
            margin: 100px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 15px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007BFF;
            color: white;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <img src="img/logo.jpeg" alt="Logo Qathu" style="max-height: 150px; display: block; margin: 0 auto;">
        <h2>Iniciar Sesión</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error">${error}</p>
        <% } %>
        <form action="LoginServlet" method="POST">
            <input type="hidden" name="op" value="login">
            <label>Correo:</label>
            <input type="text" name="usuario" required>
            
            <label>Contraseña:</label>
            <input type="password" name="clave" required>
            
            <button type="submit">Ingresar</button>
        </form>
    </div>
</body>
</html>
