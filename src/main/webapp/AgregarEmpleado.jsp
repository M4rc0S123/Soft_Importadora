<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Adicionar Proveedor</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* --- ESTILOS GENERALES (BASE) --- */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Segoe UI', sans-serif;
                display: flex;
                background-color: #eef1f5; /* Un fondo general más suave */
                color: #333;
            }

            /* --- ESTILOS DEL MENÚ LATERAL (TAL CUAL LO TIENES, SOLO CON PEQUEÑOS AJUSTES PARA LA CONSISTENCIA VISUAL) --- */
            .sidebar {
                width: 220px;
                background-color: #003366; /* Azul oscuro */
                color: white;
                height: 100vh;
                position: fixed;
                display: flex;
                flex-direction: column;
                padding-top: 20px;
                box-shadow: 2px 0 5px rgba(0,0,0,0.1); /* Sombra suave para el menú */
            }
            .sidebar h2 {
                text-align: center;
                margin-bottom: 30px;
                font-size: 1.8em; /* Tamaño de fuente ligeramente ajustado */
                padding: 0 15px; /* Pequeño padding para no pegar al borde */
            }
            .sidebar a {
                padding: 12px 20px;
                text-decoration: none;
                color: white;
                display: block;
                transition: background 0.3s ease, padding-left 0.3s ease; /* Transición para el hover */
            }
            .sidebar a:hover {
                background-color: #0059b3; /* Azul más claro al pasar el ratón */
                padding-left: 25px; /* Efecto de "empuje" al pasar el ratón */
            }

            /* --- ESTILOS DEL CONTENIDO PRINCIPAL Y FORMULARIO --- */
            .main-content {
                margin-left: 220px; /* Offset del menú lateral */
                padding: 40px; /* Más padding para el contenido */
                flex-grow: 1;
                width: calc(100% - 220px); /* Asegura que no haya desbordamiento */
            }

            h2.text-cyan { /* El h2 del título del formulario */
                color: #003366; /* Un azul más oscuro para el título, haciendo juego con el menú */
                font-size: 2.5em; /* Título más grande y prominente */
                margin-bottom: 30px;
                border-bottom: 3px solid #0059b3; /* Una línea de separación más marcada */
                padding-bottom: 10px;
                display: inline-block; /* Para que la línea solo ocupe el ancho del texto */
                line-height: 1.2;
            }

            /* Contenedor del formulario - Tarjeta */
            form {
                background-color: #ffffff; /* Fondo blanco */
                padding: 35px; /* Más padding interno */
                border-radius: 12px; /* Bordes más redondeados */
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15); /* Sombra más grande y definida */
                max-width: 650px; /* Ancho máximo del formulario */
                margin: 30px auto 0 auto; /* Margen superior y centrado */
                display: flex; /* Para organizar los form-group */
                flex-wrap: wrap; /* Permite que los elementos se envuelvan */
                gap: 25px; /* Espacio entre los form-group */
            }

            .form-group {
                flex: 1 1 calc(50% - 12.5px); /* Dos columnas, con espacio entre ellas */
                min-width: 280px; /* Ancho mínimo para evitar que se aplasten */
                margin-bottom: 0; /* Ya tenemos gap en el padre */
            }
            /* Último form-group (botones) ocupa el ancho completo */
            .form-group:last-of-type {
                flex: 1 1 100%;
                margin-top: 15px; /* Espacio extra antes de los botones */
                text-align: right; /* Alinea los botones a la derecha */
            }


            .form-group label {
                display: block;
                margin-bottom: 8px; /* Espacio entre etiqueta y campo */
                font-weight: 600; /* Texto más grueso */
                color: #444; /* Color de texto ligeramente más oscuro */
                font-size: 1.05em; /* Tamaño de fuente ligeramente más grande */
            }

            .form-control {
                width: 100%;
                padding: 12px 18px; /* Más padding para los inputs */
                border: 1px solid #d0d0d0; /* Borde más sutil */
                border-radius: 8px; /* Bordes redondeados */
                font-size: 1em;
                color: #555;
                background-color: #fcfcfc; /* Fondo ligeramente diferente para los inputs */
                transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Transiciones suaves */
                box-shadow: inset 0 1px 4px rgba(0, 0, 0, 0.06); /* Sombra interna sutil */
            }

            .form-control::placeholder {
                color: #a0a0a0; /* Color del placeholder */
            }

            .form-control:focus {
                border-color: #007bff; /* Borde azul brillante al enfocar */
                box-shadow: 0 0 0 4px rgba(0, 123, 255, 0.2); /* Sombra de enfoque más suave */
                outline: none; /* Eliminar el contorno predeterminado del navegador */
                background-color: #ffffff; /* Fondo blanco al enfocar */
            }

            /* Estilos de botones */
            .btn {
                padding: 12px 28px; /* Más padding para los botones */
                border: none;
                border-radius: 8px; /* Bordes bien redondeados */
                cursor: pointer;
                font-size: 1.05em; /* Tamaño de fuente del botón */
                font-weight: 600;
                letter-spacing: 0.5px; /* Espaciado entre letras */
                transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
                min-width: 120px; /* Ancho mínimo para consistencia */
            }

            .btn-primary {
                background-color: #007bff; /* Azul vibrante */
                color: white;
                box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3); /* Sombra para el botón primario */
            }

            .btn-primary:hover {
                background-color: #0056b3; /* Azul más oscuro al pasar el ratón */
                transform: translateY(-3px); /* Efecto de "levantamiento" */
                box-shadow: 0 6px 15px rgba(0, 123, 255, 0.4); /* Sombra más grande al pasar el ratón */
            }
            .btn-primary:active {
                transform: translateY(0); /* Vuelve a la posición original al hacer click */
                box-shadow: 0 2px 5px rgba(0, 123, 255, 0.2);
            }


            .btn-danger {
                background-color: #dc3545; /* Rojo de peligro */
                color: white;
                margin-left: 15px; /* Espacio entre el botón primario y el de peligro */
                box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3); /* Sombra para el botón de peligro */
            }

            .btn-danger:hover {
                background-color: #c82333; /* Rojo más oscuro al pasar el ratón */
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(220, 53, 69, 0.4);
            }
            .btn-danger:active {
                transform: translateY(0);
                box-shadow: 0 2px 5px rgba(220, 53, 69, 0.2);
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2>Menú</h2>
            <a href="DashboardServlet">Principal</a>
            <a href="rol">Roles</a>
            <a href="empleado">Empleados</a>
            <a href="LisProvee.jsp">Proveedores</a>
            <a href="producto">Productos</a>
            <a href="buscarImportacion.jsp">Importaciones</a>
            <a href="AlmacenServlet">Almacenes</a>
            <a href="ListarDevolucionesServlet">Devoluciones</a>
        </div>
        <div class="main-content">
        <h2 class="text-cyan">Registro De Empleados</h2>
        <form action="empleado?action=add" method="post" id="id_form">
                <div class="form-group">
                    <label for="nombre">Nombre</label>
                    <input class="form-control" type="text" id="nombre" name="nombre" 
                           placeholder="Ingrese nombre del empleado" required>
                </div>
                <div class="form-group">
                    <label for="apellido">Apellido</label>
                    <input class="form-control" type="text" id="apellido" name="apellido" 
                           placeholder="Ingrese apellido del empleado" required>
                </div>
                <div class="form-group">
                    <label for="correo">Correo</label>
                    <input class="form-control" type="email" id="correo" name="correo" 
                           placeholder="Ingrese el correo" required>
                </div>
                <div class="form-group">
                    <label for="rol">Rol</label>
                    <select class="form-control" name="rol" id="rol" required>
                        <option value="">Seleccionar rol de Empleado</option>
                        <option value="1">Administrador</option>
                        <option value="2">Usuario</option>
                    </select>
                </div>       
                <div class="form-group">
                    <label for="contrasena">Contraseña</label>
                    <input class="form-control" type="password" id="contrasena" name="contrasena" 
                           placeholder="Ingrese la contraseña" required minlength="6">
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Agregar Empleado</button>
                    <button type="button" class="btn btn-danger" 
                            onclick="window.location.href='empleado'">Cancelar</button>
                </div>
            </form>
        </div>
        
        <script>
            // Validación adicional del lado del cliente
            document.getElementById('id_form').addEventListener('submit', function(e) {
                const correo = document.getElementById('correo').value;
                if (!correo.includes('@')) {
                    alert('Por favor ingrese un correo electrónico válido');
                    e.preventDefault();
                }
                
                const contrasena = document.getElementById('contrasena').value;
                if (contrasena.length < 6) {
                    alert('La contraseña debe tener al menos 6 caracteres');
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>
